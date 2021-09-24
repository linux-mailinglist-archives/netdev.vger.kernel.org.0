Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55EBE417A39
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 19:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345148AbhIXR5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 13:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345140AbhIXR5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 13:57:14 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB807C061571
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 10:55:40 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id s17so20408288edd.8
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 10:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riotgames.com; s=riotgames;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KUPDVOA4XDNnq9zf102U8VHS3P1lA9qWx5kvOore3Uc=;
        b=b6BzUN/IhT1+G2RLlSfH5wLwLKt9cjSFXJ3GwJrAEitjD8skHCK0ptF38uGy4PF5e6
         TD4ZKlcBh05sf6gss6dDEjwMvnjAiFkanwpRDbD3t4XjJRlfa0NZHswI0QGfUKuda11E
         OOjvrDgTZIcDYJH8IyiaYGRaXlWccXfNV0YbE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KUPDVOA4XDNnq9zf102U8VHS3P1lA9qWx5kvOore3Uc=;
        b=FLsDs8Mh7eWKULrwqAU5EDG2jBPueE2Jwvau2YoL70hKxUCFG/2hKClCB9fWUgiIkn
         sFzoJgcnUivRIIXyu6YMNJHW4H78qAx8EAMQMZivfaqBix6dvCx1Iqb7AREpTIuRiaRE
         TEI+ERIl31m5UnGbGxwRXPgSPUBRPvrSMMvrWG+DW20NHE79qL6np/4fKdKTmudjm8iq
         x3Jk1UB/RezrzBtR/Ti3fX7PX3Vpx2Twbx5zEhVbtgj8nPrSMEONtaKxLFToPUOz02FY
         kKefMS/V6C54uPCad2+kbJurAc9Z35Iop+Wy9wIAgUeUDgy7v2bRAGcp36ciNo6VZ45a
         xtbw==
X-Gm-Message-State: AOAM532QI/AbN4QkQIQTHBTTLi4ZKIu+HYic0PDJF43ckOcRuxRTCF1D
        Q3dsSQal3uhcqgG2D6NDLBHMe2H2r1edeVcVDJA91w==
X-Google-Smtp-Source: ABdhPJxcc612B8PP4dsKL5V6hmcfeiecubafpzjOmP9N1vc5U2tNmnuUim3R+ghSZzRotFRBFxoNIuU/DDrteunHSSo=
X-Received: by 2002:aa7:c3cb:: with SMTP id l11mr6520519edr.310.1632506139194;
 Fri, 24 Sep 2021 10:55:39 -0700 (PDT)
MIME-Version: 1.0
References: <87o88l3oc4.fsf@toke.dk> <CACAyw99+KvsJGeqNE09VWHrZk9wKbQTg3h1h2LRmJADD5En2nQ@mail.gmail.com>
 <87tuibzbv2.fsf@toke.dk> <CACAyw9_N2Jh651hXL=P=cFM7O-n7Z0NXWy_D9j0ztVpEm+OgNA@mail.gmail.com>
In-Reply-To: <CACAyw9_N2Jh651hXL=P=cFM7O-n7Z0NXWy_D9j0ztVpEm+OgNA@mail.gmail.com>
From:   Zvi Effron <zeffron@riotgames.com>
Date:   Fri, 24 Sep 2021 10:55:27 -0700
Message-ID: <CAC1LvL2n+FYA997j8+=gnyNQz3y80socMwTqQ1fbbOdp2ZnfAg@mail.gmail.com>
Subject: Re: Redux: Backwards compatibility for XDP multi-buff
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenzo Bianconi <lbianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 3:19 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Thu, 23 Sept 2021 at 13:59, Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
> >
> > I don't think it has to be quite that bleak :)
> >
> > Specifically, there is no reason to block mb-aware programs from loadin=
g
> > even when the multi-buffer mode is disabled. So a migration plan would
> > look something like:
>
> ...
>
> > 2. Start porting all your XDP programs to make them mb-aware, and switc=
h
> > their program type as you do. In many cases this is just a matter of
> > checking that the programs don't care about packet length. [...]
>
> Porting is only easy if we are guaranteed that the first PAGE_SIZE
> bytes (or whatever the current limit is) are available via ->data
> without trickery. Otherwise we have to convert all direct packet
> access to the new API, whatever that ends up being. It seemed to me
> like you were saying there is no such guarantee, and it could be
> driver dependent, which is the worst possible outcome imo. This is the
> status quo for TC classifiers, which is a great source of hard to
> diagnose bugs.
>
> > 3. Once all your programs have been ported and marked as such, flip the
> > sysctl. This will make the system start refusing to load any XDP
> > programs that are not mb-aware.
>
> By this you mean reboot the system and early in boot change the
> sysctl? That could work I guess.
>

I don't think a reboot is required. Just an unload of all
mb-unaware XDP programs to allow adjusting the sysctl via normal sysctl
changing methods (i.e. sysctl -w). Even if rebooting, it should just need a=
n
entry in /etc/sysctl.conf, nothing necessarily early in the boot process. T=
he
sysctl would only need to be set before the first load of an mn-unaware XDP
program, which, if everything is ported correctly, would never happen.

> > > 2. Add a compatibility shim for mb-unaware programs receiving an mb f=
rame.
> > >
> > > We'd still need a way to indicate "MB-OK", but it could be a piece of
> > > metadata on a bpf_prog. Whatever code dispatches to an XDP program
> > > would have to include a prologue that linearises the xdp_buff if
> > > necessary which implies allocating memory. I don't know how hard it i=
s
> > > to implement this.
> >
> > I think it would be somewhat non-trivial, and more importantly would
> > absolutely slaughter performance. And if you're using XDP, presumably
> > you care about that, so I'm not sure we're doing anyone any favours by
> > implementing such a compatibility layer?
>
> I see your point: having a single non-mb-aware program trash
> performance is bad for marketing. Better to not let people bump the
> MTU in that case.
>
> > > 3. Make non-linearity invisible to the BPF program
> > >
> > > Something I've wished for often is that I didn't have to deal with
> > > nonlinearity at all, based on my experience with cls_redirect [2].
> > > It's really hard to write a BPF program that handles non-linear skb,
> > > especially when you have to call adjust_head, etc. which invalidates
> > > packet buffers. This is probably impossible, but maybe someone has a
> > > crazy idea? :)
> >
> > With the other helpers that we started discussing, I don't think you
> > have to? I.e., with an xdp_load_bytes() or an xdp_data_pointer()-type
> > helper that works across fragment boundaries I think you'd be fine, no?
>
> I'll take a look!
>
> Lorenz
>
> --
> Lorenz Bauer | Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
>
> www.cloudflare.com
