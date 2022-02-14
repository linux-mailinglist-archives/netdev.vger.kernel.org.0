Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7478F4B4D4A
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349031AbiBNKrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 05:47:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350739AbiBNKqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 05:46:46 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51854A1A8
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 02:09:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ta+ClzIZ7HK8IB3qgLUQs14Nk7MkkkKFuPwfXZmNy6zsG5vPSCzBNt9N9yvYs86JQABQJGJk5NxCExDSXJ80Qqqz8a8Uo3ibH7AwCo3deTv+fbxS/Vv8RCmPreLJs+YxNogrhk1jGNRNS/yBcjaH0ueirta0exk5nCge96U7iSc0iMOnJemUA53KFOK5Cs7U+7FlWcMVvoQraSzdyEBNwKVPumx0RSLjiZ/AiCkpgbDdJ4bTPnLkQRikF58tFHDw+oRkj8rmKDj36tMFOOSpMvZqFraOOr9YuBVf82JuyLZxzNA9NILiMLcfjlpvh2+c5YYQ4kf4t/XslJse9GjdAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=euwtL57VVKVbo/enj8Uh/sL/h9T5pM5dzW7Z6tHv7aQ=;
 b=Ev9EP7O5ZcZL2/cgD1V9SdM9m4P2nkgNbMr7YNqCYpZxP+fXmw/4dM9Zj3hP3SPfstIyVXZsvUqiUEnRW8NcHqE5b8Ba1//8vYGR7uYBp4CsD1tWd0Llm6wtELQU507NjyFMONHmN9aaqBbZmCphubPn7q9xHEI6LcvqYSQ1wXUw5sy8yVauC466wrqbBWCBSLkabuRaP5uX9eL5AbyQM8h67XWAYjssAOEV3NuTH6EIBOm2OXaEnSfSkcsICBkDBpLBCbE1SL//7D1EXrsMkw90gxQREXpjF4DrSBYsph/SgwXW8N98OCOkI9AEzFnFRsZgXWeMdk0ZaYd+r/R/0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=euwtL57VVKVbo/enj8Uh/sL/h9T5pM5dzW7Z6tHv7aQ=;
 b=hSj+ZkfVTo0N/kWoi4YrP+nNoKYtGCSAyd5G47dzQfEEMZLOtwFq88Eu1qmCXUcqSkWr2ejdJBKhpXreZZz/6iikMV9HFXl/zwCavMm+wBuSFoLuTsdt8rZcmaAqz00GnuJv9SGnM7vFH1KBGaSiC/eHOWgX+rjpef2TLaeRZV0TUA5KkDZqs0wOP+mmqpNLGu3MjivshvaUTWZ/vW16wf7fb+QoSuHSBGIoENKiYyVKxeuhe+YmshxmGsUU+WQ/q2JF904d7oqe3gV6HbHcWrotoDeCKrXhBDTEmE+2rJ+GZpXaGt72mSbekYd8r+8SkZuUTkq73KhXa+mVi/dLXw==
Received: from BN6PR17CA0045.namprd17.prod.outlook.com (2603:10b6:405:75::34)
 by BN8PR12MB2948.namprd12.prod.outlook.com (2603:10b6:408:6d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Mon, 14 Feb
 2022 10:09:34 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::2d) by BN6PR17CA0045.outlook.office365.com
 (2603:10b6:405:75::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18 via Frontend
 Transport; Mon, 14 Feb 2022 10:09:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Mon, 14 Feb 2022 10:09:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Feb
 2022 10:09:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 14 Feb 2022
 02:09:32 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 14 Feb
 2022 02:09:30 -0800
From:   Jianbo Liu <jianbol@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <jiri@nvidia.com>, <idosch@nvidia.com>,
        <ozsh@nvidia.com>, <roid@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [PATCH net-next 0/2] flow_offload: add tc police parameters
Date:   Mon, 14 Feb 2022 10:09:20 +0000
Message-ID: <20220214100922.13004-1-jianbol@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dabdb6c3-96db-4984-885b-08d9efa21984
X-MS-TrafficTypeDiagnostic: BN8PR12MB2948:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB29485271D7FBCE41FA5678E6C5339@BN8PR12MB2948.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RpdJc3pbJIyABUOKTRmupHC5hguH7saooVt19uIYebsZ+Tc5ZYC8NU9h9rVhr2He5xtelAb+0Q/3KkrRKQ8pMCyNM+nefnsISSYcHSfpO9CgwVsnVWSkbWtZ3wHkLHKcFfXo8Xi3m3kkEhdTPbpyA8C4PVFZivgL/TG/wi6p/9Rl74ORoQ4atBFaOwQZCuyogID2QiiJpkkYtiIMDFmXFvgU1G60BPn8k6dOThNhLrldNgZbfUarnXeC1NGiYqOYVqaK1SCx1HkvseHeuoZeYGJPtoS4zv0eZCox4G/kPMJlj5RrRdUQ/6nuP++722QVHVqlOD3yuso+WzDrOf9aFEqrGeV15IopS4clUxT9GPeaNuV4SvK6+MMXqzlWnWK3UDH9VIJe+CifFGkPCt+sLF2tpdpBgN/YQciTydC40WpBZ/QSqKmUX1lcc+iCVSExyQUI1bySANxESvelBhaiYslNrqvjxj8bQkgIFJHltadPwsmUpfmoJHxXIKU4w4QAjdp72aJ/OnmumGnPw+4C8QF3omLhv2mdnbFgj5CWRhW2/wmiA8MGGQX2U0IbYFfQQTG4NP/qkXlw0zgNW98MeT28fQrzUqoA3ET8yuwLDXB2wVbJvUrnoqPJxpgDtx291YCZPWw7GFRdUnWKvUliJO4wKReF3MY7PYRNBRmlN+nGFFrtpnSA90hnVs5bNbCHSswtb1fmIXVYwIVXlp8BwQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(4744005)(36756003)(81166007)(54906003)(8676002)(8936002)(6916009)(356005)(316002)(5660300002)(2616005)(107886003)(7696005)(26005)(508600001)(6666004)(186003)(1076003)(86362001)(47076005)(70586007)(4326008)(36860700001)(70206006)(82310400004)(426003)(336012)(40460700003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 10:09:33.9773
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dabdb6c3-96db-4984-885b-08d9efa21984
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2948
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add more tc police action parameters for flow_offload. They can be used
by driver to check if police can be offloaded.

Jianbo Liu (2):
  net: flow_offload: add tc police action parameters
  flow_offload: reject offload for all drivers with invalid police
    parameters

 drivers/net/dsa/sja1105/sja1105_flower.c      | 15 ++++++
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         | 31 +++++++++++++
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 17 +++++++
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  | 30 ++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 15 ++++++
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 15 ++++++
 drivers/net/ethernet/mscc/ocelot_flower.c     | 16 +++++++
 drivers/net/ethernet/mscc/ocelot_net.c        | 15 ++++++
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 16 +++++++
 include/net/flow_offload.h                    | 13 ++++++
 include/net/tc_act/tc_police.h                | 30 ++++++++++++
 net/sched/act_police.c                        | 46 +++++++++++++++++++
 12 files changed, 259 insertions(+)

-- 
2.26.2

