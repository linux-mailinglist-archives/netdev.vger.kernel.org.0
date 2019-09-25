Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46483BDC7A
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 12:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390764AbfIYK5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 06:57:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45438 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfIYK5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 06:57:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PAsQ3G039665;
        Wed, 25 Sep 2019 10:56:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=4al3HliRkVdmk8Hk4LVrPapR3bzkuB32T9Cht6iw6r4=;
 b=oX28Q40MYPFEUvhYd+j4+fh0BSCCMxqgkIl1yQLAPyRmqQNupF/vzn5a+XpgnO2LGsHg
 dqRv3UqeH9ctyHv5rqR04Xl2AUuNlP/g0+gk/TGZCXiHJeINc7TP1yP57d9iKGYL7df1
 eu6NheK2UYN4skW5VkPbe/7ByiMFm7WDcxWoCRi+wX2p8xw5SErfyPBCTNPEueiGmB0P
 3a5ObIdPeEkPcXBDflXPZVyLTDQiXWPajV9iM4j/D/rDSUs8id/iUfkBCPhOC6+XqhrW
 bb6rSvhji54jxtopKBpDdzAFiWxnYDlzjmj51fx7bVsF8ydwtBIyX7ubKSAqVNrpRoGX Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2v5btq3vms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 10:56:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PAro0C022458;
        Wed, 25 Sep 2019 10:56:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2v7vnxs69v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 10:56:50 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PAulQ1026583;
        Wed, 25 Sep 2019 10:56:47 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 03:56:47 -0700
Date:   Wed, 25 Sep 2019 13:56:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jassi Brar <jaswinder.singh@linaro.org>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: netsec: Fix signedness bug in netsec_probe()
Message-ID: <20190925105638.GE3264@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250112
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "priv->phy_interface" variable is an enum and in this context GCC
will treat it as an unsigned int so the error handling is never
triggered.

Fixes: 533dd11a12f6 ("net: socionext: Add Synquacer NetSec driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/socionext/netsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 1502fe8b0456..55db7fbd43cc 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -2007,7 +2007,7 @@ static int netsec_probe(struct platform_device *pdev)
 			   NETIF_MSG_LINK | NETIF_MSG_PROBE;
 
 	priv->phy_interface = device_get_phy_mode(&pdev->dev);
-	if (priv->phy_interface < 0) {
+	if ((int)priv->phy_interface < 0) {
 		dev_err(&pdev->dev, "missing required property 'phy-mode'\n");
 		ret = -ENODEV;
 		goto free_ndev;
-- 
2.20.1

