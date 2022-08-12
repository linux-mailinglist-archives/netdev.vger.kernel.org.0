Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B1D5912FF
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 17:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbiHLPcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 11:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbiHLPcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 11:32:45 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A207666
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 08:32:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fd58W+2XyZVK91alDCb+WMXjE10zyztJWGE3/6AwgCoskF+90h8A2l8onZ4kiBr/kePh+1ktDi1x0w6/8LC3oeWzUrOupcR5N661V2GCLwficBgppQ05eDE1e9FLqbV4o+tSc6dtkq26N+BniYjTFkMbZmpsBSklcRjcD+5VrdPDYCxkA0WY8qstQSbeQMhbCKiwNLZfRH/4cHkkS7ROI05Qn36dftbyOLHcFv3jDnmJTmfth/mHYujNpYVgROYeh80Z1lSxuvkzQHXDIlxYHhnSEhcEPnaQlPfLS1tMPaOv8Hk7V9aIutcO2SzxRWu4lWlSK26y87O/szXJ9ceK8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Imm8d/03wcTSr4yhyQepmVN3jMROG9oKhsHSRb6yxBM=;
 b=mgwSNMu/9juihEkJiOs48Q/YQbDlpyDBB6w4zBr0PE5BeKLLoOoQ5K38mOpc7IihI/WALl6CGUbCFdgsoI0kl+YuKdOMT3yo7XYZ75Hx7njiGNTUCxMVyPQ2DFG/lM/z00+RCZdeXip+NgJxvpwwrEVQOjsBuw7KWnUx+djEB7+5C/BUn3IUjk1MezeOPnyDHMhOPJK5JZNHLMbkdBIrb4J93ErxnP110j0s+SEyGKB3x/ATv6dOuJNmaVq7/xNTPowkgG+ojlP9NTqcqvCtzNlOQC6lKHx2hik20jVSBJWUW0Ah/siN2fMbyii7FsxTqMN9y8PUbgyQfv/kHIXvxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Imm8d/03wcTSr4yhyQepmVN3jMROG9oKhsHSRb6yxBM=;
 b=eTKSlMFHNs7enLD98CM8Lk2og0XGVx7qCPBvLinWqkjGj58lxbs/BTJqURc/eo2jrcN8Tn84lbyv3I1jVHPDbt8vbdSBQ6z4h6L9nr4nZbgx9gJTQ8lpMrZrDiOuoLOXfEp6F7fKoYAo5z5sP/TffHQfgNTDNDqDtMRj10ZfMfQ9cAwVxx5r107IpQnCDEY2x92jDUuFoS9tQC8L2PidcMGVDxe1mv8qHrA/314eqSmo4xnXdsS3xROFu6BFD76wgcJqS1NU40b00YIrOmwtPhuJ4N9KJQ7F3e8huO69/1r4Ae883EFemZb4TWu6QGq9P7Q9rN2GH21kYQFCsZWYHA==
Received: from BN9PR03CA0223.namprd03.prod.outlook.com (2603:10b6:408:f8::18)
 by DM6PR12MB4603.namprd12.prod.outlook.com (2603:10b6:5:166::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Fri, 12 Aug
 2022 15:32:42 +0000
Received: from BN8NAM11FT081.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::4d) by BN9PR03CA0223.outlook.office365.com
 (2603:10b6:408:f8::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17 via Frontend
 Transport; Fri, 12 Aug 2022 15:32:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT081.mail.protection.outlook.com (10.13.177.233) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Fri, 12 Aug 2022 15:32:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 12 Aug
 2022 15:32:40 +0000
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Fri, 12 Aug 2022 08:32:37 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Petr Machata <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net 0/4] mlxsw: Fixes for PTP support
Date:   Fri, 12 Aug 2022 17:31:59 +0200
Message-ID: <cover.1660315448.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b833b16a-cf67-4a27-46b5-08da7c77e574
X-MS-TrafficTypeDiagnostic: DM6PR12MB4603:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HqUJym6M+kBNxHa6lyq9rvHytSP6XzYV37qDBOncFFJmz2OjMmKl/9das7n3WdsKXGlgDrvKaKUejt/yymE6xkZk0vzTuuPKEdZSGpWk5+pvdJPUSHLe+nh6JokdtL1Se5a8u68l1mGvuFOA550sBt9PbR7Zl2DNRtPpoN2uQHtCNRdhKAFsHjn7s5Xgh/Ze00oGvvhFwoIMwjKHAInYnmnaTn79feeF0Xz3oUU8FusTbAE6Ghpo296Lf7tOIRHCa35vzTOyTR/anw0Oell0Ry36ZmtG515aNMJK2C+2WnbF83dMQxeW6B88hX/+3W4vgQSft55waOmBWqZNCKYyXUt1zAlQOCnjfFTMMzOo1YXocnYe0amfsP3nDU/dK8JXWk8exPKkUhsYO7jMereTmeZnIzSgN+qPtTRXeRuOd4VyX45XeoUUn12L4JRBd3uvbmHglxZVcK7ZFjlENmeuoZtQlcKtzBgtEDEVlIRSdAE8JYdSRzOrZvo4g6+irvpeQuTk9BIlb4ZxZvAwYAkD01Rc11swngJYbg1Q/ozF7Hp43VyHHJICjZv6jIxU7t8HS1WWtnBYsOfYDU9wfBYyQLKNETyQ+xIRrM3d+cYu20whX4bmym1/OK73oAK6UgoM2m2fF4ToXXbFOuQIrpmRUK5kVenUTQgyKeePqiErJpjIA0czyL3LhK3gJbe/KkfvYBeApgIz0aWcdW2EC3hR87Nb6hxJuizWcgZZ9HHiB2NotLIHAUXnIR5KEkJPbd42ttmyEdzRYrn8S+xPwHX6RCTHhfFuYGbnQs1lD0IZplbbG3RQsafHQKSi4P2acbNiM4wnsWwKbcqbBKFZ2bWc6w==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(376002)(136003)(396003)(36840700001)(40470700004)(46966006)(26005)(356005)(81166007)(82310400005)(40460700003)(86362001)(7696005)(478600001)(5660300002)(8936002)(70206006)(83380400001)(6666004)(41300700001)(4326008)(8676002)(40480700001)(70586007)(2906002)(82740400003)(36756003)(16526019)(110136005)(54906003)(2616005)(426003)(107886003)(186003)(336012)(47076005)(36860700001)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 15:32:41.7183
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b833b16a-cf67-4a27-46b5-08da7c77e574
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT081.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4603
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set fixes several issues in mlxsw PTP code.

- Patch #1 fixes compilation warnings.

- Patch #2 adjusts the order of operation during cleanup, thereby
  closing the window after PTP state was already cleaned in the ASIC
  for the given port, but before the port is removed, when the user
  could still in theory make changes to the configuration.

- Patch #3 protects the PTP configuration with a custom mutex, instead
  of relying on RTNL, which is not held in all access paths.

- Patch #4 forbids enablement of PTP only in RX or only in TX. The
  driver implicitly assumed this would be the case, but neglected to
  sanitize the configuration.

Amit Cohen (4):
  mlxsw: spectrum_ptp: Fix compilation warnings
  mlxsw: spectrum: Clear PTP configuration after unregistering the
    netdevice
  mlxsw: spectrum_ptp: Protect PTP configuration with a mutex
  mlxsw: spectrum_ptp: Forbid PTP enablement only in RX or in TX

 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  2 +-
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 30 ++++++++++++++-----
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    | 18 ++++++-----
 3 files changed, 34 insertions(+), 16 deletions(-)

-- 
2.35.3

