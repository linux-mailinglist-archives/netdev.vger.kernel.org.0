Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631E64B0EC9
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238672AbiBJNbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 08:31:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242243AbiBJNbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:31:36 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2070.outbound.protection.outlook.com [40.107.236.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B510BD9
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 05:31:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lXJj8d7xu22dhVCkpryQSr4e6D/iKAsnLZFc1q1szoecoPpRNBohg+lP/8lzlPF5ckdoO2PdzpfVnIAv5xWwKqZrjUbubaXmhUGcxalZrIxVKiA1E8dSgKqnlH/1SXJFk0L/HfVMxKdjnp9y+fvkrIYfgbqHGxOpeWFsjZmSOw+YUDVRWI01qLXUjJ87Dr/V4BEs0GVEjZKZ2tNReFOvo/OzIzTS4Q8MSREXQhubHT7bkshArLUDPfiApFmDE3recTdxRsXU9SCfSdVLnafPfXtp1cKQF7p7jLUh+W/AGYmiPRCrQpmQvU9M+ST/eqX0CXn2CO6eREclPTGMTOUNWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VSfMbxPbxhzj5rycIW/cFFylDGzKH40EPGQQbDR/rBA=;
 b=cp7KMok+FSCTZThp5tWFa2Fts5iKyGVpgx25Ry5p+vtEX8oe8tzHbhJ1uq/CCldtQrooPINBNPxkDwS9+h3myARia9UfAUWqwMbovJ4WuPeDzTa+ExeA+G5ZXUL8KR1/rB1PtIVRcfArLjn4FbIZF3ljGY6c+Xjy3nnQiggdz3ZMdIBDUBS4FsQgsItRJh/TxLHm6kXucf2AXLRPcDV1IAfnjqAyAUhRNMbB4mjUGIpDIC7LQ5zSQhAUFdW9ZIv7qnWrRpDPb/LycG6cTBDe11Ph/HY4Hqy3I1L7OaKqTVdEIhFMY9VViCdilfjFpSSS1ZMuCttkrH+Le82OaoOC5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSfMbxPbxhzj5rycIW/cFFylDGzKH40EPGQQbDR/rBA=;
 b=pt6xlKfSa4BTqQSxIh7FXcHJtPCHWFlg0dB9BUEeVGCDjULr9A0oafK7RZCF7cqdDhflKBmktOENJYVfFdLRuEVOmyFICvpi5FEoumkD2ICH1PPk4n5blMcFsjcPp0TAchaYmTSNcog9cGC177Nf4oU7qd6bx5BDiG2Ixw7KN5TgoCqVZrSRBuTmNlcB8EviAqiqsAg5587OHQXLuL1mUrKiY7MYfplzsFKgQFiVcef8aj8xYJ0mAPda9j2qZ5+h6+HCttXsCsFDDaJBQmdnMe4sJvVH4tW817R3/zdJesj74/LRbbizYjhplBdHuUDTj15YYEDcXl56hKXv1PLpMg==
Received: from DM3PR14CA0129.namprd14.prod.outlook.com (2603:10b6:0:53::13) by
 MN2PR12MB3246.namprd12.prod.outlook.com (2603:10b6:208:af::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.18; Thu, 10 Feb 2022 13:31:34 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:53:cafe::8e) by DM3PR14CA0129.outlook.office365.com
 (2603:10b6:0:53::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Thu, 10 Feb 2022 13:31:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 13:31:34 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 13:31:28 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 10 Feb 2022
 05:31:28 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 10 Feb
 2022 05:31:26 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>
CC:     <jasowang@redhat.com>, <lulu@redhat.com>, <si-wei.liu@oracle.com>,
        "Eli Cohen" <elic@nvidia.com>
Subject: [PATCH v1 3/4] vdpa: Support for configuring max VQ pairs for a device
Date:   Thu, 10 Feb 2022 15:31:14 +0200
Message-ID: <20220210133115.115967-4-elic@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210133115.115967-1-elic@nvidia.com>
References: <20220210133115.115967-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34d185e3-4895-4337-3c38-08d9ec99a82b
X-MS-TrafficTypeDiagnostic: MN2PR12MB3246:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3246C1937DE748CAF3D0FB37AB2F9@MN2PR12MB3246.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CMhYhkrZetnelL91KF06varWbivfpMHOc1XOUUFIhcKCt/2Z58v176fXIhXPNTxScyPe6JwC6hHEI4yXji58Zct4KEMFfUHkqBARQj/sZvoi9D7TsogGOjBrvaUWnVK0wKSZuwuXI76ULvdyraZdfmAIp2XxHnBGCc5FN+7pkfPLeGoFW/kepy5qyB3bCyCMF0pzGIWI+GfC2gJ/HVUEu1UwBlbt+OQlg8rAVby9FNww/mmcX4EB7tuqtCCpQ37SuztcLIvHPxMyzt9fpidQk/7r364D+Oh7AhV2d4nDoLyaXlncBhX2o8LgGP/HaidZ3vnXUVx9QkHH3rE37rRdeAOIXhEHlP4j5nhHNwcsEp78dhD0y5pJru/0b6skXeqmh/Z6A4bTr8fdgPq0sU/ebtAwqCs8VY+ENEFiYis8GfL4OQjpCwpoIKEMP4fyWiwEwUsRoNhSyZTTlZ/fc9ZsWqP+TtXFQWbgBrqnYhlpdEGbheJtnddea0gk7E9R0wLNtOK9tN7q6lCE5RtPuqDTnGwGLLmftO2+zRjJLK7lqFNlEEAa68S2uXx9X4OJwMC890Jxx+byYsrvtbWQxryfWo29qOkUrg+cXK9JVW22JcFBptjHr55Z7DKfSnE5Be2k2VUzR0He7J7yfE7SnENZweKN0of2oAWPQVt7eFVlwtnwRTSPnERLgid8CbWRZX84yOYjh3Mb8b8jjAhDcBPSFQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(110136005)(508600001)(6666004)(54906003)(86362001)(316002)(356005)(81166007)(7696005)(4326008)(36860700001)(8676002)(107886003)(336012)(2616005)(1076003)(186003)(426003)(82310400004)(70206006)(40460700003)(36756003)(8936002)(83380400001)(2906002)(5660300002)(70586007)(47076005)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 13:31:34.3786
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34d185e3-4895-4337-3c38-08d9ec99a82b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3246
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 vdpa/include/uapi/linux/vdpa.h |  1 +
 vdpa/vdpa.c                    | 25 ++++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

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
index 7deab710913d..99ee828630cc 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -24,6 +24,7 @@
 #define VDPA_OPT_VDEV_HANDLE		BIT(3)
 #define VDPA_OPT_VDEV_MAC		BIT(4)
 #define VDPA_OPT_VDEV_MTU		BIT(5)
+#define VDPA_OPT_MAX_VQP		BIT(6)
 
 struct vdpa_opts {
 	uint64_t present; /* flags of present items */
@@ -33,6 +34,7 @@ struct vdpa_opts {
 	unsigned int device_id;
 	char mac[ETH_ALEN];
 	uint16_t mtu;
+	uint16_t max_vqp;
 };
 
 struct vdpa {
@@ -80,6 +82,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
 	[VDPA_ATTR_DEV_MAX_VQS] = MNL_TYPE_U32,
 	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
 	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
+	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
 };
 
 static int attr_cb(const struct nlattr *attr, void *data)
@@ -221,6 +224,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
 			     sizeof(opts->mac), opts->mac);
 	if (opts->present & VDPA_OPT_VDEV_MTU)
 		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU, opts->mtu);
+	if (opts->present & VDPA_OPT_MAX_VQP)
+		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
 }
 
 static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
@@ -289,6 +294,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
 
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
@@ -513,6 +526,15 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
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
 
@@ -662,7 +684,8 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
 					  NLM_F_REQUEST | NLM_F_ACK);
 	err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
 				  VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
-				  VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU);
+				  VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU |
+				  VDPA_OPT_MAX_VQP);
 	if (err)
 		return err;
 
-- 
2.34.1

