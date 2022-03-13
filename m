Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FA44D7733
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 18:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbiCMRNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 13:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbiCMRNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 13:13:42 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F77139CDA
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 10:12:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+YSAb/i3o0unBieHSVMmrl0UC4/ZTV6uNrs70k8vJ/aAJmRL3IQPv2uXeMxjrRXlmYmQfWT7kHp7VUrYnEUN45tdnk9EBVwd/N+Hqz49RQR1GQ2l1S0+Yot8msSp2yUugY3dDWah97OgtW3zSywG7q9nRwHDeDFAhzjSAVOjI7TdK23dF8TxVjNGlLrH9IdvzEuQLvPYX2rGlggNd7aYSMVG83T/jLnLE6WxD56xv8DNerei9hCxWxPUgoEx8aosQOH0lFbHPSXE2YxlJrN03sJ+zGHoPJyt+9CeQJEUy7tfypVNp/M+fHrvk2s+pkx75LngAqz5rp0ib9dmOZmtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r3Neu58XsZ+YhVtEuA3u8lNWKxPs1SXabBC1SbBqE4Y=;
 b=Vdm/ZZy4DAD3KvXMajg7oVWUxqDYupI4+N+9lt0bKP1COMqVnqXs9scao6uKwJSXZ+14bRI52vBQiw3BzOoc7pKj1gGRj78Q8WKpIynw09Ln07JCEIPNZQ7IfQLRIwSp+ApU/aFyV1RmWjmiwDG18VVHDnmZBUJT3Zi05z6BhkUALfQuEER8CiOwEEAYe7b+5ziJDwvCfdrhvF+Lqn9C21SRL+1Cjgh4r+Xn5EbbPceB1yvR53IeTp8l0BTeRLTl367K0zPj0uQ6mDOFnBus/n1K640+eC+3QLNYKjxb+craV0zXi3y+KbKXurzvC7T/CWvSgKuol0hSuQy5RSHzAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r3Neu58XsZ+YhVtEuA3u8lNWKxPs1SXabBC1SbBqE4Y=;
 b=Umn7rzjlfOQydWaJeGi3+3m7WOyBioYGn9U0afxWrxYaXqqAySOB/QIiTUz7pekQCSnAA9NRTvtQVSGRvg2wrtg9K0G8E4gADxDB5VUJW9kl75AURHmJEsDn7ChItwOZZy/H9rcmO6hcEoSzxA7Q8ZSyn5lTEFEZ/frHJyCu0XM+DxjavmDDZohFWG2aGTVlTSXNZ/C8uw/AbUPIhuktsTHznRYKQnrQ4d7ktt3STWww5H6rSjdLSge8U0Xo4VBbgiCLBeZB/qGHQGlg4jTntr0+OQIzQ+kt2EuqWFuxNOnCHajK/4RuZa6uVqykWx4aUlKDhPmStuDdZi8pmLVV2A==
Received: from DM5PR13CA0019.namprd13.prod.outlook.com (2603:10b6:3:23::29) by
 BN6PR12MB1441.namprd12.prod.outlook.com (2603:10b6:405:11::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5061.25; Sun, 13 Mar 2022 17:12:32 +0000
Received: from DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:23:cafe::4f) by DM5PR13CA0019.outlook.office365.com
 (2603:10b6:3:23::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.7 via Frontend
 Transport; Sun, 13 Mar 2022 17:12:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT031.mail.protection.outlook.com (10.13.172.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Sun, 13 Mar 2022 17:12:32 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 13 Mar
 2022 17:12:31 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 13 Mar
 2022 10:12:31 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Sun, 13 Mar
 2022 10:12:28 -0700
From:   Eli Cohen <elic@nvidia.com>
To:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>
Subject: [PATCH v7 2/4] vdpa: Allow for printing negotiated features of a device
Date:   Sun, 13 Mar 2022 19:12:17 +0200
Message-ID: <20220313171219.305089-3-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220313171219.305089-1-elic@nvidia.com>
References: <20220313171219.305089-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3eb5e9cb-4019-4e95-b28b-08da0514a952
X-MS-TrafficTypeDiagnostic: BN6PR12MB1441:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB14417E8404DD9D0D4ED1E98FAB0E9@BN6PR12MB1441.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j41IPNqnTCVwA5hPMC9NtFmihPNJqk++02d4xw8ZRG68Oow1BOhVnud2FdHpug2+L9LqODJMnVwJ5i43i8ZsrxEdBo5Ukh81/9nNy87nAupo4UvQAwr9RWdjR+A97EOX2z0HVmoFCZY0DMAH/ZmhlRpyxYKAOyIdxdBB83Ba2NIgKo01JTf37Gb41q0Pr1GBSaHkhgCB+BL7Nin9rLjvpaXVpKN4DdtPPuzl92zyX1YreUqQkgEou53BqeYRytu3kkdj3yp6c+om02cIwmBWiwN9c2itnh9jokVgwJnWGXmrzc+zK1bA1ZoWPCnIPX93GM134N4VQpvzgJy+ecVtqF6oqOZLAJPkEvV48shCO0a0e5j6Ff9WfOCgLuHM5v8I2zeK1nLqPdDZHgKNaO25O+iE3vb42p8kvu/n+qALBF2zdzlBzMViJP/vvU11UrbPJiNgszEx1LQtBrdUDelcGE/YGntQiUliSf0Fsm38VTbLsB6n5G9VPPKlH/GiX81j9vdQ7FnozCkyQWRJFtp6iMMa35qvQwdm4bcASMOkBfUd91pjsPrARL9hW5RCrc7FXq6haRlHFS94lSunmnY1UJikwhSlyQonkExtjm+i/VNVFOsL8fc/u903f5eQBBEg9WC3YgdBPs2eMH5xMkSZYXcnjHq6N5eXSwJhqP8WX5ZShY/axCERiogxP3u5EmKszoo26nOP2Xs8fJwizEs2Sg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(8936002)(2906002)(36860700001)(5660300002)(82310400004)(356005)(81166007)(40460700003)(70206006)(6666004)(508600001)(70586007)(186003)(7696005)(86362001)(316002)(36756003)(54906003)(4326008)(110136005)(107886003)(47076005)(8676002)(83380400001)(26005)(336012)(426003)(1076003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2022 17:12:32.3506
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eb5e9cb-4019-4e95-b28b-08da0514a952
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1441
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
 vdpa/vdpa.c | 108 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 106 insertions(+), 2 deletions(-)

diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index 4ccb564872a0..f7b6e5f8a0bc 100644
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
@@ -385,6 +388,97 @@ static const char *parse_class(int num)
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
+			if (feature_strs)
+				s = feature_strs[i];
+			else
+				s = NULL;
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
@@ -579,9 +673,10 @@ static int cmd_dev_del(struct vdpa *vdpa,  int argc, char **argv)
 	return mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, NULL, NULL);
 }
 
-static void pr_out_dev_net_config(struct nlattr **tb)
+static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
 {
 	SPRINT_BUF(macaddr);
+	uint64_t val_u64;
 	uint16_t val_u16;
 
 	if (tb[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
@@ -610,6 +705,15 @@ static void pr_out_dev_net_config(struct nlattr **tb)
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
@@ -619,7 +723,7 @@ static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
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

