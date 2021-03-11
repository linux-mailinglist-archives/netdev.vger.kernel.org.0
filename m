Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6B3336C24
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhCKGWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:22:12 -0500
Received: from mail-eopbgr20078.outbound.protection.outlook.com ([40.107.2.78]:58371
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231313AbhCKGVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 01:21:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jK2NXiEmbBbc943eAgOt+mOFt6E7dWqqkck3+vzd/pzlpZzZrMHwOF2WA2IBepty1Z18EdWBXwu086WqqmL5EAJQcwGMAss0pVxSV8XHeUDjWCmHCfJikMP87l/7jInol6QaFLN9Wd9Xiq20Q2voAylpWw/2SVzDeH+2lIc1SZ3izBNt6ATwwxlsPpBdeteeEN5M4z7IPAMxtX+E+pjmS5ON9r1gIhYcif2IOWPH4aTQJN+qEWefLz29gsRphj+caZ+OmgLAFak/kOrP/qQyAyDaQUv4sDYBw9boQjiT70lPFql9GQ7nr8mEnYbmP8usJAU9OO7sZQxgl0QTcw++5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+8NwrK/szoll8K5Y2CAeAVgyQAQMY4RtCeOpAOwO38=;
 b=Lrnux/8FMJcEy/abXpw29RgTtFBH9X+D1Pqu93ID0TZ7W6y0hrKHen6lmLJektWZdAosqfP5+VVidsfoov5v4p8m5SjtRrz6S4umD7qGfeMRDgeJpDwYWC14lb8RDL50ZOcplc4Tmf94o3+ud4lSjLuNcVT6RVlmXODBYk7i3SrGWaO6HIcwlIlJubS1WNVS6E6zqQjJtgV3f5Nj4YLvuxsReHip0tyAWiCVsBehiyGhHwa20haKAcWJGEncxDBeLTQEixjWa6BeAme5ZXY7jqwiXypPw/X5qwFgRnrUr0U5sh8DBMujO5k5awHWB4MgMywwm26VJbALZwhJShD85A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+8NwrK/szoll8K5Y2CAeAVgyQAQMY4RtCeOpAOwO38=;
 b=Orrst5+z7qo3AKiqkZFa3OMl6S7hPOPY5lIlpf6wczqpz6IB+HsVqH83g+DY9vHPl+Sobo6oHhABBpGJTPsJNHbpDKiPBTGr8nvqQ6J06rit65AmSrXvtyMVnHkXbpk81u4YZ+qN2U1mpxySwZw2TQ7AUf3263zeM3b1kN5hMdg=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6611.eurprd04.prod.outlook.com (2603:10a6:208:176::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 06:21:46 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 06:21:46 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v7 07/16] net: mii_timestamper: check NULL in unregister_mii_timestamper()
Date:   Thu, 11 Mar 2021 11:50:02 +0530
Message-Id: <20210311062011.8054-8-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: HKAPR03CA0026.apcprd03.prod.outlook.com
 (2603:1096:203:c9::13) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HKAPR03CA0026.apcprd03.prod.outlook.com (2603:1096:203:c9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Thu, 11 Mar 2021 06:21:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5cde01ac-0ce0-4067-1026-08d8e455f204
X-MS-TrafficTypeDiagnostic: AM0PR04MB6611:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6611EFB717A82023EE2B028AD2909@AM0PR04MB6611.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NfG0GbLAYsIXaATvTuYwEdEflNXYT+F0p875XSu0yTHJLe6ekRvnF9UCv+guFd2h3k37Rm/8tq8gK/885dENxJnChoXo4lQtFuZ7VJlulCBeD7jn8VMxAqbTWoUUyo11K5EqqENg9Xp1a/8hf+EaCMAhpJiTY1wyPH5nDdB5lAxsI3oNAxGpwZOZ8GUwBilx0x1qmmu9WuzAU3uQr/jVvhohj+s9khZm2V35SEUc2STSEDiiXEDqnUiMPTKfb6Z/rv2Pc4UD33wmQxFcmHb3jlZaIa/7OUNPMw+r6mePR+OrsDjkBHO1SHc646FfMBOD3y63yHnmYzxPtSpmwr+O/XL169HUnaCmGnqsADFbqmXZjy/BiRJ8L2fv5iz1/PENWq/PF2cJc83Y9tMcewtFzluY+cte1fhGfQdG+MOZ/tE+PTGIeHAnEhHM42C4Lqq6OsU6bG3y/8FEBFZL+evofWyiYZTc40jBrcRqPk22SZC3vRJq7I2apk9eFkbU9A4I2j1Mcv1Cdaid6ogwXjIw5moiK8mpkC4frARtMckeDfSkQTisITo/vuAJ1uVBsl2Ider4jXEIRat9Kilgi822MQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(2906002)(921005)(16526019)(26005)(186003)(83380400001)(6486002)(8936002)(6506007)(66556008)(66946007)(55236004)(66476007)(44832011)(478600001)(6512007)(2616005)(316002)(54906003)(5660300002)(956004)(1006002)(52116002)(8676002)(6666004)(110136005)(86362001)(4326008)(7416002)(1076003)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4YrwtBzItUaS3Eq1SfR1FmY4L9NVjh7xRAxd/RZTUBli2CCiK2rvrkTm6EVs?=
 =?us-ascii?Q?kOc6xpfUB1/B9wKbsTabKlAQBV56zP0189Hd8ZUj0x6DH47Sj3Wyb5UbrE9o?=
 =?us-ascii?Q?wyJiPNXCgfriY7MlIS0v+Q9Ed7xifbVylKdjAG6yo9TLEergFuOsu/C1TcGh?=
 =?us-ascii?Q?Bwuy9o0BF89RWIELPMGMvZR9vgPWBsi5c/kRZBXYlo8SG/9m68KUDH2yg1P7?=
 =?us-ascii?Q?+rRpayG2CjtcEp57BspEO98E/3DbuI26Ck8NICJPDFuBnB5Qgs8HCHdUb1UV?=
 =?us-ascii?Q?9Rgenw1ZqGXvqYVDhfC0VAzvIlXwc17h+HGxKOInMc9haAwNL/TSwwEh064V?=
 =?us-ascii?Q?nXzOOWl6keG6EIke904qF6jylmG8oCUuV/oPR+k9DtDIsswDwuCIF/e0cLqG?=
 =?us-ascii?Q?i33M7R7EanQAvshq+Bi2hsLLUzlFiaCXx25B/EHl4UeonlUe9Rory/LNu0tB?=
 =?us-ascii?Q?F2fX/YreoxPkjCQ4qPHFgn8XXUDvdjdJlYQuQp+3DSrh484IP2I7hkVInqNp?=
 =?us-ascii?Q?cyN97CHsG/yhNhCuhdObdx1nRMBv+Gj2q6TrqDnYGvgnmFoDY+0U2yS4m6rt?=
 =?us-ascii?Q?U+OdvzsOtjYgnQQXk3D9i2Ne8F6B66fiuY/K0cUbYZ6TfpY90+g6MuvX5Mi0?=
 =?us-ascii?Q?O+ANwTnG7BcL/ztmZTN3qsFCb5CnZn2Jhna72PIvHcyLaitdUqnD/zyIsRsJ?=
 =?us-ascii?Q?TVfhlDHfhm6FDszarKrn3w+ivs8wMgl9NB0NT0D4l/wrLk/VM7rTt2V1pFOt?=
 =?us-ascii?Q?iLzPsNVgS8Av3qRf4t2PryoNNrfhPBEviJRW0oEbVD66YH9sD5/LBQfuuOZT?=
 =?us-ascii?Q?NHgVsk17OA6+ObSv6ZID/o+pjRgs1qoP6fhnNek0skDS+41Ar00pXAZwBi+q?=
 =?us-ascii?Q?4rKYd+tM+r9Tho/R5VAbRJs0s+rAK6Dg3Q/rPOr9azy5W35hiyJVbR4/94wD?=
 =?us-ascii?Q?od8AI81nxAc1UnLxT83k6+Jcqcga8B7xSRvtjUlGvnJCHw2nHwa35GWXnWF0?=
 =?us-ascii?Q?4J4rdPzz2Nk3+GhOzplJ597KOdRnwKAY++q7uLKHSUDYOhJIro4I1tzQs3gN?=
 =?us-ascii?Q?+OWrL+O8Vakk8KaHjpGa90Xc4vFolBNKNk1CpvOnZQRJimB6x4LkUgs4UD4h?=
 =?us-ascii?Q?jbKRMoycpx/S9+VjpU72sUIj8HjluOgSVWGW3QDj6sKhha7EabRacLNKo09s?=
 =?us-ascii?Q?Fz89V0IIdJl5xurAf8gE5N3qm3/YdJMHVcUflI8JNxhWdqwcH82JErvzUgDQ?=
 =?us-ascii?Q?U8Wg2MSdp9kl2XWt8gNywwU+hQdLFJlV98VHZJWX6yLo8Q5SuGbcOd8NB6x7?=
 =?us-ascii?Q?mBmUNI0n2tHg/7fFixmRPNFM?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cde01ac-0ce0-4067-1026-08d8e455f204
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 06:21:45.9139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fXhT/Eb8aafcKs9FBrF2a72Uyq+1shazAfqgEYqA2WKE5bH9e9G0do94hTe8j1cx4o50JMd+0WhsuwwCdKreXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6611
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Callers of unregister_mii_timestamper() currently check for NULL
value of mii_ts before calling it.

Place the NULL check inside unregister_mii_timestamper() and update
the callers accordingly.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v7:
- check NULL in unregister_mii_timestamper()

Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c        | 6 ++----
 drivers/net/phy/mii_timestamper.c | 3 +++
 drivers/net/phy/phy_device.c      | 3 +--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 612a37970f14..48b6b8458c17 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -115,15 +115,13 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 	else
 		phy = get_phy_device(mdio, addr, is_c45);
 	if (IS_ERR(phy)) {
-		if (mii_ts)
-			unregister_mii_timestamper(mii_ts);
+		unregister_mii_timestamper(mii_ts);
 		return PTR_ERR(phy);
 	}
 
 	rc = of_mdiobus_phy_device_register(mdio, phy, child, addr);
 	if (rc) {
-		if (mii_ts)
-			unregister_mii_timestamper(mii_ts);
+		unregister_mii_timestamper(mii_ts);
 		phy_device_free(phy);
 		return rc;
 	}
diff --git a/drivers/net/phy/mii_timestamper.c b/drivers/net/phy/mii_timestamper.c
index b71b7456462d..51ae0593a04f 100644
--- a/drivers/net/phy/mii_timestamper.c
+++ b/drivers/net/phy/mii_timestamper.c
@@ -111,6 +111,9 @@ void unregister_mii_timestamper(struct mii_timestamper *mii_ts)
 	struct mii_timestamping_desc *desc;
 	struct list_head *this;
 
+	if (!mii_ts)
+		return;
+
 	/* mii_timestamper statically registered by the PHY driver won't use the
 	 * register_mii_timestamper() and thus don't have ->device set. Don't
 	 * try to unregister these.
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index f875efe7b4d1..9c5127405d91 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -928,8 +928,7 @@ EXPORT_SYMBOL(phy_device_register);
  */
 void phy_device_remove(struct phy_device *phydev)
 {
-	if (phydev->mii_ts)
-		unregister_mii_timestamper(phydev->mii_ts);
+	unregister_mii_timestamper(phydev->mii_ts);
 
 	device_del(&phydev->mdio.dev);
 
-- 
2.17.1

