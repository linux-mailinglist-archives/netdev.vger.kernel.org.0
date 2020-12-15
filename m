Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B852DB209
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730147AbgLOQpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:45:55 -0500
Received: from mail-eopbgr20071.outbound.protection.outlook.com ([40.107.2.71]:62181
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729543AbgLOQpr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 11:45:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6gcD8ry+XE4gg8ivjAb+t8iGf2fYypLR27vSI81s0VR3XukEnOVyTqy9zN+u9K4ooAE8m/94g0xSjddeQomPUzsorQKDRCD3KGSIN5FGjCg53FWOUkMSi2MXCD5uNtzH4ryTHvScIxQgBl6So5AqF0CtcnUhgAWnpbTAyYZyL4+PIpmaLNKpFIX+FhKSRpfbizFCnavw2lvpUsS7yODq4KDuxQHXO4eETrZw32X3MtUrkJJYHZfHM8/8Hu/pbRkNagqfozKoNUdJfFaj6yzatvJva8c99G0NnN2IeOHXK2p+jmp7ewqz9VNiRsPM40knTp4skl1xPtsZc5DJ/gNWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=asm2PzMG5yff/FKwtgbKubq/h7PudquNTP+i5mWk6oc=;
 b=htWJUbQnceuYHseJUTFTRhx/5+ZQi8+S37typQ1tyEQBwUhRsW+TGIJGrtPq7lPa5ljPBI4I7cd4edfbDmQEHk8L3IJHYDvV/B9CsqrZop8WbD9pqHLU+WkpnayvKII6h4irdhDWJWuadP8wBLhJU+5Vq86G1QDyUxP6QhkOH7Cb4XzvIiqb8w8N4reOv61MeKJAbS4kP+ohPU+e9sKRdKkPKy/h4bP8UB+K7GrFEKiOU9kEoZcLfV1CWQvgYllE325k9cv2sjvNEqkw6fjXtB8nZfkKuxX3EbF2BqRU9gqCGBJdGEVF2d56m9BykG3uHaKKiCQrD9cBMkl9XyMJrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=asm2PzMG5yff/FKwtgbKubq/h7PudquNTP+i5mWk6oc=;
 b=OQDTKrX2EJTQc0NTkVGjs0GSt+qLlFnolirwSmb5DzQpQ2wQvhq+vuKFoEeZUk0I98Rq6BSQzHQuXzKknVi7ugNbr1X8Wz68RBeFa+PLZAiVX+liP1EQ5K57CUrTn1oTKoNNdE1gEiuTefaPgpr+fHZ5XZssesv7D05IERwzqw4=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6963.eurprd04.prod.outlook.com (2603:10a6:208:18b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Tue, 15 Dec
 2020 16:44:23 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Tue, 15 Dec 2020
 16:44:23 +0000
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
Subject: [net-next PATCH v2 05/14] of: mdio: Refactor of_get_phy_id()
Date:   Tue, 15 Dec 2020 22:13:06 +0530
Message-Id: <20201215164315.3666-6-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0152.apcprd06.prod.outlook.com (2603:1096:1:1f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 16:44:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bef3b0fa-4e7f-48ba-be71-08d8a118ad6c
X-MS-TrafficTypeDiagnostic: AM0PR04MB6963:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB69630C6F9B238D5E9631B42CD2C60@AM0PR04MB6963.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qAQ4LUxD3viAXy2BR3ol/rHqpLIUYW4njsZcdil0RP6KCcK65A7SXKW1EpFbJzG8jefkGzFk688QuR37hz+yieZM/+WIf7dba9ni1BRHlTYRLqt92QISbrqqm9kbPOyxrmRzbgkosNATyFyRU3p6CrV+0CiRycEHIiZHmvvy5jt0krssO4IXnTHR1SYchwwMSOJEVoOtHtxEyN9kHtBTjTLDB56GfKM2QOUA6BSzEcmUURVkl9uwmJfG+YMPWPTnaQu6+iYH8M3ov8gi7rqeVOGbI2Yzbs6fbqPo3DFHoraSIY2UEpzl47KUTAMJgAQBl8V1X7P6gl2H94bDXm+Ya4wT7ONW5boYiGhaFZYepzDen3TcC1cZWZCIFm3KvQ+pcOU/ZnOyKVT0NG4pwdRMrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(8936002)(4326008)(6506007)(498600001)(83380400001)(66946007)(921005)(2616005)(956004)(86362001)(52116002)(16526019)(8676002)(2906002)(26005)(6512007)(44832011)(7416002)(186003)(5660300002)(55236004)(1006002)(1076003)(66476007)(110136005)(6486002)(66556008)(6666004)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?S0mH11kB8AvtWWwJDFpjl0Ao7KwtkJMYA31eoyh8GCMBhL1t8vsvp9WIwGjp?=
 =?us-ascii?Q?YC3xlqW/3D1lz3Xg4/X6kmET8+jFa9JDCgGpPzbEuuC2T58MR3PC07qLn67i?=
 =?us-ascii?Q?T2Fg7XoRFJXZDpkExFJvaDM1CopdRn6/FyJKS+PYzEA3gYGouOKYfhdACa7l?=
 =?us-ascii?Q?2zOdYLHjpTAc8mT6BagOICSiI/QwIM5IvfMAC/Q5pDcAfHKaogX/tQnNxIvm?=
 =?us-ascii?Q?YpEUSq0DBnQ4MQx8+dfOMMvg9jilpqn4HeFxcT9ueLU1sVZq1PAS/08asZzj?=
 =?us-ascii?Q?/cKEVmQ6XOwC2B8haKAPomOmuwZ8m+U34u09R3/5GG4GO/Tl9APuGafOspWe?=
 =?us-ascii?Q?/ospbHYeISqVA73Gvh4DhlBpRp5yorEGbRX45Q9+7+F6fk4ueGGyE2RP697d?=
 =?us-ascii?Q?c7PcvTgBRs01ezU1KFMQIkpuoC9yKIh/Nw8EHHYM+12P0K6iZT6FM+nzlal8?=
 =?us-ascii?Q?6JzCZNbiKkMCjWLpmiOmoyUkKXwIvTfkX/nAalJAmlGaMFhujNIyRCZKtwtu?=
 =?us-ascii?Q?a72JgTDg5gM8KJHbgl1YPvmG0wR7UZeZ2oP46fQw8lNbN181t8OE0pd/2Dqi?=
 =?us-ascii?Q?K93ES4qUETaqiauiDqRHX7KDW9lfVrWx2/88YqVjsfsggLrBDpEia3FUT+jc?=
 =?us-ascii?Q?uWGqud+FhTiuQcI1oL3b44Xe40ca7WXUxmvRQROSvUXCagcoo5ijly14RtMu?=
 =?us-ascii?Q?Q+xOAxhqYrM4mneS9qYoRkJIMfL+bb91ObQm7+T1yv03nOLuKvlERXNXNtIO?=
 =?us-ascii?Q?KBa/+I8WYu3d3EEvd0IBsJO9+CtmoSfdLuT4nlx8zCZvML7TR8JSEk+Dlx9r?=
 =?us-ascii?Q?fV17ao7zAyGc9qf1ts/B0CpGtu/BjPhNCV0lzzevJcxdLTm5ezs+o78s6xtM?=
 =?us-ascii?Q?ZBNs6YQPMJbwHx2nRTmt28TIhUSoHTU7SLDrRT75XEwHRqF4eiN9aavbMInW?=
 =?us-ascii?Q?b2N32HMMTQnK81LPws7v42LLqB4rsHcX+CDMW/bQRW37e1bfWsIYIY3hVKkX?=
 =?us-ascii?Q?PESM?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 16:44:23.2957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: bef3b0fa-4e7f-48ba-be71-08d8a118ad6c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sMluvdSlMwm+frMfcvLjM61fkMIKG3JUIar/+4FQINcdREep/S49gkGnAdQmw7tk7x2oJUxJMwAHZ7dUpuvbIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the introduction of fwnode_get_phy_id(), refactor of_get_phy_id()
to use fwnode equivalent.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v2: None

 drivers/net/mdio/of_mdio.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index fde76bee78b3..31e6435dcc9f 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -29,17 +29,7 @@ MODULE_LICENSE("GPL");
  * ethernet-phy-idAAAA.BBBB */
 static int of_get_phy_id(struct device_node *device, u32 *phy_id)
 {
-	struct property *prop;
-	const char *cp;
-	unsigned int upper, lower;
-
-	of_property_for_each_string(device, "compatible", prop, cp) {
-		if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) == 2) {
-			*phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
-			return 0;
-		}
-	}
-	return -EINVAL;
+	return fwnode_get_phy_id(of_fwnode_handle(device), phy_id);
 }
 
 static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
-- 
2.17.1

