Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1454D56BF1F
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239054AbiGHRnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 13:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238944AbiGHRns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 13:43:48 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130135.outbound.protection.outlook.com [40.107.13.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE40FDF10;
        Fri,  8 Jul 2022 10:43:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j+9cg02e4sd2gpKe5WHSb6o7+/LUVzi1rPTV2DtknXS+SvjNGTe3JxOhYm7abvk2Uldm29KX0iQfzxiVPU7gjuuSWsC5wZis18Mqg5gosGKS0+KFNWx8p+SbMZnAmHVp1ku0oOyxC4fVaLrhlzvb41zO7IY1vxDlQYg+B1aTGKmizeqo4gtTFNApIRUOzQ/emEE4W2xc7nm0YQDoxzbcyUoBqy1IkRbzADf5TqQ3vyav4jOthWMo/U/Wx2Jg0W4XE7joWKdMEKY0/BP7s032mWf/ZMlW14L44t/jABHAQFqACJxcJGHhMx3jtRIPXWQHeuDxq5Q+RM/VVA/hjXMX6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ksutx2RW4x0Lz0Iho5G2F5CgEfNeQ2Xl0szoV1ygqXA=;
 b=iptgEIhnP0hPly0nf//0Sik2Vt9kjdf1DuXRc/icMHOjcQPO3wvLTVXsM5VogdHzjxHEeXh66HM/Rew/gPiFIfxvgmJoheADGyLitJw3QMiBz355Kn/xzhCAG8SFDhuTKtWEuLaWfyvELV6MGADfA+DjxfDJJ/E9zUeYzc6DowcdtDaOM/T2iZLuaZwTTdaniAU29+1INT4BOejg8qrdUznqEmLrFWR+imDzKUQ77wmrYMlfUaTxnz+2MSIf2PICd2bvaAUfFXDVS5M6mGLciEs98cKdtjnQe8JEaK2ijO0Qv77C/oNBCIuybqBqYG137WM15cLZAPw0pNJNb99iIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ksutx2RW4x0Lz0Iho5G2F5CgEfNeQ2Xl0szoV1ygqXA=;
 b=e0s0c3nww1W1RNZWmFImfKkjXUwnHTSc6Tv1UEc6OXb+tOz4fN7uRO7/qBhkEDvQm0B8ziRVl5xiUx+hDDGms44xB25td3uQMO0x6desjABpBzfHcFcFy7ORtUL55Fkzvgz3nIR2GGVG+Q3lGfGbHvWRUlT2F4qHhLptNjYS9j0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by AS8P190MB1414.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3f1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Fri, 8 Jul
 2022 17:43:40 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 17:43:40 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, oleksandr.mazur@plvision.eu,
        tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lkp@intel.com,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH V4 net-next 2/4] net: marvell: prestera: define MDB/flood domain entries and HW API to offload them to the HW
Date:   Fri,  8 Jul 2022 20:43:22 +0300
Message-Id: <20220708174324.18862-3-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220708174324.18862-1-oleksandr.mazur@plvision.eu>
References: <20220708174324.18862-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0045.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::18) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 826a927b-231f-4239-22c6-08da610964f0
X-MS-TrafficTypeDiagnostic: AS8P190MB1414:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zl1egdLu/RF+jXw6jWzxglJ8Fdm40gq4WQxCNbcTF4TEH+1fZQeZuyQKgWTm1IyOaCB7uwmsICOAtJ6uB+SmX6vLgW7CDnxrsU1NmQTdEPy02pDOCXEoU77UFGj7/T2ArkV6dWt+zOjRWguFRs43uRj2PhJaXibOnT7/JE70gvH+eRWAksTF4uHJs7WH8QOuZM3DeI6skiFdZU9OOzP5nSCjCh61mKXSPlqE4HqueP93Rrl6svu+lwlwZwpGz3YYV+WT5zt5s/4l396BjevkDY/EbLx2cvUra0Pv5pX8s/TUZTvPRlmRw7GctHjzK/vF+l1PdBAZr0AI3zpb+Sjf4416A15hfH/3oFwYjr2UiWysCXZN6ELdIaotWG3893KiRJe5o5s4dtZxiT1W8b9qJaKk4ErDoxlXsx90jyraNxuaj4Jh/y9jHGOW5/1xX9srZ4Q4k9Pi4Gpg5JV7aUIigidVB7Ml2n60/YQEUqAOFlusy3TCr52A3V6q2K8PnX9qLUibnXnVm/MyhFGavpXNz8tYgojTjKOs9Go/lhr1e3Bw6HqCxi3ayesyP6+SAq4+6P5Y//mBevVyVJ4bXQQ2BdjDCudUciwhxzHTrpfww3RQYAeDxsnhWsO/PHqSo4KDwBZ1dEr6VLSU0mkQqfEVH8UqliRLHRmMTK2RphKzwSwd7ZhXPXOO7SKeAqiUCwOmZzU4B71myYb7Z9w/YgYEjapwamUlQdQ6sVYZIcLlMwCoKIj8BM5fAV3iUztbYo3HIY6zNnFKzH64gPvpBtN6zY8yHaA3/d9gUsotJAusTmZ6GSrMbUHyQ/A4A0cJjEZa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(346002)(39830400003)(376002)(136003)(4326008)(66556008)(2906002)(52116002)(478600001)(316002)(6666004)(86362001)(6916009)(36756003)(6486002)(41300700001)(6512007)(6506007)(66946007)(26005)(8676002)(66476007)(66574015)(1076003)(83380400001)(38350700002)(38100700002)(2616005)(44832011)(5660300002)(30864003)(8936002)(186003)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?orgbTu5nY/gmxGFGyFc7OPuXs+onT2hZ3fc+cSTvEqLg8SHs26na8SU7IGHc?=
 =?us-ascii?Q?0/3XWWFH89YdX6Du/7YFp+oombPBEUzoofNMrjE+qaOJ6YcdDouhcZKbMN3X?=
 =?us-ascii?Q?CGy+lNw7WuVmh6InGAD+3DOdmAsmMuPrQSZyjc91WYzm+elTzB3pE/Iy7H1H?=
 =?us-ascii?Q?DIwU7PXhI1hGchBiWBjWYMvq3l2VeWOHEzxqELtzlKuW6gEOZBLDHWY2u8pk?=
 =?us-ascii?Q?0iNR7tyZpKXVBlkC3Bl96zNvUN4Wd+eNJ5E/AVDXPn9KDw6jXHacTni1Z0rt?=
 =?us-ascii?Q?lv6WHmwi5fVFO+3YsNURmnBV6rQagrrBiQ8BNsXC1KiyB3H2Gki9ZVBxRTt4?=
 =?us-ascii?Q?uXFaCYbEipfhXGEagsah8RNIlejIbT84K0lhF6bbkfjf+Jo1AjgHla9ZB0O6?=
 =?us-ascii?Q?oo7i+f2bvKUydBXIgIw6gGAzmH+MbsijJwuIFTUoAXB/LKmfTzt/ON+8xtE4?=
 =?us-ascii?Q?iXGMdWTQcdPQDwDCdT144YPQpNDFgMbW48xHEkKn5+1XyWCGLMBPa1xUKztA?=
 =?us-ascii?Q?1IymCahpAgXQYQQuUjWs2yr4ROB0Wp/OoxJYIiTlOx7fiSaMxBRvrtC08cma?=
 =?us-ascii?Q?SmRBNg8uLImC35TKX18rbqJs1Lju2ZOKwyff9lPp9gKBG3NEwxQNt8zaUpNN?=
 =?us-ascii?Q?bh7+nFEDxD+jl0BbCRVkVlWkoKM2lRTGRE8knIlrX71b4KgGSFZIjOYg3ZCf?=
 =?us-ascii?Q?mNZStUsZK7cIVlq8to4+OqvUPXXXmPOChck0dLPgQu8oG+NKd1bV06B0sFpT?=
 =?us-ascii?Q?GtmTd/7zkFRa81NdedS+ReNLRrWca//dbUHyDBwtPvQrUAXlcNu2oBFVuMQZ?=
 =?us-ascii?Q?EYwc3JpAv2CPUbexmIwbU0wRFkvFQOb8xQToZ3RzjP7dAVGf/tsw/l2uTF6T?=
 =?us-ascii?Q?UtIKrkh454WQkd3u6tUS33CTWwhPYIWtuYuLpMIJuX6DSOABhdxrvUPqRKIp?=
 =?us-ascii?Q?Zj5MD3XZ8XOHbh1epsFISs10rZrWJW3qEybXYb8/ixllTZNLnnSqYJmw5V8U?=
 =?us-ascii?Q?NFf/EHlEnv0nCVxsQP40eG1gEEWxTt03biVSZ97cqBmX/fnI37ymsrjC3tCg?=
 =?us-ascii?Q?fro8wkBPTCUFxBVQo1YJ5vU5PrnEcFiFGp4p2lGwQp4wvRbNrqOflmQjFF02?=
 =?us-ascii?Q?gBz1l90nYRLSfMeHrpxMscc4U89qEZQCJ5u7TibyT8P80AStW7KKd3DLuWWA?=
 =?us-ascii?Q?UzsGI1vTvYV//1sSrWfC6ZKqWliivoWTdC+zjFamPgEVnl3/IhWSc9ELIEeF?=
 =?us-ascii?Q?s5cnxmlz08TXWcW3djQQe6v12CRjS9555m5jI5kC7fk2Um04G7/IqoA2Metn?=
 =?us-ascii?Q?1V+Y1eTImE4QThxxko1Ja1FIJJzUMf81Bil2Df3Oc87220GdLOVp5UE222nf?=
 =?us-ascii?Q?RGLYR0U8rp5GHRmQfSbLZM/NXA6ujj1pXeflVbTwLNVUgv/0rOnGLZz9BUq2?=
 =?us-ascii?Q?ts9BLmUfctksUVvD/S3kK2rgKOLpSzf/LVZPZx+bGzbE1CaYIOVKJAn300Nn?=
 =?us-ascii?Q?FWWVCIGkwH4JqT0UGjJhz+hlelj6l2aGG3VfkhJFP4H7zZcFKOFVW0Kk3512?=
 =?us-ascii?Q?wn73XACXh9a45s5ca9E64gRM+TvkRjyLlHhEh6j9HgEwxBljd346VyE/fZu/?=
 =?us-ascii?Q?GA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 826a927b-231f-4239-22c6-08da610964f0
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 17:43:40.3499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EZPpeq3Own8z43iHcsl5G/K7+jzUa3mqTkwPCkfN6vGS3qnGuWrDhJrEklqMfMrxnd9j/wzlu70tvHL6UMWiZdZBM5vsmCDzac6E8VbVraQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1414
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define MDB entry that can be offloaded:
  - FDB entry, that defines an multicast group to which traffic can be
    replicated to;
Define flood domain:
  - Arrangement of ports (list), that have joined multicast group, which
    would receive and replicate to multicast traffic of specified group;
Define flood domain port:
  - single flood domain list entry, that is associated with any given
    bridge port interface (could be LAG interface or physical port-member).
    Applicable to both Q and D bridges;

Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |  22 ++
 .../ethernet/marvell/prestera/prestera_hw.c   | 202 ++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  11 +
 .../ethernet/marvell/prestera/prestera_main.c |  24 +++
 4 files changed, 259 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index cab80e501419..bf7ecb18858a 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -20,6 +20,26 @@ struct prestera_fw_rev {
 	u16 sub;
 };
 
+struct prestera_flood_domain {
+	struct prestera_switch *sw;
+	struct list_head flood_domain_port_list;
+	u32 idx;
+};
+
+struct prestera_mdb_entry {
+	struct prestera_switch *sw;
+	struct prestera_flood_domain *flood_domain;
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+};
+
+struct prestera_flood_domain_port {
+	struct prestera_flood_domain *flood_domain;
+	struct net_device *dev;
+	struct list_head flood_domain_port_node;
+	u16 vid;
+};
+
 struct prestera_port_stats {
 	u64 good_octets_received;
 	u64 bad_octets_received;
@@ -342,6 +362,8 @@ bool prestera_netdev_check(const struct net_device *dev);
 int prestera_is_valid_mac_addr(struct prestera_port *port, const u8 *addr);
 
 bool prestera_port_is_lag_member(const struct prestera_port *port);
+int prestera_lag_id(struct prestera_switch *sw,
+		    struct net_device *lag_dev, u16 *lag_id);
 
 struct prestera_lag *prestera_lag_by_id(struct prestera_switch *sw, u16 id);
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index b00e69fabc6b..962d7e0c0cb5 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -60,6 +60,14 @@ enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_ROUTER_VR_CREATE = 0x630,
 	PRESTERA_CMD_TYPE_ROUTER_VR_DELETE = 0x631,
 
+	PRESTERA_CMD_TYPE_FLOOD_DOMAIN_CREATE = 0x700,
+	PRESTERA_CMD_TYPE_FLOOD_DOMAIN_DESTROY = 0x701,
+	PRESTERA_CMD_TYPE_FLOOD_DOMAIN_PORTS_SET = 0x702,
+	PRESTERA_CMD_TYPE_FLOOD_DOMAIN_PORTS_RESET = 0x703,
+
+	PRESTERA_CMD_TYPE_MDB_CREATE = 0x704,
+	PRESTERA_CMD_TYPE_MDB_DESTROY = 0x705,
+
 	PRESTERA_CMD_TYPE_RXTX_INIT = 0x800,
 
 	PRESTERA_CMD_TYPE_LAG_MEMBER_ADD = 0x900,
@@ -185,6 +193,12 @@ struct prestera_fw_event_handler {
 	void *arg;
 };
 
+enum {
+	PRESTERA_HW_FLOOD_DOMAIN_PORT_TYPE_REG_PORT = 0,
+	PRESTERA_HW_FLOOD_DOMAIN_PORT_TYPE_LAG = 1,
+	PRESTERA_HW_FLOOD_DOMAIN_PORT_TYPE_MAX = 2,
+};
+
 struct prestera_msg_cmd {
 	__le32 type;
 };
@@ -627,6 +641,57 @@ struct prestera_msg_event_fdb {
 	u8 dest_type;
 };
 
+struct prestera_msg_flood_domain_create_req {
+	struct prestera_msg_cmd cmd;
+};
+
+struct prestera_msg_flood_domain_create_resp {
+	struct prestera_msg_ret ret;
+	__le32 flood_domain_idx;
+};
+
+struct prestera_msg_flood_domain_destroy_req {
+	struct prestera_msg_cmd cmd;
+	__le32 flood_domain_idx;
+};
+
+struct prestera_msg_flood_domain_ports_set_req {
+	struct prestera_msg_cmd cmd;
+	__le32 flood_domain_idx;
+	__le32 ports_num;
+};
+
+struct prestera_msg_flood_domain_ports_reset_req {
+	struct prestera_msg_cmd cmd;
+	__le32 flood_domain_idx;
+};
+
+struct prestera_msg_flood_domain_port {
+	union {
+		struct {
+			__le32 port_num;
+			__le32 dev_num;
+		};
+		__le16 lag_id;
+	};
+	__le16 vid;
+	__le16 port_type;
+};
+
+struct prestera_msg_mdb_create_req {
+	struct prestera_msg_cmd cmd;
+	__le32 flood_domain_idx;
+	__le16 vid;
+	u8 mac[ETH_ALEN];
+};
+
+struct prestera_msg_mdb_destroy_req {
+	struct prestera_msg_cmd cmd;
+	__le32 flood_domain_idx;
+	__le16 vid;
+	u8 mac[ETH_ALEN];
+};
+
 static void prestera_hw_build_tests(void)
 {
 	/* check requests */
@@ -654,10 +719,17 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_req) != 8);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_lpm_req) != 36);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_policer_req) != 36);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_flood_domain_create_req) != 4);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_flood_domain_destroy_req) != 8);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_flood_domain_ports_set_req) != 12);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_flood_domain_ports_reset_req) != 8);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_mdb_create_req) != 16);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_mdb_destroy_req) != 16);
 
 	/*  structure that are part of req/resp fw messages */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_iface) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_ip_addr) != 20);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_flood_domain_port) != 12);
 
 	/* check responses */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_common_resp) != 8);
@@ -2194,3 +2266,133 @@ int prestera_hw_policer_sr_tcm_set(struct prestera_switch *sw,
 	return prestera_cmd(sw, PRESTERA_CMD_TYPE_POLICER_SET,
 			    &req.cmd, sizeof(req));
 }
+
+int prestera_hw_flood_domain_create(struct prestera_flood_domain *domain)
+{
+	struct prestera_msg_flood_domain_create_resp resp;
+	struct prestera_msg_flood_domain_create_req req;
+	int err;
+
+	err = prestera_cmd_ret(domain->sw,
+			       PRESTERA_CMD_TYPE_FLOOD_DOMAIN_CREATE, &req.cmd,
+			       sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	domain->idx = __le32_to_cpu(resp.flood_domain_idx);
+
+	return 0;
+}
+
+int prestera_hw_flood_domain_destroy(struct prestera_flood_domain *domain)
+{
+	struct prestera_msg_flood_domain_destroy_req req = {
+		.flood_domain_idx = __cpu_to_le32(domain->idx),
+	};
+
+	return prestera_cmd(domain->sw, PRESTERA_CMD_TYPE_FLOOD_DOMAIN_DESTROY,
+			   &req.cmd, sizeof(req));
+}
+
+int prestera_hw_flood_domain_ports_set(struct prestera_flood_domain *domain)
+{
+	struct prestera_flood_domain_port *flood_domain_port;
+	struct prestera_msg_flood_domain_ports_set_req *req;
+	struct prestera_msg_flood_domain_port *ports;
+	struct prestera_switch *sw = domain->sw;
+	struct prestera_port *port;
+	u32 ports_num = 0;
+	int buf_size;
+	void *buff;
+	u16 lag_id;
+	int err;
+
+	list_for_each_entry(flood_domain_port, &domain->flood_domain_port_list,
+			    flood_domain_port_node)
+		ports_num++;
+
+	if (!ports_num)
+		return -EINVAL;
+
+	buf_size = sizeof(*req) + sizeof(*ports) * ports_num;
+
+	buff = kmalloc(buf_size, GFP_KERNEL);
+	if (!buff)
+		return -ENOMEM;
+
+	req = buff;
+	ports = buff + sizeof(*req);
+
+	req->flood_domain_idx = __cpu_to_le32(domain->idx);
+	req->ports_num = __cpu_to_le32(ports_num);
+
+	list_for_each_entry(flood_domain_port, &domain->flood_domain_port_list,
+			    flood_domain_port_node) {
+		if (netif_is_lag_master(flood_domain_port->dev)) {
+			if (prestera_lag_id(sw, flood_domain_port->dev,
+					    &lag_id)) {
+				kfree(buff);
+				return -EINVAL;
+			}
+
+			ports->port_type =
+				__cpu_to_le16(PRESTERA_HW_FLOOD_DOMAIN_PORT_TYPE_LAG);
+			ports->lag_id = __cpu_to_le16(lag_id);
+		} else {
+			port = prestera_port_dev_lower_find(flood_domain_port->dev);
+
+			ports->port_type =
+				__cpu_to_le16(PRESTERA_HW_FDB_ENTRY_TYPE_REG_PORT);
+			ports->dev_num = __cpu_to_le32(port->dev_id);
+			ports->port_num = __cpu_to_le32(port->hw_id);
+		}
+
+		ports->vid = __cpu_to_le16(flood_domain_port->vid);
+
+		ports++;
+	}
+
+	err = prestera_cmd(sw, PRESTERA_CMD_TYPE_FLOOD_DOMAIN_PORTS_SET,
+			   &req->cmd, buf_size);
+
+	kfree(buff);
+
+	return err;
+}
+
+int prestera_hw_flood_domain_ports_reset(struct prestera_flood_domain *domain)
+{
+	struct prestera_msg_flood_domain_ports_reset_req req = {
+		.flood_domain_idx = __cpu_to_le32(domain->idx),
+	};
+
+	return prestera_cmd(domain->sw,
+			   PRESTERA_CMD_TYPE_FLOOD_DOMAIN_PORTS_RESET, &req.cmd,
+			   sizeof(req));
+}
+
+int prestera_hw_mdb_create(struct prestera_mdb_entry *mdb)
+{
+	struct prestera_msg_mdb_create_req req = {
+		.flood_domain_idx = __cpu_to_le32(mdb->flood_domain->idx),
+		.vid = __cpu_to_le16(mdb->vid),
+	};
+
+	memcpy(req.mac, mdb->addr, ETH_ALEN);
+
+	return prestera_cmd(mdb->sw, PRESTERA_CMD_TYPE_MDB_CREATE, &req.cmd,
+			    sizeof(req));
+}
+
+int prestera_hw_mdb_destroy(struct prestera_mdb_entry *mdb)
+{
+	struct prestera_msg_mdb_destroy_req req = {
+		.flood_domain_idx = __cpu_to_le32(mdb->flood_domain->idx),
+		.vid = __cpu_to_le16(mdb->vid),
+	};
+
+	memcpy(req.mac, mdb->addr, ETH_ALEN);
+
+	return prestera_cmd(mdb->sw, PRESTERA_CMD_TYPE_MDB_DESTROY, &req.cmd,
+			    sizeof(req));
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index d3fdfe244f87..56e043146dd2 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -144,6 +144,8 @@ struct prestera_acl_hw_action_info;
 struct prestera_acl_iface;
 struct prestera_counter_stats;
 struct prestera_iface;
+struct prestera_flood_domain;
+struct prestera_mdb_entry;
 
 /* Switch API */
 int prestera_hw_switch_init(struct prestera_switch *sw);
@@ -302,4 +304,13 @@ int prestera_hw_policer_release(struct prestera_switch *sw,
 int prestera_hw_policer_sr_tcm_set(struct prestera_switch *sw,
 				   u32 policer_id, u64 cir, u32 cbs);
 
+/* Flood domain / MDB API */
+int prestera_hw_flood_domain_create(struct prestera_flood_domain *domain);
+int prestera_hw_flood_domain_destroy(struct prestera_flood_domain *domain);
+int prestera_hw_flood_domain_ports_set(struct prestera_flood_domain *domain);
+int prestera_hw_flood_domain_ports_reset(struct prestera_flood_domain *domain);
+
+int prestera_hw_mdb_create(struct prestera_mdb_entry *mdb);
+int prestera_hw_mdb_destroy(struct prestera_mdb_entry *mdb);
+
 #endif /* _PRESTERA_HW_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 0e8eecbe13e1..4b95ef393b6e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -600,6 +600,30 @@ static struct prestera_lag *prestera_lag_by_dev(struct prestera_switch *sw,
 	return NULL;
 }
 
+int prestera_lag_id(struct prestera_switch *sw,
+		    struct net_device *lag_dev, u16 *lag_id)
+{
+	struct prestera_lag *lag;
+	int free_id = -1;
+	int id;
+
+	for (id = 0; id < sw->lag_max; id++) {
+		lag = prestera_lag_by_id(sw, id);
+		if (lag->member_count) {
+			if (lag->dev == lag_dev) {
+				*lag_id = id;
+				return 0;
+			}
+		} else if (free_id < 0) {
+			free_id = id;
+		}
+	}
+	if (free_id < 0)
+		return -ENOSPC;
+	*lag_id = free_id;
+	return 0;
+}
+
 static struct prestera_lag *prestera_lag_create(struct prestera_switch *sw,
 						struct net_device *lag_dev)
 {
-- 
2.17.1

