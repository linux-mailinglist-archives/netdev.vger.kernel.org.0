Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F149935334B
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 11:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbhDCJZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 05:25:45 -0400
Received: from mail-co1nam11on2049.outbound.protection.outlook.com ([40.107.220.49]:28935
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231575AbhDCJZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Apr 2021 05:25:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+kOKvXTvaeqo6aJuqe83CHl5zWbQ5YlXa+tg54Pn1JwfpcPQ29hce13VNbtmDb08VFL05Aa1kkdz34O6EKJ1DJ16mjAE7YqzY5csEy2pQmXvo+bCmYWmnUNtKiZwrcV2d+CQerTwbj0P/VTEXzC+zOghxKsyC1PbbiHc56xCPcqXB/wfWrodIiWVdttyu1r8i+VlsiYQ1YPTezv0e26a2ok0+clVTay85wL76gK9+uUEEHcaCKGe62PBfFsceul4x2YwMTrryySoFnCyjr4zT7t9kxlgOPFkOcdEeOBR9eD+BhcY0OVR6u7ul6+c5kRBjIQqGZf6pUJkRhIvCvwHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFiP1C0GBJQ9SuI2fQo1WoOyWqIirt0pUaJUligozVU=;
 b=S/1bR/iLNyYhkZhX6fbPLndv2yNojOb6rVrvG21ZyziaVaSw1t13VZZkhp3QcVnlBzKpXlQxYaxtw0djUcXSxMdSvGiLb7qgVXfZMzxtG0k3ri5/vBzjSGX9yrYRKH8wdriCdz05ufINZ+0O5IRsNG6JFma16Ov51fj3G/nw22ZEBanNLYN+1S63NBwjHmaTH1ZII16GEfOQcda2mBEMPeLHy2gXrr17gfGKkCuxdJxfmuSPNvfpOBRnzVA38ZpWBBDMKZEA6IbBMc6ZCoCEwnCl/FUYFoayPBshKfOsTPNqR9ni33JPYSfOHeWlQqKa2VgvJsjSsGDb1f3Le/nFpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFiP1C0GBJQ9SuI2fQo1WoOyWqIirt0pUaJUligozVU=;
 b=RZNvlfBgflIt1Ng7hv+aWF0rUuRLR1+EGrVl/1/XWT02UIgnXv692NuiFKLcQc3digo9VKIdFKWRENm2NOAglZoIXH6JsqYtJOmjuoSvLyAp+UlHacjWuGXblotpKMGOrNh+LYpTz+lA6iiyKscfO8SB/oQ5zip34IX77F417CxaN0VmrSkxWkiwOS2IpLKPUhKyuqRQoEkQUpmGgstpwDfS6sRCRkhTjG9aPfp+bs4/vzeXsEtJ2C03oRtUMoHDxfMUEHqA/PsATSrTaUOy9fsi3sW8iCi7IwBQU5LN6eVfJYvY7i++V5wBD7LWjrTlUhh7w7qrPYyz+m6DlpG6fg==
Received: from DM5PR10CA0006.namprd10.prod.outlook.com (2603:10b6:4:2::16) by
 BN8PR12MB3635.namprd12.prod.outlook.com (2603:10b6:408:46::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.29; Sat, 3 Apr 2021 09:25:40 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:2:cafe::63) by DM5PR10CA0006.outlook.office365.com
 (2603:10b6:4:2::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend
 Transport; Sat, 3 Apr 2021 09:25:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3999.28 via Frontend Transport; Sat, 3 Apr 2021 09:25:40 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 3 Apr 2021 09:25:37 +0000
References: <20210331164012.28653-1-vladbu@nvidia.com>
 <20210331164012.28653-2-vladbu@nvidia.com>
 <CAM_iQpX85rHgUMvwQskEFqa+MRtv5Y_+ZbMnds9xxmaKP=qiOg@mail.gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Kumar Kartikeya Dwivedi" <memxor@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH RFC 1/4] net: sched: fix action overwrite reference
 counting
In-Reply-To: <CAM_iQpX85rHgUMvwQskEFqa+MRtv5Y_+ZbMnds9xxmaKP=qiOg@mail.gmail.com>
Date:   Sat, 3 Apr 2021 12:25:34 +0300
Message-ID: <ygnh1rbrbtyp.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 459fb41e-0025-45c8-8dbf-08d8f68272b7
X-MS-TrafficTypeDiagnostic: BN8PR12MB3635:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3635DD065DB7AD294496127FA0799@BN8PR12MB3635.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7g4UiE17QEEIf5Jva2cFoGeJlPj9Nev1ToWS0uSYEMW4hHaP86RYOOZer0Eds74DZTPPFH8zxT0p6L/tdu4gU9Rx/QpfzYgdrRcU/GDexqQtKWnOHRFlbxtP2p+Ywe6RC7eyTZ518rICKopZNnDhYc4T1HcrramHOauM+A/9BPXbYBvWR1lZCy0KlD4cWaDwdWmGeVzYZarpry5rJIfEuSttBNHbYUgY/ObNey3kGyT8I8MGUkFX5SLvFk6rANrHquzMJAPbnbUMSqZU3FQ3H5/pf8HSjB6+Fn6iT9x2f1LOLfKAOheO3GFmAlWFuVuqrmbrdTQjFABKpmPLkZDWahyvboTH/GGi2i4kuGm3Jot6TGYvQBXSk54dC1kwEs1/YZ+uNvXLpzCGb5AkArsTbczPqx73YKIRTNXSnKnvRI1AX4uf1BgE0KEk/CWk/hivzHTRAZ79WIIFviJz2PjRXTY5T9NL1Tj3Nxcr9wJ+Li1GghgMGBLMlNYqs0/o+8GLCBzSiyivRwUuxoZ1j8A4e2vGozlT8lCW7QTSMykWKkRG2xuDih9J1D2H0t5sRhh6vRHalbFICGN3Bpl5SnZOtFDNGy7/3hokidH56SNFmN+xILZKIZIL8UvuHC3knOypVqsYRR1eVqttJnJyMwaVZyiTYTmQsqTiJYPOltW0l2c=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(136003)(376002)(46966006)(36840700001)(336012)(7636003)(6916009)(26005)(4326008)(426003)(8936002)(16526019)(7696005)(36860700001)(54906003)(2906002)(82310400003)(316002)(186003)(83380400001)(356005)(8676002)(2616005)(478600001)(5660300002)(6666004)(70206006)(70586007)(86362001)(82740400003)(36756003)(36906005)(53546011)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 09:25:40.2509
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 459fb41e-0025-45c8-8dbf-08d8f68272b7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3635
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat 03 Apr 2021 at 01:13, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Mar 31, 2021 at 9:41 AM Vlad Buslov <vladbu@nvidia.com> wrote:
>>
>> Action init code increments reference counter when it changes an action.
>> This is the desired behavior for cls API which needs to obtain action
>> reference for every classifier that points to action. However, act API just
>> needs to change the action and releases the reference before returning.
>> This sequence breaks when the requested action doesn't exist, which causes
>> act API init code to create new action with specified index, but action is
>> still released before returning and is deleted (unless it was referenced
>> concurrently by cls API).
>
> Please also add a summary of how you fix it. From what I understand,
> it seems you just skip the refcnt put of successful cases?

Oops, I didn't regenerate patches after amending the commit message.
This should include the following paragraph:

Extend tcf_action_init() to accept 'init_res' array and initialize it with
action->ops->init() result. Refactor tcf_action_put_many() to also accept
such array and only put actions for which init result match provided value.
Modify tcf_action_add() to only put actions with init_res==0 instead of
unconditionally putting all actions when user set NLM_F_REPLACE netlink
message flag.

>
> One comment below.
>
>>
>> Fixes: cae422f379f3 ("net: sched: use reference counting action init")
>> Reported-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>> ---
>>  include/net/act_api.h |  5 +++--
>>  net/sched/act_api.c   | 27 +++++++++++++++++----------
>>  net/sched/cls_api.c   |  9 +++++----
>>  3 files changed, 25 insertions(+), 16 deletions(-)
>>
>> diff --git a/include/net/act_api.h b/include/net/act_api.h
>> index 2bf3092ae7ec..312f0f6554a0 100644
>> --- a/include/net/act_api.h
>> +++ b/include/net/act_api.h
>> @@ -185,7 +185,7 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
>>                     int nr_actions, struct tcf_result *res);
>>  int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
>>                     struct nlattr *est, char *name, int ovr, int bind,
>> -                   struct tc_action *actions[], size_t *attr_size,
>> +                   struct tc_action *actions[], int init_res[], size_t *attr_size,
>>                     bool rtnl_held, struct netlink_ext_ack *extack);
>>  struct tc_action_ops *tc_action_load_ops(char *name, struct nlattr *nla,
>>                                          bool rtnl_held,
>> @@ -193,7 +193,8 @@ struct tc_action_ops *tc_action_load_ops(char *name, struct nlattr *nla,
>>  struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>>                                     struct nlattr *nla, struct nlattr *est,
>>                                     char *name, int ovr, int bind,
>> -                                   struct tc_action_ops *ops, bool rtnl_held,
>> +                                   struct tc_action_ops *a_o, int *init_res,
>> +                                   bool rtnl_held,
>>                                     struct netlink_ext_ack *extack);
>>  int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[], int bind,
>>                     int ref, bool terse);
>> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
>> index b919826939e0..eb20a75796d5 100644
>> --- a/net/sched/act_api.c
>> +++ b/net/sched/act_api.c
>> @@ -777,8 +777,11 @@ static int tcf_action_put(struct tc_action *p)
>>         return __tcf_action_put(p, false);
>>  }
>>
>> -/* Put all actions in this array, skip those NULL's. */
>> -static void tcf_action_put_many(struct tc_action *actions[])
>> +/* Put all actions in this array, skip those NULL's. If cond array is provided
>> + * by caller, then only put actions that match.
>> + */
>> +static void tcf_action_put_many(struct tc_action *actions[], int *cond,
>> +                               int match)
>>  {
>>         int i;
>>
>> @@ -786,7 +789,7 @@ static void tcf_action_put_many(struct tc_action *actions[])
>>                 struct tc_action *a = actions[i];
>>                 const struct tc_action_ops *ops;
>>
>> -               if (!a)
>> +               if (!a || (cond && cond[i] != match))
>
> This looks a bit odd. How about passing an array of action pointers which
> only contains those that need to be put?

I wanted to make it extensible with cond array instead of make every
user manually filter the action array before calling
tcf_action_put_many(). But I guess there is currently no need for that
and just extending tcf_action_add() with a loop to zero-out the pointers
for newly created actions will be clearer. Will change it in V2.

>
> Thanks.

