Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974244BCF05
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 15:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbiBTOGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 09:06:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243902AbiBTOGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 09:06:04 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974B635856
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 06:05:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIu7HQodlH7o7DLs+7yxwisqZR85QtYUh51qjE0ZU3mZPwWd0aYu3ZMsdnrjpeHALxkkIiK9oz4qb+dvNnOl3XFryuUo8SwzaYXbwmcaZ6caCQvMf8sowZgJO/C4S70GSPMXhdnAj91NPF8UdeiD6I6dAaqOnf4jyjAvbIQBgJ+85HTGI3kXeGFwr44bKQZ/u6m7ztW251vgjzW/4Gsy3dOOxkJtT6RpGTqWPykIpE9CweGiyRugrZVKXHt0Gdv2ATuFByHxEoP+DqLKx1gwMGWjwqcHx/oON//bnOLKfd/w569DG/Cfidgb21p1OiVoYcY8pa7nSzKIHdAV8KMTmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2esf111GtPrgylCZ29AWW/U6CAr1xnDY7ueoVOsBtvo=;
 b=btC/eKbBSYDxVns2WGns9rVQEQcaGFy/57aJB1h/Lu3/uWFHJ/A/gKfZ/GjQDrmAVCb48qneGQ0FaVct0mUF7srA41SyJ97APJtmC7VmAEDpSOQtBz3xrtfWb8XyEAaM0mdvRP3pngDxmG5nEOj/thM7RHpY95qYK6b2NsQ4iB3jXgyyHDAGPArEGk2wBgGRmddTgjB2TrKjrkVSjO03dDTb+kSf+sulReiIdGvjy8c7Ex+qPn57QSXQ8nVUS3NHmwp3yPLJYSaRUFmraToYQvrkafJz2m8LytaM4om9GHvRDx5aC+f/Nd//4epmuYZIXVhhQHsJ2IIbGfnTLy18Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2esf111GtPrgylCZ29AWW/U6CAr1xnDY7ueoVOsBtvo=;
 b=gXVtwgSZ8zxsV2XU7otCMtbYJtZcIP9NkhJfGOuFtaFrFSKO86332ElWKglzl/QVm63SitCEVLa9FFINH7K0SofOYH53rRp0sCCbKXcSjK1ZxmibBCxXQcgXjGwdJ6cLUNm7WS58v+P9q2AXU2EMTLUYFschtfR2FIombiJ14Y6NgwIfyixMuPi+AJt8sIg4tj3/inF8lzPy6KV9dURdyk6C6TXCtLdXNDxam30xnwZ1G/W6PMe4bKtNOuU5TBP2ZUbCf/rqk5YZv5LTsbtaVGxRy5ayaGOR00AKyZ/AAHuAoXRddP+Iu0LzQ9log0VOkyVpTkmG+EtecbOIxoc9Sg==
Received: from DM5PR07CA0109.namprd07.prod.outlook.com (2603:10b6:4:ae::38) by
 MW2PR12MB2444.namprd12.prod.outlook.com (2603:10b6:907:11::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.17; Sun, 20 Feb 2022 14:05:37 +0000
Received: from DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::79) by DM5PR07CA0109.outlook.office365.com
 (2603:10b6:4:ae::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15 via Frontend
 Transport; Sun, 20 Feb 2022 14:05:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT065.mail.protection.outlook.com (10.13.172.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 14:05:33 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 14:05:29 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 06:05:28 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 20 Feb 2022 06:05:27 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>
Subject: [PATCH net-next 01/12] vxlan: move to its own directory
Date:   Sun, 20 Feb 2022 14:03:54 +0000
Message-ID: <20220220140405.1646839-2-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220220140405.1646839-1-roopa@nvidia.com>
References: <20220220140405.1646839-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba7e1836-b4c5-474b-2bf0-08d9f47a0f8a
X-MS-TrafficTypeDiagnostic: MW2PR12MB2444:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB244491240CD8A0278CEF224ACB399@MW2PR12MB2444.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R9YnVb7IJdt84jnZkRnkbpf7iG5wnNNBQhXlvxuTM2q7DkALADzqAHPEbktAVhqaawtMdxp4auUaGJLY3FCKL18OEHpuJAQFBRJlRceubG7FV9YV/E0ds/8MgZbP7ZgiLuZPkXjExq/Jh5Oc+S5xF3yBDa3Xq4BImYMvVSXPlYvegb+fkcvtQ0HGx1pkwP5kWWH7ZQ+ilB+HiPEe6M6+1vp3/lDESiShcApciUu360op4vPCxuexNGAHQFCduvDyg2jCZSsl9/BEj2ajVE0C6StyZD+Db8bd/k4UpIPECn/gJg1xNdT11gIrrTzoJEneVCK89J6Oc4DwTQ7esI7KkBzM+iwyY2wrrkgD0/laU+CYbmOaJFa0d8CTzuxiD3WN3ozvDoVRcawVTCXuOASLE9VO8zbybhBq95IF2n1wSw//zZhV40TODA0MmiS/pPLdR71jiARCiNpMh7fOj4W4hd+KUUd2iJMPuDFQU3lSNxqr7LakY/aH+0XGNG4U6lWWJN94jXxmva5rvxU7Xe+xSxGTUcREqLYhVkXgqVsPSnMR92ut43sjXwisHrOSp7RK9QpNEZLK3QIkjTLPhZ52fUZGvD8QyiAkjdM20zrGBLgrxDpiS9T4OLEbvoPK63yPs02K9UZkj5l54e+FSpTPJLhpaHp0jdvFGIz1w9m/+BBVCrTG8MViaUgkWN+istJ5imlILed39waki+Ql3iuB2Q==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(86362001)(36860700001)(81166007)(356005)(40460700003)(8676002)(4326008)(70586007)(70206006)(316002)(110136005)(54906003)(8936002)(47076005)(2906002)(5660300002)(82310400004)(336012)(426003)(1076003)(26005)(186003)(83380400001)(2616005)(508600001)(36756003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 14:05:33.2286
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7e1836-b4c5-474b-2bf0-08d9f47a0f8a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2444
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vxlan.c has grown too long. This patch moves
it to its own directory. subsequent patches add new
functionality in new files.

Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 drivers/net/Makefile                        | 2 +-
 drivers/net/vxlan/Makefile                  | 7 +++++++
 drivers/net/{vxlan.c => vxlan/vxlan_core.c} | 0
 3 files changed, 8 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/vxlan/Makefile
 rename drivers/net/{vxlan.c => vxlan/vxlan_core.c} (100%)

diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 50b23e71065f..3f1192d3c52d 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -31,7 +31,7 @@ obj-$(CONFIG_TUN) += tun.o
 obj-$(CONFIG_TAP) += tap.o
 obj-$(CONFIG_VETH) += veth.o
 obj-$(CONFIG_VIRTIO_NET) += virtio_net.o
-obj-$(CONFIG_VXLAN) += vxlan.o
+obj-$(CONFIG_VXLAN) += vxlan/
 obj-$(CONFIG_GENEVE) += geneve.o
 obj-$(CONFIG_BAREUDP) += bareudp.o
 obj-$(CONFIG_GTP) += gtp.o
diff --git a/drivers/net/vxlan/Makefile b/drivers/net/vxlan/Makefile
new file mode 100644
index 000000000000..567266133593
--- /dev/null
+++ b/drivers/net/vxlan/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the vxlan driver
+#
+
+obj-$(CONFIG_VXLAN) += vxlan.o
+
+vxlan-objs := vxlan_core.o
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan/vxlan_core.c
similarity index 100%
rename from drivers/net/vxlan.c
rename to drivers/net/vxlan/vxlan_core.c
-- 
2.25.1

