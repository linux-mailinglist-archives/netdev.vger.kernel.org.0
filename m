Return-Path: <netdev+bounces-3588-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7173707F7D
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:36:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4DCF1C210C8
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 11:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCB901990F;
	Thu, 18 May 2023 11:35:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96891951E
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 11:35:09 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2F51BE9
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 04:35:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vaj/4nCQWxWCLLlR23EBbylC4gEViAzpqfUceDmKQaEq94Ct/kQBeXZCbdMU4G/XsfRuJI861SKH9Wl+JpEqPKGQyIPAeJxe16qEuGHMYO49fMqWkXg1oqM9VI9+1S32PYrqBvYAoLX3wXb0nBhzSsdaSETqJxg0lUKaKgPcU1mGfIPCwTFDJS+5jl63wmeqWO/3uZxyfd7b+gK3ct/g9yaUSgtU3pWGoGcxmIr7QvOYifoXv6mOmqsFA/UDJB55SNQrV2iSWJGVY8Kpi3JmS9OgGQj8J+3NX4aqUuasnCVkBCwnVcB4gdB163vrQqblpPIQ8wToltxe/hK3B6OLUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+JC35ro7zE3aai5AM0voSy7JdBNhtLPukhKGob/b1U8=;
 b=MXamLXvqwJ4j+mbT8FaVOPDcBdeko1wqTo148DTXQMbduZhvLZqT44xZyTl63i4LAvGLnPAxGsFJKsvLgvdpcw65ZSFr/7kCChQiWD/9g2OaEAP1Mhx16MeGw9zqcnEJxqsaPMUnDNq+/CFQFflNcAQ0XsHH19MG+1pq4JHYmSlMuLkRiMj7w6j79zY4zmW1HLcq8gbzzFKTSna5ICWFZVzgpv+mSLATPsZYLEgqzuZwgdMbJwr++9fpsWk6RFtF93QnY4oGROZRzEMbYf53S5p2XAarJHjBYjVLfEVo+IEJY3Lzowu3z4hjmLgkg8x9FOB3V1cFldLEOHGH/iF4vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+JC35ro7zE3aai5AM0voSy7JdBNhtLPukhKGob/b1U8=;
 b=PD5KM6M5a19NG6lbjWIAEmCx78V/0EddY/sUNx8BhAklWblxipqdfPhEK/f4/bj/N6gQh1lVra1d40PaP7ud4IzIJR5azEy6GTI6GOC3+lcZ13lAahuObMnTs3ymu7xsABto5t/j2gNd8XMdEWymi/VzKTIHhjC3ChPFyxBg5gOVT4bUVEU3LmnQxxJ/U3s+DXHa5eA5ucU4A+LpylSBXVeNlLXF9TS9ye6iyq9vezIxQJFdNBI1iYHn5T8X+heGYp7Xj5bsa+Oqyx0BRhHBajjRikU4gj7LLyMDRSsmj5fQ7sGX7MYU205yA0QUccf90+zq7hqH0HaLQs91vZ3pWA==
Received: from SJ0PR13CA0061.namprd13.prod.outlook.com (2603:10b6:a03:2c4::6)
 by DM4PR12MB6398.namprd12.prod.outlook.com (2603:10b6:8:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Thu, 18 May
 2023 11:35:01 +0000
Received: from DM6NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:2c4:cafe::e5) by SJ0PR13CA0061.outlook.office365.com
 (2603:10b6:a03:2c4::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.6 via Frontend
 Transport; Thu, 18 May 2023 11:35:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT113.mail.protection.outlook.com (10.13.173.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.19 via Frontend Transport; Thu, 18 May 2023 11:35:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 18 May 2023
 04:34:50 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Thu, 18 May 2023 04:34:45 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <razor@blackwall.org>, <roopa@nvidia.com>,
	<taras.chornyi@plvision.eu>, <saeedm@nvidia.com>, <leon@kernel.org>,
	<petrm@nvidia.com>, <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
	<alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
	<jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<taspelund@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/5] net/sched: flower: Allow matching on layer 2 miss
Date: Thu, 18 May 2023 14:33:25 +0300
Message-ID: <20230518113328.1952135-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230518113328.1952135-1-idosch@nvidia.com>
References: <20230518113328.1952135-1-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT113:EE_|DM4PR12MB6398:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a0027a2-6221-48b5-6882-08db5793ea4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eS3V7MrIuFpXJwdVrXpAJRgeN3LGcGJ0FnVGnBfi6iNPWhped8XejwGYxSneA92miCFhJEckvMmtyFVBW9KtJCpiuYQo/xFbqAnDCJL7aeUkTKWV6DTExMMhafxapSG6QN7SIoLO5ga5pGZDUoIWsJ7F9qOJM0NYW+dJDiaDSJIl6B01ylJ5uDZYvAEuIUFH1M0SjRWlXL1oCn2QkU8Dt1NP0EL1FYSHb3eo/bPeAnH6Da8kMoaw+eTrxPKdLeL7mHGuBNTwT0zeQnhoJsLMom8yNvJRxjr6ED/TFiw1yEqdet5IqgPJMhaLZsnUEmj0IMnYSB4GEJAUtVjbBIpRzj6P2wYPzf86yBPRfhCtfTFaa8MLp+eK0xPAyzs/iU9KDeCfn4q0e4AmaNq9bCmnyXostDUhzQ5fGFpqkALQRfzrbB+r7DH/+CplY4Ue1srnWUlesV0q9O0mTuLDA2OG/ZUr20nE0yP9W7GC2DSZU9Vz9FEHFFwSgsaaWXAcaXsx34qECskH3ykRWAbYM4zwQZb6QxOdgrTKkA2XY7CTzikpik/XTTCpRHyLopXNTz2Fe99FfqnZcraU5kmaDYXpi8lkvtzbsf1qK34rZ0wryGuemZAf65pkwbpxWiJB9FbFcZjNhE0fZGLxOhr3swZSGGscjo5HpEWh7tGqQzghnwRozY8biGS6jkpCVhHlM1hDRHRxCKs5q/P+tSUVZ3JTttecPeX2ICTo6c996INUAqH5VjYapOz5QKRcbHzQ+DH0
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199021)(36840700001)(46966006)(40470700004)(40460700003)(70586007)(4326008)(316002)(70206006)(54906003)(110136005)(36756003)(86362001)(478600001)(26005)(83380400001)(47076005)(107886003)(1076003)(16526019)(186003)(36860700001)(336012)(2616005)(6666004)(426003)(8936002)(8676002)(2906002)(7416002)(5660300002)(40480700001)(82310400005)(7636003)(82740400003)(356005)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 11:35:00.4532
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a0027a2-6221-48b5-6882-08db5793ea4f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6398
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add the 'TCA_FLOWER_L2_MISS' netlink attribute that allows user space to
match on packets that encountered a layer 2 miss. The miss indication is
set as metadata in the skb by the bridge driver upon FDB/MDB lookup
miss.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/flow_dissector.h |  2 ++
 include/uapi/linux/pkt_cls.h |  2 ++
 net/core/flow_dissector.c    |  3 +++
 net/sched/cls_flower.c       | 14 ++++++++++++--
 4 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 85b2281576ed..8b41668c77fc 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -243,10 +243,12 @@ struct flow_dissector_key_ip {
  * struct flow_dissector_key_meta:
  * @ingress_ifindex: ingress ifindex
  * @ingress_iftype: ingress interface type
+ * @l2_miss: packet did not match an L2 entry during forwarding
  */
 struct flow_dissector_key_meta {
 	int ingress_ifindex;
 	u16 ingress_iftype;
+	u8 l2_miss;
 };
 
 /**
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 648a82f32666..00933dda7b10 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -594,6 +594,8 @@ enum {
 
 	TCA_FLOWER_KEY_L2TPV3_SID,	/* be32 */
 
+	TCA_FLOWER_L2_MISS,		/* u8 */
+
 	__TCA_FLOWER_MAX,
 };
 
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 25fb0bbc310f..3776c7bdd228 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -241,6 +241,9 @@ void skb_flow_dissect_meta(const struct sk_buff *skb,
 					 FLOW_DISSECTOR_KEY_META,
 					 target_container);
 	meta->ingress_ifindex = skb->skb_iif;
+#if IS_ENABLED(CONFIG_BRIDGE)
+	meta->l2_miss = skb->l2_miss;
+#endif
 }
 EXPORT_SYMBOL(skb_flow_dissect_meta);
 
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 9dbc43388e57..4eb06c6367fc 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -615,7 +615,8 @@ static void *fl_get(struct tcf_proto *tp, u32 handle)
 }
 
 static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
-	[TCA_FLOWER_UNSPEC]		= { .type = NLA_UNSPEC },
+	[TCA_FLOWER_UNSPEC]		= { .strict_start_type =
+						TCA_FLOWER_L2_MISS },
 	[TCA_FLOWER_CLASSID]		= { .type = NLA_U32 },
 	[TCA_FLOWER_INDEV]		= { .type = NLA_STRING,
 					    .len = IFNAMSIZ },
@@ -720,7 +721,7 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
 	[TCA_FLOWER_KEY_PPPOE_SID]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_PPP_PROTO]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_L2TPV3_SID]	= { .type = NLA_U32 },
-
+	[TCA_FLOWER_L2_MISS]		= NLA_POLICY_MAX(NLA_U8, 1),
 };
 
 static const struct nla_policy
@@ -1668,6 +1669,10 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 		mask->meta.ingress_ifindex = 0xffffffff;
 	}
 
+	fl_set_key_val(tb, &key->meta.l2_miss, TCA_FLOWER_L2_MISS,
+		       &mask->meta.l2_miss, TCA_FLOWER_UNSPEC,
+		       sizeof(key->meta.l2_miss));
+
 	fl_set_key_val(tb, key->eth.dst, TCA_FLOWER_KEY_ETH_DST,
 		       mask->eth.dst, TCA_FLOWER_KEY_ETH_DST_MASK,
 		       sizeof(key->eth.dst));
@@ -3074,6 +3079,11 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
 			goto nla_put_failure;
 	}
 
+	if (fl_dump_key_val(skb, &key->meta.l2_miss,
+			    TCA_FLOWER_L2_MISS, &mask->meta.l2_miss,
+			    TCA_FLOWER_UNSPEC, sizeof(key->meta.l2_miss)))
+		goto nla_put_failure;
+
 	if (fl_dump_key_val(skb, key->eth.dst, TCA_FLOWER_KEY_ETH_DST,
 			    mask->eth.dst, TCA_FLOWER_KEY_ETH_DST_MASK,
 			    sizeof(key->eth.dst)) ||
-- 
2.40.1


