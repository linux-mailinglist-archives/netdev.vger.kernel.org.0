Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9554B2193
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348499AbiBKJVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:21:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243957AbiBKJVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:21:09 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2068.outbound.protection.outlook.com [40.107.93.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542C6337;
        Fri, 11 Feb 2022 01:21:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TkUmNx67CfW5Vm6xzyJILDI7hIduT+2B3DyLfanc1HZjfXnd0HLavDQHlwHvXX5XACIZMmhWoytbbcXphBh8HCFrX2KD4+HJJikSMj/skEwCgPmNW9g7ww9jjjBSAk+m+tM4gPqXiFV/RoqBnOhleZVxrSG3TYOAkctWs0L5cZU47cJathg08BIvjWfCcIs0ibYSwk8VOXOMZaE5TlvYQaCyF2rFSZbCc7iV0mTQcnjLTdnxDs0SOxGi/U2MNFi8CEBQgpEXLKwjD7PeXHCSQb7A4Qqs/ujJFoJFVeXfy6PwcaWIC+QOmRZHegEjGX9bx8rmVcDv0C3tl95Ondd56Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JyPU+RCSAr8gLZSijksUCPoMuqtD/hjzwy06yB+Y/8M=;
 b=V7l7Rg2RJziFHNvvo1Vgprb4PPpUmbUtohcBMb9aGgI5Z9vEjei8xKcLyFry0mbo0EHlEln5cK4gPxSFt+h3MyKoFqW743Qf2TP7MUiS87NOYSOicm+4YH/Oo7fbXOgCvcYFfbQASsn7OcQGs6U+Ifex0t5sOemw8kSNvwrAF/KgOAx7eHxGUliBEywwuYTnxUJxD6EgVRH5Sz/+zrvTnJ/1Nx/Ae6rzXhq3uYZxI+Xk+THwoF6HPpU9C/U7WF3A1tno2aZ+r22CLpeRg2E8pNUkPpI0WlEK/khi/lTiKHnj94re+QJfBL3DuaMMSNm+8Hxg7ymLovPNAWtfzC+W+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JyPU+RCSAr8gLZSijksUCPoMuqtD/hjzwy06yB+Y/8M=;
 b=hEwEHdYPIOgTR3oH0j1IBgIlqawOlBm/vr6HdvDb60SAPdscb+hZY3JzmeccGt1Qy6kNRUP53xg1eBTXNnJeOCkPUIaXMTYIOUzkk9HtN0XsuyZ25hOr5J6K/RUi5wpAZuiUCm5xcGrnsxnFq33jr5+sZ+TnJbD1MfNBKVygGq6ZGA9o33WAiNAciloYE9/doB75vGF18OxbSH9A88akTekeqjl0yqdPOkd7+slKVu/Cz1wgcSmVl1ymbMseb4F3q/5An+pUBWEUVjXoNPYuk90MYnSOy5KXY30Ne+WChqU03e32N3n4BkvMjk2EKSXxhA7TLEQV2kIFTQnpmg/k3w==
Received: from BN8PR07CA0028.namprd07.prod.outlook.com (2603:10b6:408:ac::41)
 by CY4PR12MB1813.namprd12.prod.outlook.com (2603:10b6:903:124::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Fri, 11 Feb
 2022 09:21:07 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::e6) by BN8PR07CA0028.outlook.office365.com
 (2603:10b6:408:ac::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17 via Frontend
 Transport; Fri, 11 Feb 2022 09:21:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Fri, 11 Feb 2022 09:21:04 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 11 Feb
 2022 09:20:53 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 11 Feb 2022
 01:20:52 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Fri, 11 Feb
 2022 01:20:50 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Parav Pandit <parav@nvidia.com>
CC:     Jiri Pirko <jiri@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 0/4] net/mlx5: Introduce devlink param to disable SF aux dev probe
Date:   Fri, 11 Feb 2022 11:20:17 +0200
Message-ID: <1644571221-237302-1-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7853481a-ad50-4cb9-0570-08d9ed3fd58f
X-MS-TrafficTypeDiagnostic: CY4PR12MB1813:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1813CD26BE516DD58D9F187DD4309@CY4PR12MB1813.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pxFRpZpBXJ3TCoqdsyIcryfjS+SMWmweyC1+zLoINMxg1SCcFyQFB9MGYXhjBfpYMWdmqUDCItyjbU6J79P573f8oBkm/GKjhEfZ24m3KESVrIjkYlLMMIOfXy/RB0y2gbnrrdxmSSQiO7f4n5lmOUmpRdjzVavzv7gSoPsKrfwxXYrOoIAIdLwRdeW9zIeZ25tl4wLaSUsBCoa2O5sPmNrBc/Hd54hgtuzg43E/sfiRU5vxQjlreheh2djLGqeQ/fh55nTkveLVGm2Lj5UJ94UJvJKhl8ieAsBxW0ylka7VsIUFBYpygKxWhC2KvASfD3TuRRBBdDWAVYxR3k3FeL1SRDq8lwFRowoFdSNDDsS5u2YQ21EBKzyF4uvFkH4SiMlX+Vw7j4xLaJAnJyCHMwWWTC2meBp7nt8zFeb/xoL/6TkQZ1NHXndaqgy1p9gUd7Lo/fckNPboO79/KML9NtCVSSC3obSkJTlEF5ykL1l4Mrg4RsMrvwhB6rRMgZM1BxiQvc8iKzcCq0pR/w+ybz46oJyxC2zOzqxnpWXf2Ta5J+lofFwKryFz204kKqXu4AB6+nCNeLHnL+vHGqVKT4Fpac9C0adwFw8GCwc9Wuo4TmKAi27YgpiHsTSbs0Ppg8780knoV2+6Ceuqt9E6QtyPbArwKyR4RcWcYy4CGj6lylr8b8Znxee7VM8b1E1vtaonNzwIz5Gc99xK8vG/vw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(186003)(26005)(2906002)(6636002)(47076005)(86362001)(426003)(81166007)(336012)(356005)(508600001)(110136005)(36756003)(40460700003)(316002)(54906003)(107886003)(70206006)(4326008)(8936002)(8676002)(70586007)(5660300002)(2616005)(7696005)(83380400001)(82310400004)(6666004)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 09:21:04.5030
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7853481a-ad50-4cb9-0570-08d9ed3fd58f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1813
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently SF device has all the aux devices enabled by default. Once
loaded, user who desire to disable some of them need to perform devlink
reload. This operation helps to reclaim memory that was not supposed
to be used, but the lost time in disabling and enabling again cannot be
recovered by this approach[1].
Therefore, introduce a new devlink generic parameter for PCI PF which
spawns SF devices. This parameter sets a flag in order to disable all
auxiliary devices of the SF. i.e.: All children auxiliary devices of SF
for RDMA, eth and vdpa-net are disabled by default and hence no device
initialization is done at probe stage.

The settings introduced here should suit either if ESW and PF are on
same host or not.

Example 1: When ESW and SF hosting PF are the same:

Disable SF aux dev probe:
$ devlink dev param set pci/0000:08:00.0 name enable_sfs_aux_devs \
              value false cmode runtime

Create SF:
$ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11
$ devlink port function set pci/0000:08:00.0/32768 \
               hw_addr 00:00:00:00:00:11 state active

Now depending on the use case, the user can enable specific auxiliary
device(s). For example:

$ devlink dev param set auxiliary/mlx5_core.sf.1 \
              name enable_vnet value true cmode driverinit

Afterwards, user needs to reload the SF in order for the SF to come up
with the specific configuration:

$ devlink dev reload auxiliary/mlx5_core.sf.1


Example2: ESW and PF are on different hosts.

Disable SF's children auxiliary device probing for the specified PF on
host:
$ devlink dev param set pci/0000:04:00.0 name enable_sfs_aux_devs \
               value false cmode runtime

Create SF on ESW side:
$ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11 \
               controller 1
$ devlink port function set pci/0000:08:00.0/32768 \
               hw_addr 00:00:00:00:00:11 state active

When SF device appears on the host:
$ devlink dev param set auxiliary/mlx5_core.sf.1 \
               name enable_vnet value true cmode driverinit
$ devlink dev reload auxiliary/mlx5_core.sf.1

changelog:
v1->v2:
 - updated example to make clear SF port and SF device creation PFs
 - added example when SF port and device creation PFs are on different
   hosts

[1]
mlx5 devlink reload is taking about 2 seconds, which means that with
256 SFs we are speaking about ~8.5 minutes.

Shay Drory (4):
  net/mlx5: Split function_setup() to enable and open functions
  net/mlx5: Delete redundant default assignment of runtime devlink
    params
  devlink: Add new "enable_sfs_aux_devs" generic device param
  net/mlx5: Support enable_sfs_aux_devs devlink param

 .../networking/devlink/devlink-params.rst     |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  16 ++
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  51 ++---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |   3 +
 .../net/ethernet/mellanox/mlx5/core/health.c  |   5 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 183 +++++++++++++++---
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   6 +
 .../mellanox/mlx5/core/sf/dev/driver.c        |  13 +-
 .../ethernet/mellanox/mlx5/core/sf/devlink.c  |  40 ++++
 .../ethernet/mellanox/mlx5/core/sf/hw_table.c |   7 +
 .../net/ethernet/mellanox/mlx5/core/sf/priv.h |   2 +
 include/linux/mlx5/driver.h                   |   1 +
 include/net/devlink.h                         |   4 +
 net/core/devlink.c                            |   5 +
 14 files changed, 284 insertions(+), 57 deletions(-)

-- 
2.26.3

