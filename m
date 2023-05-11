Return-Path: <netdev+bounces-1904-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A18D36FF776
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 18:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 558C2281920
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D5B1206BB;
	Thu, 11 May 2023 16:35:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B97AA53
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 16:35:32 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DFE7684
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 09:35:16 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f42397f41fso205135e9.1
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 09:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683822915; x=1686414915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ON9Fi0zzx5YtFUBmyUYsMJo9GANJ9V6684fyCL5kqm8=;
        b=onivH4PbV04Tk0WiILbY5H3Of3lUq7JBJJPuKNzsvonzqv7mmCj6pJ5BVjQLw5bX30
         5pOUoulnj4KQuRv8jvtwujMTJnv2rpMjzZRn/nRmYrXIkyduyXwo6jfjW1h41dvOwgbW
         XDKBxmqV4THmYj1gbn1XGGcLvykRxXKC67X3W4vLK1YhUJrhP2WLJcnaHkzpm3IBx6Uz
         ixn2OEN9y4DskXPqeohNXioM/ydi7i0zVMPbUAXiBxUMOpBn/jMJQ9MAlgeuoytIUM7K
         qLtY5yesqXKv/kH+uyBjJQXL6JkoKnbrVzK3NmwUXSn+fUGUHRlhUXOmR2FOfShxPGu2
         TkZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683822915; x=1686414915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ON9Fi0zzx5YtFUBmyUYsMJo9GANJ9V6684fyCL5kqm8=;
        b=INXnzd25WVbVXxLTGEDQAzrtWcmKtJpa1mRA6C4BUUUaAa/dLQmFl90kg6ihfKzblt
         yXeAWkSXPbpbzU+nCxqwivGNtHyG996OTAHWS10Ls6N0ROrtEgxIXqVWltETTi6V5gvR
         2DImvzWWW41DlJkHe1gyuqBXTQEnbNLwfAnjNJJ7Sx8fQK4gjZ1s+kEk14m0oFX0uiFp
         KJnrCSmL6/WXoy1fx/uUnI4xI0wRl87z1Pa9pDOeJiVmlZOtiDg2APCT8niwan2+ULQh
         QevpejoJhGQG4WXNa1tKkyYbxLkgw2yaWgaZPClahhIJE0XnctLKl1M8Dob88b39PTS1
         7+8Q==
X-Gm-Message-State: AC+VfDzj/0mSmqA7iinf/SO7EXoxDqau8o78s7H0gOgwmEvi8Yb++FGc
	aBj6d8cxO/ienttWw0xkB2K1JIyFh45U2OmNHYFTPQ==
X-Google-Smtp-Source: ACHHUZ44DUVZ6CXKVQxVcocy3hWsEM06jeFyQKl7DACOHu54aeGpEBnvtTWKTJIO6BzH86YDumo89nKfoX5r9w4ck+0=
X-Received: by 2002:a05:600c:502b:b0:3f3:3855:c5d8 with SMTP id
 n43-20020a05600c502b00b003f33855c5d8mr26741wmr.6.1683822915271; Thu, 11 May
 2023 09:35:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230508020801.10702-1-cathy.zhang@intel.com> <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
 <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com>
 <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iJvpgXTwGEiXAkFwY3j3RqVhNzJ_6_zmuRb4w7rUA_8Ug@mail.gmail.com>
 <CALvZod6JRuWHftDcH0uw00v=yi_6BKspGCkDA4AbmzLHaLi2Fg@mail.gmail.com>
 <CH3PR11MB7345ABB947E183AFB7C18322FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+9rQcGey+AJyhR02pTTBNhWN+P78e4a8knfC9F5sx0hQ@mail.gmail.com>
 <CH3PR11MB73455A98A232920B322C3976FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com>
 <CH3PR11MB734502756F495CB9C520494FFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod4n+Kwa1sOV9jxiEMTUoO7MaCGWz=wT3MHOuj4t-+9S6Q@mail.gmail.com>
 <CH3PR11MB73454C44EC8BCD43685BCB58FC749@CH3PR11MB7345.namprd11.prod.outlook.com>
 <IA0PR11MB7355E486112E922AA6095CCCFC749@IA0PR11MB7355.namprd11.prod.outlook.com>
 <CANn89iJbAGnZd42SVZEYWFLYVbmHM3p2UDawUKxUBhVDH5A2=A@mail.gmail.com>
 <IA0PR11MB73557DEAB912737FD61D2873FC749@IA0PR11MB7355.namprd11.prod.outlook.com>
 <CALvZod7Y+SxiopRBXOf1HoDKO=Xh8CNPfgz3Etd4XOq5BPc5Ag@mail.gmail.com>
In-Reply-To: <CALvZod7Y+SxiopRBXOf1HoDKO=Xh8CNPfgz3Etd4XOq5BPc5Ag@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 11 May 2023 18:35:03 +0200
Message-ID: <CANn89iKoB2hn8QKBw+8faL4MWZ1ByDW8T9UHyS9G-8c11mWdOw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
To: Shakeel Butt <shakeelb@google.com>
Cc: "Zhang, Cathy" <cathy.zhang@intel.com>, Linux MM <linux-mm@kvack.org>, 
	Cgroups <cgroups@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>, 
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>, "Srinivas, Suresh" <suresh.srinivas@intel.com>, 
	"Chen, Tim C" <tim.c.chen@intel.com>, "You, Lizhen" <lizhen.you@intel.com>, 
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 6:24=E2=80=AFPM Shakeel Butt <shakeelb@google.com> =
wrote:
>
> On Thu, May 11, 2023 at 2:27=E2=80=AFAM Zhang, Cathy <cathy.zhang@intel.c=
om> wrote:
> >
> >
> >
> [...]
> >
> > Here is the output with the command you paste, it's from system wide,
> > I only show pieces of memcached records, and it seems to be a
> > callee -> caller stack trace:
> >
> >      9.02%  mc-worker        [kernel.vmlinux]          [k] page_counter=
_try_charge
> >             |
> >              --9.00%--page_counter_try_charge
> >                        |
> >                         --9.00%--try_charge_memcg
> >                                   mem_cgroup_charge_skmem
> >                                   |
> >                                    --9.00%--__sk_mem_raise_allocated
> >                                              __sk_mem_schedule
> >                                              |
> >                                              |--5.32%--tcp_try_rmem_sch=
edule
> >                                              |          tcp_data_queue
> >                                              |          tcp_rcv_establi=
shed
> >                                              |          tcp_v4_do_rcv
> >                                              |          tcp_v4_rcv
> >                                              |          ip_protocol_del=
iver_rcu
> >                                              |          ip_local_delive=
r_finish
> >                                              |          ip_local_delive=
r
> >                                              |          ip_rcv
> >                                              |          __netif_receive=
_skb_one_core
> >                                              |          __netif_receive=
_skb
> >                                              |          process_backlog
> >                                              |          __napi_poll
> >                                              |          net_rx_action
> >                                              |          __do_softirq
> >                                              |          |
> >                                              |           --5.32%--do_so=
ftirq.part.0
> >                                              |                     __lo=
cal_bh_enable_ip
> >                                              |                     __de=
v_queue_xmit
> >                                              |                     ip_f=
inish_output2
> >                                              |                     __ip=
_finish_output
> >                                              |                     ip_f=
inish_output
> >                                              |                     ip_o=
utput
> >                                              |                     ip_l=
ocal_out
> >                                              |                     __ip=
_queue_xmit
> >                                              |                     ip_q=
ueue_xmit
> >                                              |                     __tc=
p_transmit_skb
> >                                              |                     tcp_=
write_xmit
> >                                              |                     __tc=
p_push_pending_frames
> >                                              |                     tcp_=
push
> >                                              |                     tcp_=
sendmsg_locked
> >                                              |                     tcp_=
sendmsg
> >                                              |                     inet=
_sendmsg
> >                                              |                     sock=
_sendmsg
> >                                              |                     ____=
sys_sendmsg
> >
> >      8.98%  mc-worker        [kernel.vmlinux]          [k] page_counter=
_cancel
> >             |
> >              --8.97%--page_counter_cancel
> >                        |
> >                         --8.97%--page_counter_uncharge
> >                                   drain_stock
> >                                   __refill_stock
> >                                   refill_stock
> >                                   |
> >                                    --8.91%--try_charge_memcg
> >                                              mem_cgroup_charge_skmem
> >                                              |
> >                                               --8.91%--__sk_mem_raise_a=
llocated
> >                                                         __sk_mem_schedu=
le
> >                                                         |
> >                                                         |--5.41%--tcp_t=
ry_rmem_schedule
> >                                                         |          tcp_=
data_queue
> >                                                         |          tcp_=
rcv_established
> >                                                         |          tcp_=
v4_do_rcv
> >                                                         |          tcp_=
v4_rcv
> >                                                         |          ip_p=
rotocol_deliver_rcu
> >                                                         |          ip_l=
ocal_deliver_finish
> >                                                         |          ip_l=
ocal_deliver
> >                                                         |          ip_r=
cv
> >                                                         |          __ne=
tif_receive_skb_one_core
> >                                                         |          __ne=
tif_receive_skb
> >                                                         |          proc=
ess_backlog
> >                                                         |          __na=
pi_poll
> >                                                         |          net_=
rx_action
> >                                                         |          __do=
_softirq
> >                                                         |          do_s=
oftirq.part.0
> >                                                         |          __lo=
cal_bh_enable_ip
> >                                                         |          __de=
v_queue_xmit
> >                                                         |          ip_f=
inish_output2
> >                                                         |          __ip=
_finish_output
> >                                                         |          ip_f=
inish_output
> >                                                         |          ip_o=
utput
> >                                                         |          ip_l=
ocal_out
> >                                                         |          __ip=
_queue_xmit
> >                                                         |          ip_q=
ueue_xmit
> >                                                         |          __tc=
p_transmit_skb
> >                                                         |          tcp_=
write_xmit
> >                                                         |          __tc=
p_push_pending_frames
> >                                                         |          tcp_=
push
> >                                                         |          tcp_=
sendmsg_locked
> >                                                         |          tcp_=
sendmsg
> >                                                         |          inet=
_sendmsg
> >
> >      8.78%  mc-worker        [kernel.vmlinux]          [k] try_charge_m=
emcg
> >             |
> >              --8.77%--try_charge_memcg
> >                        |
> >                         --8.76%--mem_cgroup_charge_skmem
> >                                   |
> >                                    --8.76%--__sk_mem_raise_allocated
> >                                              __sk_mem_schedule
> >                                              |
> >                                              |--5.21%--tcp_try_rmem_sch=
edule
> >                                              |          tcp_data_queue
> >                                              |          tcp_rcv_establi=
shed
> >                                              |          tcp_v4_do_rcv
> >                                              |          |
> >                                              |           --5.21%--tcp_v=
4_rcv
> >                                              |                     ip_p=
rotocol_deliver_rcu
> >                                              |                     ip_l=
ocal_deliver_finish
> >                                              |                     ip_l=
ocal_deliver
> >                                              |                     ip_r=
cv
> >                                              |                     __ne=
tif_receive_skb_one_core
> >                                              |                     __ne=
tif_receive_skb
> >                                              |                     proc=
ess_backlog
> >                                              |                     __na=
pi_poll
> >                                              |                     net_=
rx_action
> >                                              |                     __do=
_softirq
> >                                              |                     |
> >                                              |                      --5=
.21%--do_softirq.part.0
> >                                              |                         =
       __local_bh_enable_ip
> >                                              |                         =
       __dev_queue_xmit
> >                                              |                         =
       ip_finish_output2
> >                                              |                         =
       __ip_finish_output
> >                                              |                         =
       ip_finish_output
> >                                              |                         =
       ip_output
> >                                              |                         =
       ip_local_out
> >                                              |                         =
       __ip_queue_xmit
> >                                              |                         =
       ip_queue_xmit
> >                                              |                         =
       __tcp_transmit_skb
> >                                              |                         =
       tcp_write_xmit
> >                                              |                         =
       __tcp_push_pending_frames
> >                                              |                         =
       tcp_push
> >                                              |                         =
       tcp_sendmsg_locked
> >                                              |                         =
       tcp_sendmsg
> >                                              |                         =
       inet_sendmsg
> >                                              |                         =
       sock_sendmsg
> >                                              |                         =
       ____sys_sendmsg
> >                                              |                         =
       ___sys_sendmsg
> >                                              |                         =
       __sys_sendmsg
> >
> >
> > >
>
>
> I am suspecting we are doing a lot of charging for a specific memcg on
> one CPU (or a set of CPUs) and a lot of uncharging on the different
> CPU (or a different set of CPUs) and thus both of these code paths are
> hitting the slow path a lot.
>
> Eric, I remember we have an optimization in the networking stack that
> tries to free the memory on the same CPU where the allocation
> happened. Is that optimization enabled for this code path? Or maybe we
> should do something similar in memcg code (with the assumption that my
> suspicion is correct).

The suspect part is really:

>      8.98%  mc-worker        [kernel.vmlinux]          [k] page_counter_c=
ancel
>             |
>              --8.97%--page_counter_cancel
>                        |
>                         --8.97%--page_counter_uncharge
>                                   drain_stock
>                                   __refill_stock
>                                   refill_stock
>                                   |
>                                    --8.91%--try_charge_memcg
>                                              mem_cgroup_charge_skmem
>                                              |
>                                               --8.91%--__sk_mem_raise_all=
ocated
>                                                         __sk_mem_schedule

Shakeel, networking has a per-cpu cache, of +/- 1MB.

Even with asymmetric alloc/free, this would mean that a 100Gbit NIC
would require something like 25,000
operations on the shared cache line per second.

Hardly an issue I think.

memcg does not seem to have an equivalent strategy ?

