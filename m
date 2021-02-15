Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C8231BE45
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 17:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbhBOQE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 11:04:56 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41018 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbhBOP56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 10:57:58 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11FFo1OB096860;
        Mon, 15 Feb 2021 15:56:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=7tkxxlsreJWA6Ek4x6TAxcN7G53TF9KpDfP9FbpoT20=;
 b=dSu2nTZcqhfzvUBdp7OQ4PQ+AwZ1JQe9x630UVNIJg1Or9xo/GBWMV1fMJ0TdfhV/TTY
 4uTeFYajN0JLKkJXwHDInABZerIK1TPR9pbbG9ckCqHXKKbMEEBIIUh/BBU5UbEIynek
 j5Va2Mkp0PJDMcpc+7ljHCGePDenDj/J1gOdIhQ+it9CKBiYgkC+M5tbjrCtO1EEjKbc
 bhv4hZwwvAGzsZwxQUObdKlOn4xsuW/Kq4L0DNIKtEjqBd8fL7KzGPcpSw0XmXfwz4Eb
 A+jgX2qAqP0q1X/W+z3JrfnH572t0b4wGEFqB2uCIpPC03KB8oo9DYApGHIj0ke4Gx/7 wA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36pd9a3wu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Feb 2021 15:56:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11FFoHXf028575;
        Mon, 15 Feb 2021 15:56:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 36prbm79xs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Feb 2021 15:56:57 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 11FFut56009901;
        Mon, 15 Feb 2021 15:56:56 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Feb 2021 07:56:55 -0800
Date:   Mon, 15 Feb 2021 18:56:46 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Christina Jacob <cjacob@marvell.com>
Cc:     Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] octeontx2-pf: fix an off by one bug in
 otx2_get_fecparam()
Message-ID: <YCqZvjAzSmJk5Ftb@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9895 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102150125
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9896 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102150125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "<= FEC_MAX_INDEX" comparison should be "< FEC_MAX_INDEX".

I did some cleanup in this function to hopefully make the code a bit
clearer.  There was no blank line after the declaration block.  The
closing curly brace on the fec[] declaration normally goes on a line
by itself.  And I removed the FEC_MAX_INDEX define and used
ARRAY_SIZE(fec) instead.

Fixes: d0cf9503e908 ("octeontx2-pf: ethtool fec mode support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 .../net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c    | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 237e5d3321d4..0eaf11107cb7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -955,16 +955,17 @@ static int otx2_get_fecparam(struct net_device *netdev,
 		ETHTOOL_FEC_OFF,
 		ETHTOOL_FEC_BASER,
 		ETHTOOL_FEC_RS,
-		ETHTOOL_FEC_BASER | ETHTOOL_FEC_RS};
-#define FEC_MAX_INDEX 4
-	if (pfvf->linfo.fec < FEC_MAX_INDEX)
+		ETHTOOL_FEC_BASER | ETHTOOL_FEC_RS,
+	};
+
+	if (pfvf->linfo.fec < ARRAY_SIZE(fec))
 		fecparam->active_fec = fec[pfvf->linfo.fec];
 
 	rsp = otx2_get_fwdata(pfvf);
 	if (IS_ERR(rsp))
 		return PTR_ERR(rsp);
 
-	if (rsp->fwdata.supported_fec <= FEC_MAX_INDEX) {
+	if (rsp->fwdata.supported_fec < ARRAY_SIZE(fec)) {
 		if (!rsp->fwdata.supported_fec)
 			fecparam->fec = ETHTOOL_FEC_NONE;
 		else
-- 
2.30.0

