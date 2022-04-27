Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F036E5114AE
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 12:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiD0J73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 05:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiD0J72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 05:59:28 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC3C29A8F4;
        Wed, 27 Apr 2022 02:52:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lf6dUyQ0tKQcpPrSP24NKzcaUr+YM/I57rAQJ5Wsz3gPNIUrva2E7NoZapLk4Qf+oojZeFJomKkJ6daV3gwXDjs3zF3Zyy/jJpRJmReYO42RUv28S+E6rY92NrkNFliXpFjKJmcQb5TAqPw43482xJUn7DCYz0qC0KJRVE+03wJfeuN/MB2xGcKFYDXd2BIsgCQ2ymKLD7eI07LA/WliFVQ1zcvbh9oTPYsT/wbwd7VTCL2M154R92TWXUn6MuPbaagylU7LTovSuK1bv/eghBiDBQBc5NsSG7hxaxUBKTgCg678iqnuW0Oop3wBN5Ks51fIAdVKHiTh5JcZRYAzIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iwY5ZI+WmDsRgOabWiMXkrehavxkiSSYIUFfagZlpus=;
 b=JufwKkIctMGkWEyCImc75xlGjiNErwxpK8xP21rAag+nqruRLDRhAWIOdMak1BfxLQa79Q9Z5R0GNagBwCLlr/yF2WqlRhnCs7lBdMHaseGfkTEZuifnwkBNKquLyBBvk/e9/O3n5lIdXTyLNlPvIYZMsPA42cUcJaQIPxaXsa3XC97j7yoYWKXRZ0xR0DNiaUCRl8fcuFsMpmn1EVdbwFHRTdUUtLJL39rWoiO8UteVIVFcDo5tJ7JHBG6dUQ4+zXY4ZC3whaeFQmbXP6TVIFbhChQqjfJpGTCaMGekpk1QjEK5ZjYNgrXZJrPsLze3imfWux/K8Njf0DFshpfJ8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iwY5ZI+WmDsRgOabWiMXkrehavxkiSSYIUFfagZlpus=;
 b=M5bzftypUyw5L0AxWhRySxCEYc06SRkETfzPzlc69SxnizrY/y1xMyXxjzKsTm0zu55ikyPUoX8yrRImIdPbvbDWi9UAhTY/nhzyxBzjUxnyKYjETzExYiF6pcSoWfcT73nOxDrs6hcABGAWgIwnteeFWcwspTZdFzFpp6kqOFNYOlRWsnDAEx9dLDYKP/u7FmAc/2/zNusMfxEO5CDt73RS2ZKXoZTJA4WrlW4NDVuKngZ+n//1erg+neHiU/nvCy5FvLhEYJclq1WaM41dr5I3aew/vFZEcKk5m++e2ixsgVF4vjdStiFc7OXWBPNZJhS7mnpPoXXzxVMsplOGBw==
Received: from DM6PR11CA0072.namprd11.prod.outlook.com (2603:10b6:5:14c::49)
 by DM5PR12MB1642.namprd12.prod.outlook.com (2603:10b6:4:7::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Wed, 27 Apr 2022 09:32:06 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::70) by DM6PR11CA0072.outlook.office365.com
 (2603:10b6:5:14c::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Wed, 27 Apr 2022 09:32:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Wed, 27 Apr 2022 09:32:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 27 Apr
 2022 09:31:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 27 Apr
 2022 02:31:54 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 27 Apr
 2022 02:31:52 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH mlx5-next 0/5] Improve mlx5 live migration driver
Date:   Wed, 27 Apr 2022 12:31:15 +0300
Message-ID: <20220427093120.161402-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3f9cb25-f8ff-4966-7a35-08da2830ca87
X-MS-TrafficTypeDiagnostic: DM5PR12MB1642:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1642045F581683DF3917E3E9C3FA9@DM5PR12MB1642.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PyzDuWoEwaOw27wl2kc1wHCg/UNzhC9orqhiAJXCrSryncdJ8hhAQvzu7G5onWj/JmQ2LEh9XfwphXG3PjdGLatcJlIVfAiczihzwUk18M8TcmcGARhde71ZkILIkCBxq5JKtUUIF4ldifIPyw3JDhzeNx/BlC5TZn5MqO02l05hckPXe/VATUymOeK3oH+R3PidBRcIJh42lO8UgVPQRZayeUUanUwCd6BQbHiYWF7HMzO6dQ69SDBCLmEcKVrjxq5tFSGvCL1u1ojkM/FwuH7aVrcU6JmWF/31Ecu7I9RKEt1JIpdlTvmtVP4GJdnIRgGXZciL0ozAv9qSvhdzAHDjVFOHzGmBbx+vCcVbddWlarTllslQHjCU/P8rAaLjnDmKsEp9ytohV/aT31r6USA9gHVdLXE1s3LroNJyufVPXsxblhsOJHiGbx1/H+BHGZbdW5cm8XQxlFrYhAalobcQyqiZUZZ600fvN1ZCmFmYxsWmpQs+S5uIYwkuZMRpd7XW+g50FA5qpJw5hRPdMYzFEvcsYkyWltO0V9fhSlhAeVbl6omI83XCIX9JLjD6BiTBIn6c64OeD10IXvFNx7ylC267yEzi56F2S5XVsovoAqI7Ra82gFR+r/Kvb/RNhQL+DW1+bW1l7o9MJsg5iXG/y6jLvNA72IvIxpTraDbLwGyvnBL7bIYZETQ8JZqosmElq8F/65J9SZw+3xaMwg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(70586007)(5660300002)(7696005)(82310400005)(70206006)(36860700001)(4326008)(6666004)(2906002)(316002)(81166007)(8676002)(508600001)(2616005)(36756003)(356005)(1076003)(86362001)(83380400001)(40460700003)(110136005)(186003)(54906003)(6636002)(47076005)(26005)(426003)(8936002)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 09:32:04.6357
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3f9cb25-f8ff-4966-7a35-08da2830ca87
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1642
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series improves mlx5 live migration driver in few aspects as of
below.

Refactor to enable running migration commands in parallel over the PF
command interface.

To achieve that we exposed from mlx5_core an API to let the VF be
notified before that the PF command interface goes down/up. (e.g. PF
reload upon health recovery).

Once having the above functionality in place mlx5 vfio doesn't need any
more to obtain the global PF lock upon using the command interface but
can rely on the above mechanism to be in sync with the PF.

This can enable parallel VFs migration over the PF command interface
from kernel driver point of view.

In addition,
Moved to use the PF async command mode for the SAVE state command.
This enables returning earlier to user space upon issuing successfully
the command and improve latency by let things run in parallel.

Alex, as this series touches mlx5_core we may need to send this in a
pull request format to VFIO to avoid conflicts before acceptance.

Yishai

Yishai Hadas (5):
  vfio/mlx5: Reorganize the VF is migratable code
  net/mlx5: Expose mlx5_sriov_blocking_notifier_register /  unregister
    APIs
  vfio/mlx5: Manage the VF attach/detach callback from the PF
  vfio/mlx5: Refactor to enable VFs migration in parallel
  vfio/mlx5: Run the SAVE state command in an async mode

 .../net/ethernet/mellanox/mlx5/core/sriov.c   |  65 ++++-
 drivers/vfio/pci/mlx5/cmd.c                   | 229 +++++++++++++-----
 drivers/vfio/pci/mlx5/cmd.h                   |  50 +++-
 drivers/vfio/pci/mlx5/main.c                  | 133 +++++-----
 include/linux/mlx5/driver.h                   |  12 +
 5 files changed, 358 insertions(+), 131 deletions(-)

-- 
2.18.1

