Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2B9643BD8
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 04:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbiLFDVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 22:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbiLFDVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 22:21:45 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DB62611A
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 19:21:43 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id n184so16806063yba.6
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 19:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=L0rThEAGpgTOyn17zGhI/zm1G/vnQGsdtcnyo/9H9BA=;
        b=nNZc+wIjDrFq8+W5tMuzccBqAOZsun3xycLU00kiE/tUDoF6VUGJhkvDZRi4FgaNO4
         EbnvDBzUBRmL6SEnejnlh89ho4B6nr9Vj3z1fbgAq9Lz6Y2OE8gwyRHD/RJBSO3/C8GE
         Aawh77F5YTX/M2BWfLyZ/kKDVrwx1G8tqWSORrWpj/nT6rMStGG4pNoG2w2GtpYy9v2y
         YG2x4djqMD+6so3fckQIjLBLPpjFatwpp4cV73l2sjF0JERBpRBL7LzMTIYgQBY4GWgJ
         +u8HsPIt0f0chuvxry5bc1JVQGDopoAtjHEp6H09etyXgf/ptETXXO8ZK2xMTiSVyvZ+
         JwXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L0rThEAGpgTOyn17zGhI/zm1G/vnQGsdtcnyo/9H9BA=;
        b=PWXenR8kN47dtfZnCbcjaxUXLA8e0PIpJA1AWdvao/W7uCs5j5G2Dt9gxNo2jZM1u8
         ZCB0gZSi+7yDELny+P3u15hagsr+Q8p+lWsvN8jfa8E8fmHtsm7fKbDtb6NllYkkmsuw
         ClVAFx/BW8S8wmenWs1gRq3Ov1BFvFIfRvckyZBfw79rgLwQt6DQd0FNIrhgMlK4DhVM
         obaBLnUAeZ2YyUG9ViBNGkn4KfCSJzQoJFWRJKlE8qMM1U0fVegc1C6nW+DQkBmpZNaG
         NdczZ1Y3ouM/88Fktg+u0qG46cERlcufgcoWyrWqEXhZMdyQKxLO0JuwtVqVCEpgxQgk
         3+eg==
X-Gm-Message-State: ANoB5pmqdUmwdHZbMsIRlhbjjG3Rc0eprz4UO6xkeh12AEa2Ep5XruDS
        hGkOcGQhcJZNLBYxO0eJaPbgGFjhV0pxi/NXUjSKDZCLrt4NmA==
X-Google-Smtp-Source: AA0mqf62+7uNMlNgurIXTWE7Zz21Vi6swSdHe74CT0hwHyy/bY8WqsERd6t7hN//zfEZvRKcaqI33O+x5RXPdyKk12I=
X-Received: by 2002:a25:d197:0:b0:703:4bfd:3986 with SMTP id
 i145-20020a25d197000000b007034bfd3986mr1052241ybg.407.1670296902643; Mon, 05
 Dec 2022 19:21:42 -0800 (PST)
MIME-Version: 1.0
References: <1669817512-4560-1-git-send-email-george.kennedy@oracle.com>
 <CALs4sv2ZfT1SAYY0oOYhrBBCjsG_th5g=QtSsbKJnPbW8faQ+w@mail.gmail.com>
 <CANn89iL9obgd==tdp9DgdxXk78UvzF6D4J1OeihB1kx9_U4oZw@mail.gmail.com>
 <99adf483-ae89-8010-4689-fd50a77ff023@oracle.com> <CANn89iL18gPus7YWMMX_UFg9PSxAv0SkWTjLYCPhncOCEKrWuQ@mail.gmail.com>
 <ae736328-56de-7985-8a9a-0279a123544f@oracle.com>
In-Reply-To: <ae736328-56de-7985-8a9a-0279a123544f@oracle.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 6 Dec 2022 04:21:31 +0100
Message-ID: <CANn89iKsGrTw31_yQ8DqdFeDYG0OABUKuWd5i9t+HbwAS7ZbsQ@mail.gmail.com>
Subject: Re: [PATCH] net: check for dev pointer being NULL in
 dev_hard_header() to avoid GPF
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     Pavan Chebbi <pavan.chebbi@broadcom.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        harshit.m.mogalapalli@oracle.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 6, 2022 at 2:11 AM George Kennedy <george.kennedy@oracle.com> wrote:
>
> Hi Eric,
>
> More info...
>
> On 12/1/2022 11:11 PM, Eric Dumazet wrote:
> > On Thu, Dec 1, 2022 at 9:44 PM George Kennedy <george.kennedy@oracle.com> wrote:
> >>
> >>
> >> On 12/1/2022 2:25 PM, Eric Dumazet wrote:
> >>> On Thu, Dec 1, 2022 at 2:16 PM Pavan Chebbi <pavan.chebbi@broadcom.com> wrote:
> >>>> On Wed, Nov 30, 2022 at 7:43 PM George Kennedy
> >>>> <george.kennedy@oracle.com> wrote:
> >>>>> The dev pointer can be NULL in dev_hard_header(). Add check for dev being
> >>>>> NULL in dev_hard_header() to avoid GPF.
> >>>>>
> >>>>> general protection fault, probably for non-canonical address
> >>>>>       0xdffffc0000000046: 0000 [#1] PREEMPT SMP KASAN NOPTI
> >>>>> KASAN: null-ptr-deref in range [0x0000000000000230-0x0000000000000237]
> >>>>> CPU: 1 PID: 45 Comm: kworker/1:1 Not tainted 6.1.0-rc7+ #2
> >>>>> Hardware name: Red Hat KVM, BIOS 1.15.0-2.module+el8.6.0+20659+3dcf7c70
> >>>>> Workqueue: mld mld_ifc_work
> >>>>> RIP: 0010:macvlan_hard_header (./include/linux/netdevice.h:3057
> >>>>>       (discriminator 4) drivers/net/macvlan.c:594 (discriminator 4))
> >>>>> RSP: 0018:ffff888103d377d0 EFLAGS: 00010212
> >>>>> RAX: dffffc0000000000 RBX: ffff88801cf1a000 RCX: 0000000000000000
> >>>>> RDX: 0000000000000046 RSI: 0000000000000000 RDI: 0000000000000230
> >>>>> RBP: ffff88801e8ef328 R08: 0000000000000000 R09: 0000000000000060
> >>>>> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88801f0497c0
> >>>>> R13: 0000000000000000 R14: ffff888045187c98 R15: 0000000000000060
> >>>>> FS:  0000000000000000(0000) GS:ffff888106c80000(0000)
> >>>>>       knlGS:0000000000000000
> >>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>>>> CR2: 00007fbf3f1c1840 CR3: 0000000014e36000 CR4: 00000000000006e0
> >>>>> Call Trace:
> >>>>>    <TASK>
> >>>>> neigh_connected_output (./include/linux/netdevice.h:3060
> >>>>>       net/core/neighbour.c:1595)
> >>>>> ip6_finish_output2 (./include/net/neighbour.h:546
> >>>>>       net/ipv6/ip6_output.c:134)
> >>>>> ip6_finish_output (net/ipv6/ip6_output.c:195 net/ipv6/ip6_output.c:206)
> >>>>> ip6_output (./include/linux/netfilter.h:291 net/ipv6/ip6_output.c:227)
> >>>>> NF_HOOK.constprop.0 (./include/net/dst.h:445
> >>>>>       ./include/linux/netfilter.h:302)
> >>>>> mld_sendpack (net/ipv6/mcast.c:1824)
> >>>>> mld_send_cr (net/ipv6/mcast.c:2122)
> >>>>> mld_ifc_work (net/ipv6/mcast.c:2655)
> >>>>> process_one_work (kernel/workqueue.c:2294)
> >>>>> worker_thread (./include/linux/list.h:292 kernel/workqueue.c:2437)
> >>>>> kthread (kernel/kthread.c:376)
> >>>>> ret_from_fork (arch/x86/entry/entry_64.S:312)
> >>>>>    </TASK>
> >>>>> Modules linked in:
> >>>>> Dumping ftrace buffer:
> >>>>>      (ftrace buffer empty)
> >>>>> ---[ end trace 0000000000000000 ]---
> >>>>>
> >>>>> Fixes: 0c4e85813d0a ("[NET]: Wrap netdevice hardware header creation.")
> >>>>> Reported-by: syzkaller <syzkaller@googlegroups.com>
> >>>>> Signed-off-by: George Kennedy <george.kennedy@oracle.com>
> >>>>> ---
> >>>>>    include/linux/netdevice.h | 2 +-
> >>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>>
> >>>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> >>>>> index eddf8ee270e7..9b25a6301fa5 100644
> >>>>> --- a/include/linux/netdevice.h
> >>>>> +++ b/include/linux/netdevice.h
> >>>>> @@ -3054,7 +3054,7 @@ static inline int dev_hard_header(struct sk_buff *skb, struct net_device *dev,
> >>>>>                                     const void *daddr, const void *saddr,
> >>>>>                                     unsigned int len)
> >>>>>    {
> >>>>> -       if (!dev->header_ops || !dev->header_ops->create)
> >>>>> +       if (!dev || !dev->header_ops || !dev->header_ops->create)
> >>> Do  you have a repro ?
> >> See syzkaller repros attached.
> >>
> >>> This patch will not prevent a crash later I think.
> >> The repro ran overnight without failure with the patch applied.
> > Yes, but the patch is hiding a potential bug that might show up with
> > other 'repros'
> The repro fails when these devices are configured (seem like small mtu):
>
> 20: vxcan0@vxcan1: <NOARP,UP,LOWER_UP> mtu 72 qdisc noqueue state UP group default qlen 1000
>      link/can
>      inet 172.20.20.38/24 scope global vxcan0
>         valid_lft forever preferred_lft forever
> 21: vxcan1@vxcan0: <NOARP,UP,LOWER_UP> mtu 72 qdisc noqueue state UP group default qlen 1000
>      link/can
>      inet 172.20.20.39/24 scope global vxcan1
>         valid_lft forever preferred_lft forever
>
>
> # diff ../config.fail .config
> 3325c3325
> < CONFIG_CAN_VXCAN=y
> ---
> > # CONFIG_CAN_VXCAN is not set
>
> Thanks,
> George

Small MTU has caused numerous issues in the past.

I am pretty sure we miss some READ_ONCE(dev->mtu) and other safety checks.
