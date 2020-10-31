Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBE82A1535
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 11:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgJaK3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 06:29:49 -0400
Received: from mail-am6eur05on2066.outbound.protection.outlook.com ([40.107.22.66]:21857
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726817AbgJaK3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 06:29:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Umb5meEEhVgi+iWAouC8e3kg1p08dzvGLkwdW72mywbAfCLqLBaQz64tF5eC+KlVew0vYK/7mY3cFP95FEkmR885w46wiqyF7nBLhx4U64fFo2bJQhEjjZpMbMgymxiAiNEXFc/3gry8gBE3oJCXyAOyRr5dveGuP0NE93n/iaYo4x8/a7g8rj29XcSFwt49xXxxMM/oeJY2sg6modcQsDTVz5w454Ba/7s5M9xvVDBvzFnoPTThzaKUP9BhYFo9LVdO7N+/xeOntNlw+MVwAzID3B8BEG6NEGdXQ+eAIdpayDxmS1DxKlcN+vE7PcYz3MwLvT5peJ7p/akS03/AjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unx2aMOmY+VTg8Xp9XtWQhYR5iLDGJQ84YDwVMPckSY=;
 b=bpbU4M1XKnvEpzez/J1gYmj5Ns4Rf+UZ6UZ5+XnQLv/dSAw7fawWNt4X7OQKSFq+IkCZ7BMIBKOWx8bA9YVSpxTs88e1irgn8hL9tgscAQQvp+7GyoDuTZQGMj+8AGRh0VrD5CVLMl6uuksRpQgQJANIbouK8Bi3s/zmOdqIu2b1IIpCF6k/PohQ7UkCIDEgtBw7i6yiV8dDBDH4GlJ13ZC+JsHQUPLgR+dCC3YNjm1oSjh5ZE2wHJoDm0JRoT4kI3izUyA0GAbdGvUrDcyKfHE6sbNgkvKkygyULHWpLBK0Kfw/hKrBWXWMYv+O6wGSXYcWQ39+ltd5RbXy1feC6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unx2aMOmY+VTg8Xp9XtWQhYR5iLDGJQ84YDwVMPckSY=;
 b=B3siLmU2LwvJt1x1gEPw/zjPprX5ACzxyWX7inL8sRj/+p1z/TIbXc/54MUl8M0oygoHeHScYLVVhXH8yPz3LBk3u9tUFlwUoY0YQf1r0jF9M9t/uAZFxFbLOAzwbwHB2HeRM+2bO9WFatSlSE+vIFOguKvWFj6uOtLM2jnsOpY=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sat, 31 Oct
 2020 10:29:32 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sat, 31 Oct 2020
 10:29:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/7] net: dsa: felix: improve the workaround for multiple native VLANs on NPI port
Date:   Sat, 31 Oct 2020 12:29:16 +0200
Message-Id: <20201031102916.667619-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201031102916.667619-1-vladimir.oltean@nxp.com>
References: <20201031102916.667619-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1PR08CA0170.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::24) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1PR08CA0170.eurprd08.prod.outlook.com (2603:10a6:800:d1::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sat, 31 Oct 2020 10:29:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e5666def-93bd-4b39-de26-08d87d87dad3
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB66373B0461D9E900195BF471E0120@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MacUdIsrifMgLPXp8BpUaQMLtg0hzSJtbZeLQgHLWVUqKw4LEMaSxNpe4FItB/J2d39hfGess3hph6vuVYeOeOVTpZPJdk2NEvq8a0EnEyRo0gXIn4woBAUZ0XLQe5+m6Rz9U1NMtxnvvwWf30rEvt52HLXisLXeO8I4iDazWxKyTpXWE9aM/lI1MHiE+OzaHaSV6TdSSxZT3bSnOs4KJm5408T6qFYTSQM2Q/yQxmJSieRA/Ok72CyTfzimVlt0YlnBhDk0yrK5PI4OEiJUywEPBh0lUyOCzldJlh0lJxe9Mws+yHFxMHAZ2cBTq2ujqUGNrMQpcAwptOWsaKyCoTJaQa9o1/GDkU5WMespddLgUAe6GnrSE23NmciPJze+aEDuS8iYQAT1WG6Brm5dXQY2GpCtFgIGwmiROKZoo9Ul6MZ+mIAPFx4BGqyXvdJ+LCkJK5ZNcNF1i6vDvxVCj+clthnt7JD1oNiWFz5R00Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(66556008)(1076003)(316002)(956004)(86362001)(66476007)(8936002)(83380400001)(2906002)(110136005)(66946007)(8676002)(36756003)(6512007)(6666004)(16526019)(186003)(52116002)(6506007)(44832011)(26005)(966005)(6486002)(69590400008)(478600001)(2616005)(5660300002)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ey79N++9ERrJmm6EKBCTZCvRfwk8fz3ML+JjLRrKe09ezsTPUsdhUd6qCy0r2sicY6gkBIQDZYLD30ApI2F/LMZQUOTAIgh67bW6820otrmIgRPUQlQB62N7YFm7u8eKC9u6bSjv5mAFBp0JHup4nplFo5pfqU07jyUuwEliC9ZrQVvyc+cev7di9uRXRpVkhU6cQiab5kGZ6C2tZGlN2L+W7zFOjFOxM2eBb7pwoeTLyVzqgEYgR+63k4beAHVwZWTCN4CXiQjI/5B8izSqx73IOMVTsv7fhISaj0Pa4VEz8KJMoNTvYK0+yKdOabt9mj16xVGOorzst2LmocBCV4jGoVRtIRQGkn5TKhhX9tFYJ7XODB1GiJnHe20WcBp2sSh6qU/8epXc4z6DixvI5NaXg3vEGZ7/xHZZg3518UCjJddKetM3llAeniq3n/Bvsxjq/4wh8NOXJ5+eQaINokjZ9AuL4EmkCBJyLqtwQgsj+dO22wrDJ+HzY5XK51nsAPfAd4ulzdrK3bP3JUIJOGnnztoIqcjqHMR7lj6GYpDGf5wq61cyxSG/viHN+Y0vaPZgHH4J4eQwuFG+UnChbH/ahIEcnN0n6Lk7LOQFVrb0CXurrQgBGZzyl7RV9usg9WvO7TKBTaQAJlCw4Vj9Bw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5666def-93bd-4b39-de26-08d87d87dad3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2020 10:29:32.0558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 06hyE/3HTveHLNPzN1dEagoyusbbSqlsaSmr1mQKHNeXqvgfysi85Cf0NvKfa+SlUe51VHoa7MwhIt29rcne+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the good discussion with Florian from here:
https://lore.kernel.org/netdev/20200911000337.htwr366ng3nc3a7d@skbuf/

I realized that the VLAN settings on the NPI port (the hardware "CPU port",
in DSA parlance) don't actually make any difference, because that port
is hardcoded in hardware to use what mv88e6xxx would call "unmodified"
egress policy for VLANs.

So earlier patch 183be6f967fe ("net: dsa: felix: send VLANs on CPU port
as egress-tagged") was incorrect in the sense that it didn't actually
make the VLANs be sent on the NPI port as egress-tagged. It only made
ocelot_port_set_native_vlan shut up.

Now that we have moved the check from ocelot_port_set_native_vlan to
ocelot_vlan_prepare, we can simply shunt ocelot_vlan_prepare from DSA,
and avoid calling it. This is the correct way to deal with things,
because the NPI port configuration is DSA-specific, so the ocelot switch
library should not have the check for multiple native VLANs refined in
any way, it is correct the way it is.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 3848f6bc922b..ada75fa15861 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -119,6 +119,17 @@ static int felix_vlan_prepare(struct dsa_switch *ds, int port,
 	u16 vid, flags = vlan->flags;
 	int err;
 
+	/* Ocelot switches copy frames as-is to the CPU, so the flags:
+	 * egress-untagged or not, pvid or not, make no difference. This
+	 * behavior is already better than what DSA just tries to approximate
+	 * when it installs the VLAN with the same flags on the CPU port.
+	 * Just accept any configuration, and don't let ocelot deny installing
+	 * multiple native VLANs on the NPI port, because the switch doesn't
+	 * look at the port tag settings towards the NPI interface anyway.
+	 */
+	if (port == ocelot->npi)
+		return 0;
+
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
 		err = ocelot_vlan_prepare(ocelot, port, vid,
 					  flags & BRIDGE_VLAN_INFO_PVID,
@@ -146,9 +157,6 @@ static void felix_vlan_add(struct dsa_switch *ds, int port,
 	u16 vid;
 	int err;
 
-	if (dsa_is_cpu_port(ds, port))
-		flags &= ~BRIDGE_VLAN_INFO_UNTAGGED;
-
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
 		err = ocelot_vlan_add(ocelot, port, vid,
 				      flags & BRIDGE_VLAN_INFO_PVID,
-- 
2.25.1

