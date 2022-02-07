Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA164ABF34
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443778AbiBGNBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447293AbiBGM41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 07:56:27 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED44CC043181
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 04:56:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MzYL8Pl9E8EsiHCQv/fiygfcgT9yeELLd73u1bBJy2lvL0wXZH2DpDaD7+2GZu91HqjeC0OjRloa+EMVkPSOWPCtJwzbmoZjlBuxX62f7oCBl28jtc7yeIJH9jk0Cc9sfZWAe5Pix0q87CwMwOyPLibgYSr/Xcpv4YCfdEpa1IymIZBL9yVtsXUMIEggom9FPdw92obZfIusdwFhk+Pi/zTYefqSE9Mmok+9P95qAMVi0s6ybKuwvRnPsm2xf8m0hIfYKx9gGQgG1qZSALIB+oyuIVq9qAg+uuwH+YDdwzbtUH83KL8neeMKeP5JPt+1/re9x3qdbFlirGLRXxlxVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=soL2TRuh0Wlb/hoeGCmDtuVNaKP0S2wNTvBrecMhYPk=;
 b=E/vfFBQJVYQrNTAZ4ryGGp32wzBkL0lQEq5bxy1VSxySIn9uJSzTcyaYkbFl3AL2CRFbr8UbqONiG12H36D9TEhLrFV25t5+8PtfkLakrstWRSWGdPdP5on7t6gNu+wl/QQpfT+nBKhlXCdagn7rjS/c6izq5TLATEt5r0xrBQgAu7c7X/K6+1ZlNBTjKu0K1U1FC3FITHeV3z12ffXsUNB3Wm46XRp4P2v7uEBek41BHWdgwklk8WVLT2F0WKUwTYgmHbjFFAUKAHFvEy8MLz89FwdzkkNeXPnoXGdRjvp4VSuuFzEMUA0ofI8J076xeH+jqWYKBjxDLQrjj31AiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=soL2TRuh0Wlb/hoeGCmDtuVNaKP0S2wNTvBrecMhYPk=;
 b=U01naGTDgGAGnTL8GrouiYTGdp//NlX9H4Ae2KFvl3xZG4nGD2WGnUkFgwPYyuGfhWNaDBiCM5tMWZtJxUe1fPcEBkmAREr8rwJ51WRGTEMAnl9RI76Q5751sGh01KWAKKjxG1KbNLBsmsxaVok6SWI88iYqzo0LuKN2kUVqoyXl8CBf3lG5G49VaYoOwskm600YcZA5xG5oQjCIFow3OS3siltgrKO/2daioBR5kVWCcQCmdtUoQnb7NyRCATAFQaAUpURLBonQx57TpBBrELJkBTmNR+MK1jeCAOiF+Ml73JfPDTLSx7OkGtv00T/J2PEiajbvEBvHlosqxLuhbA==
Received: from MW4PR04CA0178.namprd04.prod.outlook.com (2603:10b6:303:85::33)
 by BYAPR12MB3157.namprd12.prod.outlook.com (2603:10b6:a03:130::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Mon, 7 Feb
 2022 12:56:23 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::3c) by MW4PR04CA0178.outlook.office365.com
 (2603:10b6:303:85::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17 via Frontend
 Transport; Mon, 7 Feb 2022 12:56:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 12:56:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Feb
 2022 12:56:22 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 7 Feb 2022
 04:56:22 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 7 Feb
 2022 04:56:20 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>
CC:     <jasowang@redhat.com>, <si-wei.liu@oracle.com>,
        Eli Cohen <elic@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>
Subject: [PATCH 3/3] vdpa: Add support to configure max number of VQs
Date:   Mon, 7 Feb 2022 14:55:37 +0200
Message-ID: <20220207125537.174619-4-elic@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220207125537.174619-1-elic@nvidia.com>
References: <20220207125537.174619-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 788b4d2b-5bb0-4f0b-532e-08d9ea393eb0
X-MS-TrafficTypeDiagnostic: BYAPR12MB3157:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB31575B4719F0586BA9DC7236AB2C9@BYAPR12MB3157.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lh4EmgZ3wAVchQ/PFnf3+jplThMLOMrm3WgXeLz8Q8Hm/TCcmFTRFFZ5f9BwI5nRvc3p/ay41zYhYnaVe9hG0uYggF4beOKpAC7tRj0qcrGwrN5RxYP6XptAcBw/8QfwOMCy75A1H8LIhs4NkQTf+UrXfNXEOA4Trd6Dvg8m0G+rJ87kKJgMueTfR4WoP9gjbhjxPV4Zf3Ba0vNq6uBY15sO7Yifl22ra1fbayLmB/lktRonwy49xJhZVNUGKdHwrL/J1DXtWCusaLApAUrCkxGeYXaauGwZ1sJYj3LYOD3O+2MwYW6CPxVQh0f3m/jinqh81oAdBklizijv1L3TxSDywe1jA7Q/tLDSi6nHCPWO8/TllC8ED/FDZPDEJi57xj8dI2N8PIvTVV1uxMJWtyGlz6azFBPiTF6GJ42hrx3PNjg0z3JMfaQkleRzItlZN8Rkp0wWOODhMCbJzgmXT6pWSdkuft3xhKatsPoJSXbVB5nlhAXBBcCh7QneBJGuPj/SMaSTtIMfFpCVlUZSg71m+5An/P+yb51OsG8MWfWS9Y2D3IVLJJ0VDKTmFLXcb5h/2kWSvpQqXvrwT4qjRDyk5MOrsPHcMmMixKff85wU/F26/tp8UaIe19VkksL7tiX/z7OBdxE1cndf7WNTz7P4TX3BV6p9j1QJWTWfHR/OfLtA919GNmHW93h2jgRESVv+BM+eYLiP7jBsJDy5sg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(110136005)(1076003)(54906003)(47076005)(186003)(36756003)(40460700003)(316002)(86362001)(6666004)(70586007)(70206006)(8676002)(4326008)(336012)(82310400004)(2906002)(356005)(26005)(8936002)(7696005)(36860700001)(426003)(508600001)(2616005)(107886003)(5660300002)(81166007)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 12:56:23.4008
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 788b4d2b-5bb0-4f0b-532e-08d9ea393eb0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3157
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to configure max supported virtqueue pairs for a vdpa
device. For this to be possible, add support for reading management
device's capabilities. Management device capabilities give the user a
hint as to how many virtqueue pairs at most he can ask for. Using this
information the user can choose a valid number of virtqueue pairs when
creating the device.

Examples:
- Show management device capabiliteis:
$ vdpa mgmtdev show
auxiliary/mlx5_core.sf.1:
  supported_classes net
  max_supported_vqs 257
  dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS CTRL_VQ \
	       MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM

A user can now create a device based on the above information. In the
above case 128 virtqueue pairs at most. The other VQ being for the
control virtqueue.

- Add a vdpa device with 16 data virtqueue pairs
$ vdpa dev add name vdpa-a mgmtdev auxiliary/mlx5_core.sf.1 max_vqp 16

After feature negotiation has been completed, one can read the vdpa
configuration using:
$ vdpa dev config show
vdpa-a: mac 00:00:00:00:88:88 link up link_announce false max_vq_pairs 16 mtu 1500
  negotiated_features CSUM GUEST_CSUM MTU MAC HOST_TSO4 HOST_TSO6 STATUS
                      CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM

Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 vdpa/include/uapi/linux/vdpa.h |   4 ++
 vdpa/vdpa.c                    | 113 ++++++++++++++++++++++++++++++++-
 2 files changed, 114 insertions(+), 3 deletions(-)

diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
index b7eab069988a..171122dd03c9 100644
--- a/vdpa/include/uapi/linux/vdpa.h
+++ b/vdpa/include/uapi/linux/vdpa.h
@@ -40,6 +40,10 @@ enum vdpa_attr {
 	VDPA_ATTR_DEV_NET_CFG_MAX_VQP,		/* u16 */
 	VDPA_ATTR_DEV_NET_CFG_MTU,		/* u16 */
 
+	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
+	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,		/* u32 */
+	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
+
 	/* new attributes must be added above here */
 	VDPA_ATTR_MAX,
 };
diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index 4ccb564872a0..d0dd4196610f 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -23,6 +23,7 @@
 #define VDPA_OPT_VDEV_HANDLE		BIT(3)
 #define VDPA_OPT_VDEV_MAC		BIT(4)
 #define VDPA_OPT_VDEV_MTU		BIT(5)
+#define VDPA_OPT_MAX_VQP		BIT(6)
 
 struct vdpa_opts {
 	uint64_t present; /* flags of present items */
@@ -32,6 +33,7 @@ struct vdpa_opts {
 	unsigned int device_id;
 	char mac[ETH_ALEN];
 	uint16_t mtu;
+	uint16_t max_vqp;
 };
 
 struct vdpa {
@@ -78,6 +80,9 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
 	[VDPA_ATTR_DEV_VENDOR_ID] = MNL_TYPE_U32,
 	[VDPA_ATTR_DEV_MAX_VQS] = MNL_TYPE_U32,
 	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
+	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
+	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
+	[VDPA_ATTR_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
 };
 
 static int attr_cb(const struct nlattr *attr, void *data)
@@ -219,6 +224,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
 			     sizeof(opts->mac), opts->mac);
 	if (opts->present & VDPA_OPT_VDEV_MTU)
 		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU, opts->mtu);
+	if (opts->present & VDPA_OPT_MAX_VQP)
+		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
 }
 
 static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
@@ -287,6 +294,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
 
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
@@ -385,6 +400,77 @@ static const char *parse_class(int num)
 	return class ? class : "< unknown class >";
 }
 
+static const char * const net_feature_strs[64] = {
+	[VIRTIO_NET_F_CSUM] = "CSUM",
+	[VIRTIO_NET_F_GUEST_CSUM] = "GUEST_CSUM",
+	[VIRTIO_NET_F_CTRL_GUEST_OFFLOADS] = "CTRL_GUEST_OFFLOADS",
+	[VIRTIO_NET_F_MTU] = "MTU",
+	[VIRTIO_NET_F_MAC] = "MAC",
+	[VIRTIO_NET_F_GUEST_TSO4] = "GUEST_TSO4",
+	[VIRTIO_NET_F_GUEST_TSO6] = "GUEST_TSO6",
+	[VIRTIO_NET_F_GUEST_ECN] = "GUEST_ECN",
+	[VIRTIO_NET_F_GUEST_UFO] = "GUEST_UFO",
+	[VIRTIO_NET_F_HOST_TSO4] = "HOST_TSO4",
+	[VIRTIO_NET_F_HOST_TSO6] = "HOST_TSO6",
+	[VIRTIO_NET_F_HOST_ECN] = "HOST_ECN",
+	[VIRTIO_NET_F_HOST_UFO] = "HOST_UFO",
+	[VIRTIO_NET_F_MRG_RXBUF] = "MRG_RXBUF",
+	[VIRTIO_NET_F_STATUS] = "STATUS",
+	[VIRTIO_NET_F_CTRL_VQ] = "CTRL_VQ",
+	[VIRTIO_NET_F_CTRL_RX] = "CTRL_RX",
+	[VIRTIO_NET_F_CTRL_VLAN] = "CTRL_VLAN",
+	[VIRTIO_NET_F_CTRL_RX_EXTRA] = "CTRL_RX_EXTRA",
+	[VIRTIO_NET_F_GUEST_ANNOUNCE] = "GUEST_ANNOUNCE",
+	[VIRTIO_NET_F_MQ] = "MQ",
+	[VIRTIO_F_NOTIFY_ON_EMPTY] = "NOTIFY_ON_EMPTY",
+	[VIRTIO_NET_F_CTRL_MAC_ADDR] = "CTRL_MAC_ADDR",
+	[VIRTIO_F_ANY_LAYOUT] = "ANY_LAYOUT",
+	[VIRTIO_NET_F_RSC_EXT] = "RSC_EXT",
+	[VIRTIO_NET_F_STANDBY] = "STANDBY",
+};
+
+#define VDPA_EXT_FEATURES_SZ (VIRTIO_DEV_INDEPENDENT_F_END - \
+			      VIRTIO_DEV_INDEPENDENT_F_START + 1)
+
+static const char * const ext_feature_strs[VDPA_EXT_FEATURES_SZ] = {
+	[VIRTIO_F_RING_INDIRECT_DESC - VIRTIO_DEV_INDEPENDENT_F_START] = "RING_INDIRECT_DESC",
+	[VIRTIO_F_RING_EVENT_IDX - VIRTIO_DEV_INDEPENDENT_F_START] = "RING_EVENT_IDX",
+	[VIRTIO_F_VERSION_1 - VIRTIO_DEV_INDEPENDENT_F_START] = "VERSION_1",
+	[VIRTIO_F_ACCESS_PLATFORM - VIRTIO_DEV_INDEPENDENT_F_START] = "ACCESS_PLATFORM",
+	[VIRTIO_F_RING_PACKED - VIRTIO_DEV_INDEPENDENT_F_START] = "RING_PACKED",
+	[VIRTIO_F_IN_ORDER - VIRTIO_DEV_INDEPENDENT_F_START] = "IN_ORDER",
+	[VIRTIO_F_ORDER_PLATFORM - VIRTIO_DEV_INDEPENDENT_F_START] = "ORDER_PLATFORM",
+	[VIRTIO_F_SR_IOV - VIRTIO_DEV_INDEPENDENT_F_START] = "SR_IOV",
+	[VIRTIO_F_NOTIFICATION_DATA - VIRTIO_DEV_INDEPENDENT_F_START] = "NOTIFICATION_DATA",
+};
+
+static void print_net_features(struct vdpa *vdpa, uint64_t features, bool maxf)
+{
+	const char *s;
+	int i;
+
+	if (maxf)
+		pr_out_array_start(vdpa, "dev_features");
+	else
+		pr_out_array_start(vdpa, "negotiated_features");
+
+	for (i = 0; i < 64; i++) {
+		if (!(features & (1ULL << i)))
+			continue;
+
+		if (i >= VIRTIO_DEV_INDEPENDENT_F_START && i <= VIRTIO_DEV_INDEPENDENT_F_END)
+			s = ext_feature_strs[i - VIRTIO_DEV_INDEPENDENT_F_START];
+		else
+			s = net_feature_strs[i];
+
+		if (!s)
+			print_uint(PRINT_ANY, NULL, " unrecognized_bit_%d", i);
+		else
+			print_string(PRINT_ANY, NULL, " %s", s);
+	}
+	pr_out_array_end(vdpa);
+}
+
 static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
 				struct nlattr **tb)
 {
@@ -408,6 +494,22 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
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
+	if (tb[VDPA_ATTR_DEV_SUPPORTED_FEATURES]) {
+		uint64_t features;
+
+		features  = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_SUPPORTED_FEATURES]);
+		print_net_features(vdpa, features, true);
+	}
+
 	pr_out_handle_end(vdpa);
 }
 
@@ -557,7 +659,7 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
 					  NLM_F_REQUEST | NLM_F_ACK);
 	err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
 				  VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
-				  VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU);
+				  VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU | VDPA_OPT_MAX_VQP);
 	if (err)
 		return err;
 
@@ -579,9 +681,10 @@ static int cmd_dev_del(struct vdpa *vdpa,  int argc, char **argv)
 	return mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, NULL, NULL);
 }
 
-static void pr_out_dev_net_config(struct nlattr **tb)
+static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
 {
 	SPRINT_BUF(macaddr);
+	uint64_t val_u64;
 	uint16_t val_u16;
 
 	if (tb[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
@@ -610,6 +713,10 @@ static void pr_out_dev_net_config(struct nlattr **tb)
 		val_u16 = mnl_attr_get_u16(tb[VDPA_ATTR_DEV_NET_CFG_MTU]);
 		print_uint(PRINT_ANY, "mtu", "mtu %d ", val_u16);
 	}
+	if (tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]) {
+		val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]);
+		print_net_features(vdpa, val_u64, false);
+	}
 }
 
 static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
@@ -619,7 +726,7 @@ static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
 	pr_out_vdev_handle_start(vdpa, tb);
 	switch (device_id) {
 	case VIRTIO_ID_NET:
-		pr_out_dev_net_config(tb);
+		pr_out_dev_net_config(vdpa, tb);
 		break;
 	default:
 		break;
-- 
2.34.1

