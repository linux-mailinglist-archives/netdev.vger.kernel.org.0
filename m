Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9376459E8
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiLGMhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiLGMhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:37:51 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2068.outbound.protection.outlook.com [40.107.101.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF98BF6F
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 04:37:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NawFlc/tQQFwbjeYR9omFYC8YO+Yq6Spxv2eaNH/92TNTtsMSJ52PjRhUgSRP/eKubobd7EHs3e//6+s6EJcgyTqV7txd5kZ1nKmOnWpLcn6+0ILgiF6197gwkQuQnbS61qXXLjoX+CVCL4sxMz8UsYWqPY5yrfLENe8HXbuGU47YVZW+mxCa2/sXOjNLWB/A7h/Hyg/goq6vCD0xTWyRDYW2PnWNXn3beCVx61m2FcTcLGIkJ22WvOdILxuuX32CW2eYeRcgUWVcg5DGkhxI5Gsc7fv6r5D3Ss/apU8RfCTyb0KT05s6fC+UUxIhyjw5hXwPV+HIvUa1vaN4HK67A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jpD89GfNPAEhXs0M/cptGC/vegAMc8VilImE81rGitU=;
 b=oZsx9FnR2/JYeQ7XpO3Fs97t+ecQgL4LiSKW4pZ29X4o1KAULUkQ089h8wtwT4q+iB8WGEyYtN2rTVWXnOCUnpBufa6SfFXaTHBFyIcwLPz/Gx7CMjwwC6g0yedJ7WvxUyH5e+KzgkkEbrIiXj6ahrg5JEcKbgUi/nHYVZyaL48uTSkZoWUK1E635DUWBP66KJBnOa/HNkojSOZQqzX68Ns7LyvPnKM6B/EbF8CUJi6dQwpDUY6/W6MqHwM+1Yx5SYUT7gF2NKjx7IngdIZPiyKkdhua6UqAtgt3ND3FkbD6YJMTEEPUZVzD7ctwULYl1NbvBYht/9qDNePKdKJCiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpD89GfNPAEhXs0M/cptGC/vegAMc8VilImE81rGitU=;
 b=HXWvoSBNydFjO4E9tRjVRKMZcmALH5oEAPfERGCsboRxul17rjsWuzn1KAVT9Xrnk0vbJ8auhvdxTyIq6/n2VTm0Ea3aCK83SNlv1MUg4sgroa26jMi4N3IuIvoTs4tQ74mc0EYiHu4/b/GkwgviuZihnpWTvpL8+vD/4iz7ofeSav0TNpH7e4flZ+MPj65uTJUazn+kWY5btZP2ioTvhxhQtnFT+okSdBuQvEdLzwwdZ9use6+Vx4Pa+iNUI3hvf+1hWQcANxqmeeg+RYKkVgOBbAc4mQ3V3pglkbY6tcnPc2Rc+k68wCVkNNKhCm8519OyVBhUaSMscHa899lCsw==
Received: from DS7PR06CA0043.namprd06.prod.outlook.com (2603:10b6:8:54::25) by
 BY5PR12MB4950.namprd12.prod.outlook.com (2603:10b6:a03:1d9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 12:37:48 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::28) by DS7PR06CA0043.outlook.office365.com
 (2603:10b6:8:54::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 12:37:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 12:37:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 7 Dec 2022
 04:37:39 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 7 Dec 2022 04:37:37 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net 0/6] mlxsw: Add Spectrum-1 ip6gre support
Date:   Wed, 7 Dec 2022 13:36:41 +0100
Message-ID: <cover.1670414573.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT033:EE_|BY5PR12MB4950:EE_
X-MS-Office365-Filtering-Correlation-Id: 7585472e-9989-4c64-dd65-08dad84fd901
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AJ0vtP90YQW0Go3ZhE0t6ZUHyU8G7C8ZbaE+jn/jHaDEhQ82iAXB2p2IsLCkA1h+ZRCbfo5tuk5WlIHgmQM+ZdP7BCRDYSLmT19ggfDQ4JSC3GWxBXJeYVh40RzMEBCQNn8hiWKhYxM4uY0JaLmm8P+aazn3puMXW6lJsbM/16sis0Fkv7wLi5yzGlhKExH5Qk2uldpszuukXlEI3UEvGVJ5nPki+SlHR9/RTkdrrjTLrG0OqP/f8Ie4clk992ovgkjj0EL1z436K0aD9jVrISCv9msROc6B3Ed1qLIihr/T6dFo3MVg1BhK9XfFb3NImcAHVxG5oN9ZgO1k3wYSrB23SP5abYujG7R9O9X9M7+tWk7ejUNwzeoATOncjeBR4uA5QFOZfN3Qtm/eh0lRIUIytGNi4cA8YpCXTi6n/TYRcCVtXR/wSOysMFmls4i1w8AwNc+yBzA4TPe6t+VecSu4msFb29Zi0IWKiJmX0nxAGVhVmL3KBStAWfEML3KuwNFxrG7l9pED5Fwp3Uf+Enn+IrsIiLWEkilfMkYaVa5+qgMufpa2UB5Hyb24bEhBk14fybAaUjfbIG+OBonAbENDL4YDh3a2t/kqkrAV/7OIOpT18/w4Z7M/IE8wHJ6KKKNQYI1Opa9F460eLLcB4XqXZuOgXFADr3lu/CRrrL1Z2kJRZZ1WntZZS0ACpCU37LiV3r7TDPBErJbtKL9x2tpfoEw5EAWmwd7jn/mIKXA=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199015)(46966006)(36840700001)(40470700004)(36756003)(8676002)(7636003)(356005)(4326008)(41300700001)(2906002)(8936002)(70586007)(70206006)(36860700001)(83380400001)(86362001)(40460700003)(82740400003)(54906003)(2616005)(110136005)(316002)(5660300002)(336012)(82310400005)(7696005)(16526019)(6666004)(426003)(186003)(47076005)(107886003)(40480700001)(26005)(66574015)(478600001)(32563001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 12:37:47.9578
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7585472e-9989-4c64-dd65-08dad84fd901
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4950
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido Schimmel writes:

Currently, mlxsw only supports ip6gre offload on Spectrum-2 and newer
ASICs. Spectrum-1 can also offload ip6gre tunnels, but it needs double
entry router interfaces (RIFs) for the RIFs representing these tunnels.
In addition, the RIF index needs to be even. This is handled in
patches #1-#3.

The implementation can otherwise be shared between all Spectrum
generations. This is handled in patches #4-#5.

Patch #6 moves a mlxsw ip6gre selftest to a shared directory, as ip6gre
is no longer only supported on Spectrum-2 and newer ASICs.

This work is motivated by users that require multiple GRE tunnels that
all share the same underlay VRF. Currently, mlxsw only supports
decapsulation based on the underlay destination IP (i.e., not taking the
GRE key into account), so users need to configure these tunnels with
different source IPs and IPv6 addresses are easier to spare than IPv4.

Tested using existing ip6gre forwarding selftests.

Ido Schimmel (6):
  mlxsw: spectrum_router: Use gen_pool for RIF index allocation
  mlxsw: spectrum_router: Parametrize RIF allocation size
  mlxsw: spectrum_router: Add support for double entry RIFs
  mlxsw: spectrum_ipip: Rename Spectrum-2 ip6gre operations
  mlxsw: spectrum_ipip: Add Spectrum-1 ip6gre support
  selftests: mlxsw: Move IPv6 decap_error test to shared directory

 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   | 160 +++++-------------
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |   1 +
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 102 +++++++++--
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   4 +
 .../devlink_trap_tunnel_ipip6.sh              |   2 +-
 5 files changed, 138 insertions(+), 131 deletions(-)
 rename tools/testing/selftests/drivers/net/mlxsw/{spectrum-2 => }/devlink_trap_tunnel_ipip6.sh (99%)

-- 
2.35.3

