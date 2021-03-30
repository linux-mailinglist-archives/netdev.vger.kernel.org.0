Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE2234E581
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 12:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhC3Kcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 06:32:45 -0400
Received: from mail-co1nam11on2079.outbound.protection.outlook.com ([40.107.220.79]:37669
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231529AbhC3Kcn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 06:32:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtU6ZgQ8zU2/EOXZAdEyqQI5iBfYFr42l7gxHWqobrRXv8LbrksFKQl4TigMTzhwkhVxUIAxIqUuxQu5bcUhhsuUEnFv2pDv/DAtRk1QgToVEv0uvXE3gagTlZrTbrcnbviv9467H7bC079hVpemeEyC+RS9tiRpWphpPRZZYQZJModwe9L+5IRXNVNanpjT+xRkCdEDms9T6ueZfRKYO4mgNYboba73jgw7kKrbv3mHEIzi/iqUbrdPD9Q37tYVvrlOhlFGXAQy1BKxgU+KPEwh91iZhWSYvhx+SVyBvvqNYvUGjDciVEhEzCsXA2EZrKpIwVwGWqT3nIgTnT7qXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptnLKcWWYsm7IVHOhOBj91iFE846RC7E6aqjCqNoaEY=;
 b=lWqxJcZhxj+WslWCj/08J5opg368xt+EEXMrv61Fp5c4YgeZSlJj9oUKvo4Ihnh/TovKg8XTsk8/dZq8yXtsTcffq1cJSGdQ5HlQ/PB1PPFYe4F8yFQbAmEeCZ9xcqLQLeLMZM5xzmHoFuzI9RKEjcRuw/LISKzNyyvma0DiKgYkvDkNjBH6397SuBsO8uZSZsp5FZQqi/fixTXZQ8ZEyXR1Q4BroQv7BhGZN6nOCUzKwFn0KAvRmVj+uG4hFQ46CqlaobxfY1KIwRs8pHfoUMyfMrMgKyKzvAgDOtbdr8rLmF4lzTP2j8bKt+N1eWx38NzskGfXgkp7S0VS/kKW+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptnLKcWWYsm7IVHOhOBj91iFE846RC7E6aqjCqNoaEY=;
 b=GadEEji2lotcCOA4bTCOLrBkoMxGKQnqENu5bofG+/GWGzC220LlDNYJcd3cCOmUNWqR0COJMUF60yc3PBnBa5pQriNkH1TvVYCj8GhkIX9vg5dDZ+2UzaEfNfPu/B+aq3S0a8oclTYJ41+twFP66BFy15GJdpAnYv8/mQftCFfmwSAfmrnXIRhf+CovrCHUd/YYwu4wY9NONUesSak8qdWjvuN4pygYLRUmcGxB4atDc/HzsjglUBzfF6m8dpuMAqVomigZmlXs2lZuDDbZ/x+P0Q+1qxJl84ZGlnmte4O3x8hJBZZIZRP3/4DmKdKa8/xF2T9WPmHViLlMaDUe4g==
Received: from MW4PR03CA0147.namprd03.prod.outlook.com (2603:10b6:303:8c::32)
 by DM5PR1201MB0124.namprd12.prod.outlook.com (2603:10b6:4:58::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Tue, 30 Mar
 2021 10:32:42 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::b1) by MW4PR03CA0147.outlook.office365.com
 (2603:10b6:303:8c::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend
 Transport; Tue, 30 Mar 2021 10:32:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Tue, 30 Mar 2021 10:32:41 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 30 Mar 2021 10:32:37 +0000
References: <20210329225322.143135-1-memxor@gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     <davem@davemloft.net>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <toke@redhat.com>,
        <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v2 1/1] net: sched: bump refcount for new action in ACT
 replace mode
In-Reply-To: <20210329225322.143135-1-memxor@gmail.com>
Date:   Tue, 30 Mar 2021 13:32:35 +0300
Message-ID: <ygnhblb1gce4.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 982bd923-6d25-4632-1302-08d8f36725e1
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0124:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB012483F06A1CF6246B170EACA07D9@DM5PR1201MB0124.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NTYIVIiJ8YXB8U09FmryaqDkrU6nZpNnKgM94trIuhcUm1OhTC4Y/yUKjW8cqnb8fspgsWNldMBDxp3ED/wVqG3j/0vHOEPpx4WzliaXL6PQZqqIznImJjmBAxDljtw+RsjhI//S+BxwwfUs2uUPNdnTxtu+oWFbRLpwPuCC4yIoGaO309KsDo6BFg7tMzjnb9f/ts438UV6T16dpvXpZjC6F+cNddAHoflEnxUo+qO1H0JPWxsO7WC6N0+xKBT1twyVgTmvH8nk8SgVDQOyNdKrNGAXCroJyG49AWTnUhSv+eyhJwfkLY8SB8SsF0RC3Kz0t10pvSaTwkr1+mMr6E5WRPJnbLEY6c1PeXVmFpNkoKHhQMJkasQ9D89nDH0+4tjcW4Jl3mXl2VyxYaTYrh7AHMK2fOj2yY6o/r/fX0QFXg2Nes5iIzdFfcT66gn+Neo885qm0+yrcHzsQfQHCyn0XGxrb6ygvWPdm1wVnaf5OnvjKdFUu02kFBYkB7x6H+MklLNnR97qz3UXksnrjb2WNx+LESSJxyCFvnLTj6apjd2QYqv0ZPIiVD6FgCV0V50hiGs2gZHuIYoIgJs7KBhqq1Tb+X+7EVvLUtzbAH3sO9aNTu+N6dcunEQLai4F+7B3261fPxHBLT6pNDZoXw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(376002)(36840700001)(46966006)(426003)(2616005)(336012)(7696005)(6916009)(478600001)(54906003)(36756003)(8676002)(356005)(82740400003)(4326008)(8936002)(2906002)(5660300002)(26005)(7636003)(70586007)(70206006)(36860700001)(86362001)(16526019)(82310400003)(186003)(83380400001)(47076005)(36906005)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 10:32:41.2865
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 982bd923-6d25-4632-1302-08d8f36725e1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 30 Mar 2021 at 01:53, Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> Currently, action creation using ACT API in replace mode is buggy.
> When invoking for non-existent action index 42,
>
> 	tc action replace action bpf obj foo.o sec <xyz> index 42
>
> kernel creates the action, fills up the netlink response, and then just
> deletes the action after notifying userspace.
>
> 	tc action show action bpf
>
> doesn't list the action.

Okay, I understand the issue now. I'll also add a tdc test for it.

>
> This happens due to the following sequence when ovr = 1 (replace mode)
> is enabled:
>
> tcf_idr_check_alloc is used to atomically check and either obtain
> reference for existing action at index, or reserve the index slot using
> a dummy entry (ERR_PTR(-EBUSY)).
>
> This is necessary as pointers to these actions will be held after
> dropping the idrinfo lock, so bumping the reference count is necessary
> as we need to insert the actions, and notify userspace by dumping their
> attributes. Finally, we drop the reference we took using the
> tcf_action_put_many call in tcf_action_add. However, for the case where
> a new action is created due to free index, its refcount remains one.
> This when paired with the put_many call leads to the kernel setting up
> the action, notifying userspace of its creation, and then tearing it
> down. For existing actions, the refcount is still held so they remain
> unaffected.
>
> Fortunately due to rtnl_lock serialization requirement, such an action
> with refcount == 1 will not be concurrently deleted by anything else, at
> best CLS API can move its refcount up and down by binding to it after it
> has been published from tcf_idr_insert_many. Since refcount is atleast
> one until put_many call, CLS API cannot delete it. Also __tcf_action_put
> release path already ensures deterministic outcome (either new action
> will be created or existing action will be reused in case CLS API tries
> to bind to action concurrently) due to idr lock serialization.
>
> We fix this by making refcount of newly created actions as 2 in ACT API
> replace mode. A relaxed store will suffice as visibility is ensured only
> after the tcf_idr_insert_many call.
>
> Note that in case of creation or overwriting using CLS API only (i.e.
> bind = 1), overwriting existing action object is not allowed, and any
> such request is silently ignored (without error).
>
> The refcount bump that occurs in tcf_idr_check_alloc call there for
> existing action will pair with tcf_exts_destroy call made from the
> owner module for the same action. In case of action creation, there
> is no existing action, so no tcf_exts_destroy callback happens.
>
> This means no code changes for CLS API.
>
> Fixes: cae422f379f3 ("net: sched: use reference counting action init")
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
> Changelog:
>
> v1 -> v2
> Remove erroneous tcf_action_put_many call in tcf_exts_validate (Vlad)
> Isolate refcount bump to ACT API in replace mode
> ---
>  net/sched/act_api.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index b919826939e0..43cceb924976 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1042,6 +1042,9 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  	if (err != ACT_P_CREATED)
>  		module_put(a_o->owner);
>
> +	if (!bind && ovr && err == ACT_P_CREATED)
> +		refcount_set(&a->tcfa_refcnt, 2);
> +
>  	return a;
>
>  err_out:

Reviewed-and-tested-by: Vlad Buslov <vladbu@nvidia.com>

