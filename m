Return-Path: <netdev+bounces-7941-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAA997222BB
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:57:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 360071C20B2A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F4E2156D0;
	Mon,  5 Jun 2023 09:56:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE02134BE
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:56:10 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2101.outbound.protection.outlook.com [40.107.92.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39677D3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 02:56:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qo0Tu6dqma0Gh99nQWKfhq29TiVMwAhG0gdVVCKh6SZNLmYietXPNzHgL92A8kFpqSkyRTHiltvnKzKbPBN2I2454FzgepjIcdCr9XYh9meKTbQlqWMjiD+0Rgg/LfJmBNZiVjtJA9IZVbvFPaGaG+VTdRhjEDJl0SO69EzEAQRB2qeFNXAUd7e1MtB7b/FBGwJCDRLEuKH/rB3DcK0OVXO2R2nMPwEN19stIV6TBuno8cRC9N/kHbJPYM85Xilag5s0potXP4efhrKzupcJe0jMs5dNrINLjW9biSOzV8Q5JS4wuQrn4xs3UDZPvWjsOKKYl9QYDa5K1uXlXN6YvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xA2VL5TXwxKB7C45k1dsRoM7vK9shtWjGOYmcZ/Txmk=;
 b=jCg9HHcgnxCNQOm48HZTvYfDIduup5NF+DChwQivofM3ehS3lF3FBiTjvEMoa+my5TxegDz3zbmsNq1ObU7rMcFHtQGL50ipdhqI7/DS7GnDg3cdKHytzddKYwxkSXZl/XC75eIQyWmgU45gx6kH0inT8EUUrArTB6JgCEN3RQKbfQvhbcSQf7MQ5GCiW6dhCeDf9YkYjZK9jWrb3wH1q2OoIPsP3SSeaIr2xS6ocFWXmqDWMNgAmvgnMbv9Fw/Q8KwIzx2BRL2MdpsbtsfE62hPfZepi/Lee2O+ySis9SC8C0FH1LdeqUMnXmAJS8lWrX4welquJcoC+xeYQ8LQXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xA2VL5TXwxKB7C45k1dsRoM7vK9shtWjGOYmcZ/Txmk=;
 b=HvNjRfsipw6+msTO1O3w5umWNRphoax/mOPJ3h5zzJdtW9wu32zWJGH55QVMtP+Qwvp/4NtgtcHgvJ4y8Ic9cOrH5GELGn++occnqrHGweUl+tSWz3Le919moiMZGwfJvDGgRzaDEuSoh1keXK5YD9njwbq6KIL64nYGyRPBx3w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4016.namprd13.prod.outlook.com (2603:10b6:806:93::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 09:56:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 09:56:02 +0000
Date: Mon, 5 Jun 2023 11:55:54 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, deb.chatterjee@intel.com,
	anjali.singhai@intel.com, namrata.limaye@intel.com, tom@sipanda.io,
	p4tc-discussions@netdevconf.info, mleitner@redhat.com,
	Mahesh.Shirshyad@amd.com, Vipin.Jain@amd.com,
	tomasz.osinski@intel.com, jiri@resnulli.us,
	xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, vladbu@nvidia.com,
	khalidm@nvidia.com, toke@redhat.com
Subject: Re: [PATCH RFC v2 net-next 05/28] net/sched: act_api: introduce
 tc_lookup_action_byid()
Message-ID: <ZH2xKs65IZe1LMTC@corigine.com>
References: <20230517110232.29349-1-jhs@mojatatu.com>
 <20230517110232.29349-5-jhs@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517110232.29349-5-jhs@mojatatu.com>
X-ClientProxiedBy: AM0PR07CA0033.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::46) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB4016:EE_
X-MS-Office365-Filtering-Correlation-Id: d43d3887-6941-41a5-bac2-08db65ab122d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ttA6bI86O5CgHfZDjuSEb2dh5nRMCsSIQXMrx1u4p58HrKlwThzlGWSfKoiH/uRhZ4xk0SOMZ6/5VuYruoq7L+VDf9NjqWZDcvpUGVE8zosyavQsA9OjJmNGLx8Hk+rOz4dQYQVeeRIdJiQp5QqqxNZgtymTGoUR6UNiYxIftW2LZQBy+I422EFE8VXb2SriVhiIgB4bFGA6vEKavwlGp1EBtjNGpvF5uUmRjN7bVRT3z/dIR9Hf1/fWrDgIZy04mo3PY1Z3HJx01qOwayia6+BU4aebLCNgYXKlcwk+7hdhDorpbuKWd6LZNnT38p+xJ75x1gdRj5IgcU2XfMmIdu0tyk0CVwZhd7A5o+NZbb95vTrFG2vx4ySq1KFyz205sxAWSa2fbL2rPCjYJCxIEc219eunddakaXi3sqid/tt8ASmXkEU5/mi+r4+JzO5nh9K4F+KbrnMbnMvbjxyhaZD5msC7hkwtxLf6v+grovLMJ8/89/H1y0ZNN37bCtJ0MHqGUrKkLznDjMIr+9tsg6m++ROCtvH89MRGq1pJQmnDR5CwUZknnu388el15rCT
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(396003)(39840400004)(136003)(346002)(451199021)(6506007)(6512007)(38100700002)(2616005)(41300700001)(6486002)(6666004)(186003)(83380400001)(478600001)(4326008)(66476007)(66556008)(6916009)(316002)(66946007)(7416002)(8936002)(8676002)(5660300002)(44832011)(2906002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YlTkFwgZ35MduXdw153FoOvxZqXmkrI6JRU0qgVr7kITxXtDB65j3oSULRH4?=
 =?us-ascii?Q?AUykbdaL/dgr8IJhMfd+VrjXISjydjfUz9vANthzXPaqYbPcxK8d8A7dENQd?=
 =?us-ascii?Q?r3Y9sfo1+FnAd3OOU6CdQbfJjVkDchrkVDQrazcQfuDC6/3yqAwJSExb1yCJ?=
 =?us-ascii?Q?FGKQN8sf383qxbbHV1SMP2sqlVTTX4Ui0wr2MCx6hdMHL+zdFgzCeCrLKHYB?=
 =?us-ascii?Q?yNX34Un27PHB4tAR530YyFPb2oCWnoJMfXRZ5Jj13rah9pTBELfMo1UrrFDv?=
 =?us-ascii?Q?akHdc3sZ6kuGQ68X1oa/qE3zgI4HaObZEvCdQO0M82K9NnIjxrx/xaKb6EXo?=
 =?us-ascii?Q?yaVAwU49Ikn50Zh+FeKrv4Uk7laCFdn08VMYJAPYEBgAo9q41VgRvo4gmHhF?=
 =?us-ascii?Q?J5Sp77IHsglY2B3cYctfJ0hNC9OQSr8kKKSrydIIbIbhSPYciusgLqNAzsy8?=
 =?us-ascii?Q?GfArfxfHTO2fkvVMBOAfCCZqlRg2Ha/FkE7CRb0DzCcoufqzgS2LXfN5XIh2?=
 =?us-ascii?Q?c27gXGLMxXMngeI9qjfgxyjDoxQUjhx0WNdDxGJn8vmw+40vhdgYr7nI1dro?=
 =?us-ascii?Q?oyowP0Vhn7jM4MZtI56heaOlGGCnozBUeKZ2ao7L7w1dPdadJrzsno3EAWL6?=
 =?us-ascii?Q?IK12laQjwbqIZ/tyopdqlKM40eYUEcauFklfwmwOmJvygzS84c9Lh3Zwvm0I?=
 =?us-ascii?Q?o3+mXHkSjAlPAJK+8yF48Xdx5YNkplPqqpSTLhVnFg6+4lTHPMnGBY/T5F7e?=
 =?us-ascii?Q?clbrlBhR/PFS/d6+XK9z60dNHycFTQNPrRj7iktoNTQYzT5vsyABS2W0Kpv4?=
 =?us-ascii?Q?ZGbtwue1EjZYine0pblAeck1trnqYrFL9t5uoBHeFNOSOxBi0HAxPuL1kOmh?=
 =?us-ascii?Q?TdfvN+JWrQNQHYn/fj4ngJwpJ4w4g6yRvP9vfsTwD3KDz7W2HZM7DMQ80KFF?=
 =?us-ascii?Q?ZMNdo0b8i/goBV6NXhOY9QrJwE4okv6yguwYFKI1eloU1RyH6/YbkX7sV17b?=
 =?us-ascii?Q?rJEcPEs3gBZUs1Cw/lgx6Msfq+eJOfiEtjn7wd6GHPpIO3qqR4qKMEwDT0S+?=
 =?us-ascii?Q?WPfRfqm1sIBqPPtA0Wuv0C6EORFFHEXrKWlTo6+ZI6uPa0gpfeXys5USF1UP?=
 =?us-ascii?Q?21BHDfJrGwnyu4Z6Ps+vbye1xXtxqyk8OLNLaThp5U9FxoKl+W20EDIGsd+u?=
 =?us-ascii?Q?iHOnyqIM4PaTSLhuIN2tRsZT7e7q0CB+qlRtP6FZED20XgXkt7Mj04OGVVFL?=
 =?us-ascii?Q?lr49ntjxfqlBuwgmiuNvVY7cEi99TShquoLVHLoIBPQYzCrqSaNpO3fJEn/2?=
 =?us-ascii?Q?FIKu321GW0kASD28dQ0BIELGHCkX9j1ndzSLwq6xZgentzWCbEXUSrYTImXr?=
 =?us-ascii?Q?w67hqaConvuimCc+kkQXLduqRxEbd3iqD4UfmUU6eWdnSeuStstRWhcfAI1r?=
 =?us-ascii?Q?Yuprf9NGVT8aiPpviFpD7e4Qrzzs5QrjHNS8PBB6KIGue5Nqjnbibzb5WxH5?=
 =?us-ascii?Q?j1rnbxxZBVT6poGGKtgLrtxINnvPhTkk2SJIrcLPcHi/OY2zzgAbLzOxnW5m?=
 =?us-ascii?Q?xdHrBgebtkwZ3nDtTbXYJms4IgsWw/ISSPSpSWx/BQStx0qUmlwPTss3WUIM?=
 =?us-ascii?Q?gaaGKSkwz49MCtnZkfj7Sk8u6ST1h9lsf4fPS78Hva1luETYQLz9hUU7K88C?=
 =?us-ascii?Q?EcKMTg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d43d3887-6941-41a5-bac2-08db65ab122d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 09:56:02.2878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dnDe2f9/YbdOxhZ+ZRyoQrWwydB4hcNDU5AJkQld0RvskQ7oT64RgE5T3kK24eGviIt1uKvZ8XKTGEytCQ8ubg7/M8nSyX5R/5yiK3IT/JA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4016
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 07:02:09AM -0400, Jamal Hadi Salim wrote:
> Introduce a lookup helper to retrieve the tc_action_ops
> instance given its action id.
> 
> Co-developed-by: Victor Nogueira <victor@mojatatu.com>
> Signed-off-by: Victor Nogueira <victor@mojatatu.com>
> Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
> ---
>  include/net/act_api.h |  1 +
>  net/sched/act_api.c   | 35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index 363f7f8b5586..34b9a9ff05ee 100644
> --- a/include/net/act_api.h
> +++ b/include/net/act_api.h
> @@ -205,6 +205,7 @@ int tcf_idr_release(struct tc_action *a, bool bind);
>  
>  int tcf_register_action(struct tc_action_ops *a, struct pernet_operations *ops);
>  int tcf_register_dyn_action(struct net *net, struct tc_action_ops *act);
> +struct tc_action_ops *tc_lookup_action_byid(struct net *net, u32 act_id);
>  int tcf_unregister_action(struct tc_action_ops *a,
>  			  struct pernet_operations *ops);
>  int tcf_unregister_dyn_action(struct net *net, struct tc_action_ops *act);
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 0ba5a4b5db6f..101c6debf356 100644

> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1084,6 +1084,41 @@ int tcf_unregister_dyn_action(struct net *net, struct tc_action_ops *act)
>  }
>  EXPORT_SYMBOL(tcf_unregister_dyn_action);
>  
> +/* lookup by ID */
> +struct tc_action_ops *tc_lookup_action_byid(struct net *net, u32 act_id)
> +{
> +	struct tcf_dyn_act_net *base_net;
> +	struct tc_action_ops *a, *res = NULL;

Hi Jamal, Victor and Pedro,

A minor nit from my side: as this is networking code, please use reverse
xmas tree - longest line to shortest - for local variable declarations.

> +
> +	if (!act_id)
> +		return NULL;
> +
> +	read_lock(&act_mod_lock);
> +
> +	list_for_each_entry(a, &act_base, head) {
> +		if (a->id == act_id) {
> +			if (try_module_get(a->owner)) {
> +				read_unlock(&act_mod_lock);
> +				return a;
> +			}
> +			break;
> +		}
> +	}
> +	read_unlock(&act_mod_lock);
> +
> +	read_lock(&base_net->act_mod_lock);

base_net does not appear to be initialised here.

> +
> +	base_net = net_generic(net, dyn_act_net_id);
> +	a = idr_find(&base_net->act_base, act_id);
> +	if (a && try_module_get(a->owner))
> +		res = a;
> +
> +	read_unlock(&base_net->act_mod_lock);
> +
> +	return res;
> +}
> +EXPORT_SYMBOL(tc_lookup_action_byid);
> +
>  /* lookup by name */
>  static struct tc_action_ops *tc_lookup_action_n(struct net *net, char *kind)
>  {
> -- 
> 2.25.1
> 

