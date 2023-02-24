Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442046A1877
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 10:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjBXJF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 04:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjBXJF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 04:05:28 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2070f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::70f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AC9F76F
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 01:05:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0gW6FT1ztGJ3DOFIIuuyUBmZy/0Z8X6v0mZrgPd/doK6Mgf23269PPM0kzkBRZv/vdWDpxjy9nSyIT2vathLLiyTZL2VWL82aaN6iRRdrgiWF2lsaSrvd030mEuPk68FzV0cwOTFeV8fk5GCbXMPC9SkRT++RDMDjMzppBlH5AzUhRMWU90tboA9G9ty7puVF6u356Yq5Fs8jDyPwIK7OEnc/lt6GgHXBszBSAgNyT3iB3yeCaRul3QMCKva2HDQCPDOV0PHjZFt96mOVPQyzwIdOjf/6kaWPcx0dijauli+vCirU5gOx4SZsbizO0nh+06Xaqso58CMvTRF5s2Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vd8BLItk5i1ZZpS1f8kQSjk3kk6YwFExeohacCCyjaU=;
 b=OY+rvSAg0kECXuu+TbgeYu3sFCoH6xYNaEA8wXmWO2VG2jNhFCJtBi4NZyWp14ndwVwfRWkIBbvSlHJGj6/PzQH/7WpPpDPVUFI7roiD6eYdktPRE2ai93ZZFsWqcVYWX6RqUycDg2N5gxE407VUhrabbIY2BKnOKi97NqBQirIv+H/yzYJozqM0aQzdf4L7WsEsXHaAIgfz+EWOLjPEr35pPYQ8nJ360SUmLrYI9BaHkrfCoSoIoD39Ptg4QKoD4Glf+49CjnxNNTK3iiABeFvZHbdPawVtoKoR0ih3cgp07WI6/z7OTI7tgUsk0dm7/smcWOcyISpCjmYC3r3M4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vd8BLItk5i1ZZpS1f8kQSjk3kk6YwFExeohacCCyjaU=;
 b=taNyw2/0uiyqOoZaK9IZBbnVR1jJPXG8s4x5ovtCcBq4c54xVhsZSg6AgMj/pE7ZZv5JSqHqgHWv8GKB5gil/rcH8ecadFcDTplwskJqRiQtQGjFKK6nCTCeeN6ppOnz6CW4Rt8AVyrWmH8z+/TKrAAZgn/sCuqbkv/0ZnZWwZY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3746.namprd13.prod.outlook.com (2603:10b6:a03:227::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Fri, 24 Feb
 2023 09:05:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 09:05:18 +0000
Date:   Fri, 24 Feb 2023 10:05:11 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, error27@gmail.com
Subject: Re: [PATCH net] net/sched: act_connmark: handle errno on
 tcf_idr_check_alloc
Message-ID: <Y/h9x8c/XdJeT7e0@corigine.com>
References: <20230223141639.13491-1-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141639.13491-1-pctammela@mojatatu.com>
Organisation: Horms Solutions BV
X-ClientProxiedBy: AM0PR10CA0041.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3746:EE_
X-MS-Office365-Filtering-Correlation-Id: 54be9c75-8bfd-49fb-c268-08db16463ff2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LZTzpA7BUOhjvn0ain4FTxpRDtwqc74W7PUogCDjRYv/wAncPO8ihquQ3Z2eZf1X5yG9iLlbUIiW/ThLOP8JZ81fzSyhe0wkOnk7A0DsedwY2VU/Q4ZnNtxe6o70vJZIvVBWozNjuRB8Byb2HHRgAsg5dttsE+jyeBlHSl4E7ImQV1rzoTcbufMFJJVM0j22x5r9YNzPAxeZbxdl4B0O2aSz0bAEf2GtR/Hzn1jt53R+YUSTW71sev7l3hB7aMPmV0sMJsNcYZJJLC/8bBGGYl01yNVxo86FB0oLmX7BnHYikJO7xj7XdI5khm1+fdzVtLIAHLJNbPZRJD8NNNyl68EeHRdhjSysHhK6pHeYIxPTqJk4Ms0N5RBmw5VzasGj2+8/u6oK9zB6eaLQa4xQJTbiHSbuPiyU72hBzGJ2yfGkW98TfOGij+xh4e1FCD5vWpTp8FkXbxGW2o5CrZVuNHIqxBaloih3D9m9Uk7LrmuSOKugarYpYf8DhS/TilNeX2mOY3rvyBSqli0iFqPt2AC0iQI5fIMTF2H03KPDTRLOPJFwT86S76odWA95DFmMzPvXjW399fE7vNF+smvKQKKajOnK9S1UL4pW7EFj88zsTLv+Z1bHJ0fYXObZcwmJZzvhqNABCGi15HEUo4+Raw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(39830400003)(136003)(396003)(451199018)(186003)(41300700001)(316002)(8936002)(6512007)(4326008)(86362001)(6916009)(38100700002)(8676002)(66946007)(6486002)(6506007)(66476007)(478600001)(6666004)(36756003)(83380400001)(2906002)(44832011)(2616005)(7416002)(66556008)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f9XPG9wOcS6wT1IowQWF/uE0zqp4vd+PPfOBkd66EPFwmZ9DJ4xq5RN7okXW?=
 =?us-ascii?Q?k1qLhsZf+qXDEYhV54HQySiodYrVO6qVRbS80i9PwnqtjZWDgL/T7t/2BOIB?=
 =?us-ascii?Q?7pQa5wcYVgJ+Twee65wrll2XvTQudaKs3P+xl5bpo887NmzyaxVpoRKKDOlA?=
 =?us-ascii?Q?B7AZkkH7tW0tmg8JGLgvNQ0Y1WwFWG1ZAHQYAlGlbHwq9FRMEscZePXGyw79?=
 =?us-ascii?Q?S7ZFucsf1RrhSloVHaRWpNVGSGsIZvK5lsOozP2+MjYF3yjHDB+cYp563vHo?=
 =?us-ascii?Q?iVXibTPXRAAS9zcgWqe6m70u+CpQi6Gxgxk4MZnmu3F00IihqtvHVqw4kc+M?=
 =?us-ascii?Q?0NaJyiO+KrJMW1Cglb/xGnSZyr7Pn98gedrX/ltKoYzbHXRmiNgZxeBJPnK5?=
 =?us-ascii?Q?YA54KF2sIYJhs/S7Dea7Kpacp0UbMMRRz19o0IWN0a+C9S5yWHaPT9IXZBMS?=
 =?us-ascii?Q?1+jzj2nO3V+gBczYp/bnn8DkDi1ii81s8YXuohgDEroEuNECWPGVfVUoZpUF?=
 =?us-ascii?Q?pE1KAgLhxcGKoPEjUrZCvoA+n4RdGMycXnVtLPuzHlb0vjtPEUQGepc74Pia?=
 =?us-ascii?Q?evCtRgqYK+xJI3wQPImIJHpUx0HW9YU3eOQN4/lA3ZLAtQ8WNCqv1LfobVdA?=
 =?us-ascii?Q?vOrW38ydNVXE9TqHToL11kxFhUFHSWBbKKninZWp4w2F/kWw3Q+b2JPppWNc?=
 =?us-ascii?Q?rtnWAOF1FICw2q7TxMApvxVclGQtEyAMJWT+GEaIYZP1QXnYhhhEGuBJsUi7?=
 =?us-ascii?Q?XxiC1ePFKmZh5qidrHvoDXomhSHYZjaqn/vKQ17CfS87WFzpQ6CXp6TYqWXk?=
 =?us-ascii?Q?pSDcJJ6zi8jmW1kLXIYpDWcbq14bNrOjBRC3mQRkEgWmRd8Zr214S2//g6yp?=
 =?us-ascii?Q?MrMaFwqIvUktFKKDALU/P6Uu2K5UCkGbZ8kF4gGu0c2WGvMuEfFkD1B4uiE7?=
 =?us-ascii?Q?0buvOEzIQ72aePs9P5gxXmzD5sRw83yRycEgRc0tf+FlRREz7EEgn6kPWY5x?=
 =?us-ascii?Q?7MF0tWACs2+Kz1Q/kIAG55ekptzs9YJEEm8Rf+BkRQRL9aAuokQ9/1/tHstV?=
 =?us-ascii?Q?LWphgbdAn5/x0k7M7V99li+AFKSxBuAZNVsZruQg/CvNrnOpW6jijJEjEOJq?=
 =?us-ascii?Q?UI6NavdOZ4yozQQCQC7RkoTAyOFcJWRXRNLRxwgHIJU6ouVeURzNfgE599D3?=
 =?us-ascii?Q?2Osz5u2M5/I95UnJK6PF3ikwtSfli6Ssu0p2KjJDKEWFm40ehMv0bQZ7z/rE?=
 =?us-ascii?Q?wmq5wTORrw3hlTBYHVj61Vy0KxKgRZW1rOFAaK5gVzv7rGtaq8JAA/zkdr7m?=
 =?us-ascii?Q?18Df5VVhABAuay7bwRUJvvtzsI2+FoSESziBR0p2x4N9doOBX+GxMD0Gu316?=
 =?us-ascii?Q?cZObXhuaqW3Qo8aXxwG8th2d5Jxd8dNa+Ft2lIODxLW+1EurmzigkGDs1+wc?=
 =?us-ascii?Q?zvPKpZnyIoTFnHMEmbmS4vi7cSeG6qoBruy9DCANfAg5oBFzo0xeqDoKcGSf?=
 =?us-ascii?Q?Di3XK8E4z4LLRisThCqZSM3AC1GkVgJSI0byW+9qzYfbNQ8vzo+ttJ6WiJRZ?=
 =?us-ascii?Q?X5/QKC2BnvwcFeHZdta+sCKyCRk5cPScXTDE3rFVBc842EYjFxFmF6dJlzY9?=
 =?us-ascii?Q?puXF40aM9PiAMCQqL0/t+pm7sC9InvY7E17TGAU3vvlQHW8zPgyc4uymheW5?=
 =?us-ascii?Q?8V0rHQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54be9c75-8bfd-49fb-c268-08db16463ff2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 09:05:18.2108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B62bcwGfO7B1sts3DAOxcRZ8RJj8+L+fpbaMFGFuNHJIJs7zVYrGzwckqBNhA0qj2UhV1NV7IkPTzddSbKf0hwpE6GCXsBiuy19VSvYVMhk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3746
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 11:16:39AM -0300, Pedro Tammela wrote:
> Smatch reports that 'ci' can be used uninitialized.
> The current code ignores errno coming from tcf_idr_check_alloc, which
> will lead to the incorrect usage of 'ci'. Handle the errno as it should.
> 
> Fixes: 288864effe33 ("net/sched: act_connmark: transition to percpu stats and rcu")
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---
>  net/sched/act_connmark.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
> index 8dabfb52ea3d..cf4086a9e3c0 100644
> --- a/net/sched/act_connmark.c
> +++ b/net/sched/act_connmark.c
> @@ -125,6 +125,7 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
>  	if (!nparms)
>  		return -ENOMEM;
>  
> +	ci = to_connmark(*a);
>  	parm = nla_data(tb[TCA_CONNMARK_PARMS]);
>  	index = parm->index;
>  	ret = tcf_idr_check_alloc(tn, &index, a, bind);
> @@ -137,14 +138,11 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
>  			goto out_free;
>  		}
>  
> -		ci = to_connmark(*a);
> -
>  		nparms->net = net;
>  		nparms->zone = parm->zone;
>  
>  		ret = ACT_P_CREATED;
>  	} else if (ret > 0) {
> -		ci = to_connmark(*a);
>  		if (bind) {
>  			err = 0;
>  			goto out_free;

Hi Pedro,

I think the issue here isn't so much that there may be incorrect usage of
ci - although that can happen - but rather that an error condition - the
failure of tcf_idr_check_alloc is ignored.

Viewed through this lens I think it becomes clear that the hunk
below fixes the problem. While the hunks above are cleanups.
A nice cleanup. But still a cleanup.

I think that as a fix for 'net' a minimal approach is best and thus
the patch below.

I'd also like to comment that the usual style for kernel code is to handle
error cases in conditions - typically immediately after the condition
arises. While non-error cases follow, outside of condtions.

F.e.

	err = do_something(with_something);
	if (err) {
		/* handle error */
		...
	}

	/* proceed with non-error case here */
	...

In the code at hand this is complicate by there being two non-error cases,
and it thus being logical to treat them conditionally.

Even so, i do wonder if there is value in treating the error case first,
right next to the code that might cause the error, in order to make it
clearer that the error is being handled (as normal).

And in saying so, I do realise it contradicts my statement
about minimal changes to some extent.

i.e. (*completely untested*)

	ret = tcf_idr_check_alloc(tn, &index, a, bind);
	if (ret < 0) {
		err = ret;
		goto out_free;
	} else if (!ret) {
		...
	} else {
		...
	}

> @@ -158,6 +156,9 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
>  		nparms->zone = parm->zone;
>  
>  		ret = 0;
> +	} else {
> +		err = ret;
> +		goto out_free;
>  	}
>  
>  	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
> -- 
> 2.34.1
> 
