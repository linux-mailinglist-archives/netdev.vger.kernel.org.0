Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791786C6631
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjCWLLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjCWLLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:11:51 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE3E1B304
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 04:11:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d1CoL6YaiJu6XACAr7a3YpE/Ts4awqDS8MZAqe/G72OiNp1xO9HJW6gE51BXGaK7D3+Fc22wfXT4WN04RXqlk6IR4firrCfdU5dLDjeNDmNpdDMS3mv67cbAxp9/yAgKD36Tp6EMv3WyRMjQLkHGun/9N4k/6pLeHnaz8MX42e00MlEnDBne1xoFfrBLnlelj5q5Ujvzqkk+q3j+O3qY7d4wDQeXjJGICanPQBTi4Fq6bhtVnwYnZvZc1GzIRpCpj4z58mpePLM4BsyhRKyPhlf9I5BSjLWiKHzAG2vSHQKCkImwP2YYmQGDPLVDSd4Xudoi/9/MJTJLjG+yY86z/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QtIVrGPElJ5B5R9iuJfM4uVEo/NhjJk7R+s6tFRnhts=;
 b=hCrJ9kyjCbCXUPMuBdNPrSErMTGtvnWxaSjkDqOnDj4i8k2HwnfedNgRdL4dSznyTJdDIYOuuDZ/Ac/NZ1tWYFxCLeVCo6XbCQbF6gj+HKf7OBNVTqisRaDrBZKGFe60q7OJI0HBzDD2FrKukD5gXXE8YZu7ENKxPBMsM7ckp5RuPZHJB69n+TjniGTGdXdO6gdnb+EDUWuU+I9F+kt672SBEAZFFDYXlFPANGIWJD6d3CpiV9Wv9nJpvvMEiW78xasBbbhqA2Rp/zzgt3a5yibd+0z7EHT2J7DRGq1P8m6boJAAHuMo+zO6kEyVc2Iz6C+N6jXwNNXImIkoXEv0kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QtIVrGPElJ5B5R9iuJfM4uVEo/NhjJk7R+s6tFRnhts=;
 b=nJNbCkQZ3hSfd+6e9d+0g1IItOyzbjZgtBGUgo8ICNpUunUxocePFtWoL/YmlWpYd16hgA6YJU2BE9veGgwoQYqUKUTP31PivqoM6pUINQtmomJcgrMUkpkF172z9wK2QkHRBLzBIDJk5K4puQSkJCksXFClR1VAKzLrXsROAyY2uDjxP12URKAkQU3m1bOsUQMi1SG56SzWTAt6GJd/+cNe+ZP8bFn7ocf41ru/mC01KUyoHf0+qykReU+znymWJB63Xg24imj+zlusPEWHDFIpHtUNcK5Wo2YOhHCAzoD8OMAc55rSs6eibdNOORNRpmQphURLZW/Xb4jehz7dKw==
Received: from DM6PR08CA0013.namprd08.prod.outlook.com (2603:10b6:5:80::26) by
 PH0PR12MB8173.namprd12.prod.outlook.com (2603:10b6:510:296::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 11:11:47 +0000
Received: from DS1PEPF0000E650.namprd02.prod.outlook.com
 (2603:10b6:5:80:cafe::4f) by DM6PR08CA0013.outlook.office365.com
 (2603:10b6:5:80::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38 via Frontend
 Transport; Thu, 23 Mar 2023 11:11:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0000E650.mail.protection.outlook.com (10.167.18.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Thu, 23 Mar 2023 11:11:47 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 23 Mar 2023
 04:11:39 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 23 Mar
 2023 04:11:39 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.5 via Frontend Transport; Thu, 23 Mar
 2023 04:11:36 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH net-next 0/4] devlink: Add port function attributes to enable/disable IPsec crypto and packet offloads
Date:   Thu, 23 Mar 2023 13:10:55 +0200
Message-ID: <20230323111059.210634-1-dchumak@nvidia.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E650:EE_|PH0PR12MB8173:EE_
X-MS-Office365-Filtering-Correlation-Id: b509748e-0437-490b-4c86-08db2b8f64f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h0fxtiqvQzoF6Qo2eRfQ7wFW+jgwR6FMqIvEfQteQkZ8RN9Dp63bZEquA1c5GqNzYC/TOBLv66WHuPBMRd4IstIBhMUb2UrhnBMKA47BTixK2mZZZB1+7Pvd/CS3JihkM/pfv21v88M+0coAT73pC+YNKfaLMJjT7Hu3kR80Dm3A+S5fU8NAl01PnFAZx0/DBF6Eqely/Ilux7Jyl8sL2Hsfl8ktvhz6wDhpdjvX10JszjQYrnV5Pn1BwvVg8F6LumiJE+FgIp1fEUm6gIvwMKu7B3MRpJlCyLe2q9DpjkNpGAhDx40FCLXEv3+9Yd8QMGhHwGJvQjS4VUB3jdR7z/wftml6IhP88G6FX7ZDPNWOtPfaa408Iop+LMFuaYxnofNc19uNdH+YNc8mlZvgaTMLkaIqzU3KxVLTD8KfLFfP2thcFXhPKOr8yf0L3TqMBd/anyXDUbkwoKp7Gsul/EdLRciay6HDY32h8bpvVVaSMibGING0oSv2Py6z6zW3GFU0347zxh0NC+i4AmR2WMjESKWtWafr6VAYBeXo4cHEQx9YiLxCHQ83yv8M/yTHd7k2hcs7rRcLaYo9w9AUvXu4PmTb5N95IF8evzO5FtVHVN6iEYDT8LsHcIeBwL2ib04LeqD0GhWYNfsjOgp9am3wkiw7a5zSmVuVHa7Nk4aSa3kC9KkcdD7S0VeR9BrjL4Aw8epf4lxX+wCbc8mQ4jU1XAinjmH5SxbLqfpQwRgdYDW/0iMZgT/XRJOX7KDK
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(346002)(376002)(451199018)(40470700004)(36840700001)(46966006)(356005)(40480700001)(2906002)(40460700003)(478600001)(83380400001)(7696005)(2616005)(336012)(186003)(36756003)(86362001)(82310400005)(316002)(54906003)(36860700001)(4326008)(8676002)(6916009)(70586007)(70206006)(426003)(47076005)(107886003)(6666004)(26005)(1076003)(8936002)(7636003)(5660300002)(41300700001)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 11:11:47.5569
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b509748e-0437-490b-4c86-08db2b8f64f2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E650.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8173
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, mlx5 PCI VFs are disabled by default for IPsec functionality.
A user does not have the ability to enable IPsec support for a PCI VF
device.

It is desirable to provide a user with a fine grained control of the PCI
VF device IPsec capabilities. 

The above are a hypervisor level control, to set the functionality of
devices passed through to guests.

This is achieved by extending existing 'port function' object to control
capabilities of a function. It enables users to control capability of
the device before enumeration.

The series introduces two new boolean attributes of port function:
ipsec_crypto and ipsec_packet. They can be controlled independently.
Each to provide a distinct level of IPsec offload support that may
require different system and/or device firmware resources. 

Examples when user prefers to enable IPsec packet offload for a VF when
using switchdev mode:

  $ devlink port show pci/0000:06:00.0/1
      pci/0000:06:00.0/1: type eth netdev enp6s0pf0vf0 flavour pcivf pfnum 0 vfnum 0
          function:
          hw_addr 00:00:00:00:00:00 roce enable migratable disable ipsec_crypto disable ipsec_packet disable

  $ devlink port function set pci/0000:06:00.0/1 ipsec_packet enable

  $ devlink port show pci/0000:06:00.0/1
      pci/0000:06:00.0/1: type eth netdev enp6s0pf0vf0 flavour pcivf pfnum 0 vfnum 0
          function:
          hw_addr 00:00:00:00:00:00 roce enable migratable disable ipsec_crypto disable ipsec_packet enable

This enables corresponding IPsec capability of the function before it's
enumerated, so when driver reads the capability from the device
firmware, it is enabled. The driver then is able to configure
corresponding feature flags of the VF net device to support IPsec state
and policy offloading.

Dima Chumak (4):
  devlink: Expose port function commands to control IPsec crypto
    offloads
  net/mlx5: Implement devlink port function cmds to control ipsec_crypto
  devlink: Expose port function commands to control IPsec packet
    offloads
  net/mlx5: Implement devlink port function cmds to control ipsec_packet

 .../ethernet/mellanox/mlx5/switchdev.rst      |  16 +
 .../networking/devlink/devlink-port.rst       |  54 ++++
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   4 +
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  18 ++
 .../ethernet/mellanox/mlx5/core/esw/ipsec.c   | 299 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  34 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  27 ++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 200 ++++++++++++
 .../ethernet/mellanox/mlx5/core/lib/ipsec.h   |  41 +++
 include/linux/mlx5/driver.h                   |   1 +
 include/linux/mlx5/mlx5_ifc.h                 |   3 +
 include/net/devlink.h                         |  42 +++
 include/uapi/linux/devlink.h                  |   4 +
 net/devlink/leftover.c                        | 110 +++++++
 15 files changed, 854 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec.h

-- 
2.40.0

