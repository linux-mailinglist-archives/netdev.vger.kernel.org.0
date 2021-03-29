Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEEC34CCB9
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 11:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbhC2JHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 05:07:02 -0400
Received: from mail-bn8nam11on2059.outbound.protection.outlook.com ([40.107.236.59]:26049
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235616AbhC2JFV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 05:05:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEM8F4Kjt630vRgH/F41JpyPMIbQYCQOE+rAt12zvenbRngy3IVmUvR73EoPT8HudtaIiDmsQLN54EPWPU5yHEw+yh47gOjXqywNijBIcPQJWoFsfvljGPTWouvx7yvnRhiS1XpL3PJUNhVAvxhhYT1V5/zjkakohG052tcPb+uh7SwyvNEvelgkwoVZjrxSokq49RGnbKQHDjMiWGv10UIy6d7haMQmZj7NIsmSkxkzLetmxemuoaD6i+qUPv3Mlbi/Vygpz1kR9KoItz/XFlQYNTobXzZWIW6Ak2VGYAQrJ4ACGhxC4KujjNPZT7LHZxLcmaI7EG1yn6zRFcRwcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZBg1Up7tZvq8eFZlUeMqjE/QTBj7tnjS3ZdNk7CWI4=;
 b=mZCs6+zeBPeDCP2K5hQMgkMU9g75iQSOF04GTiV/+w5A8aX8RetYMRokArHQZ0oteYchdsuBdrVLNfRKEy4ng5RdGAROIUWtOwINNVROyOGHUaMPhnt9IUN31pUgqV49GqLtff+PKJFsxVWI2HxthNh/gKKqYepiXeV0d9Ghm8Tm1dH983HJi0f/WAj8mjZj6oNY/gjKA1CkVAemvOJwYTQoYW/JwSoHoELYup+eoQAee751FHParUKwcwOEHjPA4d3fjWx0u5NXApXEBIjcuJ+Oong/F4sVwjyLJIDGYevaqXnGCotbPONye9HXIcissuEM28sUXEI9ypOq7SbdZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZBg1Up7tZvq8eFZlUeMqjE/QTBj7tnjS3ZdNk7CWI4=;
 b=o1zlY8ParOKAvtWTSD7IEqhkDXXYt3bY1au63BPluf9BBw1vFSezUBen5xPmPuaIy8MrDNkwOlPNPMybmjnPoQPJZe4qiUz3arOm4W8rw6K0sTPXkwj5f/DR5Aee2u0G1FoKAtfvovWsB637aO8n4LrhHUbk6sfGhGMxlpRfF3q9I9je9Pj/Xp7Yb/RjVW7yfR6l7kiWACN5jQvPFWgeOWtGKpot8XGD/YbMFsLH0Kmfj84wZz5su8GtY2VCpUYfuDf+llF0DR8wghsGz/mKh3EXW3AGlEMyLqOXRlI2FXfbxlHBGVDMQcbZ01V68BFFYnXcAuTaaUKiKmr6nJLRfg==
Received: from DM5PR2201CA0015.namprd22.prod.outlook.com (2603:10b6:4:14::25)
 by MN2PR12MB4344.namprd12.prod.outlook.com (2603:10b6:208:26e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.32; Mon, 29 Mar
 2021 09:05:19 +0000
Received: from DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:14:cafe::f0) by DM5PR2201CA0015.outlook.office365.com
 (2603:10b6:4:14::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend
 Transport; Mon, 29 Mar 2021 09:05:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT053.mail.protection.outlook.com (10.13.173.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 29 Mar 2021 09:05:19 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 29 Mar 2021 09:05:16 +0000
References: <20210328064555.93365-1-memxor@gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     <netdev@vger.kernel.org>, Vlad Buslov <vladbu@mellanox.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] net: sched: extend lifetime of new action in
 replace mode
In-Reply-To: <20210328064555.93365-1-memxor@gmail.com>
Date:   Mon, 29 Mar 2021 12:05:12 +0300
Message-ID: <ygnhk0pqgwjb.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5dbfe19e-0b9e-4094-a231-08d8f291c6d2
X-MS-TrafficTypeDiagnostic: MN2PR12MB4344:
X-Microsoft-Antispam-PRVS: <MN2PR12MB43448463119969DD53AEE607A07E9@MN2PR12MB4344.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZMDHDAY+XIpaTt0M4GycxLrq9qwVNh1KVGGcVtxcuBZE8yYhQYTz1nmW9pwZVtWr+2XIv3hRkb618cGw0fpmvt/fpgW7DD/2ncj7UWg3emcp+ij9K49IMtgKLmm82VekF9uy/J8Y8UtSBO+EzrkpwNFSmwQjxub13xjHRZWrbboy0pHCfNSFaFjYcv9fwceTPwNYJ4yRB7PG8awtF+Q6DVr6kSwpeYM8P+/GSwTP62+sqy+EGjjkugqT3fcutUopY1pmh/k0rXmCgHeIdFHZUFbNBJmb0D3OU01oQJf+DEBoiZ3KFpr27loLuaHifWUEy1weTrbzMEYvGZBpb+SoV0FBbml0DZmObrxy3eRmk3e8OCe1XcejnSYBUX6rS1OgQlRtKAoEMlXSdE+irQzldjiqmwTc058Gtoew86b9fdh4cVFGux64/SUbcLTgYRoLF//YiUuOUJIJZgYhaoyo4C80AGVM4UURVzZqwtKRoKszEgLDHL33VByhA3kobJNkfqtfW9nD6ZsXxkmEcRMMSJfyTVXKbUBPTLaEamW90YBl9TMlpZ7qfOMFKmztl1iT351H+ax41ljXTPX4MzqIhUQ7HLlbWopyfc1KEti4edj9v18rtQPUQzbYUTy4WhPqJIYFr6E+cvGzW+t7mHCavHRvPwul5jI3DUhMUIcMHUg=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(36840700001)(46966006)(26005)(16526019)(36906005)(186003)(5660300002)(7696005)(47076005)(54906003)(82740400003)(426003)(36860700001)(4326008)(356005)(316002)(82310400003)(6666004)(83380400001)(86362001)(36756003)(8936002)(70586007)(2906002)(6916009)(478600001)(336012)(2616005)(7636003)(8676002)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 09:05:19.1728
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dbfe19e-0b9e-4094-a231-08d8f291c6d2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4344
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kumar,

Thanks for the patch!

On Sun 28 Mar 2021 at 09:45, Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> When creating an action in replace mode, in tcf_action_add, the refcount
> of existing actions is rightly raised during tcf_idr_check_alloc call,
> but for new actions a dummy placeholder entry is created. This is then
> replaced with the actual action during tcf_idr_insert_many, but between
> this and the tcf_action_put_many call made in replace mode, we don't
> hold a reference to the newly created action while it has been
> published. This means that it can disappear under our feet, and that
> newly created actions are destroyed right after their creation as their
> refcount drops to 0 in replace mode.

Could you describe the reproduction in more details? Looking at the code
it seems that there are two ways actions are overwritten/deleted:

1. Directly through action API, which is still serialized by rtnl lock.

2. Classifier API, which doesn't use rtnl lock anymore and can execute
concurrently.

Actions created by path 2 also have their bind count incremented which
prevents them from being deleted by path 1 and cls API can only deleted
them together with classifier that points to them.

>
> This leads to commands like tc action replace reporting success in
> creation of the action and just removing them right after adding the
> action, leading to confusion in userspace.
>
> Fix this by raising the refcount of a newly created action and then
> pairing that increment with a tcf_action_put call to release the
> reference held during insertion. This is only needed in replace mode.
> We use a relaxed store as insert will ensure its visibility.
>
> Fixes: cae422f379f3 ("net: sched: use reference counting action init")
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/net/act_api.h | 1 +
>  net/sched/act_api.c   | 5 ++++-
>  net/sched/cls_api.c   | 3 +++
>  3 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index 2bf3092ae7ec..8b375b46cc04 100644
> --- a/include/net/act_api.h
> +++ b/include/net/act_api.h
> @@ -181,6 +181,7 @@ int tcf_register_action(struct tc_action_ops *a, struct pernet_operations *ops);
>  int tcf_unregister_action(struct tc_action_ops *a,
>  			  struct pernet_operations *ops);
>  int tcf_action_destroy(struct tc_action *actions[], int bind);
> +void tcf_action_put_many(struct tc_action *actions[]);
>  int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
>  		    int nr_actions, struct tcf_result *res);
>  int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index b919826939e0..7e26c18cdb15 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -778,7 +778,7 @@ static int tcf_action_put(struct tc_action *p)
>  }
>  
>  /* Put all actions in this array, skip those NULL's. */
> -static void tcf_action_put_many(struct tc_action *actions[])
> +void tcf_action_put_many(struct tc_action *actions[])
>  {
>  	int i;
>  
> @@ -1042,6 +1042,9 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  	if (err != ACT_P_CREATED)
>  		module_put(a_o->owner);
>  
> +	if (err == ACT_P_CREATED && ovr)

So here you only take additional reference on newly created action...

> +		refcount_set(&a->tcfa_refcnt, 2);
> +
>  	return a;
>  
>  err_out:
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index d3db70865d66..666077c23147 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3074,6 +3074,9 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
>  			exts->nr_actions = err;
>  		}
>  	}
> +
> +	if (ovr)

... but here you always release the reference if ovr is set, even when
overwriting existing action.

> +		tcf_action_put_many(exts->actions);

So, what happens here is actions were 'deleted' concurrently (their
tcfa_refcnt decremented by 1)? tcf_action_put_many() will decrement
refcnt again, it will reach 0, actions get actually deleted and
tcf_exts_validate() returns with non-error code, but exts->actions
pointing to freed memory? Doesn't look like the patches fixes the
described issue, unless I'm missing something.

>  #else
>  	if ((exts->action && tb[exts->action]) ||
>  	    (exts->police && tb[exts->police])) {

