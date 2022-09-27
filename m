Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5355ED13D
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 01:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbiI0Xss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 19:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbiI0XsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 19:48:10 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70084.outbound.protection.outlook.com [40.107.7.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547E71BB20A;
        Tue, 27 Sep 2022 16:48:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EcFMmT06DCzgzNGnRyw8l+mNG7DWQMTvzrvmZudKAcZMVrmNcUUb1zj/pIuMKflr0G+1KJ4y9I4eiG3Ky2+mjxJH8MTspb/1ErDxbv54270GCcC3a2vf7H95+7enNH1oIff8WgDd4QsTeHjW/R7xNqUYiZrreVDEFftedhD4DmYIDwNOb3HYzeiRaT3s/OX2ZwU3WOtsaBMUyv1xqyuoJb76iHUUZ4hB6kr328NQbt/n55OF4Ab/b9afdLD4gGfklG5ZbJRM0mXw45WTB4ETrqHf5Qb/HcDCKMiyJgtgxCff9Y3YSmzlbnruuFXhWwjLOExgngxf6k6Gvw+VHFeWhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/C0aHcx8YYTL0CUt+aS3617l/CB0NMVBvv08wZdyfXM=;
 b=ckSDBr2GZbWe17B1Ec7+keOqIWrux2siBCGAdsdaHXDfF3//SYwV6N/rTYE6Gr9xfcfz4SZvGL6aLww2yWHJN9Ek2MCeUgL8k4h0JXfYLLwszM628cpkI75bPHt9/wg5miG0ZU3OnXWLedtINeSJFnsn1n1B+jKMAFSY8H4Twx9nwEUpZ68w4K6FxWzR0p3f9BGDpyVGdCScxeqTGjHb5JjhevYXkGg4nsWm2z33NSUlX0CLoFxeKCx5/8uSEClg9B7fV1CnYxezRy2NwIjR0+B8QEPovL/z/lJOMTeBuj9dcEBy2DTyFer1uH1CzBEEPVRVCOMaqO9hRrFIDCQjEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/C0aHcx8YYTL0CUt+aS3617l/CB0NMVBvv08wZdyfXM=;
 b=QmodO3FRbHNSWRofdwjSMfgPYWqiQwFYXpK3D3Vs6D/FuLZAdrdbQWO8k7Ob3P4NB7N8OtZv0wJRHqIzbB1ClFswhMN+F5Hmfdl7vsjfl5Zz9e44exLpkXrlVhOBHR/+g9MPuMnLP2bX0XCgL88vJoPAdF66pHzTtAjOjbkWg3k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU0PR04MB9444.eurprd04.prod.outlook.com (2603:10a6:10:35c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Tue, 27 Sep
 2022 23:48:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 23:48:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 3/8] net: dsa: felix: offload per-tc max SDU from tc-taprio
Date:   Wed, 28 Sep 2022 02:47:41 +0300
Message-Id: <20220927234746.1823648-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220927234746.1823648-1-vladimir.oltean@nxp.com>
References: <20220927234746.1823648-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0025.eurprd05.prod.outlook.com
 (2603:10a6:800:60::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU0PR04MB9444:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d3e230f-46ec-44dd-b194-08daa0e2b7eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EVXNBd9rnAjRNxT5Ku7xBfDbhpUnd8AF0pF/cYhDnEzxtqwUYbdXPuuZMZjM8aW3l3Ksq0Xl9D09rCN9W7Xhd1jy4rsIvc2sf4euf/1pQXkx2+VXHuN3oOdR/X2cUIGtsP8J3npkQmD8UUQ8zR38XWV9xWDMg4oMME7u3Cai9qAk141syx74/cU+n8GtcsDKBhq60HAP7RVI0r6yvSsujgTE+jjCEQYmqWzHpg6Htb119hbD+B0xQXM6Muh5nI2saZLlxxmznCZTwTVvXp84aXdBQyNvZt6Fa1oaBgmW/07uKYo6IMn1UqY3tbGauNXKAv3+yNaXqsAzFnelSsYHkgf+kFLxV3et/5x0eLfGWpn0b8dVABo8ws+ZLXQuzEQpDQIjteAxg1JknS7y5WFtOsezD6xW+lwx+9iwEB7YrfKjLR3sWQoTLecyx6/hKnbzBDrb+046F+wCBLRzlXjbhYLNOgV3l0uFlXcM7Iz+apM+S7RbGiHit+/UvzIGqEUg/RP7qYYCRcqOC1faaVj9T8m/41PQmKCwkZ+uJ+jR+AwOrkJT5ekrXv5Ms9JFwn5aKD6+CNTlbh4Awj6ymOfPD1ecTw/0spdso+0AW8Br3qyjs2iah9BQxKIlg8lTg4sSHjNS7Dq4YW6bp7tg4HD25LrtrV2FWVTWYPz2qprVbSgxeDBycyMZ0IsckXA0jTGu5aTnWpiHg4PS4pp6wmNi007ilfwXEbaLMvxIOMlZIh8z43fCoeLw7Sea2tpDbLLvAleLzAiF8pCoW++hYmGEww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199015)(7416002)(6512007)(41300700001)(6666004)(36756003)(6486002)(38350700002)(6506007)(6916009)(8676002)(86362001)(66476007)(4326008)(26005)(52116002)(8936002)(66946007)(83380400001)(38100700002)(316002)(54906003)(186003)(1076003)(2906002)(5660300002)(66556008)(478600001)(44832011)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UIllg//zdYMhVvt1tEIHORn6kIhlSkIKzyaZahH7TTBdkdGsCFsGtf5CYIUt?=
 =?us-ascii?Q?0p+L4QR5GGyXA1VOleqoxD2X1zmvjALgixMRE9JND7bbbX+ByfrhZq325HuS?=
 =?us-ascii?Q?2He0fOf4HPSdCqNKYkgtzDc2ybLaMZ9FIO8FDBj3ZuEAJUIgtITqfjVugPgz?=
 =?us-ascii?Q?U0j+aZHvgTeNbEih7njYKYJ/A3QT4J7Vz+OL17ggoYw/PF1o2L4nkR5zJmjV?=
 =?us-ascii?Q?keCnGWfXFrfVzZvE58+DB/c2J4H/y/bIZuranwvUbp2hu0S8vHAH96O9OHmg?=
 =?us-ascii?Q?T/s/fO1nL5FI0jWGRn+NIVD+KK3woY257ATBMcAIcywQ/X2bJGzFNHdJTaqz?=
 =?us-ascii?Q?o+jDNtIT26SBxJQ55quJYJ7zC31B1o3xaNe7pG4vXM3/1/N5upIZHNLj9gUY?=
 =?us-ascii?Q?7SM7fUdoLDxATFg1c33d1PBNk527wMpNNsu5asIe2MhbF4Xhgq7R2pOMUKDZ?=
 =?us-ascii?Q?+7kBCiW2n77iyT6/oJOMQq7JCi/2QYG0yWh1TG3wHY/vV77tw6eBtO7a5g/I?=
 =?us-ascii?Q?VEEL977kU56WKQxXSOXOUVoMtnqyp5IE9wug3v28HL2z1O+uIAnrwQVGSNxc?=
 =?us-ascii?Q?k5n84k6MA6Glm4MFexIsIwZdAOT9MuAn1GNh3h0Wj+QyPFFhvb1hWe8Fm+yr?=
 =?us-ascii?Q?c9smhH+k0nLrsGOWdgkdck24CZcBxFbDoqePeGUWyn9ctsVuuWVXwwvJh9xy?=
 =?us-ascii?Q?JrKeLcUhES6lNyJNsBRj1X9avxboUS2jxN7VVHR7ygiGSjsdxwd0MGCtAMDg?=
 =?us-ascii?Q?0d4SfrIR9xtEatdLew1DA/FZWzPHBtlD94fj3yyPJobPcpPbmRofz6o5AP8v?=
 =?us-ascii?Q?OB28zMAZO8xfEXkEi1NLSoBFN7qrCcMZXbBvo6DmN1v8ctHAapBl0dRHcD6D?=
 =?us-ascii?Q?j21ZMELzZDjO4AL/aqA8Yo4uDvnxkYV0unmCyjtKkaX/HsaSni0r+JHXyHrH?=
 =?us-ascii?Q?uQ1XxfmxBz5bFb1IbxjJsFDj/wwfVG20dOWjDdQxG4BqkLOampLOKiWAAE5w?=
 =?us-ascii?Q?SDb1f/vQP5XAJcGbZxkJ/So2bMsD5R9Y95d36FJG/a9fGSBgUurlZ8TJbtoy?=
 =?us-ascii?Q?OauYyMwReN88syRUdJCvY3/d8D/jhnbCCqEgFA2r36jnU6tE9FRp7GlAN5Z4?=
 =?us-ascii?Q?Sj7SEnM+ljq4BBWSfJ5Jcfy8AO5xzgtAieIgV2wikvtzNQVlnjOvpUw86a1F?=
 =?us-ascii?Q?MrTx8ISR7N6fRc6fx9y+0s1H3aPxeqa4drzGUROBb2DfzBG7LFJjNPTXBCSJ?=
 =?us-ascii?Q?Am/VWNfWcFRDD9fiQF8+hmZp1pyLyHPvHioCfRh0h9mexHkiiI9Ra2ayhara?=
 =?us-ascii?Q?NeVCwgiHd1/FjX1rRzDjVdO4vTZjICHeUNjh/fNRIuoIfm3uADRXYnS1F1ej?=
 =?us-ascii?Q?jXemb4I0Qqnw9ldYgScVVnPRLl7OQDvjwl7IcfOBzoRghcpGIsvXEV+E1W9t?=
 =?us-ascii?Q?GKKywiWUk6IBjJJ3uUIrp9jZ6Ln6gH0KQe4FPaFpUFSeIj9iNcFFdnY7WpWw?=
 =?us-ascii?Q?iYMdihx6cnfFz5i2ynVc2K4+gVeOu9D9dcOoN89yF+anUrtsIDbtjxc2t2ga?=
 =?us-ascii?Q?GtDDr2VMN/OKl3fz5xbmUSxV7Hm5b+Jhg/sb/jqeeLGGysWjyWN9WtegWvB/?=
 =?us-ascii?Q?Cg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d3e230f-46ec-44dd-b194-08daa0e2b7eb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 23:48:03.6638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kqrKsEL/buopAsK6v8vIw4Bk7DB1y3iSaypQii//H6a3jmJg7pqwsPZ6NQTdDsQ6sNf1OUvG16CviVvQUvmRGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9444
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Our current vsc9959_tas_guard_bands_update() algorithm has a limitation
imposed by the hardware design. To avoid packet overruns between one
gate interval and the next (which would add jitter for scheduled traffic
in the next gate), we configure the switch to use guard bands. These are
as large as the largest packet which is possible to be transmitted.

The problem is that at tc-taprio intervals of sizes comparable to a
guard band, there isn't an obvious place in which to split the interval
between the useful portion (for scheduling) and the guard band portion
(where scheduling is blocked).

For example, a 10 us interval at 1Gbps allows 1225 octets to be
transmitted. We currently split the interval between the bare minimum of
33 ns useful time (required to schedule a single packet) and the rest as
guard band.

But 33 ns of useful scheduling time will only allow a single packet to
be sent, be that packet 1200 octets in size, or 60 octets in size. It is
impossible to send 2 60 octets frames in the 10 us window. Except that
if we reduced the guard band (and therefore the maximum allowable SDU
size) to 5 us, the useful time for scheduling is now also 5 us, so more
packets could be scheduled.

The hardware inflexibility of not scheduling according to individual
packet lengths must unfortunately propagate to the user, who needs to
tune the queueMaxSDU values if he wants to fit more small packets into a
10 us interval, rather than one large packet.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none
v2->v3: implement TC_QUERY_CAPS for TC_SETUP_QDISC_TAPRIO

 drivers/net/dsa/ocelot/felix_vsc9959.c | 35 ++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2ec49e42b3f4..db6a29c5fda0 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1248,6 +1248,14 @@ static u32 vsc9959_port_qmaxsdu_get(struct ocelot *ocelot, int port, int tc)
 	}
 }
 
+static u32 vsc9959_tas_tc_max_sdu(struct tc_taprio_qopt_offload *taprio, int tc)
+{
+	if (!taprio || !taprio->max_sdu[tc])
+		return 0;
+
+	return taprio->max_sdu[tc] + ETH_HLEN + 2 * VLAN_HLEN + ETH_FCS_LEN;
+}
+
 /* Update QSYS_PORT_MAX_SDU to make sure the static guard bands added by the
  * switch (see the ALWAYS_GUARD_BAND_SCH_Q comment) are correct at all MTU
  * values (the default value is 1518). Also, for traffic class windows smaller
@@ -1257,6 +1265,7 @@ static u32 vsc9959_port_qmaxsdu_get(struct ocelot *ocelot, int port, int tc)
 static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct tc_taprio_qopt_offload *taprio;
 	u64 min_gate_len[OCELOT_NUM_TC];
 	int speed, picos_per_byte;
 	u64 needed_bit_time_ps;
@@ -1266,6 +1275,8 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 
 	lockdep_assert_held(&ocelot->tas_lock);
 
+	taprio = ocelot_port->taprio;
+
 	val = ocelot_read_rix(ocelot, QSYS_TAG_CONFIG, port);
 	tas_speed = QSYS_TAG_CONFIG_LINK_SPEED_X(val);
 
@@ -1302,11 +1313,12 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 		"port %d: max frame size %d needs %llu ps at speed %d\n",
 		port, maxlen, needed_bit_time_ps, speed);
 
-	vsc9959_tas_min_gate_lengths(ocelot_port->taprio, min_gate_len);
+	vsc9959_tas_min_gate_lengths(taprio, min_gate_len);
 
 	mutex_lock(&ocelot->fwd_domain_lock);
 
 	for (tc = 0; tc < OCELOT_NUM_TC; tc++) {
+		u32 requested_max_sdu = vsc9959_tas_tc_max_sdu(taprio, tc);
 		u64 remaining_gate_len_ps;
 		u32 max_sdu;
 
@@ -1317,7 +1329,7 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 			/* Setting QMAXSDU_CFG to 0 disables oversized frame
 			 * dropping.
 			 */
-			max_sdu = 0;
+			max_sdu = requested_max_sdu;
 			dev_dbg(ocelot->dev,
 				"port %d tc %d min gate len %llu"
 				", sending all frames\n",
@@ -1348,6 +1360,10 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 			 */
 			if (max_sdu > 20)
 				max_sdu -= 20;
+
+			if (requested_max_sdu && requested_max_sdu < max_sdu)
+				max_sdu = requested_max_sdu;
+
 			dev_info(ocelot->dev,
 				 "port %d tc %d min gate length %llu"
 				 " ns not enough for max frame size %d at %d"
@@ -1637,6 +1653,19 @@ static int vsc9959_qos_port_cbs_set(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static int vsc9959_qos_query_caps(struct tc_query_caps_base *base)
+{
+	switch (base->type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_caps *caps = base->caps;
+
+		caps->supports_queue_max_sdu = true;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int vsc9959_port_setup_tc(struct dsa_switch *ds, int port,
 				 enum tc_setup_type type,
 				 void *type_data)
@@ -1644,6 +1673,8 @@ static int vsc9959_port_setup_tc(struct dsa_switch *ds, int port,
 	struct ocelot *ocelot = ds->priv;
 
 	switch (type) {
+	case TC_QUERY_CAPS:
+		return vsc9959_qos_query_caps(type_data);
 	case TC_SETUP_QDISC_TAPRIO:
 		return vsc9959_qos_port_tas_set(ocelot, port, type_data);
 	case TC_SETUP_QDISC_CBS:
-- 
2.34.1

