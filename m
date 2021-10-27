Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583DE43CC91
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238956AbhJ0Oow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:44:52 -0400
Received: from mail-mw2nam12on2124.outbound.protection.outlook.com ([40.107.244.124]:52449
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229676AbhJ0Oou (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 10:44:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRNPY7ZAJ/ncjuCtmHfSQNLbgvJVbZbnDwLvhQkL7sQvqzfg8I5AxGIEna/myf3QVVrpeYLbWqRcQzk/Cuogl6ca77hLM4wfDph37SRjTnMz819VE//qftr26n1XhwFI0uQNcebmJgyPyfLvtOJwZP4BvdxTLaZg6ysLUcswIWS6IR2RYYV5bwtG5GZVgYDxMCyv7Hzb7C4TEQ0/ILH+UsAEeagC6urmdvUyMG1Tk7Fj6TCbCcKou0JzDg/92k1UvxbNdrPF2V2xdNX30p8kXfhJCmXZ+yY0H26r9zpeEIpQnB6lib4/WF+m1CBGiNK6Q2MosHr8AlgpS9HEUOcvYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l6RnqQpa4wJ/Gxr0ffpXqjbPWpHmoPy0KYt8Ia2AZqU=;
 b=YXiApnPPcyHg9CkHU1US0tJOdwXxAixoKvIo4lCsxs9b4qSizFgqqB/KkLm2xxPCwZzNxmYFMCybt8G9f7K1qxGRS7Nrzf2g3DNvXnZBMGsQ+rIKydfct5R2KaWXOfCQEClSUQMPBeIk+aGgJECwD5yFP5dOocxSEQvEVXHhCVehX9dOZc3XZEH5daiu5w6x3VQpkaRZ+ILP9eU4cbo/9pZAOGQfxNOrS0Y/FBbFy0MdTAABGGj6cxeR8rin0tRIwzi+z1RbaYiyJPq8pfiIICB0TgiUIOoH256/GoEp2sx/Q7+vBq1o9cf6j5TX51CehkxpMDTeekvAJmD2iJTOcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6RnqQpa4wJ/Gxr0ffpXqjbPWpHmoPy0KYt8Ia2AZqU=;
 b=OJ6JOAne1IUDbKxUxK2b04VcMRiqNBBvoJwzjJix+ymePUFUeNRCvT1IxR+kHa4LJLzbiWDvFd5XjOughv4gyHm6cuAxSqGp5QektWQtzgroT2bApG2vYJtiz45PjjvZM5+qllITEUWF7hXMeq8IX4kin70RM84ML/Mx1gCN66M=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5640.namprd13.prod.outlook.com (2603:10b6:510:12b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Wed, 27 Oct
 2021 14:42:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%8]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 14:42:23 +0000
Date:   Wed, 27 Oct 2021 16:42:17 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [RFC/PATCH net-next v2 2/5] flow_offload: allow user to offload
 tc action to net device
Message-ID: <20211027144216.GA26852@corigine.com>
References: <20211001113237.14449-1-simon.horman@corigine.com>
 <20211001113237.14449-3-simon.horman@corigine.com>
 <ygnhmtnsbtsr.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ygnhmtnsbtsr.fsf@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM8P190CA0004.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from corigine.com (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM8P190CA0004.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Wed, 27 Oct 2021 14:42:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d1de1e8-7981-4178-eb9f-08d99957fcca
X-MS-TrafficTypeDiagnostic: PH0PR13MB5640:
X-Microsoft-Antispam-PRVS: <PH0PR13MB564060ED76D2DB0C5A2290CEE8859@PH0PR13MB5640.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H5otJ1UeQ7lXFdJMMdHafT3Ni1VZPtrxcAz+LxJ5DTVaAeBYI1heQ66E8NJKKcEWOZAYO0J/fSmbjfzzl0TZVA1eRik3dqnxN5dLOR3YnQm0DPMMW27uX4L+VPsWBgdOxoOyfnX8PX/iqYm3SVISUUHaUIypkHwNIA/uNjLtwPsnB8Uww96MauMqsQuajA8UoA2e2L68awE8YA7u7xMKtQNWcpZutvoufYPnJFUI4ndeHyaEECuNegUcYfjTAvyrAoNHy3anpnYs0UcTVnuOBSdfksMiyj9piXjSjzOYdJtUiLGIvFJzBwLrhi2tRGdygS7fa3tloVW3ZE6pF/KsZf4txCIOWuC85mtxWfK9TkowAAyKG+VRBdWSM6D8KEd9aSE4Fo5JXR1pUSqNVTyZ409TUhoMJWLzDzcYkYgAM1vv5xrRK1GCGSfblVQe/JYutgrC+3uSgmshSuEpov/ppbs/7U5PIoEf5CjUzuqv81nxGJK8RPf7wl+XR1R+TMTJ5IaBisXiOeLd3u59+57piN00F8XdJGpkMF+LVk3i80NCjy1kho7+cE+dGsgv4gPh1B97BWwDzWou9JiHxO2k5unwDoFyIIJIYCCwUFhe98Nikqe0QPnSe6Ktqdgb7l2uXQDxelpMrJ7ItHvODuvkTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(376002)(346002)(136003)(66946007)(6666004)(2616005)(38100700002)(7696005)(5660300002)(52116002)(6916009)(4326008)(186003)(8676002)(508600001)(44832011)(2906002)(36756003)(8886007)(1076003)(66476007)(55016002)(54906003)(83380400001)(107886003)(316002)(8936002)(86362001)(33656002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MqqGlfmXUd+rGPIjjKDIwQJoHP9NBuEk5pbManH7nvicvHi1xDBeFf/f42U5?=
 =?us-ascii?Q?4qIfmmaO2VP66XHKyDRcMlIJqYsHCE30KHAALkqXV7dz+eMk0z2Z7zyojwlG?=
 =?us-ascii?Q?261EuYzVu+UpD/Ele3evXwToXsjp0qK2cvf+Ha5Ss2bZBwPhnkC8J3UjuyNY?=
 =?us-ascii?Q?ko+X89ii6L4VnTAjDK32rcMUf5sAohzlcFKVJ7ylXv5QxwAnzbEl3yBbX4eZ?=
 =?us-ascii?Q?/3ew1TSvrTeqISMB509LIkef/59QwAO+9F21BCeVwUEHLTIIg0o20khNGiEj?=
 =?us-ascii?Q?JWN8clTm/i58dU5pPNUKOrjAG/waiomUyo1sJM1rRQ6JQbSKfB1eaFLNMPyT?=
 =?us-ascii?Q?VXOxbGmuH8KiwmdtuXJ0EZazq9gzXsqQiU1DOWdQkbdseGjHWUgbZqBfVKU+?=
 =?us-ascii?Q?TpbwYPbiCRff7hxApizWSFbTszo4ZXrTuZ05/lLB/AaoKk44F8kyDJ7dJ0sA?=
 =?us-ascii?Q?Ek/6Jywcn18FJLVjxUpJx7uTnlSJwVPOaIkRF1s8J6kkVXsq4+B4V/taZh1D?=
 =?us-ascii?Q?SUS1enAkOiZ+JxPaFmfIASXnqrUEopgEXDDIsf6n/571/BQcHYX1fFrZfl6u?=
 =?us-ascii?Q?k9iyBwv6pipbK/Rwua3hnQ4Set0MpPLnsRvDDchGD0nRDk3qaiTdtxyHAkz6?=
 =?us-ascii?Q?T9pPsWgy7yAdu382X9TAlb35QgnJX77N+1vO7iTDh0pziJ0FT2GREZoIYHTY?=
 =?us-ascii?Q?gns/ADKU6n8Uke5+s+Teq2w6MgoKDulK8AQZG3zOTRnU8jcnhVhj9Z7dN0ot?=
 =?us-ascii?Q?k4Zi/x8wfesapdZo50L3ykSmQlViRVmsdpz82pBuCREp3Q601DrxkQlO7XZd?=
 =?us-ascii?Q?+dgKpFL84k/og/H4vaMXdnCUgL/5YKGVdVGBAKKjOoBW1vu1V0ZfgQIouq1W?=
 =?us-ascii?Q?5gOuDGjB4y1vTuG+CPbksJAiShHHH2s44XOuLlO2yIowstd3/L/LqaJH5qQk?=
 =?us-ascii?Q?BmxN2oM0i0+FpR7wNzg5Uw9hrSPaSq68T9PZEQGHrkwz1XmdeVuvkGopuAlF?=
 =?us-ascii?Q?7Gl6uEC5HAwSHdarFWGtBE9yFB9Fhb0nPlLxbrft4tb5T0i3bxKA+o54Xjae?=
 =?us-ascii?Q?xw/pJYL3w+bAs3/OW+qfcL4yOkI/sPufIzpEkvPnl428aRA2m44oNb5xrS+M?=
 =?us-ascii?Q?2gxc9ffJr82cUO3HyRaWf3d3g4lG3nPMJrHfoGoJcurB0TUlv1988yHEg8ia?=
 =?us-ascii?Q?8veQGrFwJwzerN3kt8+95JKQjZq0uPbWgBZkdP9JA6nCnTIHTBygiWGPVgs0?=
 =?us-ascii?Q?6yYzDUVASw8Y+8VAeHYa8FqDJnkLxIhqVHy+h9TMUN3wMJqMSO7xqs17fBIV?=
 =?us-ascii?Q?LU6u+JAlj7c5fBd8Jb6x7zFUxZmh17gljekvMchQco7dgmXgDCr8wZJr5MqM?=
 =?us-ascii?Q?+JFgNxdNgOpVZz8NWJqq8zF4vF2hG+/9zm/BSKGmY39NZOOqfDLQWDPTSCLo?=
 =?us-ascii?Q?Df5CGUDK2dp0Ct61gd8Q7sWKKV7D/BvAovdexfqp4qBsN/P5cNa23RrVkJ70?=
 =?us-ascii?Q?Mzs5xzhKhZa+5KMrAUeHlGMap1s+5ZBFWCVpCGmjVZ2tP7KlerBBxICdJ0Ne?=
 =?us-ascii?Q?Lwzs0qMoch9o+epgPssJ8ZDy6chcTfWJNR4v4S/+z4+IlG8wKOoRYs6tYL/r?=
 =?us-ascii?Q?OKd1PjP+KYnA2LjfA8FyWRAuppwxVtHslod1VdBXh7At9WgM4g0Vq2ZjDd/x?=
 =?us-ascii?Q?IFzS//8NRqGO8wxex7iV0O1XMdePIipZiQIQYra7MvpSzdRypBtmAPYycVpl?=
 =?us-ascii?Q?VO9QiYc53w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d1de1e8-7981-4178-eb9f-08d99957fcca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 14:42:23.3520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GJ/9jXBvCGKUK22WIXPMTQ9+MYeYk0KxFaMfb0/xrD11n6NDliCqnq3RTPZC6SiN2SHHCKsqikjiDfzHIEaeiPzYCzJQ8VK/6r99iCfYXEU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5640
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vlad,

On Fri, Oct 01, 2021 at 07:20:52PM +0300, Vlad Buslov wrote:
> 
> On Fri 01 Oct 2021 at 14:32, Simon Horman <simon.horman@corigine.com> wrote:
> > From: Baowen Zheng <baowen.zheng@corigine.com>
> >
> > Use flow_indr_dev_register/flow_indr_dev_setup_offload to
> > offload tc action.

...

Thanks for your review and sorry for the delay in responding.
I believe that at this point we have addressed most of the points
your raised and plan to post a v3 shortly.

At this point I'd like to relay some responses from Baowen who
has been working on addressing your review.

> > diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> > index 3961461d9c8b..bf76baca579d 100644
> > --- a/include/net/flow_offload.h
> > +++ b/include/net/flow_offload.h
> > @@ -148,6 +148,10 @@ enum flow_action_id {
> >  	FLOW_ACTION_MPLS_MANGLE,
> >  	FLOW_ACTION_GATE,
> >  	FLOW_ACTION_PPPOE_PUSH,
> > +	FLOW_ACTION_PEDIT, /* generic action type of pedit action for action
> > +			    * offload, it will be different type when adding
> > +			    * tc actions
> > +			    */
> 
> This doesn't seem to be used anywhere in the series (it is set by
> flow_action_init() but never read). It is also confusing to add another
> id for pedit when FLOW_ACTION_{ADD|MANGLE} already exists in same enum.

Yes, agreed. It is to be used in driver, but since we do not use it by now
we will drop it from this patch.

...

> > +/* SKIP_HW and SKIP_SW are mutually exclusive flags. */
> > +static inline bool tc_act_flags_valid(u32 flags)
> > +{
> > +	flags &= TCA_ACT_FLAGS_SKIP_HW | TCA_ACT_FLAGS_SKIP_SW;
> > +	if (!(flags ^ (TCA_ACT_FLAGS_SKIP_HW | TCA_ACT_FLAGS_SKIP_SW)))
> > +		return false;
> 
> Can be simplified to just:
> 
> return flags ^ (TCA_ACT_FLAGS_SKIP_HW | TCA_ACT_FLAGS_SKIP_SW);

Thanks, we will include that in v3.

...

> > +#define TCA_ACT_FLAGS_SKIP_HW	(1 << 1) /* don't offload action to HW */
> > +#define TCA_ACT_FLAGS_SKIP_SW	(1 << 2) /* don't use action in SW */
> > +#define TCA_ACT_FLAGS_IN_HW	(1 << 3) /* action is offloaded to HW */
> > +#define TCA_ACT_FLAGS_NOT_IN_HW	(1 << 4) /* action isn't offloaded to HW */
> > +#define TCA_ACT_FLAGS_VERBOSE	(1 << 5) /* verbose logging */
> 
> Doesn't seem to be used anywhere.

Thanks, we will drop this from v3.

...

> > @@ -145,6 +158,7 @@ static int __tcf_action_put(struct tc_action *p, bool bind)
> >  	if (refcount_dec_and_mutex_lock(&p->tcfa_refcnt, &idrinfo->lock)) {
> >  		if (bind)
> >  			atomic_dec(&p->tcfa_bindcnt);
> > +		tcf_action_offload_del(p);
> >  		idr_remove(&idrinfo->action_idr, p->tcfa_index);
> >  		mutex_unlock(&idrinfo->lock);
> 
> I'm curious whether it is required to call tcf_action_offload_del()
> inside idrinfo->lock critical section here.

Thanks for bringing this to our attention.
We'll move action offload delete out of the critical section in v3.

...

> > @@ -1059,6 +1088,219 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
> >  	return ERR_PTR(err);
> >  }
> >  
> > +static int flow_action_init(struct flow_offload_action *fl_action,
> > +			    struct tc_action *act,
> > +			    enum flow_act_command cmd,
> > +			    struct netlink_ext_ack *extack)
> > +{
> > +	int err;
> > +
> > +	if (!fl_action)
> > +		return -EINVAL;
> > +
> > +	fl_action->extack = extack;
> > +	fl_action->command = cmd;
> > +	fl_action->index = act->tcfa_index;
> > +
> > +	if (is_tcf_gact_ok(act)) {
> > +		fl_action->id = FLOW_ACTION_ACCEPT;
> > +	} else if (is_tcf_gact_shot(act)) {
> > +		fl_action->id = FLOW_ACTION_DROP;

...

> Why is this function needed? It sets flow_offload_action->id, but
> similar value is also set in flow_offload_action->entries[]->id.

We set the flow_offload_action->entries only in the action add/replace
case. So for action delete/stats we need the id in the flow_offload_action.
This is similar to how classifier offload is handled.

> > +
> > +static void flow_action_update_hw(struct tc_action *act,
> > +				  u32 hw_count,
> > +				  enum flow_act_hw_oper cmd)
> 
> Enum flow_act_hw_oper is defined together with similar-ish enum
> flow_act_command and only instance of flow_act_hw_oper is called "cmd"
> which is confusing. More thoughts in next comment.
> 
> > +{
> > +	if (!act)
> > +		return;
> > +
> > +	switch (cmd) {
> > +	case FLOW_ACT_HW_ADD:
> > +		act->in_hw_count = hw_count;
> > +		break;
> > +	case FLOW_ACT_HW_UPDATE:
> > +		act->in_hw_count += hw_count;
> > +		break;
> > +	case FLOW_ACT_HW_DEL:
> > +		act->in_hw_count = act->in_hw_count > hw_count ?
> > +				   act->in_hw_count - hw_count : 0;
> > +		break;
> > +	default:
> > +		return;
> > +	}
> > +
> > +	if (act->in_hw_count) {
> > +		act->tcfa_flags &= ~TCA_ACT_FLAGS_NOT_IN_HW;
> > +		act->tcfa_flags |= TCA_ACT_FLAGS_IN_HW;
> > +	} else {
> > +		act->tcfa_flags &= ~TCA_ACT_FLAGS_IN_HW;
> > +		act->tcfa_flags |= TCA_ACT_FLAGS_NOT_IN_HW;
> > +	}
> 
> I guess this could be just split to three one-liners for add/update/del,
> if not for common code to update flags. Such simplification would also
> probably remove the need for flow_act_hw_oper enum. I know I suggested
> mimicking similar classifier infrastructure, but after thinking about it
> some more maybe it would be better to parse in_hw_count to determine
> whether action is in hardware (and either only set {not_}in_hw flags
> before dumping to user space or get rid of them altogether)? After all,
> it seems that having both in classifier API is just due to historic
> reasons - in_hw flags were added first and couldn't be removed in order
> not to break userland after in_hw_count was implemented. WDYT?

Thanks, this is a good point.

In v3 we will drop in_hw and not_in_hw, and allow user-space to
derive them, if needed, from in_hw_count.

...

> This ~400 lines patch is hard to properly review. I would suggest
> splitting it.

Thanks, we've split this into three patches in v3.
Hopefully the result is a bit easier on the eyes.
