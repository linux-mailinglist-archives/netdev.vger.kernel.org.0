Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E76686BBA
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjBAQbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjBAQbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:31:31 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589F740E3;
        Wed,  1 Feb 2023 08:31:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=abg3P+95c6azXU5JCfdBuMEgY1WzGYaWxbQbYQZWfThJ9LDY5V7S8xB250Y3H3jqV0P3bI++qQO2vKObzhgcggXxV62/pVk4+b916Ym6CjIvkNe4tig92+gSChyAoY2HCTWBMZngMFLPO7HL0j4ujWHkSsobzbLlhxX32HCoVa6ZgGaPoAzbHdzJbVbWliGZgatDWQjJvuxOEWe01H1e8QKTP1ILw3Xoiz2STZQ5e7tTucA5vOExQjNXj1TRqbiYnTdRzx4GvKaLpCYBxQvGtj4xkxSpKGjyUoXy/fLwVfpA2Dbjif2vXlFU/waUbKAyZtmLsiAlMs0C2WWmofVvYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rhl1C3mZz++9nE4Or48E5nwmkq+J8N6y+OnmxZOz2Ig=;
 b=WAMd05Edg4ulI7l53lrI6c3d/NT2LXUc53cOLo/ZmyUlyKC5LtQazrqJIWriwBwsqO2LE6yzJjUybZQRKj7ESS7UGremQArd2eiaMyp+WmicGFgujgWDmVlYzfHR5Qyv2Zwhh/92IWIirwPxsrrA83Gj2a0YNbkK+6wu2AEvp16RNI85E/+ixgFhdmcxb/+DUUf2cjLXQDmge+t643YCb93yU5rABEsgJ2CbssxPzPpPw3ygwrqa6q3XfvDWZK36WULWI9+DhhPZXNu1P9xc1jm4HuLCEIWAmaYf7xHPPVqxrWVCI2WPEEaVpcCBU5BSo69GVnNkRQBTsYqnx6Qunw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhl1C3mZz++9nE4Or48E5nwmkq+J8N6y+OnmxZOz2Ig=;
 b=GK+y05+BaQHEcxcyi0QZuFl7uzeKnwfIxy5bELpKemgNJVsjgHU3SU2d08A/b69MdHi8x937SlPPCmHxvIY9KwUMXt+OAANon+oPL3oKrXauPzNANjbyzoY8BB4B2jJZ9nZR/GDe2mL0lWgQHoj1hc1T7zBnD/e9Its8/JNTkx7wZRxz6g5J4rk/ateb+A9SSR5ooEnelPcDG9kEYReB7jzWgJDc+YxgHLB45siy44GpRJwl3QBxANHxAWxIIZJIAlKVkIMEBJTeguOIGXWKtqYaozLNZxCVsSxyuAVx3TATP35dkTmlxMLYPxINP5+qZvZ8RB3TmVq4kfGFrhYp2A==
Received: from MW4PR04CA0206.namprd04.prod.outlook.com (2603:10b6:303:86::31)
 by BN9PR12MB5242.namprd12.prod.outlook.com (2603:10b6:408:11f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Wed, 1 Feb
 2023 16:31:28 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::5) by MW4PR04CA0206.outlook.office365.com
 (2603:10b6:303:86::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Wed, 1 Feb 2023 16:31:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Wed, 1 Feb 2023 16:31:27 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:31:18 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 1 Feb 2023 08:31:18 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Wed, 1 Feb 2023 08:31:15 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v6 0/7] Allow offloading of UDP NEW connections via act_ct
Date:   Wed, 1 Feb 2023 17:30:53 +0100
Message-ID: <20230201163100.1001180-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT058:EE_|BN9PR12MB5242:EE_
X-MS-Office365-Filtering-Correlation-Id: 364a8c66-cb6f-43fc-9c1c-08db0471c4a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TaRfciR5iP1z+vlhzzNXaJym6CEIZ8YVj7RA9iuQ0ih+kDfF5R/LBXuB4rZAKs8OiD+1LL3Ng+kMmjdhMa3FCW8891qkl+X2xvdVKgkcrpp5345WMyzwZZRCFyrel5fx/lOx6fWAd7VfkkDM6JNXunJXSdUzOx/xzpUuJ/9iFC2NFobQe2mxx8fpaoJRNTmb5WTlQrrETXWFoJKhhQEkSuZkzXUWtWJ668sXIWmpui+8TaBumEp8SPQ0oUjJmdQwD9hF75OcBMnzh2n4ifoa8kRAdpHj1HV5RlT6JiGEl0zHxGFb5+9UkUUVNHysS4wn0nkWq3WzAefjqMkGVLyz/4EyfrUwuVmWbAj7wuEE+Bf/2iHKJ9KsqQ4hj3514JgiFqOFoOGuVIwSzBA9uhD2dQYn15vOE4ilA5gxWAAI0hmIroZeTYWK9CjF9BIRWhYtTRpeUkQWyTKcZCyz2lcA2w/1knZsUjpDL8EkN/DuEQe12MCBiWGKkosuwPtWZX9BaGHi5TyUYNkKUND9GpoJmHxXuHvEDi+mH/+uPPwKYkNuSRXhVK4ATuO+/Q1/9ZFP24PaNsJQs94UnzhtyFTecCzBtkGICailXNWCLWOLP30C3tK+z5nrJXka94lZYE6kVg9CKfD33CtpD2t24S/lrgACCDmu7XclIWXB2h/3Qa+EoQE+eSKAlCrwA/DoF8Tu7KCBXBjfO++HO3uMmxMVBg==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(136003)(346002)(396003)(451199018)(40470700004)(36840700001)(46966006)(70206006)(478600001)(7696005)(86362001)(4326008)(36860700001)(41300700001)(47076005)(8676002)(8936002)(70586007)(83380400001)(426003)(336012)(2906002)(26005)(186003)(356005)(107886003)(6666004)(82740400003)(40460700003)(5660300002)(7416002)(36756003)(1076003)(7636003)(40480700001)(2616005)(54906003)(110136005)(316002)(82310400005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:31:27.9057
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 364a8c66-cb6f-43fc-9c1c-08db0471c4a4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5242
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently only bidirectional established connections can be offloaded
via act_ct. Such approach allows to hardcode a lot of assumptions into
act_ct, flow_table and flow_offload intermediate layer codes. In order
to enabled offloading of unidirectional UDP NEW connections start with
incrementally changing the following assumptions:

- Drivers assume that only established connections are offloaded and
  don't support updating existing connections. Extract ctinfo from meta
  action cookie and refuse offloading of new connections in the drivers.

- Fix flow_table offload fixup algorithm to calculate flow timeout
  according to current connection state instead of hardcoded
  "established" value.

- Add new flow_table flow flag that designates bidirectional connections
  instead of assuming it and hardcoding hardware offload of every flow
  in both directions.

- Add new flow_table flow flag that designates connections that are
  offloaded to hardware as "established" instead of assuming it. This
  allows some optimizations in act_ct and prevents spamming the
  flow_table workqueue with redundant tasks.

With all the necessary infrastructure in place modify act_ct to offload
UDP NEW as unidirectional connection. Pass reply direction traffic to CT
and promote connection to bidirectional when UDP connection state
changes to "assured". Rely on refresh mechanism to propagate connection
state change to supporting drivers.

Note that early drop algorithm that is designed to free up some space in
connection tracking table when it becomes full (by randomly deleting up
to 5% of non-established connections) currently ignores connections
marked as "offloaded". Now, with UDP NEW connections becoming
"offloaded" it could allow malicious user to perform DoS attack by
filling the table with non-droppable UDP NEW connections by sending just
one packet in single direction. To prevent such scenario change early
drop algorithm to also consider "offloaded" connections for deletion.

Vlad Buslov (7):
  net: flow_offload: provision conntrack info in ct_metadata
  netfilter: flowtable: fixup UDP timeout depending on ct state
  netfilter: flowtable: allow unidirectional rules
  netfilter: flowtable: cache info of last offload
  net/sched: act_ct: set ctinfo in meta action depending on ct state
  net/sched: act_ct: offload UDP NEW connections
  netfilter: nf_conntrack: allow early drop of offloaded UDP conns

 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  4 ++
 .../ethernet/netronome/nfp/flower/conntrack.c | 24 +++++++
 include/net/netfilter/nf_flow_table.h         |  8 ++-
 net/netfilter/nf_conntrack_core.c             | 11 ++--
 net/netfilter/nf_flow_table_core.c            |  5 +-
 net/netfilter/nf_flow_table_inet.c            |  2 +-
 net/netfilter/nf_flow_table_offload.c         | 18 +++--
 net/sched/act_ct.c                            | 65 ++++++++++++++-----
 8 files changed, 103 insertions(+), 34 deletions(-)

-- 
2.38.1

