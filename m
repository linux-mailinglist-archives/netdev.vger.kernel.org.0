Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111096441A3
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiLFK6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbiLFK6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:58:37 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BF513E03
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:58:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXcU1JaE6og7LxzbSADa4z9xnS2cDsp0+62LLH47Nmyp3sCiQKMXqlONLBniermfBTrZvOrjDNoTqT9rwcnblHD+1LKojhn4uSw1ZEGYcQZGSbqBLA2BjHuPoMIuAQC0Zog1PfbpiddQL7i5Ck4p7kS9DepEd7N8kI2I2KpamITXcfgJcUN/SgR2JD8svNcmAxmwd1y+ywRV2ORaAzEysgKwu32QEkPgfDZt7772X+jq0KwPIvRVTFUNAZ4qNknGsjnAfh3Q9RMtJy5gd8/s2p4DuF1JgKcywJpdJhD/HD0RHVGYbO0/K4ATXH0yTd5ETCRrsLNsQru+Uo05+bI6IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lJaNE3XF4lrpzF5wreA+/UkzWpCcVKuoJbopIEz17P4=;
 b=ZMIrYbx/Mu4LRIc6wLHgTsnNOTWRqdYdgtn2bJQFvCm19mETHzMgyDXCIKu79y0DHb+LVgBJy+e/zG7qmtkQTpgUIsQwVvX9qV4aEf1mYNMftVlnFuoRvFKf5Eb6y1wRtibLMkcg6jG+p9GZMrNIfwm8bpfZNq2trQ262v4yJtdi26GA4YEisf2krNJNQtPib87YSjHgyFwOQGYyRJYYqF690Itny0gmT200ax8BGtYWqp55sULgu9GtM+QMkVihq/hxdsUavitTroLpriPnZSQdUR9vgKnpzD+FposqeHhR/wrjB/paoxafkOYvGEiLpnGPumfTS5to74bO99t/4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lJaNE3XF4lrpzF5wreA+/UkzWpCcVKuoJbopIEz17P4=;
 b=pvW/VjINK2ul7GEtdLH6sU+zY2J28465b/xbQqHrikw3YJpy6lhHsEk1YjP61AWxVKBdRtzNlxxYml8+mp9OhQganF7oL/GiyLRoyzrV9/d1rIQBqUh4+B5LHkbjJYfzB5SVd4HPWSQdpaJj92JT4GXvtUT9ybo+Oa6QJTGzGhuJitFZEQI7RZe6XQuQkcS47+voCvKB4/9lkkSq2fveryfy/Hh2OwioptY1kHfeYqleWwpKdLCDrx5oJoI3kKYYV9Ge4WeBlRCJCBk0VNBda3Zz1T62Hg7FyM9kZBCV5Ja/Ij55/Fj1f8jRBMqaIm9A8QXlgQpJsp051uA+KzVtCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY8PR12MB7100.namprd12.prod.outlook.com (2603:10b6:930:60::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Tue, 6 Dec
 2022 10:58:35 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 10:58:35 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 0/9] bridge: mcast: Preparations for EVPN extensions
Date:   Tue,  6 Dec 2022 12:58:00 +0200
Message-Id: <20221206105809.363767-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0120.eurprd09.prod.outlook.com
 (2603:10a6:803:78::43) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CY8PR12MB7100:EE_
X-MS-Office365-Filtering-Correlation-Id: 2774676c-e0ba-457d-44be-08dad778d16f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nVpC5EkBchfd3LABGvV7B4Wcehjb+zu49aqhwfdKalFaekfd+yDDyXMaGj4iWaheSFAjdrDDVNW9YjCI9DQNQQJ2OF0IQEmngMn0ZHYerPDkXz0WOnsdCmebquaBclkWABp6CfYEv4w5HleAjozda+OpNhzpR0Gtj/8fGDzB/D9iq23I8pIZIsgvjPV4eTJGEaR4YQzgYr+N8PKBrvvM7xFFTFL9SBzkwwWMPEXXk4+oLekelnyWaK1QWnEpDKAyUTX5P96+xiWpwSEPm4UbQJx6/esLuFmlDbmh9l91nmSMbkMAFWRyOu0iUHNnCT1rQrkVp+l01ZwscV6d5xFbLTATj496EySzAvLcWBd1zpR8/VbbuR84r0hwM0bbA5pnrDi/zuI+da7BhY/WOMjkpx3mulHliN8KXtomHaWiJSugPYuMXI8evVCfQITkYzqUK31tQofmr6eGe/ZVWdMVNVl44QZLksmhTbMvkztYb4JIo1Hs1Rq/pTEruK9CUeorB3z+US04ktsOBAB4hRtKY/gH+YMMX+2VfJDqLpOY0hOR9MH7wnHUK5m+FLCJ1s3qTM/qXInA7FInCt/a/Bewpr6RE7oJ6y4JM63MI6KEW68SzIUIC5l4yLzDFCxfE3C02raLLPYYThdgWAQ493qDZhFHFDmjdwS/kB3uKv0WkS2fBuyP+oaSWb7+ZIMBADgLlgil6+IW6L0eyFZbWOUn5Wp/65uvBEtmrGikmhGD1PZixNjY2XgjKgWwl7ecF6rtsxDN2EmRzHXoZZUwmsbf5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199015)(1076003)(83380400001)(186003)(26005)(6512007)(2616005)(6506007)(6666004)(107886003)(66476007)(478600001)(38100700002)(6486002)(41300700001)(2906002)(316002)(66556008)(66946007)(8676002)(4326008)(8936002)(36756003)(86362001)(5660300002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tllalzf5x0rpXR+Tlo/VB/2LQZc3LaPRIMk0OJXvs3yqRpdOLOTpbv0Vd2rD?=
 =?us-ascii?Q?H8UWkVOT3uUaIxbBUy+a6oU/tWI3KNNdbvbqAOtZJMRog22FwSOID0JN7O2w?=
 =?us-ascii?Q?W1kJlvj5Ey2LPrbVAUs2ud5rt9tl9KxC9hPcdYN1+jAelWOE8KkccqmYdVNA?=
 =?us-ascii?Q?kxDytW5tyjmQZNCZwLOD/ViFe7XI5wAcCIhhxnLf1urC4fjwt+6mHpX6IJR9?=
 =?us-ascii?Q?BrovIn5gFy1De2+xdmvRexOk6gBNjFxJHHcN1T9t+BPeN9gp58O9vi0eJPom?=
 =?us-ascii?Q?gb4p3/9Zsusudsaii41odD6HjjseQUWlc2uPoOvnQRosoKdFsOYbMUnGlWcm?=
 =?us-ascii?Q?I5DyzMfLW+pxRDpt5dk0gF9MfmE3JdqzfybGrJtBkXxMTwIh91K7PTZPibfh?=
 =?us-ascii?Q?Y3QdajYZ/EeGONZBYcWq7XgkOaxvw+cAmHipsx9iNhSR7SuOzsO+E3+PKfP6?=
 =?us-ascii?Q?eRl0xidBY3cyIXYA84a1sPaFqdBDYSQ87815gPjDXPcXCWoFpn+DCB9LjLQ8?=
 =?us-ascii?Q?j74cAnZWlPWLl7c2HuA27meQ5f8YQsJnl27gn0z/lHxm9d1KEJRTYVlmEaHd?=
 =?us-ascii?Q?LtmMyDC63A0rZAuMPiiUoNr0PoSK8EbuKbKXFID4yZAgVtY2/aYahEkCpSdN?=
 =?us-ascii?Q?MXov+MYsEMMbIqL5aCktMOegA/Gw/S8uBIJ6SRHr7tJul7NhXooxm2Up3GiZ?=
 =?us-ascii?Q?7vpa+B1e0HrXE0tk9ByK+jwy1PyDdrQ6gOnsmtz5KtxZArf/JyxexGGL5vRH?=
 =?us-ascii?Q?CVnremZ1Gu1hTVbsw7pkBTUjVmDX0LEDEOD7ajtsuRbYzAEW1XGURoK+6tW8?=
 =?us-ascii?Q?FBJa9S+liWzTr5tQJQfjTFyCY5ImvWDO+NGOLHFD17nJgXy8oepBRJqPK720?=
 =?us-ascii?Q?bduBfAHULrRze0+qjwzV9iMzHb2KmgKgvnkG9FFvBaFSr/eXj0O8v/vx38of?=
 =?us-ascii?Q?Tu9QH48lgAbfekAYhPbARxmPh2FIY5iyP6PTTPVKuZCNuqd543FIHlVWwQPA?=
 =?us-ascii?Q?BHybUH6JuScVJg+b5iq85tG3Di4MANwUdYufyr0aY+9IB4Ue+JjLD3C9xCOv?=
 =?us-ascii?Q?s3SXeDP03b7He4S9Lqu97jiu0gVpfKaibTrV3nv+kQusycB7hK2ApLZHiaMj?=
 =?us-ascii?Q?Y+075NpEQNE3wFIJ0vOhUKAL3dDpVF2UX6VlWrlvgu4VleaHUhzsMHei9Hln?=
 =?us-ascii?Q?8b5jnt8UwH3Y/+5KVe5EIn6SHcvOY07s2H+EAT7rdhWREEryXQOaBe61eXue?=
 =?us-ascii?Q?wfUUuotYL97JzpE7PvOXyuRs8DOmG/FHOb076EALsVqOENPvfFAhsZIRbSyY?=
 =?us-ascii?Q?wbTbRY3+rJptTQRYObQujcUn6bXFBctpXk+99Fy+AEkigjLnf0VKINuj8YyM?=
 =?us-ascii?Q?FYjAKa+9p150YXyAhlvZ7dnGn22gsvNPUtH710k7gP+Ake/XsRjeKB1I9h1A?=
 =?us-ascii?Q?MeiSeSsVWHLFA2ntKofvgvbYKOw+wkdMc6SWKX+S7VN5zOR3QzifxQaVT7iA?=
 =?us-ascii?Q?Yrw2FO/Uj9VUwIipz7EoTMDdJPvNs+jz7D5hYimu0cmkYFGRNxaXd4xtAZ6z?=
 =?us-ascii?Q?iY/VfDxV8XjT3CY/5CDW3DdQZhEUjXKpsq8i3ZcH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2774676c-e0ba-457d-44be-08dad778d16f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 10:58:34.9863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kDJhw82x3QslpTeTEQucdAGqF/HnRsIn5abhHFfl4UNfQNc/qBANH1szfdHcd/fa1115BN0IVI3qaCfhMAu7Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7100
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset was split from [1] and includes non-functional changes
aimed at making it easier to add additional netlink attributes later on.
Future extensions are available here [2].

The idea behind these patches is to create an MDB configuration
structure into which netlink messages are parsed into. The structure is
then passed in the entry creation / deletion call chain instead of
passing the netlink attributes themselves. The same pattern is used by
other rtnetlink objects such as routes and nexthops.

I initially tried to extend the current code, but it proved to be too
difficult, which is why I decided to refactor it to the extensible and
familiar pattern used by other rtnetlink objects.

Tested using existing selftests and using a new selftest that will be
submitted together with the planned extensions.

v2:
* Patch #1: Remove 'skb' argument from br_mdb_config_init().
* Patch #1: Mark 'nlh' argument as 'const'.
* Patch #4: Pass 'cfg' as 'const'.
* Patch #5: Pass 'cfg' as 'const'.
* Patch #9: New patch.

[1] https://lore.kernel.org/netdev/20221018120420.561846-1-idosch@nvidia.com/
[2] https://github.com/idosch/linux/commits/submit/mdb_v1

Ido Schimmel (9):
  bridge: mcast: Centralize netlink attribute parsing
  bridge: mcast: Remove redundant checks
  bridge: mcast: Use MDB configuration structure where possible
  bridge: mcast: Propagate MDB configuration structure further
  bridge: mcast: Use MDB group key from configuration structure
  bridge: mcast: Remove br_mdb_parse()
  bridge: mcast: Move checks out of critical section
  bridge: mcast: Remove redundant function arguments
  bridge: mcast: Constify 'group' argument in
    br_multicast_new_port_group()

 net/bridge/br_mdb.c       | 312 ++++++++++++++++++--------------------
 net/bridge/br_multicast.c |   2 +-
 net/bridge/br_private.h   |  10 +-
 3 files changed, 159 insertions(+), 165 deletions(-)

-- 
2.37.3

