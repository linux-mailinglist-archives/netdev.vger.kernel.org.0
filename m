Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED0A3E50CD
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 03:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237279AbhHJB6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 21:58:33 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:40042
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233996AbhHJB6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 21:58:32 -0400
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 7BFF83F10F
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 01:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628560688;
        bh=wDvk7hS2vC0Ko5lDE0tYhcGzdcZyfo0vPTPLB4iBAAQ=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=KBSkRbJuneJVf6no5tsPuFl5b0YTB5DYohXNLktxlGlHNKf6fv3qhjk9aDdeY4Qj4
         Jz5SxlZRJz0V+rTSS/lMM97PTvk4dmUJL3X5l8cF+USdbgrB/RsllbIivuz2CleWnZ
         RruHqFWzysTqEByJgTSFYs0wOcfG6DtFUHnN+mBLIdYHH0uUneUdzUgPBTbu2j4pUE
         +jxgOT3K+WzBF3wSxOwGipwz7lrQPaX0B+PGPrJ4WD5kOV8ytfkoNJPt8THuBqvb1P
         dwFaKD3JQJHy9WjagA6KwgFUfrjhs/n0KN+R7xsV6FpNgN4iKZYUTAj0YxtkLfSkK1
         XhRlYNFoGEK4g==
Received: by mail-ej1-f71.google.com with SMTP id ja25-20020a1709079899b02905b2a2bf1a62so1047900ejc.4
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 18:58:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wDvk7hS2vC0Ko5lDE0tYhcGzdcZyfo0vPTPLB4iBAAQ=;
        b=FdZIWdjGhvRu4SRPRQ53sabl1rZfImSG7UgunCJkQfdpTyZJpEGcMwenpGjwKjiY42
         VESWeEgCps4Xt3lTkjr3rkaEMqtfXfO9eJ8zCOmAcVKhhlyIbabyQ7a6px7DqtwsxYEr
         4ft4IQTObrdkg5zdvWnRyqMcTAhcE3QOVTDjvPBF/lrw2DfOw0TE6VW36JaAk+KtX0DN
         2OK/UQl+Kc9PtBpHpQW8IdRXrkYroXroVTjyITO31s5OSlpm+r7fRf/3qCAB1IWiVmco
         h7NQOBbc+GzjEzCy0cYNz9VlpPdAm7yo6bqw61I0bK8ZIFVqqk0zqZlKYR8SCN/S+dSQ
         qdmg==
X-Gm-Message-State: AOAM532v5WRy/WEk7KRp3o4gAWdb3r4k6nLK+1IDyg0Lh518eXyAMmQC
        0IsxIOb+oi2Ng7ImlzD7/X6aHOVRqT627zuBjqlYpEA8XbGdiJIfWNEH4iaGd1sJUrPvxVe7xeY
        t0X7YAPFY91Di9ENsW1SxDFbo4xKNty4DtiPDZlPlxf6DRHezLw==
X-Received: by 2002:a17:906:76d8:: with SMTP id q24mr25354317ejn.22.1628560688268;
        Mon, 09 Aug 2021 18:58:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgPpQQvYWabrwLzRNdDEE/qBeTIccMjZQ6kbOh9PK708tVhxYducZG+feHVgvZ0VpgPPmXbPGb/lc4/AE5fMA=
X-Received: by 2002:a17:906:76d8:: with SMTP id q24mr25354299ejn.22.1628560688093;
 Mon, 09 Aug 2021 18:58:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210809032809.1224002-1-acelan.kao@canonical.com> <YRDCcDZGVkCdNF34@unreal>
In-Reply-To: <YRDCcDZGVkCdNF34@unreal>
From:   AceLan Kao <acelan.kao@canonical.com>
Date:   Tue, 10 Aug 2021 09:57:57 +0800
Message-ID: <CAFv23Qn=c_EZNPxu90s0n-HB6_vQCqaUG34YAq7-T6Np+10ZUA@mail.gmail.com>
Subject: Re: [RESEND][PATCH] net: called rtnl_unlock() before runpm resumes devices
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leon Romanovsky <leon@kernel.org> =E6=96=BC 2021=E5=B9=B48=E6=9C=889=E6=97=
=A5 =E9=80=B1=E4=B8=80 =E4=B8=8B=E5=8D=881:51=E5=AF=AB=E9=81=93=EF=BC=9A
>
> On Mon, Aug 09, 2021 at 11:28:09AM +0800, AceLan Kao wrote:
> > From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
> >
> > The rtnl_lock() has been called in rtnetlink_rcv_msg(), and then in
> > __dev_open() it calls pm_runtime_resume() to resume devices, and in
> > some devices' resume function(igb_resum,igc_resume) they calls rtnl_loc=
k()
> > again. That leads to a recursive lock.
> >
> > It should leave the devices' resume function to decide if they need to
> > call rtnl_lock()/rtnl_unlock(),
>
> Why? It doesn't sound right that drivers internally decide if to take or
> release some external to them lock without seeing full picture.
From what I observed, this is the only calling path that acquired
rtnl_lock() before calling drivers' resume function.
So, it encounters recursive lock while driver is going to cal rtnl_lock() a=
gain.

>
> Most of the time, device driver authors do it wrong. I afraid that igs
> is one of such drivers that did it wrong.
The issues could be if we remove rtnl_lock in device drivers, then in
other calling path, it won't be protected by the rtnl lock,
and maybe we shouldn't call pm_runtime_resume() here(within rtnl
lock), for device drivers don't know if they are protected by the rtnl
lock while their resume() got called.

>
> Thanks
>
> > so call rtnl_unlock() before calling pm_runtime_resume() and then call
> > rtnl_lock() after it in __dev_open().
> >
> > [  967.723577] INFO: task ip:6024 blocked for more than 120 seconds.
> > [  967.723588]       Not tainted 5.12.0-rc3+ #1
> > [  967.723592] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les this message.
> > [  967.723594] task:ip              state:D stack:    0 pid: 6024 ppid:=
  5957 flags:0x00004000
> > [  967.723603] Call Trace:
> > [  967.723610]  __schedule+0x2de/0x890
> > [  967.723623]  schedule+0x4f/0xc0
> > [  967.723629]  schedule_preempt_disabled+0xe/0x10
> > [  967.723636]  __mutex_lock.isra.0+0x190/0x510
> > [  967.723644]  __mutex_lock_slowpath+0x13/0x20
> > [  967.723651]  mutex_lock+0x32/0x40
> > [  967.723657]  rtnl_lock+0x15/0x20
> > [  967.723665]  igb_resume+0xee/0x1d0 [igb]
> > [  967.723687]  ? pci_pm_default_resume+0x30/0x30
> > [  967.723696]  igb_runtime_resume+0xe/0x10 [igb]
> > [  967.723713]  pci_pm_runtime_resume+0x74/0x90
> > [  967.723718]  __rpm_callback+0x53/0x1c0
> > [  967.723725]  rpm_callback+0x57/0x80
> > [  967.723730]  ? pci_pm_default_resume+0x30/0x30
> > [  967.723735]  rpm_resume+0x547/0x760
> > [  967.723740]  __pm_runtime_resume+0x52/0x80
> > [  967.723745]  __dev_open+0x56/0x160
> > [  967.723753]  ? _raw_spin_unlock_bh+0x1e/0x20
> > [  967.723758]  __dev_change_flags+0x188/0x1e0
> > [  967.723766]  dev_change_flags+0x26/0x60
> > [  967.723773]  do_setlink+0x723/0x10b0
> > [  967.723782]  ? __nla_validate_parse+0x5b/0xb80
> > [  967.723792]  __rtnl_newlink+0x594/0xa00
> > [  967.723800]  ? nla_put_ifalias+0x38/0xa0
> > [  967.723807]  ? __nla_reserve+0x41/0x50
> > [  967.723813]  ? __nla_reserve+0x41/0x50
> > [  967.723818]  ? __kmalloc_node_track_caller+0x49b/0x4d0
> > [  967.723824]  ? pskb_expand_head+0x75/0x310
> > [  967.723830]  ? nla_reserve+0x28/0x30
> > [  967.723835]  ? skb_free_head+0x25/0x30
> > [  967.723843]  ? security_sock_rcv_skb+0x2f/0x50
> > [  967.723850]  ? netlink_deliver_tap+0x3d/0x210
> > [  967.723859]  ? sk_filter_trim_cap+0xc1/0x230
> > [  967.723863]  ? skb_queue_tail+0x43/0x50
> > [  967.723870]  ? sock_def_readable+0x4b/0x80
> > [  967.723876]  ? __netlink_sendskb+0x42/0x50
> > [  967.723888]  ? security_capable+0x3d/0x60
> > [  967.723894]  ? __cond_resched+0x19/0x30
> > [  967.723900]  ? kmem_cache_alloc_trace+0x390/0x440
> > [  967.723906]  rtnl_newlink+0x49/0x70
> > [  967.723913]  rtnetlink_rcv_msg+0x13c/0x370
> > [  967.723920]  ? _copy_to_iter+0xa0/0x460
> > [  967.723927]  ? rtnl_calcit.isra.0+0x130/0x130
> > [  967.723934]  netlink_rcv_skb+0x55/0x100
> > [  967.723939]  rtnetlink_rcv+0x15/0x20
> > [  967.723944]  netlink_unicast+0x1a8/0x250
> > [  967.723949]  netlink_sendmsg+0x233/0x460
> > [  967.723954]  sock_sendmsg+0x65/0x70
> > [  967.723958]  ____sys_sendmsg+0x218/0x290
> > [  967.723961]  ? copy_msghdr_from_user+0x5c/0x90
> > [  967.723966]  ? lru_cache_add_inactive_or_unevictable+0x27/0xb0
> > [  967.723974]  ___sys_sendmsg+0x81/0xc0
> > [  967.723980]  ? __mod_memcg_lruvec_state+0x22/0xe0
> > [  967.723987]  ? kmem_cache_free+0x244/0x420
> > [  967.723991]  ? dentry_free+0x37/0x70
> > [  967.723996]  ? mntput_no_expire+0x4c/0x260
> > [  967.724001]  ? __cond_resched+0x19/0x30
> > [  967.724007]  ? security_file_free+0x54/0x60
> > [  967.724013]  ? call_rcu+0xa4/0x250
> > [  967.724021]  __sys_sendmsg+0x62/0xb0
> > [  967.724026]  ? exit_to_user_mode_prepare+0x3d/0x1a0
> > [  967.724032]  __x64_sys_sendmsg+0x1f/0x30
> > [  967.724037]  do_syscall_64+0x38/0x90
> > [  967.724044]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >
> > Fixes: bd869245a3dc ("net: core: try to runtime-resume detached device =
in __dev_open")
> > Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
> > ---
> >  net/core/dev.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 8f1a47ad6781..dd43a29419fd 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -1585,8 +1585,11 @@ static int __dev_open(struct net_device *dev, st=
ruct netlink_ext_ack *extack)
> >
> >       if (!netif_device_present(dev)) {
> >               /* may be detached because parent is runtime-suspended */
> > -             if (dev->dev.parent)
> > +             if (dev->dev.parent) {
> > +                     rtnl_unlock();
> >                       pm_runtime_resume(dev->dev.parent);
> > +                     rtnl_lock();
> > +             }
> >               if (!netif_device_present(dev))
> >                       return -ENODEV;
> >       }
> > --
> > 2.25.1
> >
