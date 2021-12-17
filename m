Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283744785F2
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 09:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbhLQIIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 03:08:50 -0500
Received: from mail-bn8nam11on2088.outbound.protection.outlook.com ([40.107.236.88]:22145
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233543AbhLQIIt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 03:08:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cvmM+vdO29aMclVVAY9guKoaDRToqzN6STo8rxCQ8knK57FPz63cMJrSeKp4ubIp6sSXhXpvn4D10lxemKTXZU5eV/iPC7sqjhWfhMHa6yZ1IkEa/WW9v+18OeITuwtd6u7N+ad22+QlTTRN9H6T2TYOzLTqQgcjArAYl2NCUeZbW9jzotRT/WP7CPqWzRdx4uq13vIJYBrMFQp+Dc6vBTCc0HC/xVWKr8OOkic6gCz0LyqvwaHLyZTQbNUaFhXxjKiT+MPQb6oH4XlXpyQE0MLAcCJNe10zNpA7Ny6KK3ezIA+/bwqoWC07sbEDPMqrQ07RsRgoyyc6anhXQic0bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h07mXzYdi4TBMoea5nxyjBJeizkU0AsttHto9/x77eg=;
 b=Hl46BppavOHZn+h35QHxZZ1K+VPchh1VnhKwhLEDdNQhz5hrGPaCloehavNHthH2bHD2wftAE/N8O1hbl/RCvd2g2F9JvYpjJ1r5jYsj/0t/qVvmsfvvjqEXbKPif9AQb/itzW7u+/S50miAdZpNL0oaa2mILmwbst17UsAfqJltAu9kxmsO4vSvtAfibmSFnxsw9dHGN8Ry2Z4hKub7w69zTQg7YgOg2iCgWT1R83O2X9aThnNkIEh83UT/kIrHonvqxrjTbbe8z/CSkzVrUDzgl7x75lxVhWOefXaBPqyBrYmIIFvxYZ0WcMShQ8Jh+XpIAi1fLJS1Gq7YYNupdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h07mXzYdi4TBMoea5nxyjBJeizkU0AsttHto9/x77eg=;
 b=Nlia548BagKfmREj383Hvz4hebW0tYlix2jP8oGw48QLk6Podi0GvggajBzPR3RC+dIsv7tyV4VfGtZdi2Q17HARgI5R4gjauONidTQw0xfSV/C9f7F/vcOmPxziQlORYqEpevmz+UKlMAv16dUlNo/hzdm5O7jAoD/oPoq0tNzri/84pt5vhX+31mm8VOuZLRs3MIVy44hAcALf3lTIRkw5Uovvw6bxR19QQftmD5GXGaXa3dY/ASTZzy+VLjGACEjOxzdvUk0n4KeviOC/0/lMITQCKpeaIVn5CcvY2PCDt+q8j65Gk3tiaKJnb3PdeJfchv7vzzQWBODIdYE6tQ==
Received: from DM5PR13CA0039.namprd13.prod.outlook.com (2603:10b6:3:7b::25) by
 BYAPR12MB3638.namprd12.prod.outlook.com (2603:10b6:a03:dc::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.14; Fri, 17 Dec 2021 08:08:46 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:7b:cafe::58) by DM5PR13CA0039.outlook.office365.com
 (2603:10b6:3:7b::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.8 via Frontend
 Transport; Fri, 17 Dec 2021 08:08:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Fri, 17 Dec 2021 08:08:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 17 Dec
 2021 08:08:45 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Fri, 17 Dec 2021 00:08:42 -0800
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     <virtualization@lists.linux-foundation.org>, <mst@redhat.com>,
        <jasowang@redhat.com>, Parav Pandit <parav@nvidia.com>
Subject: [iproute2-next v2 3/4] vdpa: Enable user to set mac address of vdpa device
Date:   Fri, 17 Dec 2021 10:08:26 +0200
Message-ID: <20211217080827.266799-4-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211217080827.266799-1-parav@nvidia.com>
References: <20211217080827.266799-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a681cf2-0a7a-45f2-3e07-08d9c134731d
X-MS-TrafficTypeDiagnostic: BYAPR12MB3638:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB363897EC3DAF3DD666411F64DC789@BYAPR12MB3638.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9JzEVstuTuCBxAwYun6XU0ilfLrTOBhtOR554RpET6L0RHBMimfn23D5WPLeeTFTI7VAW0CUXc6CL62/6+hgZ0284Lc9EZW2Z1lNf8225MwScENCeBF1imb9LNN3YEgsKdXVcoi7zWreT0Za+Q0k598d3jvdFukNdZnSHPOIYUGIBHwopTRsUq2kKLm8FM9ymAcq50NoZOwEHqBd3RT7ijd+BKZMsot0oe4qY0Hl2UC5ymm4jqmcSKIAjzeXtj0jkkxol3GRfqedm0R4+EJU62TV4nKizzRdbB16QX7kt1wnNuUeIboVUkK29EmnwC3k7lhowLEK2VCWnLL6WKSYpC2j92YLCZ1rjwZ08bvHJ9Bt80ear9ZEb5yD66QokNCOOICmLMkQiJM1xJCFa0kiVvH8l8eh0iUJJRoPoDddv2LTTRcH1sDeErfrDv0Ojfo6Fu5AIx7wXlHo0LuSIdXVDMM3BvytWTqiqC4/FUr1BdXWUQFT5qYIwS2W5460JEk5JGJuAfgijg5vh+BDdkYcugT/gwB89Jmb7sSHOd5mWhxA5HhcaBPPfsOKKuI/7Unw/WmfQk6oGh07IU5LctKgU4EiARN/egx4gOW7OqZowBTxrIBuC9C+l1sq/i9IzyiXNNB7ivshJP344SBXdo4OM/nS9+tUQHDBn84f/9JpWZ98oltj+nVp3S5IUpf5cP4rDAZGR1FU/BaaQvhvcZGa3z9D3Uk+1JUb+p8TeydQ/PhFNe4YKT/CftzbNMn9f4rLYNe60me+b+dbyGLnNZRwXxGanvCfZnvSz3BvGjmC8BQIq8t1yoL+wnpYH7vreZJ+TW963FWGcRXM3kSqdZtR0w==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(70206006)(2906002)(36756003)(82310400004)(186003)(316002)(16526019)(86362001)(426003)(83380400001)(6666004)(336012)(26005)(1076003)(5660300002)(36860700001)(34020700004)(4326008)(8936002)(54906003)(81166007)(70586007)(110136005)(40460700001)(47076005)(356005)(2616005)(107886003)(8676002)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 08:08:46.2142
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a681cf2-0a7a-45f2-3e07-08d9c134731d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3638
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vdpa: Enable user to set mtu of the vdpa device

Implement mtu setting for vdpa device.

$ vdpa mgmtdev show
vdpasim_net:
  supported_classes net

Add the device with specified mac address:
$ vdpa dev add name bar mgmtdev vdpasim_net mac 00:11:22:33:44:55

View the config after setting:
$ vdpa dev config show
bar: mac 00:11:22:33:44:55 link up link_announce false mtu 1500

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
changelog:
v1->v2:
 - use strcmp() instead of matches()
 - added man page
---
 man/man8/vdpa-dev.8 | 11 ++++++++++
 vdpa/vdpa.c         | 52 ++++++++++++++++++++++++++++++++++++---------
 2 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/man/man8/vdpa-dev.8 b/man/man8/vdpa-dev.8
index 5d3a3f26..5c5ac469 100644
--- a/man/man8/vdpa-dev.8
+++ b/man/man8/vdpa-dev.8
@@ -31,6 +31,7 @@ vdpa-dev \- vdpa device configuration
 .I NAME
 .B mgmtdev
 .I MGMTDEV
+.RI "[ mac " MACADDR " ]"
 
 .ti -8
 .B vdpa dev del
@@ -63,6 +64,11 @@ Name of the new vdpa device to add.
 .BI mgmtdev " MGMTDEV"
 Name of the management device to use for device addition.
 
+.PP
+.BI mac " MACADDR"
+- specifies the mac address for the new vdpa device.
+This is applicable only for the network type of vdpa device. This is optional.
+
 .SS vdpa dev del - Delete the vdpa device.
 
 .PP
@@ -98,6 +104,11 @@ vdpa dev add name foo mgmtdev vdpa_sim_net
 Add the vdpa device named foo on the management device vdpa_sim_net.
 .RE
 .PP
+vdpa dev add name foo mgmtdev vdpa_sim_net mac 00:11:22:33:44:55
+.RS 4
+Add the vdpa device named foo on the management device vdpa_sim_net with mac address of 00:11:22:33:44:55.
+.RE
+.PP
 vdpa dev del foo
 .RS 4
 Delete the vdpa device named foo which was previously created.
diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index ba704254..63d464d1 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -4,6 +4,7 @@
 #include <getopt.h>
 #include <errno.h>
 #include <linux/genetlink.h>
+#include <linux/if_ether.h>
 #include <linux/vdpa.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_net.h>
@@ -20,6 +21,7 @@
 #define VDPA_OPT_VDEV_MGMTDEV_HANDLE	BIT(1)
 #define VDPA_OPT_VDEV_NAME		BIT(2)
 #define VDPA_OPT_VDEV_HANDLE		BIT(3)
+#define VDPA_OPT_VDEV_MAC		BIT(4)
 
 struct vdpa_opts {
 	uint64_t present; /* flags of present items */
@@ -27,6 +29,7 @@ struct vdpa_opts {
 	char *mdev_name;
 	const char *vdev_name;
 	unsigned int device_id;
+	char mac[ETH_ALEN];
 };
 
 struct vdpa {
@@ -136,6 +139,21 @@ static int vdpa_argv_str(struct vdpa *vdpa, int argc, char **argv,
 	return 0;
 }
 
+static int vdpa_argv_mac(struct vdpa *vdpa, int argc, char **argv, char *mac)
+{
+	int alen;
+
+	if (argc <= 0 || *argv == NULL) {
+		fprintf(stderr, "String parameter expected\n");
+		return -EINVAL;
+	}
+
+	alen = ll_addr_a2n(mac, ETH_ALEN, *argv);
+	if (alen < 0)
+		return -EINVAL;
+	return 0;
+}
+
 struct vdpa_args_metadata {
 	uint64_t o_flag;
 	const char *err_msg;
@@ -183,13 +201,16 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
 	if ((opts->present & VDPA_OPT_VDEV_NAME) ||
 	    (opts->present & VDPA_OPT_VDEV_HANDLE))
 		mnl_attr_put_strz(nlh, VDPA_ATTR_DEV_NAME, opts->vdev_name);
+	if (opts->present & VDPA_OPT_VDEV_MAC)
+		mnl_attr_put(nlh, VDPA_ATTR_DEV_NET_CFG_MACADDR,
+			     sizeof(opts->mac), opts->mac);
 }
 
 static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
-			   uint64_t o_required)
+			   uint64_t o_required, uint64_t o_optional)
 {
+	uint64_t o_all = o_required | o_optional;
 	struct vdpa_opts *opts = &vdpa->opts;
-	uint64_t o_all = o_required;
 	uint64_t o_found = 0;
 	int err;
 
@@ -233,6 +254,15 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
 
 			NEXT_ARG_FWD();
 			o_found |= VDPA_OPT_VDEV_MGMTDEV_HANDLE;
+		} else if ((strcmp(*argv, "mac") == 0) &&
+			   (o_all & VDPA_OPT_VDEV_MAC)) {
+			NEXT_ARG_FWD();
+			err = vdpa_argv_mac(vdpa, argc, argv, opts->mac);
+			if (err)
+				return err;
+
+			NEXT_ARG_FWD();
+			o_found |= VDPA_OPT_VDEV_MAC;
 		} else {
 			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
 			return -EINVAL;
@@ -246,11 +276,11 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
 
 static int vdpa_argv_parse_put(struct nlmsghdr *nlh, struct vdpa *vdpa,
 			       int argc, char **argv,
-			       uint64_t o_required)
+			       uint64_t o_required, uint64_t o_optional)
 {
 	int err;
 
-	err = vdpa_argv_parse(vdpa, argc, argv, o_required);
+	err = vdpa_argv_parse(vdpa, argc, argv, o_required, o_optional);
 	if (err)
 		return err;
 	vdpa_opts_put(nlh, vdpa);
@@ -386,7 +416,7 @@ static int cmd_mgmtdev_show(struct vdpa *vdpa, int argc, char **argv)
 					  flags);
 	if (argc > 0) {
 		err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
-					  VDPA_OPT_MGMTDEV_HANDLE);
+					  VDPA_OPT_MGMTDEV_HANDLE, 0);
 		if (err)
 			return err;
 	}
@@ -413,7 +443,7 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int argc, char **argv)
 static void cmd_dev_help(void)
 {
 	fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
-	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV\n");
+	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ]\n");
 	fprintf(stderr, "       vdpa dev del DEV\n");
 	fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
 }
@@ -483,7 +513,7 @@ static int cmd_dev_show(struct vdpa *vdpa, int argc, char **argv)
 	nlh = mnlu_gen_socket_cmd_prepare(&vdpa->nlg, VDPA_CMD_DEV_GET, flags);
 	if (argc > 0) {
 		err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
-					  VDPA_OPT_VDEV_HANDLE);
+					  VDPA_OPT_VDEV_HANDLE, 0);
 		if (err)
 			return err;
 	}
@@ -502,7 +532,8 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
 	nlh = mnlu_gen_socket_cmd_prepare(&vdpa->nlg, VDPA_CMD_DEV_NEW,
 					  NLM_F_REQUEST | NLM_F_ACK);
 	err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
-				  VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME);
+				  VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
+				  VDPA_OPT_VDEV_MAC);
 	if (err)
 		return err;
 
@@ -516,7 +547,8 @@ static int cmd_dev_del(struct vdpa *vdpa,  int argc, char **argv)
 
 	nlh = mnlu_gen_socket_cmd_prepare(&vdpa->nlg, VDPA_CMD_DEV_DEL,
 					  NLM_F_REQUEST | NLM_F_ACK);
-	err = vdpa_argv_parse_put(nlh, vdpa, argc, argv, VDPA_OPT_VDEV_HANDLE);
+	err = vdpa_argv_parse_put(nlh, vdpa, argc, argv, VDPA_OPT_VDEV_HANDLE,
+				  0);
 	if (err)
 		return err;
 
@@ -597,7 +629,7 @@ static int cmd_dev_config_show(struct vdpa *vdpa, int argc, char **argv)
 					  flags);
 	if (argc > 0) {
 		err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
-					  VDPA_OPT_VDEV_HANDLE);
+					  VDPA_OPT_VDEV_HANDLE, 0);
 		if (err)
 			return err;
 	}
-- 
2.26.2

