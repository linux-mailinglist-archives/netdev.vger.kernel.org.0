Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D696D31D553
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 07:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhBQGRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 01:17:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37054 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhBQGRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 01:17:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11H6E0IL062096;
        Wed, 17 Feb 2021 06:16:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=Wn1VOMBIKISTPNKF3/vZW5/DWUU87cwkCHxW1HtNg7A=;
 b=nH1qJST5/Wy3/1GNs6ceh2rqXG4RT7OaLsbbZHuYuk2lkm54OYTqucISeaXLUHMPMlrm
 AzF1BsqFZX2pTNo8J9qSDEtw5Lmb6mfgc4O6ivGO0Xkn6qZRX0kfm97qNamF7f9JuqpP
 Xi2q2esh+F+e2lEnIwcedij2jnTC2XW5GrTCOUSUlyYlAoSGaInMUssS5PpyMVe0fdqs
 YKgtyP/u4l8qI4hpEOA7hd561/MkBWoYKDUc0ZMsPKO2qEJGKH/nAAVPM89OIiqZEjfv
 oQZbqv/s7dQcH/lm2Vd2w82+q2cGCdG/doi+CoZorUEEXnygS1qO9dkmGTvWmMqYL5XE kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36pd9a8p4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 06:16:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11H6GAxZ047057;
        Wed, 17 Feb 2021 06:16:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 36prnyuhdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 06:16:30 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 11H6GS0B023334;
        Wed, 17 Feb 2021 06:16:29 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Feb 2021 22:16:28 -0800
Date:   Wed, 17 Feb 2021 09:16:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sunil Goutham <sgoutham@marvell.com>
Cc:     Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] cteontx2-pf: cn10k: Prevent harmless double shift
 bugs
Message-ID: <YCy0tPmgaHL1U2Le@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170047
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170047
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These defines are used with set_bit() and test_bit() which take a bit
number.  In other words, the code is doing:

	if (BIT(BIT(1)) & pf->hw.cap_flag) {

This was done consistently so it did not cause a problem at runtime but
it's still worth fixing.

Fixes: facede8209ef ("octeontx2-pf: cn10k: Add mbox support for CN10K")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 4c472646a0ac..19aef37b8ef9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -210,9 +210,9 @@ struct otx2_hw {
 	u64			cgx_fec_uncorr_blks;
 	u8			cgx_links;  /* No. of CGX links present in HW */
 	u8			lbk_links;  /* No. of LBK links present in HW */
-#define HW_TSO			BIT_ULL(0)
-#define CN10K_MBOX		BIT_ULL(1)
-#define CN10K_LMTST		BIT_ULL(2)
+#define HW_TSO			0
+#define CN10K_MBOX		1
+#define CN10K_LMTST		2
 	unsigned long		cap_flag;
 
 #define LMT_LINE_SIZE		128
-- 
2.30.0

