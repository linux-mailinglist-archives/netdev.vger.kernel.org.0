Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21EB94CAE6B
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244984AbiCBTQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244982AbiCBTPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:15:54 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D2BCA70E
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:15:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hAhbtbwFbhna0KUT8zG7PMJ2K7lZvFF8WFvdTAGZ8hcwCWo07I7CvuViFZAYlWc2ctZM9SiYI1QWti/Mt1apLCcp6WC1if35rewFS7LINmJ3LpNPx9JFQw9emQ7f7qkGoigMBx7eTOVZDjuhETh6nnA/iId7pQ8NJYQTi/HPPQpzQospmB0KL+YfM/QxjRnXvFh6fCLUdx1nqkUYCWI1O06AFgV/lZeTX02WBu1qdSsMarVgHIWlEXO9lmu5KH96u1IHnO0eh4vWG6IM5oKuVcTfDLprwdmVO6YYdS6Wne2ufeRJNclh281t9uqrCzgxIsAHtY8WjOWffRH8gi9a4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=44zvX7TSGDwqKDgMhq265154VL5NUDSBTkTq+X1c5yI=;
 b=KSSNFNHJlwICf1OASavZ3ZcZCPaQvn8VQwHOjTVe6+fNHtkrO2W/LFc2JBzq/FDrDdmmbJIgxiiB/dATjJ4qnDCgW/6GxJhdKgIEcOailEZp7rw2K1xkRApqLs8fW1q2pkK7zi5/S/7GvNLM/IN+2fDl5KNgwzdW8hvwQOgvy8cEs7k100mTrlTdm1IqTolK98g6mwByBdAtBFlBgme7cxV5lGwUviKIsSjJbfq8hgA8H/TA37sofDcrd00VjanyiVhX2/FW/4mBjqVVaul1/shX1x715L0uryMkynBJS7wdbtAqcUgCKUsvfuY20nZ9UQ4y8GhwNtskhw+OwA5FHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44zvX7TSGDwqKDgMhq265154VL5NUDSBTkTq+X1c5yI=;
 b=JYb0xCdB+qf7nP+8lFtK2nlqykzD2a5loBKeguQD+gM4gJi5MQeskzT2tFKZLZDrHFpD1WRvTOWdj6HJcD73JsXiuLq7XlvQ9wWl68k1VBwyfJVOBqap/ogPk0nHpWtlDcU36M+dP+hlM2qeVsTixYt3AgPtZTVG4Sf2Y4gziy4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2911.eurprd04.prod.outlook.com (2603:10a6:800:b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Wed, 2 Mar
 2022 19:15:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 19:15:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 07/10] net: dsa: felix: migrate flood settings from NPI to tag_8021q CPU port
Date:   Wed,  2 Mar 2022 21:14:14 +0200
Message-Id: <20220302191417.1288145-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
References: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR05CA0030.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::43) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ae5afe7-ee3d-4b36-ac40-08d9fc80f224
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2911:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB291112748D6853A4A7473B72E0039@VI1PR0402MB2911.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HRD7Egz517/ySrzZnfvsMpDrXknOza4v8veXhat3VGIWvqqQOmizEwpRn1WIlL6UJctq1WQbe86QiBpWMHcm3r0q9zRpLFQAGuQedutqy/CGu+sUj1cM7R4oFgBFxKD8ru47TJ7lOb9HLjpE2ykldhSzYkMU2xBTkmKDXaO87GeWfWsNPqKL1U1FpG1ZKZFrTW+bj8COJF25GtD6hvSglFg9rN2Qln/k2y9UnPKLAHQCjezMVjbPQHbm6GP3CEXqKbOJYZNanrvQ/uQNLDwMNZeScTn5HD61/8jNAO9s1ODjMbnPFuzBSB2dSTmXG8fGzeMWQls6ZDKoZvZbOUma5Fzw3SBILeBItOYG8LMOi6xNg5sUMjbxWiZsPVPwaPoEGo8GWsnRlkGL96zyBCj+H7Tu6Z7MsBJCa9tahYz2evR2z0Ja8QQBCw0++jeHvVibWUHtoqgZ9K/IMkJsdA9kc1z4VPGTl9XOVvcLQXsIGzv+I9mN4T+rtJ4G+zjm9qTXcAa/rvx6IjGbauhm9r8wkf7t3BPROXSsQSSUJDtiH0oOIUhFhbH5EKWMuZnLiuDSQWw+mi3jJ8oG5YfyMaxq6cj4GN4Y7cZzpwnYeE3RTSJe+kMU8VJ2EpGAUnG02mqJuYCQAsD5eregbC03ddMMpLpVZEU/1vmimTCLWOUdhk8ZjRoCoHWfhYacv6hwdD8XQDaKDqTmWFX1qBszt3wVew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(316002)(6916009)(83380400001)(5660300002)(8676002)(4326008)(7416002)(66556008)(66476007)(44832011)(36756003)(54906003)(66946007)(52116002)(8936002)(38100700002)(6506007)(6512007)(6666004)(38350700002)(1076003)(2616005)(26005)(186003)(508600001)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uvPj7dTYm4AzMasKWrc6WPuUhq51eMNM5UF8L1HB71JOAypg0b/G3hE0HYb5?=
 =?us-ascii?Q?LJxl6nnzTacYmnmKsrDD0N+2RpCBVKsDy9RAqSGIZ3jam+mKhohm10yrqGft?=
 =?us-ascii?Q?LXp2ZMEtY8b5GOWYs0bXatxZUqzJ7l4zjEZyHS/7lrn19tGKVkCYyp90tqN7?=
 =?us-ascii?Q?GqqkQzMWkY1W5yiPK6MjvEXc6DkeqWjmyNxtw53AqYNDE5PnU/Rhh6KguJzb?=
 =?us-ascii?Q?cYUacUMtRFdTBVZAoi6ARm/j/ke9JKb2d/AxUftE70X4obbFMc9ens3ZCOkO?=
 =?us-ascii?Q?W0qTg6k2G/25rmlD+KPDmgU26j+ccXxkD3z8ZPzvY19KAagIPZGdlKbgVGFY?=
 =?us-ascii?Q?yHrNuaPBjVB5Lovmxt8iym+VQo77HByZHs/crZia7z2vcMqJNmLopgCqckP1?=
 =?us-ascii?Q?GVq3lQoZWdJgtOvTzod3UY/9I9Sb2nZs8lIz/Pm5WAxRftGmSES6CJcPx9Cz?=
 =?us-ascii?Q?Vphfo5yxLWTArrGc+Oxg64A+NHU9pwWomiBA6vrm5mLr7qzUWzndamEaNNa6?=
 =?us-ascii?Q?73SdNIJk17nYWew38mSn1YiglUp0Ne1MzQPE2FMmGFe8RGv3OsdNDPbQ7Nwr?=
 =?us-ascii?Q?Jhe+ok62WfKUFn4oagit1mCQiKcB64AIl4kd0mmsLJgitwNzybDKAdOZnz7M?=
 =?us-ascii?Q?opB3UoMmLj+DJuWghXOiT7v+Lc39C9caGF7u2a7bJCIDHqEDNfkmAzdVMTra?=
 =?us-ascii?Q?Q4PT6sYax2/Avb9A8L0RxBf/b0ikJf/kBpmh8myPpECHct2Gp5FwXOEN8E0D?=
 =?us-ascii?Q?1E6kT7oC8qAn77HZ7pslawBSX4KL5KjExhNJRMyDZwGV5ll/iRqCNtUd5meO?=
 =?us-ascii?Q?DhXA5AH5urSGFYFTGvcUtnimJhZ3EZdIcr2h2cWQtOQ8PtPhZopTTGL0RanW?=
 =?us-ascii?Q?AZmb7/bKGE3KSqdfPTyhzJSDtC9XkOEmQhnoq04zS77O2j8fnPCFDmU1ENE0?=
 =?us-ascii?Q?es7NR9ugJfnuDfociBEzYreqpYwpZNofSzqmckU3ZyFurvjHV8XeQvFr/7kE?=
 =?us-ascii?Q?eRSMcaSJhn6Q0U9Ax6ZxuWDXcsVpnfyjZ75Gj1RqvXLvFJXtzJazU6JCgyTt?=
 =?us-ascii?Q?ebS4svxPVRbfoxyHteuWWd7iPBJF53nC6SQX8mL72HszSq+vvB1uzSuaNV4b?=
 =?us-ascii?Q?D5j4Ka/Wb9KYI9c+5fiZmTFCo/ltyGO6auuHBLV0Hbi0hamdgL0RM/DFr7bW?=
 =?us-ascii?Q?hdEsU6us+oSqOnwHBfju6eb5yMI9NttwVZXUQ2Y9rz4HsPL2lWnaG3XGlLUQ?=
 =?us-ascii?Q?7D8im/BLibbIkZdfcFViIDs20/1ytgpu4SPrne2ix5H3HgqPSU8F8peReEw6?=
 =?us-ascii?Q?/uOkeloP4jleAO059T2vAOUsjOvpn2GkxEuGHwELnCeqXSZPk76cbQhFhMzV?=
 =?us-ascii?Q?bI0Xb4JpvmMju0/IfRNRbC/uL6b+sGoQ/JKgwU81B1hnuyFBwt3SfrT/5gRH?=
 =?us-ascii?Q?olyA7Bk+xc1enUQoaUA98d2SZchkpjDEr1nxmSzIYQjwiRricUvm91AKYjho?=
 =?us-ascii?Q?bOu9y4Z+u3VVZhmJT9PpcaH/8ry2RhTV5hj1HpQ/xlTGZnhzLcN39g3xwctL?=
 =?us-ascii?Q?SrQSFTMSo8ApZQimNqcVBpx1lwEgxzfEhpBQraTluRiOl9hDREOpwVIFMw7u?=
 =?us-ascii?Q?C2mk7Bv8HFdoY6omRNsTY2o=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ae5afe7-ee3d-4b36-ac40-08d9fc80f224
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 19:14:59.9701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UEpH9d20iU4YFcWTb+7mY9VuJOfyXXcxjxzCypIyG1NMzwMGOk9RpXv5zd4e0NEmjwj2mHspMNpsqSnDVhTx6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2911
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the tagging protocol changes from "ocelot" to "ocelot-8021q" or in
reverse, the DSA promiscuity setting that was applied for the old CPU
port must be transferred to the new one.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 47 ++++++++++++++++++++++++++++++++--
 1 file changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 47320bfbaac1..f263712a007b 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -80,6 +80,43 @@ static int felix_migrate_mdbs_to_npi_port(struct dsa_switch *ds, int port,
 	return ocelot_port_mdb_add(ocelot, cpu, &mdb, bridge_dev);
 }
 
+static void felix_migrate_pgid_bit(struct dsa_switch *ds, int from, int to,
+				   int pgid)
+{
+	struct ocelot *ocelot = ds->priv;
+	bool on;
+	u32 val;
+
+	val = ocelot_read_rix(ocelot, ANA_PGID_PGID, pgid);
+	on = !!(val & BIT(from));
+	val &= ~BIT(from);
+	if (on)
+		val |= BIT(to);
+	else
+		val &= ~BIT(to);
+
+	ocelot_write_rix(ocelot, val, ANA_PGID_PGID, pgid);
+}
+
+static void felix_migrate_flood_to_npi_port(struct dsa_switch *ds, int port)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	felix_migrate_pgid_bit(ds, port, ocelot->num_phys_ports, PGID_UC);
+	felix_migrate_pgid_bit(ds, port, ocelot->num_phys_ports, PGID_MC);
+	felix_migrate_pgid_bit(ds, port, ocelot->num_phys_ports, PGID_BC);
+}
+
+static void
+felix_migrate_flood_to_tag_8021q_port(struct dsa_switch *ds, int port)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	felix_migrate_pgid_bit(ds, ocelot->num_phys_ports, port, PGID_UC);
+	felix_migrate_pgid_bit(ds, ocelot->num_phys_ports, port, PGID_MC);
+	felix_migrate_pgid_bit(ds, ocelot->num_phys_ports, port, PGID_BC);
+}
+
 /* ocelot->npi was already set to -1 by felix_npi_port_deinit, so
  * ocelot_fdb_add() will not redirect FDB entries towards the
  * CPU port module here, which is what we want.
@@ -473,11 +510,13 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu, bool change)
 					 felix_migrate_mdbs_to_tag_8021q_port);
 		if (err)
 			goto out_migrate_fdbs;
+
+		felix_migrate_flood_to_tag_8021q_port(ds, cpu);
 	}
 
 	err = felix_update_trapping_destinations(ds, true);
 	if (err)
-		goto out_migrate_mdbs;
+		goto out_migrate_flood;
 
 	/* The ownership of the CPU port module's queues might have just been
 	 * transferred to the tag_8021q tagger from the NPI-based tagger.
@@ -490,7 +529,9 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu, bool change)
 
 	return 0;
 
-out_migrate_mdbs:
+out_migrate_flood:
+	if (change)
+		felix_migrate_flood_to_npi_port(ds, cpu);
 	if (change)
 		dsa_port_walk_mdbs(ds, cpu, felix_migrate_mdbs_to_npi_port);
 out_migrate_fdbs:
@@ -586,6 +627,8 @@ static int felix_setup_tag_npi(struct dsa_switch *ds, int cpu, bool change)
 					 felix_migrate_mdbs_to_npi_port);
 		if (err)
 			goto out_migrate_fdbs;
+
+		felix_migrate_flood_to_npi_port(ds, cpu);
 	}
 
 	felix_npi_port_init(ocelot, cpu);
-- 
2.25.1

