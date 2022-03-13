Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3E04D754A
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 13:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbiCMMsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 08:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbiCMMr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 08:47:59 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD173D1E3
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 05:46:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/a87udtxR9rJGgiJHQJwtmC4M8vi4JqdJcJvHHTDaHSQyNAp0YhVOsk6SM+Oz1wHmr7UDdLu8rfysKkd8gESvxmzzSQFq0hPB01cTvBCsWgZayGuONp8byTOpwCmm9BQMD2ZpSXcU4UbC+OtwY4Kx2cOfKIvdXF4eznkRmWm31j9T7jOOGSCm8JShxG6sGs6lhEpKwCdAA6RiE6jk6iSuv1SMqe75TvZQVDxRrNhakSNt8HIZnoETMtufD+qwYJB0TLziugm+Dhe2CIkMqxLCIhIFySIrfFDHGgM5HpUEMqEhhjgTwtkKqMqX27w3nGYW7BLbubizjw4EvATNEhZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xWJ8gM2R9umiEzGPKwrLKV6Atc0ly7IuD81qcKCqN9E=;
 b=aerWjL7oP+nTw6x/78luSsNmZjYJCB3oJQLbBAgmcUwEWptlu2Tpa4lSrGCqmW8E60NdEeM60m4XqkBjbEa0Z9xUMo/gFur6Kqrgox5ca4WZ/HHchR49WRChNIkd6hLi4xGJp1GLC+qE/inY/+JZflgiHPkOnzOKFxwgKs5+A11NGzrRcxjzGvQ1gjdKc3oyp6qfoFr/RjcWnCNieLGVVm55giSLO3wAdnHx0Wf8EkKXuIzgm0GC0mLuvTQmieGqnG8nyBEIAg/hnYtSji9akTkV7seFhpg8fOAweRtsjbkSPzlOUWM5OqEHxRvw+ZaXsGRkj2Wm4UBYNluOPuXvmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xWJ8gM2R9umiEzGPKwrLKV6Atc0ly7IuD81qcKCqN9E=;
 b=he3OzEUe4HLW3+k2ZiGQIjC7vfcP+FsPAldb0z4i++1/uYV5neFUU3ubiCzaA/PtQkgWE130mbe/9A+ft40ExjQo2w461MiTgQy+EPClMTHw0/bwhUmSdkvBaqnr4BLd4rY03BV2c5ncesG8+VqVcILuJQdVayJJdhMTzgRud2fXFp2dr0WwMJL+w8TtE51QfFMDjAeD5IYiTh02A8cUFD6YDbWAkTXA9I6mXyTw87ygbT6mTqxKftNgsJt+U5Kw9NTLncSxMbXXovmuu0ah5mRUlAmOHfIY2p3UiiyZq8S+rgD3mpRE+eEyrSGmfqG/X0aUC/8DjA01ElcB/p/azg==
Received: from MWHPR04CA0069.namprd04.prod.outlook.com (2603:10b6:300:6c::31)
 by MN2PR12MB4175.namprd12.prod.outlook.com (2603:10b6:208:1d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Sun, 13 Mar
 2022 12:46:48 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:6c:cafe::8c) by MWHPR04CA0069.outlook.office365.com
 (2603:10b6:300:6c::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.20 via Frontend
 Transport; Sun, 13 Mar 2022 12:46:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Sun, 13 Mar 2022 12:46:47 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 13 Mar
 2022 12:46:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 13 Mar
 2022 05:46:44 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Sun, 13 Mar
 2022 05:46:42 -0700
From:   Eli Cohen <elic@nvidia.com>
To:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>
Subject: [PATCH v6 3/4] vdpa: Support for configuring max VQ pairs for a device
Date:   Sun, 13 Mar 2022 14:46:28 +0200
Message-ID: <20220313124629.297014-4-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220313124629.297014-1-elic@nvidia.com>
References: <20220313124629.297014-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f61d67c4-247d-451f-83df-08da04ef8978
X-MS-TrafficTypeDiagnostic: MN2PR12MB4175:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4175CB2FE1936CBB47A7E4DCAB0E9@MN2PR12MB4175.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WUXGAYj6ZIhcz/DriKUN5bPCVCfLAFzUOgP839Hf6cSJtt3nPz+PN+ieQIT8HbwmP/ilTvzStlxOvD1S9YzF5K+8Ponwohom/P00NCVt+305kyMs4bbuhltaHJhm0muM/rwc3qp+f7KPBolh/pRXm2mn9MlqQHZZJzE/bLAUtQzB+6gZI5HCRlSSoyttRxCEWnSHiLAA85zUuHyjZKBQYQjrg/JRqcPI7bKM36BZDuL/WSGAjIr1I4tpzTqq/scVgfWQOSgau8rXn8axUfCGDcs9xFnCO4GsWgRkwxDYEaI8UWzR8X1rMfBZXAdJQHrLKm7fY5hagfk+UpB+6pQIPnzGrlU7Cw4irA3HH3S0LNkxVKvUEClc0EhQFMpAosnPK4v8plNTTO2AKgoXs67Qn9CvxBUyYP7JQH6PmG79P04FL+AWpKZwxyVv3Wf7PcI2kSl5NcCem4KDCIkGiCv6MjVmCuuglzospLn2cdOdJD9uKZHC0TcbKrWGtN0IqnHBWJsS31AeMkFv4tn+aPTOYtuPVYkS3LxiDzSaAa29CVqeZvhWUiLIbMGHmELvykx1yjIKvs0IMS+XfHnsrnaHTNrJ9lEKGWnKA2g/GkdGKjmKqZQsZ46ziyONeNcjuuTQtjPe3HLvmlZ8jSE0sy7eFKKIO+/oY8NlKQubV03juTF6022ET2Rb52ceQ5pcorRRCNTlupOyivUf4DC3BGu/fg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(8936002)(426003)(47076005)(83380400001)(336012)(54906003)(5660300002)(316002)(1076003)(186003)(26005)(36860700001)(36756003)(110136005)(7696005)(2616005)(2906002)(508600001)(356005)(81166007)(40460700003)(70586007)(8676002)(70206006)(86362001)(4326008)(6666004)(82310400004)(107886003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2022 12:46:47.5480
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f61d67c4-247d-451f-83df-08da04ef8978
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4175
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 vdpa/vdpa.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index 7cc370e34118..1326a63e729d 100644
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
@@ -503,6 +516,14 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
 		pr_out_array_end(vdpa);
 	}
 
+	if (tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]) {
+		uint32_t num_vqs;
+
+		print_nl();
+		num_vqs = mnl_attr_get_u32(tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]);
+		print_uint(PRINT_ANY, "max_supported_vqs", "  max_supported_vqs %d", num_vqs);
+	}
+
 	pr_out_handle_end(vdpa);
 }
 
@@ -563,6 +584,7 @@ static void cmd_dev_help(void)
 {
 	fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
 	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
+	fprintf(stderr, "                                                    [ max_vqp MAX_VQ_PAIRS ]\n");
 	fprintf(stderr, "       vdpa dev del DEV\n");
 	fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
 }
@@ -652,7 +674,8 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
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

