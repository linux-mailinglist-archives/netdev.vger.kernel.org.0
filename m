Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39CC5AD7FF
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 19:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237615AbiIERCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 13:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237395AbiIERCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 13:02:03 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80051.outbound.protection.outlook.com [40.107.8.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5870E5E32A;
        Mon,  5 Sep 2022 10:02:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwhQs+gId/+usHHhAq6sXGJUmYTl3SbYsA0RQLdNVn3aN0S2Xd31iofyNidioEs2RVsQxEnTtd73V9KF7v9kQq0cXDdXEh7tR7+fwpYg4HN778tX06AZXTjQN4qA1vcq5b6Fb19gVO7Ng67TftGfkciRjDJwR/KZSKn9Su9DDTqzY8lxKHKACwB1jMXhaf3mq74E47z3PIKtNGRtPwcqbWUeLjAdQhiwRMF9eIMTEieE41aVfGNLaLpZ/eLExtpfg0w6SmDP5vZ3Z4aphv47Z5spl2FmoE7vZezLwH2SUtwdTPXeQ7H7lYCFSc9z6fPpAi/VJzWNkO1xd5qZIlN3Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gwsbrN5FDWrq4WfWAhnkC/lVFCbjRT2gzxMDvfrXLlA=;
 b=asx9puZ5pNahUZ9mqC7E6CanKkYkwn66XdS41rFfswLDnB0usSV2DA/CsBE2zsqqunstegD4IMDcPu3dfEzjXTGjdW9jujIHLc7KKpIoYC8gWjTlnyneJsoGAOXZ1lbukVYyyFipoE0oBBooi0fbj8Voj1bPYgMbAdQaG95BGX0PGrCsbae8q/M3EDoQPQeRtSF8739RjWHQmipqt4k1PPgXuGCwFpIFMOqiXVwlPj0DXN23haDYU63aA/7wYX77lvNVfyy5I74Pm16dbS6lgVYQ9aEeiSwFE1LyT81jICx/eZkQ6KY2ET5z3wtWDzcIgB22JcLEVYuWhiau8ZVt5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwsbrN5FDWrq4WfWAhnkC/lVFCbjRT2gzxMDvfrXLlA=;
 b=rFKlRveH3Rpaeo94lm/G1zCujX1Jglt+mEd75wlI22BP8MEestQUWMabWJPITwdTgYbFhBmMfxvTL4eKIF2FL+FEQ+AbVcL4KkgrIkqBIuLuD9BNQ8/77aImCfcxQktTIHXY+5iS4II6Ll0XCFt6R60cu0TeXCU+rjafTnAYvqw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4803.eurprd04.prod.outlook.com (2603:10a6:208:c7::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Mon, 5 Sep
 2022 17:01:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Mon, 5 Sep 2022
 17:01:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 1/3] net: dsa: felix: tc-taprio intervals smaller than MTU should send at least one packet
Date:   Mon,  5 Sep 2022 20:01:23 +0300
Message-Id: <20220905170125.1269498-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220905170125.1269498-1-vladimir.oltean@nxp.com>
References: <20220905170125.1269498-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0140.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17cd0884-a469-46dd-3750-08da8f6057e6
X-MS-TrafficTypeDiagnostic: AM0PR04MB4803:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rUKHCtHWCeISNm8bOAg3GFHi9hJJqUGKT11mnt41wZLqvznaKF0Inf9NCxApUKN53cJXP7n2K7h1/kEp4FNw5uN65P/dZiWlMP4RFCbzlprS5qLCUtwsfK44/J0vcQzPOARXMoFEbbWiGlxr1qO9A5bd9UHEJjqaqZ1a9Fa6GpR8ZG/fjzjVPXLGLUb1ubNK6OO1Orgm/7iTBvWSMBRHvwXtLzqvKnkZnLNrXascODzI8cGERlMK6LG3Bktra2cdWOwpp010VMwLRzqMIHUXZPD4ByA3jvOH8H70VnOolzJmIc/f3gLsr6pBTwxCkPW4TUGkLtvPRN5qvpq8AaCNUJkH0R7IQnHdN1ZY1pEltQQyQlewdAgDkHu7S4bJWoV4p9MnbaPxXvDR5cfBPXIsI677iQctVTa+7Nv8y/nbpsuBnarqDJ2i/ZZ2HxUa3G1FnNSghtQwF0uKoq/F7C+vWO8d06ZdjSVRpIEagiLXqDhbCbHZpZB3jVAarrCjCAE5NC4CEe8fILE3rmBdprFK+AhbmUeg1geeTLC/PjJQKKpmVEAzYlOKiTE5nF7VK7iyWfQL8qNMrOnKDv+N5mUfbQSb0iyz5YxmLJgbb+l2zBEtXEVPVw8VnOEGsfSoI8hAR8IeIE9s2GtvHEuE/pV+RIAOvPwF++0HBA55PXLYVU/wRWd5KZtyleYfQz0nTEWO7qQxi96pFMTS6lSTC+DuEYE5hdAfflAXHVLiKVm2x8Om3RsuAIYmmgFMCmXfA0BAk8xUp7A2DIOd0/SHLGQ/ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(186003)(6916009)(54906003)(1076003)(2616005)(83380400001)(316002)(8936002)(26005)(6486002)(2906002)(36756003)(6512007)(41300700001)(5660300002)(6506007)(52116002)(4326008)(8676002)(44832011)(38350700002)(478600001)(66946007)(38100700002)(86362001)(66476007)(6666004)(66556008)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L9y6anLML104VetAOPseE5MQVv80nZmgHBWuYbMd7DcKnX4zTLKCreh0BpC1?=
 =?us-ascii?Q?ftyfalYk9bzLkofolvhzLYvwEv17YuOVBUeO+ZMucyK/F3lwwMJ5PjGLTYq5?=
 =?us-ascii?Q?OJlljiXcmKAgOycg/FdZ01e8kcDbyvJeookxJyHLLGJ9W6QEgL/N5gu6S8N1?=
 =?us-ascii?Q?FvUe+HUkQI5DqpLyjwaT0Ei63ptsqbisgC/q+/vclOmyPMl/ZkaFv1SIpy8r?=
 =?us-ascii?Q?aNu2uHpVRVu+6jhMysuEvrzyFSnH+ISd1CGOphIMrdZi2PH7Ud2oux6obJQ5?=
 =?us-ascii?Q?LqTFX8zdid70srZ+t4p8XvlKHmXBNhxTOEBRKR9W/h9bv+cQHZ3YmX/Q1/dW?=
 =?us-ascii?Q?ulcxImI60XKVpNBESM96eydq+mQCjYsEZ70qPsUw5rfOd2DzB7Nj/oIq8/Nv?=
 =?us-ascii?Q?hHmU1xyQSB1NNhywliXL3B7ojcJUjzzd0/fGYjFkkVy4YZYxKUHrSOaMWhSn?=
 =?us-ascii?Q?TDC7zpKTEkxFF1QfmhnOxatVFuLEHc+Lc1VNaC6964F5mKFhIK6L0D4YvSRH?=
 =?us-ascii?Q?bGPbSQZsmItVtGzEFzwmvkjX1WRCqoU6ebN8VGjaWA2RqyE0e3xvJR+5DRZ/?=
 =?us-ascii?Q?nWNnl+arvPHDDb8EMJbxGoxHU23k3pgPFuzldP5xUqppXcP9rbM+dqw7C9vQ?=
 =?us-ascii?Q?fUkUWU6boNQpMOcekfKyJLXotyLSiFcqOtS2MbWQAhTLfe5pCQFC8FosQc38?=
 =?us-ascii?Q?fIbuWEHnYXvJt/QQ2KnFCto6qazKZgjFlc+sWkmBqQGQaU7U9Tm4mP1O1WEi?=
 =?us-ascii?Q?iXVWd5XYmn/585KH4Wz+dp1GXqZ+d6fX2x/WAt/WWUZzN6IuvTGijVXWwOvu?=
 =?us-ascii?Q?pdhKA7n3+tnatQ+VqFSFWrTBVg9NMBIC24ww8ZKqkRbxlv5JjF6umewv8CdX?=
 =?us-ascii?Q?bz1hiEKe3tXfnLqpg9qtxeIXIjwBYs3X8vPvbCJuLYWeGoFJoxCkCfZ6XsLX?=
 =?us-ascii?Q?+tzntVNHWVD+tyoM48r3ZAMCzMplyrpv9Afowfg/4uknU4rS9zxOJiY3DEC2?=
 =?us-ascii?Q?n6FQXq6SzMhQYnNgii7E03svGEeDD0nRnZm8AQzR0IEgjzbot9z/dLYQODsd?=
 =?us-ascii?Q?CzweoPjg01p/OZj/qq8YVWgsCQkaGTiEOM5ZavVjzfPElR61V3EzCBXner1U?=
 =?us-ascii?Q?kgx8HelcM45VBD/lsjMN4yNaz2ndwZZWqan1faTbfOXzVxu0+2ZrrVIn4YRP?=
 =?us-ascii?Q?tKaaDXGrwO4IrliIM8Gk5i8hP8jpQGNThplsqgbjEP42T3fei7+gJVLT46Z9?=
 =?us-ascii?Q?xvYxAf0jc/2Mix182nVuFOggx2Bn9NFmBEETZ/lvsmT7GfpcZLqKoEGO79vR?=
 =?us-ascii?Q?wN0fnNlL5VF4zAnYOANR4w8HB6khyy+eRB13grhlGoB4Fyq9s44WP4EGpMC1?=
 =?us-ascii?Q?fBKj5AS4xpeYrJ+lmqTptWvvSEjW5YMF1WfaU1U7nxFV2RbzPVH9goSXPhg1?=
 =?us-ascii?Q?D5JDaAw8fcs5a4h/ChJ4JKeABs4ev1TDwtNd4wHDooW2/LgPw+MwhV9kAy6n?=
 =?us-ascii?Q?bREeH/7rF9sg7zfSB+Q/XYFGI23azUChIP9SmnVxhLcOA/u7pjlaVrXVmHLg?=
 =?us-ascii?Q?MQHa+/5ex5EDmZ8VoGInbLF+/CGPp99DICJO7P6hh97ZdLzOhWcMjOLJXIuF?=
 =?us-ascii?Q?TQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17cd0884-a469-46dd-3750-08da8f6057e6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 17:01:58.3183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zY+aTIYZhAuaazex8pxhheWXdmmYDRDHhP8yPamFZbDv4Bp8e28eVgBahSShm/XAWUH1HjVykYbSxfM2vJi4Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4803
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The blamed commit broke tc-taprio schedules such as this one:

tc qdisc replace dev $swp1 root taprio \
        num_tc 8 \
        map 0 1 2 3 4 5 6 7 \
        queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
        base-time 0 \
        sched-entry S 0x7f 990000 \
        sched-entry S 0x80  10000 \
        flags 0x2

because the gate entry for TC 7 (S 0x80 10000 ns) now has a static guard
band added earlier than its 'gate close' event, such that packet
overruns won't occur in the worst case of the largest packet possible.

Since guard bands are statically determined based on the per-tc
QSYS_QMAXSDU_CFG_* with a fallback on the port-based QSYS_PORT_MAX_SDU,
we need to discuss what happens with TC 7 depending on kernel version,
since the driver, prior to commit 55a515b1f5a9 ("net: dsa: felix: drop
oversized frames with tc-taprio instead of hanging the port"), did not
touch QSYS_QMAXSDU_CFG_*, and therefore relied on QSYS_PORT_MAX_SDU.

1 (before vsc9959_tas_guard_bands_update): QSYS_PORT_MAX_SDU defaults to
  1518, and at gigabit this introduces a static guard band (independent
  of packet sizes) of 12144 ns, plus QSYS::HSCH_MISC_CFG.FRM_ADJ (bit
  time of 20 octets => 160 ns). But this is larger than the time window
  itself, of 10000 ns. So, the queue system never considers a frame with
  TC 7 as eligible for transmission, since the gate practically never
  opens, and these frames are forever stuck in the TX queues and hang
  the port.

2 (after vsc9959_tas_guard_bands_update): Under the sole goal of
  enabling oversized frame dropping, we make an effort to set
  QSYS_QMAXSDU_CFG_7 to 1230 bytes. But QSYS_QMAXSDU_CFG_7 plays
  one more role, which we did not take into account: per-tc static guard
  band, expressed in L2 byte time (auto-adjusted for FCS and L1 overhead).
  There is a discrepancy between what the driver thinks (that there is
  no guard band, and 100% of min_gate_len[tc] is available for egress
  scheduling) and what the hardware actually does (crops the equivalent
  of QSYS_QMAXSDU_CFG_7 ns out of min_gate_len[tc]). In practice, this
  means that the hardware thinks it has exactly 0 ns for scheduling tc 7.

In both cases, even minimum sized Ethernet frames are stuck on egress
rather than being considered for scheduling on TC 7, even if they would
fit given a proper configuration. Considering the current situation,
with vsc9959_tas_guard_bands_update(), frames between 60 octets and 1230
octets in size are not eligible for oversized dropping (because they are
smaller than QSYS_QMAXSDU_CFG_7), but won't be considered as eligible
for scheduling either, because the min_gate_len[7] (10000 ns) minus the
guard band determined by QSYS_QMAXSDU_CFG_7 (1230 octets * 8 ns per
octet == 9840 ns) minus the guard band auto-added for L1 overhead by
QSYS::HSCH_MISC_CFG.FRM_ADJ (20 octets * 8 ns per octet == 160 octets)
leaves 0 ns for scheduling in the queue system proper.

Investigating the hardware behavior, it becomes apparent that the queue
system needs precisely 33 ns of 'gate open' time in order to consider a
frame as eligible for scheduling to a tc. So the solution to this
problem is to amend vsc9959_tas_guard_bands_update(), by giving the
per-tc guard bands less space by exactly 33 ns, just enough for one
frame to be scheduled in that interval. This allows the queue system to
make forward progress for that port-tc, and prevents it from hanging.

Fixes: 297c4de6f780 ("net: dsa: felix: re-enable TAS guard band mode")
Reported-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- add Xiaoliang's Reported-by: tag, since he did report the correct
  issue after all (my bad)
- reword commit message and explanations
- reserve just 33 ns of min_gate_len[tc] as useful space for scheduling,
  rather than one whole max MTU frame worth of time. In the given
  example of 10 us tc-taprio interval, this raises our useful max SDU
  to 1225, compared to 601 octets in v1.

 drivers/net/dsa/ocelot/felix_vsc9959.c | 35 +++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 1cdce8a98d1d..262be2cf4e4b 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -22,6 +22,7 @@
 #define VSC9959_NUM_PORTS		6
 
 #define VSC9959_TAS_GCL_ENTRY_MAX	63
+#define VSC9959_TAS_MIN_GATE_LEN_NS	33
 #define VSC9959_VCAP_POLICER_BASE	63
 #define VSC9959_VCAP_POLICER_MAX	383
 #define VSC9959_SWITCH_PCI_BAR		4
@@ -1478,6 +1479,23 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 	mdiobus_free(felix->imdio);
 }
 
+/* The switch considers any frame (regardless of size) as eligible for
+ * transmission if the traffic class gate is open for at least 33 ns.
+ * Overruns are prevented by cropping an interval at the end of the gate time
+ * slot for which egress scheduling is blocked, but we need to still keep 33 ns
+ * available for one packet to be transmitted, otherwise the port tc will hang.
+ * This function returns the size of a gate interval that remains available for
+ * setting the guard band, after reserving the space for one egress frame.
+ */
+static u64 vsc9959_tas_remaining_gate_len_ps(u64 gate_len_ns)
+{
+	/* Gate always open */
+	if (gate_len_ns == U64_MAX)
+		return U64_MAX;
+
+	return (gate_len_ns - VSC9959_TAS_MIN_GATE_LEN_NS) * PSEC_PER_NSEC;
+}
+
 /* Extract shortest continuous gate open intervals in ns for each traffic class
  * of a cyclic tc-taprio schedule. If a gate is always open, the duration is
  * considered U64_MAX. If the gate is always closed, it is considered 0.
@@ -1596,10 +1614,13 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 	vsc9959_tas_min_gate_lengths(ocelot_port->taprio, min_gate_len);
 
 	for (tc = 0; tc < OCELOT_NUM_TC; tc++) {
+		u64 remaining_gate_len_ps;
 		u32 max_sdu;
 
-		if (min_gate_len[tc] == U64_MAX /* Gate always open */ ||
-		    min_gate_len[tc] * PSEC_PER_NSEC > needed_bit_time_ps) {
+		remaining_gate_len_ps =
+			vsc9959_tas_remaining_gate_len_ps(min_gate_len[tc]);
+
+		if (remaining_gate_len_ps > needed_bit_time_ps) {
 			/* Setting QMAXSDU_CFG to 0 disables oversized frame
 			 * dropping.
 			 */
@@ -1612,9 +1633,15 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 			/* If traffic class doesn't support a full MTU sized
 			 * frame, make sure to enable oversize frame dropping
 			 * for frames larger than the smallest that would fit.
+			 *
+			 * However, the exact same register, QSYS_QMAXSDU_CFG_*,
+			 * controls not only oversized frame dropping, but also
+			 * per-tc static guard band lengths, so it reduces the
+			 * useful gate interval length. Therefore, be careful
+			 * to calculate a guard band (and therefore max_sdu)
+			 * that still leaves 33 ns available in the time slot.
 			 */
-			max_sdu = div_u64(min_gate_len[tc] * PSEC_PER_NSEC,
-					  picos_per_byte);
+			max_sdu = div_u64(remaining_gate_len_ps, picos_per_byte);
 			/* A TC gate may be completely closed, which is a
 			 * special case where all packets are oversized.
 			 * Any limit smaller than 64 octets accomplishes this
-- 
2.34.1

