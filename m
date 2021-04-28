Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E2D36DC4C
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 17:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240646AbhD1PsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 11:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240087AbhD1PsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 11:48:07 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217F1C06134E;
        Wed, 28 Apr 2021 08:44:57 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id p17so5117527pjz.3;
        Wed, 28 Apr 2021 08:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=75u7pQJ9HsbRAtKqRNDEF3hfTjqDp5ygGFcieBSKiXk=;
        b=TIpoRyhlatjydjx5XC547En1pvb4rD59ATJiZIIsCxOv+nJhBL/WP6uHKyjmQCDyiR
         xToOHai1H8K8oZCKtP4YmnWeWhty0xZ9SKrCY5DyYzWetrQj4owmRky0xZPsjq3facdk
         WTUZ/haOwqWz94mJ3Iyf49NPIhTI5lRNHnx7xPERouHBtq7OhKhf/zqZ0omEg/W7pXtr
         8ljrKpQRylrFxk3UXhyj6So26WSzvV+A3nWAUycMKbYNp+3Iz4+yR8qFPwXlRoM/Qebh
         dr8Mn4OKI6EhH0dzJxx5rK+FF3vAHB5/YR3av4FACSl623q3Wu6wdCY28N38mrMCroEI
         cqpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=75u7pQJ9HsbRAtKqRNDEF3hfTjqDp5ygGFcieBSKiXk=;
        b=X9BmX7d+5YLPYNi9kYnFM3c/btMEuhuvzWHrdC4aB+ItyzJsauNvEpxIAKlgYU20hM
         cx8jtqfOrB6jVCixqxbfUEaS+I6CpNcWFMGFUOn2p+cy0yNZv9Ombg7NIlb2r4ngLOLM
         DFN4Mu+vWzSEEmI8LT7Ve4lzNyLR8rC//aA91sm9/rfDMAilCm0ExERL4CUq0NVJpC+E
         pEmFZV6T+gCdBNOE/rJP4FF8JHrdzVpSsGgLtlKIl0i5kRAMuGarPIUsEjN7PduMuJ30
         3CeLBjUmG9G8kvUIU8UTnAGjjTmULpM7nnfmp8Bxr4dz7bIpVaU3O+kdD2qqe0P20SJ4
         3SgQ==
X-Gm-Message-State: AOAM53133LRJtLDIxei5Ch0/wlkjlDMKTAFUKoARK2DSoz6AS1wjYZaS
        FXQafRYWByj/KsgV9h/PqNpc4AqXVjs5wFq1VA==
X-Google-Smtp-Source: ABdhPJyxNARfp0e+a4I243iqTk3Oq88aRawy8yDRlfxGbYeLuOx+4I0nOTJITCAJsVLOUiKxiLGsm6bXfhRywPsdY7c=
X-Received: by 2002:a17:902:9685:b029:e9:abc1:7226 with SMTP id
 n5-20020a1709029685b02900e9abc17226mr31110901plp.64.1619624696670; Wed, 28
 Apr 2021 08:44:56 -0700 (PDT)
MIME-Version: 1.0
References: <CACkBjsYnV3_KkMasd-5GBeTBSqVun+BbPhNn+hyFpwA678mf4A@mail.gmail.com>
 <e1d781fd-886b-3489-7eb0-4cef2a90920c@gmail.com>
In-Reply-To: <e1d781fd-886b-3489-7eb0-4cef2a90920c@gmail.com>
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Wed, 28 Apr 2021 23:44:56 +0800
Message-ID: <CACkBjsbFWjcMEWtsRh3g4VFhOC721EieHKYQJGftdo9yM9PVtg@mail.gmail.com>
Subject: Re: UBSAN: shift-out-of-bounds in __qdisc_calculate_pkt_len
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, xiyou.wangcong@gmail.com,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> =E4=BA=8E2021=E5=B9=B44=E6=9C=8828=E6=
=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=8810:15=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> On 4/28/21 4:53 AM, Hao Sun wrote:
> > Hi
> >
> > When using Healer to fuzz the Linux kernel, UBSAN reported a
> > shift-out-of-bounds bug in net/sched/sch_api.c:580:10.
> >
> > Here are the details:
> > commit:   89698becf06d341a700913c3d89ce2a914af69a2
> > version:   Linux 5.12
> > git tree:    upstream
> > kernel config, reproduction program can be found in the attached file.
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> > UBSAN: shift-out-of-bounds in net/sched/sch_api.c:580:10
> > shift exponent 247 is too large for 32-bit type 'int'
> > CPU: 1 PID: 3176 Comm: kworker/1:2 Not tainted 5.12.0-rc7+ #3
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> > Workqueue: ipv6_addrconf addrconf_dad_work
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:79 [inline]
> >  dump_stack+0xfa/0x151 lib/dump_stack.c:120
> >  ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
> >  __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x20c lib/ubsan.c:327
> >  __qdisc_calculate_pkt_len.cold+0x1b/0xcf net/sched/sch_api.c:580
> >  qdisc_calculate_pkt_len include/net/sch_generic.h:787 [inline]
> >  __dev_xmit_skb net/core/dev.c:3803 [inline]
> >  __dev_queue_xmit+0x13b2/0x3020 net/core/dev.c:4162
> >  neigh_hh_output include/net/neighbour.h:499 [inline]
> >  neigh_output include/net/neighbour.h:508 [inline]
> >  ip_finish_output2+0xf20/0x2240 net/ipv4/ip_output.c:230
> >  __ip_finish_output net/ipv4/ip_output.c:308 [inline]
> >  __ip_finish_output+0x699/0xe20 net/ipv4/ip_output.c:290
> >  ip_finish_output+0x35/0x200 net/ipv4/ip_output.c:318
> >  NF_HOOK_COND include/linux/netfilter.h:290 [inline]
> >  ip_output+0x201/0x610 net/ipv4/ip_output.c:432
> >  dst_output include/net/dst.h:448 [inline]
> >  ip_local_out+0xaf/0x1a0 net/ipv4/ip_output.c:126
> >  iptunnel_xmit+0x618/0x9f0 net/ipv4/ip_tunnel_core.c:82
> >  geneve_xmit_skb drivers/net/geneve.c:967 [inline]
> >  geneve_xmit+0xea7/0x41b0 drivers/net/geneve.c:1075
> >  __netdev_start_xmit include/linux/netdevice.h:4825 [inline]
> >  netdev_start_xmit include/linux/netdevice.h:4839 [inline]
> >  xmit_one net/core/dev.c:3605 [inline]
> >  dev_hard_start_xmit+0x1ff/0x940 net/core/dev.c:3621
> >  __dev_queue_xmit+0x2699/0x3020 net/core/dev.c:4194
> >  neigh_resolve_output net/core/neighbour.c:1491 [inline]
> >  neigh_resolve_output+0x4ee/0x810 net/core/neighbour.c:1471
> >  neigh_output include/net/neighbour.h:510 [inline]
> >  ip6_finish_output2+0xd09/0x21f0 net/ipv6/ip6_output.c:117
> >  __ip6_finish_output+0x4bb/0xe10 net/ipv6/ip6_output.c:182
> >  ip6_finish_output+0x35/0x200 net/ipv6/ip6_output.c:192
> >  NF_HOOK_COND include/linux/netfilter.h:290 [inline]
> >  ip6_output+0x242/0x810 net/ipv6/ip6_output.c:215
> >  dst_output include/net/dst.h:448 [inline]
> >  NF_HOOK include/linux/netfilter.h:301 [inline]
> >  ndisc_send_skb+0xf52/0x14c0 net/ipv6/ndisc.c:508
> >  ndisc_send_ns+0x3a9/0x840 net/ipv6/ndisc.c:650
> >  addrconf_dad_work+0xd29/0x1380 net/ipv6/addrconf.c:4119
> >  process_one_work+0x9ad/0x1620 kernel/workqueue.c:2275
> >  worker_thread+0x96/0xe20 kernel/workqueue.c:2421
> >  kthread+0x374/0x490 kernel/kthread.c:292
> >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> >
>
> Can you submit a patch ?

The following modifications should have fixed this problem, and I
tested it on the latest kernel (upstream).
Do you mean I should send an formal patch? If so, I'd be happy to do so.

>
> We are at a point that we are flooded with such report. (look at syzbot q=
ueue for instance)
>
> We prefer having formal patches, and as a bonus you will be a famous linu=
x contributor.
>
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index f87d07736a1404edcfd17a792321758cd4bdd173..265289da7e84e4a408428767a=
57f82c00fd85b7f 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -504,6 +504,11 @@ static struct qdisc_size_table *qdisc_get_stab(struc=
t nlattr *opt,
>                 return ERR_PTR(-EINVAL);
>         }
>
> +       if (s->cell_log >=3D 32 || s->size_log >=3D 32) {
> +               NL_SET_ERR_MSG(extack, "Invalid cell_log/size_log of size=
 table");
> +               return ERR_PTR(-EINVAL);
> +       }
> +
>         list_for_each_entry(stab, &qdisc_stab_list, list) {
>                 if (memcmp(&stab->szopts, s, sizeof(*s)))
>                         continue;
>
>
>
>
>
