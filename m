Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D28A4F77C2
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241965AbiDGHkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241989AbiDGHkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:40:12 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B2852E3B
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:38:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AjI+oC66Tb4UxI6PgBKgdcE9EJyFLCpk8y3e3RSvAl9ANR2P7V63zBDLg3LYj6cw0QJp7lW9wmSjce/Uo/wORedameqInu7KeSYjNGM5OoMCMUDKFxmbW1pnnjNhAtqn0p51tu0sBH32nXcN2v5mcpZ7DVKRqBe20P1RCDmFBHemJ30gQmDP43AvfwmH1crS2FvUNZuvYVL+Wb568PJqYZMz+3BPEoh+FJ69zUfiL0pZz43RZJypRowzFEiEF/v2yvEbmKEWQCIxeGvPH7/8e1sR+DUJslK10aVdeSCyTFRWAum7fNR5vLi8n8PkhfNmwoLloR8EVCo8mHV84K1lGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hG60WfkarWnznb1OqkjIt2IGZ9fOdVDQsGNeN3ThKNY=;
 b=ilZBOt+Wm0AYG6DJoAfMShmP3Rquv4zzgVyieHHkC+e8Lve9hxp1X310f6OPUmQWOtlwgk09gro7fGE8WXwI7Mzk2GxQgLHr19bG6OIzMn2szbLxpE3Q10kTQWPWSpU/clOpHbKMKhE6WGJ3GOOnErer2j99F/Qb8MiZirwCF/IWdyLksQ7YCLfTvj3WI3TQaqugNe6+6bVA+Ixi0P/8lK12D48NadI3XarmEZ+hDxyHd5qW316ONfNS7FbwQyiHWwLUjhsT6jnlQQ6ay+qPXUz8s8squdwpo6etcoEtYirSeouX5/T0i4kgIkh05h+4JmZO+KtUB43nlxKpdyII+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hG60WfkarWnznb1OqkjIt2IGZ9fOdVDQsGNeN3ThKNY=;
 b=MkCARtzwPpgHlterQaEiF4RFv6sWvrU1R1rYkFbHoYBieAQkkjEau4hTXRYhxdDvkSQVMNsIagl9YopTxRXdGrHrFUspqNIl/ViDmg0v8/DhK7ibsBkfmd1IgiwkQcuIjXd3mTYHEWRbjW6L4eAbdFOfoRr2lNBT5T4+lOVU6DUFHGquxWQWgOK3dn6jusZ1HpS5G6lRsmZEJyXrIYv+KJ9Jp0wifAS8AYEakblis76Iaz0Gjxbm+El17SNiZ9eDhcv9mxIErjnvjgN61XYudarg22hhIdavyDz035DoZIXIahwQwC8XCWOh/ISCF6Bw6hJhSFcuLrDr36zw20u/Zw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM5PR1201MB0188.namprd12.prod.outlook.com (2603:10b6:4:56::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Thu, 7 Apr
 2022 07:38:09 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2%2]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 07:38:09 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        petrm@nvidia.com, jianbol@nvidia.com, roid@nvidia.com,
        vladbu@nvidia.com, olteanv@gmail.com, simon.horman@corigine.com,
        baowen.zheng@corigine.com, marcelo.leitner@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/14] net/sched: act_mirred: Add extack message for offload failure
Date:   Thu,  7 Apr 2022 10:35:24 +0300
Message-Id: <20220407073533.2422896-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220407073533.2422896-1-idosch@nvidia.com>
References: <20220407073533.2422896-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0211.eurprd08.prod.outlook.com
 (2603:10a6:802:15::20) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f504c5c4-746e-4df0-7e6c-08da18698fdf
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0188:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB018854017D77436F7431B715B2E69@DM5PR1201MB0188.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nk5IAKfZQ8eTugyitm9/TVvFJ15mgdg4i3vxOgVLxQzAB+RSf/tnlppkegiZ90T38sWoEmqQ8QIkHA+xpnt5mad4hkt/LyepUZ9aQpHpu11dBEq/rwPlwz6waMc6EUWitPcR/oYxDH+idiHzxxD+d96fIeikvAVoW6CxvyocH3XGj9S8h/nB5f4PMoulmHhtC9CkcjEdB9L9WVuxlkYyGmEOw/DrrQ8EaylHwKllvggzT9GkncqKyx7db2T8WXeaZaqSbm3ErNIBYhublc0umCUxL4MKPFavWQyoL8/JOSzdoKG274mt6O4/MVTG5WR3WGDXWIVvMcA97x0WyDj8ku+uaa/QBNT6gHQywCa9PCfO13OlwWQtklDZVauioooMuygY9C5Bizn1tY2O3J2e3HMJiLjXkPGCSGBj2QlcRaT693LLOE3gjzhWAcYXrka6JtRNEaZHKeJ4E7TyFErgAkLOFHYDFCUXvxEA01SRMtRcXQvQk4EfG8DoffL+MnLLD8UWPN/S2yDtDGdcyR4b7JdMOAsItIjNQ1pXoT8xbF0/oku7si522hf8NTwaylmJ5EpGDit4QIMLLqAMVIwtaLtBwNhdwUrup653XnEJWBkkonXP5kgnk6rApwrOQG7xNGDqvMMfoNlHClW++YPngg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(6666004)(38100700002)(186003)(15650500001)(26005)(2906002)(6512007)(83380400001)(6506007)(1076003)(4744005)(36756003)(316002)(6916009)(508600001)(6486002)(4326008)(66946007)(7416002)(66476007)(86362001)(8936002)(8676002)(2616005)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?26928baLDmeJ5OEJ0FzPgpe1b9tGpWFExiA7hZahh0yiFndv794MEptVNLpe?=
 =?us-ascii?Q?UoJUhiNQggaOovK9XrD1oFC+bsFb0EerUpyJMPkEHPD1I2mFZlErewvoAgXm?=
 =?us-ascii?Q?sb8LG7JqKhFTc6wxOYHAU14Dav166V+POq51THFAPvlrPgmA4nz+tnAiQt6X?=
 =?us-ascii?Q?naWqiH8yOGxKfFRPGupAjUbz59/4hTQwUZ9yRtoO3TH2P8Ac0fFuOOlGXKyn?=
 =?us-ascii?Q?J+PTNrxCbM6k6wlOHXr7D4rl9bwjxd4jSYcAOft/S6g9hozQE3wXsbDhKQnV?=
 =?us-ascii?Q?/5mETdSEZHDM2+R1+KNFMykq0c77sCIMa05QK/PfA1sTJxO3KMarKPBbtc9Z?=
 =?us-ascii?Q?qj4uriKTNhY9mXlo6z86J1klfh+31vvYg8jWggK8diH1MWXfAgiHNxTP77w7?=
 =?us-ascii?Q?931pkQuGpI4ILbkbJXOCKKFz9NCtCxzxKaeoD3EgF6cVsjHU4Q+crEqbxsJ1?=
 =?us-ascii?Q?31ueDvD9PLi9DbVXqPiuGFxE+H6ZxKSfxQ1RzKJ1LhzdR63cg3eWT30swoO8?=
 =?us-ascii?Q?y2c1Edh/6WD35M2+GIw2gqJAtmQhdrz9kmLtNvuBWHIfuqLYY+OJzT0Apf+t?=
 =?us-ascii?Q?w/mP3nz7O4q5oIQavxacvPqi98wD9VcKs6yWGFxcX7nvavXQN59+4kd1XZfG?=
 =?us-ascii?Q?PnLfd1yui+GVpFTPSCkyOrIU2jNf6UpeTB6x3kHftpnkIPrS69Ut7HVquHlH?=
 =?us-ascii?Q?OC7pmFsKqnpyB9t3yzA84n1gAT51ly+lzEWIDk9cfHEO82saHUgYJN0vCaXl?=
 =?us-ascii?Q?Z8pkvp/rEQcn2PihKrY4UxEjFrnGv2jdt+j6p3Dr8z+hj85NbSB9eYHGigfB?=
 =?us-ascii?Q?6YGokhDoHv8lgUJLItiXfv5dPmvZgkwAD/BUqf9/ojSoMTJllMzRc8BBgz+u?=
 =?us-ascii?Q?hpU62/eX4b1+6iU63w4U3BsUKwMr0SmQ1jrq3RiJlLeEqhb9bGykWSaHZ7hR?=
 =?us-ascii?Q?iPDiNLJvA2hZeVJtGJm51q+oH2rUcLDmYZUvA1AeeXCznO6yOc5D3kg0s4jk?=
 =?us-ascii?Q?3VKlbLfwHpU99UYit6MrUayzP9rdzj/JpZxPIlwrhEAl/LuXmOwq4HTUGmfn?=
 =?us-ascii?Q?MUUScHtx1+obkPYfhOOrLFeRNWrMzgrnDsL87+c8659ahjzir3B9bC7FbEUv?=
 =?us-ascii?Q?EQhOIK9Ige/H/ozrveRzQmq1BRoJOBTyeTITGBJQZRLSpVKKcHVPCKt5pVBy?=
 =?us-ascii?Q?/31bVXTgOPy80OShe/Wz4Q8C53zRwOEJf8F9v+c4/r4A3L90RAwm8jfAGiC1?=
 =?us-ascii?Q?+1s58hNKYB+QL+O3jm+eTyHYg7rYY8TbXl+wNf1GytCUvxdeeFCT9ikmbzQ9?=
 =?us-ascii?Q?QpB/T5cA7aHPYpvIW/MA+h5Fy4DdE29k7XX1MT1Mofkzlbhuv/m5bEVRmfUv?=
 =?us-ascii?Q?G6HCfvFd3skoLZF9sn9ZUGbhcgDPqVxPYUBltShrbYzYNcIeXvx/DQUbX9Oy?=
 =?us-ascii?Q?ZAbMfiR4rxK+kdx+rLA4klVmO/4t3jLX0v/bkXik47NbiOPTkAiiA4WXj8Kd?=
 =?us-ascii?Q?O8GlMyXzMXqracuY/G9D1DlPAK7OHLHjqooAaTZU1NEtzwooXVF/PY5rmAgd?=
 =?us-ascii?Q?g7Wb5wDTScuFwkYEkWb+tnEaJdV6bVKm3AEUAoYaPZsfCAU4hE7tHgeOEaSA?=
 =?us-ascii?Q?FprTseV8xmeh8Yg15S1/cVJPwKn4JMsCTHwsZJIlghoIDGPu8WXn2EtQW9xn?=
 =?us-ascii?Q?6DSvaZQp+qg3D6IYtQF9MpdhVo3FghaRI4Oxy5/TN579GWeNHPG6hhqamWRz?=
 =?us-ascii?Q?NP+MOeUvjA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f504c5c4-746e-4df0-7e6c-08da18698fdf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:38:09.1548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /+/hlN989Gi+fxw2Z3FaH9MgdBTzJlHsWlKuDqAnHY0Ab5rt7uRm6UpMbjQb/vmDxQmgMdBUXjo6N/dia4KSJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0188
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For better error reporting to user space, add an extack message when
mirred action offload fails.

Currently, the failure cannot be triggered, but add a message in case
the action is extended in the future to support more than ingress/egress
mirror/redirect.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 net/sched/act_mirred.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 70a6a4447e6b..ebb92fb072ab 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -479,6 +479,7 @@ static int tcf_mirred_offload_act_setup(struct tc_action *act, void *entry_data,
 			entry->id = FLOW_ACTION_MIRRED_INGRESS;
 			tcf_offload_mirred_get_dev(entry, act);
 		} else {
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported mirred offload");
 			return -EOPNOTSUPP;
 		}
 		*index_inc = 1;
-- 
2.33.1

