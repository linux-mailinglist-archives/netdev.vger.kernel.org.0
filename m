Return-Path: <netdev+bounces-7990-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B3DE72261E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D095E2811FF
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:41:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 888C1134A7;
	Mon,  5 Jun 2023 12:41:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB30525E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:41:45 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2131.outbound.protection.outlook.com [40.107.237.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF6691
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 05:41:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKMhTFsg+2xGGgmL+pU9LGflsPKPaQGY0vukFXo6CLSi34Jv76eJXufEz83oFKFa43lLdvLup1KaTVHH1yKqOrhz6kZSJmlKwJqhkT+IeWExg3y25TRyKu4Ko7SX7ihLK4g+Isvo9osMAf4r7rKVppm7XwjPNrnzc4DXkWzCONgPBbevbaU2jqW/WZbIeFB7gcqpCHLowNBKigHrAxyya59ex4PE9noNEMaRKUjy+9du4RQgOjdFJzytF2fvuYRsNk3wpGvjp42nWWSBM8J08VhJElS1vh2cf6XFO81mAhfgYtB56339Sgk6ybMtNIdbRPWiwNLEUkUrNhXx32cyPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2iAiIv46pHz7BJKamHwveTc3jSCDYHXw6X1HaubF8/4=;
 b=lmneliADOJuQYeganTi3QJhUVEw+SbQSzUYyZTkLrwNqhZIcig8uP6daqpE06lmL/If2O6Fvq5fmwpNGRDXcdar4CZgcgO0Eivvd9UKczcvtWcWMwQdjwrsUsqLTZKhTGaDUKrzDDn0mMUBoTwb7KKL8gkeI6OkW6SC1e6j0CbMBMpZVzhfRlg5xUomvbJe+ML5jgQgZ+B1w/PEsP2dMwE2yGc/wdQXlYUnd8r0glPHOQJ5qgEST0rguLRUjMm1VqjzggoEDh8r0a232eEgCH8VlwQOTmn6i1NQst00uIlh8LJ9tDYqMFkcrm/Opxq3pvQzF3467z7nJS0IkhZm76g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2iAiIv46pHz7BJKamHwveTc3jSCDYHXw6X1HaubF8/4=;
 b=cQEsHCO+mfkeoyNTELc8p8NLefzX8uYh+0A1MZ2rdsmApKxaqcuZlfh9OUMvGL9TbhpxluGru3XBqBPIDNBwpMW8j1ZjQRU9y3sL88pdhJG3LzLvJLnE6xcbvTuLGxiq0pUOT3esBfb0TnxOF+wj+DtnfV/APCBDXUY0XG/oLZQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4967.namprd13.prod.outlook.com (2603:10b6:303:f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 12:41:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 12:41:40 +0000
Date: Mon, 5 Jun 2023 14:41:34 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Eelco Chaudron <echaudro@redhat.com>
Cc: netdev@vger.kernel.org, dev@openvswitch.org, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Subject: Re: [ovs-dev] [PATCH net] net: openvswitch: fix upcall counter
 access before allocation
Message-ID: <ZH3X/lLNwfAIZfdq@corigine.com>
References: <168595558535.1618839.4634246126873842766.stgit@ebuild>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168595558535.1618839.4634246126873842766.stgit@ebuild>
X-ClientProxiedBy: AS4PR09CA0029.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4967:EE_
X-MS-Office365-Filtering-Correlation-Id: 36f75d12-050f-41ec-ab29-08db65c23594
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/xSfZ/hqmuosCZn4QrcQMhXGPv8B0xUTZK3EwirCpbzKrCPqP8hhAZ/eblciXB/Mjjj32VuVnnv1/knOXewbQxEdCX7OcdAOF0l7lPQ0FfE+rk7cq3Lr59ov5K9y6zuYVu5lVZZUeeUlkCjPGD+M52nK43ZsrZBIwIK8zWiNmHzp76BvgLQwUb7VOxTIET1+yoXujXbniTv1+WOJf7l+w52CMeO3r7DCsJxCsA3ZEM1uxa0dDqCbmGAV0myaFXhlAxQsc96rD7xd76JotGNZXq4MMEZcFSNYjwtIyuTvYY5mRDLatoafrEbsNyQ2qYfBmV0bUC9zMW/68+cjJq47l92EbGoOcVEGyr+dINe1r6Ye+ZhOJ7BDkBgcvSUlDWFpGuFbPneLRshPa1syKosiHX1uUyxWmjPXDSfxgXP28P6n04AvttrWZnKnA4JXBuANJYbvrKE7nEqDigQxB7ZA+ADQG7c4xWtSlIAZZss8+Gtnf0IaaJ3aFmAycqNMlJhIxhtL/AiDIAA1Ogrq5X+SOm49ZLyesBYAsQ0BgjaNUTc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(346002)(376002)(366004)(136003)(451199021)(36756003)(2906002)(478600001)(86362001)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002)(44832011)(4326008)(6916009)(66476007)(66556008)(66946007)(83380400001)(6506007)(6512007)(2616005)(186003)(966005)(6486002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Dh0QeCWvDX1HyI4Ozj9sF0E5XOv/EfELYNr0M/5NIJ7iXeKCQGTEM1bXpyhm?=
 =?us-ascii?Q?331hpBvx84Z9TL5K8wOkl3UCU8YeSOP3ZN/xwCaiqtKqQ30uWZ1MWRYCHVV3?=
 =?us-ascii?Q?zvGZhSASKyRTimy5uRnOyaD8cMpEojXK3z02AyCeK85C9ZzMBHSJHzaz0DUQ?=
 =?us-ascii?Q?P2oFjZKQ8Ho6twDpJDyyrVjeAhiUylHqxIO0762lY6jy5gVvFc7SsTbbIMdj?=
 =?us-ascii?Q?s2m7c6nYyg+chV8qjG5p7qg+lcepi5usbqNIN7ZcEkjjj5QkzZdHu3tVtpiV?=
 =?us-ascii?Q?O8a3KddeInG1m36yG+VNg/32jCVf5Goby/Fy3Kwyylnu6GGHnNc0vQH/Gn4f?=
 =?us-ascii?Q?h7lq/XouppWV4aGHAT+VBNZjx073mOx0owmmty1GSZYNmIuNRakGlWkzY44c?=
 =?us-ascii?Q?LenSlLyUnGrNWq+KArnySDC71AZnWs3AnzLdFRljKohxTJljyb7JETWl3M0d?=
 =?us-ascii?Q?44tnqa6V8N1SJ1yxH1shywLhGqcbx+ME0MTT6HDhW33xlez8+JSMXiu6LbSq?=
 =?us-ascii?Q?k0AQcRZw5bUkBfFXrkqjrmOz4cf7eI14Ywdz9EGngcXJHXNWgWsRBppmXE+6?=
 =?us-ascii?Q?DJvuUiLkEGbSxOUkGHFWsWNHmMLpfOyQE9mQ8WfjEoEE1NnEuVslT3lA7Oqi?=
 =?us-ascii?Q?xPPvjio0W+UAtDRcrdQMlACww0CqsMPhAvzyJvCiH7RyAwWghlbLh7dfMk9t?=
 =?us-ascii?Q?F7vRYwtzlgQOMj+WriTy0HERVDdeFbQSrssRgP2DpzseaNwtkjic1jCJixHd?=
 =?us-ascii?Q?X6CGIQBIiCSi5vYp1b8txQxW728lh9eKyPxASKCIotrFLC87Lw9/rbRHrA/C?=
 =?us-ascii?Q?mYadQnXCVTyB2KhReP4Xuctwhi546CaH9xqs8MQ1H6WFP1+FkyVOf5eD4fQg?=
 =?us-ascii?Q?+8DHajRXAUVfCoyknPPqvnZ8HNKXVw8AoKm98Vn9DEkhxJdn41nnFjR7iM3A?=
 =?us-ascii?Q?KQsiK5vz/VXtlwYSJ0MFUiqsQl8K4qMdin22nlzCihV0+xA1pbuk59ec7psK?=
 =?us-ascii?Q?qiYBHxRD7Q31kNSgTkHCW7YC4nKYH44CotjlUEhRLYhNfCeuwYEyQyNSFMnh?=
 =?us-ascii?Q?pHnmIBym0TCwWb7X0Wwvm17n1OUQGUAdGT0IkgaLHPebNUAQVTa+v9e7UKXw?=
 =?us-ascii?Q?qNAIe1qhJgxxeEdnoO9SqWUlPmY/n/GRV2ue4tMmNcxALn5hhEjq9yztrbCp?=
 =?us-ascii?Q?WOH88QzqHrmnOeGwOuLWM4RTtmv196BrkyyoIbe2dtH96pCMPWQFU61KjASy?=
 =?us-ascii?Q?eJHbQ7cBPlxE+R2kf1HlvswrOInuCigh1zlAMfxLY7/DlnUY00z1zht9uEWI?=
 =?us-ascii?Q?V1zF0weApnk3Khl5urxQN51yhBHrhRzitS6PRIqA2+wN+tTAC7PMUg9zDebs?=
 =?us-ascii?Q?xPwmLmWm4Zj89lrSwWYXXz04ZBLXUFrJ/PQmR4Ch6sZcr6wlIAPOq5ANq7EI?=
 =?us-ascii?Q?QmV7gcNuXoCWVaCCpSe3pqSKCdOreYppQpEpB6AhUEK4dbWKvG7Rp54QYx34?=
 =?us-ascii?Q?ascnbWMfwpXW7MJRAG4athA2SFEYsVXeSxsr9dlsvfTjWl4chTzKWmO5uTZH?=
 =?us-ascii?Q?S3LdihGJ7MTbIr30e1OPtb4Meaa0Qae09ygS4BJAdHtk0b7g0/rpSt3g8vgh?=
 =?us-ascii?Q?MBRltniknsA60i05TGmnbD9tTHBa2ywyt/Se6fCgsEFwAb3E2RTwCUoWJAjE?=
 =?us-ascii?Q?eMqwWA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36f75d12-050f-41ec-ab29-08db65c23594
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 12:41:40.2886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l9ghid+IfFzhgpGCj0VOp3kvhJJGm9cOMEy9OVUFLQwjmy/oOXmMm3bUSocYHoGHzlgxxWI5dw9iVLcSExLtaq65jNQ1njPmFXi8fjDbwTA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4967
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 10:59:50AM +0200, Eelco Chaudron wrote:
> Currently, the per cpu upcall counters are allocated after the vport is
> created and inserted into the system. This could lead to the datapath
> accessing the counters before they are allocated resulting in a kernel
> Oops.
> 
> Here is an example:
> 
>   PID: 59693    TASK: ffff0005f4f51500  CPU: 0    COMMAND: "ovs-vswitchd"
>    #0 [ffff80000a39b5b0] __switch_to at ffffb70f0629f2f4
>    #1 [ffff80000a39b5d0] __schedule at ffffb70f0629f5cc
>    #2 [ffff80000a39b650] preempt_schedule_common at ffffb70f0629fa60
>    #3 [ffff80000a39b670] dynamic_might_resched at ffffb70f0629fb58
>    #4 [ffff80000a39b680] mutex_lock_killable at ffffb70f062a1388
>    #5 [ffff80000a39b6a0] pcpu_alloc at ffffb70f0594460c
>    #6 [ffff80000a39b750] __alloc_percpu_gfp at ffffb70f05944e68
>    #7 [ffff80000a39b760] ovs_vport_cmd_new at ffffb70ee6961b90 [openvswitch]
>    ...
> 
>   PID: 58682    TASK: ffff0005b2f0bf00  CPU: 0    COMMAND: "kworker/0:3"
>    #0 [ffff80000a5d2f40] machine_kexec at ffffb70f056a0758
>    #1 [ffff80000a5d2f70] __crash_kexec at ffffb70f057e2994
>    #2 [ffff80000a5d3100] crash_kexec at ffffb70f057e2ad8
>    #3 [ffff80000a5d3120] die at ffffb70f0628234c
>    #4 [ffff80000a5d31e0] die_kernel_fault at ffffb70f062828a8
>    #5 [ffff80000a5d3210] __do_kernel_fault at ffffb70f056a31f4
>    #6 [ffff80000a5d3240] do_bad_area at ffffb70f056a32a4
>    #7 [ffff80000a5d3260] do_translation_fault at ffffb70f062a9710
>    #8 [ffff80000a5d3270] do_mem_abort at ffffb70f056a2f74
>    #9 [ffff80000a5d32a0] el1_abort at ffffb70f06297dac
>   #10 [ffff80000a5d32d0] el1h_64_sync_handler at ffffb70f06299b24
>   #11 [ffff80000a5d3410] el1h_64_sync at ffffb70f056812dc
>   #12 [ffff80000a5d3430] ovs_dp_upcall at ffffb70ee6963c84 [openvswitch]
>   #13 [ffff80000a5d3470] ovs_dp_process_packet at ffffb70ee6963fdc [openvswitch]
>   #14 [ffff80000a5d34f0] ovs_vport_receive at ffffb70ee6972c78 [openvswitch]
>   #15 [ffff80000a5d36f0] netdev_port_receive at ffffb70ee6973948 [openvswitch]
>   #16 [ffff80000a5d3720] netdev_frame_hook at ffffb70ee6973a28 [openvswitch]
>   #17 [ffff80000a5d3730] __netif_receive_skb_core.constprop.0 at ffffb70f06079f90
> 
> We moved the per cpu upcall counter allocation to the existing vport
> alloc and free functions to solve this.
> 
> Fixes: 95637d91fefd ("net: openvswitch: release vport resources on failure")
> Fixes: 1933ea365aa7 ("net: openvswitch: Add support to count upcall packets")
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
>  net/openvswitch/datapath.c |   19 -------------------
>  net/openvswitch/vport.c    |    8 ++++++++
>  2 files changed, 8 insertions(+), 19 deletions(-)
> 
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index fcee6012293b..58f530f60172 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -236,9 +236,6 @@ void ovs_dp_detach_port(struct vport *p)
>  	/* First drop references to device. */
>  	hlist_del_rcu(&p->dp_hash_node);
>  
> -	/* Free percpu memory */
> -	free_percpu(p->upcall_stats);
> -
>  	/* Then destroy it. */
>  	ovs_vport_del(p);
>  }
> @@ -1858,12 +1855,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  		goto err_destroy_portids;
>  	}
>  
> -	vport->upcall_stats = netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
> -	if (!vport->upcall_stats) {
> -		err = -ENOMEM;
> -		goto err_destroy_vport;
> -	}
> -
>  	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
>  				   info->snd_seq, 0, OVS_DP_CMD_NEW);
>  	BUG_ON(err < 0);
> @@ -1876,8 +1867,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  	ovs_notify(&dp_datapath_genl_family, reply, info);
>  	return 0;
>  
> -err_destroy_vport:
> -	ovs_dp_detach_port(vport);
>  err_destroy_portids:
>  	kfree(rcu_dereference_raw(dp->upcall_portids));
>  err_unlock_and_destroy_meters:
> @@ -2322,12 +2311,6 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  		goto exit_unlock_free;
>  	}
>  
> -	vport->upcall_stats = netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
> -	if (!vport->upcall_stats) {
> -		err = -ENOMEM;
> -		goto exit_unlock_free_vport;
> -	}
> -
>  	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
>  				      info->snd_portid, info->snd_seq, 0,
>  				      OVS_VPORT_CMD_NEW, GFP_KERNEL);
> @@ -2345,8 +2328,6 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  	ovs_notify(&dp_vport_genl_family, reply, info);
>  	return 0;
>  
> -exit_unlock_free_vport:
> -	ovs_dp_detach_port(vport);
>  exit_unlock_free:
>  	ovs_unlock();
>  	kfree_skb(reply);
> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> index 7e0f5c45b512..e91ae5dd7d22 100644
> --- a/net/openvswitch/vport.c
> +++ b/net/openvswitch/vport.c

Hi Eelco,

could we move to a more idiomatic implementation
of the error path in ovs_vport_alloc() ?

I know it's not strictly related to this change, but OTOH, it is.

> @@ -135,12 +135,19 @@ struct vport *ovs_vport_alloc(int priv_size, const struct vport_ops *ops,
>  	if (!vport)
>  		return ERR_PTR(-ENOMEM);
>  
> +	vport->upcall_stats = netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
> +	if (!vport->upcall_stats) {
		err = -ENOMEM;
		goto err_kfree_vport;

> +		kfree(vport);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
>  	vport->dp = parms->dp;
>  	vport->port_no = parms->port_no;
>  	vport->ops = ops;
>  	INIT_HLIST_NODE(&vport->dp_hash_node);
>  
>  	if (ovs_vport_set_upcall_portids(vport, parms->upcall_portids)) {
		err = -EINVAL;
		goto err_free_percpu;

> +		free_percpu(vport->upcall_stats);
>  		kfree(vport);
>  		return ERR_PTR(-EINVAL);
>  	}

...
	return vport;

err_kfree_vport:
	kfree(vport);
err_free_percpu:
	free_percpu(vport->upcall_stats);
	return(ERR_PTR(err));


> @@ -165,6 +172,7 @@ void ovs_vport_free(struct vport *vport)
>  	 * it is safe to use raw dereference.
>  	 */
>  	kfree(rcu_dereference_raw(vport->upcall_portids));
> +	free_percpu(vport->upcall_stats);
>  	kfree(vport);
>  }
>  EXPORT_SYMBOL_GPL(ovs_vport_free);
> 
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
> 

