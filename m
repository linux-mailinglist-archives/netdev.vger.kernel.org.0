Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AB332B381
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352683AbhCCEAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:00:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48398 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344675AbhCBLZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 06:25:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 122BKHsY052110;
        Tue, 2 Mar 2021 11:22:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=pdMfwbpSJC/Cr8zv0g4CbItRgCRo74rSKxb5p0B61JA=;
 b=VRbpLkTujaxzggxWvbD6+QT2rAHbqQA6xifgXw0NEitKJvuXMEPatNkTN2t5BBLClIZs
 C7BiL/Xt+f2sQ+t2Ge0LPDickhX5PWbnN3xOWeAmNybVO949p7VTBAMVUf3tg6AFxE1F
 NnuS7vQbdtdH7yH/eM3CjtBqBY7rhaKz+fmBLY6qi/DQAABCV4+KOYjPaNDp3Y3jcxqf
 VxD5mW4Y9XGvCsFIxFpg+TOEQisYBdgDI/tFUYmKWwMv7iMsPbd9oesKpQmg2FEcf9SS
 EG8+FlpaUV4MTgFYbj2t1KHmrDeavVF/t4b0X4DcjCwxrgXG0cj1JgVYwuL18AxM1pVA mQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36ye1m769t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 11:22:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 122BKwjm032067;
        Tue, 2 Mar 2021 11:22:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 36yynp0p3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 11:22:05 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 122BM3u3008266;
        Tue, 2 Mar 2021 11:22:03 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Mar 2021 11:22:03 +0000
Date:   Tue, 2 Mar 2021 14:21:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        hariprasad <hkelam@marvell.com>
Cc:     Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] octeontx2-af: cn10k: fix an array overflow in
 is_lmac_valid()
Message-ID: <YD4f0vIQ1bW++7M7@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020095
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0
 mlxscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020095
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value of "lmac_id" can be controlled by the user and if it is larger
then the number of bits in long then it reads outside the bitmap.
The highest valid value is less than MAX_LMAC_PER_CGX (4).

Fixes: 91c6945ea1f9 ("octeontx2-af: cn10k: Add RPM MAC support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 9caa375d01b1..68deae529bc9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -56,7 +56,9 @@ static bool is_dev_rpm(void *cgxd)
 
 bool is_lmac_valid(struct cgx *cgx, int lmac_id)
 {
-	return cgx && test_bit(lmac_id, &cgx->lmac_bmap);
+	if (!cgx || lmac_id < 0 || lmac_id >= MAX_LMAC_PER_CGX)
+		return false;
+	return test_bit(lmac_id, &cgx->lmac_bmap);
 }
 
 struct mac_ops *get_mac_ops(void *cgxd)
-- 
2.30.1

