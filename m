Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15225359E95
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 14:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhDIMZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 08:25:10 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39788 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbhDIMZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 08:25:05 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 139CFVCA194305;
        Fri, 9 Apr 2021 12:24:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=shOFeNA3XyLf4escMxhfFFDEAj60p8yZvOwPN7oekG4=;
 b=BJ5YVBD17B7On02iZ8h74Dvidjx2fzHXsIkZgVZS11U4EXptQPhdEx/+2JI4SUFdgdzM
 Nocgw/Gx9oqwxAKOEzvg4gtCSIUyP4AgqqD9dj2cuTHMvzHbpvP8lb/tKpmlJY8dIGee
 55FrB9dMCu37BDtWs7IRNkv93PJu9D2CvKy35JfIuB/Yx0rmmO9hM1ZV9mFEb20hGR0r
 jWKna3AiV+RIMvI+97HThlMadbDATbgmgZFMI2coaFz8k6fJSvfIPpA0JWAodiIZo6eG
 oiA3+UxIXW4Rjz2YqBZorZV8mFXq75f1hKvAB+xcAt6/C700ft8kzORVB+ZW5C1iWOM0 ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37rvaw97v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Apr 2021 12:24:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 139CFPeF123902;
        Fri, 9 Apr 2021 12:24:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 37rvb6j50a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Apr 2021 12:24:38 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 139COaDW023441;
        Fri, 9 Apr 2021 12:24:36 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Apr 2021 12:24:35 +0000
Date:   Fri, 9 Apr 2021 15:24:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: enetc: fix array underflow in error handling
 code
Message-ID: <YHBHfCY/yv3EnM9z@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9948 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104090092
X-Proofpoint-ORIG-GUID: SRbG0EicQFwAAbCbrKgVWRoIEiMXkaOs
X-Proofpoint-GUID: SRbG0EicQFwAAbCbrKgVWRoIEiMXkaOs
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9948 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104090092
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This loop will try to unmap enetc_unmap_tx_buff[-1] and crash.

Fixes: 9d2b68cc108d ("net: enetc: add support for XDP_REDIRECT")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 57049ae97201..d86395775ed0 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -895,7 +895,7 @@ static int enetc_xdp_frame_to_xdp_tx_swbd(struct enetc_bdr *tx_ring,
 		dma = dma_map_single(tx_ring->dev, data, len, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(tx_ring->dev, dma))) {
 			/* Undo the DMA mapping for all fragments */
-			while (n-- >= 0)
+			while (--n >= 0)
 				enetc_unmap_tx_buff(tx_ring, &xdp_tx_arr[n]);
 
 			netdev_err(tx_ring->ndev, "DMA map error\n");
-- 
2.30.2

