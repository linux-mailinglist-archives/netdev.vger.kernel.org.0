Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48624B13CF
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238706AbiBJREN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:04:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235641AbiBJREJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:04:09 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6598C10
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:04:09 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id g14so17327385ybs.8
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9lvQ6J3Nqi+1fVp77BLAwCQzDaedev0AzDXPeGFkuGI=;
        b=OBwueU59zGw141a5MIaVwOnqDF9rBhL1LPTLnDLil22Ozk+hVrHfUqIw8MU9kTe4zo
         UUYhXlMN/4mcQwP/h2nRRXwB4Z+axnwfS3yvm8z4wyGdyaSJRQPHVWnQQBG4WQuspCNr
         EyWKeZCdIu/6+U6bJ0HcHPxxVwjdBmy4/eiPs6znGWyzhbt+qBAYo+F4GoI5rwDhC9uz
         eAJeBJZtdzsm8Fv3VU92H66AbU3bCDqvdxJypnMgAfO7C+QM2TK7JBxe2bO4y9Len9Q+
         PWvmtj5fVLb2Xi9hs6Wkr+k/yURV1kKlmjxR7l71zfSO5+4FSkfdi+YkEHiI6e1NIsrZ
         9KzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9lvQ6J3Nqi+1fVp77BLAwCQzDaedev0AzDXPeGFkuGI=;
        b=5ff1RKadNX10X5By/fKsnblNmIXcNcKX3FEMfmPjhJX85TLmawQ7e692zfCfV1QUl5
         FxI7D8QRXqYwDDaAwH/scg9Ihz/WzktkTa8pSkeIMMGjXvmyBSw19x3dckImXloir2pC
         DyWUrZfKPs25iWTuJlH89FrCDFAS9/S7Bo0sDnwY5gW94jN4Tbf3CTtloyDl360/Hzy2
         HQYxq6/MHU5SY1d/qO8cwiMZfeSM0ZDrcIQRNNAB/LmwsbS67yhYvap+sDb8x9isF3w0
         mtbkv7DQjCX2B+ZXuplZiodHXn2vHTK2xjG8xwjtVeMgfLAxxhWJa2PinJFnTjDA+PAQ
         ObSA==
X-Gm-Message-State: AOAM531pBHzZwQ+IKJgxh7+eK1C6xlUIWvBIKIAFzWsqo82tkmMXfEMI
        KcpZgRtlVfEOoRsSR1lFdNNUBLLICHf95Dxa0fI=
X-Google-Smtp-Source: ABdhPJx7s5S8B0OG06HOp0CQZPCDTpx3yUC/8XJMrRS84IJuNYGcdXbxmqM7W94KL1fi7ky9zxLYNh7lbZQYPQRFdEU=
X-Received: by 2002:a81:387:: with SMTP id 129mr8263250ywd.252.1644512648858;
 Thu, 10 Feb 2022 09:04:08 -0800 (PST)
MIME-Version: 1.0
References: <20220210154912.5803-1-claudiajkang@gmail.com> <20220210161216.jc5hydc2sb5nyamo@skbuf>
In-Reply-To: <20220210161216.jc5hydc2sb5nyamo@skbuf>
From:   Juhee Kang <claudiajkang@gmail.com>
Date:   Fri, 11 Feb 2022 02:03:33 +0900
Message-ID: <CAK+SQuT1BOgEFGmDnFL5==n9RLUKiv9u2d9aMDibAY6khqtktg@mail.gmail.com>
Subject: Re: [PATCH net] net: hsr: fix suspicious usage in hsr_node_get_first
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, ennoerlangen@gmail.com,
        george.mccollister@gmail.com, marco.wenzel@a-eberle.de,
        xiong.zhenwu@zte.com.cn,
        syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 1:12 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Thu, Feb 10, 2022 at 03:49:12PM +0000, Juhee Kang wrote:
> > Currently, to dereference hlist_node which is result of hlist_first_rcu(),
> > rcu_dereference() is used. But, suspicious RCU warnings occur because
> > the caller doesn't acquire RCU. So it was solved by adding rcu_read_lock().
> >
> > The kernel test robot reports:
> >     [   53.750001][ T3597] =============================
> >     [   53.754849][ T3597] WARNING: suspicious RCU usage
> >     [   53.759833][ T3597] 5.17.0-rc2-syzkaller-00903-g45230829827b #0 Not tainted
> >     [   53.766947][ T3597] -----------------------------
> >     [   53.771840][ T3597] net/hsr/hsr_framereg.c:34 suspicious rcu_dereference_check() usage!
> >     [   53.780129][ T3597] other info that might help us debug this:
> >     [   53.790594][ T3597] rcu_scheduler_active = 2, debug_locks = 1
> >     [   53.798896][ T3597] 2 locks held by syz-executor.0/3597:
> >
> > Fixes: 4acc45db7115 ("net: hsr: use hlist_head instead of list_head for mac addresses")
> > Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> > Reported-by: syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com
> > Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
> > ---
> >  net/hsr/hsr_framereg.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
> > index b3c6ffa1894d..92abdf855327 100644
> > --- a/net/hsr/hsr_framereg.c
> > +++ b/net/hsr/hsr_framereg.c
> > @@ -31,7 +31,10 @@ struct hsr_node *hsr_node_get_first(struct hlist_head *head)
> >  {
> >       struct hlist_node *first;
> >
> > +     rcu_read_lock();
> >       first = rcu_dereference(hlist_first_rcu(head));
> > +     rcu_read_unlock();
>
> Why wasn't this an issue when when hsr_node_get_first() was just list_first_or_null_rcu()?
> Full stack trace please?
>
> I am not familiar with the hsr code base, but I don't need more context
> than given to realize that this isn't the proper solution. You aren't
> really "fixing" anything if you exit the RCU critical section but still
> use "first" afterwards. The driver probably needs some proper accessors
> from the writer side, with
> rcu_dereference_protected(..., lockdep_is_held(&hsr->list_lock));
>
> > +
> >       if (first)
> >               return hlist_entry(first, struct hsr_node, mac_list);
> >
> > --
> > 2.25.1
> >

Hi Vladimir,
Thank you for your review!

Sorry, I sent the patch on the wrong target(net). This patch is based
on net-next. Actually, in the current net git, there wasn't an issue
related to hsr_node_get_first().
So I already sent the v2 patch on net-next. If you want to follow up
on this patch, could you check the v2 patch?

And this is full stack trace.

[   53.824741][ T3597] stack backtrace:
[   53.831045][ T3597] CPU: 1 PID: 3597 Comm: syz-executor.0 Not
tainted 5.17.0-rc2-syzkaller-00903-g45230829827b #0
[   53.842052][ T3597] Hardware name: Google Google Compute
Engine/Google Compute Engine, BIOS Google 01/01/2011
[   53.852279][ T3597] Call Trace:
[   53.855582][ T3597]  <TASK>
[   53.859043][ T3597]  dump_stack_lvl+0xcd/0x134
[   53.863632][ T3597]  hsr_node_get_first+0x9b/0xb0
[   53.868507][ T3597]  hsr_create_self_node+0x22d/0x650
[   53.874156][ T3597]  hsr_dev_finalize+0x2c1/0x7d0
[   53.879012][ T3597]  hsr_newlink+0x315/0x730
[   53.883496][ T3597]  ? hsr_dellink+0x130/0x130
[   53.888098][ T3597]  ? rtnl_create_link+0x7e8/0xc00
[   53.893268][ T3597]  ? hsr_dellink+0x130/0x130
[   53.897949][ T3597]  __rtnl_newlink+0x107c/0x1760
[   53.902867][ T3597]  ? rtnl_setlink+0x3c0/0x3c0
[   53.907741][ T3597]  ? is_bpf_text_address+0x77/0x170
[   53.913136][ T3597]  ? lock_downgrade+0x6e0/0x6e0
[   53.918254][ T3597]  ? unwind_next_frame+0xee1/0x1ce0
[   53.924612][ T3597]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
[   53.930943][ T3597]  ? __sanitizer_cov_trace_cmp4+0x1c/0x70
[   53.936837][ T3597]  ? is_bpf_text_address+0x99/0x170
[   53.942177][ T3597]  ? kernel_text_address+0x39/0x80
[   53.948179][ T3597]  ? __kernel_text_address+0x9/0x30
[   53.953416][ T3597]  ? unwind_get_return_address+0x51/0x90
[   53.959065][ T3597]  ? create_prof_cpu_mask+0x20/0x20
[   53.964356][ T3597]  ? arch_stack_walk+0x93/0xe0
[   53.969254][ T3597]  ? rcu_read_lock_sched_held+0x3a/0x70
[   53.974790][ T3597]  rtnl_newlink+0x64/0xa0
[   53.979161][ T3597]  ? __rtnl_newlink+0x1760/0x1760
[   53.984388][ T3597]  rtnetlink_rcv_msg+0x413/0xb80
[   53.989414][ T3597]  ? rtnl_newlink+0xa0/0xa0
[   53.994007][ T3597]  netlink_rcv_skb+0x153/0x420
[   53.998862][ T3597]  ? rtnl_newlink+0xa0/0xa0
[   54.003885][ T3597]  ? netlink_ack+0xa60/0xa60
[   54.008560][ T3597]  ? netlink_deliver_tap+0x1a2/0xc40
[   54.013948][ T3597]  ? netlink_deliver_tap+0x1b1/0xc40
[   54.020086][ T3597]  netlink_unicast+0x539/0x7e0
[   54.024854][ T3597]  ? netlink_attachskb+0x880/0x880
[   54.029974][ T3597]  ? __sanitizer_cov_trace_const_cmp8+0x1d/0x70
[   54.038078][ T3597]  ? __sanitizer_cov_trace_const_cmp8+0x1d/0x70
[   54.044448][ T3597]  ? __phys_addr_symbol+0x2c/0x70
[   54.049828][ T3597]  ? __sanitizer_cov_trace_cmp8+0x1d/0x70
[   54.055806][ T3597]  ? __check_object_size+0x16e/0x310
[   54.061758][ T3597]  netlink_sendmsg+0x904/0xe00
[   54.066541][ T3597]  ? netlink_unicast+0x7e0/0x7e0
[   54.071771][ T3597]  ? __sanitizer_cov_trace_const_cmp4+0x1c/0x70
[   54.078289][ T3597]  ? netlink_unicast+0x7e0/0x7e0
[   54.083308][ T3597]  sock_sendmsg+0xcf/0x120
[   54.087826][ T3597]  __sys_sendto+0x21c/0x320
[   54.092332][ T3597]  ? __ia32_sys_getpeername+0xb0/0xb0
[   54.097791][ T3597]  ? lockdep_hardirqs_on_prepare+0x400/0x400
[   54.103814][ T3597]  ? __context_tracking_exit+0xb8/0xe0
[   54.109388][ T3597]  ? lock_downgrade+0x6e0/0x6e0
[   54.114437][ T3597]  ? lock_downgrade+0x6e0/0x6e0
[   54.119465][ T3597]  __x64_sys_sendto+0xdd/0x1b0
[   54.124329][ T3597]  ? lockdep_hardirqs_on+0x79/0x100
[   54.129615][ T3597]  ? syscall_enter_from_user_mode+0x21/0x70
[   54.135504][ T3597]  do_syscall_64+0x35/0xb0
[   54.139936][ T3597]  entry_SYSCALL_64_after_hwframe+0x44/0xae


-- 

Best regards,
Juhee Kang
