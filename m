Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D8B5700D4
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 13:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiGKLkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 07:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbiGKLjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 07:39:36 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80103.outbound.protection.outlook.com [40.107.8.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720FF12D0A;
        Mon, 11 Jul 2022 04:28:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdG1MxMcMmy1JQhBrBaf1rIMunJ0OuBkPT07oZELChGLBHbo6H0DJFD/snymoV3zpu31KHAWRxicUm4r1owdCX6pYPZsGZcPfUbmFMtPQp6+fLsuOtE38qZMy1iPdOJNF4YvNU/rOwzHXQgfOeTv0WHlmo+O4azCaIIwqR4Jz8BvZOSP1Mi1zNQRHFz8dX08OvDUl6pYjrrzACo9kGkYkhu/ikBL/88TTXPBX0FK4BNiuIFJumCX4ystDX0CmXEzw9KJAL7X0y+ezoneqjvnUF+yWRuNmzRUCnjhPwo3ElzoeyR1om36BwZRAR2M4m1JbT8p4ks18rvd9OuILUAeyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ksutx2RW4x0Lz0Iho5G2F5CgEfNeQ2Xl0szoV1ygqXA=;
 b=LTY8EQabZtw30UYmt9qbHhYsvnTRyEyo72thHqVc54xmHz8M23jkGkQri1vmjX6D47Bigr1UBJuQxbqcGGw+Sui5Fd65nQ5vqCWvCuo53Mi+/XVvyP0GwQA+ibBHIzrhCYKKiKm8Qj16tI2R5kNmmbFXaBstDvxSyBDeKH5hndu4jbrCj7YPnXJaTCE1ePMVfQVYdKm4E2xbeZplvHDfmi5a1zZVPbtovmh1g5ymL3yvF/aGtmqrB1bpA8MX16VZMl37GvxrKNvC8s2q+oG1pZ4Iq8Afo3sksy99Ts7je/8qpfPjhXC8UOl8BDiS2WxYB9KagKZz3N5sHX3VMZgiEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ksutx2RW4x0Lz0Iho5G2F5CgEfNeQ2Xl0szoV1ygqXA=;
 b=Abu56utg4OxQtBcTRqzxjKrQm5DPwboET85LBzN6ZHdr1PWgzWUOVN1mMGU87sO6sushCoHJ+C+/ge6RhOiBzurAoctYCHVlbaGxZTvGm0vUNIMtFPsnOK4PLGtYdbfOcnL4lrRJ4SmTKd9GQWfCTXg+6C9ntn+6XZ3OcG1ecM0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by AS8P190MB1208.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2ef::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Mon, 11 Jul
 2022 11:28:41 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5417.023; Mon, 11 Jul 2022
 11:28:41 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, oleksandr.mazur@plvision.eu,
        tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lkp@intel.com,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH V5 net-next 2/4] net: marvell: prestera: define MDB/flood domain entries and HW API to offload them to the HW
Date:   Mon, 11 Jul 2022 14:28:20 +0300
Message-Id: <20220711112822.13725-3-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220711112822.13725-1-oleksandr.mazur@plvision.eu>
References: <20220711112822.13725-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0080.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::15) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 933be36e-ea39-4120-4afa-08da633081f8
X-MS-TrafficTypeDiagnostic: AS8P190MB1208:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /+ry6H3KwN/mVGWMmYrQNawH0POHA/3PNNq4dDcfRP6w/f9U9aaD3MQl1LH5Cy6b7zHKL2o2FAG6i9BoFLVIFCvJYeprJBznnRc+UiyEos14RNBAjRn3s6ZKwbcB/cKhA2zjL0aLzXkoAZM/Pb/r/K+2DHvKLsObP9lXdLLNzZ1EHAj3pGXkGaj9IxJOQruth5Z0m1HRj15oZutxMWgFOnVrY+oSP5Syxgvc6lrNwuPdLfhvLWqag0afwQyCG4LXmHkz+pOEU4zf4qygy7AKY/bsCzN1MIWqzzBknrI05sCw7i8QDp9Mc+luKzYp/6efrJPNtBBi+zzrw28Cij8PNiiuLdmrK7EPUnPo3PraYBRQmwIaaIFjaCnzAyBaK6HKnndYnnEf4hwHA2hXrfXjRJjt3IgYeRNp+vO1/zzNtkni2y/m+CfQed0lgBfx2vBxfUfeJGU6A0Rg+ZO0d05vm7+dG17Jo7mDY8ELLR6ldJ8todOmwIkxFcVokyk1CZrVWg43+dKgzSKMaJdBr0a+VJZmZGfqUQ6tjjreF6Gh5egH3R3LjqWmm53uI6GijC+SX8gbDbX88+JnuP8YxOaKGKoWwvQDfwjfkyOION0RA7HpNWRva7BCezlCa/aGtyGbgMvg71aL+RRurDJ9LZiGCzNd+n7ky7t5Mv/aVQbGhFTeezvGIZBeiTOv2WBTEmm9eOrAADykdUqWJzpihey/oA/PjvPFeK/IezSE0qY63E4L42UlOe4+ninkTF9w9811AhWbeExlwXf25XG2dMAPtCp7j2G/tcfC7oPzQlbl0JCkuDntqwM4Vc0DBgXlPWLo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39840400004)(346002)(376002)(366004)(396003)(6916009)(6506007)(186003)(86362001)(107886003)(52116002)(478600001)(1076003)(6486002)(6512007)(26005)(36756003)(66476007)(8676002)(4326008)(5660300002)(8936002)(316002)(66574015)(66556008)(2906002)(66946007)(38350700002)(2616005)(6666004)(83380400001)(41300700001)(44832011)(30864003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s5BMqOcFkPmlF5TbJiwCa3b+J5BahHMc9KYZtMutHVsdYUemoCJshRc0OD6h?=
 =?us-ascii?Q?vHKr/IiG12Tt+/iDGnO+y0RoexUo/14v+4KOCPsXKz1PAXRnN07/4lmWi82N?=
 =?us-ascii?Q?pSol47F3QKmMZB4NxXofqx3MKmSSQAM7xuGSmMjoQ1ZbvjYl8JIoWKnGkg3p?=
 =?us-ascii?Q?Ggx+93RhPMSC3pCL6CuzZgO8kKsu71XssxHf4WrJu9GiRMlCcMuQAzvd3Fjf?=
 =?us-ascii?Q?CiBqEIn4g+XnVKfUWlQ2m7fvbMOl7vnoWr04RAbtycJ9p95hgSQDEfyWcirN?=
 =?us-ascii?Q?awvWU9nDb9lOl0h0I2fwpRx+pprB2nrOiYTCkJrpUo9G3cqhN4kGyij5H3fD?=
 =?us-ascii?Q?WZmoDgUwzlFcxyqC9mxv+GJzcFE9K5yNBwgNAn4Imzw0nviQdbG0FXs62eqr?=
 =?us-ascii?Q?qxo8HIsu0IvgvqQGbO+SkaumYQa1kMP6TIPgPsoJMcocGbN5CGlg4C2JxF1m?=
 =?us-ascii?Q?7rsOWSac7vBvCFyVMDvqoM+F4ILcISmlWr8ikGzoLi5GHhWnsgXwc5k2Esf3?=
 =?us-ascii?Q?8aGk0hSsHOBIS3/0DxnltktG+3KPGYdjW3LP6yA5Wu/KxckpGgTKn+rW6IKf?=
 =?us-ascii?Q?gEr9XB8lr/lq4HcJdzNCwLlOfhG17xtcmxoAQPGt6aCbmP+zbBdGmWf4tWKc?=
 =?us-ascii?Q?LdEh79YBeBPWmDsHKtYigZvlRCFJ66M9nQhpH2Hw2knLTbDVfJz/sCIo+cpf?=
 =?us-ascii?Q?XLIF9K5mehMLyHwyP/nvVVph/NIDdf27EPYaHukncuHYKMtbvr/6jpc02eyI?=
 =?us-ascii?Q?NfMPAC8GTq16fXxfkzHgy030P/8VFSsBUIHkXIVBB6ZJt3cOLGiCR5qVXe7s?=
 =?us-ascii?Q?UsWcZGvyF2UYHUbORLTpoU5zAaFg1tzvolxJsdeBxjcIHYh6tjwKz80Xd7Lq?=
 =?us-ascii?Q?Vh3Li91FSmgkyZUWVzDc+Sec4nv1T0m4TbGwnWgI1FahumbXHXh3OObCu/Fo?=
 =?us-ascii?Q?KyB47y4o2OQbGy37fLVthxcpbaUReqSz+Q/uSy2WzcQeql9UpuCg76IukI2k?=
 =?us-ascii?Q?LjHgGws9MotdLQO+xQrL6bz5LSbM5xxOL9e44N7DWBGsBp0RcaMzcBUbVmPY?=
 =?us-ascii?Q?Jm0+4LxtCCBrx1Lx8vUIWmYLHGlIcYtFnsrFESfUO1EbTobst7EbwlHMjuIE?=
 =?us-ascii?Q?F3o3gCLIsbFPfzy1xcakpKCuTAdEuCsEbGRgjWnane1JKqFeTMxE+40aUC7x?=
 =?us-ascii?Q?O87H0vIq8kzDhI0PAb/8v80HzAbtPVPbk/VsauY7T3vX4FcymtjtvD1I+1+L?=
 =?us-ascii?Q?a5jhRa6KdcK5COS8keENRfD+4iOtp89CU9OFhAFXHZjw2V6//gAg2V+52HYd?=
 =?us-ascii?Q?4YzHcz3qT/OwE8DtoUPJ/8+vG1RZQ3P1YPQVTlUizLpJEShO39ScxpLcnmar?=
 =?us-ascii?Q?+Aak0hKrHiL+rC1Lk6W8XambS9u8mgfs5claa+wVimAHwrac4pQZ2KnSMuwV?=
 =?us-ascii?Q?F6DZk9f+iL7DGW6uQJHgzGaR0Z/JLiB9Z7NBLO3hI0t1AV6Q0ey5cFp8tId1?=
 =?us-ascii?Q?uUXVavRuWpCb9bHXqo15PdtIQHhPt3C9sm5N/4AnjVLTqqKDHMIPeoNZe0TR?=
 =?us-ascii?Q?VdECOBUyVYOlEw+PAqcUREXmsLn2RDf1bqIUNBhJ8clklx7kGkS4IesVK+VE?=
 =?us-ascii?Q?tQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 933be36e-ea39-4120-4afa-08da633081f8
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 11:28:41.7709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HtbiyIukgmqF8ox5WVSKO/VQS2ikjeNMprJav0Duvy96flKYCkQ2atYo6Ys9sk7Ma01V4RafUT/8nmIj/wcHPdgny+D4pA4+No9NOVrcaSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1208
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

