Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBA651EDA4
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 15:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbiEHNPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 09:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbiEHNPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 09:15:31 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB2EE0CC;
        Sun,  8 May 2022 06:11:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOxbMO+yO+N450z7IlK2mtubGdO01ByuU9GZcPEdr3RzQYfjXjpfWLwkBlaAslyd16/yXQeeBgXsE/UW9NBW3R+jmjIrE88Q4UnBIwnBfvLfSFgy3rnDYivJD5W6bRjoOJ7Y+DXNhkw85qI4xq8a4vPhhZhpphriQPGFcPmbOyhbkorROfmnrq4TN5kmGrsms5J9XRyYypH8GcxSMQPW18t7nYo+/SawB35nHClcS8QSEwraJYgblzRi6Cph/UBKsVTuqTlFXV0jklh9ewjkOOsjzaT0/CnkFNegIR5E7CLGKDXhE+JO9lSFwoyTFsSa6OrtJT9/I/bBlb2HaJxcoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uzhpbd2Ebg/onl5yt7bpA/pUloGWQ+m8iR1IyotfqH0=;
 b=Xlrq1PLzEZ7fArWLxwKg9PWOg2I/1sk5GV0lUaqRag1o5bZdP8O9d0OHvfjQteYNTI/cKKpqsq13zM1UqVSBY7bdodN2u8wyhykKLQ531ciq2lhmnHaSLpDPXi2MgPdgoOdrY2f0hHu7eAIaf8mBZhxFy/iybXBH+niXRnbCkHZLXTRUJrEnoa+FhAjnX+BJQeg9EkoPAa8EvWH0G3f2XTMegW5doEhoc8vA5Bl2r0xwFx61FFv7kRxdsU9TxL/7/UVVwHffgMdGysaSNI29J0dRMecEhVGlaxVjQWwcYuT07MIxOZhdFX5LwT7QQmvqMssPQ+ecRogNFwc++ToFPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uzhpbd2Ebg/onl5yt7bpA/pUloGWQ+m8iR1IyotfqH0=;
 b=Aes07M/u+Bb2QwH9GeinjpI1FIfUzD6h2Du+FSliQqBZCHJi33FgeTRvg6c5ZNv9jZpVtag9nZmpHl0bM1JtLAPCjePHpoZbFR2z4aP83wf7R2Zs91zbxelQX3ICVaKlza1yxHtzZZvBeJoRgqulCvZEPU5ViO2NXiZoTmaZU37HvstSoTSWRc9ryVRE10t8zlVuwUn1PnI5Nmr9V4N9BiV6VfyKSDA/dZx+s8CoycVIrUnZJGXK2uGWcxPc7xy7QxqvJECsZmTbGEcu5fMCEPnSEVZF8lRIN45z+SLQ6YZORz1Ruu43g/zwbrDMBECd3y8E659XBgEPXmdebgMtag==
Received: from MW4PR03CA0313.namprd03.prod.outlook.com (2603:10b6:303:dd::18)
 by BL1PR12MB5045.namprd12.prod.outlook.com (2603:10b6:208:310::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 13:11:38 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::61) by MW4PR03CA0313.outlook.office365.com
 (2603:10b6:303:dd::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20 via Frontend
 Transport; Sun, 8 May 2022 13:11:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 13:11:38 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 8 May
 2022 13:11:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 8 May 2022
 06:11:36 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Sun, 8 May
 2022 06:11:34 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V1 mlx5-next 0/4] Improve mlx5 live migration driver
Date:   Sun, 8 May 2022 16:10:49 +0300
Message-ID: <20220508131053.241347-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63b67b65-f735-4ad7-0dd7-08da30f44918
X-MS-TrafficTypeDiagnostic: BL1PR12MB5045:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB50451C6AB7C46189434B6478C3C79@BL1PR12MB5045.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TXidzmhYffK4pHfvbWJr/8utQUBO48b8ZjZCvXpLSWyomajR+la6ceyBG9rEU3XDlOO5Fv8KT6dzmS9arJLUMhuyALoSZTO2IPfXExxprkZVs2+Ebs3ejQpaTb6yCfAK10dCQ7RKOqQjKAFZB5cJkg9OtiUJ6Rcjb2VWqcx1NYgJdfdY8/tWX7FBYnPTgZBKSbVWNqqsI8wjWzlWCm5LTHi4DaXTH7Pcm9cMgDaW5owjKvgJYQDE4Lj0nopUXFQz1UaT6t1QGZLQUvlFi0Sht7gO4UhZDlih0sGJwNdHg5zSdlVKgWFn+9dlE+sMY0Dh0zu79fVKyLCqTvX79F4GDnp8Hi4nxumS30dOL9SBAC/LVfcCZuV+f2gKBrLqgWshyDbh0WQWazoPlTpkFj3A0NFjOeGz3HOAJeSTr+15NNqHVPg1HVp162ztBbXPgsRipJ1lbXfnElV5dGJMl5fUYauCPt/HqP/EajhM/wGvkkU/RgwRuSzfGYwMgagoR6Dlay8JcdTMfABigyuKP0L72pKo7qJRgisr+EkF/HpOyrXF11Jy9nQm2ODs7xvALxaHSYareDZaaIOwTyFS6kpZCeU5jbOpobfw2cZHFt+N/vN3DqJuJVFUnjuH2IOk+GqQWvj3Ir22GGmPqTUZu3qRvSCJIt4RaPz0mltLFgE6J06JBaWCWi8YscKp2zCuV79RGPWrHp3D8mio3upLyirJa3MMMh5cTnClOqLjbOzMI2pPtlRC5Iv3y1/Wbu0gc0rOWaelnwjNwGYtNGv3odJtAE9pPv0YB6hPukWM0WKVblw=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(508600001)(70586007)(70206006)(336012)(426003)(47076005)(4326008)(8676002)(5660300002)(83380400001)(8936002)(7696005)(6666004)(966005)(2906002)(6636002)(110136005)(54906003)(2616005)(40460700003)(36756003)(81166007)(316002)(1076003)(186003)(82310400005)(26005)(36860700001)(356005)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 13:11:38.1719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63b67b65-f735-4ad7-0dd7-08da30f44918
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5045
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

V1:
- Put the net/mlx5 patch as the first patch based on Jason's note.
- Refactor and combine the previous first patch with the third patch to
  have a cleaner readable code, this follows Alex's notes on V0.

V0: https://lore.kernel.org/netdev/20220504213309.GM49344@nvidia.com/T/

Yishai
Yishai Hadas (4):
  net/mlx5: Expose mlx5_sriov_blocking_notifier_register /  unregister
    APIs
  vfio/mlx5: Manage the VF attach/detach callback from the PF
  vfio/mlx5: Refactor to enable VFs migration in parallel
  vfio/mlx5: Run the SAVE state command in an async mode

 .../net/ethernet/mellanox/mlx5/core/sriov.c   |  65 ++++-
 drivers/vfio/pci/mlx5/cmd.c                   | 226 +++++++++++++-----
 drivers/vfio/pci/mlx5/cmd.h                   |  50 +++-
 drivers/vfio/pci/mlx5/main.c                  | 132 +++++-----
 include/linux/mlx5/driver.h                   |  12 +
 5 files changed, 352 insertions(+), 133 deletions(-)

-- 
2.18.1

