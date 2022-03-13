Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6FE94D754B
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 13:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbiCMMr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 08:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbiCMMry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 08:47:54 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F213EA9E
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 05:46:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MtYeA3Ode9qZfEvFxrraSfDc5o/GFsgh2ACTzJsX0m4o98CKMzOL5Y/y45F7aS5rj+vOooqnokIykmejX+TV5HkVBQItaTQvD4iMA+1YbdsU4dOYSwBsaQD6ouH8DS+jG5b3Dcc6R9Xs/UlHOI5BA1LohGBxzt8ySAfj4DUbPkE8fM1oqNCUWHNie9pzlP4PW4n3L0L4NiVwwady59Cy7JU1xbwXf7hTgSfn6VBBI7ObnkOWLS+8Ds7pD3ba04GTiV8OvUwxVxZQQmXEP26jdhn+nhwVl5m/8MBkYjpGc1zJLq5Qq7fjmQTzaVgohM7qui2DCNsNFyLclcW2bo4MJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eoHVRnVrmRF9NNmaH/TNIoWNfCD7fURCK5nE4o9Hflk=;
 b=GNr8OPHV/vBs4PUUeDP6PEX7PqKXJboVnwHoMqxI3F9ggqAWVwe+utA78GFDh4fBvilmYFmeGBoZsk0IvTmhfQpA+cjawdVdCPwNnap8m8tIz0gqKyNXSAXLS8yHvZs8WuciZWJ7Yu+51Bo16eLkX4DxKH1hCxZDKp/olDbSvkmB2qVzcl6WteHA32w3I/Ty63YyUzS93P54THfcPvaXlqDcy/fs3UUMAovTIuFA1uvAEFUfPFBmU8dvt4Doj25wTmeEcinN5mPrs61+kYfEhIj53KC/BknbgasW+1RSq/4thHbBz7u9Hv1edBVi/x1hwup8atJSo7vmlg43qNtmRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eoHVRnVrmRF9NNmaH/TNIoWNfCD7fURCK5nE4o9Hflk=;
 b=i77p0Tir61U26q6PLNTD5Xxs3PhKFY/xcTQK3vZgLPwCnNLOgQ3pt4srtz3nJU75t+1r8AtBuwjxCWgJFN4NkggB/yzpydbpY3Trw4JkOigfwle+QAsl/3k+IYn3EFGF/P0/GuWYhBwBMWHzuKZ11iAqljMuzuATZWN3JEUBfgUuuG0goGRuauBv0iyBgqmoPqu5C3WFbAMqNfaDQQvIB4vm3H545rriD6Nmy5ttmZwhPG2UEbl6653j0T9NfSFDxBdQjOnLPwFBNefmIrOiM7icIzmVJu5NT4md8vYQ6xblDIXsQu38C2hzzqyi6O1te7a9juyIFXavHJ2L7mAt9A==
Received: from MW4PR04CA0369.namprd04.prod.outlook.com (2603:10b6:303:81::14)
 by BN6PR1201MB0052.namprd12.prod.outlook.com (2603:10b6:405:53::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Sun, 13 Mar
 2022 12:46:44 +0000
Received: from CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::39) by MW4PR04CA0369.outlook.office365.com
 (2603:10b6:303:81::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.20 via Frontend
 Transport; Sun, 13 Mar 2022 12:46:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT022.mail.protection.outlook.com (10.13.175.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Sun, 13 Mar 2022 12:46:43 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 13 Mar
 2022 12:46:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 13 Mar
 2022 05:46:41 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Sun, 13 Mar
 2022 05:46:39 -0700
From:   Eli Cohen <elic@nvidia.com>
To:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>
Subject: [PATCH v6 2/4] vdpa: Allow for printing negotiated features of a device
Date:   Sun, 13 Mar 2022 14:46:27 +0200
Message-ID: <20220313124629.297014-3-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220313124629.297014-1-elic@nvidia.com>
References: <20220313124629.297014-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8416b510-1100-4881-13b7-08da04ef8759
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0052:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB005247630B291B4A3FE382E4AB0E9@BN6PR1201MB0052.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dpezrH/hsBhbbN4fYkt0JnoovnXqMdmxaZ7CRHe1EB7iTHOJ92qtcdRNA0JH2ME6MF9YffD16U6GKj3A3sOhFm12jwypyQDYkAqY/q5TbnFPWf+ddNLJeqwppVQisJImVpft7qDGJiP0+lveLJH8zsfQmKQfFOnR7HH4CHpbbmteBTP4qCjmbf1SZhuRV0qhnVhlESzoRf8i7W3hNT7oU52Z9n9lhHSrY1KI1vKVLMgaB0THanLWAlwh6Q4E5MVYzF9Y3GvRwHlxbBMYqJnHyO8/1kQGZtEpAzl6grQPX/mh2dRCnX01NAQ7RQl+ZbucYnryzWIAMpOwrsMLE8lrRlc2WiUyxCgTdQS72NH2ynfdqN4blsxLw0G4c1xvWrrg8x74/+60ksIoFm7iwq6gPk/z/LQqtMKqXOZR1vp4Dw6c2/hLwEFuSSKx2JMMHJXPBQErOZphyYUdJDLhnYUvbsvPF8q3/+IH7BCoJDVP0Nb37i7kCU7Vmx3lyoPeLAyeCONQp5qBaO4+lFLm363LPgpge+q2JST4QfkBDEuzREkr9jwA2tlly/Dv0O4dUmUxP0c2ffO9p/1HtlFZPDEMAyscsR9LuTuYWfdv4GzL1xY7Piztz4sDv/vAkKakXFPz5Y52HFyAHD+os/pZFFdgLWsevyQHTZ1KfbJ0lecLsrQgGVsHy7MhZOvnXq1b0PLmaU5I2SRiulT38m3Ol3ZHfA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(83380400001)(5660300002)(107886003)(2906002)(8936002)(4326008)(426003)(336012)(186003)(26005)(508600001)(7696005)(2616005)(47076005)(36860700001)(1076003)(6666004)(36756003)(82310400004)(40460700003)(81166007)(356005)(86362001)(70206006)(54906003)(316002)(110136005)(70586007)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2022 12:46:43.9865
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8416b510-1100-4881-13b7-08da04ef8759
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0052
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
1. Standard presentation
$ vdpa dev config show vdpa-a
vdpa-a: mac 00:00:00:00:88:88 link up link_announce false max_vq_pairs 2 mtu 9000
  negotiated_features CSUM GUEST_CSUM MTU MAC HOST_TSO4 HOST_TSO6 STATUS \
CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM

2. json output
$ vdpa -j dev config show vdpa-a
{"config":{"vdpa-a":{"mac":"00:00:00:00:88:88","link":"up","link_announce":false,\
"max_vq_pairs":2,"mtu":9000,"negotiated_features":["CSUM","GUEST_CSUM",\
"MTU","MAC","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ","MQ","CTRL_MAC_ADDR",\
"VERSION_1","ACCESS_PLATFORM"]}}}

3. Pretty json
$ vdpa -jp dev config show vdpa-a
{
    "config": {
        "vdpa-a": {
            "mac": "00:00:00:00:88:88",
            "link ": "up",
            "link_announce ": false,
            "max_vq_pairs": 2,
            "mtu": 9000,
            "negotiated_features": [
"CSUM","GUEST_CSUM","MTU","MAC","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ",\
"MQ","CTRL_MAC_ADDR","VERSION_1","ACCESS_PLATFORM" ]
        }
    }
}

Reviewed-by: Si-Wei Liu<si-wei.liu@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 vdpa/vdpa.c | 109 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 107 insertions(+), 2 deletions(-)

diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index 4ccb564872a0..7cc370e34118 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -10,6 +10,8 @@
 #include <linux/virtio_net.h>
 #include <linux/netlink.h>
 #include <libmnl/libmnl.h>
+#include <linux/virtio_ring.h>
+#include <linux/virtio_config.h>
 #include "mnl_utils.h"
 #include <rt_names.h>
 
@@ -78,6 +80,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
 	[VDPA_ATTR_DEV_VENDOR_ID] = MNL_TYPE_U32,
 	[VDPA_ATTR_DEV_MAX_VQS] = MNL_TYPE_U32,
 	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
+	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
 };
 
 static int attr_cb(const struct nlattr *attr, void *data)
@@ -385,6 +388,98 @@ static const char *parse_class(int num)
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
+static const char * const *dev_to_feature_str[] = {
+	[VIRTIO_ID_NET] = net_feature_strs,
+};
+
+#define NUM_FEATURE_BITS 64
+
+static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
+			   uint16_t dev_id)
+{
+	const char * const *feature_strs = NULL;
+	const char *s;
+	int i;
+
+	if (dev_id < ARRAY_SIZE(dev_to_feature_str))
+		feature_strs = dev_to_feature_str[dev_id];
+
+	if (mgmtdevf)
+		pr_out_array_start(vdpa, "dev_features");
+	else
+		pr_out_array_start(vdpa, "negotiated_features");
+
+	for (i = 0; i < NUM_FEATURE_BITS; i++) {
+		if (!(features & (1ULL << i)))
+			continue;
+
+		if (i < VIRTIO_TRANSPORT_F_START || i > VIRTIO_TRANSPORT_F_END) {
+			if (feature_strs) {
+				s = feature_strs[i];
+			} else {
+				s = NULL;
+			}
+		} else {
+			s = ext_feature_strs[i - VIRTIO_TRANSPORT_F_START];
+		}
+		if (!s)
+			print_uint(PRINT_ANY, NULL, " bit_%d", i);
+		else
+			print_string(PRINT_ANY, NULL, " %s", s);
+	}
+
+	pr_out_array_end(vdpa);
+}
+
 static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
 				struct nlattr **tb)
 {
@@ -579,9 +674,10 @@ static int cmd_dev_del(struct vdpa *vdpa,  int argc, char **argv)
 	return mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, NULL, NULL);
 }
 
-static void pr_out_dev_net_config(struct nlattr **tb)
+static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
 {
 	SPRINT_BUF(macaddr);
+	uint64_t val_u64;
 	uint16_t val_u16;
 
 	if (tb[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
@@ -610,6 +706,15 @@ static void pr_out_dev_net_config(struct nlattr **tb)
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
+		print_features(vdpa, val_u64, false, dev_id);
+	}
 }
 
 static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
@@ -619,7 +724,7 @@ static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
 	pr_out_vdev_handle_start(vdpa, tb);
 	switch (device_id) {
 	case VIRTIO_ID_NET:
-		pr_out_dev_net_config(tb);
+		pr_out_dev_net_config(vdpa, tb);
 		break;
 	default:
 		break;
-- 
2.35.1

