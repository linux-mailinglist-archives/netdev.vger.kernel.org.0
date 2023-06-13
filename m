Return-Path: <netdev+bounces-10311-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E0972DCC6
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 10:39:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FBDB281218
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 08:39:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A063D210D;
	Tue, 13 Jun 2023 08:39:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A863D76
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 08:39:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BD0173C
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 01:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686645580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vrGYNaIheG5cW9vw0WAFpAIgS9tsi2HOTi0exhZ2A/c=;
	b=Avk7s660PC5B/iJUn3KiKtCadQwKMcGTFFpqx1JTamUdDo1LWZy1wC66f0elYWQOxe6Ev0
	WUQwhAP+8kmJDS7uatnSSe3LrXVuEqEpdxqoRTphTST1sjPQAgXmF6AUYUoPnOuj4hh976
	sED7yWZPnhZLj+q/hQJ7hGGH55ZuSOc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-st1e-jw8OkmPj_IORDmJwQ-1; Tue, 13 Jun 2023 04:39:39 -0400
X-MC-Unique: st1e-jw8OkmPj_IORDmJwQ-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-62849c5e9f0so6815956d6.1
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 01:39:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686645579; x=1689237579;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vrGYNaIheG5cW9vw0WAFpAIgS9tsi2HOTi0exhZ2A/c=;
        b=P0FLfjugGS4pLEcnY8+mvH1FmCmEswNebxbWoTWS9lmcVzAG1oho7s0qmT+vHjdwb7
         5Apl/2pW9GSm6cQ4d73IDUWB+ElVKjBUk7YAWIa1iuR0HMdG+IqTMKtGPsS02RYeCP8A
         kGBrr33y+Efcgtu7xuAFOzEf/pMrLLVQvxfneU9WzzIN6MaSnv+6Z94VFKjdIfM1DUz9
         EYsxZ8Uos25AzGTa9/c/C5vxeJ2VeLF86e6eyKVKqoUytoeyEEyAhQmVfu78+y/1ntvZ
         ld23FlmmNo2LBFXcSJ7/lvjVXUB27FWR/W2/jpX5hvn9FjDwNoE+K5yavx69+u4sQDQa
         05Ew==
X-Gm-Message-State: AC+VfDwSQ45KwSFDNgzm9x5SvYR4vARdbJTsSE0/RZu38L2EwVIII6Lx
	j2kw0sLHz+1omr93n5KPQsyYbleuxVuGOLxXdQTHoYhPxz8zLigWBddtmQAAVui0tVdMg7AEGRy
	Ecdklm8CIuiF8FtZq
X-Received: by 2002:a05:6214:763:b0:62d:eceb:f7ce with SMTP id f3-20020a056214076300b0062decebf7cemr5372265qvz.1.1686645578858;
        Tue, 13 Jun 2023 01:39:38 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6ArpYF88Ugrz7kYTH6At9wENyZlMxfLOFwsntoCoR4u161C9Q+M0HyVxOHw+cLbQW2p3OGig==
X-Received: by 2002:a05:6214:763:b0:62d:eceb:f7ce with SMTP id f3-20020a056214076300b0062decebf7cemr5372260qvz.1.1686645578567;
        Tue, 13 Jun 2023 01:39:38 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-245-147.dyn.eolo.it. [146.241.245.147])
        by smtp.gmail.com with ESMTPSA id e21-20020a0caa55000000b00626330a39ecsm3835317qvb.9.2023.06.13.01.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 01:39:38 -0700 (PDT)
Message-ID: <7f773c114001cbcd0c6ff21da9976eb0ba533421.camel@redhat.com>
Subject: Re: [PATCH net 2/2] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
From: Paolo Abeni <pabeni@redhat.com>
To: Peilin Ye <yepeilin.cs@gmail.com>, Jamal Hadi Salim <jhs@mojatatu.com>, 
 Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>
Cc: Peilin Ye <peilin.ye@bytedance.com>, Vlad Buslov <vladbu@mellanox.com>, 
 Pedro Tammela <pctammela@mojatatu.com>, John Fastabend
 <john.fastabend@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, Hillf
 Danton <hdanton@sina.com>, Zhengchao Shao <shaozhengchao@huawei.com>,
 netdev@vger.kernel.org,  linux-kernel@vger.kernel.org, Cong Wang
 <cong.wang@bytedance.com>
Date: Tue, 13 Jun 2023 10:39:33 +0200
In-Reply-To: <c1f67078dc8a3fd7b3c8ed65896c726d1e9b261e.1686355297.git.peilin.ye@bytedance.com>
References: <cover.1686355297.git.peilin.ye@bytedance.com>
	 <c1f67078dc8a3fd7b3c8ed65896c726d1e9b261e.1686355297.git.peilin.ye@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

On Sat, 2023-06-10 at 20:30 -0700, Peilin Ye wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
>=20
> mini_Qdisc_pair::p_miniq is a double pointer to mini_Qdisc, initialized
> in ingress_init() to point to net_device::miniq_ingress.  ingress Qdiscs
> access this per-net_device pointer in mini_qdisc_pair_swap().  Similar
> for clsact Qdiscs and miniq_egress.
>=20
> Unfortunately, after introducing RTNL-unlocked RTM_{NEW,DEL,GET}TFILTER
> requests (thanks Hillf Danton for the hint), when replacing ingress or
> clsact Qdiscs, for example, the old Qdisc ("@old") could access the same
> miniq_{in,e}gress pointer(s) concurrently with the new Qdisc ("@new"),
> causing race conditions [1] including a use-after-free bug in
> mini_qdisc_pair_swap() reported by syzbot:
>=20
>  BUG: KASAN: slab-use-after-free in mini_qdisc_pair_swap+0x1c2/0x1f0 net/=
sched/sch_generic.c:1573
>  Write of size 8 at addr ffff888045b31308 by task syz-executor690/14901
> ...
>  Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
>   print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:319
>   print_report mm/kasan/report.c:430 [inline]
>   kasan_report+0x11c/0x130 mm/kasan/report.c:536
>   mini_qdisc_pair_swap+0x1c2/0x1f0 net/sched/sch_generic.c:1573
>   tcf_chain_head_change_item net/sched/cls_api.c:495 [inline]
>   tcf_chain0_head_change.isra.0+0xb9/0x120 net/sched/cls_api.c:509
>   tcf_chain_tp_insert net/sched/cls_api.c:1826 [inline]
>   tcf_chain_tp_insert_unique net/sched/cls_api.c:1875 [inline]
>   tc_new_tfilter+0x1de6/0x2290 net/sched/cls_api.c:2266
> ...
>=20
> @old and @new should not affect each other.  In other words, @old should
> never modify miniq_{in,e}gress after @new, and @new should not update
> @old's RCU state.
>=20
> Fixing without changing sch_api.c turned out to be difficult (please
> refer to Closes: for discussions).  Instead, make sure @new's first call
> always happen after @old's last call (in {ingress,clsact}_destroy()) has
> finished:
>=20
> In qdisc_graft(), return -EBUSY if @old has any ongoing filter requests,
> and call qdisc_destroy() for @old before grafting @new.
>=20
> Introduce qdisc_refcount_dec_if_one() as the counterpart of
> qdisc_refcount_inc_nz() used for filter requests.  Introduce a
> non-static version of qdisc_destroy() that does a TCQ_F_BUILTIN check,
> just like qdisc_put() etc.
>=20
> Depends on patch "net/sched: Refactor qdisc_graft() for ingress and
> clsact Qdiscs".
>=20
> [1] To illustrate, the syzkaller reproducer adds ingress Qdiscs under
> TC_H_ROOT (no longer possible after commit c7cfbd115001 ("net/sched:
> sch_ingress: Only create under TC_H_INGRESS")) on eth0 that has 8
> transmission queues:
>=20
>   Thread 1 creates ingress Qdisc A (containing mini Qdisc a1 and a2),
>   then adds a flower filter X to A.
>=20
>   Thread 2 creates another ingress Qdisc B (containing mini Qdisc b1 and
>   b2) to replace A, then adds a flower filter Y to B.
>=20
>  Thread 1               A's refcnt   Thread 2
>   RTM_NEWQDISC (A, RTNL-locked)
>    qdisc_create(A)               1
>    qdisc_graft(A)                9
>=20
>   RTM_NEWTFILTER (X, RTNL-unlocked)
>    __tcf_qdisc_find(A)          10
>    tcf_chain0_head_change(A)
>    mini_qdisc_pair_swap(A) (1st)
>             |
>             |                         RTM_NEWQDISC (B, RTNL-locked)
>          RCU sync                2     qdisc_graft(B)
>             |                    1     notify_and_destroy(A)
>             |
>    tcf_block_release(A)          0    RTM_NEWTFILTER (Y, RTNL-unlocked)
>    qdisc_destroy(A)                    tcf_chain0_head_change(B)
>    tcf_chain0_head_change_cb_del(A)    mini_qdisc_pair_swap(B) (2nd)
>    mini_qdisc_pair_swap(A) (3rd)                |
>            ...                                 ...
>=20
> Here, B calls mini_qdisc_pair_swap(), pointing eth0->miniq_ingress to
> its mini Qdisc, b1.  Then, A calls mini_qdisc_pair_swap() again during
> ingress_destroy(), setting eth0->miniq_ingress to NULL, so ingress
> packets on eth0 will not find filter Y in sch_handle_ingress().
>=20
> This is just one of the possible consequences of concurrently accessing
> miniq_{in,e}gress pointers.
>=20
> Fixes: 7a096d579e8e ("net: sched: ingress: set 'unlocked' flag for Qdisc =
ops")
> Fixes: 87f373921c4e ("net: sched: ingress: set 'unlocked' flag for clsact=
 Qdisc ops")
> Reported-by: syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/r/0000000000006cf87705f79acf1a@google.com=
/
> Cc: Hillf Danton <hdanton@sina.com>
> Cc: Vlad Buslov <vladbu@mellanox.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>

The fixes LGTM, but I guess this could deserve an explicit ack from
Jakub, as he raised to point for the full retry implementation.

Cheers,

Paolo


