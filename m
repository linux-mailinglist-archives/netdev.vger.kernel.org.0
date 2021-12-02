Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BF1465D5F
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 05:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355322AbhLBE0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 23:26:39 -0500
Received: from mail-dm6nam11on2059.outbound.protection.outlook.com ([40.107.223.59]:6279
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355289AbhLBE0a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 23:26:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KzdQBZBPzWbUBmO8YXgBkZ5Si10Eludae1ZLTajzMu0EXG/7BLT8hB2eIEcotKu4ePbLDL9zgt78/+O5Te+qDshKdbn9MJMCckRryZ/8OYVqf+AT9h0fA/Me+BXcbrlwnEH1J1BX1U1fSY+nvGZkv/1lDgeWBzMSaTtLemlqTH8ZBc5HkZisYx6/YyqRNb7wp8O8xJp4QPEuHklq5oB+Eg3SgfVB4MdZzI0Of3LiRtKGMmKVAszoK7RQCJiyUpppq1bEy1g9Ms3szyVLRpRjl8lO1W9rOfEARelE3DBvs+M/lMHfIBLSfLhkFRP1BljjuMXqVjN9WHVnoSrkOTxvyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iFwJE2bkk2IgpSZ0gq5glUFxSafNMdBsTrrHBCrzW5I=;
 b=OcHO3tO2fm4ZFwDRPb1ODMIHRmbJKvTv9bQhMshy3LbmHURK3mer69gpAzNnCXaSsqQtlg1ZPAeYfIOrBbPme3bcv7CPNcyN/mWznqOzJZO73l8g/st+dDopf891Ppge1tc4/Fzj16xy1+N7v5Zy2Cv/qHgfTHSSGsvEkmQD7rLolBqHVd7z+6leduCik5zMuUksBDnK+ce2ZuduDV+BAB6iNbaLKFQodbB3IQTxH3FVHSVaa9TiVnqjdsw1aQQ5jVH3C27MN6dH8+snsex1/UclWIDtzsrTFBhZAkHFOGAfDnTyG+4zX99OuZe25W8vN46FA6NqEbl2WHSWsYLSbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFwJE2bkk2IgpSZ0gq5glUFxSafNMdBsTrrHBCrzW5I=;
 b=cgjXfO5tnMLID/pAQFuRC8sEoJvAmEchF/llfMmZ2mP7J6qtKBW/uWu0gnSeYvOZnZ7xr2NloYZWNYqeXE7jPsuGykgbm45Iu0unZ1oGAXw9G4A+FVLmUR2oeFaQ+KILv+f1lFrPwMOWPIwWRG9TtZHFKG8+xO8fr6O5vp8KeyFq23k58F1XtnsPJS9dPKr7/w/6v8Pfv7+RlhXxfJoihCRqBHzQx96ShHwXCssmnpPe0Bw7YIbk7qpxfOiLhmwTzmGgY6FTWPRHwPqfta0+55JGqrxoEZkXp7IYAQCgejOviJvnvpWIDsIuzvP1Fm4W3B65T8qFSWDOdxyuUSyflw==
Received: from DM6PR11CA0026.namprd11.prod.outlook.com (2603:10b6:5:190::39)
 by CH2PR12MB4924.namprd12.prod.outlook.com (2603:10b6:610:6b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Thu, 2 Dec
 2021 04:23:06 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::1e) by DM6PR11CA0026.outlook.office365.com
 (2603:10b6:5:190::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend
 Transport; Thu, 2 Dec 2021 04:23:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Thu, 2 Dec 2021 04:23:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 2 Dec
 2021 04:23:05 +0000
Received: from unicorn01.mtl.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Wed, 1 Dec 2021 20:23:03 -0800
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     <virtualization@lists.linux-foundation.org>, <mst@redhat.com>,
        <jasowang@redhat.com>, Parav Pandit <parav@nvidia.com>
Subject: [iproute2-next 4/4] vdpa: Enable user to set mtu of the vdpa device
Date:   Thu, 2 Dec 2021 06:22:39 +0200
Message-ID: <20211202042239.2454-5-parav@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3cb91013-2c77-4b81-ff68-08d9b54b7083
X-MS-TrafficTypeDiagnostic: CH2PR12MB4924:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4924ED36C31E2E835280A088DC699@CH2PR12MB4924.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yGNWZnNPnGJj4sGZUwPPZIa4X9Zuc+wC2fF1hc/lqUmTXuJJxM/WhwHnIZzuwP3CsrnhZqCzRHVc9p7hsdtduy/H6aLcbGYMKY1jKcv/Uw7vMpM4AKG3InwH+M/YwxvlqVWW69ycSyWJIF2iDAWg6sRYy4LHRfVRw9yxTKcZMpLxoaYZqKBQfyPngFS8IxFhYUn8vClBwInK/jrEL3maX9a2qMwS8NMgXyyKRjSUoB17g79YL/klgL7rg7SbtayQUd5zA3k82agRVZxMtxgBu0R04dh8QFrRTHMxC2RznsqERND1OZr5R+Nq0CTjeoh1ucd/cM2LHZh3MFgngpALx34DVYpxwl5TO/taQONUs4OeSFIk0Q9dB17SGxJpKf6GVBmNRYWtO9M//C4RVBF3B3og/1Fr2VveqpylKe6660RSNLAAeP3Xxd6axcZQXR77n6+mBr3oYqHplE7jck/KWqDEsD0O+3E0PN5aeoMURvXTbr2nskUFXAWgZ2nMDtdj7emLSszB1jBpU5n/ByzAFBTpXMvYiASmbKvvDy9oK3FI7S2X7naGKrmsmNn8qcmrbwmLQnw/w9/qO3XSMF6EALBRX/X2LV6Cuq8RwzkQaAQ2e3JpXpo3yCNKXn8MefeD1ApOyaXnP2Rn/iUqTubT54pXoNs1DwDMcY6qTB0FZaMukSu1Ur8G97L8vu6P5mqMNQQH8XGzcmzPY/DPYgAe6fVtXbjKs9/WBkq/WtSvZRtc/2UpqWU3Ey4n+hqGu+YPdvB5K2A9PmZuAZYNV5VHLA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(426003)(508600001)(16526019)(336012)(86362001)(26005)(8936002)(186003)(7636003)(6666004)(2616005)(47076005)(36756003)(1076003)(82310400004)(83380400001)(2906002)(356005)(40460700001)(8676002)(4326008)(110136005)(316002)(54906003)(107886003)(36860700001)(70586007)(70206006)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 04:23:06.3415
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cb91013-2c77-4b81-ff68-08d9b54b7083
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4924
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement mtu setting for vdpa device.

$ vdpa mgmtdev show
vdpasim_net:
  supported_classes net

Add the device with mac address and mtu:
$ vdpa dev add name bar mgmtdev vdpasim_net mac 00:11:22:33:44:55 mtu 9000

In above command only mac address or only mtu can also be set.

View the config after setting:
$ vdpa dev config show
bar: mac 00:11:22:33:44:55 link up link_announce false mtu 9000

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 vdpa/vdpa.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index 9d20bdb4..7da2ea7a 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -22,6 +22,7 @@
 #define VDPA_OPT_VDEV_NAME		BIT(2)
 #define VDPA_OPT_VDEV_HANDLE		BIT(3)
 #define VDPA_OPT_VDEV_MAC		BIT(4)
+#define VDPA_OPT_VDEV_MTU		BIT(5)
 
 struct vdpa_opts {
 	uint64_t present; /* flags of present items */
@@ -30,6 +31,7 @@ struct vdpa_opts {
 	const char *vdev_name;
 	unsigned int device_id;
 	char mac[ETH_ALEN];
+	uint16_t mtu;
 };
 
 struct vdpa {
@@ -154,6 +156,31 @@ static int vdpa_argv_mac(struct vdpa *vdpa, int argc, char **argv, char *mac)
 	return 0;
 }
 
+static int strtouint16_t(const char *str, uint16_t *p_val)
+{
+	char *endptr;
+	unsigned long int val;
+
+	val = strtoul(str, &endptr, 10);
+	if (endptr == str || *endptr != '\0')
+		return -EINVAL;
+	if (val > USHRT_MAX)
+		return -ERANGE;
+	*p_val = val;
+	return 0;
+}
+
+static int vdpa_argv_u16(struct vdpa *vdpa, int argc, char **argv,
+			 uint16_t *result)
+{
+	if (argc <= 0 || *argv == NULL) {
+		fprintf(stderr, "number expected\n");
+		return -EINVAL;
+	}
+
+	return strtouint16_t(*argv, result);
+}
+
 struct vdpa_args_metadata {
 	uint64_t o_flag;
 	const char *err_msg;
@@ -204,6 +231,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
 	if (opts->present & VDPA_OPT_VDEV_MAC)
 		mnl_attr_put(nlh, VDPA_ATTR_DEV_NET_CFG_MACADDR,
 			     sizeof(opts->mac), opts->mac);
+	if (opts->present & VDPA_OPT_VDEV_MTU)
+		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU, opts->mtu);
 }
 
 static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
@@ -263,6 +292,15 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
 
 			NEXT_ARG_FWD();
 			o_found |= VDPA_OPT_VDEV_MAC;
+		} else if ((matches(*argv, "mtu")  == 0) &&
+			   (o_all & VDPA_OPT_VDEV_MTU)) {
+			NEXT_ARG_FWD();
+			err = vdpa_argv_u16(vdpa, argc, argv, &opts->mtu);
+			if (err)
+				return err;
+
+			NEXT_ARG_FWD();
+			o_found |= VDPA_OPT_VDEV_MTU;
 		} else {
 			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
 			return -EINVAL;
@@ -443,7 +481,7 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int argc, char **argv)
 static void cmd_dev_help(void)
 {
 	fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
-	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ]\n");
+	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
 	fprintf(stderr, "       vdpa dev del DEV\n");
 	fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
 }
@@ -533,7 +571,7 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
 					  NLM_F_REQUEST | NLM_F_ACK);
 	err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
 				  VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
-				  VDPA_OPT_VDEV_MAC);
+				  VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU);
 	if (err)
 		return err;
 
-- 
2.26.2

