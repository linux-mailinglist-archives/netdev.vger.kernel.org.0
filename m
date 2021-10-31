Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6095440DB0
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 10:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhJaJww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 05:52:52 -0400
Received: from mail-dm6nam10on2062.outbound.protection.outlook.com ([40.107.93.62]:48097
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229638AbhJaJwv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Oct 2021 05:52:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HM2KI1MCgl9/XSqM8mNWE0dwZi55kdPzzq53BMIU1wLXte0ekgtEfKw+XseEP4M6xI+ifxfHhXXluH/C8rOuEaEt72lHLvUUpeMH+5KWY7wAI9xtt7zbynoUNbk6q/wM+QOOXFuSy3BMoGu6gNnr4ifXxuy4ZmN/7/gsy8R6LM67s+BbqkBUpeysKSgjcjKkT4xFzkCNitgVjNmEhYL6sg2zz67A/97tPpBQggYJKUG+MCNIVoYlgRmJ5AZ/fEKaYU9TpK30XwMNB1HlyQHF0IlD/VM9wj6ARfztAjFy2UKPnhEInxZPjZvLEl6GLs61Iht0Wtmh7+s/Ifr38Xz9VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+gR7lFlEoPhOCY1b6niPq7517TGQ2PCKvZSLbFYZfZ4=;
 b=fY6Sa/y0CIUY5H9RxkDduDWMFIjjR850SlqiiD1Ci11Q7VnvUVg3spDBE7b/aEfONiAwQFeVGAQnma9Sh3HtplA98SOmGPUO99T15DrAcRnp3A5MoyMFXOW/kUX9zFWTcI1LjVPmWgxT/tG3tx0vhCpELzkiJrXMSRBLAtssgmXIXWW0PtqtanTpJx0yCZaMyzFsV6S2njAf5tHqMCy1WurUPQUymTkyy2umm2gNLXdRQzByKu9sJdTL3q4bOv6j+GMW/29pbv+Vyppi5pqhJJR5OxEbZNGKkMW/ERYxldoK3/ojQWMmj37v7Lak+lLuZ5MV2bS5aZpQUuvCwr/Tng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+gR7lFlEoPhOCY1b6niPq7517TGQ2PCKvZSLbFYZfZ4=;
 b=C6mmYAksh8lLTz4z09yFH4Mu5RBr8M07HhZh/+droSO8pUp6GDW21i/Z4tGfnoRoGEmB/PclInNVWVgeoU3h2NKMxerLwSTnp6XNS7o39BHxpaYHS6xOVO28gc9DNIhmpNKYcdZSbHGbbXECauyDUpaXlaZ5q0oW2Uu+gywq1lIlM10ryHP0JwAB6hKlVRbKJmFiePYM9EFehf0PXGvkjxtLD8avITL/qz5I7EUx3KCgKrnDlbyCiK0qeNN8CyDahjr1Vv3tF4sohbITgIt3Vpy6JwTNy6ND7l+lC0HzJqRrFIxiEnkCTMJQ9bodQSJgvG2FaZz08VSGVuuQdcvC6A==
Authentication-Results: corigine.com; dkim=none (message not signed)
 header.d=none;corigine.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5379.namprd12.prod.outlook.com (2603:10b6:208:317::15)
 by BL1PR12MB5270.namprd12.prod.outlook.com (2603:10b6:208:31e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Sun, 31 Oct
 2021 09:50:17 +0000
Received: from BL1PR12MB5379.namprd12.prod.outlook.com
 ([fe80::205d:a229:2a0f:1440]) by BL1PR12MB5379.namprd12.prod.outlook.com
 ([fe80::205d:a229:2a0f:1440%9]) with mapi id 15.20.4649.018; Sun, 31 Oct 2021
 09:50:17 +0000
Message-ID: <cf6ebe6c-d852-e934-cbb3-03220d5eedf8@nvidia.com>
Date:   Sun, 31 Oct 2021 11:50:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC/PATCH net-next v3 3/8] flow_offload: allow user to offload
 tc action to net device
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-4-simon.horman@corigine.com>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <20211028110646.13791-4-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0076.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::6) To BL1PR12MB5379.namprd12.prod.outlook.com
 (2603:10b6:208:317::15)
MIME-Version: 1.0
Received: from [172.27.15.108] (193.47.165.251) by FR0P281CA0076.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.5 via Frontend Transport; Sun, 31 Oct 2021 09:50:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a4a90e6-1524-431f-7d9d-08d99c53d7de
X-MS-TrafficTypeDiagnostic: BL1PR12MB5270:
X-Microsoft-Antispam-PRVS: <BL1PR12MB527004C9793F81D2DD163CB6A6899@BL1PR12MB5270.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:565;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xSuiLioMBlkjpabIYAC4mKUS3Dlsut9QtMs2wrvlqnfjmUJmgjF6cO0hP5ANjq/mFWknZrJw9mNXY2dLUiSpkEze4M47ehnltQJmSD+vlo6dx+fBqNpZsb10RmqJqLH21S2Hx6yjIqLOhFl9b5EkEF3KchXEGrkN916TaHSFp7zhRCrlZ5hPoiqFa8UhXn1qJ2crIp12J8++I37lpihgrs865bdJqM+YiEkEAO3AFglUL+th6dvAUXtmhFDKkaLzIihv3h03/CFLZoSNOz941fSazyJr0bv1pzxA6cBFSXLJmQVJCPAA3lhUA24mQzdYA/Y0flWpkE8PddNlTGo2dAG300770ni7FlOucZ8yWhsiKu8BXZsf1b/QWDODEaEDxrahq+cR7txKratzgHs6E4yOurdzXKT5AjwrIZzF6XybyBDk9k2YWYEV2f7EBYr7cxIHDS2h8J/Wk2PzWbalfwhpDZWES6lE0bNJCWLuYayXDM+763/7ywOtqWiZVY1K5Ypl3vdlE9k75ZNFF5HnVzdv4RHNsYxI2ANp3lJfvBn2Oj2Uv9ZSCWvrFsURatkY9acLGS66aMPs+lYu4M4uyzQIspA813/Tc5CxG9SZoJ1zZcZfKHFqi6o39FXeXRwSwQzPFRmxuFsv7mlXpB/OhBmtuMfAnSU+dBz7dlsb22ilYo22sPFZzNawf1Q9Aw2TH2fS6yLrB8MJrgMC5P107iKmtESYNvIr+ayT8ZF1mKFczadtZSW2q4vW8aaRVc6i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5379.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(316002)(186003)(956004)(508600001)(2906002)(26005)(16576012)(5660300002)(31696002)(83380400001)(6486002)(30864003)(66946007)(54906003)(8936002)(8676002)(31686004)(36756003)(38100700002)(66556008)(4326008)(66476007)(53546011)(2616005)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0pqSUozc2JJMU5rakd3M1FlcmR0VDJlMHh3SmVpbk9OblRxWXdqeENWT0wx?=
 =?utf-8?B?T1V6bEdZdDFqajhLdjRiUEdJdGJxUFpMU2VXK3lMU1JsYXgwd1NzR0tOdEQw?=
 =?utf-8?B?WS90TWtqS0c0RTBzemRhTGV6NkZqVkZTc2xGSmdHbXZPMVlVcHV3b3pHRXZZ?=
 =?utf-8?B?empLZ2Q5cnRTU1F6L3BXVHZjNWE0OTZlWVVXQTRISVd3ckxJSE45SmpRZEtZ?=
 =?utf-8?B?ZmIwSW9FdGtlL2p2d2VITG5qdzBab0J4TVgxcFNxZDBmK1MweXJCaDVma1R2?=
 =?utf-8?B?dkpWQ0NZR3h0LzNBK1FjRW1rSkpoRkdaT1VtMUI5VU1JMzVCdDl4MW1UNWI4?=
 =?utf-8?B?cWVtcitZbHk4SVFWOTFKQXljUFdZM2ZIcUxJU0JtRGJpeHpKamhEL1pHY1Ns?=
 =?utf-8?B?bG1raFJsU2RyZHdFLytnY2pRYmhoTGVGU1Q0bS9vbVhMQkhwNllZNWkrZE5N?=
 =?utf-8?B?OXJnRDN6MXJHUkZ1Ym16V3dEMzFWRnd0anZmZ3l6aUxRdW9zYmtRZElvWnhy?=
 =?utf-8?B?NW9Zcy8rdHF4SlMrZHFJWEdWU2I3VW1ScUFjMUR4aksveStFUXdvYThLOFV1?=
 =?utf-8?B?REdmb29id0ZkU0tTVkRDOVZrYWsyMDR0UnlOam4yb0ZDR2lmTElDREUxYW9T?=
 =?utf-8?B?QnRWUGJsUzdxa0pSQm15TzJxT2hPelNkNnQ4QXBLbFJHRnBYN1BYb3orMG91?=
 =?utf-8?B?TVdnS2owczNvY0cvYzVDVlZnb3h3bWNOL2hiQWZaRkp0ZWZocUdmSUdFcTc1?=
 =?utf-8?B?N0p3VHpnMm9VREsvdkoyOVpZdVAyVXNzZWpCUVhMd1JvMVJub1laeTJBamk1?=
 =?utf-8?B?U09EK3gvQnhnU2Y0N284L09QOGRITUNPMGh1REhLSGhrbnM0NjVVaG9pa2sy?=
 =?utf-8?B?SUNyeVBJWHZFNjNXVy90a3o4VjlrYnRaRXVHUjJpZjBiMUdER0JYOU5aSHV3?=
 =?utf-8?B?dDZhckFDNVRLK0p6TmlVcU1VK1prTjEzdFloTVlkUVhjMW5tbHQ0akVsT2Zp?=
 =?utf-8?B?MmpaSktQMXZ6L3ZmL1ZLdFdkZ1gyZ01lWVBweUl4WHdZU0NZY0hDWWVUTytR?=
 =?utf-8?B?OWlpWktYM3g2TXRGcHZScGFmNUZUT3FBZk1jcWt5VUs0Ty8rVGpTTzFmQlZQ?=
 =?utf-8?B?ZU53ekVCV2RIL0FqUWY4QTVVT2tOZWpnZU1KQ3ROSDl3YXNFT29ySkRTaUZr?=
 =?utf-8?B?bFpWeE0zcjZDMlIyODJQZFNGRHNISFRIem9UWXV1MVRCR3Vhc0k3YzFFNGww?=
 =?utf-8?B?eFpBTDk3bHkvWXY1RmFDTzVpOGdENFlsUUY4dS95RllLSWpoRUVrcGg0TzZp?=
 =?utf-8?B?YlBHZnkwaGVDcHBYeXR1MjFldkFXRGNHbEFxSUgwVTlINmdFQ2JDdFF4K2Vs?=
 =?utf-8?B?eElyT3FrbHo5Wm9DUEZXYXYvblhuRHJ2WnpIQk1UTXhUWGFmRThacW02U2hB?=
 =?utf-8?B?RnlWSE5JZ3VPY1ZzOUQ4SC9DQVhDTlhINUR5TjE1WS9PcFFUVDZYMUhDTFpO?=
 =?utf-8?B?ai8ydHhMaG5vQ1FWeklLT1h3T2lVTk9sSHVGTmFGRU9qZUFzYXBydmNtOHFo?=
 =?utf-8?B?UmNjMWF5WTVLV1daVFdZNjJyazQwUDdXSytRMEd6YlFzdk9iUnRNZDRuY2x0?=
 =?utf-8?B?ZGVabVlwNFRvdHc2UUtNcHFtVE5lN0wzaDlwYmxMdXN1bkpOb1RPelN5OWFN?=
 =?utf-8?B?TjVPOHA2ZFloZDJreWJKaWxSRGhoYXBuTURFeHRSY1Nuelg3NEtGM2dreEYz?=
 =?utf-8?B?QzlOeEkxRytFS2tjVUNVN3l2bFBFOE0xTXMwYldDL0hIYVYzci9HNVppcXVK?=
 =?utf-8?B?QUtzRGlLWVlKQmNOd0kxblhkOEIxMXI3TnBYTFNYU1VsYi9tRWx0WG56bmpr?=
 =?utf-8?B?WnZtL3J5Q2JSRzZmOE4vU0ozbUVyb0ZCWlcwVGJ4MndGYVlJd3ozWjdUK0dv?=
 =?utf-8?B?ajRJemtxci9mdjRPQVBiaFZGaVhwQWE5eW5OSGIxZ05tT1hhUVV5a2tWRmor?=
 =?utf-8?B?RWs3VnRwT3gxQ1ZXeFM0bDNqQlJTaU9Qek85L0pNNzNoQ1R0ZCs3bC92M3gx?=
 =?utf-8?B?Qkt1QUx3TXJ6UXcvQW9mdzBRL0l1SEV5emgzL0lZUFJ1anBqaU5JOHhJNFZB?=
 =?utf-8?Q?4qZc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a4a90e6-1524-431f-7d9d-08d99c53d7de
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5379.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2021 09:50:17.2116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VoCNdk9v9xGtjPeWzq0C4Q1nlWJOd+jdb4Mhf+0wlu2JzNtxIiHJ+mXSijtj7NHd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5270
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/28/2021 2:06 PM, Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> Use flow_indr_dev_register/flow_indr_dev_setup_offload to
> offload tc action.

How will device drivers reference the offloaded actions when offloading a flow?
Perhaps the flow_action_entry structure should also include the action index.

> 
> We need to call tc_cleanup_flow_action to clean up tc action entry since
> in tc_setup_action, some actions may hold dev refcnt, especially the mirror
> action.
> 
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>   include/linux/netdevice.h  |   1 +
>   include/net/act_api.h      |   2 +-
>   include/net/flow_offload.h |  17 ++++
>   include/net/pkt_cls.h      |  15 ++++
>   net/core/flow_offload.c    |  43 ++++++++--
>   net/sched/act_api.c        | 166 +++++++++++++++++++++++++++++++++++++
>   net/sched/cls_api.c        |  29 ++++++-
>   7 files changed, 260 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 3ec42495a43a..9815c3a058e9 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -916,6 +916,7 @@ enum tc_setup_type {
>   	TC_SETUP_QDISC_TBF,
>   	TC_SETUP_QDISC_FIFO,
>   	TC_SETUP_QDISC_HTB,
> +	TC_SETUP_ACT,
>   };
>   
>   /* These structures hold the attributes of bpf state that are being passed
> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index b5b624c7e488..9eb19188603c 100644
> --- a/include/net/act_api.h
> +++ b/include/net/act_api.h
> @@ -239,7 +239,7 @@ static inline void tcf_action_inc_overlimit_qstats(struct tc_action *a)
>   void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
>   			     u64 drops, bool hw);
>   int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
> -
> +int tcf_action_offload_del(struct tc_action *action);
>   int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
>   			     struct tcf_chain **handle,
>   			     struct netlink_ext_ack *newchain);
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 3961461d9c8b..aa28592fccc0 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -552,6 +552,23 @@ struct flow_cls_offload {
>   	u32 classid;
>   };
>   
> +enum flow_act_command {
> +	FLOW_ACT_REPLACE,
> +	FLOW_ACT_DESTROY,
> +	FLOW_ACT_STATS,
> +};
> +
> +struct flow_offload_action {
> +	struct netlink_ext_ack *extack; /* NULL in FLOW_ACT_STATS process*/
> +	enum flow_act_command command;
> +	enum flow_action_id id;
> +	u32 index;
> +	struct flow_stats stats;
> +	struct flow_action action;
> +};
> +
> +struct flow_offload_action *flow_action_alloc(unsigned int num_actions);
> +
>   static inline struct flow_rule *
>   flow_cls_offload_flow_rule(struct flow_cls_offload *flow_cmd)
>   {
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index 193f88ebf629..922775407257 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -258,6 +258,9 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
>   	for (; 0; (void)(i), (void)(a), (void)(exts))
>   #endif
>   
> +#define tcf_act_for_each_action(i, a, actions) \
> +	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
> +
>   static inline void
>   tcf_exts_stats_update(const struct tcf_exts *exts,
>   		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
> @@ -532,8 +535,19 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
>   	return ifindex == skb->skb_iif;
>   }
>   
> +#ifdef CONFIG_NET_CLS_ACT
>   int tc_setup_flow_action(struct flow_action *flow_action,
>   			 const struct tcf_exts *exts);
> +#else
> +static inline int tc_setup_flow_action(struct flow_action *flow_action,
> +				       const struct tcf_exts *exts)
> +{
> +	return 0;
> +}
> +#endif
> +
> +int tc_setup_action(struct flow_action *flow_action,
> +		    struct tc_action *actions[]);
>   void tc_cleanup_flow_action(struct flow_action *flow_action);
>   
>   int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
> @@ -554,6 +568,7 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
>   			  enum tc_setup_type type, void *type_data,
>   			  void *cb_priv, u32 *flags, unsigned int *in_hw_count);
>   unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
> +unsigned int tcf_act_num_actions_single(struct tc_action *act);
>   
>   #ifdef CONFIG_NET_CLS_ACT
>   int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index 6beaea13564a..6676431733ef 100644
> --- a/net/core/flow_offload.c
> +++ b/net/core/flow_offload.c
> @@ -27,6 +27,27 @@ struct flow_rule *flow_rule_alloc(unsigned int num_actions)
>   }
>   EXPORT_SYMBOL(flow_rule_alloc);
>   
> +struct flow_offload_action *flow_action_alloc(unsigned int num_actions)
> +{
> +	struct flow_offload_action *fl_action;
> +	int i;
> +
> +	fl_action = kzalloc(struct_size(fl_action, action.entries, num_actions),
> +			    GFP_KERNEL);
> +	if (!fl_action)
> +		return NULL;
> +
> +	fl_action->action.num_entries = num_actions;
> +	/* Pre-fill each action hw_stats with DONT_CARE.
> +	 * Caller can override this if it wants stats for a given action.
> +	 */
> +	for (i = 0; i < num_actions; i++)
> +		fl_action->action.entries[i].hw_stats = FLOW_ACTION_HW_STATS_DONT_CARE;
> +
> +	return fl_action;
> +}
> +EXPORT_SYMBOL(flow_action_alloc);
> +
>   #define FLOW_DISSECTOR_MATCH(__rule, __type, __out)				\
>   	const struct flow_match *__m = &(__rule)->match;			\
>   	struct flow_dissector *__d = (__m)->dissector;				\
> @@ -549,19 +570,25 @@ int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
>   				void (*cleanup)(struct flow_block_cb *block_cb))
>   {
>   	struct flow_indr_dev *this;
> +	u32 count = 0;
> +	int err;
>   
>   	mutex_lock(&flow_indr_block_lock);
> +	if (bo) {
> +		if (bo->command == FLOW_BLOCK_BIND)
> +			indir_dev_add(data, dev, sch, type, cleanup, bo);
> +		else if (bo->command == FLOW_BLOCK_UNBIND)
> +			indir_dev_remove(data);
> +	}
>   
> -	if (bo->command == FLOW_BLOCK_BIND)
> -		indir_dev_add(data, dev, sch, type, cleanup, bo);
> -	else if (bo->command == FLOW_BLOCK_UNBIND)
> -		indir_dev_remove(data);
> -
> -	list_for_each_entry(this, &flow_block_indr_dev_list, list)
> -		this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
> +	list_for_each_entry(this, &flow_block_indr_dev_list, list) {
> +		err = this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
> +		if (!err)
> +			count++;
> +	}
>   
>   	mutex_unlock(&flow_indr_block_lock);
>   
> -	return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
> +	return (bo && list_empty(&bo->cb_list)) ? -EOPNOTSUPP : count;
>   }
>   EXPORT_SYMBOL(flow_indr_dev_setup_offload);
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 3258da3d5bed..33f2ff885b4b 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -21,6 +21,19 @@
>   #include <net/pkt_cls.h>
>   #include <net/act_api.h>
>   #include <net/netlink.h>
> +#include <net/tc_act/tc_pedit.h>
> +#include <net/tc_act/tc_mirred.h>
> +#include <net/tc_act/tc_vlan.h>
> +#include <net/tc_act/tc_tunnel_key.h>
> +#include <net/tc_act/tc_csum.h>
> +#include <net/tc_act/tc_gact.h>
> +#include <net/tc_act/tc_police.h>
> +#include <net/tc_act/tc_sample.h>
> +#include <net/tc_act/tc_skbedit.h>
> +#include <net/tc_act/tc_ct.h>
> +#include <net/tc_act/tc_mpls.h>
> +#include <net/tc_act/tc_gate.h>
> +#include <net/flow_offload.h>
>   
>   #ifdef CONFIG_INET
>   DEFINE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
> @@ -148,6 +161,7 @@ static int __tcf_action_put(struct tc_action *p, bool bind)
>   		idr_remove(&idrinfo->action_idr, p->tcfa_index);
>   		mutex_unlock(&idrinfo->lock);
>   
> +		tcf_action_offload_del(p);
>   		tcf_action_cleanup(p);
>   		return 1;
>   	}
> @@ -341,6 +355,7 @@ static int tcf_idr_release_unsafe(struct tc_action *p)
>   		return -EPERM;
>   
>   	if (refcount_dec_and_test(&p->tcfa_refcnt)) {
> +		tcf_action_offload_del(p);
>   		idr_remove(&p->idrinfo->action_idr, p->tcfa_index);
>   		tcf_action_cleanup(p);
>   		return ACT_P_DELETED;
> @@ -452,6 +467,7 @@ static int tcf_idr_delete_index(struct tcf_idrinfo *idrinfo, u32 index)
>   						p->tcfa_index));
>   			mutex_unlock(&idrinfo->lock);
>   
> +			tcf_action_offload_del(p);
>   			tcf_action_cleanup(p);
>   			module_put(owner);
>   			return 0;
> @@ -1061,6 +1077,154 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>   	return ERR_PTR(err);
>   }
>   
> +static int flow_action_init(struct flow_offload_action *fl_action,
> +			    struct tc_action *act,
> +			    enum flow_act_command cmd,
> +			    struct netlink_ext_ack *extack)
> +{
> +	if (!fl_action)
> +		return -EINVAL;
> +
> +	fl_action->extack = extack;
> +	fl_action->command = cmd;
> +	fl_action->index = act->tcfa_index;
> +
> +	if (is_tcf_gact_ok(act)) {
> +		fl_action->id = FLOW_ACTION_ACCEPT;
> +	} else if (is_tcf_gact_shot(act)) {
> +		fl_action->id = FLOW_ACTION_DROP;
> +	} else if (is_tcf_gact_trap(act)) {
> +		fl_action->id = FLOW_ACTION_TRAP;
> +	} else if (is_tcf_gact_goto_chain(act)) {
> +		fl_action->id = FLOW_ACTION_GOTO;
> +	} else if (is_tcf_mirred_egress_redirect(act)) {
> +		fl_action->id = FLOW_ACTION_REDIRECT;
> +	} else if (is_tcf_mirred_egress_mirror(act)) {
> +		fl_action->id = FLOW_ACTION_MIRRED;
> +	} else if (is_tcf_mirred_ingress_redirect(act)) {
> +		fl_action->id = FLOW_ACTION_REDIRECT_INGRESS;
> +	} else if (is_tcf_mirred_ingress_mirror(act)) {
> +		fl_action->id = FLOW_ACTION_MIRRED_INGRESS;
> +	} else if (is_tcf_vlan(act)) {
> +		switch (tcf_vlan_action(act)) {
> +		case TCA_VLAN_ACT_PUSH:
> +			fl_action->id = FLOW_ACTION_VLAN_PUSH;
> +			break;
> +		case TCA_VLAN_ACT_POP:
> +			fl_action->id = FLOW_ACTION_VLAN_POP;
> +			break;
> +		case TCA_VLAN_ACT_MODIFY:
> +			fl_action->id = FLOW_ACTION_VLAN_MANGLE;
> +			break;
> +		default:
> +			return -EOPNOTSUPP;
> +		}
> +	} else if (is_tcf_tunnel_set(act)) {
> +		fl_action->id = FLOW_ACTION_TUNNEL_ENCAP;
> +	} else if (is_tcf_tunnel_release(act)) {
> +		fl_action->id = FLOW_ACTION_TUNNEL_DECAP;
> +	} else if (is_tcf_csum(act)) {
> +		fl_action->id = FLOW_ACTION_CSUM;
> +	} else if (is_tcf_skbedit_mark(act)) {
> +		fl_action->id = FLOW_ACTION_MARK;
> +	} else if (is_tcf_sample(act)) {
> +		fl_action->id = FLOW_ACTION_SAMPLE;
> +	} else if (is_tcf_police(act)) {
> +		fl_action->id = FLOW_ACTION_POLICE;
> +	} else if (is_tcf_ct(act)) {
> +		fl_action->id = FLOW_ACTION_CT;
> +	} else if (is_tcf_mpls(act)) {
> +		switch (tcf_mpls_action(act)) {
> +		case TCA_MPLS_ACT_PUSH:
> +			fl_action->id = FLOW_ACTION_MPLS_PUSH;
> +			break;
> +		case TCA_MPLS_ACT_POP:
> +			fl_action->id = FLOW_ACTION_MPLS_POP;
> +			break;
> +		case TCA_MPLS_ACT_MODIFY:
> +			fl_action->id = FLOW_ACTION_MPLS_MANGLE;
> +			break;
> +		default:
> +			return -EOPNOTSUPP;
> +		}
> +	} else if (is_tcf_skbedit_ptype(act)) {
> +		fl_action->id = FLOW_ACTION_PTYPE;
> +	} else if (is_tcf_skbedit_priority(act)) {
> +		fl_action->id = FLOW_ACTION_PRIORITY;
> +	} else if (is_tcf_gate(act)) {
> +		fl_action->id = FLOW_ACTION_GATE;
> +	} else {
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
> +static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
> +				  struct netlink_ext_ack *extack)
> +{
> +	int err;
> +
> +	if (IS_ERR(fl_act))
> +		return PTR_ERR(fl_act);
> +
> +	err = flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT,
> +					  fl_act, NULL, NULL);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;
> +}
> +
> +/* offload the tc command after inserted */
> +static int tcf_action_offload_add(struct tc_action *action,
> +				  struct netlink_ext_ack *extack)
> +{
> +	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
> +		[0] = action,
> +	};
> +	struct flow_offload_action *fl_action;
> +	int err = 0;
> +
> +	fl_action = flow_action_alloc(tcf_act_num_actions_single(action));
> +	if (!fl_action)
> +		return -EINVAL;
> +
> +	err = flow_action_init(fl_action, action, FLOW_ACT_REPLACE, extack);
> +	if (err)
> +		goto fl_err;
> +
> +	err = tc_setup_action(&fl_action->action, actions);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Failed to setup tc actions for offload\n");
> +		goto fl_err;
> +	}
> +
> +	err = tcf_action_offload_cmd(fl_action, extack);
> +	tc_cleanup_flow_action(&fl_action->action);
> +
> +fl_err:
> +	kfree(fl_action);
> +
> +	return err;
> +}
> +
> +int tcf_action_offload_del(struct tc_action *action)
> +{
> +	struct flow_offload_action fl_act;
> +	int err = 0;
> +
> +	if (!action)
> +		return -EINVAL;
> +
> +	err = flow_action_init(&fl_act, action, FLOW_ACT_DESTROY, NULL);
> +	if (err)
> +		return err;
> +
> +	return tcf_action_offload_cmd(&fl_act, NULL);
> +}
> +
>   /* Returns numbers of initialized actions or negative error. */
>   
>   int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
> @@ -1103,6 +1267,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
>   		sz += tcf_action_fill_size(act);
>   		/* Start from index 0 */
>   		actions[i - 1] = act;
> +		if (!(flags & TCA_ACT_FLAGS_BIND))
> +			tcf_action_offload_add(act, extack);

Why is this restricted to actions created without the TCA_ACT_FLAGS_BIND flag?
How are actions instantiated by the filters different from those that are created by "tc actions"?

>   	}
>   
>   	/* We have to commit them all together, because if any error happened in
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 2ef8f5a6205a..351d93988b8b 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3544,8 +3544,8 @@ static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
>   	return hw_stats;
>   }
>   
> -int tc_setup_flow_action(struct flow_action *flow_action,
> -			 const struct tcf_exts *exts)
> +int tc_setup_action(struct flow_action *flow_action,
> +		    struct tc_action *actions[])
>   {
>   	struct tc_action *act;
>   	int i, j, k, err = 0;
> @@ -3554,11 +3554,11 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>   	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
>   	BUILD_BUG_ON(TCA_ACT_HW_STATS_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
>   
> -	if (!exts)
> +	if (!actions)
>   		return 0;
>   
>   	j = 0;
> -	tcf_exts_for_each_action(i, act, exts) {
> +	tcf_act_for_each_action(i, act, actions) {
>   		struct flow_action_entry *entry;
>   
>   		entry = &flow_action->entries[j];
> @@ -3725,7 +3725,19 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>   	spin_unlock_bh(&act->tcfa_lock);
>   	goto err_out;
>   }
> +EXPORT_SYMBOL(tc_setup_action);
> +
> +#ifdef CONFIG_NET_CLS_ACT
> +int tc_setup_flow_action(struct flow_action *flow_action,
> +			 const struct tcf_exts *exts)
> +{
> +	if (!exts)
> +		return 0;
> +
> +	return tc_setup_action(flow_action, exts->actions);
> +}
>   EXPORT_SYMBOL(tc_setup_flow_action);
> +#endif
>   
>   unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
>   {
> @@ -3743,6 +3755,15 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
>   }
>   EXPORT_SYMBOL(tcf_exts_num_actions);
>   
> +unsigned int tcf_act_num_actions_single(struct tc_action *act)
> +{
> +	if (is_tcf_pedit(act))
> +		return tcf_pedit_nkeys(act);
> +	else
> +		return 1;
> +}
> +EXPORT_SYMBOL(tcf_act_num_actions_single);
> +
>   #ifdef CONFIG_NET_CLS_ACT
>   static int tcf_qevent_parse_block_index(struct nlattr *block_index_attr,
>   					u32 *p_block_index,
> 
