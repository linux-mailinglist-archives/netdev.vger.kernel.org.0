Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88688302618
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 15:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbhAYOHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 09:07:05 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55934 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729130AbhAYOGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 09:06:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10P8A3qT158329;
        Mon, 25 Jan 2021 08:13:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=eukozOlwERUsiiJa50WK4bplUAZvd/sAVG0MWml20+c=;
 b=nZ2sSTREa8Kn2lgq0GxIwvhBsSMuH4N8SIOKZr0MnUiAAGSiQb5RB1BorrXPnMN77lMu
 3KE74yZ12zqTk4W5LBoKDubIDfsBPvFiErfKMlWfR2QtIx1DxormZWsEaovlUpe2DxYq
 iGx7a2HfyQWinnJMw5rDQTQt5sR31OlVHVPPzuPPm5yUSw76grGltRGu0BxAsH5QPhNf
 9LNsqnWl3dmGNCXpfFU0/XVyikQwzMszpvYOPTzsgVxYqHn1PJAi/h70Tw0E6Ax2pm4f
 OV6S1o8R2CdyWipPwmwJgCK5xdIdvKDWA8pZxZzjZUdpwq9AUcHPtarz4hv4eDblWBv9 sQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 368b7qm1qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jan 2021 08:13:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10P8BRSI003656;
        Mon, 25 Jan 2021 08:13:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 368wjpcucy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jan 2021 08:13:32 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10P8DV9k022050;
        Mon, 25 Jan 2021 08:13:31 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 Jan 2021 00:13:30 -0800
Date:   Mon, 25 Jan 2021 11:13:19 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2 net-next] net: mscc: ocelot: fix error code in
 mscc_ocelot_probe()
Message-ID: <YA59n5DbO0BkK7rv@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YA59en4lJCiYsPHv@mwanda>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9874 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101250048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9874 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101250048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Probe should return an error code if platform_get_irq_byname() fails
but it returns success instead.

Fixes: 6c30384eb1de ("net: mscc: ocelot: register devlink ports")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 2c82ffe2c611..7e4c9b255124 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1307,8 +1307,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		goto out_free_devlink;
 
 	irq_xtr = platform_get_irq_byname(pdev, "xtr");
-	if (irq_xtr < 0)
+	if (irq_xtr < 0) {
+		err = irq_xtr;
 		goto out_free_devlink;
+	}
 
 	err = devm_request_threaded_irq(&pdev->dev, irq_xtr, NULL,
 					ocelot_xtr_irq_handler, IRQF_ONESHOT,
-- 
2.29.2

