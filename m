Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3A725AAA1
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 13:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgIBL5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 07:57:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35828 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgIBL5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 07:57:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082BsdTm176231;
        Wed, 2 Sep 2020 11:56:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=n0FzEU4KMlYvb3jcA1hVv+tmmUwolrwfTOenwY/ICYg=;
 b=FKJ4mLiHHdZeJ5VpE+KQjfHbDvge2kpBfnVujT32b3uej4i9RuOJKeJMT6ImsOzIso7e
 wWB0zfrDARFDH4VMfHR7IV9AP5AzjX08NJ0VhVweNnuBRvuL/1Ue/+6iRB4GeSHFKVQj
 g2ieNQLihM5t72/XbtGRM33JfeSpnSjv7Xt86xkpzrWrtHo5a4uL9kCfian/QIfQZ2YJ
 A3r6xKKutgaUCkl95AzyNh/s0zS2uLnGXplXvs+xDo/WBuFoNPalGmD11O0OaBor4+9q
 o84cIl7NeyDrthpXxSfgA5j2FM/WoJDCOWI7VLdfXf7gqkeyWRBPOPK1WAWMWv80SK9c sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 337eyma14f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 11:56:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082BtDAr144968;
        Wed, 2 Sep 2020 11:56:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3380kpvnpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 11:56:41 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 082BucPL005076;
        Wed, 2 Sep 2020 11:56:38 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 04:56:38 -0700
Date:   Wed, 2 Sep 2020 14:56:31 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Wang Hai <wanghai38@huawei.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: gemini: Fix another missing clk_disable_unprepare()
 in probe
Message-ID: <20200902115631.GA286978@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1011 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020112
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We recently added some calls to clk_disable_unprepare() but we missed
the last error path if register_netdev() fails.

I made a couple cleanups so we avoid mistakes like this in the future.
First I reversed the "if (!ret)" condition and pulled the code in one
indent level.  Also, the "port->netdev = NULL;" is not required because
"port" isn't used again outside this function so I deleted that line.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/cortina/gemini.c | 34 +++++++++++++--------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 62e271aea4a5..ffec0f3dd957 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2446,8 +2446,8 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	port->reset = devm_reset_control_get_exclusive(dev, NULL);
 	if (IS_ERR(port->reset)) {
 		dev_err(dev, "no reset\n");
-		clk_disable_unprepare(port->pclk);
-		return PTR_ERR(port->reset);
+		ret = PTR_ERR(port->reset);
+		goto unprepare;
 	}
 	reset_control_reset(port->reset);
 	usleep_range(100, 500);
@@ -2502,25 +2502,25 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 					IRQF_SHARED,
 					port_names[port->id],
 					port);
-	if (ret) {
-		clk_disable_unprepare(port->pclk);
-		return ret;
-	}
+	if (ret)
+		goto unprepare;
 
 	ret = register_netdev(netdev);
-	if (!ret) {
+	if (ret)
+		goto unprepare;
+
+	netdev_info(netdev,
+		    "irq %d, DMA @ 0x%pap, GMAC @ 0x%pap\n",
+		    port->irq, &dmares->start,
+		    &gmacres->start);
+	ret = gmac_setup_phy(netdev);
+	if (ret)
 		netdev_info(netdev,
-			    "irq %d, DMA @ 0x%pap, GMAC @ 0x%pap\n",
-			    port->irq, &dmares->start,
-			    &gmacres->start);
-		ret = gmac_setup_phy(netdev);
-		if (ret)
-			netdev_info(netdev,
-				    "PHY init failed, deferring to ifup time\n");
-		return 0;
-	}
+			    "PHY init failed, deferring to ifup time\n");
+	return 0;
 
-	port->netdev = NULL;
+unprepare:
+	clk_disable_unprepare(port->pclk);
 	return ret;
 }
 
-- 
2.28.0

