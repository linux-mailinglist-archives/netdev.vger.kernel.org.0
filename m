Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672613501E8
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 16:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbhCaOJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 10:09:10 -0400
Received: from mail-mw2nam08on2058.outbound.protection.outlook.com ([40.107.101.58]:36961
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235957AbhCaOIm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 10:08:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7Oook9JJrz9Wlx8AzRUTVebZPEm4xyCcLWwgtpY9YaHtDhhhQcZgL4wxI1LFdkL5ZsOrt4fXflgVDrwJO6U9ONjLkwWqX81RrZW4kN4KMMMfUaT2CewGCfvw3ITE5SOr+ZLOP+BzHGPLytJwiyF/rrYW81vzZ5ykBfR8IZXvYZINbMuJWn1llR5QC5B8EzU/WDEY8igOgPX88DqR+H/XVxcW29rA6x+KRvkBzmTnU38ftPCoaaHZFeALD/9BJM2Pvp4YQk+P2PwUBzlKD4dUqlurK+hXf/Hw9r8ZsogkpiBWFRF7dr1QXfspgi+UMqvrmU+Xxu9i25LkqNIcZ4MHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5fQ5ObuqvA8nfqqLPa8NdaWK9MaCyXXA2R/oTYN/qY=;
 b=AMXJp0sRvx5Ln6kNWa7OBISc6zMQwDm9Tpw8dzMSzzBwKZYo6XVGDJGuj/MeNlNku+dMc0szku9gUawv7l+po86m9ik4MmyRpUn7Bvdca8vGccS2BpY3DY5sfjEZYjfwYPAG0q0295ZM5sHlCXt/8xHHffEqiWEP6GzbhMvxFN2TWpxyBMMtFkG5liKnjVsYSkpi1hvDP+NhE45ESgOE0qhawBOeZ97Lu+Ao3lk32jgsoiqED9A1Mf5n7SVk8hzd+/LReF4v3JvkcAhQWut5jBv9xIsiDYfPETQGlCZ6U5U1EuujqeZoSmVJb3V21mobHlrEMqyz+ti7ik7U7lSmew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5fQ5ObuqvA8nfqqLPa8NdaWK9MaCyXXA2R/oTYN/qY=;
 b=dU3StDokPqUQ7mKPJI12bPF5HMmS2SQqDpdCVR9yguUwtbINwUNuU4jVKtZOOHRGfngYDnUcC4skNE/NRJr7x/ZcLN/M8l8l8LqlS7c/lmbcKEXyaX+uOJki+5FpWowqSm0loj71btonKTSEckxM/r/rHFQ52Gpk6JlIXbDKAXXCFiwL1m3Ug3PRLdJDH/Tq8wnPhXboAvs5dGN4BX+ukA+NiMLBHBzlvLHh6Z7YopB3Ff6dP4A1nDQamKvRP3jY3Dvb6m4tt2mCWmLCr5qPHW0MhChcVB7Qhfvz0tbncRCKeI9f+BUU11wQW2/sXEtkWx+TeOlqPbGKXPzLrOoccg==
Received: from DM5PR13CA0044.namprd13.prod.outlook.com (2603:10b6:3:7b::30) by
 MWHPR12MB1310.namprd12.prod.outlook.com (2603:10b6:300:a::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.30; Wed, 31 Mar 2021 14:08:40 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:7b:cafe::43) by DM5PR13CA0044.outlook.office365.com
 (2603:10b6:3:7b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.16 via Frontend
 Transport; Wed, 31 Mar 2021 14:08:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 31 Mar 2021 14:08:40 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 31 Mar 2021 14:08:37 +0000
References: <CAM_iQpVAo+Zxus-FC59xzwcmbS7UOi6F8kNMzsrEVrBY2YRtNA@mail.gmail.com>
 <20210331083723.171150-1-memxor@gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     <xiyou.wangcong@gmail.com>, <davem@davemloft.net>,
        <jhs@mojatatu.com>, <jiri@resnulli.us>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <toke@redhat.com>
Subject: Re: [PATCH net-next v3] net: sched: bump refcount for new action in
 ACT replace mode
In-Reply-To: <20210331083723.171150-1-memxor@gmail.com>
Date:   Wed, 31 Mar 2021 17:08:34 +0300
Message-ID: <ygnh5z17h0v1.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8038a667-02fd-4b23-2361-08d8f44e7c45
X-MS-TrafficTypeDiagnostic: MWHPR12MB1310:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1310B342E06863B0CE47005BA07C9@MWHPR12MB1310.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jd9wXWMFMLK+LmByCflzxjVbcdEqkvb5TzbWW5kbLjYruSf26KWjvj6eh1C2adcRmUmzpu+NJL+ehngxwiSWudeLymTMVXG+x2coVyNbwiyRBqbdjVbuIyyRiV6X4JHwScZJUtFVKH71zhcwD7EoIeTsxvYPMfU+mTRiGn7Lb99Qz18n7JBmrt8m/1CY2hubgeex5iL0QRjYZ/hhK1AZ6ODIOkx9xQa4aNqrqELGBHrlIMggyzQ/nw1/mjE/5vBH+fIvzgPnxYXglohCE9P7YtV88d6EAj/Ah9DZvwD8irtWaBcBfBIgIgs8jusXnl3jVaEWirTV+8QyHlw3RPLHaqlV99nY5FIayHCHN0PMZUXRM8vWTDkdamfA7ss8L5DTk7VrnaKyQCPIYNbXZ6clYiW83bsYFabaGCL3sTGplOR3qa7jja4rwXk0HNtcMIItFBnpXR5MowpET3tDdpTD/L2QvmMvS8AcG246fjOvRkabz2OmOz7HXrlwcsa1Z9GrunlUo2dk8wOSsPfBauHa18shC0HRmSu5PcWNSp/aSkQ0ifnVnmGqMP5GAtsMWqAR9A8zejMUUFmJYzxfpHIhtxfK9upddzbhahkO7E6XYD5Rf3nF8eHKIH3BMSwHRvhiGxfYyaSYCXhPPLKBL1rQpVKIgIphExa+m1eaFzkIdWA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(46966006)(36840700001)(6916009)(36756003)(8936002)(70586007)(316002)(8676002)(5660300002)(36906005)(356005)(82310400003)(86362001)(83380400001)(336012)(82740400003)(7636003)(4326008)(426003)(7696005)(186003)(16526019)(2616005)(26005)(47076005)(54906003)(36860700001)(2906002)(70206006)(6666004)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 14:08:40.1398
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8038a667-02fd-4b23-2361-08d8f44e7c45
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1310
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed 31 Mar 2021 at 11:37, Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> Currently, action creation using ACT API in replace mode is buggy.  When
> invoking for non-existent action index 42,
>
> 	tc action replace action bpf obj foo.o sec <xyz> index 42
>
> kernel creates the action, fills up the netlink response, and then just
> deletes the action while notifying userspace of success.
>
> 	tc action show action bpf
>
> doesn't list the action.
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
> We also remember the new actions that we took an additional reference on,
> and relinquish the temporal reference during rollback on failure.
>
> Note that in case of creation or overwriting using CLS API only (i.e.
> bind = 1), overwriting existing action object is not allowed, and any
> such request is silently ignored (without error).
>
> The refcount bump that occurs in tcf_idr_check_alloc call there for
> existing action will pair with tcf_exts_destroy call made from the owner
> module for the same action. In case of action creation, there is no
> existing action, so no tcf_exts_destroy callback happens.
>
> This means no code changes for CLS API.
>
> Fixes: cae422f379f3 ("net: sched: use reference counting action init")
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
> Changelog:
>
> v2 -> v3
> Cleanup new action on rollback after raising refcount (Cong)
>
> v1 -> v2
> Remove erroneous tcf_action_put_many call in tcf_exts_validate (Vlad)
> Isolate refcount bump to ACT API in replace mode
> ---
>  include/net/act_api.h |  2 +-
>  net/sched/act_api.c   | 24 ++++++++++++++++++++++--
>  net/sched/cls_api.c   |  2 +-
>  3 files changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index 2bf3092ae7ec..a01ff5fa641e 100644
> --- a/include/net/act_api.h
> +++ b/include/net/act_api.h
> @@ -194,7 +194,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  				    struct nlattr *nla, struct nlattr *est,
>  				    char *name, int ovr, int bind,
>  				    struct tc_action_ops *ops, bool rtnl_held,
> -				    struct netlink_ext_ack *extack);
> +				    struct netlink_ext_ack *extack, bool *ref);
>  int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[], int bind,
>  		    int ref, bool terse);
>  int tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int, int);
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index b919826939e0..718bc197b9a7 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -993,7 +993,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  				    struct nlattr *nla, struct nlattr *est,
>  				    char *name, int ovr, int bind,
>  				    struct tc_action_ops *a_o, bool rtnl_held,
> -				    struct netlink_ext_ack *extack)
> +				    struct netlink_ext_ack *extack, bool *ref)
>  {
>  	struct nla_bitfield32 flags = { 0, 0 };
>  	u8 hw_stats = TCA_ACT_HW_STATS_ANY;
> @@ -1042,6 +1042,13 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  	if (err != ACT_P_CREATED)
>  		module_put(a_o->owner);
>
> +	if (!bind && ovr && err == ACT_P_CREATED) {
> +		if (ref)
> +			*ref = true;
> +
> +		refcount_set(&a->tcfa_refcnt, 2);
> +	}
> +

I wonder if we are being too clever here with all the refcnt
manipulations. Maybe it is better to just expose to the caller whether
existing action has been overwritten or a new one has been created and
let the user decide if they want to keep the reference? I'll send a RFC
to gather feedback from maintainers.

>  	return a;
>
>  err_out:
> @@ -1062,10 +1069,13 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
>  	struct tc_action_ops *ops[TCA_ACT_MAX_PRIO] = {};
>  	struct nlattr *tb[TCA_ACT_MAX_PRIO + 1];
>  	struct tc_action *act;
> +	u32 new_actions = 0;
>  	size_t sz = 0;
>  	int err;
>  	int i;
>
> +	BUILD_BUG_ON(TCA_ACT_MAX_PRIO > sizeof(new_actions) * 8);
> +
>  	err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX_PRIO, nla, NULL,
>  					  extack);
>  	if (err < 0)
> @@ -1083,8 +1093,9 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
>  	}
>
>  	for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
> +		bool ovr_new = false;
>  		act = tcf_action_init_1(net, tp, tb[i], est, name, ovr, bind,
> -					ops[i - 1], rtnl_held, extack);
> +					ops[i - 1], rtnl_held, extack, &ovr_new);
>  		if (IS_ERR(act)) {
>  			err = PTR_ERR(act);
>  			goto err;
> @@ -1092,6 +1103,10 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
>  		sz += tcf_action_fill_size(act);
>  		/* Start from index 0 */
>  		actions[i - 1] = act;
> +
> +		/* remember new actions that we take a reference on */
> +		if (ovr_new)
> +			new_actions |= 1UL << (i - 1);
>  	}
>
>  	/* We have to commit them all together, because if any error happened in
> @@ -1103,6 +1118,11 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
>  	return i - 1;
>
>  err:
> +	/* reset the reference back to 1 in case of error */
> +	for (i = 0; i < TCA_ACT_MAX_PRIO && actions[i]; i++) {
> +		if (new_actions & (1UL << i))
> +			refcount_set(&actions[i]->tcfa_refcnt, 1);
> +	}
>  	tcf_action_destroy(actions, bind);
>  err_mod:
>  	for (i = 0; i < TCA_ACT_MAX_PRIO; i++) {
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index d3db70865d66..4f4a7355b1e1 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3052,7 +3052,7 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
>  			act = tcf_action_init_1(net, tp, tb[exts->police],
>  						rate_tlv, "police", ovr,
>  						TCA_ACT_BIND, a_o, rtnl_held,
> -						extack);
> +						extack, NULL);
>  			if (IS_ERR(act)) {
>  				module_put(a_o->owner);
>  				return PTR_ERR(act);

