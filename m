Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F16357EC2
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 11:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhDHJLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 05:11:07 -0400
Received: from mail-dm6nam11on2079.outbound.protection.outlook.com ([40.107.223.79]:34593
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229603AbhDHJLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 05:11:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b97V26MmenTYqilc4tordu3gZN2d6GAVFXwjDiXDjI9oQ4Q7oVX8DNOQt5QlHyw3RdqgMrNU83zINpdwdagyOCM67QZ9N8ZiPuo0KCkTBBUh22XjZp8WSrilAE/3ZoRG+AVW0Ls/tm1ffWnRZyQvh8K/NBKBpjpwZ7j5b/TyVWC7amiDBYf4c6c4B2Q3tTH/s4nER1Qduho/jUZ0YDzGInYKZMakAH+oO4nlODLj0FgGtDwf+wpmj/Gbl+oXsk0QeJxXt+lIFXbIH5zVKAqYR9SUviD+sfjaZpHVsl0Nsx3sVzlUqgrVNXCDvuGNjXNaI9WrUIDrp1JX4S3EvsaKGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGSaONj6Is+iGZ/3Cq17zOfiJTywuj6CcNOIk2l3xug=;
 b=cnSeSsI/Axm5PwiwyuVuvsu9asFll03Tx+OzvJ5LLGHiU8GQ5yCwWCJXbqXP/sRhFxQKqGcYg4Xv/GZQFxtkaFQyFzAgyNqMeeeVymSOmVk4n5h+FzlW2cIdzdreLcUtLdGDTPETqcgILewlchuWs+VhpqpsU1wHD11373Q25CEqC8vT5pOih3W/ce/NqVuL8762Z4ks+rfWeawhwFbS9Xe6XnJLtxAnOK2naF9d1rqlqONmFaVFKle7n/zxtHJ63ViQHQPdfoG2o7emOzpIoICyv3VYhZzlltGkUgG/JLNIqZOsVxUqZhkFixnE3uGRgaywRgRagulcPZ3NgToFiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGSaONj6Is+iGZ/3Cq17zOfiJTywuj6CcNOIk2l3xug=;
 b=MAMjh9p5A4sl3yQ9qbul3181XDlaLHzS4Xq4HnLfAkkTxw6/ixt0GCh/R/ucTeKTLYpTL1kTCLyzSnjCh717l1Cv3xkCHIWLqgWNRR+yHaN8xEtBDrcYHD9LzpvyprIOS3iMVCRouuYN68FWFi96aNKTmW9UdeCBbFvw1BRlvduhdysdmfy/BRsr5UVdNztaCqoh5WJqF47oMedEmZCrjQUDR5P+lpR1Zqw5V/AZxUaAACAheErjE45oFuMQ/AqSSh/FJTfCVBsrmvxl+iMro50HgP4jsDvmL6c5A8mvFRgm9atl0O8k7jFgpBhV2cIu3lFF4XUFg3az3s1deF3lcQ==
Received: from MW4PR04CA0072.namprd04.prod.outlook.com (2603:10b6:303:6b::17)
 by BN8PR12MB3010.namprd12.prod.outlook.com (2603:10b6:408:63::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Thu, 8 Apr
 2021 09:10:54 +0000
Received: from CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::b4) by MW4PR04CA0072.outlook.office365.com
 (2603:10b6:303:6b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Thu, 8 Apr 2021 09:10:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT068.mail.protection.outlook.com (10.13.175.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 09:10:53 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 02:10:53 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 09:10:53 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 8 Apr 2021 09:10:50 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <si-wei.liu@oracle.com>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Eli Cohen <elic@nvidia.com>
Subject: [PATCH 0/5] VDPA mlx5 fixes
Date:   Thu, 8 Apr 2021 12:10:42 +0300
Message-ID: <20210408091047.4269-1-elic@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ec79710-5755-4564-c20b-08d8fa6e3670
X-MS-TrafficTypeDiagnostic: BN8PR12MB3010:
X-Microsoft-Antispam-PRVS: <BN8PR12MB30107D95211AB63ECC884CC4AB749@BN8PR12MB3010.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: flItQN5bwKkbkGLtRzYJu6QCwWF3wrEseEftbvHGIOh3u/3+qkwtE3vYCjaSbQXXysF/+TXkHSyzH/BZif4vLEaSK9tcUHxHoxzjiwFtfIL6mw3Lavpnf6Tc2lI4tLr7pTSqL+b0KPrYnlSxk3rNJohdJSma9XwWaxnyhpXiAjUdU8ry+vSGHHW+Eg08VXLvTkueNe/Kfyp1O+2rQShLR61dM5o3BdC9GnKNDBk8UI+NQTLorrVVOXk0Qxt1aGEiJwwuDj3aSStHizsjF5GNGenKRcy1TOOq1RwyDHKjKBGEXZoMCyPnAHO9fbwJ4vjJYB/X2EmuTnSz7btNa2FwAKsqIw5MtMRbCSdLj6I33cK5gKHib2HOeBnDc2DvsgKSQHIP/sGVHGg4C0tOUhzGWn+SSvsTrzVuhe6PoeQ6CWUftz98PkS/DDjEOtItXx7u0G+2JF4/MnssfKIW8bTAPFfIoqb7JZkfB2JMubiAnIKYGDnDfjZ/tnGpyMd73wYrySfSudvx4v04VrhHGFx/bWdWl4nNZXBUX0yYub9ZWlU39COnEb4hw8k9feALcbUVZlUqLW8AP4c1DR/hMpi9ZMt46IxbaxvytyX/IQqS5sEIT8l+oi1pPdykLnqfisl4IRR/hNlHRsZb4HOXQytbcPY+W/4RCx/L2JqbfFYcT5Mx0JH6qZBsYWpYzuMWzZT9aN3MOf59fIs1arIypPpfDrV6v3SkduZQwhBI5gxx+ec=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(346002)(36840700001)(46966006)(316002)(26005)(107886003)(186003)(8676002)(5660300002)(54906003)(110136005)(478600001)(966005)(47076005)(36860700001)(83380400001)(82740400003)(8936002)(7636003)(6666004)(356005)(70586007)(7696005)(336012)(70206006)(2616005)(426003)(36756003)(1076003)(2906002)(82310400003)(4744005)(86362001)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 09:10:53.8601
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ec79710-5755-4564-c20b-08d8fa6e3670
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3010
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

The following series contains fixes to mlx5 vdpa driver.  Included first
is Siwei's fix to queried MTU was already reviewed a while ago and is
not in your tree.

Patches 2 and 3 are required to allow mlx5_vdpa run on sub functions.

This series contains patches that were included in Parav's series
http://lists.infradead.org/pipermail/linux-mtd/2016-January/064878.html
but that series will be sent again at a later time.

Eli Cohen (4):
  vdpa/mlx5: Use the correct dma device when registering memory
  vdpa/mlx5: Retrieve BAR address suitable any function
  vdpa/mlx5: Fix wrong use of bit numbers
  vdpa/mlx5: Fix suspend/resume index restoration

Si-Wei Liu (1):
  vdpa/mlx5: should exclude header length and fcs from mtu

 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  4 +++
 drivers/vdpa/mlx5/core/mr.c        |  9 +++++--
 drivers/vdpa/mlx5/core/resources.c |  3 ++-
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 40 ++++++++++++++++++------------
 4 files changed, 37 insertions(+), 19 deletions(-)

-- 
2.30.1

