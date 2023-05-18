Return-Path: <netdev+bounces-3587-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9043F707F77
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:35:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EA441C21026
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 11:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9412B1990A;
	Thu, 18 May 2023 11:35:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F96019902
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 11:35:06 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F64EA
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 04:34:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5+siAzCthcTavXpUzTlRIfv9lK2vlxLYZOgC/sG/pHKeJL/OuV+kXbMc3ehlVa7C33MDn7EoA8qB3V3WpcpgXqvXuM6rTi+c7Zr2bl2CKaNDJX5alv0TCHDz6yT+8uXchzNWBYWJc9145HpOJHTxar4TE6xCqV2N56KywCcnwK2XpVa0p7uS8zp5qpCP3dBKM/MWczJL4fNmfqLKcQkMj9u2KMwSEN1PhxMt3wMvOg0AgABiMRzJsJfBl0uX/y+aEITJWP9TgpHKXvenZVqpYg2qtWOO6Ju29XQ9L96LeFCpnfNLjglWZV/gBI5xr/5jkUABtqj/Jq7ac4S+IeBkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3U0gVe0IZp8tb/PBmr/db2c4m/Qqc+y3KMkhyWl8Pb4=;
 b=msPIRXUEDwF4EAS/HLmix9yIo+g8wjiF652qiTfphN7mEII70t8fqdECrZ7zOSHFMWOiQXyek6K5mpxmNxH4FDK9BqyCvceETMT6l/E0Y1d+jzR68o0qwGTOJYbTtRuMButRPfuqMI6EYycYpxeg7KsfN4EcishqnjbYC7Nr73LEXER8kkGiD5zvBAS8DpD/rhOIgq5DjNd7Gnj+wzjZKcAZM763UCMdmON5GVQWaUgyp/WHbUhCdKQhaieK/Cx4iC1K6JVB7RnIJ1WfqEJglZcHNppm6ecb56d6du5IZgx0QVzXldIDgcm6OGXYJ0fRCNIv55zNiKSMl413/oBYOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3U0gVe0IZp8tb/PBmr/db2c4m/Qqc+y3KMkhyWl8Pb4=;
 b=dD30uOvtgcboI6ksNr7TUMMsbNCzlt5uIstkhUrO6oWaD+vOhFlWT8Bj+PTH+Lprjndn5rfRrzp4aEtmwUlHHTdAn/qDQEq+Ua4mfPqXD3GHBWkutjzj4P3x7OSvn3/Yb36HgfkPubaMuMJTI6dchKm452xdtGOpT3lAEZ33Vw5VhYV4guAryeADz437Rc9AttELQ5keu1ela6zCiCg8UouPaQc/cC5Qdx474/EwEvevfL66yS8R+Ju/YDTgacQv0KE/1wLSpQTeTH/JtzA4NRUo3F0r2XbAcv/AKFS7o5AFRsyJVRnuf4hmQ6TC9jp8SIDQxPRjYprhh0b51Smh6A==
Received: from SJ0PR13CA0085.namprd13.prod.outlook.com (2603:10b6:a03:2c4::30)
 by PH7PR12MB5951.namprd12.prod.outlook.com (2603:10b6:510:1da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Thu, 18 May
 2023 11:34:57 +0000
Received: from DM6NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:2c4:cafe::e0) by SJ0PR13CA0085.outlook.office365.com
 (2603:10b6:a03:2c4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.6 via Frontend
 Transport; Thu, 18 May 2023 11:34:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT113.mail.protection.outlook.com (10.13.173.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.19 via Frontend Transport; Thu, 18 May 2023 11:34:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 18 May 2023
 04:34:44 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Thu, 18 May 2023 04:34:39 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <razor@blackwall.org>, <roopa@nvidia.com>,
	<taras.chornyi@plvision.eu>, <saeedm@nvidia.com>, <leon@kernel.org>,
	<petrm@nvidia.com>, <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
	<alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
	<jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<taspelund@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/5] skbuff: bridge: Add layer 2 miss indication
Date: Thu, 18 May 2023 14:33:24 +0300
Message-ID: <20230518113328.1952135-2-idosch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT113:EE_|PH7PR12MB5951:EE_
X-MS-Office365-Filtering-Correlation-Id: 264d6f83-806a-48f6-0fd5-08db5793e869
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	laprFPTvKpNxUMZS3qdNJRjFAjijm70xsr8UBrn4pbMMhQyktXGRauGtNVUr6JzlJBnNCcVd9YEdQp5rbvu8cSZUrMLr/3vPa687KuzaatP81j6ZHJ0bxQnR9MWx+DLVqvDXhvXMJ2641+R6sqkUmf3uBTafRohC6Ef0sj+e3lod+bq7zkkO6bOIa7bn86FATKGYQpGQSnzBYZ7kuf3DWKvbPXGiotx16ZGVYx1K5+ga7ntmGwLyHnupHHfuHZ2m8hFc4T3Z0+J0x9Z9iURbsDW0XSHQZZlbpjddQRVsXJAaNHD2BQeG0sH+DigO6tqNfArgvRouUq2qkgX9X1ophKED8cx3wV34jTuBTV/r+1Tt1zyg4mDJDafOy1+TJK8HaKYSppE0vMcCe20gEcYe/R9sSNv4kpllfr+GWYWWHY5YpsUihfxt4qbko6duG4Nig1LLYmgo1tk/M1dzc9TsgopwUc6JDklP3j12GiFINyb3pky2IohNU6BWjZH4q+c+wTwqmV/Wts6KSGrR33qJioQbQmsadQdJFByFSMoSTguiNaoTsz4NXRtocxGn5NyOjEA9HTxqeXhkvKZPhCiXdhSCalZdVLcdYFLdkq2hRHcYtwMaNzjQPHayYnsEIOQdQu/zTR1ZUyw5DtAZF4scxOtxHv+bWeC7Lm7kWfbONoYyTl32KFz9zOu8U7DJsiUT93/h0VuhXjsyT989QFV+HeH44YIU86X7wQouds47TyuHreOOXOmDk8j+uXTjqW/VIYDg76ce017vEDYvVQ9E9Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(346002)(396003)(376002)(451199021)(46966006)(40470700004)(36840700001)(83380400001)(36860700001)(336012)(47076005)(426003)(70586007)(70206006)(26005)(8676002)(107886003)(2616005)(40460700003)(40480700001)(478600001)(54906003)(5660300002)(110136005)(7416002)(36756003)(186003)(6666004)(1076003)(16526019)(86362001)(8936002)(82740400003)(41300700001)(316002)(2906002)(356005)(7636003)(4326008)(82310400005)(21314003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 11:34:57.2659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 264d6f83-806a-48f6-0fd5-08db5793e869
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5951
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Allow the bridge driver to mark packets that did not match a layer 2
entry during forwarding by adding a 'l2_miss' bit to the skb.

Clear the bit whenever a packet enters the bridge (received from a
bridge port or transmitted via the bridge) and set it if the packet did
not match an FDB/MDB entry.

Subsequent patches will allow the flower classifier to match on this
bit. The motivating use case in non-DF (Designated Forwarder) filtering
where we would like to prevent decapsulated packets from being flooded
to a multi-homed host.

Do not allocate the bit if the kernel was not compiled with bridge
support and place it after the two bit fields in accordance with commit
4c60d04c2888 ("net: skbuff: push nf_trace down the bitfield"). The bit
does not increase the size of the structure as it is placed at an
existing hole. Layout with allmodconfig:

struct sk_buff {
[...]
			__u8       csum_not_inet:1;      /*   132: 3  1 */
			__u8       l2_miss:1;            /*   132: 4  1 */

			/* XXX 3 bits hole, try to pack */
			/* XXX 1 byte hole, try to pack */

			__u16      tc_index;             /*   134     2 */
			u16        alloc_cpu;            /*   136     2 */
[...]
} __attribute__((__aligned__(8)));

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/linux/skbuff.h  | 4 ++++
 net/bridge/br_device.c  | 1 +
 net/bridge/br_forward.c | 3 +++
 net/bridge/br_input.c   | 1 +
 4 files changed, 9 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8cff3d817131..b64dc3f62c5c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -801,6 +801,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@encap_hdr_csum: software checksum is needed
  *	@csum_valid: checksum is already valid
  *	@csum_not_inet: use CRC32c to resolve CHECKSUM_PARTIAL
+ *	@l2_miss: Packet did not match an L2 entry during forwarding
  *	@csum_complete_sw: checksum was completed by software
  *	@csum_level: indicates the number of consecutive checksums found in
  *		the packet minus one that have been verified as
@@ -991,6 +992,9 @@ struct sk_buff {
 #if IS_ENABLED(CONFIG_IP_SCTP)
 	__u8			csum_not_inet:1;
 #endif
+#if IS_ENABLED(CONFIG_BRIDGE)
+	__u8			l2_miss:1;
+#endif
 
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 8eca8a5c80c6..91dbdae4afd4 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -39,6 +39,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	u16 vid = 0;
 
 	memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
+	skb->l2_miss = 0;
 
 	rcu_read_lock();
 	nf_ops = rcu_dereference(nf_br_ops);
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 84d6dd5e5b1a..8cf5a51489ce 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -203,6 +203,8 @@ void br_flood(struct net_bridge *br, struct sk_buff *skb,
 	struct net_bridge_port *prev = NULL;
 	struct net_bridge_port *p;
 
+	skb->l2_miss = 1;
+
 	list_for_each_entry_rcu(p, &br->port_list, list) {
 		/* Do not flood unicast traffic to ports that turn it off, nor
 		 * other traffic if flood off, except for traffic we originate
@@ -295,6 +297,7 @@ void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
 			allow_mode_include = false;
 	} else {
 		p = NULL;
+		skb->l2_miss = 1;
 	}
 
 	while (p || rp) {
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index fc17b9fd93e6..d8ab5890cbe6 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -334,6 +334,7 @@ static rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 		return RX_HANDLER_CONSUMED;
 
 	memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
+	skb->l2_miss = 0;
 
 	p = br_port_get_rcu(skb->dev);
 	if (p->flags & BR_VLAN_TUNNEL)
-- 
2.40.1


