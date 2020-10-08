Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE863287AC3
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 19:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731869AbgJHRQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 13:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730261AbgJHRQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 13:16:01 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D30EC061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 10:16:01 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id o17so1449247ioh.9
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 10:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vozB4RX6LnK/Jr5VFSyBOkamu9xOxl29VMpG9E2UeeI=;
        b=JgnBq1GR/VFqTiSp2LzPStnPAwAdwKiTh2S/s/FtIcm9+GrPstQN37NpigEl+MJ/Og
         R9abwemFwCx/Td/vlplPG60c+pS9xpZA7m0PSAGPEa1pzSJR8m2IExqNgk9oZa+jBnR2
         Zy/jPip8rA2EIIujzB+9OWhAe6NYhpNoThZ2V7QyUWBl6Kqz7bMgNwWgTR5GakgDFXIN
         1bAdKAXtwM75h/jCgSj5pUb+3JTuGM+TDmc8C+9jvLiIPlAWwZRklmRzHXZgmhWR0euV
         MEe26kRnX3Wh8WSg27tEFR9cPornxenGO7hTiqOWk4mQAQbuYF3H0wwkEZQY7iPEtFtw
         PtQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vozB4RX6LnK/Jr5VFSyBOkamu9xOxl29VMpG9E2UeeI=;
        b=ImKzyyl3wOKLf3JNMivt/Oo6ZO8aMwoV8vU5x286QUn0poiZDauoEVIlZfYSv7UTcr
         ztFdfzs5qbekIlgU5YaF6MpBPg41hAGqf3svqKlkTqd7Pk7MbfCJCOX57ogTHV0mtCWE
         +tWJn8SgBiGGObEMvjIXmPCcQMUnE1OOoAbf+oWIUvCHhc7OfLdFMcmAFniyEqIT6DXF
         +dcbAtJ/H/PlLvJIjLzWJtIEClWZcBOueUgOhZNOon8mj4ByPuLltwDSc2mctsDA9qYy
         KrGUx6bHJtPZ4q5ZMm5CAVBxrnUkNd+1Zblw0UEizl0EiNuP0PYx2CsBNWabYMWldakx
         UdCQ==
X-Gm-Message-State: AOAM533psxW9G0KCM03Z9D9eoCiM4Mha9g8BN8rkUQxpege9TUogg90Y
        WXTa6hRfVl2Vid2GSljuCHsr215XNNh4HSFevsNq7g==
X-Google-Smtp-Source: ABdhPJwA+Aiz+KTDveWoNDhPRAzsD+Kw6JiVl1FPhPF46PHEbExGf7OOebzYDkKGtb+qo4sJEiuSrp9I0kiO7BTuYxo=
X-Received: by 2002:a02:c85a:: with SMTP id r26mr7369153jao.99.1602177360550;
 Thu, 08 Oct 2020 10:16:00 -0700 (PDT)
MIME-Version: 1.0
References: <bug-209423-201211-atteo0d1ZY@https.bugzilla.kernel.org/>
 <80adc922-f667-a1ab-35a6-02bf1acfd5a1@gmail.com> <CANn89i+ZC5y_n_kQTm4WCWZsYaph4E2vtC9k_caE6dkuQrXdPQ@mail.gmail.com>
 <733a6e54-f03c-0076-1bdc-9b0d4ec1038c@gmail.com> <CANn89iJ2zqH=_fvJQ8dhG4nBVnKNB7SjHnHDLv+0iR7UwgxTsw@mail.gmail.com>
 <b6ff841a-320c-5592-1c2b-650e18dfe3e0@gmail.com> <CANn89iJ2KxQKZmT2ShVZRTjdgyYkF_2ZWBraTZE4TJVtUKh--Q@mail.gmail.com>
 <9e4b2b1f-c2d9-dbd0-c7ce-49007ddd7af2@gmail.com>
In-Reply-To: <9e4b2b1f-c2d9-dbd0-c7ce-49007ddd7af2@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 8 Oct 2020 19:15:48 +0200
Message-ID: <CANn89iJwwDCkdmFFAkXav+HNJQEEKZsp8PKvEuHc4gNJ=4iCoQ@mail.gmail.com>
Subject: Re: [Bug 209423] WARN_ON_ONCE() at rtl8169_tso_csum_v2()
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 6:37 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 02.10.2020 13:48, Eric Dumazet wrote:
> > On Fri, Oct 2, 2020 at 1:09 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>
> >> On 02.10.2020 10:46, Eric Dumazet wrote:
> >>> On Fri, Oct 2, 2020 at 10:32 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 10/2/20 10:26 AM, Eric Dumazet wrote:
> >>>>> On Thu, Oct 1, 2020 at 10:34 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>>>>>
> >>>>>> I have a problem with the following code in ndo_start_xmit() of
> >>>>>> the r8169 driver. A user reported the WARN being triggered due
> >>>>>> to gso_size > 0 and gso_type = 0. The chip supports TSO(6).
> >>>>>> The driver is widely used, therefore I'd expect much more such
> >>>>>> reports if it should be a common problem. Not sure what's special.
> >>>>>> My primary question: Is it a valid use case that gso_size is
> >>>>>> greater than 0, and no SKB_GSO_ flag is set?
> >>>>>> Any hint would be appreciated.
> >>>>>>
> >>>>>>
> >>>>>
> >>>>> Maybe this is not a TCP packet ? But in this case GSO should have taken place.
> >>>>>
> >>>>> You might add a
> >>>>> pr_err_once("gso_type=%x\n", shinfo->gso_type);
> >>>>>
> >>>
> >>>>
> >>>> Ah, sorry I see you already printed gso_type
> >>>>
> >>>> Must then be a bug somewhere :/
> >>>
> >>>
> >>> napi_reuse_skb() does :
> >>>
> >>> skb_shinfo(skb)->gso_type = 0;
> >>>
> >>> It does _not_ clear gso_size.
> >>>
> >>> I wonder if in some cases we could reuse an skb while gso_size is not zero.
> >>>
> >>> Normally, we set it only from dev_gro_receive() when the skb is queued
> >>> into GRO engine (status being GRO_HELD)
> >>>
> >> Thanks Eric. I'm no expert that deep in the network stack and just wonder
> >> why napi_reuse_skb() re-initializes less fields in shinfo than __alloc_skb().
> >> The latter one does a
> >> memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
> >>
> >
> > memset() over the whole thing is more expensive.
> >
> > Here we know the prior state of some fields, while __alloc_skb() just
> > got a piece of memory with random content.
> >
> >> What I can do is letting the affected user test the following.
> >>
> >> diff --git a/net/core/dev.c b/net/core/dev.c
> >> index 62b06523b..8e75399cc 100644
> >> --- a/net/core/dev.c
> >> +++ b/net/core/dev.c
> >> @@ -6088,6 +6088,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
> >>
> >>         skb->encapsulation = 0;
> >>         skb_shinfo(skb)->gso_type = 0;
> >> +       skb_shinfo(skb)->gso_size = 0;
> >>         skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
> >>         skb_ext_reset(skb);
> >>
> >
> > As I hinted, this should not be needed.
> >
> > For debugging purposes, I would rather do :
> >
> > BUG_ON(skb_shinfo(skb)->gso_size);
> >
>
> We did the following for debugging:
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 62b06523b..4c943b774 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3491,6 +3491,9 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
>  {
>         u16 gso_segs = skb_shinfo(skb)->gso_segs;
>
> +       if (!skb_shinfo(skb)->gso_type)
> +               skb_warn_bad_offload(skb);

You also want to get a stack trace here, to give us the call graph.


> +
>         if (gso_segs > dev->gso_max_segs)
>                 return features & ~NETIF_F_GSO_MASK;
>
> Following skb then triggered the skb_warn_bad_offload. Not sure whether this helps
> to find out where in the network stack something goes wrong.
>
>
> [236222.967236] skb len=134 headroom=778 headlen=134 tailroom=31536
>                 mac=(778,14) net=(792,20) trans=812
>                 shinfo(txflags=0 nr_frags=0 gso(size=568 type=0 segs=1))
>                 csum(0x0 ip_summed=1 complete_sw=0 valid=0 level=0)
>                 hash(0x0 sw=0 l4=0) proto=0x0800 pkttype=0 iif=4
> [236222.967297] dev name=enp1s0 feat=0x0x00000100000041b2
> [236222.967392] skb linear:   00000000: 00 13 3b a0 01 e8 7c d3 0a 2d 1b 3b 08 00 45 00
> [236222.967404] skb linear:   00000010: 00 78 e2 e6 00 00 7b 06 52 e1 d8 3a d0 ce c0 a8
> [236222.967415] skb linear:   00000020: a0 06 01 bb 8b c6 53 91 be 5e 6e 60 bd e2 80 18
> [236222.967426] skb linear:   00000030: 01 13 5c f6 00 00 01 01 08 0a 3d d6 6a a3 63 ea
> [236222.967437] skb linear:   00000040: 5c d9 17 03 03 00 3f af 00 01 84 45 e2 36 e4 6a
> [236222.967454] skb linear:   00000050: 3d 76 a8 7f d7 12 fa 72 4b d1 d0 74 0d c1 49 77
> [236222.967466] skb linear:   00000060: 8b a4 bb 04 e5 aa 03 61 d3 e6 1f c9 0d 3e 46 c8
> [236222.967477] skb linear:   00000070: cd 1f 7d ce e8 a7 84 84 01 5d 1f b4 ee 4f 27 63
> [236222.967488] skb linear:   00000080: d2 a1 ab 1f 26 1d
>
>
>
> >
> > Nothing in GRO stack will change gso_size, unless the packet is queued
> > by GRO layer (after this, napi_reuse_skb() wont be called)
> >
> > napi_reuse_skb() is only used when a packet has been aggregated to
> > another, and at this point gso_size should be still 0.
> >
>
