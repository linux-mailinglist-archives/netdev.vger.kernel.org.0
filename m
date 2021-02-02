Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A837930BAC4
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 10:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhBBJRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 04:17:32 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35682 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbhBBJQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 04:16:49 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1129ExLs039270;
        Tue, 2 Feb 2021 09:15:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=XeW5vxg1oljfl4NXPYOgql+RYM8k8nJCK9uJMauzFyQ=;
 b=iFSps5hvLXTkb1IpbQtL4B+9QdQaiKeCoS6sZnAMrma4suhj/OQqd8hItpALHuAkaD+L
 KBf2c4Z+fTIBvnLxRXCfDFKhd492Mu60m8dhyzDq2vpVwuSAb60jbu5l52bdPECKtqU8
 0T3/UHRgQIAQSa1YCuUN+aakiE5DU58bu1N6JjfWmzThHRdxEH4V1SNyz3xk34inkY72
 dUWgAyE1G6fn3KQ5eKT1dbLAj0rdCLcAfpxSvp18KNF4n0ZHUXeL+KW5YdUzzuChLAWt
 STyT715+iN75/vVRF1ySKgZOZkQ9XHNRAclG03wC0DRj2wJmDYbCAUA5rpDulqDs0fSC pw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36cydksmf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 09:15:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11299Trh073369;
        Tue, 2 Feb 2021 09:13:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 36dh1npd0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 09:13:55 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1129DqdL032702;
        Tue, 2 Feb 2021 09:13:53 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Feb 2021 01:13:52 -0800
Date:   Tue, 2 Feb 2021 12:13:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH v3 2/2 net-next] net: mscc: ocelot: fix error code in
 mscc_ocelot_probe()
Message-ID: <YBkXyFIl4V9hgxYM@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBkXhqRxHtRGzSnJ@mwanda>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020064
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Probe should return an error code if platform_get_irq_byname() fails
but it returns success instead.

Fixes: 6c30384eb1de ("net: mscc: ocelot: register devlink ports")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3: rebase

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index b52e24826b10..6b6eb92149ba 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1300,8 +1300,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
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
2.30.0

