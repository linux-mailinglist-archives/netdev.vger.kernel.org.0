Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8D0470784
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241539AbhLJRmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238612AbhLJRmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 12:42:08 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608B4C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:38:33 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id e3so32924533edu.4
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r1TEcttao870SrnIicEigLO42+hcfR0TeBILkFKia7Y=;
        b=CboLVXP61BcjnVlVdqz9HlC+G+qQbOOK29GAI2MsticWmll2r3p3ODnYgo9GhFKFdK
         kXUSmTVedjzEkmv8LdxrKVLxiCTGvesTCHvrdN2TSTG3BjR0SNGHKtrgt4Rqdhmekw7W
         r7N8vmuE2ASFT3QfcbthXK+3S9g8KmXmVJrL8BM3la8PzoO0YE+lndAv2NwMwdz1Sj0Y
         sgVrfNDSoPstYhpVARaqCehlj5aouMxu9soPxGsSlVXj6aILw5IRS5LCK/a6j/ahBfFK
         mtdtGtY70jdd1y0DsFGt17jr+IHHt65Gv2jgrfY0JuRY7apgKyNDe3+7Uq4z0260E+kX
         5BkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r1TEcttao870SrnIicEigLO42+hcfR0TeBILkFKia7Y=;
        b=3BAsAMGDxnIcgZfOynq2imYdR1SP5TULksygtoHTvEc/O4k7tLCp7JxTibBuNJDCcA
         0fmRwRAspzMwm7SCx0lHOLKUZ7kC2+mmitBochvv2FzmMityVgILmM21Arbu9GcmT9bb
         3jycYgS4VCn/4UZc+CDbK9PPh+CkzzwKzKyWcQJMpWzyspTjU/AE83obruN64RWbzMyO
         Ww7bj7+u3MQHr7evx28h3Fldkzf9Mc0SmHE1JFXmFJKrE8lM2nMjuBPliNiKE7eEVFBM
         l+PR1bmeJsTAeJHJi2BtRJtGk+aSp0vD8YFHYnYmIxtJAQrKUth3aW5F1eIUGADOxDIp
         I/Aw==
X-Gm-Message-State: AOAM530h+a4EiPOkIlukxVJ2vvFmB2zOo0pvHkoowwqzfSldj48ZUwkA
        jkDnUlXJHpFCh/nMxa5BR7LUOzWEbJvHzHv6vBc=
X-Google-Smtp-Source: ABdhPJy3tAn00zTOJfEvNbSI+YgkApSEEj6rzUNLc50sjJnuFQXf3zF7RtA7bwNJ1RG5ErLCDUkr5xumbBWnlFp0wyg=
X-Received: by 2002:a05:6402:405:: with SMTP id q5mr40555005edv.62.1639157911956;
 Fri, 10 Dec 2021 09:38:31 -0800 (PST)
MIME-Version: 1.0
References: <20211208145459.9590-1-xiangxia.m.yue@gmail.com>
 <20211208145459.9590-3-xiangxia.m.yue@gmail.com> <61b383c6373ca_1f50e20816@john.notmuch>
In-Reply-To: <61b383c6373ca_1f50e20816@john.notmuch>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Sat, 11 Dec 2021 01:37:55 +0800
Message-ID: <CAMDZJNV3-y5jkUAJJ--10PcicKpGMwKS_3gG9O7srjomO3begw@mail.gmail.com>
Subject: Re: [net v5 2/3] net: sched: add check tc_skip_classify in sch egress
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 12:43 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> xiangxia.m.yue@ wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > Try to resolve the issues as below:
> > * We look up and then check tc_skip_classify flag in net
> >   sched layer, even though skb don't want to be classified.
> >   That case may consume a lot of cpu cycles. This patch
> >   is useful when there are a lot of filters with different
> >   prio. There is ~5 prio in in production, ~1% improvement.
> >
> >   Rules as below:
> >   $ for id in $(seq 1 5); do
> >   $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
> >   $ done
> >
> > * bpf_redirect may be invoked in egress path. If we don't
> >   check the flags and then return immediately, the packets
> >   will loopback.
>
> This would be the naive case right? Meaning the BPF program is
> doing a redirect without any logic or is buggy?
>
> Can you map out how this happens for me, I'm not fully sure I
> understand the exact concern. Is it possible for BPF programs
> that used to see packets no longer see the packet as expected?
>
> Is this the path you are talking about?
Hi John
Tx ethx -> __dev_queue_xmit -> sch_handle_egress
->  execute BPF program on ethx with bpf_redirect(ifb0) ->
-> ifb_xmit -> ifb_ri_tasklet -> dev_queue_xmit -> __dev_queue_xmit
the packets loopbacks, that means bpf_redirect doesn't work with ifb
netdev, right ?
so in sch_handle_egress, I add the check skb_skip_tc_classify().

>  rx ethx  ->
>    execute BPF program on ethx with bpf_redirect(ifb0) ->
>      __skb_dequeue @ifb tc_skip_classify = 1 ->
>        dev_queue_xmit() ->
>           sch_handle_egress() ->
>             execute BPF program again
>
> I can't see why you want to skip that second tc BPF program,
> or for that matter any tc filter there. In general how do you
> know that is the correct/expected behavior? Before the above
> change it would have been called, what if its doing useful
> work.
bpf_redirect works fine on ingress with ifb
__netif_receive_skb_core -> sch_handle_ingress -> bpf_redirect (ifb0)
-> ifb_xmit -> netif_receive_skb -> __netif_receive_skb_core
but
__netif_receive_skb_core --> skb_skip_tc_classify(so the packets will
execute the BPF progam again)

> Also its not clear how your ifb setup is built or used. That
> might help understand your use case. I would just remove the
> IFB altogether and the above discussion is mute.
tc filter add dev veth1 egress bpf direct-action obj
test_bpf_redirect_ifb.o sec redirect_ifb

the test_bpf_redirect_ifb  bpf progam:
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 DiDi Global */
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+SEC("redirect_ifb")
+int redirect(struct __sk_buff *skb)
+{
+       return bpf_redirect(skb->ifindex + 1 /* ifbX */, 0);
+}
+
+char __license[] SEC("license") = "GPL";

The 3/3 is selftest:
https://patchwork.kernel.org/project/netdevbpf/patch/20211208145459.9590-4-xiangxia.m.yue@gmail.com/

> Thanks,
> John



-- 
Best regards, Tonghao
