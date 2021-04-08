Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14526358134
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 12:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhDHK6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 06:58:46 -0400
Received: from mail-dm6nam12on2049.outbound.protection.outlook.com ([40.107.243.49]:20204
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229640AbhDHK6q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 06:58:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHsqB5GPG9Y3EVctzbQiun7WS3jhZojhBOhylgN16XDbSL3NdByn+RKaTSc8b9qAXNtumqVU89ZEmghKy9I7Ikqyvxym151zb3pqPaEKO5MIkQNR/2HMdrrOxEQGws5qeQY/SFF06ejLd2ypmzFxSOrkl9ZSE75W5O8jwPm1SwPecZENIzFQ+cRoLcwo+1dlukZVOXDixwPNH3wJotWbTW6rJGYi7zSnFALxC9ii67VwJ9YLnou7fq5OWPzlpvI1jtJfkTWmRkyWH0x2ICL1mSTtNLvgQRLVoXEi3ZpWkFdRIelBvkXBU1KqM0a8JQ/8xq5hNYo4duQP4/t29PLeIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBuYBqW8EyBv7Gsq1pTc++Y2avZCg6j3eTIouoWgtko=;
 b=PInyF3j3o/fTt1WXRKYsTHOmgmKJjrXMQpcOJuLaBtcSZAzBvujvYuKd3RKPW3sqDC7QsLck70J/r2h1LApGsKPz1AOv5kDV8ioiuX0U3+NpmvqL6fc87Hf4SLthp+g23vN1baEsjvs/ZycaHj7t4s5UV3ObRCqsGBAFDzQFh5utq82yrLvmbN7wt7l4a1CX9z4LVZ/maMNAY0FgaVDB4yvfLOlWIfMY62MORid0bdZ2I9V9FqB82oECIPLLXZbOogUpANOjlVEPxRZbhsbB7+XBY2wP4zWWEef0QOfut+CTCKX3gsnHDc8o7AmUvdA9SpbpF0kKin0RiJu35TAJ8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=fb.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBuYBqW8EyBv7Gsq1pTc++Y2avZCg6j3eTIouoWgtko=;
 b=W4JVGGdgwGcRoYEjlsecV/3eoCAys8tR7b4s9OjI/DUVX5mAE177rT7fdsQk+6rl64RyHis0lpOLKyuVC1Vc99G13DbA0mUn1r0qQ0AzLPBDM/ug8Iz3r71+sudrVf5n8ndbizqrRRUKYCEI3V2C/Qk8e5sujU6ROmPlUUSOT1NP0IxVhad2zOazy6QpzFk62XcX+r6KzFZbwOMqqLV7eMqirBDaXKME8/B/Q/9nI1eE4raIzs4HR1fBISlnMu2zOpt7Ixf3GmGxLl1Lz10VYotmOXvB00m7rn9uyoC1tLOqrV7Mp5blwdOv2mRHxfPt+d/CvdTQcHHNT57umkhqzQ==
Received: from DM5PR07CA0127.namprd07.prod.outlook.com (2603:10b6:3:13e::17)
 by CH2PR12MB4134.namprd12.prod.outlook.com (2603:10b6:610:a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 8 Apr
 2021 10:58:33 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13e:cafe::95) by DM5PR07CA0127.outlook.office365.com
 (2603:10b6:3:13e::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21 via Frontend
 Transport; Thu, 8 Apr 2021 10:58:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 10:58:33 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 8 Apr 2021 10:58:28 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <alobakin@pm.me>,
        <meirl@mellanox.com>, <dmurphy@ti.com>, <andrew@lunn.ch>,
        <mkubecek@suse.cz>, <f.fainelli@gmail.com>,
        <irusskikh@marvell.com>, <alexanderduyck@fb.com>,
        <magnus.karlsson@intel.com>, <ecree@solarflare.com>,
        <idosch@nvidia.com>, <jiri@nvidia.com>, <mlxsw@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next] ethtool: Move __ethtool_get_link_ksettings() to common file
Date:   Thu, 8 Apr 2021 13:58:13 +0300
Message-ID: <20210408105813.2555878-1-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f736cf8-483c-4cb1-7406-08d8fa7d409a
X-MS-TrafficTypeDiagnostic: CH2PR12MB4134:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4134633049EF7BFBCADC8F7BD8749@CH2PR12MB4134.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qIEK9LQQJ9NHroARpXqh5Sguk/yRuTopBzWtcIB/f/NyFQ+/gFuoSubicGLdROPyGREXaHrB+/GTWv626/UqGR065Ix4Km13vdMrKeWJlt1O4lwHF7yDB4IggOnWlh98zQwbVbvq1CK+QLWdhUzwBTNhUYUEb6pCazTd8MhJ6ICxVYaEPPELSr0FV+6P7fIIT8pmbXwi9xwhnRZ/1VTskGx/rkTLLZVnoWV3xNa1R+AHAYP/CcWxyAMiEoFvUq0sNgNIB5oGb5Y/Hu4JSUNr4H/z+BUbT85cfiRjn6G0f4HBEvOo57fSEgk4BOjR6Dm0bp9m54Wsgdmmag0f/aZnUpWShr32U8k3dct9Yb1TSwTAJk2zThW35lNCXQsUuiPS1nZRS7H0JyVdab0yyQETT9xQDmUXlFRfYScqv96xIAe93D59U/YGkAfbfPw3YX8ol7pFjyNmxXCsNEEaXhPU9E8RchdzJLKV3J5AR39+zZrPYhdmGuxMt5Fk3xqnzDzZRbZ9XEB0SwHjlmwX7fSipndOwHcNuBsX+6hy4KuFai2qwTgrSfzYZHjw18epXRx8UE/jPAj6WUTfFDXiZgjjG5wWag6ox6F4FndjkubivitqELE4dI68QpWrVU/6VkmG5YSMt8IirSyBT6VQiSTL5rXMmbRjHZG8ZUf1jI0kd+0=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(396003)(36840700001)(46966006)(70206006)(2616005)(336012)(356005)(70586007)(2906002)(82310400003)(478600001)(83380400001)(82740400003)(426003)(26005)(6666004)(36860700001)(7636003)(36756003)(7416002)(86362001)(186003)(4326008)(107886003)(6916009)(54906003)(316002)(47076005)(36906005)(16526019)(8936002)(8676002)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 10:58:33.3575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f736cf8-483c-4cb1-7406-08d8fa7d409a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__ethtool_get_link_ksettings() function is shared by both ioctl and
netlink ethtool interfaces.

Move it to net/ethtool/common.c file, which is the suitable place for
a shared code.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/ethtool/common.c | 14 ++++++++++++++
 net/ethtool/ioctl.c  | 14 --------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index f9dcbad84788..0dc78e0e8a25 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -484,6 +484,20 @@ convert_legacy_settings_to_link_ksettings(
 	return retval;
 }
 
+/* Internal kernel helper to query a device ethtool_link_settings. */
+int __ethtool_get_link_ksettings(struct net_device *dev,
+				 struct ethtool_link_ksettings *link_ksettings)
+{
+	ASSERT_RTNL();
+
+	if (!dev->ethtool_ops->get_link_ksettings)
+		return -EOPNOTSUPP;
+
+	memset(link_ksettings, 0, sizeof(*link_ksettings));
+	return dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
+}
+EXPORT_SYMBOL(__ethtool_get_link_ksettings);
+
 int __ethtool_get_link(struct net_device *dev)
 {
 	if (!dev->ethtool_ops->get_link)
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index a9f67574148f..8944f4496cf0 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -422,20 +422,6 @@ struct ethtool_link_usettings {
 	} link_modes;
 };
 
-/* Internal kernel helper to query a device ethtool_link_settings. */
-int __ethtool_get_link_ksettings(struct net_device *dev,
-				 struct ethtool_link_ksettings *link_ksettings)
-{
-	ASSERT_RTNL();
-
-	if (!dev->ethtool_ops->get_link_ksettings)
-		return -EOPNOTSUPP;
-
-	memset(link_ksettings, 0, sizeof(*link_ksettings));
-	return dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
-}
-EXPORT_SYMBOL(__ethtool_get_link_ksettings);
-
 /* convert ethtool_link_usettings in user space to a kernel internal
  * ethtool_link_ksettings. return 0 on success, errno on error.
  */
-- 
2.26.2

