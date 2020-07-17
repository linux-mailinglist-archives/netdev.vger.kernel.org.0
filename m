Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D89223FA1
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 17:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgGQPci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 11:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgGQPch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 11:32:37 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4275C0619D2;
        Fri, 17 Jul 2020 08:32:37 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id e18so7684253ilr.7;
        Fri, 17 Jul 2020 08:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EJCYLsBj2TMBtJ1pc/v8p/M1SvJbCZciC16iI6Wx2S0=;
        b=aCRYjGNogXTIkiKdk1+hxb0Nka9KJTFwAKqphCu5ghi2Jwy1BNQg0moABIv7gKeuEw
         eFsgcq5SSf4/6naxmO5ruF3czffPfoD6/kIa8EEaVbrJZPdbUixztAq9ZZSsquQD7ulF
         Fni06vWPb6f/WxwypMpfuFZ+5i/vR3MTFv/VWnbmD8+saJ//fV2iX9fDls4ciCEfAok9
         Sclke+SozjXg2dVHtuzhxLREGjy0UBSke+Z5lI5MtTGYtgRKe8Ak0avf3hFq3g8fLFkt
         4Kx0zzhIDJZidAZUGaXltnqaVtP7Rb62iasQyNJqx6quWCNQgmiV5ir0RKCP+pdEetz/
         5R1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EJCYLsBj2TMBtJ1pc/v8p/M1SvJbCZciC16iI6Wx2S0=;
        b=TXlulF5i/AmZRHFLpAbzCsAVa0DeRapa2PEQ8XRJm/MPtPzDECOngHQRxDWuJ5PZdb
         JsmKCKkik/02vh7QrQlS1ciJiA7o8yHJ2BPCVl4IqC/uuwD1F+KwgaC5g/9ekpJ6u2XX
         AaNf6c4h73deF5d8uXzjb5r9KRU/9vkbzlsq/SyTgzaTjyGFgpWgzJg4SdBIitaUnd0y
         9MXsZ3VjWfhMWClpVQsOPPZ8ToDcT+48dFiowgNc+tOHny+T9kNhikII1NGMcylvwL2u
         GHcQ1catnTOdmPLIZAFEBuNBK6zNzZja+Y0n1J/qQetvT/STbpeKxhNo9e4PrfTkn8Cg
         yc8A==
X-Gm-Message-State: AOAM5323N0WxOKEEjNKflF0qRO7DcYYfb4y5moYkKF89lcwq7HF06s7A
        T0f6pX5g5xgCLS9U4+AX/SZ3H1cT+s20FWfTc2M=
X-Google-Smtp-Source: ABdhPJzrtHXUAbJhhMYDsLUG/XetbHRfQWpl9lWm9ZVf4DxUV9OzWGYlyTxZ39FPQ0iJ3PJqIDxgEuEPNy2Yuz7KZQ0=
X-Received: by 2002:a92:5857:: with SMTP id m84mr10133790ilb.144.1594999957052;
 Fri, 17 Jul 2020 08:32:37 -0700 (PDT)
MIME-Version: 1.0
References: <1594097711-9365-1-git-send-email-wenxu@ucloud.cn>
 <20200715132659.34fa0e14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20200715211714.GR32005@breakpoint.cc>
In-Reply-To: <20200715211714.GR32005@breakpoint.cc>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 17 Jul 2020 08:32:25 -0700
Message-ID: <CAM_iQpUw+D=6aQc0Dxfy8bUuk_vz8JKtWV8GvhKOKJvyQ-a=dg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/3] make nf_ct_frag/6_gather elide the skb CB clear
To:     Florian Westphal <fw@strlen.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, wenxu <wenxu@ucloud.cn>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 2:17 PM Florian Westphal <fw@strlen.de> wrote:
>
> Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue,  7 Jul 2020 12:55:08 +0800 wenxu@ucloud.cn wrote:
> > > From: wenxu <wenxu@ucloud.cn>
> > >
> > > Add nf_ct_frag_gather and Make nf_ct_frag6_gather elide the CB clear
> > > when packets are defragmented by connection tracking. This can make
> > > each subsystem such as br_netfilter, openvswitch, act_ct do defrag
> > > without restore the CB.
> > > This also avoid serious crashes and problems in  ct subsystem.
> > > Because Some packet schedulers store pointers in the qdisc CB private
> > > area and parallel accesses to the SKB.
> > >
> > > This series following up
> > > http://patchwork.ozlabs.org/project/netdev/patch/1593422178-26949-1-git-send-email-wenxu@ucloud.cn/
> > >
> > > patch1: add nf_ct_frag_gather elide the CB clear
> > > patch2: make nf_ct_frag6_gather elide the CB clear
> > > patch3: fix clobber qdisc_skb_cb in act_ct with defrag
> > >
> > > v2: resue some ip_defrag function in patch1
> >
> > Florian, Cong - are you willing to venture an ack on these? Anyone?
>
> Nope, sorry.  Reason is that I can't figure out the need for this series.
> Taking a huge step back:
>
> http://patchwork.ozlabs.org/project/netdev/patch/1593422178-26949-1-git-send-email-wenxu@ucloud.cn/
>
> That patch looks ok to me:
> I understand the problem statement/commit message and I can see how its addressed.
>
> I don't understand why the CB clearing must be avoided.
>
> defrag assumes skb ownership -- e.g. it may realloc skb->data
> (calls pskb_may_pull), it calls skb_orphan(), etc.
>
> AFAICS, tcf_classify makes same assumption -- exclusive ownership
> and no parallel skb accesses.
>
> So, if in fact the "only" problem is the loss of
> qdisc_skb_cb(skb)->pkt_len, then the other patch looks ok to me.
>
> If we indeed have parallel access, then I do not understand how
> avoiding the memsets in the defrag path makes things any better
> (see above wrt. skb pull and the like).

+1

I don't see parallel access here either. skb can be cloned for packet
socket or act_mirred, but its CB is cloned at the same time.

Thanks.
