Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1AD7BDCB1
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 13:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404253AbfIYLGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 07:06:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55666 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729602AbfIYLGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 07:06:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PB4N9V047379;
        Wed, 25 Sep 2019 11:06:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=7AcvPUSXbf3zvRYSdYau2KWOrIhOXWajH29zkbdtniQ=;
 b=X1Ha/D2yvIzM8AW9I48fuemhHZXVmhaZ9eJEfJTPxNuHKwkdSfpgDmRfGJrKrLw+A+uu
 qn+VdJ2iVqYY4GfllktHnoYoFaZkqRLDZgDxAZKPVIj9Fpr1lAWzFvVajBjzjZtIVqHR
 lDk8uH1enxloRXLmg+8yGXrb/r9+2jP6R0LO9sDe5lJn2jO3Oea++N3BkKpuRPRJS0Lz
 ZkAUxN1TFHqvz9c6ysg2hbFn/C+3nOwWViwPv4DNShO8svl018UCwBY2AZAns3EksXYE
 Kl81fjhe8s9a60CyRTvj4b5V6faSpPeN3GSLAX51MQxWZPGqu1+aD0l1qyMBL0f3M7mn Ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2v5btq3x06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 11:06:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PB42oX049915;
        Wed, 25 Sep 2019 11:06:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2v7vnxsm72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 11:06:04 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PB62Ep023806;
        Wed, 25 Sep 2019 11:06:02 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 04:06:01 -0700
Date:   Wed, 25 Sep 2019 14:05:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Mathieu Olivari <mathieu@codeaurora.org>
Cc:     Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: ethernet: stmmac: Fix signedness bug in
 ipq806x_gmac_of_parse()
Message-ID: <20190925110554.GQ3264@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250113
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "gmac->phy_mode" variable is an enum and in this context GCC will
treat it as an unsigned int so the error handling will never be
triggered.

Fixes: b1c17215d718 ("stmmac: add ipq806x glue layer")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
index 2c6d7c69c8f7..0d21082ceb93 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -191,7 +191,7 @@ static int ipq806x_gmac_of_parse(struct ipq806x_gmac *gmac)
 	struct device *dev = &gmac->pdev->dev;
 
 	gmac->phy_mode = of_get_phy_mode(dev->of_node);
-	if (gmac->phy_mode < 0) {
+	if ((int)gmac->phy_mode < 0) {
 		dev_err(dev, "missing phy mode property\n");
 		return -EINVAL;
 	}
-- 
2.20.1

