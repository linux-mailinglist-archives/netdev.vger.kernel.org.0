Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B933E5954
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240247AbhHJLrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:47:04 -0400
Received: from mail-co1nam11on2066.outbound.protection.outlook.com ([40.107.220.66]:16960
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238497AbhHJLrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:47:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2mwrCO7+qk8OWsS9tuozIcVF2SiCvTCczaA16VA3iy56grlv3RicBGGHLrbj2IGecfjnhWBn/1v1H23qTaNY5wQ30Xf+B3Tg5lXe9PB951k26LeE4EiWHgbCKids5Lj7PZleo0dc8TY+dIEpb0y2CjAUfBvlc8mMiNMQkDmor2pQI8EEg2JY5IyOL1IZogUydO5dp5g64qf67lX6xzYMQZl84nIuQNtHXtatQtRnclbM7IhkFPqLbGFGT43PEdkdajp/XhLrrC0onVPKquw/aNVhPEQeC0upK6PwqMZZm9B31Nv8cCVLzc5yBIBr7xWBRcFRKwXUnQEcDNJLRzI4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5VNbBe7OY35PU74n5lXT3FspJbIoLV5b/K0G1/4diTA=;
 b=m7h0QhzyE4e2X7Fci+hfdL6+P8anDcIRn7lu/NGjaDDkVDebA/rnFWawPO/tWhLbBwlJM4HCKnkYpz8IApbTiPpckPeY7Iof/wOv2+q9YE+49X/upcz+prC9YCofpaNQbLk7y0wjtLFa3MqI+cmJaerVjeW3f5TleKjTmTF/RXnKFyimUKGaAvfg6fM9pikR+gL4dKkIaBeYsothZ0FII4JaPZBwA8hHCRAuozW+XZMUWD+nknUcWC6FXRH3+welzi2sefyUcV0JpdbMExyFy7nHOBQNThYDdbUJZLFbk1RSViFmj9FmwCHZc5QrGnm+oTDSBRaNuNiUeShvFEgu/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5VNbBe7OY35PU74n5lXT3FspJbIoLV5b/K0G1/4diTA=;
 b=a3xz85IQlClbCJofw2I4sFfv0KqgcCq/k7ciFBsGGUkuNJYzPrLwOabxqetaeQvlYFgUYyiD4n5eZ6IBpmZAT4abjbS4GA+I3wluO2UOGchFgeNF1nJT78+1N4/GJ08Dug4HhmUX5bO/arCdOky54YJQhGHrLQX2MlJoGEhkEwjSOMZX3ZYtR7zdBf/lm+MFhZX8WZ8XjhrEsV3bGEa24bnly8CvRBF5tG3holFwhGaawOi759g3ss97IGdGCfuoimuoB+RFdO5VZsQaH/9fmb6h+Us2FSLID3B4CJineloYpajRnJYFDOSbWp+XP1TNz/e6Cv44lSG/8Jjd27w8kQ==
Received: from BN9P222CA0016.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::21)
 by DM6PR12MB2937.namprd12.prod.outlook.com (2603:10b6:5:181::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Tue, 10 Aug
 2021 11:46:39 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::32) by BN9P222CA0016.outlook.office365.com
 (2603:10b6:408:10c::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend
 Transport; Tue, 10 Aug 2021 11:46:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 11:46:38 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Aug
 2021 11:46:37 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next 00/10] devlink: Control auxiliary devices
Date:   Tue, 10 Aug 2021 14:46:10 +0300
Message-ID: <20210810114620.8397-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97523cc5-c175-4982-27fa-08d95bf483d1
X-MS-TrafficTypeDiagnostic: DM6PR12MB2937:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2937B9D688E45089A6A768D6DCF79@DM6PR12MB2937.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PLNcDx9uHa3he/9bit6YzAEExNDos8kQr2bnaI5T5venT388uIk/cHDAE0d6IqNVQ5GgHxytyQrujD8P9aI6COkCnjAwJFgubzc4+WsEhR7Jt1upAkpzTb19WWfGKZ3+UILDe4599ENAfQTQfO/Qhdlap9iSi5yN4Tnp4NBUkqnqr7UGGPFpUaYAK7/Th7XCRpU627075LZb+uji9MzCH7JFriighzzWGlQ+oQNR2qhjZMOvlmBC/UEQJSyoCHjYjhKNtGvRdVPkZguBCkXQMbzRpcUEsO2CjSTBdroKTteNawkNlPA+EM2nitBxUkMbjS2DAnifwJDt57RvWViOPeFvi997dzd0QnMQjS7UHU4mSVuAimDI2xhI2EL5viJi8MI15cR66hWGR2I/k9UACswr7MzoKiGkXFXJsMGovJYhLHvs4cwMcf33koXwvZ8PLiJbTItZU6awgWGverriBNwRPgRwux39gcDG32AdQhd0aM9EnBTByYnbZ+fx0FihYs2GkwHu4rDXskvOQ+pvRm+fj/qaMDU2+OeoXRSckAeom9enpiMee6tXbcUn1+U7J1peC40Q3/0tT2igMFoKFQLlJqvK8K1mTHXMT/Hohcuzqnr4l9HybJZJW7LUaWYiS42af968MdKaXpDIglyRd9bBIfQ01pHTfQH17NMZTkVW1OALcwMh4lIytuVZyVUDs+k+exv0EYq7wxgzOGLeqKAIM1rwb80JmLDHd58mwF/u8/56Sh9Y+Zz+KLfx1vRFef5gmctniNDIl/bHsXH6nEHkUOefzVpWGEXVYghO8NQ=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(2616005)(356005)(16526019)(82310400003)(8676002)(316002)(36906005)(186003)(966005)(5660300002)(36756003)(6666004)(4326008)(70206006)(8936002)(70586007)(110136005)(426003)(47076005)(107886003)(2906002)(83380400001)(508600001)(7636003)(36860700001)(1076003)(86362001)(336012)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 11:46:38.9587
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97523cc5-c175-4982-27fa-08d95bf483d1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2937
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Jakub,

Currently, for mlx5 multi-function device, a user is not able to control
which functionality to enable/disable. For example, each PCI
PF, VF, SF function by default has netdevice, RDMA and vdpa-net
devices always enabled.

Hence, enable user to control which device functionality to enable/disable.

This is achieved by using existing devlink params [1] to
enable/disable eth, rdma and vdpa net functionality control knob.

For example user interested in only vdpa device function: performs,

$ devlink dev param set pci/0000:06:00.0 name enable_rdma value false \
                   cmode driverinit
$ devlink dev param set pci/0000:06:00.0 name enable_eth value false \
                   cmode driverinit
$ devlink dev param set pci/0000:06:00.0 name enable_vnet value true \
                   cmode driverinit

$ devlink dev reload pci/0000:06:00.0

Reload command honors parameters set, initializes the device that user
has composed using devlink dev params and resources.
Devices before reload:

            mlx5_core.sf.4
         (subfunction device)
                  /\
                 /| \
                / |  \
               /  |   \
 mlx5_core.eth.4  |  mlx5_core.rdma.4
(SF eth aux dev)  |  (SF rdma aux dev)
    |             |        |
    |             |        |
 enp6s0f0s88      |      mlx5_0
 (SF netdev)      |  (SF rdma device)
                  |
         mlx5_core.vnet.4
         (SF vnet aux dev)
                 |
                 |
        auxiliary/mlx5_core.sf.4
        (vdpa net mgmt device)

Above example reconfigures the device with only VDPA functionality.
Devices after reload:

            mlx5_core.sf.4
         (subfunction device)
                  /\
                 /  \
                /    \
               /      \
 mlx5_core.vnet.4     no eth, no rdma aux devices
 (SF vnet aux dev) 

Above parameters enable user to compose the device as needed based
on the use case.

Since devlink params are done on the devlink instance, these
knobs are uniformly usable for PCI PF, VF and SF devices.

Patch summary:
patch-1 adds generic enable_eth devlink parameter to control Ethernet
        auxiliary device function
patch-2 adds generic enable_rdma devlink parameter to control RDMA
        auxiliary device function
patch-3 adds generic enable_vnet devlink parameter to control VDPA net
        auxilariy device function
patch-4 rework the code to register single device parameter
patch-5 added APIs to register, unregister single device parameter
patch-6 added APIs to publish, unpublishe single device parameter
patch-7 Fixed missing parameter unpublish call in mlx5 driver
patch-8 extends mlx5 driver to support enable_eth devlink parameter
patch-9 extends mlx5 driver to support enable_rdma devlink parameter
patch-10 extends mlx5 driver to support enable_vnet devlink parameter

Subsequent to this series, in future mlx5 driver will be updated to use
single device parameter API for metadata enable/disable knob which is
only applicable on the eswitch manager device.

[1] https://www.kernel.org/doc/html/latest/networking/devlink/devlink-params.html
 
Parav Pandit (10):
  devlink: Add new "enable_eth" generic device param
  devlink: Add new "enable_rdma" generic device param
  devlink: Add new "enable_vnet" generic device param
  devlink: Create a helper function for one parameter registration
  devlink: Add API to register and unregister single parameter
  devlink: Add APIs to publish, unpublish individual parameter
  net/mlx5: Fix unpublish devlink parameters
  net/mlx5: Support enable_eth devlink dev param
  net/mlx5: Support enable_rdma devlink dev param
  net/mlx5: Support enable_vnet devlink dev param

 .../networking/devlink/devlink-params.rst     |  12 ++
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  74 +++++++-
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 159 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   5 +
 include/net/devlink.h                         |  20 +++
 net/core/devlink.c                            | 124 +++++++++++++-
 6 files changed, 382 insertions(+), 12 deletions(-)

-- 
2.26.2

