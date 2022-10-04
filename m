Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657E75F3E2C
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 10:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiJDIWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 04:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiJDIWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 04:22:51 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AED1B7B0
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 01:22:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MVrf6avN2l/J2Fw8vGCyl000l9tj0R1I+nD1vigsHgKKOCvOHNo830fa6SGtpf8YOFg2cVg/3gj5zdZgblN/JOMshYkVbav+d/96ZweiYJPmyr5J1R6JjYSd6WRjSBxCun1JgEdni5XSeu4F2hkq6vQvmtRPf0z+3y731ATOhuPACvLBo9+rqlw/Vwz3LzohC/1Naxs2/zs0PpECVCBbu77qsQQv+cdkDwoMsUssL5dm9pqNLQq+RBiqo78L/56l9VCIdoM+Oog078LD87OmFUAD7BySy+9WlPl+/trkCeTn7uWUnD6x8WrTSAzSZmlfMOVWFVY6KxVu3bWw89T9wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=chSGZw/w6KRfKgHt5/kwL61PA3f1Z/u0snHM+EBL6CU=;
 b=QgGs86t+ml9oTKv6PnSf3/vkwNX5XKbs66ICC8vcMV0CVvt/uIrcvWyIzWKBQAtNgAk21419Vxe3iceBeWzbqBdckIYNNDrtgRjDQa/+BClZc7IMvLobLMD0/Vmz2b8MVp6S6i4u+C5S/ysCJfS3daWPpZ1VIgrPK0tW8czIdU5/9jJNGKAsJ5ilvvJ3MBJO7afCUKNGV/YugYiWqmLoSktlZGAsHGE0fPNO8T1HNwhyO2tlh+2/vjsN8d78tUPvPe5aGbOFaawmwKX7Sw0Mb2znkb6imSDGn8xfoVcQ99+ZmnrzO4m3S6IEJA3r0JCVS9e923wQCPi7a2NTazdfDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=chSGZw/w6KRfKgHt5/kwL61PA3f1Z/u0snHM+EBL6CU=;
 b=FqmqtKhhF4rAobXJgwKtEwc/hSdCMcSywAU+gKa+8+Fk1uGCrqiaebLUjkdMrDYLWIyqUYU6K+h0h2ill5wtw6Tn+ViSCpy8lx38RbPIj4Zbp0Ss0v4G//vIAl8rqI6AWmf1AzCLpzWGHR8UDo8oTaZO1kHdGXWdLrcwbQjPTGkTWj2sBT6siUiWEA2nvgNYpjqweBl3djwu2Hj3UDSZ8Jfo438JD46LFRZWSBhg/B/8urPyUqnMq70fdkfbioYrFeObqgy1o124cRyQIx2hIhwXXPEMOJXsOQT0YmeIcG7S/s6hMkScXSXToIxuVTQlp3cPAcIRMUz5xP+GLcxV1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY4PR12MB1301.namprd12.prod.outlook.com (2603:10b6:903:3e::17)
 by SA0PR12MB4528.namprd12.prod.outlook.com (2603:10b6:806:9e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Tue, 4 Oct
 2022 08:22:47 +0000
Received: from CY4PR12MB1301.namprd12.prod.outlook.com
 ([fe80::5d5:6a21:7068:3d11]) by CY4PR12MB1301.namprd12.prod.outlook.com
 ([fe80::5d5:6a21:7068:3d11%12]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 08:22:47 +0000
Message-ID: <0d15ac22-df7f-241a-52eb-a6dcf0a67385@nvidia.com>
Date:   Tue, 4 Oct 2022 11:22:40 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [ RFC net-next v2 2/2] net: flow_offload: add action stats api
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Edward Cree <ecree.xilinx@gmail.com>
References: <20221003061743.28171-1-ozsh@nvidia.com>
 <20221003061743.28171-3-ozsh@nvidia.com>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <20221003061743.28171-3-ozsh@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0491.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::16) To CY4PR12MB1301.namprd12.prod.outlook.com
 (2603:10b6:903:3e::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR12MB1301:EE_|SA0PR12MB4528:EE_
X-MS-Office365-Filtering-Correlation-Id: f74db9e5-cb2b-4014-85a5-08daa5e19e99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KKqQOzpNCPam0i2upcUUEFhSX0PFbQn0m8lUBOvM/vrqgQ4B+rA6IMgJnoV77Ukp4XhxXE1aIg5T48TUl7S+c1Bwp2mVCMyNDxGvcc8YB5yxNCdohlnOFMIq562tSkYmt6yt6dQbOgMiCko4hDC5u4+BzFmCRh7SshI9pxhGbQOwYGj58CLwoVAPT5uG3MiyL0fm8hmBSv6odrCyw6JzaN8oJ5ET1Gi22OwcQseMgfu66i4RrtPwBdzHHrtStzkRckwcjvpzBVzhAQ/K2PRpm89pHnmEe+Oies4U9r2pU5oh23yjMT6HMgwDu+h70OGczssmadHgrsKKrcsjh/EBeN8IsIRaWgwfmHmEHjYhbwsEDLloY9BuSVpnHVd/S1N7bUUlYZC5hJfiA6cbr6ht6Y6zgLrXiDA5BwDgbE6Cj1ph17bpe8PXrgGxoUAxkgTa62RtYDBJVkoC5aW8wZQX2+7CDUzCixdYZ1268RXfb/ha6McBq0O6HVNWpR/j5k2mWxMxMpIoj0/FLHFyATTS4WZjBpvzyAreXMl1T0o+hXf303k/mYJS0llUkQb1404ZiOCdSA6NKOHusDkpyNUSq+fAn+5pgqPKuS20wv5epZZ2/LEK2XFq0Q9lnA+Ny8zk2U3SKaMaSQs2jGQXnrlCc0BOUJYBBstqQQ3VhowWKcUTnLseJwAl4U4NSZRXjKaHHhhN0+mAc9kFEZ/mUMGlS6Ngua1V46nl8/e60ng7VCqC/9jBacDBqpEavtX6v+Cm9A1omOvXuPX2Mc+Aw4PdVDoZtoWzr9XirHgHULA6bww=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(396003)(346002)(136003)(451199015)(31686004)(2906002)(316002)(5660300002)(66476007)(66556008)(4326008)(8676002)(66946007)(6486002)(54906003)(6916009)(31696002)(36756003)(8936002)(41300700001)(6666004)(86362001)(53546011)(83380400001)(26005)(2616005)(478600001)(6506007)(38100700002)(6512007)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YU1oVnY4S3loWGdJVGI4aWVyMWd3WDI3ODFKUXplK0JmUTNCKzU0eS9EMEhT?=
 =?utf-8?B?Q3ppc0xMVktTU0NDKzB3MlhDVktvY2dYTVFXWXhlVkpHaXg2T3F2ZjY0anZC?=
 =?utf-8?B?R3BpTW13OS8ybVk1bHluWmQ3TkZCTy9ybnErUlI1cEtNS3RhSUZkdEN0b0tF?=
 =?utf-8?B?UXdaa3NFSUpWZ2FpcEpWdzlySmpYNDBZWWNkMmpDU3NzNjZWRzgvbUpPZUx6?=
 =?utf-8?B?MTNtTHMwS09MekkrOUNBVUhsTEZYTlBsVlZhMWhtSldFVHFNZUxBY3kxVlVW?=
 =?utf-8?B?dVAxd3VtcXJEUXhudStDY3NHalZrQ0tCUXBaUmxWWmxDaEJLR09jUTl3YTQr?=
 =?utf-8?B?azNuNGdGdFpTZ29OYjlZNzROWEE2RC9YeWJvbUEzK1lwajUydmoyZ2RBOUIv?=
 =?utf-8?B?d1huUUEvSjljTVBIT0pqNU85cWxWdWxFZ2hkdjU0NHdlTmZ4OFlVSlNncFdZ?=
 =?utf-8?B?Ykx2N0J6VkZwQTVjNmV1NEl6a0x6Q3A1ckQ4MkErNXN6NmNrNUc4eTJjanhJ?=
 =?utf-8?B?UzVtNXBCQk5oQWJtanljVzVwbEZpUmpabkQ0TTV1Qlp5MGpOb2JQU3FhRW1Z?=
 =?utf-8?B?czhsS1hpcXVsQzc4YkFuNVlMbndxZkR3Q3IydFJ1eDJKVFdBd3BMK0hNMTZq?=
 =?utf-8?B?Y1dUN3IzbE9OWDZ1Qm4rTEdXS0dhd2IwUWRtOVZIT0dGMHNTbGFlVkxMaGNP?=
 =?utf-8?B?TlM1ekpId1Z5NmNDM01HRW1VY1Y3bnhTRFFxZnJIbzRXVnozTU5jTDVxakZH?=
 =?utf-8?B?b1U0UXFaYW9kY1VIMjFJaEhoY3BpcDl2YU14VXlnTjd1MGQ5c2RrUUVxeXkx?=
 =?utf-8?B?NS9TNWJhck9IdzBvWllKbVdzZU55S2FzUmlDQVVyNURjT3VsKzUzRlVidjVR?=
 =?utf-8?B?dTltekhWb2Y3dFhoa0YwUnJzTnpOR3pGRTNKVGdGV0xVNlJxNHUzZTlaeVR5?=
 =?utf-8?B?UmE3Nm9WTlUxV0VUV2hCdlBSYmZMVE9IZVhpdXFJTDA3d0QzblZBSmlDZ1pv?=
 =?utf-8?B?dU5NWlN5Qm9Xc3RsTUsrRkUyOVlsMWQ2blM3b1RwbTU5ZjFsdCszM0VkT201?=
 =?utf-8?B?MjdtTllrMjdsUnlRRFB4azNBbUZRY3J6SXdxMFBsUlc4aThkbmVVNHo3cFd0?=
 =?utf-8?B?RlhiR2lJbHZFZGVwMDZNREZiL0ltY0V4M1lOemt5WTZRb0p5VkFHbkVWTkFP?=
 =?utf-8?B?Sjl5ZSsxNGpDRDRaaWFSL2FHRTBGT2NheWZaUUd3UHVJeFpJbXFCb09wL2hJ?=
 =?utf-8?B?aXZpOTB1Z1ZDa3ZGVHhZQkVPb3c2cDJHTGpsZjlXWmdJc0crV0l1NTExQmNX?=
 =?utf-8?B?WWZSaEJ2OWRMY1N5OFlBN0FLbnBOU09IOVZSRENDc05kVFRLSHdXS2hCN2JQ?=
 =?utf-8?B?VWVnQVJuQmVEVm1Dcm5XRTJMKytuMXBhc2JoWUw2L3QvU1ZrNlVEaTMvMHN3?=
 =?utf-8?B?ZmRpVjVqVlJMUVFOR3RrYnpvZWJ2WVN1L3cwNG80S2FsVkIrZTlnY1llRmNr?=
 =?utf-8?B?VFRWOUxvN3BvYmF0d2hsOHVtVzloU1gzZDdNdU1udm5TTC9CSFgyODYzVkEr?=
 =?utf-8?B?QXlSVzl3V1oxUzEreTVpQnhORktSQ0w4QW9kUGJuMFc4NVR1SWZ6NytNQ1o0?=
 =?utf-8?B?b1gyOUo4cldicG8xbFZVTC9oZ29oR001bllJM2hjbXZmZ3R3MzcybDhQNE10?=
 =?utf-8?B?YnFQZUovL3pmR3g2TEN6eENMMVlzWjlRZ1pyZzRnU3N0dWZTSGJHZXpwT0NK?=
 =?utf-8?B?bExSeTNwRVhhdVU1a251RDNkbG9HNDAzV0k5M2pPMTUzZXdBaVhhTEFTczRt?=
 =?utf-8?B?VjhadzkxRGRmMUk0OUd3Y1RjNHRtZVNmaFZNcXlNV1lxYW1aWDlETU83YytZ?=
 =?utf-8?B?ZGVxYWFJbWczSWhGMmFtSGRNVXU0cDRuMTZOOTdFZWQySUtHMnZIUTR5akF5?=
 =?utf-8?B?L1ZQdkNYYTA1ZzJjeUJ2dS9pcEljcU1lVGZiNmJuSVZlb0ttVkt5V1N1SDQz?=
 =?utf-8?B?VEdQcmk2cWtmWFR0eXU5YWlJSThHQU9sNVV3TTREbmtab3VrQTRMM2xLMnli?=
 =?utf-8?B?MjBjOXcrSWNvSmhzUWg2MjMvWEpPZlB4L0trLys4TGk1dVhkMkJVTHRCejhO?=
 =?utf-8?Q?IEgPkyl0IaRnqb4nsXKbjUKNL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f74db9e5-cb2b-4014-85a5-08daa5e19e99
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 08:22:47.7338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ui++L0TX2txTKe1Jot66eKt8PhNiXNQBmJFOEeLJ84tHEtH3HiowQ93XZLXf9kMn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4528
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/3/2022 9:17 AM, Oz Shlomo wrote:
> The current offload api provides visibility to flow hw stats.
> This works as long as the flow stats values apply to all the flow's
> actions. However, this assumption breaks when an action, such as police,
> drops or jumps over other actions.
> 
> Extend the flow_offload api to return stat record per action instance.
> Use the specific action, identified with an action cookie, stats value
> when updating the action's hardware stats.
> 
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> ---
>   include/net/flow_offload.h | 10 ++++++++++
>   include/net/pkt_cls.h      | 18 ++++++++++++++++--
>   net/sched/cls_api.c        |  1 +
>   net/sched/cls_flower.c     |  3 ++-
>   net/sched/cls_matchall.c   |  2 +-
>   5 files changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index e343f9f8363e..1c88ca113544 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -213,6 +213,8 @@ struct flow_action_cookie {
>   	u8 cookie[];
>   };
>   
> +#define FLOW_OFFLOAD_MAX_ACT_STATS 32
> +
>   struct flow_action_cookie *flow_action_cookie_create(void *data,
>   						     unsigned int len,
>   						     gfp_t gfp);
> @@ -221,6 +223,7 @@ struct flow_action_cookie *flow_action_cookie_create(void *data,
>   struct flow_action_entry {
>   	enum flow_action_id		id;
>   	u32				hw_index;
> +	unsigned long			act_cookie;
>   	enum flow_action_hw_stats	hw_stats;
>   	action_destr			destructor;
>   	void				*destructor_priv;
> @@ -442,6 +445,11 @@ struct flow_stats {
>   	bool used_hw_stats_valid;
>   };
>   
> +struct flow_act_stat {
> +	unsigned long		act_cookie;
> +	struct flow_stats	stats;
> +};
> +
>   static inline void flow_stats_update(struct flow_stats *flow_stats,
>   				     u64 bytes, u64 pkts,
>   				     u64 drops, u64 lastused,
> @@ -588,6 +596,8 @@ struct flow_cls_offload {
>   	unsigned long cookie;
>   	struct flow_rule *rule;
>   	struct flow_stats stats;
> +	struct flow_act_stat act_stats[FLOW_OFFLOAD_MAX_ACT_STATS];

Apparently this array can exceed the stack frame size for several archs 
(reported by the kernel test bot).
I will change this array to be dynamically allocated.

> +	bool use_act_stats;
>   	u32 classid;
>   };
>   
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index d5b8fa01da87..642e6f07cbf0 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -282,13 +282,27 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
>   
>   static inline void
>   tcf_exts_hw_stats_update(const struct tcf_exts *exts,
> -			 struct flow_stats *stats)
> +			 struct flow_stats *flow_stats,
> +			 struct flow_act_stat *act_stats,
> +			 bool use_act_stats)
>   {
>   #ifdef CONFIG_NET_CLS_ACT
> +	int nr_actions = exts->nr_actions;
>   	int i;
>   
> -	for (i = 0; i < exts->nr_actions; i++) {
> +	if (use_act_stats)
> +		nr_actions = FLOW_OFFLOAD_MAX_ACT_STATS;
> +
> +	for (i = 0; i < nr_actions; i++) {
>   		struct tc_action *a = exts->actions[i];
> +		struct flow_stats *stats = flow_stats;
> +
> +		if (use_act_stats) {
> +			a = (struct tc_action *)act_stats[i].act_cookie;
> +			if (!a)
> +				break;
> +			stats = &act_stats[i].stats;
> +		}
>   
>   		/* if stats from hw, just skip */
>   		if (tcf_action_update_hw_stats(a)) {
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 50566db45949..c5a6a0d7f7a1 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3553,6 +3553,7 @@ int tc_setup_action(struct flow_action *flow_action,
>   		for (k = 0; k < index ; k++) {
>   			entry[k].hw_stats = tc_act_hw_stats(act->hw_stats);
>   			entry[k].hw_index = act->tcfa_index;
> +			entry[k].act_cookie = (unsigned long)act;
>   		}
>   
>   		j += index;
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 82b3e8ff656c..ff004f13d0c9 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -500,7 +500,8 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
>   	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false,
>   			 rtnl_held);
>   
> -	tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats);
> +	tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats,
> +				 cls_flower.act_stats, cls_flower.use_act_stats);
>   }
>   
>   static void __fl_put(struct cls_fl_filter *f)
> diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
> index 225e87740ec5..3d441063113d 100644
> --- a/net/sched/cls_matchall.c
> +++ b/net/sched/cls_matchall.c
> @@ -329,7 +329,7 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
>   
>   	tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false, true);
>   
> -	tcf_exts_hw_stats_update(&head->exts, &cls_mall.stats);
> +	tcf_exts_hw_stats_update(&head->exts, &cls_mall.stats, NULL, false);
>   }
>   
>   static int mall_dump(struct net *net, struct tcf_proto *tp, void *fh,
