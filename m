Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0C72DB1F7
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbgLOQqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:46:15 -0500
Received: from mail-eopbgr20074.outbound.protection.outlook.com ([40.107.2.74]:21124
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730214AbgLOQp7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 11:45:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWoMwptZoUa2V6d9N4lg3/oJQ1dDwVxr+LsbIyCuKP651Cvofez2b4XFuOcZGWjXf+y74Lf3wrc1xDnCUaIckXtAmD8Rhrh5j0foApWpjUW8TSHNf3g0k8p+zKvamARV65EAM3KgUSWvdpgSJ5khCzbXlq51Il886Yhd9xRf4yBuaXkQLy6rWeBDifmTCJ9DdoZZDuLKx0pr5GSmjHJTyeqwg9ddIaPlQkyIvncncZFMnBbm3DDgpgeMfS2ahHCP37xHRUTtUkPWYKk0m5okMZ64otLjNxz9MTv3tsTmZ9rlt5PgJlIg8UzShSBOO9qIA2tFTYPAwGOvZ4NUTIspTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPUWc9b5sQAylHp9YXwciwmzvBd36tMUDg4/MdJI/V4=;
 b=GyuQV90B31X0na/GdJHxEzjIfGv0S0fYdaT3XcdjHs6KgkGymuN7W5N7rVJq+PXH/UZUKUxonapDxOKg4xyfQlRYRT9wBynglNrPI64bX9g2CrB37M0wF0Y8Ep5bq4rmC7NDRU8jXwGB6L8cI4+p0gohXXl6pF/1Wv7kb390WylAY2lLjLuCCci+I0fYWlataHtFYjo7oGJSfDVONbBl6zy1Ylatbqi9VT/X7EKp6whg+PaLJyB4uQm92zI3PeUtVWEq52WIEc5Vnae99Bd6zcA9J4sDmB22LodkfCaCop3bA/12E4P+d4MSvYbxKP4U5PQ2jviXwQyGdtFZsOWPTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPUWc9b5sQAylHp9YXwciwmzvBd36tMUDg4/MdJI/V4=;
 b=FBBCzPAvMXnLwqKee0Qk87sEwBd5mNStI7q02IiFueOVpzhMDgPoacrDkpvCBB66s/acWEEo8IzWvYtBPSm48s6VmSlcFw798qoRDki6TvwM4hDI21S0v5L1cgRoH1+UPniOuTlL3jiysDrn9mDnKrAAWl6x3kFp6Bee0GNORKU=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6963.eurprd04.prod.outlook.com (2603:10a6:208:18b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Tue, 15 Dec
 2020 16:44:10 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Tue, 15 Dec 2020
 16:44:10 +0000
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
        Jon <jon@solid-run.com>
Cc:     linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v2 03/14] of: mdio: Refactor of_phy_find_device()
Date:   Tue, 15 Dec 2020 22:13:04 +0530
Message-Id: <20201215164315.3666-4-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0152.apcprd06.prod.outlook.com
 (2603:1096:1:1f::30) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0152.apcprd06.prod.outlook.com (2603:1096:1:1f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 16:44:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 88429c5e-aa01-4818-be9f-08d8a118a5a6
X-MS-TrafficTypeDiagnostic: AM0PR04MB6963:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB696312F38CEF77161DBCD2E0D2C60@AM0PR04MB6963.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JSG9pu3wOxv1YckrAnXh/QebWdSL0dh4Q/ELlY10tD0P4Xxpm50fU8JXzgi5eUnECaBzN4Vj/+Z5Fyz1o4KHSXgcdHI3zxiWT0gH9v1Fj62eC58JVgIaUtDGBjFZ4xcs2EpvhmRXR0jYGQHSwAHKpWt/xuBdfM/sv1gl14fFqOQUhBCHA10fzzTgD+yBdY9IMhiZrW94SBBf+LT01LLYJIvb6Gvmy7Ih3ljDJmbI1huIebr8K7tO2rltrqsHM6rr0F2C+K4hK2Ms/q2mhzp/JC+1KbfUfARsyOwS2CleqsRxxrCAb0gFRkwNq88xj6RYouNojd9hB636OFVz+nbO0GDLYVp1+15G24YV61CDSzfgEQ0yns2/rdD5t01MVOZwpokjoU5gUIggs8iaD48q8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(8936002)(4326008)(6506007)(498600001)(83380400001)(66946007)(921005)(2616005)(956004)(86362001)(52116002)(16526019)(8676002)(2906002)(26005)(6512007)(44832011)(7416002)(186003)(5660300002)(4744005)(55236004)(1006002)(1076003)(66476007)(110136005)(6486002)(66556008)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/WR5cFbtFdcinwoJQZDiJCLx5DqhiVIasu7pSEZlOxph2uYZ8UzwL2zM6ZLU?=
 =?us-ascii?Q?h7o2utk3V58bHN2qjMfKbuVrCZlvmSvm/Y44ikVsApZAJpQZP/2+L/XFQKAS?=
 =?us-ascii?Q?+EtzF3nKCoBAqsAsGUG/dyNscgsTBAbLKeVrt05dMzED9i/BazU8l7R+NGiu?=
 =?us-ascii?Q?6E1oyqEwU6M9ismtYynLN0DxKMwrxZpIGUAuL5fQkLaRiMiXzxyuueIuqtmZ?=
 =?us-ascii?Q?RxFF2cR+1zYqLfXuYDWu88GNrUYWjjPS3Yrlzn1T+MZCN+Z3FsuxwyiGV8dX?=
 =?us-ascii?Q?qMmw7gCnT522HMf8KwQ3ZZkZm3KI0YwMzPZBETPlU8B4xATHCxHafx+sr5qv?=
 =?us-ascii?Q?lHwRZd/slePpUgHoPVmQ1qrzelz1e06RA1/pErkPxbEMxLKHT8/ZcH7tMsM/?=
 =?us-ascii?Q?f7d17pK9OzMx9MNPsGA8wI1yaElbo/yvkPBPUD5uGKBmlFxx4U6SGNf3qMq8?=
 =?us-ascii?Q?GKFulpTFL2bqzTBs99hnVdHPGHOpNhaUcpaEFdYY0dBnT0JmNQML6yXrOoCf?=
 =?us-ascii?Q?e+SUM7WfuPhY4OvZ/wRpvOMet+YXowGn5F69BfNjiUT7Hn1qPOvlt/DintFE?=
 =?us-ascii?Q?oTdRAJhBoBaFomtI+OQ5Q+OofHFWLdIULF34Glq41HAm5PXmMRyTu1TZDJdn?=
 =?us-ascii?Q?1xpZXjDFdASD/VgoXzlecdZY5JycTxUzpffJ1Y5gk+Wo0ou1I1XTGse+/x0W?=
 =?us-ascii?Q?sir14O0zMg/86YdZMAta9p6ixc2ZTyRIJg9GZbq2qYEAGBqaTS3ENlguDbzt?=
 =?us-ascii?Q?6ipvhAiM6MlaoGAiDmTMpAK0odM0SMA3lSqwpY534FjNMoaD16eXAjdBZHhM?=
 =?us-ascii?Q?clM/oZHXjgDOzlf6VrFhZg743ETSF1g4R01Ed5OyuPxDGwqLIcqc985dOVkP?=
 =?us-ascii?Q?/biRhqc/5q3I+xXDnJQ2+ObW/bEMJJGKvJA7I7DO8SRwtPyFIXfkU5SykkeC?=
 =?us-ascii?Q?T5t84UzwauPVudIGUOst8aC6voTLaokgSXKAiJhdROt88nMZY9UoZsIfPT9U?=
 =?us-ascii?Q?WIr7?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 16:44:10.2671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 88429c5e-aa01-4818-be9f-08d8a118a5a6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pBGf5ov+yKJEu+A+8JTYJpNLPBW10KqIgW1IZQP7Am07hNMzuCozY6xWsKNrqSwtVlu9dCi9avbz2nb3hidKnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor of_phy_find_device() to use fwnode_phy_find_device().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v2: None

 drivers/net/mdio/of_mdio.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 4daf94bb56a5..fde76bee78b3 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -369,18 +369,7 @@ EXPORT_SYMBOL(of_mdio_find_device);
  */
 struct phy_device *of_phy_find_device(struct device_node *phy_np)
 {
-	struct mdio_device *mdiodev;
-
-	mdiodev = of_mdio_find_device(phy_np);
-	if (!mdiodev)
-		return NULL;
-
-	if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
-		return to_phy_device(&mdiodev->dev);
-
-	put_device(&mdiodev->dev);
-
-	return NULL;
+	return fwnode_phy_find_device(of_fwnode_handle(phy_np));
 }
 EXPORT_SYMBOL(of_phy_find_device);
 
-- 
2.17.1

