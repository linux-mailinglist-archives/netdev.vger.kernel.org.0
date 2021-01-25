Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D85D3033CF
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731423AbhAZFFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:05:35 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:35472 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728487AbhAYMyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 07:54:16 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10P8ZcWw017890;
        Mon, 25 Jan 2021 08:44:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=4fELZprUH3BjWQpVYxUfMG9nV16pv93PKan2y8Keyzg=;
 b=RJlAYVqU1vyzvRa6MsCkUmMFEigAm8ZVftestgE9FyQ4tSnoLBd0VtHOs9VJ9c/X7B7G
 V+LUB/cYxkIaPQbMvFi+BpfVbLqtmNqiyfSiQogvXjqXsyLMm5gS2hNCuOfpEei+mSyv
 f1TmCaZV5bnoqZAkCGjITeVnoXPmAIpGKBCrY7c2nTIlKHbu62WmpkpblfxNFxawe76b
 MLuAv9OnrC3lRoZbS4+d5bCJbLnsGfB4IXC8nhRXqnLnGVKrr08uFqDytK2VKV3pWAo5
 p+y1YsLwZwD7kdHfzO841qjabCsdjFO9j16LkBycQj8YobPO6yhidMM55JRRZSOYYmDo ZQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 3689aacaw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jan 2021 08:44:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10P8ZSuL091808;
        Mon, 25 Jan 2021 08:42:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 368wjpdqv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jan 2021 08:42:46 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10P8gjE6002789;
        Mon, 25 Jan 2021 08:42:45 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 Jan 2021 00:42:45 -0800
Date:   Mon, 25 Jan 2021 11:42:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH v2 2/2 net-next] net: mscc: ocelot: fix error code in
 mscc_ocelot_probe()
Message-ID: <YA6EfL9tQWYU3dDn@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YA59en4lJCiYsPHv@mwanda>
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9874 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101250051
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9874 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101250051
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Probe should return an error code if platform_get_irq_byname() fails
but it returns success instead.

Fixes: 6c30384eb1de ("net: mscc: ocelot: register devlink ports")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: no change

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

