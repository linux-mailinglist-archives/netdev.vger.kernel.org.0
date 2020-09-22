Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1E1273B48
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 08:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbgIVG4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 02:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727710AbgIVG4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 02:56:18 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9834C061755;
        Mon, 21 Sep 2020 23:56:17 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id z13so18434364iom.8;
        Mon, 21 Sep 2020 23:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4EbyiXki977MF5ROkFyExmjP+SM+e03uI5E9aUrMUf8=;
        b=SRl6HcHt+8Uzri216O4e5r8e0o+mHfjC+qQv7rdeTG6tkOk7pY2ofO9hvqG0eVyIvI
         kEqrKOOgnPUvzoKkmV0yQgcTQRXE4nwugiU0kNew4PjUNhM5Vlz388ZMjtRh1HoX2Gqv
         qSfhHMRf1vWKfBdRsusWDrKiNX5mLAfCUDqBSqqRhS7U2yCJydStMvBHApsIZIJVN8VF
         E7f3S8pxgVoV4HckeanqyZfI4WQpvNqyuM571EFCiL+vDImTLsrqXP5yjP/Dq1UKgAwx
         kbP0vj5ecHdpqpfzbK4s+42DKiCCCAy+tmEUy/JW7E1FBp4IB+cCYYGy3h6S1EZpogAW
         Uc9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4EbyiXki977MF5ROkFyExmjP+SM+e03uI5E9aUrMUf8=;
        b=THCIaWCBj9XGjgceGojbpv24HYLCf9wa5pECFqnnPylXSwKGI5/yn9JFS+s+iuZKnH
         GKQCKFydBcyFoMODpcRUys53SEARDOZjsQFMHC6flr4q/kI8f3WkSBCiJzH/rrtLxPxK
         zDhYXwPKminf/VQGazfkILG6H0YaLCWVViGQ2RyWBXlwW9M8sVMdB5GSWQCW7tJ+oqLS
         G++cHc63m2BeGMsdveU+Y+T3wtvAdHunLBPvr8KYEZb9hOqXD4F/0wdiGPqNqQV3eMKj
         NQYAvRxUCjy0/8oIKhGNOMatQx7zYrJuT6R/JmzR/gFd/riccXvgfaZYcA56bGDLnoJD
         Dk5A==
X-Gm-Message-State: AOAM530s5hj5fzwSbNr5KQAlH3UkiQH+bZ7UHklb+h1Zm3u1Bz7ibVPo
        O/COIyQrI86hsRTp0jmyb83nNvbZbKywOyPHrrk=
X-Google-Smtp-Source: ABdhPJxvo8OeLajAmZnqjD/Ad7r9KwCJO7F/Kcyzl1yLfhxRLVEJgU4VlpXL48Y5R9GfG4dX04kLWsFFZhi2diF+D6c=
X-Received: by 2002:a6b:3e06:: with SMTP id l6mr2371335ioa.160.1600757776664;
 Mon, 21 Sep 2020 23:56:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200917143846.37ce43a0@carbon> <CANP3RGcxM-Cno=Qw5Lut9DgmV=1suXqetnybA9RgxmW3KmwivQ@mail.gmail.com>
 <56ccfc21195b19d5b25559aca4cef5c450d0c402.camel@kernel.org>
 <20200918120016.7007f437@carbon> <CANP3RGfUj-KKHHQtbggiZ4V-Xrr_sk+TWyN5FgYUGZS6rOX1yw@mail.gmail.com>
 <CACAyw9-v_o+gPUpC-R9SXsfzMywrdGsWV13Nk=tx2aS-fEBFYg@mail.gmail.com>
 <20200921144953.6456d47d@carbon> <340f209d-58d4-52a6-0804-7102d80c1468@iogearbox.net>
 <20200921182638.5d8343fd@carbon>
In-Reply-To: <20200921182638.5d8343fd@carbon>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Tue, 22 Sep 2020 09:56:05 +0300
Message-ID: <CAHsH6Gug-hsLGHQ6N0wtixdOa85LDZ3HNRHVd0opR=19Qo4W4Q@mail.gmail.com>
Subject: Re: BPF redirect API design issue for BPF-prog MTU feedback?
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 7:30 PM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Mon, 21 Sep 2020 17:08:17 +0200
> Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> > On 9/21/20 2:49 PM, Jesper Dangaard Brouer wrote:
> > > On Mon, 21 Sep 2020 11:37:18 +0100
> > > Lorenz Bauer <lmb@cloudflare.com> wrote:
> > >> On Sat, 19 Sep 2020 at 00:06, Maciej =C5=BBenczykowski <maze@google.=
com> wrote:
> > >>>
> > >>>> This is a good point.  As bpf_skb_adjust_room() can just be run af=
ter
> > >>>> bpf_redirect() call, then a MTU check in bpf_redirect() actually
> > >>>> doesn't make much sense.  As clever/bad BPF program can then avoid=
 the
> > >>>> MTU check anyhow.  This basically means that we have to do the MTU
> > >>>> check (again) on kernel side anyhow to catch such clever/bad BPF
> > >>>> programs.  (And I don't like wasting cycles on doing the same chec=
k two
> > >>>> times).
> > >>>
> > >>> If you get rid of the check in bpf_redirect() you might as well get
> > >>> rid of *all* the checks for excessive mtu in all the helpers that
> > >>> adjust packet size one way or another way.  They *all* then become
> > >>> useless overhead.
> > >>>
> > >>> I don't like that.  There may be something the bpf program could do=
 to
> > >>> react to the error condition (for example in my case, not modify
> > >>> things and just let the core stack deal with things - which will
> > >>> probably just generate packet too big icmp error).
> > >>>
> > >>> btw. right now our forwarding programs first adjust the packet size
> > >>> then call bpf_redirect() and almost immediately return what it
> > >>> returned.
> > >>>
> > >>> but this could I think easily be changed to reverse the ordering, s=
o
> > >>> we wouldn't increase packet size before the core stack was informed=
 we
> > >>> would be forwarding via a different interface.
> > >>
> > >> We do the same, except that we also use XDP_TX when appropriate. Thi=
s
> > >> complicates the matter, because there is no helper call we could
> > >> return an error from.
> > >
> > > Do notice that my MTU work is focused on TC-BPF.  For XDP-redirect th=
e
> > > MTU check is done in xdp_ok_fwd_dev() via __xdp_enqueue(), which also
> > > happens too late to give BPF-prog knowledge/feedback.  For XDP_TX I
> > > audited the drivers when I implemented xdp_buff.frame_sz, and they
> > > handled (or I added) handling against max HW MTU. E.g. mlx5 [1].
> > >
> > > [1] https://elixir.bootlin.com/linux/v5.9-rc6/source/drivers/net/ethe=
rnet/mellanox/mlx5/core/en/xdp.c#L267
> > >
> > >> My preference would be to have three helpers: get MTU for a device,
> > >> redirect ctx to a device (with MTU check), resize ctx (without MTU
> > >> check) but that doesn't work with XDP_TX. Your idea of doing checks
> > >> in redirect and adjust_room is pragmatic and seems easier to
> > >> implement.
> > >
> > > I do like this plan/proposal (with 3 helpers), but it is not possible
> > > with current API.  The main problem is the current bpf_redirect API
> > > doesn't provide the ctx, so we cannot do the check in the BPF-helper.
> > >
> > > Are you saying we should create a new bpf_redirect API (that incl pac=
ket ctx)?
> >
> > Sorry for jumping in late here... one thing that is not clear to me
> > is that if we are fully sure that skb is dropped by stack anyway due
> > to invalid MTU (redirect to ingress does this via dev_forward_skb(),
>
> Yes, TC-redirecting to *INGRESS* have a slightly relaxed MTU check via
> is_skb_forwardable() called via ____dev_forward_skb().  This MTU check
> seems redundant as netstack will do MTU checks anyhow.
>

I found the MTU check on redirect-to-ingress to be very unexpected.

We hit this when implementing NAT64 as a tc egress program which translates
the packet and redirects it to ingress from the same device.

It is beneficial to have the MTU of the device set to a limit fitting the
IPv4 MTU, so that the IP stack would fragment as needed on the IPv4->IPv6
path. But when translating the packet to IPv6, it can no longer be ingresse=
d
from the same device because of the MTU check. Packets are silently dropped
without any hint.

So would definitely be nice if this check is removed, or a flag to avoid
it is supported in bpf_redirect().

Eyal.
