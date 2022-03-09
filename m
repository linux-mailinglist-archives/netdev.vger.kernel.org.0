Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2C24D36F4
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbiCIQ7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237450AbiCIQ7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:59:44 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2061e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eb2::61e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1731D1AE655
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 08:46:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2giQ6w8KNFFJkdXEPYWVPvWgNuXXWJ0irMtxxsw6myYac/LEwlqB4uwBndb2IqYKpwSeD6tCznx5P209KLMwTe8/hCRIpNkJDe4RQg0Ig2JMtQHglyNO1bSCo0EzDZrSiFMwtnNes1VXuQt7x5CT6joxwJBrH+xo0SdKuj+bKL8tjnUCgSqMLpvQBN6BeVFwUb666ytWa7NKBP6EKW0aeBl2g7BNRwjulGNx1mS2Pc6pY8vmBL0kl7kSQzc4AJbzLEYvtNsMsSSzLIYuhiBCocCZHgvoi81ypzy07q/+tSTXsLA75txzcfXgx8heCac2His6BYDdn4v5uHylALERQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AEX3g++mu7xh2dD8MqNl3I7Lg2dW5QLXO8AxiX6qhD0=;
 b=eMbTq1i6annfqvraa8Cx/c+h1Kw/CTX3MSWK2Ob8ofwgUVJVHJmlinv6KkDnce0szxLRh2/ZhAMfZbOPHRWXnUBKxPWByfXEYlYuSNNT7UAFqtJTPU5Lldh+ejp2UBGYxjfHP8YdvBzPD+870A/fV7WKSAKROQj5bYxx60VlFiRYSa8Se0CpkvVBMvi18inF5u3AGTR3I3k0z3VsnQdOf6Xv/kU29ialG48NuUVeLns23U72EKcwDz9Jz4UuvquXwVsWPeAXuFntGcSOaYRAOE70tVa/TnWQsv2XntPv2FOqvZcG7MWi8Qt32XiFgSRw6nI10fpFqbEQn6zlVhkTYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AEX3g++mu7xh2dD8MqNl3I7Lg2dW5QLXO8AxiX6qhD0=;
 b=B4TMMCYzBXCFkAgxHargcvsmU8gcz5462seJpYacj1lt416wwP3NpzFROp6xbrqTpGfWj5lF5uXpvQcDolQaSgra9C6Lj0pGsVbCNhfXktc1O/7kZEwxia5QCSrzvNsig5+ZyBFvYj78vmbsA7Tc2G/IJ6zgJVEK31hmbdBl/uUAy92F0JhYc5gk6HON93DjHcoBAY7fQ4wzURyAlEPQa3TcWmq5+1a3vtbYxfJQ0KfhlAxZu0RWXqsvmFeaduRrtPrMf1Q+bMfiqIDg0l7qkh28gewskdMjVji0xXuypHIKfwxujQSiFjDhbj7Js97/bW/ojCmpcXZfgL41pubnFw==
Received: from BN0PR10CA0004.namprd10.prod.outlook.com (2603:10b6:408:143::18)
 by BY5PR12MB4227.namprd12.prod.outlook.com (2603:10b6:a03:206::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Wed, 9 Mar
 2022 16:46:29 +0000
Received: from BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:143:cafe::75) by BN0PR10CA0004.outlook.office365.com
 (2603:10b6:408:143::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Wed, 9 Mar 2022 16:46:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT008.mail.protection.outlook.com (10.13.177.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Wed, 9 Mar 2022 16:46:28 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 9 Mar
 2022 16:46:27 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 9 Mar 2022
 08:46:25 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Wed, 9 Mar
 2022 08:46:23 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>
Subject: [PATCH v5 3/4] vdpa: Support for configuring max VQ pairs for a device
Date:   Wed, 9 Mar 2022 18:46:08 +0200
Message-ID: <20220309164609.7233-4-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309164609.7233-1-elic@nvidia.com>
References: <20220309164609.7233-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cd9184c-4d94-40a4-a4d0-08da01ec5bca
X-MS-TrafficTypeDiagnostic: BY5PR12MB4227:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB422754723B94780366834DDEAB0A9@BY5PR12MB4227.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YUXcE63y54l9wVmZOGsVrEl+u4FJquiYIpTlCpZVJkLamffedLrzNExi0CsyhQIU+6R+bnX/FYCwvB9IC6uowR/RELtg9R3pOGXiAbPgAFYgniATECvf1bjjDw+TzK6CHrFWFxZHRL0ioE9I/b6Pt2M/ydv0tgAsWnFjPvb8LPyd/WCi8qFt6hJvbW48m523O4xmcNLTegrjjywGfFCleczFd+MGc1LRn+cgFgK7MTF6LITEfF6U6yp6YjxIbQ/tkW+4MoczYB2754KvH2bf5P8xdRyvn8s14ZS51JKiIRGCqdQx5Nzv4mZrtRAuwoYwOjU+/sLAKh8F/eZgQ5n+UnrREk0LtwT5QfrlGpvZj69Im2EINa/UThPQMcAwqi0Q3Y/X5dvGTNjUn4MPSr8gf+eEhibpyoIBTxQFfBDyUsEiQtmd3RlDJBAP83b5SaWj7kBELTjEpAZ+/yLO0LvhKZ831yCk1ZU/GFeVfSSyzsoT9aeN78FYHBiF+zwQ/lv7LJRB0lTBYWcZiO3K085Bo0pfpwkVxG8h3zsXQZYVRmPK9bhDw3Aoh/vWuF2MhihGc4L0dS6VkHSNPM7H+3OQeb/xXliF27bDolbey66xzBxQpjMJn3SJW0o8+fQiXl9zaJtITHlhieZFodDKeT8klh0DbQVOc7mQIGjPwl+rYCONf9DkPKa1OclovuTQJsrwvWYda6Yvm0RhA9S4DI+1iQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(6666004)(7696005)(40460700003)(8676002)(2906002)(186003)(70206006)(86362001)(4326008)(110136005)(81166007)(36756003)(316002)(356005)(36860700001)(2616005)(1076003)(426003)(26005)(107886003)(5660300002)(82310400004)(336012)(8936002)(83380400001)(70586007)(54906003)(47076005)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 16:46:28.8544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cd9184c-4d94-40a4-a4d0-08da01ec5bca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4227
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
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

Signed-off-by: Eli Cohen <elic@nvidia.com>
---
v4 -> v5:
1. Use u32 arithmetic in pr_out_mgmtdev_show() to be consistend with
   attribute width.

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
index 5f1aa91a4b96..8b34e29394b2 100644
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
+		uint32_t num_vqs;
+
+		if (!vdpa->json_output)
+			printf("\n");
+		num_vqs = mnl_attr_get_u32(tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]);
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

