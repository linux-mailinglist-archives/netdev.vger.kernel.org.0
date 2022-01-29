Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCD24A323E
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 23:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353447AbiA2WDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 17:03:07 -0500
Received: from mail-dm3nam07on2115.outbound.protection.outlook.com ([40.107.95.115]:64192
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353318AbiA2WCt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jan 2022 17:02:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aox63QadoRbZsr3WLN86LjjmAMuUFtx08D4EwhIEGMGSEvJavpGIRsG9kT++y5SlERHlA0kYxRQNk+lhW1scnfBD8Xg9Iv33+v2vN/X/A6o3lwU1o2XCEqf5Lrx+UJb5a27noAnjQXJ5zJ+Mh5Dad90pdV+J9mioqvcIYiJSGzVxWzK1H+vuJNhZ7S+vuKINYDBIpf0xAR4ng4sJKubZdPuAcLJRRFuoBzxPA4j4uSDPvTkrXVg4J7IR0EqBacNonu18KJbOsYmTIqZJPCjQH+6cBp6+CLyJ8sqGIIjFJEjHlQ/SLX1ADa61g7u25lDEshQVwKb9UUVsxgnpQkH4xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kPqlrLClhdoNYZoHVi+ysGlGTjn1dpJbc6IvRsKbuY=;
 b=RZCNBMhPdItiHCEw7nXoH4ThT/rlnWfK1Jj9Kb/Ylmiss7u/SIrHdN7S7jqplpm2Wl4bGHHyjJ7lT7XyfLT48eNsEDgUfQ9hhOp/xKThX6XabsBjjYO6Io9LUOC+YSBwYY63AFivQYHjxJPX7iLSlX6Xp2UzykTaLAuVF4Ck8zlyz2TyCf5bnKy20toGK028lh8liris7Cunu8wd+qfEPA8YOySQYjhBX1ikExFWaxqE0ZsngXJk4JAMwX8VIeeKtGoFiot+fIoGtsREDN9YV/RM/O6lna7fMpyDeri85YCsfUnbjX6nDAD+gnRBqXEJx6V95KjNFifmbwQ8e3CymA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1kPqlrLClhdoNYZoHVi+ysGlGTjn1dpJbc6IvRsKbuY=;
 b=xsR+DdspGYU/kO2FMAXUbbU12gtsIHmbRFjTfGW4hvduUgfMZCPaxo5fmmkzPFCNNOVfTCJgVN4iBvA5qyrHhZxWaIOLIGxBUAES9B+hH2t1hQ8PMnQLuP+BYuzzgs3u8PzuEfbv/UKRkbgBtzpz2RP8/l2fpRFHkRhQS3CVmDw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BYAPR10MB2968.namprd10.prod.outlook.com
 (2603:10b6:a03:85::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Sat, 29 Jan
 2022 22:02:45 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4930.020; Sat, 29 Jan 2022
 22:02:45 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [RFC v6 net-next 8/9] net: dsa: felix: add configurable device quirks
Date:   Sat, 29 Jan 2022 14:02:20 -0800
Message-Id: <20220129220221.2823127-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220129220221.2823127-1-colin.foster@in-advantage.com>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO1PR15CA0113.namprd15.prod.outlook.com
 (2603:10b6:101:21::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7261dedc-d4d0-403e-89cb-08d9e3731458
X-MS-TrafficTypeDiagnostic: BYAPR10MB2968:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2968443762557747CC2DE862A4239@BYAPR10MB2968.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qnijt0nQ3SJZu7yJKWHIGLNNeQVinmJ0SFAj2O4LuibcAjgHE9/oyQiIIB15y9hAQhmoLQq0ot/RLzx4TbpriSuSJnHMJRnKjsplmdxnbe9DoVUuca7DiIyz1xBaTplqUS+UueoL+HAdKpZ2Su13UkCn2FSkepEBiJBN2VxVEIL4NfWijlKzQjjWVtfmfoJFYEf5+9BizdDlPfJgjtheGh+7Z8m8DSpmFvJtOOuBhm49bJiuFPc8nxlTBF2TZ5F8V0PoSESsYtXkLZA5anOXiVzedkaNrPZ+gQ7dYRYGkjY/poLFW5bh3sZLVRU1cMA1gPghZvqo/ihU32UcennQatn6aIRo22hBah7otRbSCwbGt8dp9NQ1zbTGEn52Pu6QsSvcvHxPSheX/sJOJESpUFA5qxAWzwB+2p57FrZTf12/G5qCFdA1h0hrmLrJkZGS1GWYe5VYDoR6Dtlaw9byE4itkAV00+CzhftmFzWDl8C9e5xJAOm37TPqGe1LXieTcddhBhxOucY87POyisbRTJCnUd27UD8cYRqMyjj6eFABwOVpQ/tYV7Q3aUCo/VQgvs1vOcsxoWNGsMRLywf/Sy6Hw0A1EaAyJyQ0ReVPoS8hzAeLWBSvMICs55ZA3hkGO+oE2ElOfQ3Bg/A9+O+uzcqLsbmF8XYZzT6UbzpctvA4U7E20ZuGWAHjOZqYvD7DuMHyfOO32gcwGlBRfBZ5Sg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(376002)(346002)(42606007)(396003)(39840400004)(366004)(186003)(508600001)(5660300002)(6486002)(1076003)(86362001)(66946007)(8676002)(66476007)(26005)(4326008)(66556008)(8936002)(7416002)(107886003)(6506007)(38350700002)(6512007)(2906002)(44832011)(6666004)(2616005)(52116002)(38100700002)(83380400001)(316002)(36756003)(54906003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M7hQPUiyolR9tyoCUtQDPaGyCny7t/fyGn+GndiGp4PiCkM8Asr72Q5N1xGV?=
 =?us-ascii?Q?Srg2CwVPClcZRPkAwZlLp66ggHug0YVxXwDz5tIfbrx5biXxlNUyeeSNmXeo?=
 =?us-ascii?Q?Kpz+ByadBj/z1Jnznzcwfw4RWBtnAsn4ZL0dzYbZy7A6fqoEBOWLY+UHqtx9?=
 =?us-ascii?Q?a8jyRYwlWw3CX27/4Ru3wmUnMwyAP026tBNaO6CkHh6MqdGNEldMNlppEy23?=
 =?us-ascii?Q?QekDMtMiKSt4txKZoH2uyaGJ5DkeHzB4Dl+j+UlHbfWK3ChReF71FBTTOEou?=
 =?us-ascii?Q?kiSLQHj+4rqggstUL9olkUMRXSmXPo++lddWGuCwbKIsV7/I1MqyzFpuiHzL?=
 =?us-ascii?Q?pSIWU7kDINn1YUo77lFS+fhawirkWH/aOiZhWKoOjwppxWCS3FbXQzjZr6ty?=
 =?us-ascii?Q?SzAnmUAuiQ/yyP1fgaS5v8NFsVyt9yQcUYld++U0ugP2wNLIbiNtKGitGDoB?=
 =?us-ascii?Q?vRwEy39SFICwq7x1a5xW7/X7d7VdgJz4mOgfxvxpEZOmyUddt8KXNx+Exh5e?=
 =?us-ascii?Q?74rj76YtWBdVQknxamayQQ3NZ7vQy8DLtyT/Rh7qqvAtExZO9+bDL6JsPJR6?=
 =?us-ascii?Q?e+C9eg9mWUTkBmxqzBqwAawX58+xasmvUrspFcLodwaORjiuzjJj1pKQApiR?=
 =?us-ascii?Q?8D6mluwEAevmIR4GGokhpXX6Gm/xZ1ZysUFnHNo901LcshX75rSr03MBwaHE?=
 =?us-ascii?Q?Aj+sHISZwmy+Js93lx4i/PLMRqFULZSBS7J1DrpUnLgVybrNDjqcCDbDgtOj?=
 =?us-ascii?Q?EffOIWBU91yKscfTgHIKu9zVq5/aHrwDE7elcB82cUOeYT9yWACmey48c2+C?=
 =?us-ascii?Q?JuTKABwV8HaqukzTEOl4NnmYCaxktqQXRfpUSA4JQMfisIILZ0pIfPJS9ygS?=
 =?us-ascii?Q?XbAKxEbxhs1ZETIjTkfql2Awldg//rqlyCDZuY3N/CAe0NOCKEVDvzv42B1N?=
 =?us-ascii?Q?okCVraX3/PSJQwI0C/0q1RwQ3Bzuf1a2SfWO13oY96muHmALCjrqpRT2PR2X?=
 =?us-ascii?Q?AxGuKLw6+ky/0Ye7uesZK9gKn2CCIT+srUS46JpwAfESK6gR3pCWgyC3W6Id?=
 =?us-ascii?Q?xrxoRYZy5CWc3sZhlhVsK3GUXkCoD1K3/uq887brCgZtPz7JoZ7BjgufC5Zt?=
 =?us-ascii?Q?FTQp5iAP3i78Y62yfErAqi54IK4tDsDHlEETsvhouUnwr+PMjYjVew3OQpcU?=
 =?us-ascii?Q?17cRwTuB+vl5sgyArXLe/fAxQYFGulrDCh3xagGl92b/IhFJ5a9GZ3r7LjTZ?=
 =?us-ascii?Q?r5nopZAc+MkbfR17UW6iAUVTLUl4zpVXI/grUsFAIcy41UtlkW5XrgVvv6ZD?=
 =?us-ascii?Q?bPiYnz9XXXyJx+5uQUORF6/0PK4ELaBwPVvlkfNRpsz3YKRsIHw7Hecgz7EI?=
 =?us-ascii?Q?Q3EUV9DUDWHRsOSKt4H4SQievQuBe0IWJk0861aEG5N5PwwW7rN3MeZvdi7r?=
 =?us-ascii?Q?IYrKVBQOdG+ngJCNqyESo5yBp2WGKCiV0ix6EWnCndTs9NFq66AoFJOE35ec?=
 =?us-ascii?Q?uuR+SsNpy75m1JjdS3OQS4YCvGYEjbPasxr9EEh7gB6angTa9sI1kKo/W6U4?=
 =?us-ascii?Q?D8dXVdjabEAVkClyVY33DwFDUFtkwwqbq4pa5Ooa9uHabIMU7asapBRRl+LN?=
 =?us-ascii?Q?CNTDdg7krjHt0ZtLwB/7Mq8aae1xAQOPbqQYtS0H/0sfJjZtjMsM5XkvFEoj?=
 =?us-ascii?Q?uZFSMQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7261dedc-d4d0-403e-89cb-08d9e3731458
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2022 22:02:45.3445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CV4r4G4enX6jp66VspLvXD57vCbDixx2bMNAkXv2AT9MBTppxHts2ZhaazwRmdthYx3TKoCO98jFhlRQXM8slppLDYH9M4buOGfkOyc7cbw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The define FELIX_MAC_QUIRKS was used directly in the felix.c shared driver.
Other devices (VSC7512 for example) don't require the same quirks, so they
need to be configured on a per-device basis.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c           | 7 +++++--
 drivers/net/dsa/ocelot/felix.h           | 1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1 +
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 9957772201d5..4c086bcf111b 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -850,9 +850,12 @@ static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
 					phy_interface_t interface)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct felix *felix;
+
+	felix = ocelot_to_felix(ocelot);
 
 	ocelot_phylink_mac_link_down(ocelot, port, link_an_mode, interface,
-				     FELIX_MAC_QUIRKS);
+				     felix->info->quirks);
 }
 
 static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
@@ -867,7 +870,7 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 
 	ocelot_phylink_mac_link_up(ocelot, port, phydev, link_an_mode,
 				   interface, speed, duplex, tx_pause, rx_pause,
-				   FELIX_MAC_QUIRKS);
+				   felix->info->quirks);
 
 	if (felix->info->port_sched_speed_set)
 		felix->info->port_sched_speed_set(ocelot, port, speed);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 9395ac119d33..f35894b06ce5 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -26,6 +26,7 @@ struct felix_info {
 	u16				vcap_pol_base2;
 	u16				vcap_pol_max2;
 	const struct ptp_clock_info	*ptp_caps;
+	u32				quirks;
 
 	/* Some Ocelot switches are integrated into the SoC without the
 	 * extraction IRQ line connected to the ARM GIC. By enabling this
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index bf8d38239e7e..7e88480cc103 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2231,6 +2231,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.num_mact_rows		= 2048,
 	.num_ports		= 6,
 	.num_tx_queues		= OCELOT_NUM_TC,
+	.quirks			= FELIX_MAC_QUIRKS,
 	.quirk_no_xtr_irq	= true,
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index c6264e9f4c37..aa31f741634e 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1100,6 +1100,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.vcap_pol_max		= VSC9953_VCAP_POLICER_MAX,
 	.vcap_pol_base2		= VSC9953_VCAP_POLICER_BASE2,
 	.vcap_pol_max2		= VSC9953_VCAP_POLICER_MAX2,
+	.quirks			= FELIX_MAC_QUIRKS,
 	.num_mact_rows		= 2048,
 	.num_ports		= 10,
 	.num_tx_queues		= OCELOT_NUM_TC,
-- 
2.25.1

