Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2ECF4785F1
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 09:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbhLQIIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 03:08:48 -0500
Received: from mail-dm6nam12on2074.outbound.protection.outlook.com ([40.107.243.74]:12672
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233543AbhLQIIr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 03:08:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0yhhegD6pNhFh0LfzFVV6KCVFQ7zxeHu0PvvF2jOvE2OZFkCd8c6uSDxrqZOcqeL+qtzLvlSX48RXU0LgnwO0gfy6/lpV4E0DsgAVyAJlYBGQGIXk7XYBm5sqXUpaYU+usmb9XFQJhLx/ViaapRUk1+E+XkE3FN4W2tbuhq5rUM7amEs+pGMDFGq+S7RkJ7ckkaA8vEugHA4braE2P0SHUSs4TQyLoi2f9emY7CSb12FwVvxmIe0UKt7bbRj4LfVuA/4jwN0Bg39TOWWPDeJFyb3R4ykiZPyI4LBMFTPQoZQxAdke0UflvhGngXX7hoZ1Kzz1mUF/r//Avs8UMwsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f0KZufUdK2sovcS1Zm6o1rRDABipt2NsDh5b+7TYjXg=;
 b=YrM4TiVylaeK4ieA2FsO168dyeVYY/sebRYZ0QTuPTHMfjvRIfGjQb9dYEVm9BNjwkgL/NflHEN+s3IHPrx7JnBJJIs73npJRvr6wG5wvv1H9NU2bhQDx0kgXJmB2sOdAirmV8uwj+LLzVwvbjYb+3JaNGAuLt+22mkaIRneV0uoDwOn2V0sLyIckVx8vaeT1nzg2ah0Ekq6ZkBW/kSXCfhluPL9ACegOzhkULSlfcHkVPOljWy2htJcjFQsE3Ia8hc4nu8ahbvL2g8mI7VUGtJCaeMvvl//tlaPJ6yaac/i1N1BjifmwZlELX/qrMwHWn20Dwlj/UOGQlulTpKypg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0KZufUdK2sovcS1Zm6o1rRDABipt2NsDh5b+7TYjXg=;
 b=aasPyhfaSFiz9H6Hq6CrrFIqt8+Gj9r1QmE+Ko+gSCYzm5rBVNU5Yqw+JN0YPaNham8tCBhoUUOz/0s78m5wQrsjslMqxnKEpFUftJoqs+oLD9Ylgj0KoppRB485kMvjXoOAvDrWDAhDVlREaHkmfL/5JBCl2fTt0AjfKGuN6Kn1TpqCSYgfxiWth4zmTr1GxhqOJNO/j9G3Vxm33DecAYIVbHDEmluieNPqo+Sm7t6aNKU3AviQ6YRhk27UejZWQokFqxDOrgv2joP/NKPQfTfkQVL9R+Fas5NT7yu9hXeQQXqFi8K32+Vx+Pd7YwEUHrppZo8zy0g9/2HHDMUuow==
Received: from DM5PR13CA0037.namprd13.prod.outlook.com (2603:10b6:3:7b::23) by
 BN8PR12MB3635.namprd12.prod.outlook.com (2603:10b6:408:46::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.17; Fri, 17 Dec 2021 08:08:45 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:7b:cafe::51) by DM5PR13CA0037.outlook.office365.com
 (2603:10b6:3:7b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.7 via Frontend
 Transport; Fri, 17 Dec 2021 08:08:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Fri, 17 Dec 2021 08:08:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 17 Dec
 2021 08:08:44 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Fri, 17 Dec 2021 00:08:41 -0800
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     <virtualization@lists.linux-foundation.org>, <mst@redhat.com>,
        <jasowang@redhat.com>, Parav Pandit <parav@nvidia.com>
Subject: [iproute2-next v2 2/4] vdpa: Enable user to query vdpa device config layout
Date:   Fri, 17 Dec 2021 10:08:25 +0200
Message-ID: <20211217080827.266799-3-parav@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 01cecd92-1e0b-47b9-91ca-08d9c13472ce
X-MS-TrafficTypeDiagnostic: BN8PR12MB3635:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3635E3FB624CF00D9F1251E8DC789@BN8PR12MB3635.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:483;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b4y29tRwCwaVF3MEuLy0Vkvzmb+B912ijzE4izoyjJ8m/E/I1oagnJWL+sygEMCwVe8QPf3bZHBpt6XY4abhuFyeQ+J7CQPiE0SGcWelNEsk+t+yt4yxmCKbZB8upkBzrZh1Nb7lW6EVe7hzm711NLy//OjtaiT9SM9ZW6b/CUsTeH+rKrm88TjblnBJAYZy+Iqin+h+xx4gbikTZ78xgZPcgGx2DQttVHZAjgViz1Z3lTSB2ZLLuG4oC7y8nhMqRFLTeMHMMN+rrP5nC2uYxbGS++8XnOCsL6MF6VXmzZdK/MJSh8sZjkuX2iVBRKuHVl7Aq2ByQdEPkC/NlUjplh2Z20gaCi/NIRcENc/KZ7qaAUIAgnTrrh0betgvFN+ZT4GCX+UCduvGSTqFF05zCnV7aGSY6s3AvwrO+8VzH37Smc3KislKQBuQlsVp8atO70IMqO5ibjJ4kUJ8t4+uX5RWaMVXnbuClOgXnTr+dsvun8BnQ7lOOFVR6Eg8LkKNH3eHj9AxqfrNIUiKmB+p5YBnjguOZkETHgnBWf4/qvmyQJA73aPIWZfyANcVQyd3n4vCExnBlOYgmDSUrX2QJxbB/PJ2N/IywxXXgzIgn4b8+h0o8B18mhxunG/pIqlNNp2JZiBCp+ricpS3CazFhyMy7RtmZH9splU8eleb8hGz4LBhNamaLFkmIEo8cYc2fhbKw450C+unzMjHxYGl4KIV/+svZzqBwxhpC5KGYlbuk9BhlpiLV3ckiX349Gp7AGXRYC24A0HrSyljCb1uQzVMlxMgWl97a6INjzIqz42NLAJLGcksegGTsQ6NB2plyJIEOQuMpCTjqkIZeFR/vg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(336012)(81166007)(8676002)(5660300002)(186003)(2906002)(426003)(82310400004)(316002)(2616005)(16526019)(36756003)(107886003)(47076005)(40460700001)(26005)(70206006)(34020700004)(6666004)(8936002)(4326008)(1076003)(54906003)(110136005)(70586007)(356005)(86362001)(36860700001)(508600001)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 08:08:45.6986
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01cecd92-1e0b-47b9-91ca-08d9c13472ce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3635
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Query the device configuration layout whenever kernel supports it.

An example of configuration layout of vdpa device of type network:

$ vdpa dev add name bar mgmtdev vdpasim_net

$ vdpa dev config show
bar: mac 00:35:09:19:48:05 link up link_announce false mtu 1500

$ vdpa dev config show -jp
{
    "config": {
        "bar": {
            "mac": "00:35:09:19:48:05",
            "link ": "up",
            "link_announce ": false,
            "mtu": 1500,
        }
    }
}

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
changelog:
v1->v2:
 - added man page
---
 man/man8/vdpa-dev.8 |  21 +++++++++
 vdpa/vdpa.c         | 110 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 131 insertions(+)

diff --git a/man/man8/vdpa-dev.8 b/man/man8/vdpa-dev.8
index 36433519..5d3a3f26 100644
--- a/man/man8/vdpa-dev.8
+++ b/man/man8/vdpa-dev.8
@@ -36,6 +36,10 @@ vdpa-dev \- vdpa device configuration
 .B vdpa dev del
 .I DEV
 
+.ti -8
+.B vdpa dev config show
+.RI "[ " DEV " ]"
+
 .SH "DESCRIPTION"
 .SS vdpa dev show - display vdpa device attributes
 
@@ -65,6 +69,18 @@ Name of the management device to use for device addition.
 .I "DEV"
 - specifies the vdpa device to delete.
 
+.SS vdpa dev config show - Show configuration of specific device or all devices.
+
+.PP
+.I "DEV"
+- specifies the vdpa device to show its configuration.
+If this argument is omitted all devices configuration is listed.
+
+.in +4
+Format is:
+.in +2
+VDPA_DEVICE_NAME
+
 .SH "EXAMPLES"
 .PP
 vdpa dev show
@@ -86,6 +102,11 @@ vdpa dev del foo
 .RS 4
 Delete the vdpa device named foo which was previously created.
 .RE
+.PP
+vdpa dev config show foo
+.RS 4
+Shows the vdpa device configuration of device named foo.
+.RE
 
 .SH SEE ALSO
 .BR vdpa (8),
diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index 7fdb36b9..ba704254 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -6,9 +6,11 @@
 #include <linux/genetlink.h>
 #include <linux/vdpa.h>
 #include <linux/virtio_ids.h>
+#include <linux/virtio_net.h>
 #include <linux/netlink.h>
 #include <libmnl/libmnl.h>
 #include "mnl_utils.h"
+#include <rt_names.h>
 
 #include "version.h"
 #include "json_print.h"
@@ -413,6 +415,7 @@ static void cmd_dev_help(void)
 	fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
 	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV\n");
 	fprintf(stderr, "       vdpa dev del DEV\n");
+	fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
 }
 
 static const char *device_type_name(uint32_t type)
@@ -520,6 +523,111 @@ static int cmd_dev_del(struct vdpa *vdpa,  int argc, char **argv)
 	return mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, NULL, NULL);
 }
 
+static void pr_out_dev_net_config(struct nlattr **tb)
+{
+	SPRINT_BUF(macaddr);
+	uint16_t val_u16;
+
+	if (tb[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
+		const unsigned char *data;
+		uint16_t len;
+
+		len = mnl_attr_get_payload_len(tb[VDPA_ATTR_DEV_NET_CFG_MACADDR]);
+		data = mnl_attr_get_payload(tb[VDPA_ATTR_DEV_NET_CFG_MACADDR]);
+
+		print_string(PRINT_ANY, "mac", "mac %s ",
+			     ll_addr_n2a(data, len, 0, macaddr, sizeof(macaddr)));
+	}
+	if (tb[VDPA_ATTR_DEV_NET_STATUS]) {
+		val_u16 = mnl_attr_get_u16(tb[VDPA_ATTR_DEV_NET_STATUS]);
+		print_string(PRINT_ANY, "link ", "link %s ",
+			     (val_u16 & VIRTIO_NET_S_LINK_UP) ? "up" : "down");
+		print_bool(PRINT_ANY, "link_announce ", "link_announce %s ",
+			     (val_u16 & VIRTIO_NET_S_ANNOUNCE) ? true : false);
+	}
+	if (tb[VDPA_ATTR_DEV_NET_CFG_MAX_VQP]) {
+		val_u16 = mnl_attr_get_u16(tb[VDPA_ATTR_DEV_NET_CFG_MAX_VQP]);
+		print_uint(PRINT_ANY, "max_vq_pairs", "max_vq_pairs %d ",
+			     val_u16);
+	}
+	if (tb[VDPA_ATTR_DEV_NET_CFG_MTU]) {
+		val_u16 = mnl_attr_get_u16(tb[VDPA_ATTR_DEV_NET_CFG_MTU]);
+		print_uint(PRINT_ANY, "mtu", "mtu %d ", val_u16);
+	}
+}
+
+static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
+{
+	uint32_t device_id = mnl_attr_get_u32(tb[VDPA_ATTR_DEV_ID]);
+
+	pr_out_vdev_handle_start(vdpa, tb);
+	switch (device_id) {
+	case VIRTIO_ID_NET:
+		pr_out_dev_net_config(tb);
+		break;
+	default:
+		break;
+	}
+	pr_out_vdev_handle_end(vdpa);
+}
+
+static int cmd_dev_config_show_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[VDPA_ATTR_MAX + 1] = {};
+	struct vdpa *vdpa = data;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[VDPA_ATTR_DEV_NAME] || !tb[VDPA_ATTR_DEV_ID])
+		return MNL_CB_ERROR;
+	pr_out_dev_config(vdpa, tb);
+	return MNL_CB_OK;
+}
+
+static int cmd_dev_config_show(struct vdpa *vdpa, int argc, char **argv)
+{
+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
+	struct nlmsghdr *nlh;
+	int err;
+
+	if (argc <= 0)
+		flags |= NLM_F_DUMP;
+
+	nlh = mnlu_gen_socket_cmd_prepare(&vdpa->nlg, VDPA_CMD_DEV_CONFIG_GET,
+					  flags);
+	if (argc > 0) {
+		err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
+					  VDPA_OPT_VDEV_HANDLE);
+		if (err)
+			return err;
+	}
+
+	pr_out_section_start(vdpa, "config");
+	err = mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, cmd_dev_config_show_cb, vdpa);
+	pr_out_section_end(vdpa);
+	return err;
+}
+
+static void cmd_dev_config_help(void)
+{
+	fprintf(stderr, "Usage: vdpa dev config show [ DEV ]\n");
+}
+
+static int cmd_dev_config(struct vdpa *vdpa, int argc, char **argv)
+{
+	if (!argc)
+		return cmd_dev_config_show(vdpa, argc - 1, argv + 1);
+
+	if (matches(*argv, "help") == 0) {
+		cmd_dev_config_help();
+		return 0;
+	} else if (matches(*argv, "show") == 0) {
+		return cmd_dev_config_show(vdpa, argc - 1, argv + 1);
+	}
+	fprintf(stderr, "Command \"%s\" not found\n", *argv);
+	return -ENOENT;
+}
+
 static int cmd_dev(struct vdpa *vdpa, int argc, char **argv)
 {
 	if (!argc)
@@ -535,6 +643,8 @@ static int cmd_dev(struct vdpa *vdpa, int argc, char **argv)
 		return cmd_dev_add(vdpa, argc - 1, argv + 1);
 	} else if (matches(*argv, "del") == 0) {
 		return cmd_dev_del(vdpa, argc - 1, argv + 1);
+	} else if (matches(*argv, "config") == 0) {
+		return cmd_dev_config(vdpa, argc - 1, argv + 1);
 	}
 	fprintf(stderr, "Command \"%s\" not found\n", *argv);
 	return -ENOENT;
-- 
2.26.2

