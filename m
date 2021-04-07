Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B23E356907
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 12:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350574AbhDGKHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 06:07:37 -0400
Received: from mail-bn8nam12on2058.outbound.protection.outlook.com ([40.107.237.58]:58887
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238559AbhDGKHa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 06:07:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+hG+0OayMyMpIPgHJ3e+rZgk4IEQY+kSU5T13ti2pVQQj7a8ymcw/0DgBLiRxAsidP4YLSRFfDOPGr216lMqKQtCmlw0C+WbgxVBH/riftkz6Oc37HvJLgqB19T8gax+UQPpXJzqErljmjDkweCqcYIWjKV5Yz3T1hQkfaoucu9WbRoAjTAuWcJ6WSvrrR3ibhwiEQE+jCOa/0gTLgiohFXLbi2xjLqQ4bPNtSCLBmh74YDmJfCSm/cYGiaAz3A/TPd5Ie+rY+vMVlCKteLwGUU/JZiKHYHe4TrHI9TMlJoYVJ6yUp2Tlv4NLwtjdTeYb7AH9L3Er8TpiYuFeZJ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gjZQRJkBhEymUUrOhrUPIjO55ByWk6oTc0krh2QTS2A=;
 b=Pkjf9ieztawazdbHJN58Y79vvQWbmSl8aXnKxMqFzAcnQPJmtIXdxqBaW9jeVRJNUJ/5ackpbl8Js68AyroGB7nOPp6ZoQIxtZQWzAJI+e2uT6o8E6knMZpWKJdjuHqRCWrCIzuS8VCnlwr5c2T0PlSJWAfL6vwSab6mW2+sWuTz6G5vpVTkk8GL9pj9GJP0mUV0IrMm9rvA3kTQd8G0KWc9DTRtk7DryyhYK9rDrdpMlHDda00c0WMsyFBWXlx8wIm2Y4M/CLTTdvMbqS1n/0qk38AqOUdjwrJlVn9tZpFTTzOx1egvLz9obJDqvI366i6Yb6jQFtS1Ra49qF68Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=embeddedor.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gjZQRJkBhEymUUrOhrUPIjO55ByWk6oTc0krh2QTS2A=;
 b=TaBJ410CahStdWp5xaoF2gGuyPt4CsSnzgpmEg5UyHen1IyP2vPrkdCsEAKOIlsakB9n/O8o7eK22ph+KEQjBAa5nujWomcWorIQAkNlhGUMAFJFxQnkH8UkRk8qe/9Nn2QwEcdiCDlZjvNFD9Bc6YOEueJCCDYMRq0U9idWXVhYbena7ITt2OEVY3omqZ3tjYLs0q8sp9x3VAlG0lrmbgB2mNwuyASa1GK9tRj70+vdUFWrQRLsGaFaQUdo89qH5nQM0vLoHn3KmIXKCSYRUrTq3JSVjZmnGXQRGVtrAu1eks1kPiD0IwCri1PE2uQveH9qtTMYtzL7RV7QWuQaNQ==
Received: from MWHPR18CA0055.namprd18.prod.outlook.com (2603:10b6:300:39::17)
 by DM6PR12MB3961.namprd12.prod.outlook.com (2603:10b6:5:1cc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Wed, 7 Apr
 2021 10:07:19 +0000
Received: from CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:39:cafe::38) by MWHPR18CA0055.outlook.office365.com
 (2603:10b6:300:39::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Wed, 7 Apr 2021 10:07:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; embeddedor.com; dkim=none (message not signed)
 header.d=none;embeddedor.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT024.mail.protection.outlook.com (10.13.174.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 10:07:18 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 7 Apr 2021 10:07:14 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <eric.dumazet@gmail.com>,
        <andrew@lunn.ch>, <mkubecek@suse.cz>, <f.fainelli@gmail.com>,
        <acardace@redhat.com>, <irusskikh@marvell.com>,
        <gustavo@embeddedor.com>, <magnus.karlsson@intel.com>,
        <ecree@solarflare.com>, <idosch@nvidia.com>, <jiri@nvidia.com>,
        <mlxsw@nvidia.com>, Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net v3 0/2] Fix link_mode derived params functionality
Date:   Wed, 7 Apr 2021 13:06:50 +0300
Message-ID: <20210407100652.2150415-1-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57d29d47-b2ec-408e-a25c-08d8f9aced93
X-MS-TrafficTypeDiagnostic: DM6PR12MB3961:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3961C3182150369A8CD22F90D8759@DM6PR12MB3961.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FlF57Npu1JfIMzma7yhvgxkNRf8inCxtmAzMY4vgFhTOZJP1lF4EpFpLKJWjK5acLiwzemjLaV4mbEIIXDxC1GJzFG8hvBH62Zhpk40nTR0vDPC3lbq6P0A9QwECrPThq4kbfVmadkyfAyS1GLXB/pBLsjP/amegIsXW6wuFmkL6GajgsCPg9/swJ3jwoVYko1BfHjs04+W56YL1OhYPV4WeOrLDC0KYznU7M7P2DiL3CLcpNydINRPpX1wAKi6Qbry+08/I6HWS1QM+BJ5MI2FZ56aWgGMqr0EPmSykGgLHs3iZmKy4IumfZzm3pSIRqxR8VQwx3NiGZIDF3mtIBXj6fKPcpq0s7GSEolY1ICGKEqaF7u0Cz+QgxODkuJtipELO5E0aRgSP3Q0vUKnPz/D49AdCURsyYnzPKGUmCWu2f1rqQwddyq1pgfi7WkZqOdVjeEjLlYfIu9A+EJJlmryGVJxYdmonUMZe+bBxUwUREl7Qg1CQl1akidlI/0kql1bFxuIEs3g0u5EB8GnDAvWkLH+DcXTsksShZD6JCzQgzwqKZxUx7A5USnTzkX+XRQZrSnYDe3I288ckmsSsMqgWAwfDtf9itK4dT/TxCPAr2aWLQzd8/pkeBzEcWWuuMMcyhDEYHs6o1w7EL6ptpPhEC3CgUFoikLRfQYu4n7M=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(136003)(39860400002)(46966006)(36840700001)(16526019)(186003)(356005)(107886003)(47076005)(82310400003)(8936002)(2616005)(82740400003)(4326008)(316002)(6666004)(36860700001)(7636003)(26005)(336012)(478600001)(8676002)(6916009)(70586007)(426003)(70206006)(54906003)(86362001)(7416002)(1076003)(83380400001)(5660300002)(36906005)(36756003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 10:07:18.7492
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57d29d47-b2ec-408e-a25c-08d8f9aced93
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3961
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, link_mode parameter derives 3 other link parameters, speed,
lanes and duplex, and the derived information is sent to user space.

Few bugs were found in that functionality.
First, some drivers clear the 'ethtool_link_ksettings' struct in their
get_link_ksettings() callback and cause receiving wrong link mode
information in user space. And also, some drivers can report random
values in the 'link_mode' field and cause general protection fault.

Second, the link parameters are only derived in netlink path so in ioctl
path, we don't any reasonable values.

Third, setting 'speed 10000 lanes 1' fails since the lanes parameter
wasn't set for ETHTOOL_LINK_MODE_10000baseR_FEC_BIT.

Patch #1 solves the first two problems by removing link_mode parameter
and deriving the link parameters in driver instead of ethtool.
Patch #2 solves the third one, by setting the lanes parameter for the
link_mode.

v3:
	* Remove the link_mode parameter in the first patch to solve
	  both two issues from patch#1 and patch#2.
	* Add the second patch to solve the third issue.

v2:
	* Add patch #2.
	* Introduce 'cap_link_mode_supported' instead of adding a
	  validity field to 'ethtool_link_ksettings' struct in patch #1.

Danielle Ratson (2):
  ethtool: Remove link_mode param and derive link params from driver
  ethtool: Add lanes parameter for ETHTOOL_LINK_MODE_10000baseR_FEC_BIT

 .../mellanox/mlxsw/spectrum_ethtool.c         | 19 ++++++++++++++-----
 include/linux/ethtool.h                       |  9 ++++++++-
 net/ethtool/common.c                          | 17 +++++++++++++++++
 net/ethtool/ioctl.c                           | 18 +-----------------
 4 files changed, 40 insertions(+), 23 deletions(-)

-- 
2.26.2

