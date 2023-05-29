Return-Path: <netdev+bounces-6049-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0FF87148DB
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B118280E4D
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 11:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 757566ABA;
	Mon, 29 May 2023 11:49:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639C4A53
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 11:49:59 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2087.outbound.protection.outlook.com [40.107.243.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D5F9B
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 04:49:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knO44x5Dc3Bt/B/jlylumZ8dl4eaYFDU9fJJXddua0I06F/4lXSFUxYed3LEfWE5iZkdkIAvthaa+ZcrxcIKY/6/m+5reTYxcc7coOk1FmoZuQ/EHagZYe/w9g+GN8rbbVpDLTCeGcmEWrH88TGPwA78WBrEdjfuwaOsXVX8OJZO1VcJVS13QQXjixvj921kbBPJneZ2ocD6l2l0+rpLXM82SUALcGW2zCxmv/za5Riyf+R4O6wuYg/RrUT5AvB/NlGQENKlAbdNVCm9NqnmDLOzXhN4hX5LmoBUHk54laFG1fXIEllKpBRsi8cs+L1yve+LjqlGNOhlzf1GIC3DbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zX3ZXapMoybqW9SxbIxK65G+JaqV1YHwVd/wK5hmo1U=;
 b=GYmEbm49uXDfp1Iz33IlrK7btqW1W5cAfSw4m1ak42f3YRVdntBKZkkFMhWItR84V8FuqCXTHsr4CGBMK+/QsUpBL9gi+I/lXG+vwwCIaftmm0cLmoK3SUqmLXidi3d/LHvl9wof+Nlx7SXn6Z2fl6j0mjN7/U8Ii7sQ7ILiNMBYtxEzpX7s/bXTxud3aduIlpE7AI2AKBmAqdRNU3rcU/DGyDL47d/l66rFc8438yMb10AbDTJXRoD09/hE5e8NwhVU5XtfktX8ulJfWBgsamddio4CJ3YjAKx1koKdch31ijpEU9cePM1Z/DoQrtoU50Ud+HhTZ5cMVZl4yV8csQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zX3ZXapMoybqW9SxbIxK65G+JaqV1YHwVd/wK5hmo1U=;
 b=afrUuKCbsY6iJgJDzVWcreeB9AyFHJc0dpdouhqT/hMSQhAdFst9Wxq2E6SvUIitecW+QlI9S3PNFBzx0qtZ59L5zpFgHHYsTfPi+wdJekRc35/ui5BrE684/lQ9Am5iO9uLc6IIt7UnrXZVaLrPLnxUM1HYJuPWY/HQdCpbLAaDCWT/PdIP8jEi0n2s3eg34Z0iwR9jMhOcGhfZT+gsghUtBRMlPz7XkmHv2qpwIfTO4xyLrmvZSOxgGId7Dcn4Yky8ALMdJufvMCOlpqsFqTO+CxLBJtkKm/cNwdKd6SZo2Npqv1awvJUnvcUEB5AGb/oUj4FEePCTdehHc/6yYg==
Received: from SJ0PR03CA0035.namprd03.prod.outlook.com (2603:10b6:a03:33e::10)
 by LV8PR12MB9262.namprd12.prod.outlook.com (2603:10b6:408:1e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 11:49:54 +0000
Received: from DM6NAM11FT108.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:33e:cafe::f0) by SJ0PR03CA0035.outlook.office365.com
 (2603:10b6:a03:33e::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23 via Frontend
 Transport; Mon, 29 May 2023 11:49:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT108.mail.protection.outlook.com (10.13.172.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.21 via Frontend Transport; Mon, 29 May 2023 11:49:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 29 May 2023
 04:49:37 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 29 May 2023 04:49:31 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <taras.chornyi@plvision.eu>, <saeedm@nvidia.com>,
	<leon@kernel.org>, <petrm@nvidia.com>, <vladimir.oltean@nxp.com>,
	<claudiu.manoil@nxp.com>, <alexandre.belloni@bootlin.com>,
	<UNGLinuxDriver@microchip.com>, <jhs@mojatatu.com>,
	<xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <roopa@nvidia.com>,
	<razor@blackwall.org>, <simon.horman@corigine.com>, Ido Schimmel
	<idosch@nvidia.com>
Subject: [PATCH net-next v2 2/8] flow_dissector: Dissect layer 2 miss from tc skb extension
Date: Mon, 29 May 2023 14:48:29 +0300
Message-ID: <20230529114835.372140-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529114835.372140-1-idosch@nvidia.com>
References: <20230529114835.372140-1-idosch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT108:EE_|LV8PR12MB9262:EE_
X-MS-Office365-Filtering-Correlation-Id: 04d89ba5-e710-47a9-1920-08db603ad1af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Epm7knEe8hCFj4tXbZEPaKU0Pz8gIMkQmWHTggGD1AUYYRmsfUz1LSMu3AUqATIY5tB4Eu/Wd08p6RsW+AOgcWF6tWzqaP8oWlokw6PpUOuw9TSJTYdkfmSR12Ifn3Cm0QIlfKDXevuCuDay7kd+Eo7QDYQpTMQlyaLRZbrs+QZU7+y5Q+RiO51/PzotUF7xKLOjCSpICeowoT4Zeof4Pzk/YA4iq+xUlS0X9GSYDyUCs0aqPocPYsx8XKfO2fxOophVG03K3vRLkGixdomlzIzH1XXm68UBKzZ1/52yghnRTugRV9ldeUmylh12waCbcsCD2Tvc/yfxrSbcz6KEVE4kfbcccEwv6HibRrIOnrts3pUowEJVogFj9fMzF3lo0tu5ATjh5e/MjhU0aKQAl1CWHv5dSR/QYEsdrGw4kOtVaNjfNDlXE5qFecrCY5CA+Ib1SJ8lU/kXxSJkxyOvTe+MYIswLUNUr02FLVM/8NX3nyvUhko3qQ2fJpYaPbdywOxXt/qg18SM0dIvcDYwVlT+xLtGGQPR0FMRk5NrWKFtyZUd8lIwrZpvTb4MmkV2sSk5Dt4HsyI8s5hAAcJB/ITlL29jsbwlAGRkeAIst2mk5P8L6/9RLnRKLzaK7Oj3wqQYMY2zN0x3cxFDy5JXwJGy69fD9QvgNz2rC5H/2rLHf618mxXvXucgzlbeV62ZRmMTqJh7shLkjoE5jE/yfhJRJVxAsAw/f6oLBm5lXzQMcBBrlPyyNMgcY8ba/4Sp
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(36860700001)(40460700003)(47076005)(5660300002)(316002)(70586007)(70206006)(107886003)(7416002)(4326008)(82310400005)(36756003)(82740400003)(7636003)(8676002)(8936002)(356005)(41300700001)(86362001)(40480700001)(110136005)(54906003)(2906002)(2616005)(186003)(16526019)(336012)(426003)(478600001)(1076003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 11:49:54.3934
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04d89ba5-e710-47a9-1920-08db603ad1af
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT108.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9262
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Extend the 'FLOW_DISSECTOR_KEY_META' key with a new 'l2_miss' field and
populate it from a field with the same name in the tc skb extension.
This field is set by the bridge driver for packets that incur an FDB or
MDB miss.

The next patch will extend the flower classifier to be able to match on
layer 2 misses.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    v2:
    * Split from flower patch.
    * Use tc skb extension instead of 'skb->l2_miss'.

 include/net/flow_dissector.h |  2 ++
 net/core/flow_dissector.c    | 10 ++++++++++
 2 files changed, 12 insertions(+)

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
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 25fb0bbc310f..481ca4080cbd 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -27,6 +27,7 @@
 #include <linux/tcp.h>
 #include <linux/ptp_classify.h>
 #include <net/flow_dissector.h>
+#include <net/pkt_cls.h>
 #include <scsi/fc/fc_fcoe.h>
 #include <uapi/linux/batadv_packet.h>
 #include <linux/bpf.h>
@@ -241,6 +242,15 @@ void skb_flow_dissect_meta(const struct sk_buff *skb,
 					 FLOW_DISSECTOR_KEY_META,
 					 target_container);
 	meta->ingress_ifindex = skb->skb_iif;
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	if (tc_skb_ext_tc_enabled()) {
+		struct tc_skb_ext *ext;
+
+		ext = skb_ext_find(skb, TC_SKB_EXT);
+		if (ext)
+			meta->l2_miss = ext->l2_miss;
+	}
+#endif
 }
 EXPORT_SYMBOL(skb_flow_dissect_meta);
 
-- 
2.40.1


