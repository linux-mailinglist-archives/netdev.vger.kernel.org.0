Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9097E414053
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 06:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhIVEOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 00:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhIVEOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 00:14:52 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA3CC061574;
        Tue, 21 Sep 2021 21:13:23 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id k23so1149554pji.0;
        Tue, 21 Sep 2021 21:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qC6TyEa9TAMW0NdzYyCRXoalES0QCazomfSR+acMeVI=;
        b=TOD3tCMhnFiKRslCvz8eoSnlHxgZDBeg93pw8oH6Xqaly9DD7sm9utwVvgX+/9W/ez
         vvXZTgCrBTarOyhMBCqUc3Yt7uK67YPrKE0nGaJ2/Q/+Gmnhk03kbOjR52o/IcSWzcwV
         LBWhK9mK7C8rgYRLcd2MXt4CQ4ZEz96YTCfoXvcpYVdt/R/OXBJvuRg8GFzyktcR/0Fd
         OE9c+2zQQwbwWstJsUBfAFhsu9Z0uwu316ahREgU3kSvzGQo05o+QC1OisPfjCcjgKwq
         IUWyqXILCet+x6225Wf7r0owxEvlSm63RIls/GHSSdtUTfLNGsOJGyg0KQr3CNwlaS/S
         3agA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qC6TyEa9TAMW0NdzYyCRXoalES0QCazomfSR+acMeVI=;
        b=as6RjIWs+XNiO7G8TYQrvADhRMnWxVHKHiwO5hS8lO1O7M8LH1AJ9UgUJLVGttDsNM
         Z8qmig74SBKq/qrzLt+IZhpdZADUymA5arlwXglYVfU0mY4aVIt5C7ujT4d9K9vRfKJi
         rkRJdA84gGluZe/YSIjTeUOFeIATqDK9xCM2U0AlGrb4oCej8bCV2x7P5UqEloNDCgFl
         tYmSlY2dCSn7CZTAtAXAdaaoh05+VKFGgB+eVRaZ7pedq4K1hedTpWiNrv6TonV64hlY
         cL+B8rE7JtzGCzfKSG2IdCOvJCnXkg8GepREz/K0uNRvP6zNLlnaY6uqBopJzCIbZaav
         xydA==
X-Gm-Message-State: AOAM531a9ROosqeHTQ3JfjOMtuDnct6xJikVVmVbcUNVgnwpa0nv2Emd
        Ud3T2xwRC6ibaT+K3I9mLoSbIhjfWCyniS2Y4FzKAqLVRCY=
X-Google-Smtp-Source: ABdhPJydRwv/KoenUPS9VMLCoQWu/wvMspxTZVzLghrhPjG2ekB4V6gqXb6fLpVYhvDtIC5fIFyedjRktLwSiXgSSEU=
X-Received: by 2002:a17:902:6846:b0:13c:9f94:59e0 with SMTP id
 f6-20020a170902684600b0013c9f9459e0mr30068203pln.52.1632284002818; Tue, 21
 Sep 2021 21:13:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210913231108.19762-1-xiyou.wangcong@gmail.com>
 <CAADnVQJFbCmzoFM8GGHyLWULSmX75=67Tu0EnTOOoVfH4gE+HA@mail.gmail.com>
 <CAM_iQpX2prCpPDmO1U0A_wyJi_LS4wmd9MQiFKiqQT8NfGNNnw@mail.gmail.com> <CAADnVQJJHLuaymMEdDowharvyJr+6ta2Tg9XAR3aM+4=ysu+bg@mail.gmail.com>
In-Reply-To: <CAADnVQJJHLuaymMEdDowharvyJr+6ta2Tg9XAR3aM+4=ysu+bg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 21 Sep 2021 21:13:11 -0700
Message-ID: <CAM_iQpUCtXRWhMqSaoymZ6OqOywb-k4R1_mLYsLCTm7ABJ5k_A@mail.gmail.com>
Subject: Re: [RFC Patch net-next v2] net_sched: introduce eBPF based Qdisc
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 9:03 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Sep 21, 2021 at 8:59 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Fri, Sep 17, 2021 at 11:18 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Mon, Sep 13, 2021 at 6:27 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > ---
> > > > v2: Rebase on latest net-next
> > > >     Make the code more complete (but still incomplete)
> > >
> > > What is the point of v2 when feedback on the first RFC was ignored?
> >
> > They are not ignored for two reasons:
> >
> > 1) I responded to those reasonable ones in the original thread. Clearly
> > you missed them.
>
> Multiple people in the v1 thread made it clear that the approach
> presented in v1 is not generic enough. v2 made no attempt to
> address these concerns.

It looks like you just missed the first part:

"This *incomplete* patch introduces a programmable Qdisc with
eBPF.  The goal is to make this Qdisc as programmable as possible,
that is, to replace as many existing Qdisc's as we can, no matter
in tree or out of tree. And we want to make programmer's and researcher's
life as easy as possible, so that they don't have to write a complete
Qdisc kernel module just to experiment some queuing theory."

If you compare it with V1, V2 explains the use case in more details,
which is to target Qdisc writers, not any other. Therefore, the argument
of making it out of Qdisc is non-sense, anything outside of Qdisc is
not even my target. Of course you can do anything in XDP, but it has
absolutely nothing with my goal here: Qdisc.

I also addressed the skb map concern:

" 2b) Kernel would lose the visibility of the "queues", as maps are only
   shared between eBPF programs and user-space. These queues still have to
   interact with the kernel, for example, kernel wants to reset all queues
   when we reset the network interface, kernel wants to adjust number of
   queues if they are mapped to hardware queues."

More than writing, I even tried to write a skb map by myself, I don't
see it fits into my goal at all. Therefore, the only thing I can do is just to
expand my changelog to explain why.

Thanks.
