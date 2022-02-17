Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED4C4BA02A
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 13:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiBQMa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 07:30:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240469AbiBQMa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 07:30:57 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2089.outbound.protection.outlook.com [40.107.94.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE132AE2AE
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 04:30:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3aegGs9+6tkwPuKHrsyJXJN3JGLNnrL08XIE51xYkpqU3KPAiKF5eGoeRqbc6WHd/AMdP/hVqg6wSSQx7AvGJPzYezRpFpPwOo+TZQnobzhkKbRlKutGJO+lzuzEj2+jkpJ1JEgN9Z4TWComnrlFA78hNXoLCJCdoR+hif8Lo1yeJ1EnP3O0apWlEQPfWvdnbNcTd3FoD/bjLm1/zBSoOwHMzGI14uh0E74/gW6dEperH1Q7QVxhG6iAIrLLmLM9XFJZK+TZjy8xQBnIwF7m0p9liy4j+5lvEnZ9zqey8lHPMXGiCy5g66Cl74L/TLQF7zjKGwVM6eGpCn6Nv2nhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8kPbF5jfqKpVao7jJiAEpEv2Pa2bKwfjdpeEryaWNYQ=;
 b=cYIEHVdNxr+yQvPACSdcMaPMRkcOnXn+Bl5GVYIzP2uyi3zYHyw196+QSFbwN5T8VTrGS2SAIPNjW0cpt9GVplBxpUFnQPjbfs3YTThxLhZJsbdnJIn2kQp7MJsbMkhUmvMVfdG8FBFqP5F88yng58BDWcCHjx4kHZbbr540JKIJMP/gK2gkhCwAeQGd7Uy9uBESuD5MC7ORZiCImcybL6E0cqcvj+j/kWqIZuMxTBDQtVAVU8oYCyE7OQU9k/4TzYKcTh1XdP4zgTERC6GKz4N1bRKBo1VBXy3kkNxsRQKMwArzWWpk2owVVAdWnqw9bbXSdZtBua8XAPU1etzwMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8kPbF5jfqKpVao7jJiAEpEv2Pa2bKwfjdpeEryaWNYQ=;
 b=nrw1UE3HQaCqozQVVLe0D6FV7m1wZneiRzikUJdJ5pnQVzISCDWxDHHPGnBat7pwo3S4ZDtG94f/hVbVptAqiAiBAb3c1LZ7qhz9dN3HDBwTj6zrJpbkRfaz17RnKqr5KVtc/rT6fEyZYEmNxsP6Z9gHZySSkqqrtPqgS/3bkPGI2r2psTP5Ql7uoQA4yhHnfo3SSZG8qSTXKIzKuiSA5OEBQb05IOFBXJ8vY9C91nWbytxc550WJniHNYk1B5nNpOnMqjWtxizVyM/xsmdkUUMVXEVIP4NRmnSHCx+PdVqWxYzCy1cTdVkwVQdhISbqRTpbRmEW3I2QU0SRCmfVBQ==
Received: from BN0PR04CA0203.namprd04.prod.outlook.com (2603:10b6:408:e9::28)
 by DM6PR12MB3401.namprd12.prod.outlook.com (2603:10b6:5:39::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15; Thu, 17 Feb
 2022 12:30:38 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e9:cafe::46) by BN0PR04CA0203.outlook.office365.com
 (2603:10b6:408:e9::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Thu, 17 Feb 2022 12:30:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Thu, 17 Feb 2022 12:30:36 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Feb
 2022 12:30:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 17 Feb 2022
 04:30:34 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 17 Feb
 2022 04:30:32 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>
CC:     <jasowang@redhat.com>, <lulu@redhat.com>, <si-wei.liu@oracle.com>,
        "Eli Cohen" <elic@nvidia.com>
Subject: [PATCH v2 2/4] vdpa: Allow for printing negotiated features of a device
Date:   Thu, 17 Feb 2022 14:30:22 +0200
Message-ID: <20220217123024.33201-3-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220217123024.33201-1-elic@nvidia.com>
References: <20220217123024.33201-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd12a678-c30a-4e19-618f-08d9f2114cab
X-MS-TrafficTypeDiagnostic: DM6PR12MB3401:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3401A09622DBF53FCC7D29F2AB369@DM6PR12MB3401.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yRGb3fsJann0Sreke4P2dhOLYxEkhcNwmE0aO/JHHbbbR+2gNRXeFqRYj3KekSrkzhvKISnpmJhK1N8dulcGd1cSdmFtw5JkGC7OQg5SuROdX7NcniZWgEfLEEUHwdz24rgPRjlwJGBnMXAy0ckXxxmIUnuX3RYYsXc79fYuBExb682oEewqf2PEHJoH1l1JJ+QejO+FUiwO25xABcnxn/ScH9C/3rFfKL5DgMpAsfxkdRgss1eh893RYWoP8LLfrT3I1ogzba/yJYL4YP6yre+0Y/b2L+fn9g8biGVuBJ52zq6gND+RoSFBv4WmHy92xdMQkQK3qA809JoYhpcQBATQy6UoZKm/xDFWaU0zQxaaib032edbyToeDrwEFhLAJw4Un9za2dKupZ/QYYkR/20i71Bg1JWJwCNqHLhZFYoVP5SFVCWYFqV1RkAN8V9UcUuIcHZxZgF136yY9fhn3cNiGOMh0Hhkl1db+G1Ib/M3o/DZyWho9rNRyWL1n4z/r8n4zMrsDHSktMO0RKPoxekur20ANWuYdU+CBQ6NtFRtKwBNtMmKbCl/R2SZESXFytXwbA2JyYaCyO8f78LdHoU2mc5a/OSKTVQMR0ljX2nB9S62dDBEJ8SDhjGKtavFpuyFKQTuQkLThbZ9Gh/JReSSBTogR3mqUbY+hIPbB8RDk5KA0b5aBBaEamc2n0v2uC4rIRSkPSqkG2DR0BddOw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(316002)(336012)(508600001)(2906002)(70206006)(81166007)(356005)(82310400004)(110136005)(4326008)(54906003)(5660300002)(7696005)(40460700003)(6666004)(8676002)(36860700001)(86362001)(36756003)(47076005)(8936002)(26005)(426003)(186003)(83380400001)(107886003)(70586007)(2616005)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 12:30:36.2583
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd12a678-c30a-4e19-618f-08d9f2114cab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3401
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 vdpa/include/uapi/linux/vdpa.h |   2 +
 vdpa/vdpa.c                    | 108 ++++++++++++++++++++++++++++++++-
 2 files changed, 107 insertions(+), 3 deletions(-)

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
index 4ccb564872a0..f60e647b8cf8 100644
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
@@ -395,7 +488,6 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
 
 	if (tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]) {
 		uint64_t classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
-
 		pr_out_array_start(vdpa, "supported_classes");
 
 		for (i = 1; i < 64; i++) {
@@ -579,9 +671,10 @@ static int cmd_dev_del(struct vdpa *vdpa,  int argc, char **argv)
 	return mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, NULL, NULL);
 }
 
-static void pr_out_dev_net_config(struct nlattr **tb)
+static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
 {
 	SPRINT_BUF(macaddr);
+	uint64_t val_u64;
 	uint16_t val_u16;
 
 	if (tb[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
@@ -610,6 +703,15 @@ static void pr_out_dev_net_config(struct nlattr **tb)
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
@@ -619,7 +721,7 @@ static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
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

