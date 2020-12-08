Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B1E2D23E7
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 07:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgLHGtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 01:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgLHGtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 01:49:42 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDCEC061749;
        Mon,  7 Dec 2020 22:49:02 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id x2so15207313ybt.11;
        Mon, 07 Dec 2020 22:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q5gbwWkOtujJVv2v0BjUJ6Ouy8BGKxoIqvXI37zp8Pw=;
        b=gH85z02WDx+RfDoz1i5hCKihVidqOLOEXlpAVuCE4lJJNLwoVTuJL4SXKxs6hkBayl
         cty8t3+PwOjO0V/pSCcRPGblDVVPn7ZBdv77CUN76bG6eHXsXpSsmm2f4LjdgbDO0art
         Buj2vSefcnibMR8ZZNW1DqYKkrzlXurtO6CnAGCPSAo5+32PnbsYwX3SIZjQE5UDS0bV
         UwB5XD3w1zz49/MbQDs2YP74qclVJtbFyGL4ZlgsDQ4WXP08GsoydcmNYLI1KBULgOWG
         qphT8bPqKg3LzVasIlfWsX7yLpNJ9P6OLsaQ+xsC27Z/ZIRai6yd1CY5ul5GyE+sRBUV
         EdIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q5gbwWkOtujJVv2v0BjUJ6Ouy8BGKxoIqvXI37zp8Pw=;
        b=oa3Acx5FcrQ74WjDc4rclaEqn5ArOQYSWhPEpwhCmHnmYZEfJEP2Y9m9OCfvTdrxip
         uaR2mJs+aOCnMNMV8QGuFayWBbbDGc6u51BLQCTGvLbqD2PZGcQ8r6pWX6WgzsZpuly2
         Y13RemAdf9F4DRDIwJwIejxghkSc+Y2AfrkI4Vx7PoC5qeZU+Qf7HNZvcJ4V7Kxh8fV2
         bOqumy709LzeEC4OTpcfBTN/lDNOI/2E/6di13rTGaw4AbaUQy8RNtYsuIuy7rNKwj8c
         m2B8geMxf4g8/7+7XbItO4Fpm0Ap3JZbZ+uT6HYR8L41HOJwDWBjG1mxm9SxYWJy82Fw
         ZcKA==
X-Gm-Message-State: AOAM5312SY6OWmJMEXNk6QBI5qXkYTrrvJnKq6jzVO8NYpxwnQvd8zSg
        bsNdvXA890jnVbl6iG2SWqCYJq5oqp5loNDP5rwvgAi+CgnaOg==
X-Google-Smtp-Source: ABdhPJwL0agTDPSK7vFLX8XzeHMr2QoOJ7hDDsr64XcQo0TmjAfJ2TfzmDpeAzhRF24uCh6vDZyTPiRJMzbVY9RSfFM=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr28229261ybe.403.1607410141361;
 Mon, 07 Dec 2020 22:49:01 -0800 (PST)
MIME-Version: 1.0
References: <20201207052057.397223-1-saeed@kernel.org> <CAEf4BzZe2162nMsamMKkGRpR_9hUnaATWocE=XjgZd+2cJk5Jw@mail.gmail.com>
 <76aa0d16e3d03cf12496184c848f60069bf71872.camel@kernel.org>
 <CAEf4BzYzJuPt8Fct2pOTPjHLiiyGPQw05rFNK4d+MAJTC_itkw@mail.gmail.com> <5a86df89822ba7e4d944867916423c46ad4b7434.camel@kernel.org>
In-Reply-To: <5a86df89822ba7e4d944867916423c46ad4b7434.camel@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Dec 2020 22:48:50 -0800
Message-ID: <CAEf4BzZYfaC0v8ewDyQHz9JNL-w8bJazAJmuweuH=zif-RUy3Q@mail.gmail.com>
Subject: Re: [PATCH bpf] tools/bpftool: Add/Fix support for modules btf dump
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 10:45 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On Mon, 2020-12-07 at 22:38 -0800, Andrii Nakryiko wrote:
> > On Mon, Dec 7, 2020 at 10:26 PM Saeed Mahameed <saeed@kernel.org>
> > wrote:
> > > On Mon, 2020-12-07 at 19:14 -0800, Andrii Nakryiko wrote:
> > > > On Sun, Dec 6, 2020 at 9:21 PM <saeed@kernel.org> wrote:
> > > > > From: Saeed Mahameed <saeedm@nvidia.com>
> > > > >
> [...]
> > > > >
> > > > > I am not sure why this hasn't been added by the original
> > > > > patchset
> > > >
> > > > because I never though of dumping module BTF by id, given there
> > > > is
> > > > nicely named /sys/kernel/btf/<module> :)
> > > >
> > >
> > > What if i didn't compile my kernel with SYSFS ? a user experience
> > > is a
> > > user experience, there is no reason to not support dump a module
> > > btf by
> > > id or to have different behavior for different BTF sources.
> >
> > Hm... I didn't claim otherwise and didn't oppose the feature, why the
> > lecture about user experience?
> >
>
> Sorry wasn't a lecture, just wanted to emphasize the motivation.
>
> > Not having sysfs is a valid point. In such cases, if BTF dumping is
> > from ID and we see that it's a module BTF, finding vmlinux BTF from
> > ID
> > makes sense.
> >
> > > I can revise this patch to support -B option and lookup vmlinux
> > > file if
> > > not provided for module btf dump by ids.
> >
> > yep
> >
> > > but we  still need to pass base_btf to btf__get_from_id() in order
> > > to
> > > support that, as was done for btf__parse_split() ... :/
> >
> > btf__get_from_id_split() might be needed, yes.
> >
> > > Are you sure you don't like the current patch/libbpf API ? it is
> > > pretty
> > > straight forward and correct.
> >
> > I definitely don't like adding btf_get_kernel_id() API to libbpf.
> > There is nothing special about it to warrant adding it as a public
> > API. Everything we discussed can be done by bpftool.
> >
>
> What about the case where sysfs isn't available ?
> we still need to find vmlinux's btf id..

Right, but bpftool is perfectly capable of doing that without adding
APIs to libbpf. That's why I wrote above:

  > > Not having sysfs is a valid point. In such cases, if BTF dumping is
  > > from ID and we see that it's a module BTF, finding vmlinux BTF from
  > > ID
  > > makes sense.

>
>
>
