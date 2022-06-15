Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F1254C044
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 05:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239500AbiFODq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 23:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiFODq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 23:46:26 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3904F9D4
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 20:46:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+a+BS2KrNu95LTZjApJrv/YtqGChdQDAZHYlXB8kf0HM4xlVVS3XhTtMkJRyPkh4nI+FFU9YgkouVmItXzD5mTbZIDVfXnYgKXjMXTN5VeTZjLbLWbuPTlTbKEDd8puOLTF2HhGLZ+2htw/e4mMbEbZqI1GjlswA5AQgAotPb1x9NPiweKaI3Sck7jgs14cFFn14IDUos1pEZ2B3HwsrLI7SU+2i5bAVI1DfNjF7Ck/KL0HWfe7dLL6OydMYpCEiWvMSOo3u8bhEmba1pFqYt67rLE3mM9q3HhU4dH5XN1w4SiZH7R8CZGykDkMOr/ylBCbvdMHKOuX6tSa/9Wj7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yZJ/Pl+FA+u8wQGkrZFDqIqu25s0OnOov42YbSNbs7I=;
 b=NqsyBfnyc3TPjroxMXCDLnc3xj6Pbsym2xdS6g3rfjB1+cO0EA3oZrVd9X9DMbfiJdI5eIQGBZKXgH1VhxpLyyZnPa6SvW6ipMh3TpW95MyRHlsFK1yu1g9/wt3w9Bnf7KQYCxomvO47ViaVkzePgE7NhsCNYxdFrtPHGdf/rE7AH4VtaMQ+FZX8v2hkuAn9EM1GrsHIp1+9VSvqNnmlqGF+Fzg0C0ZyjJ/c7tjGLpd36OdOlTv9WFBYRv1Q/sOQLPXdx0ogjGJUoBMGjYM9s58EJHbdCl9crJ9s9pXEtZLC6dNHAV3UWQ82x30U/aSLIsMiL7B0zqcAff1x1hauEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZJ/Pl+FA+u8wQGkrZFDqIqu25s0OnOov42YbSNbs7I=;
 b=MbFjCVbBo1djP/qeyCqy9invsqn78XrpfQFBvexoWOEyqeiL3bgRZO+9Zbvxnx8vY9aD/z6BZjJf6t9qR7pd+kznRiJU6azVEXQTVCC2sTxh+UY2FOmgpaZjNDZMfaA4QhrLib1iInXp0CoJ6bMo4i7QtbVZG5SGVPInKxAbjRG0yP89HkhckcEcAJMUtKn9i5N2/GOdfv6R6xwjPZFaBlnbHLY3uumv0cw/Wp/49wpGJ0JIzpc9AtptQ7JU4HWgw4r8kZO7pBHk4ngQfTvZfbPmP02vQIeYcIUsGHSgdW6G2RthThnJ0zkRoVJC/rb2Y7v0uqvbOXXdA43l0CoJ7g==
Received: from MW4P221CA0022.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::27)
 by BN6PR12MB1780.namprd12.prod.outlook.com (2603:10b6:404:107::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Wed, 15 Jun
 2022 03:46:23 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::3e) by MW4P221CA0022.outlook.office365.com
 (2603:10b6:303:8b::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13 via Frontend
 Transport; Wed, 15 Jun 2022 03:46:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 03:46:23 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 15 Jun
 2022 03:46:22 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 14 Jun
 2022 20:46:21 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Tue, 14 Jun
 2022 20:46:19 -0700
From:   Eli Cohen <elic@nvidia.com>
To:     <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>, <mst@redhat.com>
CC:     Eli Cohen <elic@nvidia.com>
Subject: [PATCH v1] vdpa: Add support for reading vdpa device statistics
Date:   Wed, 15 Jun 2022 06:46:16 +0300
Message-ID: <20220615034616.16474-1-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 650bc17c-c776-46e8-0ea2-08da4e819dcc
X-MS-TrafficTypeDiagnostic: BN6PR12MB1780:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB178074190CEF45CEDB5F63C0ABAD9@BN6PR12MB1780.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i4x/K6FYMtiD6eLxRXQaxEY+Bt0bYuzpSWOoIx/1wfICFw5OwnU8tN4Shp/EZwjyZxXGtHOdGaFSOI/XNNa6yKVTA9odsPUPa4KtJ9ltvAanT29vRiJvcOUTPDsjRdbVi0Z3b4hmlE7Kw8+f7j5cIMZjWN1e4ns8ut6ZU1rw8ovIClcCI9Pg7Jk4wn+3fRh72Z2pR1/mn14a1MGqqM2xvi0Acub7mFxf9PahxbcgU8AYba0MzFMcL3MB2PK3drqEGb1+rLMO57KIIWhFjmioicHwLXsfde/ou+w20K/kT+KYYRepOQcdFhnR7kL6ftf+iv5iYE5IfWHIbl00dPj4VTGtINo1P0rveGNnxA9SXm1x/9QkTKE8GrUxPpNR0qu2dmFxf4m+Y2bUm2V1bfUBw46iqcy4ZKGV4m3AynNxBssHJLyyE0gTbpGi9bPBdAJ9r/ZoWoD2Moq/MTMgNKjESMu25pqHxuZ2zzHmMqfwccprjaQPuK4oNBRKNk9y0Kp3q6QRO0hLJtIFseQKWea/N8vq97j8O000HmlaZS3LL76sMrmuxt/TpzxLnUNmsl6TmQg28PLZUFa1k1YZULebWMmhKFLdZXLe64uZ3FmhC/jKBLK67Z6b7rYVqnDoqGJU+on09UXHpjfE/LBUZPP4Bt55ArQlcyuxYS0juPolaHM7MX05/c8iFT95Ry+8c6Bx8OropiJKBJ7kMpQOSVh9tg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(46966006)(40470700004)(36840700001)(7696005)(5660300002)(26005)(8676002)(316002)(70206006)(70586007)(110136005)(4326008)(86362001)(81166007)(6666004)(356005)(508600001)(8936002)(426003)(82310400005)(1076003)(2616005)(107886003)(186003)(47076005)(83380400001)(336012)(36756003)(40460700003)(2906002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 03:46:23.0396
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 650bc17c-c776-46e8-0ea2-08da4e819dcc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1780
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
V0 -> V1:
1. Avoid using matches(), use strcmp() instead
2. Put some code inside a function to get shorter lines.

References kernel commit:
commit 1892a3d425bf525ac98d6d3534035e6ed2bfab50
Author: Eli Cohen <elic@nvidia.com>
Date:   Wed May 18 16:38:03 2022 +0300

    vdpa/mlx5: Add support for reading descriptor statistics


 vdpa/include/uapi/linux/vdpa.h |   6 ++
 vdpa/vdpa.c                    | 163 +++++++++++++++++++++++++++++++++
 2 files changed, 169 insertions(+)

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
index 3ae1b78f4cac..6ded1030273b 100644
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
@@ -304,6 +320,15 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
 
 			NEXT_ARG_FWD();
 			o_found |= VDPA_OPT_MAX_VQP;
+		} else if (!strcmp(*argv, "qidx") &&
+			   (o_optional & VDPA_OPT_QUEUE_INDEX)) {
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
@@ -594,6 +619,7 @@ static void cmd_dev_help(void)
 	fprintf(stderr, "                                                    [ max_vqp MAX_VQ_PAIRS ]\n");
 	fprintf(stderr, "       vdpa dev del DEV\n");
 	fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
+	fprintf(stderr, "Usage: vdpa dev vstats COMMAND\n");
 }
 
 static const char *device_type_name(uint32_t type)
@@ -819,6 +845,141 @@ static int cmd_dev_config(struct vdpa *vdpa, int argc, char **argv)
 	return -ENOENT;
 }
 
+#define MAX_KEY_LEN 200
+/* 5 bytes for format */
+#define MAX_FMT_LEN (MAX_KEY_LEN + 5 + 1)
+
+static void print_queue_type(struct nlattr *attr, uint16_t max_vqp, uint64_t features)
+{
+	bool is_ctrl = false;
+	uint16_t qidx = 0;
+
+	qidx = mnl_attr_get_u16(attr);
+	is_ctrl = features & BIT(VIRTIO_NET_F_CTRL_VQ) && qidx == 2 * max_vqp;
+	if (!is_ctrl) {
+		if (qidx & 1)
+			print_string(PRINT_ANY, "queue_type", "queue_type %s ",
+				     "tx");
+		else
+			print_string(PRINT_ANY, "queue_type", "queue_type %s ",
+				     "rx");
+	} else {
+		print_string(PRINT_ANY, "queue_type", "queue_type %s ",
+			     "control_vq");
+	}
+}
+
+static void pr_out_dev_net_vstats(const struct nlmsghdr *nlh)
+{
+	const char *name = NULL;
+	uint64_t features = 0;
+	char fmt[MAX_FMT_LEN];
+	uint16_t max_vqp = 0;
+	struct nlattr *attr;
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
+			print_queue_type(attr, max_vqp, features);
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
+	if (!strcmp(*argv, "help")) {
+		cmd_dev_vstats_help();
+		return 0;
+	} else if (!strcmp(*argv, "show")) {
+		return cmd_dev_vstats_show(vdpa, argc - 1, argv + 1);
+	}
+	fprintf(stderr, "Command \"%s\" not found\n", *argv);
+	return -ENOENT;
+}
+
 static int cmd_dev(struct vdpa *vdpa, int argc, char **argv)
 {
 	if (!argc)
@@ -836,6 +997,8 @@ static int cmd_dev(struct vdpa *vdpa, int argc, char **argv)
 		return cmd_dev_del(vdpa, argc - 1, argv + 1);
 	} else if (matches(*argv, "config") == 0) {
 		return cmd_dev_config(vdpa, argc - 1, argv + 1);
+	} else if (!strcmp(*argv, "vstats")) {
+		return cmd_dev_vstats(vdpa, argc - 1, argv + 1);
 	}
 	fprintf(stderr, "Command \"%s\" not found\n", *argv);
 	return -ENOENT;
-- 
2.35.1

