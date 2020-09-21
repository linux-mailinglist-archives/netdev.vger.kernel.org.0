Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1747527316E
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 20:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgIUSES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 14:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgIUSER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 14:04:17 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9EAC061755;
        Mon, 21 Sep 2020 11:04:17 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id gf14so173810pjb.5;
        Mon, 21 Sep 2020 11:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=V9rNnPQoAMI4NEIiklaqCcoHp0WL+M41f5UIEeXZuPk=;
        b=nInBMP6Or4FOjSpV7OD0u32IG1Ipkfqr+mtKv9Ji1pH58MBn2Szngx6Ra0y1E30cWq
         +XZAUwvtJo00pWANLfdzwT3OoUNOqTAb9Sovx50B2Opu9G8d38MbZ6KGeFdxaVDlOFOe
         M9gAulDA7hL7TvS6F7+VH5vZfttz0pibyXMcDXfMJBR7waI60P8H9V8I5LuzOx7sfzoE
         pksvRZWuS3aqIdtwRc+5O/oJDDWkNceHRPYpLfxzDMP80k4YHG5wGgRE52H39CizA2DQ
         hPay26eL0mv082kT246Ze8xSqaqa7VjOidskPPVZbRZQTQNzwQ0TZle6wqzSvj25Ytny
         cOSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=V9rNnPQoAMI4NEIiklaqCcoHp0WL+M41f5UIEeXZuPk=;
        b=JN7WM9krAgHRUHEHOhxlurIT460Mr03SEJHDgXG+X/wx4HfUcveohOxVPjUMqFIALA
         CZSL8YK1p96oCtr8xeD0k+iXewp9vLBAWagUkiZSPzGbbKWJU+uoVFz+wMlieQe4j/da
         8H+KvSdlU5jRYwTbO/q8l0ZzxfsMSABuv2CEMGDcezHnpZiWSiEJMitP143rhJkdHGPb
         KywK7FPeyl5lWnSz61xqbZDDF9TmV7Y5GAxk5lj4aJvNLG/j36Bw/WrfEIswMFrW/CUf
         b1UgklbJJq376ZGt+K7d/n1J4i4hcHrho+G4YMLrxISExOYyWpaQ8OQHYOkRJxZtqwm2
         rv1g==
X-Gm-Message-State: AOAM5336o1JOmbvM15Rcu+kCJz2dYW3T/GehMOThb1bRCP21Boqeonq1
        /GkxN+hHutetHIgs3FXswIA=
X-Google-Smtp-Source: ABdhPJywv9uoqNpx3Zgj+Bhj8oA3JuOmUEW3VhKcMkplWJIm1B6l9nYvDNMFS7TyZMuFV6Qn9d772Q==
X-Received: by 2002:a17:90a:9f8e:: with SMTP id o14mr464512pjp.103.1600711457216;
        Mon, 21 Sep 2020 11:04:17 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id i187sm12160547pgd.82.2020.09.21.11.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 11:04:16 -0700 (PDT)
Date:   Mon, 21 Sep 2020 11:04:09 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <maze@google.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        BPF-dev-list <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shaun Crampton <shaun@tigera.io>,
        David Miller <davem@davemloft.net>,
        Marek Majkowski <marek@cloudflare.com>
Message-ID: <5f68eb19cc0a2_17370208c9@john-XPS-13-9370.notmuch>
In-Reply-To: <340f209d-58d4-52a6-0804-7102d80c1468@iogearbox.net>
References: <20200917143846.37ce43a0@carbon>
 <CANP3RGcxM-Cno=Qw5Lut9DgmV=1suXqetnybA9RgxmW3KmwivQ@mail.gmail.com>
 <56ccfc21195b19d5b25559aca4cef5c450d0c402.camel@kernel.org>
 <20200918120016.7007f437@carbon>
 <CANP3RGfUj-KKHHQtbggiZ4V-Xrr_sk+TWyN5FgYUGZS6rOX1yw@mail.gmail.com>
 <CACAyw9-v_o+gPUpC-R9SXsfzMywrdGsWV13Nk=tx2aS-fEBFYg@mail.gmail.com>
 <20200921144953.6456d47d@carbon>
 <340f209d-58d4-52a6-0804-7102d80c1468@iogearbox.net>
Subject: Re: BPF redirect API design issue for BPF-prog MTU feedback?
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote:
> On 9/21/20 2:49 PM, Jesper Dangaard Brouer wrote:
> > On Mon, 21 Sep 2020 11:37:18 +0100
> > Lorenz Bauer <lmb@cloudflare.com> wrote:
> >> On Sat, 19 Sep 2020 at 00:06, Maciej =C5=BBenczykowski <maze@google.=
com> wrote:
> >>>   =

> >>>> This is a good point.  As bpf_skb_adjust_room() can just be run af=
ter
> >>>> bpf_redirect() call, then a MTU check in bpf_redirect() actually
> >>>> doesn't make much sense.  As clever/bad BPF program can then avoid=
 the
> >>>> MTU check anyhow.  This basically means that we have to do the MTU=

> >>>> check (again) on kernel side anyhow to catch such clever/bad BPF
> >>>> programs.  (And I don't like wasting cycles on doing the same chec=
k two
> >>>> times).
> >>>
> >>> If you get rid of the check in bpf_redirect() you might as well get=

> >>> rid of *all* the checks for excessive mtu in all the helpers that
> >>> adjust packet size one way or another way.  They *all* then become
> >>> useless overhead.
> >>>
> >>> I don't like that.  There may be something the bpf program could do=
 to
> >>> react to the error condition (for example in my case, not modify
> >>> things and just let the core stack deal with things - which will
> >>> probably just generate packet too big icmp error).
> >>>
> >>> btw. right now our forwarding programs first adjust the packet size=

> >>> then call bpf_redirect() and almost immediately return what it
> >>> returned.
> >>>
> >>> but this could I think easily be changed to reverse the ordering, s=
o
> >>> we wouldn't increase packet size before the core stack was informed=
 we
> >>> would be forwarding via a different interface.
> >>
> >> We do the same, except that we also use XDP_TX when appropriate. Thi=
s
> >> complicates the matter, because there is no helper call we could
> >> return an error from.
> > =

> > Do notice that my MTU work is focused on TC-BPF.  For XDP-redirect th=
e
> > MTU check is done in xdp_ok_fwd_dev() via __xdp_enqueue(), which also=

> > happens too late to give BPF-prog knowledge/feedback.  For XDP_TX I
> > audited the drivers when I implemented xdp_buff.frame_sz, and they
> > handled (or I added) handling against max HW MTU. E.g. mlx5 [1].
> > =

> > [1] https://elixir.bootlin.com/linux/v5.9-rc6/source/drivers/net/ethe=
rnet/mellanox/mlx5/core/en/xdp.c#L267
> > =

> >> My preference would be to have three helpers: get MTU for a device,
> >> redirect ctx to a device (with MTU check), resize ctx (without MTU
> >> check) but that doesn't work with XDP_TX. Your idea of doing checks
> >> in redirect and adjust_room is pragmatic and seems easier to
> >> implement.
> >   =

> > I do like this plan/proposal (with 3 helpers), but it is not possible=

> > with current API.  The main problem is the current bpf_redirect API
> > doesn't provide the ctx, so we cannot do the check in the BPF-helper.=

> > =

> > Are you saying we should create a new bpf_redirect API (that incl pac=
ket ctx)?
> =

> Sorry for jumping in late here... one thing that is not clear to me is =
that if
> we are fully sure that skb is dropped by stack anyway due to invalid MT=
U (redirect
> to ingress does this via dev_forward_skb(), it's not fully clear to me =
whether it's
> also the case for the dev_queue_xmiy()), then why not dropping all the =
MTU checks
> aside from SKB_MAX_ALLOC sanity check for BPF helpers and have somethin=
g like a
> device object (similar to e.g. TCP sockets) exposed to BPF prog where w=
e can retrieve
> the object and read dev->mtu from the prog, so the BPF program could th=
en do the
> "exception" handling internally w/o extra prog needed (we also already =
expose whether
> skb is GSO or not).
> =

> Thanks,
> Daniel

My $.02 is MTU should only apply to transmitted packets so redirect to
ingress should be OK. Then on transmit shouldn't the user know the MTU
on their devices?

I'm for dropping all the MTU checks and if a driver tosses a packet then
the user should be more careful. Having a bpf helper to check MTU of a
dev seems useful although the workaround would be a map the user could
put the max MTU in. Of course that would be a bit fragile if the BPF prog=
ram
and person managing MTU are not in-sync.

Thanks.=
