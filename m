Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB8E64BA02D
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 13:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240468AbiBQMa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 07:30:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240485AbiBQMax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 07:30:53 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2044.outbound.protection.outlook.com [40.107.236.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3582AE29E
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 04:30:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHoAoLxvJ8Rf2SP4u4Q2cZkZmE+tPi99y3tEpq7Xn5+SH1R/BkCWX8aDOADkckylsmAIpt6lX/0E6QaUMpRM5Lnwscu2HFQEKD+iPDKGFNNtJ6C6De3kqQBLVJBL1ghe5okjwkxfxSR1sVC5puiHHjPmaFrY42iFO2glHD4ImFA+5lH/I9zjXgQa0dg1JJU0Jn80ChUd/EYkQMfZAGdYlv4ZumVrZLknNHDHOYC5cBfSKMytvUECaChLa5i8+I0A6WKEmF3fIA24okvaWs41QGjjWsNxJFftYodZ9ijrz8u7z10qNgKZg5tC0JathbUTYwVqvE3w4/SQfKcxzXxS+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uZED+5AbRTZYloNKXrZy1erv8I3NY4hiT+u1mey0Dns=;
 b=e7uSL+vqq0vSj8pUc/u/GvVeAzpUQCgVL0ckqoSbInT92GVDXFC9b9G0HdsiqZLr4UFRo8O2JEMPB8Hn5LFmM2DqQ156GJ73mWkOYiqn9csbdfPU3q7o/Pl8XgQD146f64iHGOuxzJPtIyLdvVEGewH7jLGXT25g8+ZLfd8yO8MtpdPTTq5lnRqjF6v/Jdwzdb0CGCHhBEEBaB3byzZexrVZASs10a6cA72SVWFXm1N065GE36ZDsbMM6a7PpoJ0xtINkCqAt456g3LtmaJTfdauEdNl74CpGdE1q5J0jTcL9QHExabZOjn2YsDFCNG6TC4Xf5ufypyX9tn6nie4UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZED+5AbRTZYloNKXrZy1erv8I3NY4hiT+u1mey0Dns=;
 b=VgLAXNNR8CHSeuWZOTp0/MOU2ak3qgsP5CM1y30kDkfxHRyQU2rbn8caX3145vjWH2T+pLIM1MWO45vkHfltvGPFAe50bwLWQ3QWdj7uWw1vZP0Wrn/ezjFMvqCPyv+QxammW796ojEwE/bC3r8W/SMSgyXg+hiCN37J3/3mjfE+xjLe7epqBUNpPSD3Fzw6Obys7OdrwhR6ZohwQcVBiL7WIdbR+gcH6LXmRghekeXDlBI/U1Fzgd9YObFiTR94WzMpnD25pPlVa4Q51awcm1ywf2cJ3Apc+G7oJm9yehd471znnZA9F0DoPdrSEpfi9PBvBOMakHM6g+XSIej7vA==
Received: from MW2PR16CA0055.namprd16.prod.outlook.com (2603:10b6:907:1::32)
 by DM6PR12MB3739.namprd12.prod.outlook.com (2603:10b6:5:1c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Thu, 17 Feb
 2022 12:30:37 +0000
Received: from CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::8d) by MW2PR16CA0055.outlook.office365.com
 (2603:10b6:907:1::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.19 via Frontend
 Transport; Thu, 17 Feb 2022 12:30:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT068.mail.protection.outlook.com (10.13.175.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Thu, 17 Feb 2022 12:30:37 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Feb
 2022 12:30:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 17 Feb 2022
 04:30:36 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 17 Feb
 2022 04:30:34 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>
CC:     <jasowang@redhat.com>, <lulu@redhat.com>, <si-wei.liu@oracle.com>,
        "Eli Cohen" <elic@nvidia.com>
Subject: [PATCH v2 3/4] vdpa: Support for configuring max VQ pairs for a device
Date:   Thu, 17 Feb 2022 14:30:23 +0200
Message-ID: <20220217123024.33201-4-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220217123024.33201-1-elic@nvidia.com>
References: <20220217123024.33201-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e951f94-cbcb-4acc-e51a-08d9f2114d58
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB37399F6BA1E99FEBD2DAEF1DAB369@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H3gAWNUdGQp/MTxBfCxgwbPdmsJZIbO2G6EOZ8XEkZ+2Q8WrfU+if1KFB6HianMEeMl4s459UGlVvNS/6qtaIs99iAta6TetTz5lzXqAAarxjOGVbFHJtJRe0gaOIO3JfvFoThkyFcztpF7KPTUkI8gywlP3Q0UVT68hDLCNJITmTg9FHqkd/Xd+SMuKInA3rVaXFVEXgK2DmeIbLbFjTiDB0rU6UoM2AvKiKPawSdf9oW9VUfnpgXzNDGujNQ4difH7xTughWOiTI2vuUFFoZTeCbtY6ERHxzLCqdNWoace0pDwGns5lF5HeueCIQNLz+RQKnaE8MMmQHGCrplUtYE057Fh6nFvVm0e+SDbq5MEKIP88kaPbYTAs4Ni0CS+OEy4Dr+OMTI1tgF+VJy93gpoVYG92ujY3z1qDOa/uB9Wf+P+OXswUHWCk4qraeKlzO4KZDtV2fwmru0YoHH1yTplHcg8XWV1Mnl3/bGo7NWZlYrTlUy2FBMS996C7NFyyKzElDQS44DxLHk6CGpeRh8/fsxCIR1YNCLLqPO2RfAZIXd5l+4GrCFPcwRCoG4eoigJJTwpoykWjmftvBV1sd1E4hykri1gJVH2RQrGssBDWzdtqF41vK5AGPBguoGRit4YqvucXI7vK3I8D7d2pvOwAIs1as+qss3wuONF56FK83eu6VFTcOljCOOdK+KD9TG8llWlliyCm9SMmLHy0w==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(54906003)(36860700001)(2906002)(110136005)(2616005)(36756003)(7696005)(86362001)(8936002)(186003)(70206006)(6666004)(356005)(26005)(426003)(107886003)(70586007)(83380400001)(336012)(47076005)(40460700003)(1076003)(4326008)(508600001)(8676002)(81166007)(316002)(82310400004)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 12:30:37.4579
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e951f94-cbcb-4acc-e51a-08d9f2114d58
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index f60e647b8cf8..78736b1422b6 100644
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
@@ -500,6 +513,15 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
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
 
@@ -559,7 +581,7 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int argc, char **argv)
 static void cmd_dev_help(void)
 {
 	fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
-	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
+	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ] [max_vqp MAX_VQ_PAIRS]\n");
 	fprintf(stderr, "       vdpa dev del DEV\n");
 	fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
 }
@@ -649,7 +671,8 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
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

