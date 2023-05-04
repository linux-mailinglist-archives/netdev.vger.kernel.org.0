Return-Path: <netdev+bounces-330-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28ED06F71DB
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:21:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FC99280DE3
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 18:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB796BE4C;
	Thu,  4 May 2023 18:21:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D035B7E7
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 18:21:06 +0000 (UTC)
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8898E9C
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 11:21:04 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 46e09a7af769-6a606135408so703414a34.0
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 11:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1683224464; x=1685816464;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8zDsQYS3FCzF6OgNzC1vlfEBQ7ZONxUiJEBAHQhpHWI=;
        b=HXCKj6Ccifi26SewtGFEsuFb0OyTjE2UAxIXoZz99du7vIkb47yu0n7u0rfBMeloRn
         y55qA+Hmio7qB71LH5hVdcGXXc/8aX54PERMaTOfgOHKjKh69n0ZWXgPCi7NjPkINM7o
         +Xnf5IBRO54CIAlWgpzTQ2bgNVNGA4sXbWs2NiwHy/+FXdPsc2KQfmqXZo1xpR9La//f
         ZC+chcnPt3Kjv9qRAtJVKY6NxYDzd2ae64zUcaLDbWpmGcULA8rpSGsMEJyd1elGWtnG
         lYkV8U50TwnQBlUbIUNEVWhsJ0Pr5wcBOuFv4h93NLwC+feSYdC0ebOE+3bUwGG5HJ/Q
         WN6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683224464; x=1685816464;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8zDsQYS3FCzF6OgNzC1vlfEBQ7ZONxUiJEBAHQhpHWI=;
        b=konwQe6xgzA9a4XleClHUscs9m/AGPj6v+KWfwvoJ6WV0ePOPuDVVxnKRrj2yc2sRH
         20aTAtsS/A9mmMT1/uvdFuksBHGtD6n8LnAPUIKzN34HqkqcrLg2mz5d6nB774gpYU5m
         23aLJB1LFJMSag/jPuZQsLq8teqY3OinFs26FNF0CKXJSbXc578S7GJTTPCn8IOShep1
         qy/hk73KTIcupeJLNviRXX8v1qLZcEcsPB6prtA0aHRk8KTcT3yB5SPUJ67hZU2jD+lD
         4D1LX+c2gvhZ9A37f9hGy0fA8l6SThWWjvQ66rz5uuE7xhRf9ZwvaIsVcMBjarDKvwCR
         dS2w==
X-Gm-Message-State: AC+VfDxgVZbugu55+CIY4lN4R4OrHDgtMDc2GMaDKyPRb47/ma250QQL
	cgDy7CK5CPBJnvHiHit9aGW0OQ==
X-Google-Smtp-Source: ACHHUZ4/oap22Nf2AlvNfNfJ2d+wcnGH981tYSs/aOnq3xEPR6on5uGwNLS78Vya6/MIQ+4LpDv2Lw==
X-Received: by 2002:a05:6830:1e2d:b0:6a6:5a4a:a691 with SMTP id t13-20020a0568301e2d00b006a65a4aa691mr407188otr.15.1683224463821;
        Thu, 04 May 2023 11:21:03 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:1f7c:197f:18de:768b? ([2804:14d:5c5e:44fb:1f7c:197f:18de:768b])
        by smtp.gmail.com with ESMTPSA id r2-20020a9d7cc2000000b006a7b28e052dsm1974494otn.40.2023.05.04.11.21.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 May 2023 11:21:03 -0700 (PDT)
Message-ID: <d39cf0ab-ff17-c149-22ff-1aa8f5f1cb3c@mojatatu.com>
Date: Thu, 4 May 2023 15:20:58 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net v2 1/3] net/sched: flower: fix filter idr
 initialization
To: Vlad Buslov <vladbu@nvidia.com>, pabeni@redhat.com, davem@davemloft.net,
 kuba@kernel.org
Cc: netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
 jiri@resnulli.us, marcelo.leitner@gmail.com, paulb@nvidia.com,
 simon.horman@corigine.com, ivecera@redhat.com
References: <20230504181616.2834983-1-vladbu@nvidia.com>
 <20230504181616.2834983-2-vladbu@nvidia.com>
Content-Language: en-US
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230504181616.2834983-2-vladbu@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 04/05/2023 15:16, Vlad Buslov wrote:
> The cited commit moved idr initialization too early in fl_change() which
> allows concurrent users to access the filter that is still being
> initialized and is in inconsistent state, which, in turn, can cause NULL
> pointer dereference [0]. Since there is no obvious way to fix the ordering
> without reverting the whole cited commit, alternative approach taken to
> first insert NULL pointer into idr in order to allocate the handle but
> still cause fl_get() to return NULL and prevent concurrent users from
> seeing the filter while providing miss-to-action infrastructure with valid
> handle id early in fl_change().
> 
> [  152.434728] general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN
> [  152.436163] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> [  152.437269] CPU: 4 PID: 3877 Comm: tc Not tainted 6.3.0-rc4+ #5
> [  152.438110] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
> [  152.439644] RIP: 0010:fl_dump_key+0x8b/0x1d10 [cls_flower]
> [  152.440461] Code: 01 f2 02 f2 c7 40 08 04 f2 04 f2 c7 40 0c 04 f3 f3 f3 65 48 8b 04 25 28 00 00 00 48 89 84 24 00 01 00 00 48 89 c8 48 c1 e8 03 <0f> b6 04 10 84 c0 74 08 3c 03 0f 8e 98 19 00 00 8b 13 85 d2 74 57
> [  152.442885] RSP: 0018:ffff88817a28f158 EFLAGS: 00010246
> [  152.443851] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [  152.444826] RDX: dffffc0000000000 RSI: ffffffff8500ae80 RDI: ffff88810a987900
> [  152.445791] RBP: ffff888179d88240 R08: ffff888179d8845c R09: ffff888179d88240
> [  152.446780] R10: ffffed102f451e48 R11: 00000000fffffff2 R12: ffff88810a987900
> [  152.447741] R13: ffffffff8500ae80 R14: ffff88810a987900 R15: ffff888149b3c738
> [  152.448756] FS:  00007f5eb2a34800(0000) GS:ffff88881ec00000(0000) knlGS:0000000000000000
> [  152.449888] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  152.450685] CR2: 000000000046ad19 CR3: 000000010b0bd006 CR4: 0000000000370ea0
> [  152.451641] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  152.452628] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  152.453588] Call Trace:
> [  152.454032]  <TASK>
> [  152.454447]  ? netlink_sendmsg+0x7a1/0xcb0
> [  152.455109]  ? sock_sendmsg+0xc5/0x190
> [  152.455689]  ? ____sys_sendmsg+0x535/0x6b0
> [  152.456320]  ? ___sys_sendmsg+0xeb/0x170
> [  152.456916]  ? do_syscall_64+0x3d/0x90
> [  152.457529]  ? entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [  152.458321]  ? ___sys_sendmsg+0xeb/0x170
> [  152.458958]  ? __sys_sendmsg+0xb5/0x140
> [  152.459564]  ? do_syscall_64+0x3d/0x90
> [  152.460122]  ? entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [  152.460852]  ? fl_dump_key_options.part.0+0xea0/0xea0 [cls_flower]
> [  152.461710]  ? _raw_spin_lock+0x7a/0xd0
> [  152.462299]  ? _raw_read_lock_irq+0x30/0x30
> [  152.462924]  ? nla_put+0x15e/0x1c0
> [  152.463480]  fl_dump+0x228/0x650 [cls_flower]
> [  152.464112]  ? fl_tmplt_dump+0x210/0x210 [cls_flower]
> [  152.464854]  ? __kmem_cache_alloc_node+0x1a7/0x330
> [  152.465592]  ? nla_put+0x15e/0x1c0
> [  152.466160]  tcf_fill_node+0x515/0x9a0
> [  152.466766]  ? tc_setup_offload_action+0xf0/0xf0
> [  152.467463]  ? __alloc_skb+0x13c/0x2a0
> [  152.468067]  ? __build_skb_around+0x330/0x330
> [  152.468814]  ? fl_get+0x107/0x1a0 [cls_flower]
> [  152.469503]  tc_del_tfilter+0x718/0x1330
> [  152.470115]  ? is_bpf_text_address+0xa/0x20
> [  152.470765]  ? tc_ctl_chain+0xee0/0xee0
> [  152.471335]  ? __kernel_text_address+0xe/0x30
> [  152.471948]  ? unwind_get_return_address+0x56/0xa0
> [  152.472639]  ? __thaw_task+0x150/0x150
> [  152.473218]  ? arch_stack_walk+0x98/0xf0
> [  152.473839]  ? __stack_depot_save+0x35/0x4c0
> [  152.474501]  ? stack_trace_save+0x91/0xc0
> [  152.475119]  ? security_capable+0x51/0x90
> [  152.475741]  rtnetlink_rcv_msg+0x2c1/0x9d0
> [  152.476387]  ? rtnl_calcit.isra.0+0x2b0/0x2b0
> [  152.477042]  ? __sys_sendmsg+0xb5/0x140
> [  152.477664]  ? do_syscall_64+0x3d/0x90
> [  152.478255]  ? entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [  152.479010]  ? __stack_depot_save+0x35/0x4c0
> [  152.479679]  ? __stack_depot_save+0x35/0x4c0
> [  152.480346]  netlink_rcv_skb+0x12c/0x360
> [  152.480929]  ? rtnl_calcit.isra.0+0x2b0/0x2b0
> [  152.481517]  ? do_syscall_64+0x3d/0x90
> [  152.482061]  ? netlink_ack+0x1550/0x1550
> [  152.482612]  ? rhashtable_walk_peek+0x170/0x170
> [  152.483262]  ? kmem_cache_alloc_node+0x1af/0x390
> [  152.483875]  ? _copy_from_iter+0x3d6/0xc70
> [  152.484528]  netlink_unicast+0x553/0x790
> [  152.485168]  ? netlink_attachskb+0x6a0/0x6a0
> [  152.485848]  ? unwind_next_frame+0x11cc/0x1a10
> [  152.486538]  ? arch_stack_walk+0x61/0xf0
> [  152.487169]  netlink_sendmsg+0x7a1/0xcb0
> [  152.487799]  ? netlink_unicast+0x790/0x790
> [  152.488355]  ? iovec_from_user.part.0+0x4d/0x220
> [  152.488990]  ? _raw_spin_lock+0x7a/0xd0
> [  152.489598]  ? netlink_unicast+0x790/0x790
> [  152.490236]  sock_sendmsg+0xc5/0x190
> [  152.490796]  ____sys_sendmsg+0x535/0x6b0
> [  152.491394]  ? import_iovec+0x7/0x10
> [  152.491964]  ? kernel_sendmsg+0x30/0x30
> [  152.492561]  ? __copy_msghdr+0x3c0/0x3c0
> [  152.493160]  ? do_syscall_64+0x3d/0x90
> [  152.493706]  ___sys_sendmsg+0xeb/0x170
> [  152.494283]  ? may_open_dev+0xd0/0xd0
> [  152.494858]  ? copy_msghdr_from_user+0x110/0x110
> [  152.495541]  ? __handle_mm_fault+0x2678/0x4ad0
> [  152.496205]  ? copy_page_range+0x2360/0x2360
> [  152.496862]  ? __fget_light+0x57/0x520
> [  152.497449]  ? mas_find+0x1c0/0x1c0
> [  152.498026]  ? sockfd_lookup_light+0x1a/0x140
> [  152.498703]  __sys_sendmsg+0xb5/0x140
> [  152.499306]  ? __sys_sendmsg_sock+0x20/0x20
> [  152.499951]  ? do_user_addr_fault+0x369/0xd80
> [  152.500595]  do_syscall_64+0x3d/0x90
> [  152.501185]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [  152.501917] RIP: 0033:0x7f5eb294f887
> [  152.502494] Code: 0a 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
> [  152.505008] RSP: 002b:00007ffd2c708f78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> [  152.506152] RAX: ffffffffffffffda RBX: 00000000642d9472 RCX: 00007f5eb294f887
> [  152.507134] RDX: 0000000000000000 RSI: 00007ffd2c708fe0 RDI: 0000000000000003
> [  152.508113] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
> [  152.509119] R10: 00007f5eb2808708 R11: 0000000000000246 R12: 0000000000000001
> [  152.510068] R13: 0000000000000000 R14: 00007ffd2c70d1b8 R15: 0000000000485400
> [  152.511031]  </TASK>
> [  152.511444] Modules linked in: cls_flower sch_ingress openvswitch nsh mlx5_vdpa vringh vhost_iotlb vdpa mlx5_ib mlx5_core rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi ib_umad rdma_cm ib_ipoib iw_cm ib_cm ib_uverbs ib_core xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter overlay zram zsmalloc fuse [last unloaded: mlx5_core]
> [  152.515720] ---[ end trace 0000000000000000 ]---
> 
> Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization earlier")
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>

Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>

> ---
>   net/sched/cls_flower.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 6ab6aadc07b8..4dc3a9007f30 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -2210,10 +2210,10 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
>   		spin_lock(&tp->lock);
>   		if (!handle) {
>   			handle = 1;
> -			err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
> +			err = idr_alloc_u32(&head->handle_idr, NULL, &handle,
>   					    INT_MAX, GFP_ATOMIC);
>   		} else {
> -			err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
> +			err = idr_alloc_u32(&head->handle_idr, NULL, &handle,
>   					    handle, GFP_ATOMIC);
>   
>   			/* Filter with specified handle was concurrently
> @@ -2378,7 +2378,7 @@ static void fl_walk(struct tcf_proto *tp, struct tcf_walker *arg,
>   	rcu_read_lock();
>   	idr_for_each_entry_continue_ul(&head->handle_idr, f, tmp, id) {
>   		/* don't return filters that are being deleted */
> -		if (!refcount_inc_not_zero(&f->refcnt))
> +		if (!f || !refcount_inc_not_zero(&f->refcnt))
>   			continue;
>   		rcu_read_unlock();
>   


