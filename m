Return-Path: <netdev+bounces-6304-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E3AB87159E9
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:21:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76EEB1C20B15
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A314C13AF3;
	Tue, 30 May 2023 09:21:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7221426A
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:21:13 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2059.outbound.protection.outlook.com [40.107.6.59])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD7010D5;
	Tue, 30 May 2023 02:20:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIYELnMBbSMV75HCq+Rz6/5SHO2MtGaSQ+euZCRpMtivV0EEx9Q/5RNsC2YNo1c4uaQA8fUWu0V/SmOzva5Hrq6v2IX6sHMUusB04g7dEEm4Ncfhly3+5xbpMql9k82qyQOzIoIrPkmuKQbnNunuxE+zJiRwk3uQaEopeqKG/BIdk7zGpe3m3uvp8L2Jgwmq5awikQvORorrtsAqXm4BCqHQVkZAHvSvD7yXcWlUrDgM7Yh0ARAWlBR80Jitxhq2aYI/C3hXztfoai5ZhHhFJPjT37sHmBjAj6rb4RKCwe7/ZSfa5XHWE0oR1nc0wArEAami4STTqjWxf/1ojAnilg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BtkZpYfXeGBh2Yn69kyjMNGg1iDOxeC/KYzXKmxFsYE=;
 b=Mi8oK9JagoVl8QBPxqgZgZreTwMdNBZpHtyfwu38HhBYMXm2KhWa84tqazCmHGFjUQBGCgh9i96H7dXdNCX5c06igXqLQGZEAqSE0id+dxzMnqyFfe7H2D/KaJaq/fV7W+gKEy9LUvtBO/OLH3Nar9mwJk2LgcXiW7MmZHVBphcOWJ6eFwHtLUglJuZ5Tzynrbt4ZHwaxf5qnlKdiGK8sapdt0LrGgIhPfi+LbRCm7e/ifutu/514GMQ4Rw5N5q89dqdqKcl3cI01HiarXH240MEv8w66PzedfhJrTUzLqp57eHkSlvAUkuD+oRQAjrESOJlVqZ0DgmuRDcDyTz9Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtkZpYfXeGBh2Yn69kyjMNGg1iDOxeC/KYzXKmxFsYE=;
 b=cafou14AdaCjybHeZO4K7NI/5xHACXyPefo+VtM6FVX+SYUrDP1YB5uwImxykoTSR76GOqjMBm2tXcy7OFD7Sgpq4415Mo6XOXPbSrzgytCxIj0GaW/I68W4m9v5AtZ3PtPEsJqP10YHIWh7lDJwI1BmPBX0GT+7Ne37TQODjv8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB7167.eurprd04.prod.outlook.com (2603:10a6:800:12a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 09:20:12 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea%6]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 09:20:12 +0000
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Amritha Nambiar <amritha.nambiar@intel.com>,
	Ferenc Fejes <ferenc.fejes@ericsson.com>,
	Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
	Roger Quadros <rogerq@kernel.org>,
	Pranavi Somisetty <pranavi.somisetty@amd.com>,
	Harini Katakam <harini.katakam@amd.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
	Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	linux-kernel@vger.kernel.org,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	UNGLinuxDriver@microchip.com,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	intel-wired-lan@lists.osuosl.org,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: [PATCH net-next 3/5] net/sched: taprio: add netlink reporting for offload statistics counters
Date: Tue, 30 May 2023 12:19:46 +0300
Message-Id: <20230530091948.1408477-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230530091948.1408477-1-vladimir.oltean@nxp.com>
References: <20230530091948.1408477-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0155.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::18) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB7167:EE_
X-MS-Office365-Filtering-Correlation-Id: c3bf6029-81a9-4e9f-f74d-08db60ef1277
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aQc5+jRH8dzOT44c65SP5tTD5NfwrCHaCICKcFKmZs0EwGnkbr1GhAw8NJyUbJvTXcCQYueuSSMF6vD+14vp1lp1e4xEu9U58bOKice+87p36MGU3VYmR6xLQDgqeiwg7HFsOcjOl517xdbTmhf+zFnl4LXVwc17aQoa/yBssdCi8w3X6qDtZtUW4Mz8VrUsVpKdlY8ezEMAKj14o83OKPBlvxfiw4e74tU8pvK95DS5w0NcjS5cmmTJChvvxo2Tqx9jTB4HnEkdjbE0Mja2GMngWpubfC0oiziC2nQc3Gk4Qu68c1v0fbtWKO+bvNjL0/j7sVZ+cYy57HNd6perhtivVNZkgwQl4w6oU1Q7rpBgnh2ZO0sHIixaI8y/k4NhgtcuekazdTyDS005kJ2DoHWkWTOmKbrnmmh98+b05h9xNNOFz8BccebUx0/Z+Ju/V7t6B6wrOIhO6h+6Fw4rAfmki8WfPZ1lOviuXQzUiMJYLBmzK2o5h59WRRHAkayMi0nuNGg7Wb+wgysz9WJpHxXUFUHEGQBnrIwmMa6wFFUY79lOPKx46yTj5mxjBddDTQedPOmlhDCNxtUzkiYf63vfgP7hKL23FQ9v5eSxCFbb2UuqSkYVVFbOwudOlm9s
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(451199021)(54906003)(478600001)(38100700002)(38350700002)(66946007)(66556008)(66476007)(6486002)(41300700001)(52116002)(7416002)(7406005)(8676002)(8936002)(5660300002)(86362001)(44832011)(26005)(2906002)(186003)(1076003)(6506007)(6512007)(83380400001)(6916009)(4326008)(316002)(6666004)(2616005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TDPNmHfOb0sJWF1n3ITHv5JBOMNHDv0nIk0knwTWxPqZBrtFB8rY5XnL817V?=
 =?us-ascii?Q?RZiokVn6KiFW5lMgg4COkqtAtcUg5tnIzyLhqcKPBx5vdKq8WFuV721dy03b?=
 =?us-ascii?Q?Jg1XJ6zJqXEZFxQv5WTyxsA8Gi4UXYWPzRMeVS5QMVc+ObBnyQ39JTpvaQmO?=
 =?us-ascii?Q?IuFH0OWo0pwhcGgFKCDxJNgEXs4et5mJIlhq2tCZlC/eTu1tayxkm8pwP5zt?=
 =?us-ascii?Q?aInDSFJqUmgAEfikw4juWNYaZVkc4LlCmVeP/62S3mU4RIF4fTQngih5zzqB?=
 =?us-ascii?Q?jcy/Z9EIoyrUC8lNWYAZbrKdEGi32BL5/Kfcncfc1o5OaDjhPotTmrVUEAHz?=
 =?us-ascii?Q?ATz6bUQ+nGA7PfQ9FUNgpJuCPvoP0MMAPjAogevpl0/RqWpStgukakiO+rA/?=
 =?us-ascii?Q?2W93zFLMaF0WjDLip2HIrVPRmMH2MNSpm5lhbg/z2zAw/TuZlmftm8k2nidm?=
 =?us-ascii?Q?T/LYczei5lEpRhV6gh8VmTGyVNTgZo9QaM+ORRvYjwV3nGch0LC99s8CR8Wi?=
 =?us-ascii?Q?sdBF8RtRr/hbDEwdJApAgfq0vkdNP7Feeaa2exs8ZorjZwo33Yj15kZ2fYbW?=
 =?us-ascii?Q?R10g2Ybxlbq0Iqn7uDud64r3+wOa2MT2apeGHDOh7N/aES7kOS6b+QqYfuDO?=
 =?us-ascii?Q?0xFkbVRcBwkPnuUr9v9oIK0qw9WIkKbg5Tcjx8R4VxvK3Hr3PS4O/zk1G2nh?=
 =?us-ascii?Q?kUE+5E7sC/pva9IyASXWa0NQPg/Ch6VqWn+52tUyLVu+2u/yyjDYjcpET9zM?=
 =?us-ascii?Q?Lwke7DsKFzRALoexeQJUxB6/8dEsM9exfkqioQFbcD4glcgK1elht3gMZgPX?=
 =?us-ascii?Q?iSvHMSvBIHotebcSZv92kpGyuMfsfKGD4In0Y/VbbZl3YyJVGeSuo8kqEbol?=
 =?us-ascii?Q?PakIIkaIUSbBgR/sBvlkil1XwI7hJurgxqJ6InK+H079Bsuz4BkUY4h3s9NR?=
 =?us-ascii?Q?d3Rf9eN3wKCvznStCiK+bL3HLz5YPiv36VR3qSRbhDhUcJv7pRAE7cdSsrB0?=
 =?us-ascii?Q?kPppKFk/pHSQ78Uj1pZhapOTioug7XlHTDqQ2ltSRJA89V29XcN5TfSrerfK?=
 =?us-ascii?Q?V2zdNy0QAAXA1nWu3B255dn2hsbPTGo//bLMlPhhlp+Nf88JEZwxv1p0UYm9?=
 =?us-ascii?Q?EqutxNRB5C3dtG30fby7U2BR3l6DwiCaYq+/bnV2MOW3Xx1d3BmiR7MjT0xQ?=
 =?us-ascii?Q?oC6hrqWX6bTqvZEP+dHGPKRDn6TpeuacYR4zscHPiwkopchqXFl67XcVf/3R?=
 =?us-ascii?Q?mkmERDsehOriZ/BlNpXMv6UGREiev+8Xnk5mv3SEtKJVT7jkNoSSkllmXK2V?=
 =?us-ascii?Q?nBKm3AZZSgZ4EpNI1J37wJNcA++asCHeAWeWze8zMAXWjlBHUj+BnKtRILJd?=
 =?us-ascii?Q?UKqEGedYcopNbNEBfl/VZPnMZRpi7OjAGUOQrXdGUcQ6ssaYA4T+NL4Tl4dV?=
 =?us-ascii?Q?oNMj9KKJD0ds2YXqzEIkHwwIezkuAaRLw+Dk8OO3ewGMPjvXHhKFKO+sSd1H?=
 =?us-ascii?Q?n7bq1y2Iun1N0tTm/lJMfz/fKgRsfbuOVJZFBs14FrTlsuPo8ka6GSmoCjQV?=
 =?us-ascii?Q?/GrNNFyyly+/YEkeWx45g5ZgifMdiCGvdsrr+4mrE8vSP5Q+ZINoMXTsXNa0?=
 =?us-ascii?Q?sQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3bf6029-81a9-4e9f-f74d-08db60ef1277
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 09:20:12.8431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dVxAgpXlT9HyeLXQnVn0alMHnB2y0qxZ04PnqwATmQDxYTERQgD+11rw00ziVPBS0yXeV4D5uyrcnWGBc4CBvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7167
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Offloading drivers may report some additional statistics counters, some
of them even suggested by 802.1Q, like TransmissionOverrun.

In my opinion we don't have to limit ourselves to reporting counters
only globally to the Qdisc/interface, especially if the device has more
detailed reporting (per traffic class), since the more detailed info is
valuable for debugging and can help identifying who is exceeding its
time slot.

But on the other hand, some devices may not be able to report both per
TC and global stats.

So we end up reporting both ways, and use the good old ethtool_put_stat()
strategy to determine which statistics are supported by this NIC.
Statistics which aren't set are simply not reported to netlink. For this
reason, we need something dynamic (a nlattr nest) to be reported through
TCA_STATS_APP, and not something daft like the fixed-size and
inextensible struct tc_codel_xstats. A good model for xstats which are a
nlattr nest rather than a fixed struct seems to be cake.

 # Global stats
 $ tc -s qdisc show dev eth0 root
 # Per-tc stats
 $ tc -s class show dev eth0

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/pkt_sched.h        | 47 ++++++++++++++++----
 include/uapi/linux/pkt_sched.h | 10 +++++
 net/sched/sch_taprio.c         | 78 +++++++++++++++++++++++++++++++++-
 3 files changed, 126 insertions(+), 9 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index f5fb11da357b..530d33adec88 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -188,6 +188,27 @@ struct tc_taprio_caps {
 enum tc_taprio_qopt_cmd {
 	TAPRIO_CMD_REPLACE,
 	TAPRIO_CMD_DESTROY,
+	TAPRIO_CMD_STATS,
+	TAPRIO_CMD_TC_STATS,
+};
+
+/**
+ * struct tc_taprio_qopt_stats - IEEE 802.1Qbv statistics
+ * @window_drops: Frames that were dropped because they were too large to be
+ *	transmitted in any of the allotted time windows (open gates) for their
+ *	traffic class.
+ * @tx_overruns: Frames still being transmitted by the MAC after the
+ *	transmission gate associated with their traffic class has closed.
+ *	Equivalent to `12.29.1.1.2 TransmissionOverrun` from 802.1Q-2018.
+ */
+struct tc_taprio_qopt_stats {
+	u64 window_drops;
+	u64 tx_overruns;
+};
+
+struct tc_taprio_qopt_tc_stats {
+	int tc;
+	struct tc_taprio_qopt_stats stats;
 };
 
 struct tc_taprio_sched_entry {
@@ -199,16 +220,26 @@ struct tc_taprio_sched_entry {
 };
 
 struct tc_taprio_qopt_offload {
-	struct tc_mqprio_qopt_offload mqprio;
-	struct netlink_ext_ack *extack;
 	enum tc_taprio_qopt_cmd cmd;
-	ktime_t base_time;
-	u64 cycle_time;
-	u64 cycle_time_extension;
-	u32 max_sdu[TC_MAX_QUEUE];
 
-	size_t num_entries;
-	struct tc_taprio_sched_entry entries[];
+	union {
+		/* TAPRIO_CMD_STATS */
+		struct tc_taprio_qopt_stats stats;
+		/* TAPRIO_CMD_TC_STATS */
+		struct tc_taprio_qopt_tc_stats tc_stats;
+		/* TAPRIO_CMD_REPLACE */
+		struct {
+			struct tc_mqprio_qopt_offload mqprio;
+			struct netlink_ext_ack *extack;
+			ktime_t base_time;
+			u64 cycle_time;
+			u64 cycle_time_extension;
+			u32 max_sdu[TC_MAX_QUEUE];
+
+			size_t num_entries;
+			struct tc_taprio_sched_entry entries[];
+		};
+	};
 };
 
 #if IS_ENABLED(CONFIG_NET_SCH_TAPRIO)
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 51a7addc56c6..00f6ff0aff1f 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1259,6 +1259,16 @@ enum {
 	TCA_TAPRIO_TC_ENTRY_MAX = (__TCA_TAPRIO_TC_ENTRY_CNT - 1)
 };
 
+enum {
+	TCA_TAPRIO_OFFLOAD_STATS_PAD = 1,	/* u64 */
+	TCA_TAPRIO_OFFLOAD_STATS_WINDOW_DROPS,	/* u64 */
+	TCA_TAPRIO_OFFLOAD_STATS_TX_OVERRUNS,	/* u64 */
+
+	/* add new constants above here */
+	__TCA_TAPRIO_OFFLOAD_STATS_CNT,
+	TCA_TAPRIO_OFFLOAD_STATS_MAX = (__TCA_TAPRIO_OFFLOAD_STATS_CNT - 1)
+};
+
 enum {
 	TCA_TAPRIO_ATTR_UNSPEC,
 	TCA_TAPRIO_ATTR_PRIOMAP, /* struct tc_mqprio_qopt */
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 06bf4c6355a5..3c4c2c334878 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -27,6 +27,8 @@
 #include <net/sock.h>
 #include <net/tcp.h>
 
+#define TAPRIO_STAT_NOT_SET	(~0ULL)
+
 #include "sch_mqprio_lib.h"
 
 static LIST_HEAD(taprio_list);
@@ -2289,6 +2291,72 @@ static int taprio_dump_tc_entries(struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
+static int taprio_put_stat(struct sk_buff *skb, u64 val, u16 attrtype)
+{
+	if (val == TAPRIO_STAT_NOT_SET)
+		return 0;
+	if (nla_put_u64_64bit(skb, attrtype, val, TCA_TAPRIO_OFFLOAD_STATS_PAD))
+		return -EMSGSIZE;
+	return 0;
+}
+
+static int taprio_dump_xstats(struct Qdisc *sch, struct gnet_dump *d,
+			      struct tc_taprio_qopt_offload *offload,
+			      struct tc_taprio_qopt_stats *stats)
+{
+	struct net_device *dev = qdisc_dev(sch);
+	const struct net_device_ops *ops;
+	struct sk_buff *skb = d->skb;
+	struct nlattr *xstats;
+	int err;
+
+	ops = qdisc_dev(sch)->netdev_ops;
+
+	/* FIXME I could use qdisc_offload_dump_helper(), but that messes
+	 * with sch->flags depending on whether the device reports taprio
+	 * stats, and I'm not sure whether that's a good idea, considering
+	 * that stats are optional to the offload itself
+	 */
+	if (!ops->ndo_setup_tc)
+		return 0;
+
+	memset(stats, 0xff, sizeof(*stats));
+
+	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
+	if (err == -EOPNOTSUPP)
+		return 0;
+	if (err)
+		return err;
+
+	xstats = nla_nest_start(skb, TCA_STATS_APP);
+	if (!xstats)
+		goto err;
+
+	if (taprio_put_stat(skb, stats->window_drops,
+			    TCA_TAPRIO_OFFLOAD_STATS_WINDOW_DROPS) ||
+	    taprio_put_stat(skb, stats->tx_overruns,
+			    TCA_TAPRIO_OFFLOAD_STATS_TX_OVERRUNS))
+		goto err_cancel;
+
+	nla_nest_end(skb, xstats);
+
+	return 0;
+
+err_cancel:
+	nla_nest_cancel(skb, xstats);
+err:
+	return -EMSGSIZE;
+}
+
+static int taprio_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
+{
+	struct tc_taprio_qopt_offload offload = {
+		.cmd = TAPRIO_CMD_STATS,
+	};
+
+	return taprio_dump_xstats(sch, d, &offload, &offload.stats);
+}
+
 static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
@@ -2389,11 +2457,18 @@ static int taprio_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 {
 	struct netdev_queue *dev_queue = taprio_queue_get(sch, cl);
 	struct Qdisc *child = dev_queue->qdisc_sleeping;
+	struct tc_taprio_qopt_offload offload = {
+		.cmd = TAPRIO_CMD_TC_STATS,
+		.tc_stats = {
+			.tc = cl - 1,
+		},
+	};
 
 	if (gnet_stats_copy_basic(d, NULL, &child->bstats, true) < 0 ||
 	    qdisc_qstats_copy(d, child) < 0)
 		return -1;
-	return 0;
+
+	return taprio_dump_xstats(sch, d, &offload, &offload.tc_stats.stats);
 }
 
 static void taprio_walk(struct Qdisc *sch, struct qdisc_walker *arg)
@@ -2440,6 +2515,7 @@ static struct Qdisc_ops taprio_qdisc_ops __read_mostly = {
 	.dequeue	= taprio_dequeue,
 	.enqueue	= taprio_enqueue,
 	.dump		= taprio_dump,
+	.dump_stats	= taprio_dump_stats,
 	.owner		= THIS_MODULE,
 };
 
-- 
2.34.1


