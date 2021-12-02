Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1050B465D58
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 05:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355261AbhLBE03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 23:26:29 -0500
Received: from mail-dm6nam10on2053.outbound.protection.outlook.com ([40.107.93.53]:48864
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344852AbhLBE01 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 23:26:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+wdmMrzjKaOA6NHiGXyV7IkZnX+1L+LYmIBzB31M0o8UQm6Nr+/7kkRn7xGN6ebp1yvQ5uL+niQz3Lm9rE7e66LI8428cANS8GWWaWKy1AY018apZ8qZnJ3317FWYtrqjmMAVpLUXGr2f9CO/C5/UNL6x8HHWT76MOjV+dyT7DxAov9I3LRbOygm2LV+9DxQHbYRF1Nx3HquawzmLQoZ+xkIa6A8MxO9K+hLzcClsGFqqWwe6PuKykHptSOHdVHo7iqF85gApKv/iRSG5xX/xkDC3tBaeyl0jw2Y9l4AidAEfjFBFRrOkWRFgfp432azUqVG/ypx7mP0AEcDRx40w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tEh90SOM6XTAaqsEZjadqVZETFrbj1lY1tBkoSlQlGg=;
 b=ZXaJxXQZpf0Tp2AL9kBX7gL1Ao0JUKjXNqrM5+sEdEq1zAWnhqBX8BkrFr88AGQ6ziNLY7c47ba0aY3a6TlfTs6G2af7r3Q7V2ObrRUNxbi+ykQkuvrD1gh8v04thXUsP+M21aKAEWnqQ9mTInHExJUK4B20E5u4ldCHWMCdrLx14vt4NUh6xgORwJZ1NSrZ/ViRZiZO7/1tSL64HtnSv6yv3UxG40p6uoWh5Nd6opDMn73PgW3Syr44TGyoZOG5WOEppQH7uV/BZNddpXJKwoe6jdPW8ns4Z8hPCB6rAU7MC1w1UHeqKKuS3a/cZIZ0DeCbfmv1Vnd9wA9Dvdowcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEh90SOM6XTAaqsEZjadqVZETFrbj1lY1tBkoSlQlGg=;
 b=nxL6Qt4UKsE6jnKKXOwrjuz5C3Ye4CpeqRvxAwntfZU2zXA0Uh7CGg0MNZRVOaKz8gzBuzQsw3SjMddWElo9rDBXRh/yPng7GBjjeTw+uSYObfvuShuqXOnNWc30jnEhcaQ0+e9aK29QpqWAxtC5SfHiayfUGkUArDwC010yChNF9AQMCQq7LyRj/PY9EOUPzQJwOOODxUUKAFYZxV4rIfbx/zCXQ+uAeMGPdakYJ0BF6oqB1GSrzcrHFE3BUgCsFF3bR1SIjgb4rQBxb4siDZeb+h/pH6a7SiCuWHvvWTlxVKZlRjIvtjyLlJVUr5CJgpqRE5UoBUyQaFHmwNuc2g==
Received: from BN6PR16CA0039.namprd16.prod.outlook.com (2603:10b6:405:14::25)
 by MN2PR12MB4392.namprd12.prod.outlook.com (2603:10b6:208:264::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Thu, 2 Dec
 2021 04:23:02 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:14:cafe::70) by BN6PR16CA0039.outlook.office365.com
 (2603:10b6:405:14::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24 via Frontend
 Transport; Thu, 2 Dec 2021 04:23:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Thu, 2 Dec 2021 04:23:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 2 Dec
 2021 04:23:01 +0000
Received: from unicorn01.mtl.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Wed, 1 Dec 2021 20:22:58 -0800
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     <virtualization@lists.linux-foundation.org>, <mst@redhat.com>,
        <jasowang@redhat.com>, Parav Pandit <parav@nvidia.com>
Subject: [iproute2-next 2/4] vdpa: Enable user to query vdpa device config layout
Date:   Thu, 2 Dec 2021 06:22:37 +0200
Message-ID: <20211202042239.2454-3-parav@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211202042239.2454-1-parav@nvidia.com>
References: <20211202042239.2454-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da9e2cba-4cd4-4f90-97b7-08d9b54b6de7
X-MS-TrafficTypeDiagnostic: MN2PR12MB4392:
X-Microsoft-Antispam-PRVS: <MN2PR12MB439281FD28E63EAC37CADD2FDC699@MN2PR12MB4392.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:91;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mEbVLH3VQRiYAPxyU4yyQ5vyZLk5jkKboA/rkqiaQo42puFS8pcOrRv/k+WT3Rk2cAKZndNmgtya0UJlMy478jn7YyaiX0P9rdUQSL82b5yCWasVKVZEufHXvzb9+Gj4OSqOhoezU5b4lDk5n0w6PAozuNaLvXrGY4YFeSuV31nYg7FXcIUQRfwQT07FCXEt3XC8ZfJ9spmiyJhynm/18Bw6EK2YKwfYyq1LtZDCdsRVZRHZTTCVvox1vmzrJf51zfgBeHW5Luh2Rh+4CJuYsuzljfBKe7aZFepQefZuL/V06qUQi9UcnR/lWI6WZOaaWNLcXfIJTQUnlvXJrE498sZfkgHAb/XFB+4/pkN45cRLZS5m4wkCjTXlMJNk7kuh/WN1Pt70Va6FZ7bHyy6b14Rm3dItltuxXjS71gDRuqgfGwYZaKO3P+bjoeMVnmY9lvjpMXY3EGGXVKPLJcBWtYhx0GAtWHusDTciJkYeulsRRyH2VmRsXy1qHAYk65mu0yJO0YYshd0Rrfegtseium7TeLZeNvo3tMTOcQSrY6upb//JANs+e9QqVbi0ueKqd3He8ROJGV2TxPsivFFRh83DhrWxO3tW+kYPRLqIaq24etaId+G2CgqpGSOSP3VjbfyhTpTcjcKMNV2SKFbspfMuZqSmcbk77xOjowLO/dSz2mbA4mf60CLl01XAE1H5LTmuohhrYm4cia19iwGDb4IXMaUk25lMQ/9YSI877K4B+gBQhaecVm1jkAYUqLtDs7mnmkHJ/3Zt3yas225OEQ==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(70206006)(110136005)(54906003)(107886003)(1076003)(82310400004)(186003)(70586007)(426003)(8936002)(4326008)(2616005)(47076005)(36756003)(2906002)(8676002)(26005)(7636003)(336012)(508600001)(5660300002)(86362001)(83380400001)(356005)(6666004)(36860700001)(16526019)(316002)(40460700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 04:23:01.8986
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da9e2cba-4cd4-4f90-97b7-08d9b54b6de7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4392
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
 vdpa/vdpa.c | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 110 insertions(+)

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

