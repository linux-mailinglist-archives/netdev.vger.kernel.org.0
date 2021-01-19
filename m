Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B832FBAF2
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389256AbhASPUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:20:19 -0500
Received: from mail-eopbgr00129.outbound.protection.outlook.com ([40.107.0.129]:33614
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390945AbhASPLm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:11:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByhpoXjq59CHK7wUyZ/KsNR7s0rsI8g8uyv8jN0Wn9s0ix5e892oUYjdIcHJY/zr2Ir0mhZZo++lA4/fqDtsWu5aYNQglmNBk0hOs60s5+IFMx3Ey9twjI0A3DRTmrK3WcQiEjyooe4deGE1uJmH9FK3P2gESFsHSGWjAmyJrGx4i7DnYjGksXH0POlc/rvefLReevQ9GxByCWvT7LqMEEM3VL3o4nMM04ZWHAtQnA1Z0hkZXjMOm5F9uc96ri4mHDGxiYC7aYG69+qz9wE+e89p3UywXTpXWQTZwYToRpr41l/F34WsigQYabBvSVEGNs/MYu8GiHdVUuU+fL2P+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SfTOF/9xR8KEyG4aELWQAscdgq/aPgCbf+M2MsTfIh8=;
 b=WyZbAlp+Wbpidv46ufxYj0cBRwUdDg4GO5RrMuZHnNAZmFo5npWFeDUCYfBTSMzWZHa+gqw4JW4bHB9eYg/VUHzPAL3roqfKohGPQ3wjp+bEmlIpIV47QIFUCKlPSAhStDzj194wUbGYwRpz1XjfdmqBx72+WvBnvsC5jZmf5ZOBLuz3ERyZpsIC9BPw8SCXM6MzCvK5ghTeqyaMsDFTZ0ynKUPkLzyf6vpOMgAFWgwUYfQA2PfFhsdPSMNwfEK6Z4DO5fi6sGU1gdo9Rt+oSvQ4plwJQRC8BhnFKaUk0NhZbTxP5Jf8zEIjWOuyzNMcT0g01GCooiEpuZzZjDlU8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SfTOF/9xR8KEyG4aELWQAscdgq/aPgCbf+M2MsTfIh8=;
 b=b+IFQ2nTjq+5g01DljC3Gz4K9DdIE9KWvcgyPSz5v6ek24mG2jYu4+jF0V0UUQsez2flYwH5263nBsVxqXKog8gGBj+jChv8Ya10uX62i44l7TvKf/3o/y0foIW4bYMdg35U1O8mbKqN/mP4WgOugqWjFO55UqzXALgw0ZIWU2o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3681.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:15d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 19 Jan
 2021 15:09:16 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:09:16 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 11/17] ethernet: ucc_geth: don't statically allocate eight ucc_geth_info
Date:   Tue, 19 Jan 2021 16:07:56 +0100
Message-Id: <20210119150802.19997-12-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR02CA0036.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::49) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR02CA0036.eurprd02.prod.outlook.com (2603:10a6:20b:6e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 15:09:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ca129ca-0a51-45e0-2774-08d8bc8c3034
X-MS-TrafficTypeDiagnostic: AM0PR10MB3681:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB3681C32A3AC297BD265F310B93A30@AM0PR10MB3681.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x/ycqqQGOhYZylGWNu035cwhADzt9bMVSB5zlXdbuvI8V32FsiNvtzNRLp21QwrWSH2EqS70J6uC7JdUX+ZFEavCHYCFrM2DR+cWSpd21ak2NMRI9qe2bhHbW7oaPrdKXEAorX57FCWa0sadJGWHETWmkTpmJaot9BWx+LBvbwgmv0zytJt+NiGjFrT0mxvv/0prUIhFyjM8Pj86o4HM+DgzNuhJKacuoCeujyWrmyhXLfK5kqySH83jUWjRojPZz8PPTRPhsFV+MQaiK9FkEvT9xfu/rOd5acX6uINWfRU/OrHN3T5M6ysX2BK0h/aeffxw7uUwkV8mGOkGM35ZzkLKNs40YzetOd/c/qvrkN7EnZPBXuYrd6tVBowkEEcsyCuqdFyPXZR4USCg87Zmng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(136003)(39840400004)(376002)(8976002)(16526019)(6916009)(5660300002)(8936002)(2906002)(6506007)(66476007)(52116002)(66946007)(1076003)(83380400001)(186003)(956004)(6666004)(6486002)(8676002)(66556008)(4326008)(54906003)(44832011)(107886003)(478600001)(36756003)(6512007)(86362001)(26005)(2616005)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ijxyhR3Kbb6mnmTzIRSJHffxpUOzYTZhSdSyyqbt0sGgBoZxtwgqGV7DpYTw?=
 =?us-ascii?Q?UN8YK6HECBYU9vswOG6zl+iUGOIFBhoZRHcXr9YRLPsX6+/JPj+u72bmXyQd?=
 =?us-ascii?Q?THD8wpiINV0lo3/ZaFksQlW+vhx6Sp2pB0rd3NMnjooeFZQGdDgz2y91O/yE?=
 =?us-ascii?Q?yIOgk3fY0W5lME7CxtjmdogAAl2A/F2+VYDgM2ZEv4C62pVWp2y/WAjwnuYw?=
 =?us-ascii?Q?CNStkOmboC4/nPtitRZDWuO1fVe7Y0NWGKkWW4bpUeGvFyk+9zvFZnRjujC9?=
 =?us-ascii?Q?W+YHE5psEkdwwBg2uxD1ULPAju7JEu21Zj8kK69QO1IV9lmGiq7yyIzoTbyj?=
 =?us-ascii?Q?8XHYvaQYaJT1ih+3mv/pOJq3652SnALX2NkbEdHTsW2fGYKGuaR62+UMDKcd?=
 =?us-ascii?Q?D2TcWb4U0IKEUQlOFXlYx9c3HFtv50cDdyW4eRof82vKC6jqQWbhlR4/6kLr?=
 =?us-ascii?Q?kk58wLTogmezn20hguYfF4m7Ndb4NY5NzpVGosDFveWb2JeWrW9B4Kl2ziSt?=
 =?us-ascii?Q?5iBGaTTlK5YcqZU6u127jcxnQ/nHfjcBQIo8MDIMpYNtf1M1Iog4VkPd2LyG?=
 =?us-ascii?Q?dsxGzDwAyxlS/Ab/nOYYdJqETEOsnUTGPP9SfHajOfPXm2qUEX+0PYGIxr5c?=
 =?us-ascii?Q?9wERpPsZrnNkM9zyzTXKrEaA9yDeiOuUiLnPsWMOfzRbb71OMc1rKfrm69ky?=
 =?us-ascii?Q?91Jolu3MOfsSPjlnM+ZGfYxwacqqpaD9Ds3NUJ/gNMisWa+wRQAl6QH8lDVJ?=
 =?us-ascii?Q?MwAALkJJL3flVdb2GjntF6V2HrIt38Z4ltmH1G6CrIO+kuk1obJJlttOdbJ2?=
 =?us-ascii?Q?G2Ya3jfn12rJ5Ds31mQ/CSoeiHqYlpQxX1ZHc4d/lvdFV2nsbiW4PAOYCU7J?=
 =?us-ascii?Q?T3Px0aJq7gFZ/C7wrryI4/jte51GWxcn3fMdQ3AHLyFu5cgCKp/2gijqFW5I?=
 =?us-ascii?Q?ObGGdZY0hL4fUmOZ51tHebUwIAQSS8AOW+dPZbw/jP/xjwHLQyAYyAjGU8hP?=
 =?us-ascii?Q?n4Fr?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca129ca-0a51-45e0-2774-08d8bc8c3034
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:09:16.4991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tA6wFh8zbo/OmbtdHqSnhBOtGodYaGn7bHoV7FTz/mLb7SBCOSJkxDZx9NZY39VJvC80A80CaOM8XYh/Bkr/NECfVWggkRbmnbMq//SUihI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3681
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct ucc_geth_info is somewhat large, and on systems with only one
or two UCC instances, that just wastes a few KB of memory. So
allocate and populate a chunk of memory at probe time instead of
initializing them all during driver init.

Note that the existing "ug_info == NULL" check was dead code, as the
address of some static array element can obviously never be NULL.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 32 +++++++++--------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 65ef7ae38912..67b93d60243e 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -157,8 +157,6 @@ static const struct ucc_geth_info ugeth_primary_info = {
 	.riscRx = QE_RISC_ALLOCATION_RISC1_AND_RISC2,
 };
 
-static struct ucc_geth_info ugeth_info[8];
-
 #ifdef DEBUG
 static void mem_disp(u8 *addr, int size)
 {
@@ -3715,25 +3713,23 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 	if ((ucc_num < 0) || (ucc_num > 7))
 		return -ENODEV;
 
-	ug_info = &ugeth_info[ucc_num];
-	if (ug_info == NULL) {
-		if (netif_msg_probe(&debug))
-			pr_err("[%d] Missing additional data!\n", ucc_num);
-		return -ENODEV;
-	}
+	ug_info = kmalloc(sizeof(*ug_info), GFP_KERNEL);
+	if (ug_info == NULL)
+		return -ENOMEM;
+	memcpy(ug_info, &ugeth_primary_info, sizeof(*ug_info));
 
 	ug_info->uf_info.ucc_num = ucc_num;
 
 	err = ucc_geth_parse_clock(np, "rx", &ug_info->uf_info.rx_clock);
 	if (err)
-		return err;
+		goto err_free_info;
 	err = ucc_geth_parse_clock(np, "tx", &ug_info->uf_info.tx_clock);
 	if (err)
-		return err;
+		goto err_free_info;
 
 	err = of_address_to_resource(np, 0, &res);
 	if (err)
-		return -EINVAL;
+		goto err_free_info;
 
 	ug_info->uf_info.regs = res.start;
 	ug_info->uf_info.irq = irq_of_parse_and_map(np, 0);
@@ -3746,7 +3742,7 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 		 */
 		err = of_phy_register_fixed_link(np);
 		if (err)
-			return err;
+			goto err_free_info;
 		ug_info->phy_node = of_node_get(np);
 	}
 
@@ -3877,6 +3873,8 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 		of_phy_deregister_fixed_link(np);
 	of_node_put(ug_info->tbi_node);
 	of_node_put(ug_info->phy_node);
+err_free_info:
+	kfree(ug_info);
 
 	return err;
 }
@@ -3893,6 +3891,7 @@ static int ucc_geth_remove(struct platform_device* ofdev)
 		of_phy_deregister_fixed_link(np);
 	of_node_put(ugeth->ug_info->tbi_node);
 	of_node_put(ugeth->ug_info->phy_node);
+	kfree(ugeth->ug_info);
 	free_netdev(dev);
 
 	return 0;
@@ -3921,17 +3920,10 @@ static struct platform_driver ucc_geth_driver = {
 
 static int __init ucc_geth_init(void)
 {
-	int i, ret;
-
 	if (netif_msg_drv(&debug))
 		pr_info(DRV_DESC "\n");
-	for (i = 0; i < 8; i++)
-		memcpy(&(ugeth_info[i]), &ugeth_primary_info,
-		       sizeof(ugeth_primary_info));
-
-	ret = platform_driver_register(&ucc_geth_driver);
 
-	return ret;
+	return platform_driver_register(&ucc_geth_driver);
 }
 
 static void __exit ucc_geth_exit(void)
-- 
2.23.0

