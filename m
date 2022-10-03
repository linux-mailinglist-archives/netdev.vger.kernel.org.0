Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616795F2887
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 08:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiJCGSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 02:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiJCGSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 02:18:22 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D26349AF
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 23:18:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UrJqvSpMFh0KcQ2iLRxV6RuUTEWkMOQFJG8z2GcsQWo77a05e5pGEZuPn4GMm4tB8rxRD5V4R5UB7/5bAPMLWGYjJVp1ZdFP29vu4cbk77Qwrm3sFFosUfoqbNd5M9HjlEuAH3IQmJwt4Du1UsHyhLIRhqO+4gP7QaSrdOqwGU5brswhf52Y3/pZkyxgO0L9txN2ZHxb4NJzXrEoiA+S5fQACyVtO/DnekomyZT+iXnWPl2Jyui/grrgvVt4chxMx4E0TKRVISbrpYPpKaG+o1nBlm8t/Y436aPP/ujWc0+Vtoo6+O3wrK6+NVaiDpH3SGaXLGUb/ZBn2oBw58IrdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/boW0NH6CQ291/YqOs3A8UVDOdnRlr4M/1XTebnZTvI=;
 b=U4nVbx8MZkGca4zsHpolcn+GLxIx12F4ZywbaCB3ydb0KyokcUDpPxBIsvO+ihtt/Uik6hIaPXCIq2LPWXSr0q0tqH5aePlbBgT21jZZ6OYz4tu8g1Zakjk5p/LTIKVfQglHg5MI3bqJnidUHCvJtBt2TWFjzx3/e/OUXNkm5DWPtIKzsbozRzcrwEHxd3rRNKzMiCEJRNXmvMLMLuZcPUXQJN9Nk/R6fTxDleNUT7G8Pu3QkZrc8xkhVUzU42sSBmpdi9KVEbX9nXKkPh7/vIm4NmUqB55yUybKvI841cKOGgOQbrhewd+uaURVbXRJtKDoCuqV9l8TDIhnpcypsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/boW0NH6CQ291/YqOs3A8UVDOdnRlr4M/1XTebnZTvI=;
 b=hz41sbvLaSMbTP7N699uqa+viqTvLVVU9Dh5rYk6tKb3cWiv5ez2SFuTvBdQReEvIVXOqMZ46HJmrih5V/BjNvBHe218LbXGEQ2aZ7OCUn4oUpJ0mZAg99noT/Uu1n/VPxPFqaF2UHqQehORfbam/ib7S24Z11sHZ+4aQf5XZaG5K7SGfgT4znSyhRZ/XN4hz2NYjsGWVK9Nj3Qsy6geg1X8ogWDIpnHbp1MexThAGpgjQl41cikJW3SwEVT0Ws+uXEb2vxpk1s1jRELJwpHN2EcO4kSXG6GpIP/L/c+RPAU9utvMkAeCHAFFpparsZwIl8o6sjIFZxFZKWQZmrfKg==
Received: from MW4PR03CA0082.namprd03.prod.outlook.com (2603:10b6:303:b6::27)
 by BY5PR12MB4180.namprd12.prod.outlook.com (2603:10b6:a03:213::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Mon, 3 Oct
 2022 06:18:19 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::33) by MW4PR03CA0082.outlook.office365.com
 (2603:10b6:303:b6::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24 via Frontend
 Transport; Mon, 3 Oct 2022 06:18:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Mon, 3 Oct 2022 06:18:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 2 Oct 2022
 23:18:08 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 2 Oct 2022
 23:18:08 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via
 Frontend Transport; Sun, 2 Oct 2022 23:18:05 -0700
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Oz Shlomo <ozsh@nvidia.com>
Subject: [ RFC  net-next v2 0/2] net: flow_offload: add support for per action hw stats
Date:   Mon, 3 Oct 2022 09:17:41 +0300
Message-ID: <20221003061743.28171-1-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT036:EE_|BY5PR12MB4180:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b8a00b5-16d1-457f-2a64-08daa50710b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uo1fNhCFZeqxl3HnW2oS8/gGsUoQefEQpoGPTSLW4aa5vTteufjdjZhrxe+EnI7MsdIlG6SKgsHRiB6ScJk3zsWmsZ4IChW6+hfJrbbm78oGvsQRAFvEmUgaO9plF66nqZucLGf83dKGPocnUSfvvWuErPdOxnLT5mLWllZjyteXf+lsQtpUuE1hTw3mr/TD+2naXXlPMNDQLJ+QlsLa/gZRFOKNzUrX4VZ1cDG++35i0EbNaq+bEl9rpye1abwTy5FQ6FTqC58F1VLe4nEwir2c5X7w+UPuXdGmce3cjxRH+9wMKeiglX3BRT8xW9R4I7jfHqaAFBDkZN9/Iw6MyozzmUJ2ptJWEa7coBNDpODUxLjkI/58w+5lcfwaMTdBytNDZ6zNC5tO1RvetClffc8Mgx1U5oMCZ/d6xL5IzJqTKuoOkQ/KBmImTNEGXDenIODmccpwTtJeS9IN3eagZBPkvnR9/wDLFCFjex32ihxRmTK0kUCfKPnDYaBUSaY0cD6yP427IPjZho9SJUVdXFSWccetvCd/T1g1eeSRRMwItKTaqE2hlR4vex/nNrLKfbGJ6pk1jab8DTSG/nmo8gN0q0VVTSjURoSpYXTasIW2f+YGilTXYe83cJL73e83Zip5pFf5Y1mBMFZ0e2keFTpuqtr2NRs4LpyBYAVL/00cTogZvAvRqYareH14lptyUOrqFaokgjFTsLqoj4nfd9DSMYOf26Kh/+kr09cxCu+nlfSN/qOU9IdGrZbm7wqwFCS9mQXIUjT4mCLU6Ot/tw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(39860400002)(376002)(451199015)(46966006)(40470700004)(36840700001)(478600001)(316002)(6916009)(54906003)(26005)(8936002)(186003)(1076003)(2616005)(70206006)(70586007)(86362001)(82310400005)(6666004)(36756003)(107886003)(336012)(2906002)(4326008)(8676002)(83380400001)(82740400003)(7636003)(40460700003)(41300700001)(36860700001)(5660300002)(356005)(426003)(47076005)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 06:18:18.8159
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b8a00b5-16d1-457f-2a64-08daa50710b3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4180
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are currently two mechanisms for populating hardware stats:
1. Using flow_offload api to query the flow's statistics.
   The api assumes that the same stats values apply to all
   the flow's actions.
   This assumption breaks when action drops or jumps over following
   actions.
2. Using hw_action api to query specific action stats via a driver
   callback method. This api assures the correct action stats for
   the offloaded action, however, it does not apply to the rest of the
   actions in the flow's actions array, as elaborated below.

The current hw_action api does not apply to the following use cases:
1. Actions that are implicitly created by filters (aka bind actions).
   In the following example only one counter will apply to the rule:
   tc filter add dev $DEV prio 2 protocol ip parent ffff: \
        flower ip_proto tcp dst_ip $IP2 \
        action police rate 1mbit burst 100k conform-exceed drop/pipe \
        action mirred egress redirect dev $DEV2
  
2. Action preceding a hw action.
   In the following example the same flow stats will apply to the sample and
   mirred actions:
    tc action add police rate 1mbit burst 100k conform-exceed drop / pipe
    tc filter add dev $DEV prio 2 protocol ip parent ffff: \
        flower ip_proto tcp dst_ip $IP2 \
        action sample rate 1 group 10 trunc 60 pipe \
        action police index 1 \
        action mirred egress redirect dev $DEV2
        
3. Meter action using jump control.
   In the following example the same flow stats will apply to both
   mirred actions:
    tc action add police rate 1mbit burst 100k conform-exceed jump 2 / pipe
    tc filter add dev $DEV prio 2 protocol ip parent ffff: \
        flower ip_proto tcp dst_ip $IP2 \
        action police index 1 \
        action mirred egress redirect dev $DEV2
        action mirred egress redirect dev $DEV3

This series provides the platform to query per action stats for in_hw flows.

The first patch is a preparation patch

The second patch extends the flow_offload api to return stats array corresponding
to the flow's actions list.
The api populates all the actions' stats in a single callback invocation.
It also allows drivers to avoid per-action lookups by maintain pre-processed
array of the flow's action counters.

Note that this series does not change the existing functionality, thus preserving
the current stats per flow design.

Mellanox driver implementation of the proposed api will follow the rfc discussion.

-----

v1 -> v2:
- Change flow_offload action stats to a static array
- Assign action_cookie to flow_offload actions
- Use action cookie to dereference the action to be updated
- Remove single action update

Oz Shlomo (1):
  net: flow_offload: add action stats api

Roi Dayan (1):
  net: sched: Pass flow_stats instead of multiple stats args

 include/net/flow_offload.h | 10 ++++++++++
 include/net/pkt_cls.h      | 27 ++++++++++++++++++++-------
 net/sched/cls_api.c        |  1 +
 net/sched/cls_flower.c     |  8 ++------
 net/sched/cls_matchall.c   |  6 +-----
 5 files changed, 34 insertions(+), 18 deletions(-)

-- 
1.8.3.1

