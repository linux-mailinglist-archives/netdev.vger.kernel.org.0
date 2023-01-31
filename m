Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39E8682CAC
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 13:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjAaMhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 07:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbjAaMhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 07:37:13 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2118.outbound.protection.outlook.com [40.107.220.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A764B483
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 04:37:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XO7en81N/X41IZAUU/Xl2d8gj3BmoTUZB1teoQVhgwWhdMOLXvcd8ui4O40sBkliH8xtbQ9j/dvRQ6xbT6qk7prLrvc7zUrV/YRjwuSa3qNhfzhCsnnP3Ou2IAj9yvVBEiEuL/Z3y/Z7yZIvGV+kp0BMphfEB+w047wYmWIXvnW7Mp4aV/mrXMYW0naQYUNjnZIeabkjkUZpyed2NgLkQbdBrxvWLjj3l23pTZsGZuP/NnF/cPuawVls1EZQnHoyEHCREiROU7uvwUKEYZgDdYHvOWnRE/qr4eGf4iymZRX3ltVf6tx4inNLcGwi6nzRhUJnIOOLBQmk6ZvR7Tgh4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3dhlHDq+imnp8zZv0vHAjLEbP3zWb7S/Q4+R1vJpUw=;
 b=P5oZdtSnWc4aWSnl7oSGeCnECMzNUsJsttJYSgLoBjAwFg6zVrdJv5QP7QoSG/8nX0+zrfEOnEI1dl/Pqefz6PLemzcvEvepNCyzNrjWcrqOtDmrvG8xLZ8xfCSXSXtR7ng0sWKQ0SkC3Dx8MczzurXg2/evqCYxfJ2qf6x8+e8cwLHsw8x7v8zInQA2tbDfS7n82gyMiQH/NMvbuIDc0mMgGHYSMQ1EUyMlbLAE+J7COybywdInOG+i8IIKlJeQpb2dY9MOcxBFlQycyZfR1gbvTk8bQbNraQMofu7NxGmtn6kmLrLoV+K+3RoHS/7Bo17J094M7N/oXjHlcad5Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3dhlHDq+imnp8zZv0vHAjLEbP3zWb7S/Q4+R1vJpUw=;
 b=NWO7+bfZiTsAFHengQWUhSfKoDIsWW95/JjgwXXP+WGMMEWk4Zis+DwkxQRv9dVEsYDZasJeW0RfvBbbmnw8tCMM2XlN2a6szyZq8xuyUyp7qMcH0fuyMgvi1exSuA0v/MP/bwKMUGAqXQJwg9XsauBNy4ri21kohAAeXevcXvY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5608.namprd13.prod.outlook.com (2603:10b6:303:191::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.28; Tue, 31 Jan
 2023 12:37:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 12:37:08 +0000
Date:   Tue, 31 Jan 2023 13:37:03 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v4 1/2] net/sched: transition act_pedit to rcu
 and percpu stats
Message-ID: <Y9kLbylZSeSst01o@corigine.com>
References: <20230130160233.3702650-1-pctammela@mojatatu.com>
 <20230130160233.3702650-2-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130160233.3702650-2-pctammela@mojatatu.com>
X-ClientProxiedBy: AM4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5608:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ac48e5f-b257-4b0d-3233-08db0387de07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B1ujva7J9kY+JciE6nV36/ig9mOfZAP9noRsz83bbNV1WkCTE2z/iKNBRcsZiH7/pQbUHBXaGGzGwg+0c8PC72KH5eRKr7CtmKVS0UPE5C1jgdm3eZGz/MjxUeaQ0Aj2Y+nhl1PtOfR7fAvdSbxYVoXY9s8CTOsubG1HGaxJ3AYnmCwvyE2s9aszAJ64LtaPO1Q8SNkW1ZvKfFTe7m39U64bkmooU+jz2/4NmD1UUFr0UKAK8FixPJlNL1oFNzcyvYD8Huvn2JLdaKBDMAUsjy+A06JF1dtKWJnNuLQRmxKIk5oM4OABD4pfqIgzavFwklOgKPU2gkXAQ2zx8e/X8QWb0yZt8zj/AQJYkCSlPQQ+1fscrgTFcbOFW3aJIQXK06dNhZlondZmRCymfVE7tieCjCbqVTMwhlIfAbvePPugPueElUFv+8WWNgQkSxHesxuXitpXt6+8BaUtuafMDSc9W1LPp509wIbbT6nR+qVujkmlV96/6vmoE3u4M7xxp1W98RWdfnVmPpj0g6AO0fkEffVA9873y43pYcTRqaHsl6XkAW+d/JXkIzBnPu/Vft9SlIAVE1clthvDb+6ockKgeNwtDU54rrt0CNlHSXmJ11dCdO7zgoN7vZr6zUUU/6jpjYdvn9pSY6NdNnCocFyEAnYFpAc0uvoY0ju8VMj3Pk2gFESeRQ9qKp936AjS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39840400004)(396003)(376002)(366004)(451199018)(38100700002)(6486002)(478600001)(41300700001)(2906002)(36756003)(6666004)(86362001)(44832011)(5660300002)(316002)(8936002)(66946007)(8676002)(66476007)(4326008)(66556008)(83380400001)(186003)(6916009)(6512007)(6506007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tbfn/Jx2KStvnoS5yQiuzZMoEkYm5BdOJ3okFF9Nsimw3q2W7Gs6vjf0EZP9?=
 =?us-ascii?Q?rpTejzKo1CxUqPPFrgdclmfRLPotXIfWsPFQzxeOPaZJAsCfgzzjXlksko0t?=
 =?us-ascii?Q?EhNAL07SciVnBrtUWQQI07u15cNSljmky2u1OUfa+akD3UGQIHzmCvKkDE1A?=
 =?us-ascii?Q?NqS+GanZmvHzPHKUZ9XXMJOvHZWLB+o25Qek/BEvdQT7CWemIbRWjcvrVhB1?=
 =?us-ascii?Q?0glRDmqXurO+rq5/eHMphYdMUKrz3YJ3J8CaVzsz0ZYSsll12YqDvhDcZ+V/?=
 =?us-ascii?Q?wTzNW60KNk/EteWT94xmIyRCismdtIeqt0YQC+EFlGblZBv42CEzdjickSAk?=
 =?us-ascii?Q?gKj5HkLs7l93Jeh1vNyu+r59SDbWZqxQmS16BuCCVJnISDpPezIvoKR01kgR?=
 =?us-ascii?Q?SnnRQmcBiOmkVmDn253VFIpD1IBYh4Dffm9Ru8xJwMlx1vBMws6Qc8PVYUZt?=
 =?us-ascii?Q?b15CB/r9d3hY7qSXFqpwarVCy/BaYGOooc9Mr1w0byZJqwZLzexTcWfJIgnX?=
 =?us-ascii?Q?D0pXVPnWwdfMM2Of6btdoyNVuDcUPpySSSRxDaoDdZQaQ3UkkHDn9wAAm1F0?=
 =?us-ascii?Q?B+N3GhzAT/exStWzLat/OFKLXRnLv+0hbGJQPPPzuwjzp2A3KgnXTb6EkHSq?=
 =?us-ascii?Q?Dk0HQAPwnyNOPwAqYBDabOmHsAOaXgMfUbpKpP+wShbqnmGDS6wnoXhQ0DnM?=
 =?us-ascii?Q?w+ufi6+FoEhQbCfBYOCVxHwsi9TufK+ocKmI5i7QGuV7AKjH1VZDytkSWCZt?=
 =?us-ascii?Q?uHWnozXVbcSn/6FYR5Lohs1oVKFTWKm+B4mjspslfpxsAJxnlFhAz7/GZHoN?=
 =?us-ascii?Q?9vSF6+GRDUOhBlfNr23QZWeGne+tmpp/U2Hj5jNHS4Yr9gc13x5X351X3Zm1?=
 =?us-ascii?Q?GQcEAaEZEs6cMYBkgtIcGy0JbdkTUognmplhHYLilBpjNOG3umDb/SW5Wz/j?=
 =?us-ascii?Q?/iLvmVtAILy2K0X4EBFVlH84noNdn8j7ywgOUNAv+mTKpqGkbn8KshAnGFYj?=
 =?us-ascii?Q?sFm2rFQ+wnycNpVtlu+SSh/2GSGuAk0OQX7WyejcVfdC0yiIoQCe3S25uquG?=
 =?us-ascii?Q?31tex9+DQsftVIoFpJpDg8fB3LmTjFtgXS+pLK0q/p270rumMsIqjNbdLw9J?=
 =?us-ascii?Q?O9EN8s0gE0vRAm6xAkeHY7Nel5pd3Bed1CFZbdHgb4unXmZsXSktYB/M/zYc?=
 =?us-ascii?Q?ZWaI6iqlNfyhU13gBRXSc7fsyl7YNwzbAqqS7Iqt+X571W91JhhvhJFKTjg3?=
 =?us-ascii?Q?nOhBAreKDJQAJTJdBSrK1ZXzDaTOuh6jzyCw03XrvHhFQr3EPJwV/c3jEPcT?=
 =?us-ascii?Q?Wp6242bOfgj2S0gvYosfrtpcYuUNROFXotFJpA86XI2SEeC8Q8Myf79/aGlf?=
 =?us-ascii?Q?mH/fEM/7zl0CjvcVJWrqmgnHWVRn4H/nqUmYbZRyepAolVmZ7HTz/X8K/l50?=
 =?us-ascii?Q?GImFhXG/gJrIi6Oazm8jP5h7J8gFeF9Nfwh4nkUpkZjUE2ek0uuZGSutF+OW?=
 =?us-ascii?Q?i+1lRHV8qdR+v2OBmXGRcuHF67iJW969n93tNKZTFY4GD7w8CEiNhvaV6Y5W?=
 =?us-ascii?Q?slcJAWK6joQHKWRPz0d3lsOZUoh/Mg05qPGmK2vH5RaBhVdsEEnURiAKUEuJ?=
 =?us-ascii?Q?kIsyW4xFy6MW6y9Saqpzi+/sv8mnCsl7eLMZmOt0iGPKImD5SQNTAExyqmVH?=
 =?us-ascii?Q?37zSFQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac48e5f-b257-4b0d-3233-08db0387de07
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 12:37:08.4945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SAWqj/08t1DbY6GkTVQK3uUjX0mZvoup72kNnWZ/AWIGL5zJuhS+7f1zVhQd9Ebw4yDE2NTqcfcMtXx829hqt7tlrMyOdbNf6plUgCGjHiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5608
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 01:02:32PM -0300, Pedro Tammela wrote:
> The software pedit action didn't get the same love as some of the
> other actions and it's still using spinlocks and shared stats in the
> datapath.
> Transition the action to rcu and percpu stats as this improves the
> action's performance on multiple cpu deployments.
> 
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---
>  include/net/tc_act/tc_pedit.h |  81 +++++++++++++++----
>  net/sched/act_pedit.c         | 144 +++++++++++++++++++++-------------
>  2 files changed, 154 insertions(+), 71 deletions(-)

Hi Pedro,

thanks for the update.

A few questions from my side below.

> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> index a0378e9f0121..c8e8748dc258 100644
> --- a/net/sched/act_pedit.c
> +++ b/net/sched/act_pedit.c
> @@ -134,6 +134,17 @@ static int tcf_pedit_key_ex_dump(struct sk_buff *skb,
>  	return -EINVAL;
>  }
>  
> +static void tcf_pedit_cleanup_rcu(struct rcu_head *head)
> +{
> +	struct tcf_pedit_parms *parms =
> +		container_of(head, struct tcf_pedit_parms, rcu);
> +
> +	kfree(parms->tcfp_keys_ex);
> +	kfree(parms->tcfp_keys);
> +
> +	kfree(parms);
> +}
> +
>  static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>  			  struct nlattr *est, struct tc_action **a,
>  			  struct tcf_proto *tp, u32 flags,
> @@ -143,8 +154,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>  	bool bind = flags & TCA_ACT_FLAGS_BIND;
>  	struct nlattr *tb[TCA_PEDIT_MAX + 1];
>  	struct tcf_chain *goto_ch = NULL;
> -	struct tc_pedit_key *keys = NULL;
> -	struct tcf_pedit_key_ex *keys_ex;
> +	struct tcf_pedit_parms *oparms, *nparms;
>  	struct tc_pedit *parm;
>  	struct nlattr *pattr;
>  	struct tcf_pedit *p;
> @@ -181,18 +191,25 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>  		return -EINVAL;
>  	}
>  
> -	keys_ex = tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
> -	if (IS_ERR(keys_ex))
> -		return PTR_ERR(keys_ex);
> +	nparms = kzalloc(sizeof(*nparms), GFP_KERNEL);
> +	if (!nparms)
> +		return -ENOMEM;
> +
> +	nparms->tcfp_keys_ex =
> +		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
> +	if (IS_ERR(nparms->tcfp_keys_ex)) {
> +		ret = PTR_ERR(nparms->tcfp_keys_ex);
> +		goto out_free;
> +	}
>  
>  	index = parm->index;
>  	err = tcf_idr_check_alloc(tn, &index, a, bind);
>  	if (!err) {
> -		ret = tcf_idr_create(tn, index, est, a,
> -				     &act_pedit_ops, bind, false, flags);
> +		ret = tcf_idr_create_from_flags(tn, index, est, a,
> +						&act_pedit_ops, bind, flags);
>  		if (ret) {
>  			tcf_idr_cleanup(tn, index);
> -			goto out_free;
> +			goto out_free_ex;
>  		}
>  		ret = ACT_P_CREATED;
>  	} else if (err > 0) {
> @@ -204,7 +221,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>  		}
>  	} else {
>  		ret = err;
> -		goto out_free;
> +		goto out_free_ex;
>  	}
>  
>  	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
> @@ -212,68 +229,79 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>  		ret = err;
>  		goto out_release;
>  	}
> +
> +	nparms->tcfp_off_max_hint = 0;
> +	nparms->tcfp_flags = parm->flags;
> +
>  	p = to_pedit(*a);
>  	spin_lock_bh(&p->tcf_lock);
>  
> +	oparms = rcu_dereference_protected(p->parms, 1);
> +
>  	if (ret == ACT_P_CREATED ||
> -	    (p->tcfp_nkeys && p->tcfp_nkeys != parm->nkeys)) {
> -		keys = kmalloc(ksize, GFP_ATOMIC);
> -		if (!keys) {
> +	    (oparms->tcfp_nkeys && oparms->tcfp_nkeys != parm->nkeys)) {
> +		nparms->tcfp_keys = kmalloc(ksize, GFP_ATOMIC);
> +		if (!nparms->tcfp_keys) {
>  			spin_unlock_bh(&p->tcf_lock);
>  			ret = -ENOMEM;
> -			goto put_chain;
> +			goto out_release;

I'm a little unclear on why put_chain is no longer needed.
It seems to me that there can be a reference to goto_ch held here,
as was the case before this patch.

>  		}
> -		kfree(p->tcfp_keys);
> -		p->tcfp_keys = keys;
> -		p->tcfp_nkeys = parm->nkeys;
> +		nparms->tcfp_nkeys = parm->nkeys;
> +	} else {
> +		nparms->tcfp_keys = oparms->tcfp_keys;

I feel that I am missing something obvious:
* Here oparms->tcfp_keys is assigned to nparms->tcfp_keys.
* Later on there is a call to call_rcu(..., tcf_pedit_cleanup_rcu),
  which will free oparms->tcfp_keys some time in the future.
* But the memory bay still be accessed via tcfp_keys.

Is there a life cycle issue here?

> +		nparms->tcfp_nkeys = oparms->tcfp_nkeys;
>  	}
> -	memcpy(p->tcfp_keys, parm->keys, ksize);
> -	p->tcfp_off_max_hint = 0;
> -	for (i = 0; i < p->tcfp_nkeys; ++i) {
> -		u32 cur = p->tcfp_keys[i].off;
> +
> +	memcpy(nparms->tcfp_keys, parm->keys, ksize);
> +
> +	for (i = 0; i < nparms->tcfp_nkeys; ++i) {
> +		u32 cur = nparms->tcfp_keys[i].off;
>  
>  		/* sanitize the shift value for any later use */
> -		p->tcfp_keys[i].shift = min_t(size_t, BITS_PER_TYPE(int) - 1,
> -					      p->tcfp_keys[i].shift);
> +		nparms->tcfp_keys[i].shift = min_t(size_t,
> +						   BITS_PER_TYPE(int) - 1,
> +						   nparms->tcfp_keys[i].shift);
>  
>  		/* The AT option can read a single byte, we can bound the actual
>  		 * value with uchar max.
>  		 */
> -		cur += (0xff & p->tcfp_keys[i].offmask) >> p->tcfp_keys[i].shift;
> +		cur += (0xff & nparms->tcfp_keys[i].offmask) >> nparms->tcfp_keys[i].shift;
>  
>  		/* Each key touches 4 bytes starting from the computed offset */
> -		p->tcfp_off_max_hint = max(p->tcfp_off_max_hint, cur + 4);
> +		nparms->tcfp_off_max_hint =
> +			max(nparms->tcfp_off_max_hint, cur + 4);
>  	}
>  
> -	p->tcfp_flags = parm->flags;
>  	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
>  
> -	kfree(p->tcfp_keys_ex);
> -	p->tcfp_keys_ex = keys_ex;
> +	rcu_assign_pointer(p->parms, nparms);
>  
>  	spin_unlock_bh(&p->tcf_lock);
> +
> +	if (oparms)
> +		call_rcu(&oparms->rcu, tcf_pedit_cleanup_rcu);

	Here there is a condition on oparms being non-NULL.
	But further above oparms is dereference unconditionally.
	Is there an inconsistency here?

> +
>  	if (goto_ch)
>  		tcf_chain_put_by_act(goto_ch);
> +
>  	return ret;
>  
> -put_chain:
> -	if (goto_ch)
> -		tcf_chain_put_by_act(goto_ch);
>  out_release:
>  	tcf_idr_release(*a, bind);
> +out_free_ex:
> +	kfree(nparms->tcfp_keys_ex);
>  out_free:
> -	kfree(keys_ex);
> +	kfree(nparms);
>  	return ret;
> -
>  }

...
