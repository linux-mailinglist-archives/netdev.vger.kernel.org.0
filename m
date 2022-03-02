Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816D74C9E11
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 07:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239775AbiCBG5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 01:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbiCBG5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 01:57:07 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBD8B3E66
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 22:56:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kFG4uc3BDXpmmTm8K3ZKOggXKFGYSpvIDz5wj20IEYoley0jGv1CV3VI2ZcFo5CMxSdzP8UWFTGLecFLDjoud0e9rGfaXUEnGkIgffQtDAyrX35prPa2LVUCzwE20Zd0UzT4kM3qgZ7lL8S3d3yhh9LH8+wTHvnbn7GtlyJXfualRhJWRCYKUj+nNyL8gGxt4xUGDXtpmhr/c3qfRByxJjzTMfKeMoHkFoVG4aONIg2AJoN8xphdu3dJRq2yw6sjcNl49f8vCgNztZS4CwoAZuKBElNFiCEV9AY62mooAbxnorUWYJStHWM5k0OjqeZLAQ10v3YIJEu2oBnH90Glog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oqNcRLmq8KV3ZHlT0wHDLTk+5RNhOWksF0I/KQO2HTI=;
 b=CqCTKzXKUEsLWWXHZytXRJvX/W9ZfrWeGq1/HnZJmBq6WzHbymPaw/4EudvRaLezKITdi1KMTij0fEaXbrmGA6oGt/AiX/rcEc5Kw0WLh5yhW38AXH3GRhYsTNdH+ZloNqckPpKOKR2FCqC4I8QtkUwzSo2rmC5YLxJeZCHRM964osKmuhV3dR/tTedfzAMb99FQOwPWZ07F0mdtamN7vQvCcDzU/HnTbUuuHG59JqIeDb6QUIZ2BKXjhB1B6KX3WFYrOK7vPPnSniVfRFdB1TTPC1BjE9uJcPoeMJbXAcRST3vUMSdKmKN+R3P/yPZK8gxUD6u9qkmt1BAeOjN/iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqNcRLmq8KV3ZHlT0wHDLTk+5RNhOWksF0I/KQO2HTI=;
 b=DV35BMhJSYMT0hT/xuMz+8DCxdMg2Mxt8UQb80MsAVGWCyBC7z9mUmQ8Yaq3lhsMz7p6Lp9KsPh0CNXLXNXfYMiUCHMotq6FOHNMQAITdARvacq+MgPUEXXa6Zs76J3k+/md6Etp5pistqTRSbEZluBmXRh3Z6EE4zQe1bv0hk9CkdQmxQw0wqUvEAUyKm0liudYhskBpEHFmG3owxc29YALcBQGoZmR4pv8Ob2rF3CvNN5U66FsAol3t2p4vTxmEio2ejnek8se6VtinKkjIjBiEHQZ1P0YQbX2JtOF2lH+AQ2T6h38LgAFQsAwA1uOcxPy1Z3iJAg9c7MBGuxY9A==
Received: from BN6PR14CA0024.namprd14.prod.outlook.com (2603:10b6:404:79::34)
 by BY5PR12MB4968.namprd12.prod.outlook.com (2603:10b6:a03:1d2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 2 Mar
 2022 06:56:21 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::9f) by BN6PR14CA0024.outlook.office365.com
 (2603:10b6:404:79::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Wed, 2 Mar 2022 06:56:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Wed, 2 Mar 2022 06:56:21 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 2 Mar
 2022 06:55:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 1 Mar 2022
 22:55:34 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 1 Mar
 2022 22:55:32 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
CC:     <jasowang@redhat.com>, <mst@redhat.com>, <lulu@redhat.com>,
        <si-wei.liu@oracle.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>
Subject: [PATCH v4 3/4] vdpa: Support for configuring max VQ pairs for a device
Date:   Wed, 2 Mar 2022 08:54:43 +0200
Message-ID: <20220302065444.138615-4-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220302065444.138615-1-elic@nvidia.com>
References: <20220302065444.138615-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec2e741e-7f5e-4e62-ed73-08d9fc19c233
X-MS-TrafficTypeDiagnostic: BY5PR12MB4968:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB49683865E852E387A11D866EAB039@BY5PR12MB4968.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ODY4ZdEv0Z7eJ50pl+xLLlaRJJiggl/XiaHkXhAgJ05wmM8nucwzV8pRm5ItLp1gRy/g05k2FjvxO1UL3ImgPanqbXvhNyqkirngYH/8pVgZHCFpDJJwT7h+iDyN/1mcgQhhNLNMNKWcByIhVb2ISOmccBoKlSuBgPTW6aSLtIBTbJhYGhPAVgVAHzNqvPeFxrgvwGxI1gfz6OXBdwFzwuFlAnS2TO5zeB7xM0yWC0sAFcDYHzNtgVpOnT3SkjAlRstI6z+F4nB9XswHdHLBeuURVxGU3SbDRrYgAYaY3rtSQhKpdqwX2VRAtyD38WIXgObEGBh58Y5ec3mbXFffdsTx55ftIBsMPcJ1S2su0EoLkZyLq8SUrXoe3oeJdxg7+JZQjqFUKUJmBNoyg+PvJYgx47amJIsmr+W5AYRLLwvwH46Mxf42l7pEKuaD9WRYJxuiX4JrJiYQ1K29pwxpiaF+jy7NI7ZkRr6Wyg1kad1cYF/RpSSYA9bqyJlvPhsB0KFIY9edO/3keT11PdSMO8BrzBZhNNh669qL7H1T54HYLkqvvbIykDum12f1QsXR4oSm7MMIfrkS9BUeb5me5GmLaKUSN55Bcv/0rj1amRYkcQoakZcQl4amtO/SD22nAy4eipOHhRm3VcfRLqXRw2s9XmA1nUP4JLflyUwu6cmUTZxVfapRpkZ2/CrsHWTXiM4ZPSPJtp//yyz2kEi2dg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(6666004)(186003)(1076003)(336012)(36756003)(7696005)(26005)(426003)(508600001)(81166007)(356005)(54906003)(316002)(110136005)(82310400004)(86362001)(47076005)(5660300002)(2906002)(36860700001)(107886003)(40460700003)(8936002)(83380400001)(2616005)(8676002)(70586007)(70206006)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 06:56:21.0482
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec2e741e-7f5e-4e62-ed73-08d9fc19c233
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4968
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use VDPA_ATTR_DEV_MGMTDEV_MAX_VQS to specify max number of virtqueue
pairs to configure for a vdpa device when adding a device.

Examples:
1. Create a device with 3 virtqueue pairs:
$ vdpa dev add name vdpa-a mgmtdev auxiliary/mlx5_core.sf.1 max_vqp 3

2. Read the configuration of a vdpa device
$ vdpa dev config show vdpa-a
  vdpa-a: mac 00:00:00:00:88:88 link up link_announce false max_vq_pairs 3 \
          mtu 1500
  negotiated_features CSUM GUEST_CSUM MTU MAC HOST_TSO4 HOST_TSO6 STATUS \
                      CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM

Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 vdpa/include/uapi/linux/vdpa.h |  1 +
 vdpa/vdpa.c                    | 27 +++++++++++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
index 748c350450b2..a3ebf4d4d9b8 100644
--- a/vdpa/include/uapi/linux/vdpa.h
+++ b/vdpa/include/uapi/linux/vdpa.h
@@ -41,6 +41,7 @@ enum vdpa_attr {
 	VDPA_ATTR_DEV_NET_CFG_MTU,		/* u16 */
 
 	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
+	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,          /* u32 */
 
 	/* new attributes must be added above here */
 	VDPA_ATTR_MAX,
diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index 5f1aa91a4b96..22064c755baa 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -25,6 +25,7 @@
 #define VDPA_OPT_VDEV_HANDLE		BIT(3)
 #define VDPA_OPT_VDEV_MAC		BIT(4)
 #define VDPA_OPT_VDEV_MTU		BIT(5)
+#define VDPA_OPT_MAX_VQP		BIT(6)
 
 struct vdpa_opts {
 	uint64_t present; /* flags of present items */
@@ -34,6 +35,7 @@ struct vdpa_opts {
 	unsigned int device_id;
 	char mac[ETH_ALEN];
 	uint16_t mtu;
+	uint16_t max_vqp;
 };
 
 struct vdpa {
@@ -81,6 +83,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
 	[VDPA_ATTR_DEV_MAX_VQS] = MNL_TYPE_U32,
 	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
 	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
+	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
 };
 
 static int attr_cb(const struct nlattr *attr, void *data)
@@ -222,6 +225,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
 			     sizeof(opts->mac), opts->mac);
 	if (opts->present & VDPA_OPT_VDEV_MTU)
 		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU, opts->mtu);
+	if (opts->present & VDPA_OPT_MAX_VQP)
+		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
 }
 
 static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
@@ -290,6 +295,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
 
 			NEXT_ARG_FWD();
 			o_found |= VDPA_OPT_VDEV_MTU;
+		} else if ((matches(*argv, "max_vqp")  == 0) && (o_optional & VDPA_OPT_MAX_VQP)) {
+			NEXT_ARG_FWD();
+			err = vdpa_argv_u16(vdpa, argc, argv, &opts->max_vqp);
+			if (err)
+				return err;
+
+			NEXT_ARG_FWD();
+			o_found |= VDPA_OPT_MAX_VQP;
 		} else {
 			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
 			return -EINVAL;
@@ -501,6 +514,15 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
 		pr_out_array_end(vdpa);
 	}
 
+	if (tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]) {
+		uint16_t num_vqs;
+
+		if (!vdpa->json_output)
+			printf("\n");
+		num_vqs = mnl_attr_get_u16(tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]);
+		print_uint(PRINT_ANY, "max_supported_vqs", "  max_supported_vqs %d", num_vqs);
+	}
+
 	pr_out_handle_end(vdpa);
 }
 
@@ -560,7 +582,7 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int argc, char **argv)
 static void cmd_dev_help(void)
 {
 	fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
-	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
+	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ] [max_vqp MAX_VQ_PAIRS]\n");
 	fprintf(stderr, "       vdpa dev del DEV\n");
 	fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
 }
@@ -650,7 +672,8 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
 					  NLM_F_REQUEST | NLM_F_ACK);
 	err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
 				  VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
-				  VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU);
+				  VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU |
+				  VDPA_OPT_MAX_VQP);
 	if (err)
 		return err;
 
-- 
2.35.1

