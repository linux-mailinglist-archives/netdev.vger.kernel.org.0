Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02DD652102C
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 11:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238222AbiEJJGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 05:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbiEJJGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 05:06:20 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11DA23F381;
        Tue, 10 May 2022 02:02:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MpBlNI2yAgbCoaMN9c5SktA+R7w48gfv0k4YonBF47cT8ZCMS4SJSC8sbeg2K2lS8gATh8yrA80o6osv+rgj+zRhYvSfv8+DiomNrsY1lx0zq6XQeMdsSJKs7JlP8uGu6Qs5DpuwSLmwHalvyYe1NyKE2QEFyffAu6r5k8QDiMQDO6DaHfvR61JdIZeOUOKgbmlCpx64MDweAA08ABv5mm6mj9oawEhePZnKdTw0RQDWjnRZXIYNcYa1ssWLe9sfrdrOu3L0OECRWoKI5BlbkcujrRwZSdurtPueDdhVSl7yVa8Gh+Kdppnn8Emb6bIltcHGixOxMkgF9n4k97xQAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HOP3sychT0jMVesRI2HfSpWPgd6I4Tl4tVGmpbf1YSE=;
 b=FTLdypGyuAfNIPwuZcUyTkaaC7veNKd+X2fEsDl5+enmTfGjHlIl7tW1uTUNBkmDtFsxwUBo4iKGQ1g8I3VanwhOsc7VtrOuar6pjqWrQl7EsIesLCXr+BElF1EMwSPfWU2LNTl5+TfxUtsqM/YRGJNM446gb2cle4NEg3xXHKecpwsRTKBO+XUI1O43IfgE6Mid+FdaXIrXjRr1Z95OnxDATEIitFTmA7rP6sfIyuthlyxUJX7Q29kgrUnDUfuZvfRz3kNYwzAEcqa+8lGGyJNNINPyYDX06vg+L5qYuIb/j3PCW1+w+teEzylqqucpKSxlLv0NgP7s1zAzXo8vOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HOP3sychT0jMVesRI2HfSpWPgd6I4Tl4tVGmpbf1YSE=;
 b=nAI/XEzUoZILuGOCN7enA14bxh7VO/uROZJB33j9nC4hL5IoakiNEZ9CO4T9KXrjDcAyWm7i5SPZPK6IIJg2LqIYzl+PpTgEDev+jVao70fEPlnWIOrwq0/QI06fCqxHwmJ3annRnWiQbT9fQJjblovpURf7xgXTxWeno7lJoD6+3bKlTLhwgbt+lJ/zt3WeOeypDwakrlf6lr3ttZLl7don0H5QdBguPw8xaYouB/lcRZI5FQ5pOR7OyYZTtK9UwONV/rkV7LBb1jtSBet0QniM7P9TEaPyuvwkloM/6rd4iyi3jDWH+sBUbG+fA/w7yEI5BKpnrfYkSGgu9eCwVA==
Received: from MW4P221CA0012.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::17)
 by MWHPR12MB1504.namprd12.prod.outlook.com (2603:10b6:301:c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Tue, 10 May
 2022 09:02:20 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::6e) by MW4P221CA0012.outlook.office365.com
 (2603:10b6:303:8b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22 via Frontend
 Transport; Tue, 10 May 2022 09:02:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Tue, 10 May 2022 09:02:20 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 10 May 2022 09:02:20 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 10 May 2022 02:02:19 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Tue, 10 May 2022 02:02:16 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V2 mlx5-next 0/4] Improve mlx5 live migration driver
Date:   Tue, 10 May 2022 12:02:02 +0300
Message-ID: <20220510090206.90374-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e5b21f7-0135-4629-377c-08da3263ca86
X-MS-TrafficTypeDiagnostic: MWHPR12MB1504:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB150477A8B729D7D30741A112C3C99@MWHPR12MB1504.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bLUgjyOpKEvqskWt24L2hynGMGd2F/53r002DYdfq6rw7AsK0M16a2pzKI4TfIhbN28iNPRqKlELZlU3+u64eRqmba0EylrsQ6LuOc7J/3x9IxrRwM/4KRPH+JSVX293sHFVyoIYjbQJitWxrE8P0liRDp1MuB8ef4UeftLX2lTQA6+KweqK69D1dw+n0i2IzP1A/fNDzY9USflOpy/sBdsKtdctSjr2uj4Ia5e9DHh+qDW3PNJU1hBMu1XWrLWDnvFkY9vlzHuEZDIs2Wiu7QYHppW9YDPZUhtG2wmLS1VgnRRGFy5ZoSWwuzeDyS3MW+7co3qEJiPvXprNQ3Byc+NU2iyVR+xv2Wgv15F80T1I21dnHfle3/tVze32kIS8TRonmv+CQuqJJmc4umBPEQOGJqP1AcSeOueMx+5X1p7qvx6c6lyUGddcI7n/P8WcRXe1xBExI2GjqesKqPb13UP7fTdTMNOb/1IXNy9VPMmYuMhaE6FK+t+dW3C/U5i3/F2niK7bkkHSTRcenCm56XkEIsu4qYOl1zMOUNPIibRb2KdcGGRvBVCKYIxMWVnahjlEhVHOlt7Kh3kHystIfxHmdPo4Ocjt1Hv1v28JA+JCOWDuymciXRcaRQD/ukpyJCl3NfuDDW4LG9WImX8URvSl8Q00wUtO4SFuxgJ3Kilm1mG/hiXZYL/KXCt1FBqP99Q/9FrYri+rjCqi0TQ2OpN0wYaqLLLakvF5pTqoLCQc+Y8j1OYgyMFvY3wJPZLHXQoALGkzPhTSvdeBi30IetfBdY2xGucUz9WCYCUSx+fidPmSIPIofeD4o0eWESv1jypj3GGdF6PG63aLWHwqhg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(2616005)(8936002)(36756003)(1076003)(7696005)(86362001)(110136005)(81166007)(6636002)(54906003)(70586007)(316002)(70206006)(82310400005)(8676002)(4326008)(6666004)(356005)(2906002)(508600001)(83380400001)(966005)(426003)(36860700001)(336012)(47076005)(5660300002)(40460700003)(26005)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 09:02:20.6041
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e5b21f7-0135-4629-377c-08da3263ca86
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1504
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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

V2:
- Improve packing in some structures as was suggested by Alex.
- Move workqueue managing into set/remove migratable functions as was
  suggested by Alex.

V1: https://lore.kernel.org/netdev/20220508131053.241347-1-yishaih@nvidia.com/
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
 drivers/vfio/pci/mlx5/cmd.c                   | 236 +++++++++++++-----
 drivers/vfio/pci/mlx5/cmd.h                   |  52 +++-
 drivers/vfio/pci/mlx5/main.c                  | 122 ++++-----
 include/linux/mlx5/driver.h                   |  12 +
 5 files changed, 351 insertions(+), 136 deletions(-)

-- 
2.18.1

