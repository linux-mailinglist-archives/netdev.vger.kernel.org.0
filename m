Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E834D3716
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235564AbiCIRAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236291AbiCIQ7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:59:51 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2C81AF8C9
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 08:47:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mxh6adh7CFcmHST6Hzv3uVFIkIJF00kXMT/R9WzdLczLaI4QIoAFHwHp4H0KLHKqykVVzEAgdwq6WiHTqR55vfJsFpvw0KM6Fr0CG0+PVnbT9O3enTM1xg1J935hnG3k8dLA2eRvrW+ZHIudHuHpBiZaZwpQ74bGKox8mXwgFBUhBsCNFcA+V2YVQQkV8ZJ+cuS1gdMRBbl8vBThZewBHPFJyhPId9fZQerWgAXODRxGqPzWRCVRO2AooeMaEWhycfMCuXf9kLzXzmKPvy8qDz/UwU3n+Vn5qBfTr+aFw3/5KTN9m2HglzfTP9ZuKwQM3TLs7Qn1z9h2NPNBKuZElA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RawkQa0mj6SlpfKIO3QgQxIcaj+O0L1+XWuGmmQRusM=;
 b=CHA4h4kygOBmvIeXjOpkuYmbGHQy3aA+MrJwUYp4tYNu1+oJNfWaQofir3QtHn3pqBeFOl9NYMcv0sQSxLk/Ht22NSG3wWWu0FvCCBcb28ycE5/yS7EEVVRiBJGCIAshLz3bqU4h5QhuMDsqmOpe/m0g4LtIzmMUfbJf804iOIRrDJv6j7gk7CRXOcG7zv9piFlq8T6CVy7odMBQpSMb8llo5IZoA05EIxKVtKT47mKlyfGR88iRFQXShGYulkovg30dSUiIM2urvDdelVxRV3vm+QZeu9M5Ultc2gfKq22JwhrmqJ8z9fW1HDYI6NZQ7EWOPJmzCWlSTh8a4Tqk4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RawkQa0mj6SlpfKIO3QgQxIcaj+O0L1+XWuGmmQRusM=;
 b=ImY0VyTHzdTydhq5oQRRGmTgI29i9n7d57vnrUkXCGhYhmVI7sc+NiS+UfTxCwZaijKvhvs+CtRRD/afuyX5DCB0jiuMTaP2p529vvQQFF0gYC3jImehQNT46J4BtlJy+7QJgg9hzKhebIOpb9C653Kc5+BFd1sBwVHOTwFNK5Q3UzdQgHHpnsJUM1YUd/Di5Ld/Azj5mN9drLXpg2PybgJXz+1djSafImFnBFZrVlnFbgqUc+9Ly6uDxuhcE7zA6rHojCbC/yXbpgDsAVimEopav4MN7mFSE7tCJ+LPkmL7x1egDBONvK2plo/PmyWZrDSZxj+mLCIAOz5JQBcXIg==
Received: from BN9PR03CA0230.namprd03.prod.outlook.com (2603:10b6:408:f8::25)
 by BN8PR12MB3137.namprd12.prod.outlook.com (2603:10b6:408:48::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 16:46:25 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::d4) by BN9PR03CA0230.outlook.office365.com
 (2603:10b6:408:f8::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.20 via Frontend
 Transport; Wed, 9 Mar 2022 16:46:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Wed, 9 Mar 2022 16:46:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 9 Mar
 2022 16:46:23 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 9 Mar 2022
 08:46:22 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Wed, 9 Mar
 2022 08:46:20 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>
Subject: [PATCH v5 2/4] vdpa: Allow for printing negotiated features of a device
Date:   Wed, 9 Mar 2022 18:46:07 +0200
Message-ID: <20220309164609.7233-3-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309164609.7233-1-elic@nvidia.com>
References: <20220309164609.7233-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be67e6ef-24ad-4776-723e-08da01ec59c5
X-MS-TrafficTypeDiagnostic: BN8PR12MB3137:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB31375A6C0B323BD7E527E865AB0A9@BN8PR12MB3137.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cRYJEBEpU6LDiv0xd3+6xEJw2b3XCyZ6DGm5QCt1wkUfITBFalCZuunsOJCUldqUZ5+s3GXKjzlEqU38QhbLJNytSMI8vHynDgNdKELAKJyXwJfmToekCiZI+QKDZqDe87dim/Fv9pfIfLY2d0UQ0cGjGzwrQ3wTqT+DW+4xSIy1ESaTCwaswDkQk9MiBRMt0nD9uzBM8oOoI1IsOdVCaMnxUV2oV78LktVPt2OBnD/1dF5AURTM8/aK6kZwAwgCJgfnGsqEoo5fzMdw4BM0/6REvNbvSL0KySarYSgf0VWpJeZYCShAwKtOIzmnWmyT0RB1KbpqkkbiGDvHJu+HHUlkzgpjxT+zyz8f05b3RVPTYKHWSYQAAsKT3wM/h84UWJKV8EIfQgKPrBGPBAa6z6vzh4wzlDgub7DiniLatAW8cyerrEkC3GZpaIPAfA2r3xKPh4HYgAnGCqBGqmi8WwfTnlebPUmASAGt3y3YsDy31sp+Zb+lfP5dDBKj+ysQkwdDxEgROrMhIk2vHUpOxHqKNuni27/PU5vQhKnK8Nt4NUiFgfjEVoK8cyE0t4OELPchaWa8c11zZqBePQmyK6Roqf4tyY0qMcPwKDxvvWuOY3tevnh8KVFrOlDnTHWAe6Qi+Vt15MgPa+ZXvDTuOl2gmilSIQMj/w2yqZqzMz3oUtCKT1THMIhcqwuF7e6dXqiPVMNIOdb7Cuv0gUVUgw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(82310400004)(47076005)(86362001)(4326008)(70206006)(508600001)(70586007)(26005)(36860700001)(6666004)(7696005)(83380400001)(336012)(2906002)(426003)(36756003)(5660300002)(8936002)(110136005)(40460700003)(54906003)(356005)(1076003)(107886003)(81166007)(2616005)(186003)(316002)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 16:46:25.4024
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be67e6ef-24ad-4776-723e-08da01ec59c5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3137
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 vdpa/include/uapi/linux/vdpa.h |   2 +
 vdpa/vdpa.c                    | 107 ++++++++++++++++++++++++++++++++-
 2 files changed, 107 insertions(+), 2 deletions(-)

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
index 4ccb564872a0..5f1aa91a4b96 100644
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
@@ -385,6 +388,96 @@ static const char *parse_class(int num)
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
+	for (i = 0; i < 64; i++) {
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
@@ -579,9 +672,10 @@ static int cmd_dev_del(struct vdpa *vdpa,  int argc, char **argv)
 	return mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, NULL, NULL);
 }
 
-static void pr_out_dev_net_config(struct nlattr **tb)
+static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
 {
 	SPRINT_BUF(macaddr);
+	uint64_t val_u64;
 	uint16_t val_u16;
 
 	if (tb[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
@@ -610,6 +704,15 @@ static void pr_out_dev_net_config(struct nlattr **tb)
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
@@ -619,7 +722,7 @@ static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
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

