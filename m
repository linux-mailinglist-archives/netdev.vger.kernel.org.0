Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C9D4ADF19
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352438AbiBHRPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352657AbiBHRPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:15:07 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E4BC061576;
        Tue,  8 Feb 2022 09:15:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pafd5G00znU2tEhLiKdU5qbVB6UbTwFkZBKRdgjpEP+Pa2I2xWvonpsSD5WycR8gr0jPzsgjjgdnj0/uHrjr36kwiM0aQBR8m7yXzb4Y/h+S0jJU05X7Ex3rD95y3D/j3Zva2T/AINNouGtI+Xirw9iwPls58uJZWZmjVLnZNHZoBrr0fCWKBJzmwXtXGLpK+Mn8jti84Vo6H1otBtBskqKD6WGmQcdDw3FbacSRwX9CpaS93YAGNfHHRvYNw83hV7AT/RNW08p4g8JBQeXcBAicyuMczROrYEwpFfGEFDA/4VRKAyw8kjkZQ7Ep4MDdIldrg/H3C+c8snqMgumwIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vIm+7DXWqyozF+Wh+jrKS1y3QEhSQ40IiUGK6OZcX90=;
 b=Ix0n5zGH3Jn8DvPSFbyJ7meAWXeYJXaWefBsf9VmgeB0dXZoCIMP3wyutz69UknAuxSjJ4fBt9U7uQMfw1OxQJahVElXjQ9NquoLN9o0C4ghUFpV3V18+0yRG6AqDVpVfmGjJS+y3C85ywSsyDpM5xknkJDqp9dP2wrqhqo/YWQ3EclgZs8uPCdz9y9l0Ao30zyAvARhxMqRsXLcutMSNXw9JEbxjpALGRiHxuapwsds4T5jlmIBHQs0KD+tK6+lgxTTBgMm7ifTSKDlvLU2/Y4RVXYnukv0+ZAVU35uyspWiNiSELhwMd27av6E2eiRloU4LBIm59eIa8/NAbaeVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vIm+7DXWqyozF+Wh+jrKS1y3QEhSQ40IiUGK6OZcX90=;
 b=jCmI7VwYXlZT6HTCV6swrtEPIVLrcJjPuCyeA76mPZO3eKwG5guey77ZXBzCrGuHL22HujBdhQtCby5PjsC4zBmcLz+J/oEUkIfMOw4x0qmbsg866mxZduCLwX9IbGe7WeMvfv3nn6bRC/D4rmvjOKuT5MhdNJzo6Rq4p32k/aoK6HTNKGJFFFTsiumws/2vadV8xXJ11g3DrsVHcZPCRQ+jpnrIGLJRqwuDtujrE9oHuK0s0v+LC60tJ94iVJKwDGKUJI2lBDkU0jrqjdPq45td8Qem14CtkG095YcZhsZuWSttq1C2FuPEIcAaCeNmfT7NLgWZDlcGiNtuwfefHw==
Received: from DM3PR11CA0013.namprd11.prod.outlook.com (2603:10b6:0:54::23) by
 BYAPR12MB2821.namprd12.prod.outlook.com (2603:10b6:a03:9b::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.18; Tue, 8 Feb 2022 17:15:03 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:54:cafe::2) by DM3PR11CA0013.outlook.office365.com
 (2603:10b6:0:54::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Tue, 8 Feb 2022 17:15:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Tue, 8 Feb 2022 17:15:03 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Feb
 2022 17:14:44 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Feb 2022
 09:14:43 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 8 Feb
 2022 09:14:41 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 0/4] net/mlx5: Introduce devlink param to disable SF aux dev probe
Date:   Tue, 8 Feb 2022 19:14:02 +0200
Message-ID: <1644340446-125084-1-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c094671-7c6a-427c-d0c4-08d9eb268ba9
X-MS-TrafficTypeDiagnostic: BYAPR12MB2821:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB282126D0F2D83AC4BED5C01AD42D9@BYAPR12MB2821.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ImhXMZnpAx1ksNukUj8EI+ZLG0q4dynOwUd3LO7W3p/qrm4nZk1Z+PSetsSnyAzhkuiABQEfuRwAH+YZ0jwV62xU/xWSABV6m+I646yUUyYGRhJ2xuwCfJ/8upvJ81l2eIAXekWsnNbFL80biI4j5PGEM8eVJ4FWLRlQpbsWhFMHBwDEApElK0jOrEqWUuEMUWwXWOM35zeSKkI63eivbPGxH9zOPQPbdujk+2+b3lApwaN/jIz++EBvPoqoyGu3gfjlDsRYCjj40LWwlQhv7SKvZ4E3KXdnzO+37qBSN7YwyUs2uHMeAeTv9DPI7eoxMIy0sHHRPwXbxdcwhuRfYBJRV4to3Fu8+hYwFqjZGgoUGaKibcPBp19r9ZT/qrjlA2AByupeEAMAW//O/K4Q6HEm6x+rGuiytIQaG2N04sLyABPQQswN85GAqKdrlZ2EOnMCMgOJWU4kUfa+B4YZlrN/ftIRwZgLyuDvvHOZAfNl2QY9Pd46ZIxBriaqZGVEnmmAt2kaxGJtZyqXqE6kCUxGsybLGQJy+hs9xpEgnV+g1h9c0GIdv9B4mhLtDUTZVxatbJAp2RMzRbW3cosoT/ggE742MznSd2NlhIvBPpOGjEORKZiIfBAIDMLoQpz9Gc6BjWZoN9Q2xdU0cdAdr+eRbmR/QyzDqYtDFt2jsGMHMwcTXpiXHd6jyp+RnN10kfGkt2YP+cRKznMmXpZuQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(40460700003)(36860700001)(508600001)(86362001)(8936002)(6666004)(336012)(426003)(7696005)(8676002)(70206006)(83380400001)(4326008)(47076005)(5660300002)(316002)(36756003)(82310400004)(81166007)(110136005)(186003)(356005)(2616005)(70586007)(26005)(54906003)(2906002)(107886003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 17:15:03.2676
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c094671-7c6a-427c-d0c4-08d9eb268ba9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2821
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
controls the creation of SFs. This parameter sets a flag in order to
disable all auxiliary devices of the SF. i.e.: All children auxiliary
devices of SF for RDMA, eth and vdpa-net are disabled by default and
hence no device initialization is done at probe stage.

$ devlink dev param set pci/0000:08:00.0 name enable_sfs_aux_devs \
              value false cmode runtime

Create SF:
$ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11
$ devlink port function set pci/0000:08:00.0/32768 \
               hw_addr 00:00:00:00:00:11 state active

Now depending on the use case, the user can enable specific auxiliary
device(s). For example:

$ devlink dev param set auxiliary/mlx5_core.sf.1 \
              name enable_vnet value true cmde driverinit

Afterwards, user needs to reload the SF in order for the SF to come up
with the specific configuration:

$ devlink dev reload auxiliary/mlx5_core.sf.1

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

