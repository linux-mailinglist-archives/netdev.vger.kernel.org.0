Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33CC453A493
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 14:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244683AbiFAMKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 08:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiFAMKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 08:10:37 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2051.outbound.protection.outlook.com [40.107.236.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232BE56764
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 05:10:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bgv097D5jEVtnwCSlgPdMcLID9jzTACxQysMxKeyRP4yRDHKCQPQi6T0TAMiCCwUDUv8qtYX5HQcDrea49m64DLMNz2h1uEjEaIcUWdDqcBCbTt+M7j2opxNkG49qDCe/AFcy+nJMGgIQfvcx6FA+eASfgO0ljYhowgzWbOVbRTIuxsqvGXKWAld0TXBD8pBPw2nzmGYkk/Xrc5oDrQGpG9ONtIrqzXLzhntMaADIcxupTN18DaF/ChVkAtNpeQBcPtyLp9nMu94f4Q93IARona6tQfHeGBXeDSX5QRj/P0SXgtdkDFEmxJfXEdP2U8h/prv626mhzi3Bo+/XFcSWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9c2SoiuTWzkUK6KjWTov4AK33KZTgwNwlcIR/PfOB6I=;
 b=HZ47oJDQ0jaGgGLVTregxU0U2qdCAu5bluef8Co7nnfhdLTGK/t537CeBD3KFeqeBO7OiDxa/Xujw0H2/13/xaMB8GxfY/2qpIjYZKSBmtfJ0iG4itFQBScPP4asdQV8xbvOMLohq/plu9gWNZ5BdxsszSHA7ezsJet+NEqfpRu2yt2al4GqTduYy3uFiS6LLjjdv7N1c+yHBr1Hqgtm41gHVAmX5+BpSgsrkjCaoGeT9dRlYpzrKNvyBybYIBN877Mg2STRb0NgKHMW2eNmA78OOX8M1xoW+EG5Fe0YJXsJ1ZYbKTyJrFMUZ496X5t7TqJqkQ8dNfEa/xpPr4wR2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9c2SoiuTWzkUK6KjWTov4AK33KZTgwNwlcIR/PfOB6I=;
 b=Qc9VRidCbWUsKdJgXBiVw97K6jlOSi2eb5sjtLo0+8FsRw7MWgI42ds5EAqIk5bBCup1aNjUwtKDd4HZ3LFGHkHRLgu9LBpQBfdF23t0xANM7brzJmN9ZPwtwxgJiPc1GICPsc3p7MrDJwscvCJc5SyaiyTYOnmCJT7+heVfHg+rZzh4Zqf5kXsKyda/ySk9I5BdY90LAtgJ1QNvHub0PjAUm8wk38URuw6/xezT6J7EXwMqW4xQwhVxt3281b9UH8Km4HKTSlujfvvb8AOgAk5aVewfZHmH60Kqn86/TxSHxdlUy1Ad6I4DcJiskqxIkKEWMKg+I5dwxXMfnxQKcA==
Received: from BN9PR03CA0511.namprd03.prod.outlook.com (2603:10b6:408:131::6)
 by BYAPR12MB2904.namprd12.prod.outlook.com (2603:10b6:a03:137::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 1 Jun
 2022 12:10:33 +0000
Received: from BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:131:cafe::87) by BN9PR03CA0511.outlook.office365.com
 (2603:10b6:408:131::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13 via Frontend
 Transport; Wed, 1 Jun 2022 12:10:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT062.mail.protection.outlook.com (10.13.177.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5314.12 via Frontend Transport; Wed, 1 Jun 2022 12:10:33 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 1 Jun 2022 12:10:32 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 1 Jun 2022 05:10:30 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Wed, 1 Jun 2022 05:10:29 -0700
From:   Eli Cohen <elic@nvidia.com>
To:     <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>, <mst@redhat.com>
CC:     Eli Cohen <elic@nvidia.com>
Subject: [PATCH] vdpa: Add support for reading vdpa device statistics
Date:   Wed, 1 Jun 2022 15:10:21 +0300
Message-ID: <20220601121021.487664-1-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8018f64-5b78-4510-95bd-08da43c7ba80
X-MS-TrafficTypeDiagnostic: BYAPR12MB2904:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB29040ABC81E05F53E6138208ABDF9@BYAPR12MB2904.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uOBnOT72Htg4I3rtJD1QMqaRoQcCsWYNr4jAdG2dT3JzZhiXnjJgXu5bjLPxjLfEV+aDaClX3gT5Z4+1YYqD3Bekk1dzg8cg9bHDSadbGHJBaCAiUAoy1lc/H76KRG09bz+oWZxRrbMCOZ38HJoUVoe67zL5tugkjnlMMIdOc1HcT2pnsZVzppk2AR1Vc9TYfKTUk89n/XIo3ADXIB3OY3Xh6F5pjyAY5S6prpk+s3mDrJMx8DN86rHcbT0dOyGsp1XWnu9gGW0jpDbMhwcHfT/wkyhf/cbh+OuoIt+DGcu+y0dlIw6nteDrreXwpFeXF8yM3Bj/BK7g6Pj8Ky7MTr/MsvL3jKdTDf9wdM9ynsCJQQohL4J6TTcrK4j7NEkGvj1KiR+3QvaWaAHDXmpVk6pQQVRU4MvbUPZ20WYqD8/Y4DE8KcgF5Cp78b+dr7dYyXXnvHDRtQNJNORd4fUyqCTD1Phgbegi5wC+2CqvjRMaSq8bLH7trahKqq/vQauBP3i6VMU1WwK2Mj4AZiWOfPrJEed/c1ZV0Z6C19AU02hJNjCQcTF5yj9yTQFAh/oRL3LWt/rNFkd3K7VK9E+9YwUAZHy2Fxn44B9Lu0G/sedbPCP1Ai8J7FaL2Cp21Rrlc6ZXXBsvSME99YOxbPP0S6NmS9R5JL9ysN+rZv4LOX8g9KPpBONwQmWHkll6k/Y+hOz+A06zIX432i4j57Etdg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(2906002)(36860700001)(40460700003)(508600001)(83380400001)(81166007)(82310400005)(26005)(356005)(47076005)(86362001)(6666004)(110136005)(316002)(36756003)(70206006)(70586007)(2616005)(5660300002)(107886003)(7696005)(1076003)(8936002)(336012)(186003)(426003)(4326008)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 12:10:33.1169
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8018f64-5b78-4510-95bd-08da43c7ba80
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2904
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Read statistics of a vdpa device. The specific data is a received as a
pair of attribute name and attribute value.

Examples:
1. Read statistics for the virtqueue at index 1

$ vdpa dev vstats show vdpa-a qidx 1
vdpa-a:
vdpa-a: queue_type tx received_desc 321812 completed_desc 321812

2. Read statistics for the virtqueue at index 16
$ vdpa dev vstats show vdpa-a qidx 16
vdpa-a: queue_type control_vq received_desc 17 completed_desc 17

3. Read statisitics for the virtqueue at index 0 with json output
$ vdpa -j dev vstats show vdpa-a qidx 0
{"vstats":{"vdpa-a":{"queue_type":"rx","received_desc":114855,"completed_desc":114617}}}

4. Read statistics for the virtqueue at index 0 with preety json
   output
$ vdpa -jp dev vstats show vdpa-a qidx 0
vdpa -jp dev vstats show vdpa-a qidx 0
{
    "vstats": {
        "vdpa-a": {
            "queue_type": "rx",
            "received_desc": 114855,
            "completed_desc": 114617
        }
    }
}

Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 vdpa/include/uapi/linux/vdpa.h |   6 ++
 vdpa/vdpa.c                    | 156 +++++++++++++++++++++++++++++++++
 2 files changed, 162 insertions(+)

diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
index cc575a825a7c..7f52e703f1ad 100644
--- a/vdpa/include/uapi/linux/vdpa.h
+++ b/vdpa/include/uapi/linux/vdpa.h
@@ -18,6 +18,7 @@ enum vdpa_command {
 	VDPA_CMD_DEV_DEL,
 	VDPA_CMD_DEV_GET,		/* can dump */
 	VDPA_CMD_DEV_CONFIG_GET,	/* can dump */
+	VDPA_CMD_DEV_STATS_GET,
 };
 
 enum vdpa_attr {
@@ -46,6 +47,11 @@ enum vdpa_attr {
 	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
 	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,		/* u32 */
 	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
+
+	VDPA_ATTR_DEV_QUEUE_INDEX,		/* u32 */
+	VDPA_ATTR_DEV_VENDOR_ATTR_NAME,		/* string */
+	VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,	/* u64 */
+
 	/* new attributes must be added above here */
 	VDPA_ATTR_MAX,
 };
diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index 3ae1b78f4cac..3ca3095ed783 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -26,6 +26,7 @@
 #define VDPA_OPT_VDEV_MAC		BIT(4)
 #define VDPA_OPT_VDEV_MTU		BIT(5)
 #define VDPA_OPT_MAX_VQP		BIT(6)
+#define VDPA_OPT_QUEUE_INDEX		BIT(7)
 
 struct vdpa_opts {
 	uint64_t present; /* flags of present items */
@@ -36,6 +37,7 @@ struct vdpa_opts {
 	char mac[ETH_ALEN];
 	uint16_t mtu;
 	uint16_t max_vqp;
+	uint32_t queue_idx;
 };
 
 struct vdpa {
@@ -174,6 +176,17 @@ static int vdpa_argv_u16(struct vdpa *vdpa, int argc, char **argv,
 	return get_u16(result, *argv, 10);
 }
 
+static int vdpa_argv_u32(struct vdpa *vdpa, int argc, char **argv,
+			 uint32_t *result)
+{
+	if (argc <= 0 || !*argv) {
+		fprintf(stderr, "number expected\n");
+		return -EINVAL;
+	}
+
+	return get_u32(result, *argv, 10);
+}
+
 struct vdpa_args_metadata {
 	uint64_t o_flag;
 	const char *err_msg;
@@ -183,6 +196,7 @@ static const struct vdpa_args_metadata vdpa_args_required[] = {
 	{VDPA_OPT_VDEV_MGMTDEV_HANDLE, "management device handle not set."},
 	{VDPA_OPT_VDEV_NAME, "device name is not set."},
 	{VDPA_OPT_VDEV_HANDLE, "device name is not set."},
+	{VDPA_OPT_QUEUE_INDEX, "queue index is not set."},
 };
 
 static int vdpa_args_finding_required_validate(uint64_t o_required,
@@ -228,6 +242,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
 		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU, opts->mtu);
 	if (opts->present & VDPA_OPT_MAX_VQP)
 		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
+	if (opts->present & VDPA_OPT_QUEUE_INDEX)
+		mnl_attr_put_u32(nlh, VDPA_ATTR_DEV_QUEUE_INDEX, opts->queue_idx);
 }
 
 static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
@@ -304,6 +320,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
 
 			NEXT_ARG_FWD();
 			o_found |= VDPA_OPT_MAX_VQP;
+		} else if ((matches(*argv, "qidx")  == 0) && (o_optional & VDPA_OPT_QUEUE_INDEX)) {
+			NEXT_ARG_FWD();
+			err = vdpa_argv_u32(vdpa, argc, argv, &opts->queue_idx);
+			if (err)
+				return err;
+
+			NEXT_ARG_FWD();
+			o_found |= VDPA_OPT_QUEUE_INDEX;
 		} else {
 			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
 			return -EINVAL;
@@ -594,6 +618,7 @@ static void cmd_dev_help(void)
 	fprintf(stderr, "                                                    [ max_vqp MAX_VQ_PAIRS ]\n");
 	fprintf(stderr, "       vdpa dev del DEV\n");
 	fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
+	fprintf(stderr, "Usage: vdpa dev vstats COMMAND\n");
 }
 
 static const char *device_type_name(uint32_t type)
@@ -819,6 +844,135 @@ static int cmd_dev_config(struct vdpa *vdpa, int argc, char **argv)
 	return -ENOENT;
 }
 
+#define MAX_KEY_LEN 200
+/* 5 bytes for format */
+#define MAX_FMT_LEN (MAX_KEY_LEN + 5 + 1)
+
+static void pr_out_dev_net_vstats(const struct nlmsghdr *nlh)
+{
+	const char *name = NULL;
+	uint64_t features = 0;
+	char fmt[MAX_FMT_LEN];
+	uint16_t max_vqp = 0;
+	bool is_ctrl = false;
+	struct nlattr *attr;
+	uint16_t qidx = 0;
+	uint64_t v64;
+
+	mnl_attr_for_each(attr, nlh, sizeof(struct genlmsghdr)) {
+		switch (attr->nla_type) {
+		case VDPA_ATTR_DEV_NET_CFG_MAX_VQP:
+			max_vqp = mnl_attr_get_u16(attr);
+			break;
+		case VDPA_ATTR_DEV_NEGOTIATED_FEATURES:
+			features = mnl_attr_get_u64(attr);
+			break;
+		case VDPA_ATTR_DEV_QUEUE_INDEX:
+			qidx = mnl_attr_get_u16(attr);
+			is_ctrl = features & BIT(VIRTIO_NET_F_CTRL_VQ) && qidx == 2 * max_vqp;
+			if (!is_ctrl) {
+				if (qidx & 1)
+					print_string(PRINT_ANY, "queue_type", "queue_type %s ",
+						     "tx");
+				else
+					print_string(PRINT_ANY, "queue_type", "queue_type %s ",
+						     "rx");
+			} else {
+				print_string(PRINT_ANY, "queue_type", "queue_type %s ",
+					     "control_vq");
+			}
+			break;
+		case VDPA_ATTR_DEV_VENDOR_ATTR_NAME:
+			name = mnl_attr_get_str(attr);
+			if (strlen(name) > MAX_KEY_LEN)
+				return;
+
+			strcpy(fmt, name);
+			strcat(fmt, " %lu ");
+			break;
+		case VDPA_ATTR_DEV_VENDOR_ATTR_VALUE:
+			v64 = mnl_attr_get_u64(attr);
+			print_u64(PRINT_ANY, name, fmt, v64);
+			break;
+		}
+	}
+}
+
+static void pr_out_dev_vstats(struct vdpa *vdpa, struct nlattr **tb, const struct nlmsghdr *nlh)
+{
+	uint32_t device_id = mnl_attr_get_u32(tb[VDPA_ATTR_DEV_ID]);
+
+	pr_out_vdev_handle_start(vdpa, tb);
+	switch (device_id) {
+	case VIRTIO_ID_NET:
+		pr_out_dev_net_vstats(nlh);
+		break;
+	default:
+		break;
+	}
+	pr_out_vdev_handle_end(vdpa);
+}
+
+static int cmd_dev_vstats_show_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[VDPA_ATTR_MAX + 1] = {};
+	struct vdpa *vdpa = data;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[VDPA_ATTR_DEV_NAME] || !tb[VDPA_ATTR_DEV_ID])
+		return MNL_CB_ERROR;
+	pr_out_dev_vstats(vdpa, tb, nlh);
+	return MNL_CB_OK;
+}
+
+static void cmd_dev_vstats_help(void)
+{
+	fprintf(stderr, "Usage: vdpa dev vstats show DEV [qidx QUEUE_INDEX]\n");
+}
+
+static int cmd_dev_vstats_show(struct vdpa *vdpa, int argc, char **argv)
+{
+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
+	struct nlmsghdr *nlh;
+	int err;
+
+	if (argc != 1 && argc != 3) {
+		cmd_dev_vstats_help();
+		return -EINVAL;
+	}
+
+	nlh = mnlu_gen_socket_cmd_prepare(&vdpa->nlg, VDPA_CMD_DEV_STATS_GET,
+					  flags);
+
+	err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
+				  VDPA_OPT_VDEV_HANDLE, VDPA_OPT_QUEUE_INDEX);
+	if (err)
+		return err;
+
+	pr_out_section_start(vdpa, "vstats");
+	err = mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, cmd_dev_vstats_show_cb, vdpa);
+	pr_out_section_end(vdpa);
+	return 0;
+}
+
+static int cmd_dev_vstats(struct vdpa *vdpa, int argc, char **argv)
+{
+	if (argc < 1) {
+		cmd_dev_vstats_help();
+		return -EINVAL;
+	}
+
+	if (matches(*argv, "help") == 0) {
+		cmd_dev_vstats_help();
+		return 0;
+	} else if (matches(*argv, "show") == 0) {
+		return cmd_dev_vstats_show(vdpa, argc - 1, argv + 1);
+	}
+	fprintf(stderr, "Command \"%s\" not found\n", *argv);
+	return -ENOENT;
+}
+
 static int cmd_dev(struct vdpa *vdpa, int argc, char **argv)
 {
 	if (!argc)
@@ -836,6 +990,8 @@ static int cmd_dev(struct vdpa *vdpa, int argc, char **argv)
 		return cmd_dev_del(vdpa, argc - 1, argv + 1);
 	} else if (matches(*argv, "config") == 0) {
 		return cmd_dev_config(vdpa, argc - 1, argv + 1);
+	} else if (matches(*argv, "vstats") == 0) {
+		return cmd_dev_vstats(vdpa, argc - 1, argv + 1);
 	}
 	fprintf(stderr, "Command \"%s\" not found\n", *argv);
 	return -ENOENT;
-- 
2.35.1

