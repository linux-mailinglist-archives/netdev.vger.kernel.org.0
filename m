Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34EFD55B1C0
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 14:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbiFZMGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 08:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbiFZMF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 08:05:59 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2050.outbound.protection.outlook.com [40.107.104.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4E51572C;
        Sun, 26 Jun 2022 05:05:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIrlrjQlmuLrRJV/XJ5LlJECdi0GkdDqLO0XrVfz7WaNsqri77CQe612JdyW+FIaNKLzeraMK/qDi+DKcM252ol24v/9RH9EiLxYiqAued+ffGLatYY53HMh0yYX04RPsKy/9yNJS8MqiuuuZSKmwk/cG5u/vlDvpCBDZX2gb9Ptvex1KwXdLqGL5xNxapUQiC34Y+wrkhNOTxsNcLXWQaq/EP2dY+4tl3ZD6bvcWzu9rliXk+WiFZHjy7t2raKUEvuS01I3Pp+0H/a7Nj+1YZuDV66tpMGVYzSYzvlKGw/yCszgtaWhv9xblPV4FD4gx3BpiJUvQCC8muXQO3R0EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4QtwFYtmL/PZYuIO6nzmLx32nx2BFlMZchBMPewCp3w=;
 b=NS+Zn372EJlfEFvn7x8gFO8xRZMxOCMrbsn0+Dk+BoeWJYp+cRZASK41OiUEVF+ZmakLuOAmYHNzyQHdyA0YXp2VLHQjYIXFfAaR8XpCYS2Jz1p+fM/UA2pbPih4g1iPXn2t3JNjakNdPloDilb/tM/zzM96UHbSHFAlOHa2gh1zPEZLEgsC8K6FwDW2Il28C58KxgkopfEUml9eansGSvf95ss/T7uzWXlXho6wFyd8SLE7+OzZVTvRB65oWtoJYc0HPenGiy8iK3E9QjN+gkYA3Xu38ZH4apo6r8CvMboMiDwVghkCgVytUvF2Fb2cyQ7soCWosR/hseQ3yDjR/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4QtwFYtmL/PZYuIO6nzmLx32nx2BFlMZchBMPewCp3w=;
 b=OFjG1v5L+2TxvZbNrCnXfhWL8vmZi0HDTPi52iZfKuJOA/G2KSc/EV1sov7AMlN8Gukup2M1qom4x0U1ElKXbrwWUICgCS4PxceprjhVtrVRkN6YiXj3ESc1nuTqGrfO1vVR09RMODfQhycWieugaUMJVCHWaUjJoYHeVggc02Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4273.eurprd04.prod.outlook.com (2603:10a6:208:67::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Sun, 26 Jun
 2022 12:05:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Sun, 26 Jun 2022
 12:05:38 +0000
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
Subject: [PATCH net-next 4/4] net: dsa: felix: drop oversized frames with tc-taprio instead of hanging the port
Date:   Sun, 26 Jun 2022 15:05:05 +0300
Message-Id: <20220626120505.2369600-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220626120505.2369600-1-vladimir.oltean@nxp.com>
References: <20220626120505.2369600-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0401.eurprd06.prod.outlook.com
 (2603:10a6:20b:461::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 542ea7a0-d8ea-4b0f-6fa7-08da576c2f31
X-MS-TrafficTypeDiagnostic: AM0PR04MB4273:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vjnHNaxr7gXgEBeyQo2eMojIny5sY804afnqqutVOFB3Gl11ZcjxBYssuvWPDbWL7o0gXDM3eUg04vr9ZUUzzdnbCd48MkOO1DaxLpgdDUAuadfwW2vOsWB5gafFAUnD+9z2XZyitUY6cwr9SxT31QxVVJH/vOOAZIf2XtlMqmImjzg+uuSLC+zZuVfRCBZ1FM1DdgqLXCAy1F3k5oUR5rY4b7TjgWxkuqk9PO+3VHwTdjsY+FPB8i1zeJEpXBJ9JMEdNy9THxD+THBTscIGLxg6T6iJEijvQgl29ELeZI4E3XertbxZs179xRXaIGeA16mWKqlXRuCsvE8OibEWCh0f+5lO369Xd8jGD4fcDRy3SZXV1f050Zze3rXn23tgovfth0aSIzZS9TT/BF1WZYKdUh6oBirxVDkOXq89Tci0Ke3f295pM4g9ALW/ANO1iHUlk2FjmOoPF8X66hA7lpJTxUAZKaTtHFp6B1AKxbdFCVypTIzjj2w/KC48/82wBcv11TwqyzR1Ej8+nzcNJmc56hCmdmaRD+bGYSUm3qprO5p3XsTj0kgS8T2G9JTzjM/ufA8D/TkEOM/zxHtqzhD72FhnH4y2qdXBzSVIeTr3qgey10sf5mMLCCqtBRE21d8eiR43nm11YxEGjjvg7QxMDp9oW9hPGNkYUpbwLLyt0fjEiA/ySWOiHAKdRzDnszQbIbtQPE2OVbyZmLjuwYxovIgRniBBSS8z9Iy+95m/O5ED2mLTf2z8HjQnRQO5jKhoguOjA0W8AeMMPFp9EnapQMg+17BcHvtwFAOaie0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(38100700002)(316002)(83380400001)(86362001)(52116002)(2616005)(36756003)(6506007)(38350700002)(66556008)(66476007)(66946007)(4326008)(8676002)(5660300002)(8936002)(7416002)(1076003)(186003)(41300700001)(54906003)(2906002)(30864003)(26005)(478600001)(6512007)(6666004)(6486002)(6916009)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GPYJJN+0SGE9D3qk/ACnfNUchBFtNttBMnf5DMP3NNqm7lHzdAin18Byh7gt?=
 =?us-ascii?Q?WQ5XwPjJxWd2lR4zxmS6v9f5h8atjQojoKvP7yw6BxHun6CKpBrZKbCyhMHu?=
 =?us-ascii?Q?K9yBXyZmXL8DcwRDIoYREbofZeKgP/mPS5ac9/LRYY8qFWJgGpZYl0AkwYOx?=
 =?us-ascii?Q?3TBuYFQw+p+QCl2+LIRGWUik93ZaMS/OmQfRGK8lPS4DikzjSafvJU7y/OTB?=
 =?us-ascii?Q?wESIlt3RE5lAyTX2lq2bQRZNFsY2t1GG/LV4C6boAtzVLaStApfq96ncZJv4?=
 =?us-ascii?Q?9zTFJpHSXou2pcPPGOkQQeIeDLBD4mkbMgJSYxr5GRX0qQrXotH3oFv9Bs83?=
 =?us-ascii?Q?JHGcUuCfwBFLbV8yeh1Nwh/65s3v9A7YBojHLVKl312LSGcEmTslPLnV+egS?=
 =?us-ascii?Q?oLUTbpDPLSF+S1q1HEvdweJZPIS1WgrVQTrkG+GA4Ot+S7NwO/YcJQIYu3ZU?=
 =?us-ascii?Q?scBj4cTtw/hAbn02Pvr+rmQchmk8c+fAv0afXC1RPcU7Wn5XpAurIpXKW1Lw?=
 =?us-ascii?Q?J5ihkWlG2FthqNiSqSOAg/6UNP1BiGjaRsgDOzApM3qvnUiWv2vV+42X3ZFy?=
 =?us-ascii?Q?crQ6Js0rJWMsnBRlydi8KdnkbRRgo4mStdhFu2UDY1w6SamcwH0tikGY2Xu4?=
 =?us-ascii?Q?oIVm9RW3Zez7JruOKIXV2Let/UIZminhqJZ7HqnhKF+DQM9rU+zhAlTDMMj7?=
 =?us-ascii?Q?dYd8fTWPrf6JhbG6NdjbQSvuIMNqGz3SkB7ixZcM+mDj/K7yBvjEvPDwkfs/?=
 =?us-ascii?Q?pQPEu4cz2qFk9bh7RZNgb83mVGklxSUl0zO2VhDu0zd4+ij+plvsvaZCQh28?=
 =?us-ascii?Q?WU3eVRQx2p/He+/ila+xfq/vMbYrnayN0EACKxo5RM16Vbeiw9reY5/GgXsR?=
 =?us-ascii?Q?VLELCZAA52Xzni4j7seJWFmntY/9CArm0i8XEYNzHcrR/NkJGpPDo83RPxWA?=
 =?us-ascii?Q?ELQvRgiYeVeyWMLqzGzbF2PN12Wed52+snfwmVZtMDxootTAqqo7GGQQRyI6?=
 =?us-ascii?Q?TdrZ0KKiJ/IWKBgCW05b8OBPqwpIyoxPeoZ8tNsQ1rq4ytvVNotevy5yB2/C?=
 =?us-ascii?Q?0U5PdpVKjt3TFCJwaZAHvf4h/G30icc66x3KbS52QSPR1fXZbN6IIHWaFA4p?=
 =?us-ascii?Q?Icy4HvWGV4B3Ba8BD75jx1hVbIhNKQj2R2ocuwS9r80/BXpWdPx9JGvL9iTf?=
 =?us-ascii?Q?QNKKWxVk9cuWK8bYlQelTh8IHsdO08HS2zHEdkK+JIcRwMDAxsxWWbsd7MbJ?=
 =?us-ascii?Q?DPPb2tlXnRvYyGBwbPHX/l0syBDeVMSUUrHtKy4WHERWbyLPS9pkYlRrULCB?=
 =?us-ascii?Q?Drh1X3Py56l/j9QiU5SNPi8DXy1P+BxAofMB84mxy28Yx6iYZt6wM0Z6PQm9?=
 =?us-ascii?Q?LUa+KWJF1XN0bgpTNZHuut+K47RNrNMo2wK/H1K/E4dcepkVO8oyrVhQNXQS?=
 =?us-ascii?Q?ArS8bHmd0Sk/XAPPG6gft8RTS894IH1IF0ZP6Dg4lUJvHwxPXXh1WMucOsuU?=
 =?us-ascii?Q?ur2bscm2IUMTuz1fgpGvYIVaFZhvIDqb89HhZwwvmK0o9K3KGsj2oat9HX0o?=
 =?us-ascii?Q?KBeYcrVwrLw1YOK+PYJoIG/LwObf5fJbxlVp8zdjvi6seQIZ7pz8GsFsFFB0?=
 =?us-ascii?Q?rg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 542ea7a0-d8ea-4b0f-6fa7-08da576c2f31
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2022 12:05:38.7762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: agFJRoLtPiQVzqlIgKh2Ja+0OuklrI08SXZbJ1lIphrYazqL1anqyC5I7m61wdEi2oYLMSv2IMUybNsYClghaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4273
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, sending a packet into a time gate too small for it (or always
closed) causes the queue system to hold the frame forever. Even worse,
this frame isn't subject to aging either, because for that to happen, it
needs to be scheduled for transmission in the first place. But the frame
will consume buffer memory and frame references while it is forever held
in the queue system.

Before commit a4ae997adcbd ("net: mscc: ocelot: initialize watermarks to
sane defaults"), this behavior was somewhat subtle, as the switch had a
more intricately tuned default watermark configuration out of reset,
which did not allow any single port and tc to consume the entire switch
buffer space. Nonetheless, the held frames are still there, and they
reduce the total backplane capacity of the switch.

However, after the aforementioned commit, the behavior can be very
clearly seen, since we deliberately allow each {port, tc} to consume the
entire shared buffer of the switch minus the reservations (and we
disable all reservations by default). That is to say, we allow a
permanently closed tc-taprio gate to hang the entire switch.

A careful inspection of the documentation shows that the QSYS:Q_MAX_SDU
per-port-tc registers serve 2 purposes: one is for guard band calculation
(when zero, this falls back to QSYS:PORT_MAX_SDU), and the other is to
enable oversized frame dropping (when non-zero).

Currently the QSYS:Q_MAX_SDU registers are all zero, so oversized frame
dropping is disabled. The goal of the change is to enable it seamlessly.
For that, we need to hook into the MTU change, tc-taprio change, and
port link speed change procedures, since we depend on these variables.

When a frame is dropped due to a queue system oversize condition, the
counter that increments is the generic "drop_tail" in ethtool -S, even
if this isn't a tail drop as the rest (i.e. the controlling watermarks
don't count these frames, as can be seen in "devlink sb occupancy show
pci/0000:00:00.5 sb 0"). So the hardware counter is unspecific
regarding the drop reason.

The issue exists in various forms since the tc-taprio offload was introduced.

Fixes: de143c0e274b ("net: dsa: felix: Configure Time-Aware Scheduler via taprio offload")
Reported-by: Richie Pearn <richard.pearn@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Q: checkpatch says "quoted string split across lines", don't you see?
A: I do, but I believe it won't practically affect anybody, since the
   usual reason for not splitting up strings is for grep-ability. But
   no reasonable person would grep for a string containing a number,
   realizing that it's part of a printf-formatted string and the search
   wouldn't find any result. There are plenty of contiguous words that
   can be grepped already, and the "%d" specifier constitutes a good
   place IMO to snap an already long string into multiple lines.

 drivers/net/dsa/ocelot/felix.c         |   9 ++
 drivers/net/dsa/ocelot/felix.h         |   1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c | 201 +++++++++++++++++++++++++
 3 files changed, 211 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 3e07dc39007a..859196898a7d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1553,9 +1553,18 @@ static void felix_txtstamp(struct dsa_switch *ds, int port,
 static int felix_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct felix *felix = ocelot_to_felix(ocelot);
 
 	ocelot_port_set_maxlen(ocelot, port, new_mtu);
 
+	mutex_lock(&ocelot->tas_lock);
+
+	if (ocelot_port->taprio && felix->info->tas_guard_bands_update)
+		felix->info->tas_guard_bands_update(ocelot, port);
+
+	mutex_unlock(&ocelot->tas_lock);
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 9e07eb7ee28d..deb8dde1fc19 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -53,6 +53,7 @@ struct felix_info {
 				    struct phylink_link_state *state);
 	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
 				 enum tc_setup_type type, void *type_data);
+	void	(*tas_guard_bands_update)(struct ocelot *ocelot, int port);
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
 	struct regmap *(*init_regmap)(struct ocelot *ocelot,
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 7573254274b3..00578110b8da 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1127,9 +1127,199 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 	mdiobus_free(felix->imdio);
 }
 
+/* Extract shortest continuous gate open intervals in ns for each traffic class
+ * of a cyclic tc-taprio schedule. If a gate is always open, the duration is
+ * considered U64_MAX. If the gate is always closed, it is considered 0.
+ */
+static void vsc9959_tas_min_gate_lengths(struct tc_taprio_qopt_offload *taprio,
+					 u64 min_gate_len[OCELOT_NUM_TC])
+{
+	struct tc_taprio_sched_entry *entry;
+	u64 gate_len[OCELOT_NUM_TC];
+	int tc, i, n;
+
+	/* Initialize arrays */
+	for (tc = 0; tc < OCELOT_NUM_TC; tc++) {
+		min_gate_len[tc] = U64_MAX;
+		gate_len[tc] = 0;
+	}
+
+	/* If we don't have taprio, consider all gates as permanently open */
+	if (!taprio)
+		return;
+
+	n = taprio->num_entries;
+
+	/* Walk through the gate list twice to determine the length
+	 * of consecutively open gates for a traffic class, including
+	 * open gates that wrap around. We are just interested in the
+	 * minimum window size, and this doesn't change what the
+	 * minimum is (if the gate never closes, min_gate_len will
+	 * remain U64_MAX).
+	 */
+	for (i = 0; i < 2 * n; i++) {
+		entry = &taprio->entries[i % n];
+
+		for (tc = 0; tc < OCELOT_NUM_TC; tc++) {
+			if (entry->gate_mask & BIT(tc)) {
+				gate_len[tc] += entry->interval;
+			} else {
+				/* Gate closes now, record a potential new
+				 * minimum and reinitialize length
+				 */
+				if (min_gate_len[tc] > gate_len[tc])
+					min_gate_len[tc] = gate_len[tc];
+				gate_len[tc] = 0;
+			}
+		}
+	}
+}
+
+/* Update QSYS_PORT_MAX_SDU to make sure the static guard bands added by the
+ * switch (see the ALWAYS_GUARD_BAND_SCH_Q comment) are correct at all MTU
+ * values (the default value is 1518). Also, for traffic class windows smaller
+ * than one MTU sized frame, update QSYS_QMAXSDU_CFG to enable oversized frame
+ * dropping, such that these won't hang the port, as they will never be sent.
+ */
+static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	u64 min_gate_len[OCELOT_NUM_TC];
+	int speed, picos_per_byte;
+	u64 needed_bit_time_ps;
+	u32 val, maxlen;
+	u8 tas_speed;
+	int tc;
+
+	lockdep_assert_held(&ocelot->tas_lock);
+
+	val = ocelot_read_rix(ocelot, QSYS_TAG_CONFIG, port);
+	tas_speed = QSYS_TAG_CONFIG_LINK_SPEED_X(val);
+
+	switch (tas_speed) {
+	case OCELOT_SPEED_10:
+		speed = SPEED_10;
+		break;
+	case OCELOT_SPEED_100:
+		speed = SPEED_100;
+		break;
+	case OCELOT_SPEED_1000:
+		speed = SPEED_1000;
+		break;
+	case OCELOT_SPEED_2500:
+		speed = SPEED_2500;
+		break;
+	default:
+		return;
+	}
+
+	picos_per_byte = (USEC_PER_SEC * 8) / speed;
+
+	val = ocelot_port_readl(ocelot_port, DEV_MAC_MAXLEN_CFG);
+	/* MAXLEN_CFG accounts automatically for VLAN. We need to include it
+	 * manually in the bit time calculation, plus the preamble and SFD.
+	 */
+	maxlen = val + 2 * VLAN_HLEN;
+	/* Consider the standard Ethernet overhead of 8 octets preamble+SFD,
+	 * 4 octets FCS, 12 octets IFG.
+	 */
+	needed_bit_time_ps = (maxlen + 24) * picos_per_byte;
+
+	dev_dbg(ocelot->dev,
+		"port %d: max frame size %d needs %llu ps at speed %d\n",
+		port, maxlen, needed_bit_time_ps, speed);
+
+	vsc9959_tas_min_gate_lengths(ocelot_port->taprio, min_gate_len);
+
+	for (tc = 0; tc < OCELOT_NUM_TC; tc++) {
+		u32 max_sdu;
+
+		if (min_gate_len[tc] == U64_MAX /* Gate always open */ ||
+		    min_gate_len[tc] * PSEC_PER_NSEC > needed_bit_time_ps) {
+			/* Setting QMAXSDU_CFG to 0 disables oversized frame
+			 * dropping.
+			 */
+			max_sdu = 0;
+			dev_dbg(ocelot->dev,
+				"port %d tc %d min gate len %llu"
+				", sending all frames\n",
+				port, tc, min_gate_len[tc]);
+		} else {
+			/* If traffic class doesn't support a full MTU sized
+			 * frame, make sure to enable oversize frame dropping
+			 * for frames larger than the smallest that would fit.
+			 */
+			max_sdu = div_u64(min_gate_len[tc] * PSEC_PER_NSEC,
+					  picos_per_byte);
+			/* A TC gate may be completely closed, which is a
+			 * special case where all packets are oversized.
+			 * Any limit smaller than 64 octets accomplishes this
+			 */
+			if (!max_sdu)
+				max_sdu = 1;
+			/* Take L1 overhead into account, but just don't allow
+			 * max_sdu to go negative or to 0. Here we use 20
+			 * because QSYS_MAXSDU_CFG_* already counts the 4 FCS
+			 * octets as part of packet size.
+			 */
+			if (max_sdu > 20)
+				max_sdu -= 20;
+			dev_info(ocelot->dev,
+				 "port %d tc %d min gate length %llu"
+				 " ns not enough for max frame size %d at %d"
+				 " Mbps, dropping frames over %d"
+				 " octets including FCS\n",
+				 port, tc, min_gate_len[tc], maxlen, speed,
+				 max_sdu);
+		}
+
+		/* ocelot_write_rix is a macro that concatenates
+		 * QSYS_MAXSDU_CFG_* with _RSZ, so we need to spell out
+		 * the writes to each traffic class
+		 */
+		switch (tc) {
+		case 0:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_0,
+					 port);
+			break;
+		case 1:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_1,
+					 port);
+			break;
+		case 2:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_2,
+					 port);
+			break;
+		case 3:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_3,
+					 port);
+			break;
+		case 4:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_4,
+					 port);
+			break;
+		case 5:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_5,
+					 port);
+			break;
+		case 6:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_6,
+					 port);
+			break;
+		case 7:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_7,
+					 port);
+			break;
+		}
+	}
+
+	ocelot_write_rix(ocelot, maxlen, QSYS_PORT_MAX_SDU, port);
+}
+
 static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
 				    u32 speed)
 {
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u8 tas_speed;
 
 	switch (speed) {
@@ -1154,6 +1344,13 @@ static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
 		       QSYS_TAG_CONFIG_LINK_SPEED(tas_speed),
 		       QSYS_TAG_CONFIG_LINK_SPEED_M,
 		       QSYS_TAG_CONFIG, port);
+
+	mutex_lock(&ocelot->tas_lock);
+
+	if (ocelot_port->taprio)
+		vsc9959_tas_guard_bands_update(ocelot, port);
+
+	mutex_unlock(&ocelot->tas_lock);
 }
 
 static void vsc9959_new_base_time(struct ocelot *ocelot, ktime_t base_time,
@@ -1210,6 +1407,8 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 		taprio_offload_free(ocelot_port->taprio);
 		ocelot_port->taprio = NULL;
 
+		vsc9959_tas_guard_bands_update(ocelot, port);
+
 		mutex_unlock(&ocelot->tas_lock);
 		return 0;
 	}
@@ -1284,6 +1483,7 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 		goto err;
 
 	ocelot_port->taprio = taprio_offload_get(taprio);
+	vsc9959_tas_guard_bands_update(ocelot, port);
 
 err:
 	mutex_unlock(&ocelot->tas_lock);
@@ -2303,6 +2503,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.port_modes		= vsc9959_port_modes,
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
+	.tas_guard_bands_update	= vsc9959_tas_guard_bands_update,
 	.init_regmap		= ocelot_regmap_init,
 };
 
-- 
2.25.1

