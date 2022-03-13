Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5D54D7735
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 18:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbiCMROA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 13:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235133AbiCMRN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 13:13:58 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4655813A1E6
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 10:12:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEWB4fTmZdw+k6sowwiIR5fRsleZhRvJqVk5veja7FE7DNmrGJ0WEMGvqGFXbcgZOHJOKSeZiLZqaX+C2tRNHqEDA9u2poKpfCBgjyXEsQXS+NZLkL95+qJminPrb4yWhGQXnGwH60D/sIXbwZreu3zQPDO7tzelSWWbTAkZo4167HDYnJ+n7R8KaoIqMnuofX3FYeLyq9nAOfaWY+II9PccgvsPncnF6R8foB0RQq8CIPz6DjwAXy/o/Y/wJ4ArcTyHt73ZlDd2f0zluriAtiuJqIMjDsGxhGHNasEHqxrSbY+tIEsf1MhLuKZht6lvem4TuAMlPtBq9CwNVG/FFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IleM5VV4LZIfv09dZlisHWimcnybXGOpsVQgibDScLQ=;
 b=GBoZ5NSQEUEnzKjOAuHlFwrJg+SfNH28n0oMfBsV2cxNAly0TfGyskZbF4YhD/VPdo+PsS0ldryhMRzDPtBAeZuNW5nnULgAK9SfeBBz0qv7zpfglyHAm8R5POTdi4jdiqxrBukAjLVOGf3xu4l/LQD1tk8q/ea+k9r55KiPVhwZctg2HMsXLgrO09ShMFMk0bayF+mWUhjG4JrJSFGTm5V6yF/8BPyiuogaHO9EIMBnDSmKGB4OCshRfkncHgIPLiOMP2v8+yXcanCeyLRcoexl2tdl5Pu2wnwKmRLRWOMEutTF91QXGorBkiIrdX1jZyoZic/B/8aG2HHj/J/Ogw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IleM5VV4LZIfv09dZlisHWimcnybXGOpsVQgibDScLQ=;
 b=oBmk1ujAEn2hyKQqEtTKNCpVoYiTsw/ftjvPp4QxC73RHXROAVRU5tCBbU5PQrUwDn+yeP51ckCLLcdYPFY+VuSR5TH3rOuoj5It9+toPgxmTW8XoW+r0F/lptH3QF5aQYIlAdE1HB7IrQhDl9Q37djLMR0CAWBRw/vD2FiLxc94hFTPkhbaCeXWq4V8NijuIMwsiP9qgVGj50F434NfFoqGfeEQIbwnwldXC24v+g96wOWeHm+PkA5w03BelKWcNWZzbHpw8LD9I8Pxqk7/V6XC8/Go7h+a0ykKfElhP7a1nYBns7qEqWU+a2Jld0d87liMnEPOtdRYCTjnzOsMUQ==
Received: from MWHPR15CA0070.namprd15.prod.outlook.com (2603:10b6:301:4c::32)
 by CY4PR1201MB0181.namprd12.prod.outlook.com (2603:10b6:910:1f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Sun, 13 Mar
 2022 17:12:42 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4c:cafe::d0) by MWHPR15CA0070.outlook.office365.com
 (2603:10b6:301:4c::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26 via Frontend
 Transport; Sun, 13 Mar 2022 17:12:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Sun, 13 Mar 2022 17:12:42 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 13 Mar
 2022 17:12:35 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 13 Mar
 2022 10:12:34 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Sun, 13 Mar
 2022 10:12:31 -0700
From:   Eli Cohen <elic@nvidia.com>
To:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>
Subject: [PATCH v7 3/4] vdpa: Support for configuring max VQ pairs for a device
Date:   Sun, 13 Mar 2022 19:12:18 +0200
Message-ID: <20220313171219.305089-4-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220313171219.305089-1-elic@nvidia.com>
References: <20220313171219.305089-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e798ac5e-1e94-4505-cafd-08da0514af30
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0181:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB01817667BE3D5F7D01F966CEAB0E9@CY4PR1201MB0181.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MT5G5smg0cd41t9kMUoDXsq4ufN6yGqdDBBO1hzMN7Vc2uZRsaLTGbwtEP+3gGsvyjormQnJNbVcFFleeq9GdJKrDXJzGajZbJ/5awhMgbXHmIpHmSoZDNaOyqwpWsUw+DS4ADAZSl4uavVPwXGJJ8lVTo/8rLlGpSQbJ/BTj9mgnpipSJ9Q0ngsblmW/xG8dstA1fMYaqKaqzqqEDzsVJESr4Y28QukTeitJiK7MV9RVrAb5E0KYEK5lVSlzDA7hPQQc0mBwNDm71l7ntY3Me5KurJVn74Q1acDGQkWj9Gs04twqVrHFOcd3matyqIJ2X9bwQTiIHB2KS/q9U21i/bGiMrt6eHLP9RHT825XdZISlgX265BNiZU3h7HoiINwQBUXZGgwvd0+KAA+dS1io5YHOTPSWW+JW2Q6NnGrk8A4I3Fx7/68C2YqOeDW4UOYWJlYFjveCXd+hVJe3GwMLOG+QGq84vVNb9oLmzk4exmP4hA6f39qgkWqjv8wKNaRbSEhn0rtpONbHOtzQwNjuRznWxrCOQDZJchaeGa/iMTT51sDEgrLCdjFrBY2ou4rEbczQX5/+LUFimw16fiOkBUsznZyT82t3f8ZHIUF8nA6NqAIlKur5kyKtU7drtkrfMdgKCpCg1vwbwrWG1bT0LJ+srsKazpZ9KXaWk94lA8lKjMnNOMz8Mk+/PitMdp/Z7yzPVUYnymxeM41cUvIg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(2616005)(36756003)(5660300002)(7696005)(2906002)(356005)(86362001)(8936002)(6666004)(186003)(1076003)(107886003)(81166007)(26005)(40460700003)(4326008)(336012)(70586007)(8676002)(426003)(70206006)(36860700001)(83380400001)(47076005)(316002)(508600001)(54906003)(82310400004)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2022 17:12:42.1948
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e798ac5e-1e94-4505-cafd-08da0514af30
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0181
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use VDPA_ATTR_DEV_MGMTDEV_MAX_VQS to specify max number of virtqueue
pairs to configure for a vdpa device when adding a device.

Examples:
1. Create a device with 3 virtqueue pairs:
$ vdpa dev add name vdpa-a mgmtdev auxiliary/mlx5_core.sf.1 max_vqp 3

2. Read the configuration of a vdpa device
$ vdpa dev config show vdpa-a
  vdpa-a: mac 00:00:00:00:88:88 link up link_announce false max_vq_pairs 3 \
          mtu 1500
  negotiated_features CSUM GUEST_CSUM MTU MAC HOST_TSO4 HOST_TSO6 STATUS \
                      CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM

Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 vdpa/vdpa.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index f7b6e5f8a0bc..c2b1207af8cf 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -25,6 +25,7 @@
 #define VDPA_OPT_VDEV_HANDLE		BIT(3)
 #define VDPA_OPT_VDEV_MAC		BIT(4)
 #define VDPA_OPT_VDEV_MTU		BIT(5)
+#define VDPA_OPT_MAX_VQP		BIT(6)
 
 struct vdpa_opts {
 	uint64_t present; /* flags of present items */
@@ -34,6 +35,7 @@ struct vdpa_opts {
 	unsigned int device_id;
 	char mac[ETH_ALEN];
 	uint16_t mtu;
+	uint16_t max_vqp;
 };
 
 struct vdpa {
@@ -81,6 +83,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
 	[VDPA_ATTR_DEV_MAX_VQS] = MNL_TYPE_U32,
 	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
 	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
+	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
 };
 
 static int attr_cb(const struct nlattr *attr, void *data)
@@ -222,6 +225,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
 			     sizeof(opts->mac), opts->mac);
 	if (opts->present & VDPA_OPT_VDEV_MTU)
 		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU, opts->mtu);
+	if (opts->present & VDPA_OPT_MAX_VQP)
+		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
 }
 
 static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
@@ -290,6 +295,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
 
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
@@ -502,6 +515,14 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
 		pr_out_array_end(vdpa);
 	}
 
+	if (tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]) {
+		uint32_t num_vqs;
+
+		print_nl();
+		num_vqs = mnl_attr_get_u32(tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]);
+		print_uint(PRINT_ANY, "max_supported_vqs", "  max_supported_vqs %d", num_vqs);
+	}
+
 	pr_out_handle_end(vdpa);
 }
 
@@ -562,6 +583,7 @@ static void cmd_dev_help(void)
 {
 	fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
 	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
+	fprintf(stderr, "                                                    [ max_vqp MAX_VQ_PAIRS ]\n");
 	fprintf(stderr, "       vdpa dev del DEV\n");
 	fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
 }
@@ -651,7 +673,8 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
 					  NLM_F_REQUEST | NLM_F_ACK);
 	err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
 				  VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
-				  VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU);
+				  VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU |
+				  VDPA_OPT_MAX_VQP);
 	if (err)
 		return err;
 
-- 
2.35.1

