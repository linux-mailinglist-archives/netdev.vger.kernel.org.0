Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04DD5683237
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 17:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjAaQHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 11:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbjAaQHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 11:07:22 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2105.outbound.protection.outlook.com [40.107.93.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDF3C142
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 08:07:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5dIeT0jX2vRsPsKeF4veBB5zjNRgYbQijmZq9JiOUos0UFM2SMzAbQVpS6HdwDzpz3v0PiU/vlikzWaqrFJ22KOMUeSfiMJ3ZMJI82l2iLCSGnIhHDGTIpEGzYl3nDogMm20NAxwDPF5ggBp19l3HLQYOit7w6d6jCuj5hXYjpyr80Lb3UxoB+Gzcp+RSBzSlgztLT/OcfRreIVMs5z7udht7g+HgARvha+pLKSRFZKTPfj4yd1exrlanIa8VYdE6SF7UinxAC5bkkJfwdJmr/sWyHWAYTKymHUtZS80YLufHbAC9RMYB2+M56qxv1ZdfcRHZSe7CpothygrRnIDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dT9UNFKXhJLs/I4wr7d9sijgY6xPM32ckDtUDN3vqBc=;
 b=HPEne9sMrFp/IQcZ1WDn1nOin+g6XLbbCZ5XoD6lxyAPBb2R2AHyvTdc6n8OPUFEd5uJ5nktMWMK7lmVuiBiYPpggD1PuzyK7E5UkTS207dkFJZSaCX3VY0BYFnhPTbiFpw931JXjtlK6M5PcsdF6i1kuOo6J/rXHJ06XPB9jEjeeJHKvdbXm9Rt/2BxOaiBxa4tdLMvDSvckOwsH7CnQX3pXPAos2LugGxGTUtMlQebEMD0olV7WBaB2IANEY4ALdGDoSupXf8bqag16LFjmPNidLcPJcw8/6Vicat25pyNKc+3DnxFdG45UyOizejb031hRDfe1BCY+xSkpr/YEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dT9UNFKXhJLs/I4wr7d9sijgY6xPM32ckDtUDN3vqBc=;
 b=ZPMGBXBZHAZJ9tCmjcB7iA8TwJHwBNwUa/KXEyqfPtmORBYZe3E7qsGM3XV9Sn79LldScXPB1hVu4IpLCFhnxUJF9qQLkIi218LmBHF52L56q7QWbJClOlnEQANlGCMzQnfRhfBmLZu+4dPv5EdcOLcsie/AoyLcJFb1RWcWHUQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5448.namprd13.prod.outlook.com (2603:10b6:510:12b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 16:07:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 16:07:18 +0000
Date:   Tue, 31 Jan 2023 17:07:13 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v5 1/2] net/sched: transition act_pedit to rcu
 and percpu stats
Message-ID: <Y9k8seDdoS1LHB7L@corigine.com>
References: <20230131145149.3776656-1-pctammela@mojatatu.com>
 <20230131145149.3776656-2-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131145149.3776656-2-pctammela@mojatatu.com>
X-ClientProxiedBy: AM4P190CA0022.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5448:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c663e1b-f82c-4740-85ed-08db03a53a50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YJuyMqqY9MtO/HTEseEvLCleg5gzcQSK/W5XD59l+tdMq++a3AAx7RErbKAg5O8lq5K5d6VT+2L5XcQYCkSktxOpd+/6XQE6fRQ1p+8qbgSKKQGH+ENJ8EpF2WNvAt4e7jXW9VWjkGcrRCOwRTmoK/VguAGOm4DXUKveY9qDXKmQXcgVR6Ofa2py2SclwhUCvF/iZqzPpaBEgvIhSLnDjoGZT50df5hGRhab1lKoN2H7VKgdwLU6HrdgVrNtDVPbO/LTfNQ6o027sHReMrFjM+e76uRq+srieH5ySdgUInS5pVyTaDfvMcCfCrGg3qkWS7Zwc97VV8uzDs1ToCmBKGy6jo9SWvrMV4Cqa/MrB/XKZ6q9XD4uo7Fb8UPujHybw4StAOgbQh+Coc/0BPNQmj8mRY5VmMYwRA78/3xubt1wVO50+0Jsj4lkA4mlK21yr8eM4u93ZS5S13Kx21x/EpHHrhTnVW50mVb8U/LJZi+TEDM44X/gAEPRTZ4fSgwBfmrKyfuoB7Rv9zZ0X0jxZrN9umbHmrPJ39iscZFFsJPjKagNNgbg3qVJsJQB258N4bWHN0OMMbaL8+bAPkqx1VeIs7dGrTIekU2CIlFajnFvve8hjXiJFrbIZ0ukv3glavhsr8JTQ37vhfMPU8mgsb8EHLpokMVkaTcZI79hsn7L6truCG7fW/REC8G7gUFt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39840400004)(346002)(376002)(366004)(451199018)(8676002)(4326008)(66556008)(66476007)(66946007)(6916009)(316002)(2906002)(8936002)(41300700001)(44832011)(5660300002)(38100700002)(6506007)(6666004)(83380400001)(36756003)(186003)(6512007)(2616005)(6486002)(478600001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jlGBbCaOJOOBdM1IxT/dUqdiF6C5OMDPWc9W59ryQig5Jne9iG+imScJM8bI?=
 =?us-ascii?Q?+Dvt1Q/ajkV0glkIl9fH+cfISHWqhSZ/vHRh587JYrgVZnQ8ixLc+Y982zr6?=
 =?us-ascii?Q?KcgexAHmoHJeme1Hcd7GVQ3dSX+C6lWqnTcIUmygMtl6gUoiNQI8QQxKk7wU?=
 =?us-ascii?Q?HIQnNBWcPDcMHY8qxrBttzRbhDRPHdxVDPFmKJUoGv6P3wpf1z6YKTvNgusA?=
 =?us-ascii?Q?IcfHixsTkLi8OK1jYp56fZA/HUJ6zDqxFw7gWs83+9yy38CrEAjM7kum2WNE?=
 =?us-ascii?Q?5mcJ8RQ2JJhQbHdLb7ahYVdHFiLEhcgYflZ9nB2xzKFLvBRTJkrLzyAsXxBf?=
 =?us-ascii?Q?elgTQsIfKz6Prle4ZZSvtWqLBI+uy1ruhpK3Tp9xFL07Ey/qmNIpyk5FoYPT?=
 =?us-ascii?Q?jl1+3NUR0PljfLuSqjKov6SijCwhboX+Yx14mJ79eWTFXH0DQ5RIsp8EGcyj?=
 =?us-ascii?Q?N98/dA3Am6FwYGHNL6TKnrHhqkpPLp1qvpWCVHJLUlOCeQaiGeWwXKaCgPxp?=
 =?us-ascii?Q?27iqU8iK6MLoaUTlWDAwFLRE9urGZPtJTGdIj8zvkVU36pJlNFBM27jPFfXq?=
 =?us-ascii?Q?U5C3TI4KE/gjsMMDS0irEJIGJoIzoK7vE46SblKK0P3IWqNQog3RmIB5t0nS?=
 =?us-ascii?Q?YqTr013erde1Vc0U3Elhi7ySC/eNqz6UHewkhYtSZxAGBByNJjfTonV90sUv?=
 =?us-ascii?Q?b8DeSPzcaVGeQzhnnCPNoqNVqPZ44rBWPLPCPLaVzAUmvlL1WfAHsZUtitwU?=
 =?us-ascii?Q?7RcCmqJTOQ/+hi7PiqhpexuKSPx6ob4aC5kd6dZjhYOrw1gd32ZCG2Byzg3q?=
 =?us-ascii?Q?GiwBce+aF/v/f/tLObJSQst4PwGfAOEq/aXVYldHfGpC0i1tzKdktFSPYjvT?=
 =?us-ascii?Q?s6kF+nYcuM+Akhg85Iiickl6K+g8p68TDQ2gxc0cRlcG7SxhHjGNUUcrNeWr?=
 =?us-ascii?Q?RmzJEmWbwgVqeIdM6ZQLgWHUx9jpGyQOFZgAjdVk3/X4Fksz3txZmbsEy50o?=
 =?us-ascii?Q?vJDKfYjp0YFLMlOEYSeszlZErvKKNGHtdjGoYaVlVWJEnqkF1SRzsRNY2i/B?=
 =?us-ascii?Q?3Ru6Z2T57v9huJPSl7DbBNIYCy5Rm3OxzHL3O20OHOVLQ+zOrgDIF+KDe4Sq?=
 =?us-ascii?Q?aUHicC04mSTHwK+uoxEgXt/NtbhrEsVwr8W5g7OhpBDBRxMr8/39nOdQkNi4?=
 =?us-ascii?Q?86wC0mSS4ebMHhU7s5mHqSE9FcgP/LzY9b/CHvMdMPn/iYCkj3cPdQPDAyYO?=
 =?us-ascii?Q?PRJVdKmBwym5NyX48fMq2DbYdzvjN/nowhkG3iA1RbiArWVdLPbF6mNGEs5f?=
 =?us-ascii?Q?bHxNbggJOgsji7598UdAevQTPVYfRrq4S48ZT677Kd3e0CX4IHyKdMadn/sM?=
 =?us-ascii?Q?IvACBf6bO8Q1z2ujAmUfN1ZCO/1H4Ty/OQTlLpYj2QkC+X6Hke/6na4fEHk0?=
 =?us-ascii?Q?Ir51jHQK5kKpzA0zNTCmIq7ODwX0N3LPb2okLBlAbKr6USBo+JFxcpsiB+S2?=
 =?us-ascii?Q?oTxgjPY6b/LnvqipAJ2AgZtdnN97/glVVGDeruixgWtVT5NyTevP6Zd21Wkm?=
 =?us-ascii?Q?a7sBgDh1vV7pzVBzTW3jYySnun8hAFxksD2hAL6Q1CYSiZ6f3Aesi+KjZNF5?=
 =?us-ascii?Q?ReVzn5BZGKLbhMGhxCOWF9AnURX/uj5F85cQ+6MAaL3vW6qGET28BXWpjAaF?=
 =?us-ascii?Q?YVsbQw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c663e1b-f82c-4740-85ed-08db03a53a50
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 16:07:18.8555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U9Qt3+9N1+VkLGez+OuLwVmHdNKYpyVUUZdp97fvIGjt5HsTUayTvQT5XofmqU9OoZayNE5qt+CCFT/AOpSiE5YLzzWDdD5WOFZbEbn32fc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5448
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 11:51:48AM -0300, Pedro Tammela wrote:
> The software pedit action didn't get the same love as some of the
> other actions and it's still using spinlocks and shared stats in the
> datapath.
> Transition the action to rcu and percpu stats as this improves the
> action's performance dramatically on multiple cpu deployments.
> 
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

...

> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> index a0378e9f0121..674b534be46e 100644
> --- a/net/sched/act_pedit.c
> +++ b/net/sched/act_pedit.c

...

> @@ -143,8 +154,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>  	bool bind = flags & TCA_ACT_FLAGS_BIND;
>  	struct nlattr *tb[TCA_PEDIT_MAX + 1];
>  	struct tcf_chain *goto_ch = NULL;
> -	struct tc_pedit_key *keys = NULL;
> -	struct tcf_pedit_key_ex *keys_ex;
> +	struct tcf_pedit_parms *oparms, *nparms;

nit: reverse xmas tree

>  	struct tc_pedit *parm;
>  	struct nlattr *pattr;
>  	struct tcf_pedit *p;

...

> @@ -212,48 +228,51 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>  		ret = err;
>  		goto out_release;
>  	}
> -	p = to_pedit(*a);
> -	spin_lock_bh(&p->tcf_lock);
>  
> -	if (ret == ACT_P_CREATED ||
> -	    (p->tcfp_nkeys && p->tcfp_nkeys != parm->nkeys)) {
> -		keys = kmalloc(ksize, GFP_ATOMIC);
> -		if (!keys) {
> -			spin_unlock_bh(&p->tcf_lock);
> -			ret = -ENOMEM;
> -			goto put_chain;
> -		}
> -		kfree(p->tcfp_keys);
> -		p->tcfp_keys = keys;
> -		p->tcfp_nkeys = parm->nkeys;
> +	nparms->tcfp_off_max_hint = 0;
> +	nparms->tcfp_flags = parm->flags;
> +	nparms->tcfp_nkeys = parm->nkeys;
> +
> +	nparms->tcfp_keys = kmalloc(ksize, GFP_KERNEL);

Can ksize be zero?

...
