Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26AD9353763
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 10:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhDDIPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 04:15:13 -0400
Received: from mail-dm6nam11on2054.outbound.protection.outlook.com ([40.107.223.54]:10465
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229483AbhDDIPL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 04:15:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AyleZijr1xSbsuuQwNGq2pCLr1Qd2YVbCpg1o6OqL5ZcU2mVXlZwVQsTXA3bAWZKlRfKvTG6XE4f4zyP6iYQOvsup/l0lj9CSjrGbCSoRm8NeXcxHP/ziLTCNtxwBJmFVcLQGS6UuZUWOBD3cZ7e/X0D46n7dGNvPfDyogsUsR6i5Zo2cT5La+CHVtR51LqYz3bInYA75VBUY/P0GDnRmxM0luytrr9booIVUW8yS3jmpwOGN18mS3S3Y50i9XIPLMa570RMBB/Gm23aWSg9a9b9U9ErH+HnhlPNjNXf2r33HUm9BU/0+sBDlFvERHxzyyL0WclJmnMhZQukOBwJ2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SeNm3NyJAP1TJht/5vLt8u9uoVxSx2Jxc+dQhIgu2qE=;
 b=At/NNI5RdrTaxnrdIV9pP1GE4/+2IwY1E9kTJVHI0b9z1MbiTduXemuGeDI6WQhQL+XNWVfKAGuzg9yCyKkv4rGIHfIiBY1KodcCk1AWmhHrLkpc29uo8RUZvUYho9bk2KEkY6F617GDWhJI15OU5QpfJAvqqRN1vpvNWpdqODWoc5y0oVB7nqsqkI9SyxAlLKxlGCIcC1t1WQjob8K/YcWKKLBip4LgzlFbieghsXM5WIYttDEMZ8iXFzU2DldmhIgHwoSpT0zN3uEBNM69L75To++TbQwv6m92/U5AeXQOI7mliQKxtCNHSJJz0hStwo5EDIZul7R4uRszu1Fupw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=embeddedor.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SeNm3NyJAP1TJht/5vLt8u9uoVxSx2Jxc+dQhIgu2qE=;
 b=UOarSsgSGWDLiJAfnkdMOglq9Hf0Lw08xS/AgQwHD/c49o07BXMZm5pF6IZ0zjf45SjsH/O7YWuzyPHDXCgQSwAoEoNrP0r/Z1ZNLnmyMP0nClzAwTAZ9efVDYGSBwSl70E+EMjmiuUbYDWFvb7+bhILEweX1DpVxuC96k9wfShGvmIVYkImSHiszhdq8u0PZ6s/mYiasFtwMYclLO5Q5RCIKjoW132zD44KO2L8wijRbbtGY4aImutiUKIJrwtnZq2S9784qFL2geolYyEUjss8xL4vWkNbDnaADX7Glqhz91+8klQjszoxqJyicgrM+WTw1p7vkk9HoXabnuyqzQ==
Received: from DS7PR03CA0153.namprd03.prod.outlook.com (2603:10b6:5:3b2::8) by
 BY5PR12MB4241.namprd12.prod.outlook.com (2603:10b6:a03:20c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.28; Sun, 4 Apr 2021 08:15:05 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::7b) by DS7PR03CA0153.outlook.office365.com
 (2603:10b6:5:3b2::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend
 Transport; Sun, 4 Apr 2021 08:15:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; embeddedor.com; dkim=none (message not signed)
 header.d=none;embeddedor.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3999.28 via Frontend Transport; Sun, 4 Apr 2021 08:15:04 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 4 Apr 2021 08:15:00 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <eric.dumazet@gmail.com>,
        <andrew@lunn.ch>, <mkubecek@suse.cz>, <f.fainelli@gmail.com>,
        <acardace@redhat.com>, <irusskikh@marvell.com>,
        <gustavo@embeddedor.com>, <magnus.karlsson@intel.com>,
        <ecree@solarflare.com>, <idosch@nvidia.com>, <jiri@nvidia.com>,
        <mlxsw@nvidia.com>, Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net v2 2/2] ethtool: Derive parameters from link_mode in ioctl path
Date:   Sun, 4 Apr 2021 11:14:33 +0300
Message-ID: <20210404081433.1260889-3-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210404081433.1260889-1-danieller@nvidia.com>
References: <20210404081433.1260889-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b565a1f7-08fc-4ea4-bbe2-08d8f741c093
X-MS-TrafficTypeDiagnostic: BY5PR12MB4241:
X-Microsoft-Antispam-PRVS: <BY5PR12MB424175DF11E57D028F374FBBD8789@BY5PR12MB4241.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fpszzyn1Wga2XghUkjGHNGwoAM5v9/+OywP9vPjhPjNt/Q96b43rAdIjOOjVj5Zu6O5VbGhVI3uZpEV5r+h0BvccVwIGobW+6hxqRvargaL5uezoy0a8GfWlxEJWERtag4Spri8ncMqb1QZNSAjXNcv7S0Are1BV1zzLjJxP1/QiEewq5qbngIPmA3dCbL5PUftkJIrHDIBD/lwTqdmO6M0S7hYUG/lDZOwgmfc4GeoOWQMmNTiFHf3kdUVQVn+pByQ6JgAekyTtDvl6vlCUcf2/w5dUdoNdxafalN+O49zlAVmjQHcjbU607UI+12ibhiwMwWkcbZ5MrOPQN0WNhfLogd+c4tofogRMWvh0g6eE0DwKdG4BVR3HUxkvtCQAUOk+QUkXTyWtYVo5FdDoG0b+PGLNKzernTqJoLkKxBA6ot9DOmgMqJT08JhzMrcMm8H0PJz3e/h8fqxY7xfFIhoeRMB8jmmI5UitOmWHNE5MfgIO3JRt8WfO5v2GzoC4mEMU5W+OO7SrH2x3kAMV+8o7rz8wWJZV4/kP6sT8v2qgyGyrKQQ8Urt3WDur/ibZ3GUk9JhbsCHDS7K0Ds9Fw4wj0zVpxuC6F63KEwkGt7ZI6xqk9JSXGiH99WM0KEl2q+VoV6m0hUFZgOtCfSiIRTSk//s+SQeCshVtu9ukquI=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(376002)(46966006)(36840700001)(70586007)(336012)(6916009)(426003)(2616005)(478600001)(82310400003)(36756003)(6666004)(2906002)(1076003)(356005)(36906005)(316002)(16526019)(8676002)(7416002)(186003)(8936002)(107886003)(4326008)(54906003)(26005)(86362001)(36860700001)(82740400003)(5660300002)(7636003)(83380400001)(70206006)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2021 08:15:04.7548
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b565a1f7-08fc-4ea4-bbe2-08d8f741c093
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4241
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, some ethtool link parameters, like speed, lanes and duplex, are
derived from the link_mode parameter. These link parameters are only
derived in __ethtool_get_link_ksettings(), but the ioctl path does not go
through this function. This means that old ethtool (w/o netlink) won't get
any reasonable values.

Add a function that derives the parameters from link_mode and use it in
ioctl paths as well.

Output before:

$ ethtool --version
ethtool version 5.4
$ ethtool swp13
Settings for swp13:
        Supported ports: [ FIBRE Backplane ]
        Supported link modes:   1000baseKX/Full
                                10000baseKR/Full
                                25000baseCR/Full
                                25000baseKR/Full
                                25000baseSR/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  1000baseKX/Full
                                10000baseKR/Full
                                25000baseCR/Full
                                25000baseKR/Full
                                25000baseSR/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: Unknown!
        Duplex: Half
        Port: Direct Attach Copper
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        Link detected: yes

Output after:

$ ethtool swp13
Settings for swp13:
        Supported ports: [ FIBRE Backplane ]
        Supported link modes:   1000baseKX/Full
                                10000baseKR/Full
                                25000baseCR/Full
                                25000baseKR/Full
                                25000baseSR/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  1000baseKX/Full
                                10000baseKR/Full
                                25000baseCR/Full
                                25000baseKR/Full
                                25000baseSR/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 25000Mb/s
        Duplex: Full
        Port: Direct Attach Copper
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        Link detected: yes

Fixes: c8907043c6ac9 ("ethtool: Get link mode in use instead of speed and duplex parameters")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reported-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ethtool/ioctl.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index cebbf93b27a7..943162ef080c 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -422,11 +422,31 @@ struct ethtool_link_usettings {
 	} link_modes;
 };
 
+static int
+ethtool_params_from_link_mode(const struct net_device *dev,
+			      struct ethtool_link_ksettings *link_ksettings)
+{
+	const struct link_mode_info *link_info;
+
+	if (dev->ethtool_ops->cap_link_mode_supported &&
+	    link_ksettings->link_mode != -1) {
+		if (WARN_ON_ONCE(link_ksettings->link_mode >=
+				 __ETHTOOL_LINK_MODE_MASK_NBITS))
+			return -EINVAL;
+
+		link_info = &link_mode_params[link_ksettings->link_mode];
+		link_ksettings->base.speed = link_info->speed;
+		link_ksettings->lanes = link_info->lanes;
+		link_ksettings->base.duplex = link_info->duplex;
+	}
+
+	return 0;
+}
+
 /* Internal kernel helper to query a device ethtool_link_settings. */
 int __ethtool_get_link_ksettings(struct net_device *dev,
 				 struct ethtool_link_ksettings *link_ksettings)
 {
-	const struct link_mode_info *link_info;
 	int err;
 
 	ASSERT_RTNL();
@@ -440,17 +460,7 @@ int __ethtool_get_link_ksettings(struct net_device *dev,
 	if (err)
 		return err;
 
-	if (dev->ethtool_ops->cap_link_mode_supported &&
-	    link_ksettings->link_mode != -1) {
-		if (WARN_ON_ONCE(link_ksettings->link_mode >=
-				 __ETHTOOL_LINK_MODE_MASK_NBITS))
-			return -EINVAL;
-
-		link_info = &link_mode_params[link_ksettings->link_mode];
-		link_ksettings->base.speed = link_info->speed;
-		link_ksettings->lanes = link_info->lanes;
-		link_ksettings->base.duplex = link_info->duplex;
-	}
+	ethtool_params_from_link_mode(dev, link_ksettings);
 
 	return 0;
 }
@@ -572,6 +582,8 @@ static int ethtool_get_link_ksettings(struct net_device *dev,
 	if (err < 0)
 		return err;
 
+	ethtool_params_from_link_mode(dev, &link_ksettings);
+
 	/* make sure we tell the right values to user */
 	link_ksettings.base.cmd = ETHTOOL_GLINKSETTINGS;
 	link_ksettings.base.link_mode_masks_nwords
@@ -673,6 +685,8 @@ static int ethtool_get_settings(struct net_device *dev, void __user *useraddr)
 		return err;
 	convert_link_ksettings_to_legacy_settings(&cmd, &link_ksettings);
 
+	ethtool_params_from_link_mode(dev, &link_ksettings);
+
 	/* send a sensible cmd tag back to user */
 	cmd.cmd = ETHTOOL_GSET;
 
-- 
2.26.2

