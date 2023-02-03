Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F286689BDC
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbjBCOeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbjBCOd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:33:59 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2136.outbound.protection.outlook.com [40.107.94.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257E239B83
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 06:33:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bHLPLWbaGKmQ8p6sxPeLOerOVcvxuv5ZnUxIWHMnIxiY9xqU+j+ZxBEqnwps47d/Axj9AEnyFxF7dWSssYLnCyB/FeLH7ydwb+Cq/NO1MEmEmzl828+AH+Td54wbag6LopIqOJTapxrvzpKGO1c6emq8ZCRm7tDaQDFJM5Yd3SrIV9Y4kelMhaYXsFefwaIMQMcMnqPITfuA0KUIuoysWAH7VzIsjsMRtc+3Y5yNtrMK1o0zn4T+SfSeBKRzfuWnqtPFtr1Qvf2UiiF7ULEIvqA5dCcgy6l7hX/uUNkFO6JuUg84ACVv5lR1IAaaq9QVkhVlvBmlvikKdV1uyKfKhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9DVnrOqkAy/t+/7rzOCiN/UifEWO72gJPUsgibM3tfg=;
 b=BqMY+z1xB4rsa5ixvjDm/KRnNC40haQGT9VSQqGCa0xXynYpxX2s11sueaxnHvyuCKM0DLdZzKxfISU4xqrjkNoLX/AZe1Zl+b6L0rM0zaBrFZ9cwnUPkQENbzUUdi6D66G8xyB1cplsoxbsPz6MZQGmNg9A+MWbcg3ea6r7lZ2ha3stnK9v32fmagqLFDd9KkbXYpj8yrsZ5QiRY+dQUZGiVYp43GB1SGH1cJCh5AMGIUXjUOdkf3TmB1D77yaJon7KFu6sV5ayM1cTu7lUEA+tuYmAvQIu/3fFhNgoSE2C6iYR9t9T9YM6orT7wENKDMY7/GjVZss3NURCVqDhhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9DVnrOqkAy/t+/7rzOCiN/UifEWO72gJPUsgibM3tfg=;
 b=ie4OHTsvQkB7tjE+F7jfnlnjvrALGVV58TRcWF3Qw+0+hOBNIxWiCvFYzwzVag0s06oc6BaNu2Xd3B9PvY6WnQ2CuL0IVHaZy4ienYSpYQlmaSDLOaZLnHsQ2QfFxX7qjWwmfR/nHsgTNpUwYzKPIzg4S6MEAVlEmZh5zl0Q3+A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6114.namprd13.prod.outlook.com (2603:10b6:510:2bb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 14:33:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 14:33:53 +0000
Date:   Fri, 3 Feb 2023 15:33:40 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH  net-next 5/9] net/sched: support per action hw stats
Message-ID: <Y90bRHerUsBhFIcl@corigine.com>
References: <20230201161039.20714-1-ozsh@nvidia.com>
 <20230201161039.20714-6-ozsh@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201161039.20714-6-ozsh@nvidia.com>
X-ClientProxiedBy: AM3PR04CA0148.eurprd04.prod.outlook.com (2603:10a6:207::32)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6114:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f79eff2-cf5c-4693-b147-08db05f3ac5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JcN4n5OJ1uEqJglwvhGJp3/bvDC4w2iDaMtvhOjNmaoN77r2jN6nAP3AMEcMxScqLtY+41lyunN7MZi/JMk7I1sfoWEA0N2ul6yk4CY5NicfgdO2XNglOIWgtTC3j9Jh6L1gRmOVSMbRBg4wEPJMBJSyxQjvoopWb88YnLsRes6bDKGFsYODpJ7W5jWeNSQ8zMeXI+72Y+56upqljhcT9A0k1VukLpeusAIVDLTLuLhxNQmDAC6LnVnVgG6BseeZ0LufUFXQinCLhFY3LkLCtSTIMwMvl93+QXg5Fgb2WCRYe1Ze80lpi+l+cNCMnfIn6vJdC/7jz5nyCMW1h8h0/i2gBWzonGrjFd4kq9oKT4ffoHjSKT0ato9ofQTthHvVv5N9OWvJ7qvei42JgvOUfsNYhdIko323sLVMk23HvDPefCx4DdVsGuUKe2NKTVdRHpwcjNFgEXt0TkXMLvuRjqB8Ot14dDh3CwPV1eUBqF9JN+xiG/tSHolEiCCj9W0eu2E4WTjNW+3wwbM5wST5c1jR6tLrbwcUpt1HlXYJSojoPFXkravQEdd1+lVhESko8VQOsjbrcjuKa9jZftdi7Gq65EpltqYX+kNIeDWeV3nYzS8/gEipur00nViaKkoHD2aYvZilAoHdvu4RtyfFUXGmtXKCzh0SrMz4BQskS2H1zYdbbdjocfO04CWRvyaUD6PEWoh+irpwuFds4dx921FmjwoEoKgc3w9KjgAHeXMaYYKnzPuukU5dDcJRSl8v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39840400004)(396003)(376002)(346002)(451199018)(66946007)(8676002)(6506007)(6486002)(478600001)(6512007)(36756003)(54906003)(6666004)(316002)(186003)(5660300002)(86362001)(2906002)(44832011)(6916009)(41300700001)(66476007)(8936002)(66556008)(4326008)(2616005)(83380400001)(38100700002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?suyJzCIGF+0L9/v//5PZvvJ0/2HH0MDefbICXS1XHv7bt2eyggiaKZQfWyEu?=
 =?us-ascii?Q?Sj+6W/ANhwWrFod8uf+sTmgTSuHzNvqcKuvTeK/RjOM1fY8Rbx/Mof9wl1Kv?=
 =?us-ascii?Q?WWIWZKpeMNmU/IOTdqNLSlbjhBZaBRzdr98dCMgTchsGUD7Kfs7YQKRv9szb?=
 =?us-ascii?Q?1Fo6pApAbmM0WeOS3TrfYGdweEvbZMxLyL7d1a8oTRs1zM3TsosHdFGvFHMt?=
 =?us-ascii?Q?MCr6zXp909Wu7a2ohxn0Fh/DTx8izBI4hZj4aU/9JREhQWxMKohA4o5BCcuQ?=
 =?us-ascii?Q?yiTzweX0mXJPn0m45TBXo2SK5HbieoQNCGvFEXctiFk8hrke1sJQx+fhpVKI?=
 =?us-ascii?Q?0nk+9yeB2XV5b6GsSX2L/cz+5w/sXsR1bZmfJOn8Ze4aVZz7waIUhIcIvPMb?=
 =?us-ascii?Q?RvmweYJYSyfm1hlmDJ/DJFMdttv61eRPwx4grnEu3MkEZHAzu7h/yY54sEqa?=
 =?us-ascii?Q?86hTU4PL8Iy4ePvpechfsmH8LPCaQky7NNQr2ryTAGniA8JeGaGdmrH+FDbJ?=
 =?us-ascii?Q?EKIvhJhgnGSJzsbrk+49WxguYnMcg3kn6ebx/RPuq3noZLFEA059xQ3E87Gn?=
 =?us-ascii?Q?numa/PKCPNosEgDXIc500eRaVZlx3JTFwnHwNfrnmtOxg8fCqGHFNCUcbfZ3?=
 =?us-ascii?Q?J1NzVmb/OIx2aXLNXQj48yiNsZvU5ArHomza5cuZrU2FYACLMh56z1GhaI88?=
 =?us-ascii?Q?VkhCSNDr+Rkg4VuPaVGYvv04jRKfWTN6W2dMWSQAEy7LGLOSpmIykmO44fqr?=
 =?us-ascii?Q?BFMixXuen87YHOXKvT+/fZLWMiaACkbxiuZYMN089LIPoQhFb10WcEAmXR6p?=
 =?us-ascii?Q?/FR+hg45bTOqCSGQKCiQrmf3PSpSJ7Jhzr2Y5aEMyLZic8UDzEKjyYi3jhQE?=
 =?us-ascii?Q?gGH/0G0LTwM0A5Q8kgHgGe5KYOhl63legpxry46Ktiz+Dc8xSzLbZsB6tY49?=
 =?us-ascii?Q?rmDR/0yI/dV+vwqX89uOM+h6jk/Yb4hoBPfDCJRnYNCK/7O4m9dVnECERZSu?=
 =?us-ascii?Q?Gowmn4HGhPuNfVvKP1+njeJxi2Wrb4Cep0RH0YhGpIyzhVwHf1+trk8Uf+Ju?=
 =?us-ascii?Q?6ZP3k1d4i0ANnLzx+6zi4ZOaW/0UJ8/VJ+H/dcduRTB0kCG2DwY26VdRU4VS?=
 =?us-ascii?Q?YsWf+JSBmdamdYtpSDusfch6L4FV7NFZ3Ss6tJ2VgTfnUl8L3CNXNHXzsrVf?=
 =?us-ascii?Q?kyq6YSX6sUCGEG5OkDO9waSvLDy15TYB9gcU40yOZb2WlYyuUIMAmNYfnHGI?=
 =?us-ascii?Q?QDFLkkux0MJ523wkc9lhVhirFfhfg7D2L5A8ep9ehzpZXo1bVuLxqNao1pwp?=
 =?us-ascii?Q?MCaZLp5rT8btmlg0iEVG1b/amLi1InKUz81WNOiCu7R73khnRiw02g6z1g8C?=
 =?us-ascii?Q?lrjineVtDrl5HfCkDFVPCrsHPcBi59/4/KUkYxQZ9K0qeWx+9Mm5crudU0A0?=
 =?us-ascii?Q?4gfE9/bRfDBQ2vFAPm+kJvh/ITssh7tafwVR4Rp3VsHMGnk1N1WAdV4S3tgx?=
 =?us-ascii?Q?Skw/Gbw7UTWFg0YqIoDjX9dv2X29vmZ5i8Uyo0suI24j4RR5Sx24YHevRsma?=
 =?us-ascii?Q?34z+uThR6RCUhO0Hlf4UZnIr7dZCDteBWSELCvtOTVPQJ3bVRR5y7M7mSU0J?=
 =?us-ascii?Q?NB5c3N0lqhd/B7bwmKee5cV3LxRaxGgPF0BLD1azPXUD4gn7bF59VdT75buV?=
 =?us-ascii?Q?bbMzVg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f79eff2-cf5c-4693-b147-08db05f3ac5e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 14:33:53.2322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xuh56xhwROtalFirfN/gQRhI2x62ZTW7j2nz5Dm5iTBjmX2N5y/56m5TqL7blhztq1f4x2RGngJb8z7NQLQfWsv9K1UQRk9ztYYX4EIsX2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6114
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 06:10:34PM +0200, Oz Shlomo wrote:
> There are currently two mechanisms for populating hardware stats:
> 1. Using flow_offload api to query the flow's statistics.
>    The api assumes that the same stats values apply to all
>    the flow's actions.
>    This assumption breaks when action drops or jumps over following
>    actions.
> 2. Using hw_action api to query specific action stats via a driver
>    callback method. This api assures the correct action stats for
>    the offloaded action, however, it does not apply to the rest of the
>    actions in the flow's actions array.
> 
> Extend the flow_offload stats callback to indicate that a per action
> stats update is required.
> Use the existing flow_offload_action api to query the action's hw stats.
> In addition, currently the tc action stats utility only updates hw actions.
> Reuse the existing action stats cb infrastructure to query any action
> stats.
> 
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>

...

> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index be21764a3b34..d4315757d1a2 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -292,9 +292,15 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
>  #define tcf_act_for_each_action(i, a, actions) \
>  	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
>  
> +static bool tc_act_in_hw(struct tc_action *act)
> +{
> +	return !!act->in_hw_count;
> +}
> +
>  static inline void
>  tcf_exts_hw_stats_update(const struct tcf_exts *exts,
> -			 struct flow_stats *stats)
> +			 struct flow_stats *stats,
> +			 bool use_act_stats)
>  {
>  #ifdef CONFIG_NET_CLS_ACT
>  	int i;
> @@ -302,16 +308,18 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
>  	for (i = 0; i < exts->nr_actions; i++) {
>  		struct tc_action *a = exts->actions[i];
>  
> -		/* if stats from hw, just skip */
> -		if (tcf_action_update_hw_stats(a)) {
> -			preempt_disable();
> -			tcf_action_stats_update(a, stats->bytes, stats->pkts, stats->drops,
> -						stats->lastused, true);
> -			preempt_enable();
> -
> -			a->used_hw_stats = stats->used_hw_stats;
> -			a->used_hw_stats_valid = stats->used_hw_stats_valid;
> +		if (use_act_stats || tc_act_in_hw(a)) {
> +			tcf_action_update_hw_stats(a);

Hi Oz,

I am a unclear why it is ok to continue here even if
tcf_action_update_hw_stats() fails.  There seem to be cases other than
!tc_act_in_hw() at play here, which prior to this patch, would execute the
code below that is now outside this if clause.

> +			continue;
>  		}
> +
> +		preempt_disable();
> +		tcf_action_stats_update(a, stats->bytes, stats->pkts, stats->drops,
> +					stats->lastused, true);
> +		preempt_enable();
> +
> +		a->used_hw_stats = stats->used_hw_stats;
> +		a->used_hw_stats_valid = stats->used_hw_stats_valid;
>  	}
>  #endif
>  }
> @@ -769,6 +777,7 @@ struct tc_cls_matchall_offload {
>  	enum tc_matchall_command command;
>  	struct flow_rule *rule;
>  	struct flow_stats stats;
> +	bool use_act_stats;
>  	unsigned long cookie;
>  };
>  
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 917827199102..eda58b78da13 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -169,11 +169,6 @@ static bool tc_act_skip_sw(u32 flags)
>  	return (flags & TCA_ACT_FLAGS_SKIP_SW) ? true : false;
>  }
>  
> -static bool tc_act_in_hw(struct tc_action *act)
> -{
> -	return !!act->in_hw_count;
> -}
> -
>  /* SKIP_HW and SKIP_SW are mutually exclusive flags. */
>  static bool tc_act_flags_valid(u32 flags)
>  {
> @@ -308,9 +303,6 @@ int tcf_action_update_hw_stats(struct tc_action *action)
>  	struct flow_offload_action fl_act = {};
>  	int err;
>  
> -	if (!tc_act_in_hw(action))
> -		return -EOPNOTSUPP;
> -
>  	err = offload_action_init(&fl_act, action, FLOW_ACT_STATS, NULL);
>  	if (err)
>  		return err;

...
