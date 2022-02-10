Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5103B4B0EC8
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242242AbiBJNbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 08:31:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238351AbiBJNb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:31:29 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5079DBDA
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 05:31:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgU8IIWMJ1/PIhZPDVz9f8chxwsuQNwHTw3HgFkPy5nouu52ceDYR+tcprcfqVTMeLNAfC1M3VFlPTHCKGW14Jb99Gkt0+qixnDuwnvNYaeg7ubM+REzGy3OP3tyjeKFu+/O57lYR6Cw/TJrW/m7tPz47JQDU0XALee0LiPLOdGFHdub0ugv0+w1th34QhitLk5vMXdG2f9f/wR06JNVuprRNJiSH2url0i0F+8DmVte1L0uzA0bZLJ5GHkjwwyNRiSMW+vH4awO/tYeKHZv8TXZCWlJVn9NgYSJDQRB0F1vtJonXpewJ+oihizOk7GQY+RiIRwSdPX/uGOt9xjVjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+x91k3lvKrzKozK058sQ+Idezv5Izj9Jn/XeooB3ngQ=;
 b=HwZ20Hc64Inat3hirBnr4Me4LQ3uUG2ftoaSS1fJWoPzfdt2yEcb3QGjIfo2YZJj6rvrYWspxOPEaUrReNpxrLltPyXCLnDmCy9Y9/0bOKhVFwt4NPOGz940rT5uR54Cwt+uxbsopDqZPhilvan10jOS3TzwqGOQHlYX0FPTYURqUssSje92k5/uLERYRhG8M0kKdhbqHv/nqmgOa32aRwmDlzVXRbU9IG2UFU4n7v9pYHB6pdZkd7/42zuBvq3mDdGJLzuSK3qNsOPHk3Oib9B1kLgH2m6uoE2N3s7ePVEXoJRsmMMw2JnC3a5lrtKM/Y8nt+a9+tlt5uH9l96t6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+x91k3lvKrzKozK058sQ+Idezv5Izj9Jn/XeooB3ngQ=;
 b=ZoHVJHJsAfGLGtKvtDzF2w1eTd2Ugf+JtOIdrCJADIsciCKlnmR4d8wrv1F0MBoCvh/vqJ6l3n806Mxp6mvxXGa2QVQ/epXsaxUleavNWrIq8tuOHd/GSGX54cn6YGuACtSfx5vpwJUd0A5NMoYy1SAmk+CYLSvLaYkUkSpBekcbmqAff+uY7IfNpqAf4GjfQmIyon6yFwRnJzKdmB1NlP7oJDIGGtYCQEpDt91/wc59/Yrd1wyfbbZ1rwNngmm8qn9vgKOK1WNtZWPs1CSyVQl9dwkJIUuFc8HgjVfTnKbHO34M1Xs1o3DNGDm4SANwZjHUpN9H5OQ6n1Ir867iRA==
Received: from BN9P222CA0025.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::30)
 by SA1PR12MB5640.namprd12.prod.outlook.com (2603:10b6:806:238::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 13:31:28 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::36) by BN9P222CA0025.outlook.office365.com
 (2603:10b6:408:10c::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.13 via Frontend
 Transport; Thu, 10 Feb 2022 13:31:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 13:31:27 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 13:31:26 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 10 Feb 2022
 05:31:25 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 10 Feb
 2022 05:31:24 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>
CC:     <jasowang@redhat.com>, <lulu@redhat.com>, <si-wei.liu@oracle.com>,
        "Eli Cohen" <elic@nvidia.com>
Subject: [PATCH v1 2/4] vdpa: Allow for printing negotiated features of a device
Date:   Thu, 10 Feb 2022 15:31:13 +0200
Message-ID: <20220210133115.115967-3-elic@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210133115.115967-1-elic@nvidia.com>
References: <20220210133115.115967-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25d5fe95-f3b9-4155-c74f-08d9ec99a481
X-MS-TrafficTypeDiagnostic: SA1PR12MB5640:EE_
X-Microsoft-Antispam-PRVS: <SA1PR12MB5640791F52FB967FAC8FE28AAB2F9@SA1PR12MB5640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:660;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jyXScTPiFulnzW5OL5tQiS4s2nrcdxfNipU9FBr2pr+yiq/j15HOVBkQmDuueVvwsmk+jFXT8nU63R5NibYys9xvzj1s8wXZSbRPMipcZYjFRUV6H0kMUY9xpgKziA1tsgaPAaceybgZmA38e11i1CtTyIeHQirbbm1VdRgVfJXb7rN9LGhlRq/AiFQXOfrpfDPTbtRvl3teqCMGQA8j8VMawnSJGOm2mzM4Pkwo1M/R929ON4I16skT4ZgqJm1vhTLMC15vN/PQ6BwAhZdiLxcCzvxTmH1fD1LdG2OVot7krM1sb/KEl6Fa+wlb70GBaAw7YpTWsRStk3H5IGGPZ5Ln70G30JIrB8V1WFQn5YQES6ez4swDddX/TBTA0UDFHjfIP+6J9QFVTlg+gyfC4GvGqtajGRjtGGcopKtjhi5hujY4WCut7eLEqokUIM2fCJV5J2oTJQYmXbSiMSgkYNYOW7QQ5EryrlvwrU2kMSKQvUYiLyZaU5ucAPxqZWUpQAFuYPm1TmTz2EgmoIobB7GIq1Izg/SQ1wg4unRgJAp6Nf7H550jf5c9Ihvg9bgn8SchVFFcWv89CMKpVg7YBRYDdQmYOdScz8pZC0wzrwmirsLvTVsAeFObabkCk1mphngk0GzWYFDmYukdIr9c6F3HsCQnh8aAZ/slwm8L+ynnwxT5BT+RZbIVLAc8cCbo6trYeMGNr8u4gX1vmJBp5A==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(426003)(336012)(70586007)(4326008)(186003)(5660300002)(26005)(82310400004)(70206006)(86362001)(83380400001)(2906002)(81166007)(8676002)(356005)(6666004)(2616005)(54906003)(110136005)(7696005)(40460700003)(36860700001)(107886003)(36756003)(8936002)(47076005)(508600001)(1076003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 13:31:27.7662
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25d5fe95-f3b9-4155-c74f-08d9ec99a481
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5640
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When reading the configuration of a vdpa device, check if the
VDPA_ATTR_DEV_NEGOTIATED_FEATURES is available. If it is, parse the
feature bits and print a string representation of each of the feature
bits.

We keep the strings in two different arrays. One for net device related
devices and one for generic feature bits.

In this patch we parse only net device specific features. Support for
other devices can be added later. If the device queried is not a net
device, we print its bit number only.

Examples:
1.
$ vdpa dev config show vdpa-a
vdpa-a: mac 00:00:00:00:88:88 link up link_announce false max_vq_pairs 3 \
        mtu 1500
  negotiated_features CSUM GUEST_CSUM MTU MAC HOST_TSO4 HOST_TSO6 STATUS \
                      CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM

2. json output
$ vdpa -j dev config show vdpa-a
{"config":{"vdpa-a":{"mac":"00:00:00:00:88:88","link":"up","link_announce":false, \
  "max_vq_pairs":3,"mtu":1500,"negotiated_features":["CSUM","GUEST_CSUM","MTU", \
  "MAC","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ","MQ","CTRL_MAC_ADDR", \
  "VERSION_1","ACCESS_PLATFORM"]}}}

3. pretty json
$ vdpa -jp dev config show vdpa-a
{
    "config": {
        "vdpa-a": {
            "mac": "00:00:00:00:88:88",
            "link ": "up",
            "link_announce ": false,
            "max_vq_pairs": 3,
            "mtu": 1500,
            "negotiated_features": [
"CSUM","GUEST_CSUM","MTU","MAC","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ", \
"MQ","CTRL_MAC_ADDR","VERSION_1","ACCESS_PLATFORM" ]
        }
    }
}

Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 vdpa/include/uapi/linux/vdpa.h |   2 +
 vdpa/vdpa.c                    | 126 +++++++++++++++++++++++++++++++--
 2 files changed, 124 insertions(+), 4 deletions(-)

diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
index b7eab069988a..748c350450b2 100644
--- a/vdpa/include/uapi/linux/vdpa.h
+++ b/vdpa/include/uapi/linux/vdpa.h
@@ -40,6 +40,8 @@ enum vdpa_attr {
 	VDPA_ATTR_DEV_NET_CFG_MAX_VQP,		/* u16 */
 	VDPA_ATTR_DEV_NET_CFG_MTU,		/* u16 */
 
+	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
+
 	/* new attributes must be added above here */
 	VDPA_ATTR_MAX,
 };
diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index 4ccb564872a0..7deab710913d 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -10,6 +10,7 @@
 #include <linux/virtio_net.h>
 #include <linux/netlink.h>
 #include <libmnl/libmnl.h>
+#include <linux/virtio_ring.h>
 #include "mnl_utils.h"
 #include <rt_names.h>
 
@@ -78,6 +79,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
 	[VDPA_ATTR_DEV_VENDOR_ID] = MNL_TYPE_U32,
 	[VDPA_ATTR_DEV_MAX_VQS] = MNL_TYPE_U32,
 	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
+	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
 };
 
 static int attr_cb(const struct nlattr *attr, void *data)
@@ -385,17 +387,120 @@ static const char *parse_class(int num)
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
+	[VIRTIO_NET_F_HASH_REPORT] = "HASH_REPORT",
+	[VIRTIO_NET_F_RSS] = "RSS",
+	[VIRTIO_NET_F_STANDBY] = "STANDBY",
+	[VIRTIO_NET_F_SPEED_DUPLEX] = "SPEED_DUPLEX",
+};
+
+#define VIRTIO_F_IN_ORDER 35
+#define VIRTIO_F_NOTIFICATION_DATA 38
+#define VDPA_EXT_FEATURES_SZ (VIRTIO_TRANSPORT_F_END - \
+			      VIRTIO_TRANSPORT_F_START + 1)
+
+static const char * const ext_feature_strs[VDPA_EXT_FEATURES_SZ] = {
+	[VIRTIO_RING_F_INDIRECT_DESC - VIRTIO_TRANSPORT_F_START] = "RING_INDIRECT_DESC",
+	[VIRTIO_RING_F_EVENT_IDX - VIRTIO_TRANSPORT_F_START] = "RING_EVENT_IDX",
+	[VIRTIO_F_VERSION_1 - VIRTIO_TRANSPORT_F_START] = "VERSION_1",
+	[VIRTIO_F_ACCESS_PLATFORM - VIRTIO_TRANSPORT_F_START] = "ACCESS_PLATFORM",
+	[VIRTIO_F_RING_PACKED - VIRTIO_TRANSPORT_F_START] = "RING_PACKED",
+	[VIRTIO_F_IN_ORDER - VIRTIO_TRANSPORT_F_START] = "IN_ORDER",
+	[VIRTIO_F_ORDER_PLATFORM - VIRTIO_TRANSPORT_F_START] = "ORDER_PLATFORM",
+	[VIRTIO_F_SR_IOV - VIRTIO_TRANSPORT_F_START] = "SR_IOV",
+	[VIRTIO_F_NOTIFICATION_DATA - VIRTIO_TRANSPORT_F_START] = "NOTIFICATION_DATA",
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
+		if (i >= VIRTIO_TRANSPORT_F_START && i <= VIRTIO_TRANSPORT_F_END)
+			s = ext_feature_strs[i - VIRTIO_TRANSPORT_F_START];
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
+static void print_generic_features(struct vdpa *vdpa, uint64_t features, bool maxf)
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
+		if (i >= VIRTIO_TRANSPORT_F_START && i <= VIRTIO_TRANSPORT_F_END)
+			s = ext_feature_strs[i - VIRTIO_TRANSPORT_F_START];
+		else
+			s = NULL;
+
+		if (!s)
+			print_uint(PRINT_ANY, NULL, " bit_%d", i);
+		else
+			print_string(PRINT_ANY, NULL, " %s", s);
+	}
+	pr_out_array_end(vdpa);
+}
+
 static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
 				struct nlattr **tb)
 {
+	uint64_t classes = 0;
 	const char *class;
 	unsigned int i;
 
 	pr_out_handle_start(vdpa, tb);
 
 	if (tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]) {
-		uint64_t classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
-
+		classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
 		pr_out_array_start(vdpa, "supported_classes");
 
 		for (i = 1; i < 64; i++) {
@@ -579,9 +684,10 @@ static int cmd_dev_del(struct vdpa *vdpa,  int argc, char **argv)
 	return mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, NULL, NULL);
 }
 
-static void pr_out_dev_net_config(struct nlattr **tb)
+static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
 {
 	SPRINT_BUF(macaddr);
+	uint64_t val_u64;
 	uint16_t val_u16;
 
 	if (tb[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
@@ -610,6 +716,18 @@ static void pr_out_dev_net_config(struct nlattr **tb)
 		val_u16 = mnl_attr_get_u16(tb[VDPA_ATTR_DEV_NET_CFG_MTU]);
 		print_uint(PRINT_ANY, "mtu", "mtu %d ", val_u16);
 	}
+	if (tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]) {
+		uint16_t dev_id = 0;
+
+		if (tb[VDPA_ATTR_DEV_ID])
+			dev_id = mnl_attr_get_u32(tb[VDPA_ATTR_DEV_ID]);
+
+		val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]);
+		if (tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] && dev_id == VIRTIO_ID_NET)
+			print_net_features(vdpa, val_u64, false);
+		else
+			print_generic_features(vdpa, val_u64, true);
+	}
 }
 
 static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
@@ -619,7 +737,7 @@ static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
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

