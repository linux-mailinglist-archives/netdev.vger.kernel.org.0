Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6898159A464
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349893AbiHSSDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 14:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350136AbiHSSCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 14:02:20 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2079.outbound.protection.outlook.com [40.107.21.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E66876B7
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 10:48:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tl10Xpabv/Wh+sJyW/NCv+qF2DOqpY3mYF7S2KaVX2ViA9cULYVpuNk8EYkKD7L5HYgksp3sOZZAanXckGueLqXt9mS/pGZCcz8Iu3lwPGbYU4dBL4S+ewl0Rbf2NgRo9GRB6IMiX+x5D00vf909CEGoywglJ/NagsrwcHscTldR0G+euZ/twPEMKUR+WffCFfBIxvde4Hc1IbOUnaInZ8OhOn/fTY8h2hxtwd6LAOWFVaX/as1V5qGLOqcAVvR/RkLdjIRhnufyzF7yF1VHXpORy0vARHLDVg0PBnUPiR0+btIVsp60CofaynmHNHusEljtsEcRuWQBbRbkW0OzYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+w/zSZBEIt6ji8H/DzJt45Xq+vmJnhIMDFeU0gZwEOA=;
 b=bg0jwO0DMpJSOkra6ldWk1psHICTQUxpyRPWzi0ncqwude0p3BvwiM8Qp7KguGVS8NJC23mnG8QdvJoEadqQ+rSnP0MEdiVaaVHMgkCx+Qfxp7+onm4D4djL7Ej6kCtCiO8aMSzVyRgzjitvxd00aS3BwqEvtJ9VepIixIaDEZP/py3NYnupAkwQUY2RtYYn31pAJaK5vyoALDFd8FJYn8zPP0amQTqPMb21psfCrBSC7oadiHpcXYYdmPpv+dEtA1n0nOV2DOXvPzLmqL0zbsAkzy4ZXutWg/NySEt1HbA0JnvcJ8O1xABN8sh8gH18ZBfgp0+Xpo9Dus+XqigfGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+w/zSZBEIt6ji8H/DzJt45Xq+vmJnhIMDFeU0gZwEOA=;
 b=AhrZZClo+QQ3ECUrgQcx59nJk1Ip18Qz54IsDQZWROJ62MpT1g9QmXGKSRBcfDEIAfmljsHb9xKKu7e03q1NCbZJs0HZUENJVZNxqYMKxje4b9bkVUwumR1l/aqXc4sVsM2AI0Z2eoNjGVgNj00JthPmDZwqSX/Wk4emYDPXjwU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8551.eurprd04.prod.outlook.com (2603:10a6:10:2d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 17:48:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 17:48:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v3 net-next 8/9] net: mscc: ocelot: set up tag_8021q CPU ports independent of user port affinity
Date:   Fri, 19 Aug 2022 20:48:19 +0300
Message-Id: <20220819174820.3585002-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220819174820.3585002-1-vladimir.oltean@nxp.com>
References: <20220819174820.3585002-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0044.eurprd05.prod.outlook.com
 (2603:10a6:200:68::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a61a9ae1-20c9-495b-b6ff-08da820b0da7
X-MS-TrafficTypeDiagnostic: DU2PR04MB8551:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c3HcwaDdzKwKppFVKAYggp+iIrubpYO1FZy5LZzSUg72PV3cxCB14aEppQx3ttGVLIqjLABH9gF2rt9Y03Usp7ZqzidXmcbI+xBRpCt6SZu227v81ljsOvJ/cDVfVcWh6qefKxjjVGyp2XgRwuGZ/GmQoJDf5IKyELPuGONAu64Nq4TwbaIXEuUegcrSQDLXvGNYDaPrpSkeVzWtfadRJdAKueLL3nzBVO+FLCMqp73p0coCOYCx8Fr+sczI4oQJZuvATeb5EYIFVAX6uDNO1HPD1m0WSR25wtzrjWjmAaq2768LmJj77cAKzENKIXTW25HVPIDxSqkCx4hf8LsulDcqcRjKeaAbcp4SbkqKL+J5CXJQLNL7JAK6CbMrlYi8GaPeU2BfCEwKkfNGKpO5ZZDddEHhm0okVKLAw9VLzqQF0UryazsDjZM/PF0x6N8RFIPD18PVaWDOiyTpj30278N6wmCMKpxI22glCuh97ui2z1nEdLjAwDPfo+J3rowvv9CHCxtoH9ID/0vvy3L907D6EUDpzXRYqB6MWj0cND3bykgNVgNmHLuvZBZMTOnRhcY+S3Ezhf+EgDuwlAT7xylsu6kb+5PuKniqZrdcPc5OC56dT1ehsgs71jJ5WXnbTvHGQhn5W8FVRknoFmrVLbPVOqOzxJr+dmznauJ/vDwVmz7WXWn9JYoS0cZYHYCXtq9rgbjrTkNSh4lhdblGXtRsU0zBDfGbueLTpubc0AWVNH+6fXkxRkdWsJ8oO3uDV+rfUL5eHCGx1Rq4xQUpXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(66556008)(8676002)(4326008)(7416002)(44832011)(66946007)(66476007)(316002)(6916009)(54906003)(5660300002)(36756003)(8936002)(2906002)(478600001)(6486002)(41300700001)(6506007)(6666004)(26005)(52116002)(6512007)(2616005)(86362001)(83380400001)(1076003)(38350700002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QweDGFG6xylO87RJ2SINw0HE7ZJEICNxbw+R1ZALYENgEFI6OIuisb1WfiAf?=
 =?us-ascii?Q?NL7Oq0IzC5A793HxgKg32boHf3vPDqc9Qee7ljZqGvgQfQpk364hEPPDi6Za?=
 =?us-ascii?Q?r558Lb4IXhQZlvbNxrN/+7aJvUr3asqcHxEpjhPaTE3bVyrEXdDzGqHHqvZQ?=
 =?us-ascii?Q?MvAcieK6MBMrhuOIta7Py9o0JzSOfMasQ1AcfBzuRadGUnz2joAybrt/z37s?=
 =?us-ascii?Q?pAaL8EH17QeHjSaUV4Z00KVNgPZOPWX9X9q+UYrrcfbQwSO5iC9yr2JNH5UM?=
 =?us-ascii?Q?NA7vMLPq51vruj1lJasirB6K1C1G+XczvHa0z1k4KijfPfp/jxSO1zfYDOwT?=
 =?us-ascii?Q?UMgBYuWV4Xz9KHiVueOcnEcKXtms2PCHq1TLvdyXLN9JoQjRGNBoTZOD6UNm?=
 =?us-ascii?Q?aRKxZi0GflkeQo2dFrbp6AOLzfxyzghHQ9DwRlDO0Hj4bHy/gwpNjJu0CsaL?=
 =?us-ascii?Q?gqCcGHyT2zVIbo/djHyKPf+nO3pmuvz22+4c8jwbTJH4wO7jxr5SaZNRBzqW?=
 =?us-ascii?Q?ejtbUEKboIKfyUfmTP0pIyNyhXiMMMDtfHWXbCsQ5C8a0vhFQcwarfgAJOgd?=
 =?us-ascii?Q?99pUkEZafmHEOxSURuOZUO/6yHqlfo7tvNtcR+EPTpnAFpJ5j2b0ckpYOK94?=
 =?us-ascii?Q?Mp/jyQ9MoOvuvmb7sZvxzl2hoXoSgh4qFVLiryVdACUyrPGnogX8dgO1LXg3?=
 =?us-ascii?Q?PlBTjywveLSJiSBcfvaHkjIuw5cNEYYTPdSI0qjrnHfuhwQI7MevNin3GgG/?=
 =?us-ascii?Q?VgYVs6xVrI+XVTGOnA51NF0D/tFBRY+LttH/hcEbIoDfuLxUaLiLv0imz4e+?=
 =?us-ascii?Q?bb0mNIxEqixia0YR103hMBQs2sdDfcsXbubx8NPJbjGpDHildDGfUJlcM11O?=
 =?us-ascii?Q?rn480nBc+yU9Kgnbqt6I/eE3qWV3d/zFmQEq+Akfp0bvt1UICzCNlKWKen6i?=
 =?us-ascii?Q?TV4ZPk3IA7jsFtrknDb3X3R/EI2rO6HGvvtXq3D7qinseZLxGxtuAU19mBd8?=
 =?us-ascii?Q?FogrFvAYh4eLgBzIDRhRSjfsbvyQ+Gt7aoecmfyHvCbrkUozhZfKJGoNF9F8?=
 =?us-ascii?Q?7Uuvdco2xRd81Y5FQ8RsAnlDCeEhkHruX8NTmvWKoWQu/CdKz0FpuPzD/OhE?=
 =?us-ascii?Q?X6Z7JfpkmGcq9sfGZgsPoXFK85Y3L+XzuHHWogRoTFiWWZj8rF7FWFTaIAKB?=
 =?us-ascii?Q?2ZvIleYUSbzVThg00kN2khOWSSLMc7Oj4ezQukLBCllKEg+xN0bRCJ+hrqmS?=
 =?us-ascii?Q?of0Q5rddcJOcSzmGLG6zr4X9w/r2s0zivYB4JfcMPS0yvwl9naFLB174+dfc?=
 =?us-ascii?Q?iukHaZWWfXMpvI4llOn0I4Y5WrhqruCxgFkZH1tcQiizFwniIiYgRMU//YS2?=
 =?us-ascii?Q?IVab6hvBFyC0f1t46+acld/gMrKdZnA+jHse2b/Hz7+5OPpVCjy3i5wOBU9U?=
 =?us-ascii?Q?6oRU/vk5W2r1xENC/wMhUEh8Ncpz0PNeoItjNaK+lFM5tHhMillHWUcMlmM3?=
 =?us-ascii?Q?lJLKnPyQ35vgj/hfHBSjTGlDhtAoDz/9xG1SxZD8nkEWgKkfOQgeqYNSOPiw?=
 =?us-ascii?Q?7NeMjTZSpRPguQ37uQTUfNu20Zgu8VXbNTcNkdJ9D0POyUR4gm9aSd9N0DA9?=
 =?us-ascii?Q?8g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a61a9ae1-20c9-495b-b6ff-08da820b0da7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 17:48:41.3255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: STaJqneH9zWr40a/z2UvYT0NJgzMydUb2RbCp5ZGEzW7COmdQNlIhGcuy7Xb8MhOyIvDCiLy6129SNBUka9NOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8551
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a partial revert of commit c295f9831f1d ("net: mscc: ocelot:
switch from {,un}set to {,un}assign for tag_8021q CPU ports"), because
as it turns out, this isn't how tag_8021q CPU ports under a LAG are
supposed to work.

Under that scenario, all user ports are "assigned" to the single
tag_8021q CPU port represented by the logical port corresponding to the
bonding interface. So one CPU port in a LAG would have is_dsa_8021q_cpu
set to true (the one whose physical port ID is equal to the logical port
ID), and the other one to false.

In turn, this makes 2 undesirable things happen:

(1) PGID_CPU contains only the first physical CPU port, rather than both
(2) only the first CPU port will be added to the private VLANs used by
    ocelot for VLAN-unaware bridging

To make the driver behave in the same way for both bonded CPU ports, we
need to bring back the old concept of setting up a port as a tag_8021q
CPU port, and this is what deals with VLAN membership and PGID_CPU
updating. But we also need the CPU port "assignment" (the user to CPU
port affinity), and this is what updates the PGID_SRC forwarding rules.

All DSA CPU ports are statically configured for tag_8021q mode when the
tagging protocol is changed to ocelot-8021q. User ports are "assigned"
to one CPU port or the other dynamically (this will be handled by a
future change).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new
v2->v3: export the ocelot_port_teardown_dsa_8021q_cpu() symbol

 drivers/net/dsa/ocelot/felix.c     |  6 +++
 drivers/net/ethernet/mscc/ocelot.c | 64 +++++++++++++++---------------
 include/soc/mscc/ocelot.h          |  2 +
 3 files changed, 40 insertions(+), 32 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index aadb0bd7c24f..ee19ed96f284 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -445,6 +445,9 @@ static int felix_tag_8021q_setup(struct dsa_switch *ds)
 	if (err)
 		return err;
 
+	dsa_switch_for_each_cpu_port(dp, ds)
+		ocelot_port_setup_dsa_8021q_cpu(ocelot, dp->index);
+
 	dsa_switch_for_each_user_port(dp, ds)
 		ocelot_port_assign_dsa_8021q_cpu(ocelot, dp->index,
 						 dp->cpu_dp->index);
@@ -493,6 +496,9 @@ static void felix_tag_8021q_teardown(struct dsa_switch *ds)
 	dsa_switch_for_each_user_port(dp, ds)
 		ocelot_port_unassign_dsa_8021q_cpu(ocelot, dp->index);
 
+	dsa_switch_for_each_cpu_port(dp, ds)
+		ocelot_port_teardown_dsa_8021q_cpu(ocelot, dp->index);
+
 	dsa_tag_8021q_unregister(ds);
 }
 
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index d4649e4ee0e7..8468f0d4aa88 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2196,61 +2196,61 @@ static void ocelot_update_pgid_cpu(struct ocelot *ocelot)
 	ocelot_write_rix(ocelot, pgid_cpu, ANA_PGID_PGID, PGID_CPU);
 }
 
-void ocelot_port_assign_dsa_8021q_cpu(struct ocelot *ocelot, int port,
-				      int cpu)
+void ocelot_port_setup_dsa_8021q_cpu(struct ocelot *ocelot, int cpu)
 {
 	struct ocelot_port *cpu_port = ocelot->ports[cpu];
 	u16 vid;
 
 	mutex_lock(&ocelot->fwd_domain_lock);
 
-	ocelot->ports[port]->dsa_8021q_cpu = cpu_port;
+	cpu_port->is_dsa_8021q_cpu = true;
 
-	if (!cpu_port->is_dsa_8021q_cpu) {
-		cpu_port->is_dsa_8021q_cpu = true;
+	for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
+		ocelot_vlan_member_add(ocelot, cpu, vid, true);
 
-		for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
-			ocelot_vlan_member_add(ocelot, cpu, vid, true);
-
-		ocelot_update_pgid_cpu(ocelot);
-	}
-
-	ocelot_apply_bridge_fwd_mask(ocelot, true);
+	ocelot_update_pgid_cpu(ocelot);
 
 	mutex_unlock(&ocelot->fwd_domain_lock);
 }
-EXPORT_SYMBOL_GPL(ocelot_port_assign_dsa_8021q_cpu);
+EXPORT_SYMBOL_GPL(ocelot_port_setup_dsa_8021q_cpu);
 
-void ocelot_port_unassign_dsa_8021q_cpu(struct ocelot *ocelot, int port)
+void ocelot_port_teardown_dsa_8021q_cpu(struct ocelot *ocelot, int cpu)
 {
-	struct ocelot_port *cpu_port = ocelot->ports[port]->dsa_8021q_cpu;
-	bool keep = false;
+	struct ocelot_port *cpu_port = ocelot->ports[cpu];
 	u16 vid;
-	int p;
 
 	mutex_lock(&ocelot->fwd_domain_lock);
 
-	ocelot->ports[port]->dsa_8021q_cpu = NULL;
+	cpu_port->is_dsa_8021q_cpu = false;
 
-	for (p = 0; p < ocelot->num_phys_ports; p++) {
-		if (!ocelot->ports[p])
-			continue;
+	for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
+		ocelot_vlan_member_del(ocelot, cpu_port->index, vid);
 
-		if (ocelot->ports[p]->dsa_8021q_cpu == cpu_port) {
-			keep = true;
-			break;
-		}
-	}
+	ocelot_update_pgid_cpu(ocelot);
 
-	if (!keep) {
-		cpu_port->is_dsa_8021q_cpu = false;
+	mutex_unlock(&ocelot->fwd_domain_lock);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_teardown_dsa_8021q_cpu);
 
-		for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
-			ocelot_vlan_member_del(ocelot, cpu_port->index, vid);
+void ocelot_port_assign_dsa_8021q_cpu(struct ocelot *ocelot, int port,
+				      int cpu)
+{
+	struct ocelot_port *cpu_port = ocelot->ports[cpu];
 
-		ocelot_update_pgid_cpu(ocelot);
-	}
+	mutex_lock(&ocelot->fwd_domain_lock);
 
+	ocelot->ports[port]->dsa_8021q_cpu = cpu_port;
+	ocelot_apply_bridge_fwd_mask(ocelot, true);
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_assign_dsa_8021q_cpu);
+
+void ocelot_port_unassign_dsa_8021q_cpu(struct ocelot *ocelot, int port)
+{
+	mutex_lock(&ocelot->fwd_domain_lock);
+
+	ocelot->ports[port]->dsa_8021q_cpu = NULL;
 	ocelot_apply_bridge_fwd_mask(ocelot, true);
 
 	mutex_unlock(&ocelot->fwd_domain_lock);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index ac151ecc7f19..4c8818576437 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -875,6 +875,8 @@ void ocelot_deinit(struct ocelot *ocelot);
 void ocelot_init_port(struct ocelot *ocelot, int port);
 void ocelot_deinit_port(struct ocelot *ocelot, int port);
 
+void ocelot_port_setup_dsa_8021q_cpu(struct ocelot *ocelot, int cpu);
+void ocelot_port_teardown_dsa_8021q_cpu(struct ocelot *ocelot, int cpu);
 void ocelot_port_assign_dsa_8021q_cpu(struct ocelot *ocelot, int port, int cpu);
 void ocelot_port_unassign_dsa_8021q_cpu(struct ocelot *ocelot, int port);
 u32 ocelot_port_assigned_dsa_8021q_cpu_mask(struct ocelot *ocelot, int port);
-- 
2.34.1

