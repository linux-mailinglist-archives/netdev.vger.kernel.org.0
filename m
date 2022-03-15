Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7694D99DC
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 12:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347779AbiCOLDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 07:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347771AbiCOLDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 07:03:44 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB9D45791
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 04:02:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTzk5R4cjM1/vrU6tmXDrxsg58xI/hHTgYSDzlsvrVZ8q7mkxwuXkTV7NU2RtvT6f2Ztyz8Zjz831LN/kEknhWfL/R4Ff50M+Zj/A6TOLhevFaYFc/+c4/2ZX566nLxNhXioljwDrn1CcZXkavLi/anPe3Q2ad9TXBc2LJn7ZrJt4hlIAAZOCZ+dq6aVqzOSPUrUJyUcbJLlXSK6o2lc2Hzmh1Rn958X1i6uhJUTW26CrtCKS8sseBQTLZx+YwDpXJQS/PeC5qJTtcimD7lK7gcb1L+5+bg3PY1ApbPQRKE0TKvYpCCf80GwuYpJllfvPEe61eF3BOBADg9WmeyP7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KXcXkHPzFz3MFbYCjyk2VcJhCNQg5L6cRWzb3JSJHMk=;
 b=RiXmlmTjG9JKtvKUsci3NJ3N+Z/6FhgCu2eC9+KO6zOhLHPB4aDaZxLbSpyjGS8N6nb8Tiu5417syQqF4T3EUYYvHDUaaISBghZvlJNIAVmOWbiSVPexE2yNini4Q07nij2lnIIrPeMEMDfKBTWNOyJYdCQZGA2QkipMIK8dGD0fbrqMXrUu5lrB54Az+Tij3WI3CLqcoi7uAxpBq2sIFzsd5RhJhbHAwjgFFPm5EKqdbisKtBYHSbNaAROAe/yJOsDWDAn4BLvPEjWZ0WSX0/Zhv2IxrJvbA0I6ulaG0ZtodpXfhtd19aVOCNx9y2wQX8p+g9hvl2GgD7rtVkDo+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXcXkHPzFz3MFbYCjyk2VcJhCNQg5L6cRWzb3JSJHMk=;
 b=FJ9CGAV31dhcOhqfwE7lzbhOGWLBd1RrdijMJ4rCeaTSLUGHUQ0gG6tAdEnjnpDdEuDvnnyOK7tx3ekTle9+ni3OMCpg5lus8My8QLnTrohOSCAzyrDUAX2rXIp9WHkb95GtZ1c2Plz1jM/C5kba8SOhudiAkn1nFdiw3yGncLaL8kD9FlXUVr8Kwv0O8HqnFOszsW1oxsOMwkDPtTfO0pUFQQXeEXjpac4D9aUch4o5UvU5bbUZrfHC+oiq82aOe3JPYdpnpMPxNGqd2vyxO2VY0979sDUC3qp4GejjQMzTIvAbV+vh74IsUxrrKkR2NSvfQW1VHHd/a9wboqFEJQ==
Received: from MWHPR18CA0033.namprd18.prod.outlook.com (2603:10b6:320:31::19)
 by SN6PR12MB2622.namprd12.prod.outlook.com (2603:10b6:805:72::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Tue, 15 Mar
 2022 11:02:31 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:320:31:cafe::bd) by MWHPR18CA0033.outlook.office365.com
 (2603:10b6:320:31::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.28 via Frontend
 Transport; Tue, 15 Mar 2022 11:02:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Tue, 15 Mar 2022 11:02:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 15 Mar
 2022 11:02:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 15 Mar
 2022 04:02:29 -0700
Received: from dev-r-vrt-138.mtr.labs.mlnx (10.127.8.10) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Tue, 15 Mar 2022 04:02:27 -0700
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 0/3] flow_offload: add tc vlan push_eth and pop_eth actions
Date:   Tue, 15 Mar 2022 13:02:08 +0200
Message-ID: <20220315110211.1581468-1-roid@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ca18155-c7a6-4bb3-fc04-08da06734d3b
X-MS-TrafficTypeDiagnostic: SN6PR12MB2622:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB26223372300DD293108CEA9CB8109@SN6PR12MB2622.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fvR6zC6KbDITc9aCiDB5HrKWggXTqJP/QU8bNO61y+xf5KqzDDbomzo+mIfHpieyLCHWyHLBkSI9lA4Qyt1thPr5P4ICSjf+Ik6CfM9TyNxujLlsfQW/76hwcguFwQfmSmamWBx3TjH85/sSmK1betMEoP3RI337Z1Ms+wZK6HFewxWteNGNgciy7Suv2NmA/2TWgSBuqpFfWqglqlhqJbDNsBOt+BV0C8RRyWUHKtv7Ne5hhI9KYF8hDPBtsNHa8N07Z/QlemT7WutKqyVExOJNQ1wwsZk6l8rIyZCuuXnvCXr4ewVcz3ayJVCZc5THcxGIiqu+/RaG4+3vQKjJf8u1JszBgV+TIdV3ML/H8dO02/sjlT5iJbQJbThwD2ihkLO0OOpkq5nBvEO+zbDWmQLmUVFvVyQg+x0hbJEC9nFzoKd9N4TAMVd1RBqyibaY0lKfH3FxK+ntsNT+8R6bxPmvy/AZpsFm0b5BCAL0WQt4QcCKWRQz65UGFp3wzxd+L6PLIqUzLEVjv9xmjEn3Sy7IbXZEcIkpDPF4upOITcB1MCAzZ3Cjdr6rvXKpJnNZmrBBf4ZU9NyKG1LyD+Yu8cm0ONNhKYwUero3VSEl4OR+1oWXUFd6t41Apvwd0BpJlcSKCralZQuVuOxY8iTQoHVGEWi5afbp/Dy7AoyT9dBJUePTo5LtoDxog3C+uSGdUsU8PBQfdYa24+fxQOdq3g==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(83380400001)(40460700003)(36860700001)(2616005)(356005)(81166007)(5660300002)(2906002)(8936002)(36756003)(47076005)(70206006)(86362001)(508600001)(6666004)(336012)(426003)(4326008)(107886003)(186003)(26005)(1076003)(316002)(54906003)(82310400004)(6916009)(70586007)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 11:02:31.2035
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ca18155-c7a6-4bb3-fc04-08da06734d3b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2622
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Offloading vlan push_eth and pop_eth actions is needed in order to
correctly offload MPLSoUDP encap and decap flows, this series extends
the flow offload API to support these actions and updates mlx5 to
parse them.

v2:
- wrap vlan push_eth related members into struct.
- merge two helpers into one.

Maor Dickman (3):
  net/sched: add vlan push_eth and pop_eth action to the hardware IR
  net/mlx5e: MPLSoUDP decap, use vlan push_eth instead of pedit
  net/mlx5e: MPLSoUDP encap, support action vlan pop_eth explicitly

 .../mellanox/mlx5/core/en/tc/act/act.c        |  7 +++
 .../mellanox/mlx5/core/en/tc/act/act.h        |  2 +
 .../mellanox/mlx5/core/en/tc/act/mirred.c     | 10 ++++
 .../mellanox/mlx5/core/en/tc/act/mpls.c       |  7 ++-
 .../mellanox/mlx5/core/en/tc/act/pedit.c      | 59 +++----------------
 .../mellanox/mlx5/core/en/tc/act/pedit.h      |  3 +-
 .../mellanox/mlx5/core/en/tc/act/vlan.c       | 19 ++++--
 .../mlx5/core/en/tc/act/vlan_mangle.c         |  4 +-
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |  1 -
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 10 ++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 include/net/flow_offload.h                    |  6 ++
 include/net/tc_act/tc_vlan.h                  | 10 ++++
 net/sched/act_vlan.c                          | 13 ++++
 14 files changed, 82 insertions(+), 70 deletions(-)

-- 
2.34.1

