Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF3D017439B
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 00:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgB1XyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 18:54:08 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:34376 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbgB1XyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 18:54:07 -0500
Received: by mail-yw1-f67.google.com with SMTP id o186so811188ywc.1
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 15:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TJ5ojO5Np681CC2oVjkjjG2+Xs87TvHsctuTnLocErE=;
        b=ehrEFKSdeYbf6yWDD3UNYs5YoO/BagSQOxMGt/C8jtA9S87UmtPg9QdS6qmoGIYcFg
         hoMBxfPCo4d+JoXNyfWoNoo5zJ1Gj96gHrmfbJP8KlQ6NhnXAkR23ZbaUifBglOIzsys
         RgeEL/VdfJx8nSTQHLdX2QIMcZa4HiTJxw2Gd2FN8lQiCpR1ODw2OwntVvK84LJQxDh+
         9+gTR0Ub0boZZ23v/aCJn037knAlRODVEtAdZOYQ5Np4wc10rDVhq1QVzynxrbwszcaF
         6MLkPAzybGOVgtkUAdQiAJhubHcuUP/+LMV22GahmBRdGSulNAQsSaEXV1fsCbSovVjq
         SLIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TJ5ojO5Np681CC2oVjkjjG2+Xs87TvHsctuTnLocErE=;
        b=ovrqANJ8H2pwhtondN5E7Gk6HJ9UH0VcA5OuMQ/akcjCONYPsMDBe2bwF4W+vThc62
         H9jrymAnyOEw/RDbOp4eAGCNuJ3i0Hg1YqUGr+w7Uof3VDd3dY8XUW63Q5ZIY/GZ32bJ
         4EXaEO+kA7HgGhviYx3UO8B2GABeQ2+n7USA/OLgvqDz2MHH9PoYCU7zbYlvk1+Az8Wd
         lZWZdWMd4/bK2ITJlelzSeqIvgd7EHxcWRfMzfv0hpDYckC32X/jj+21G4zmqgDpVbOH
         i6tFk/8aKIt+e82Ug4MmcMN+tVqLNhSBtNscA8mCnNj9s5TF3QkaTZzeEmIeaJzGjWtK
         eewQ==
X-Gm-Message-State: APjAAAWX3cW+9FoNyX7YxVzoZxvUNs5hoFYm4C+VPLRIPr8KfopbZvrj
        VaVlqLtUkGFWFEjV25HrwcUgkiDW
X-Google-Smtp-Source: APXvYqxFquSgauIuj2mG6lxxA5tGhsGLGk1fQj+n8fLmaN9h/8u1fSiuwH0+G3XAuIGCb+9D2snb8g==
X-Received: by 2002:a25:cc15:: with SMTP id l21mr6216207ybf.385.1582934045792;
        Fri, 28 Feb 2020 15:54:05 -0800 (PST)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id g190sm4554854ywf.41.2020.02.28.15.54.04
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 15:54:04 -0800 (PST)
Received: by mail-yw1-f43.google.com with SMTP id u78so273528ywf.10
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 15:54:04 -0800 (PST)
X-Received: by 2002:a81:6588:: with SMTP id z130mr6419395ywb.355.1582934043863;
 Fri, 28 Feb 2020 15:54:03 -0800 (PST)
MIME-Version: 1.0
References: <20200228105435.75298-1-lrizzo@google.com> <20200228110043.2771fddb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200228110043.2771fddb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 28 Feb 2020 18:53:27 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfd80pZroxtqZDsTeEz4FaronC=pdgjeaBBfYqqi5HiyQ@mail.gmail.com>
Message-ID: <CA+FuTSfd80pZroxtqZDsTeEz4FaronC=pdgjeaBBfYqqi5HiyQ@mail.gmail.com>
Subject: Re: [PATCH v4] netdev attribute to control xdpgeneric skb linearization
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Luigi Rizzo <lrizzo@google.com>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        David Miller <davem@davemloft.net>, hawk@kernel.org,
        "Jubran, Samih" <sameehj@amazon.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 2:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 28 Feb 2020 02:54:35 -0800 Luigi Rizzo wrote:
> > Add a netdevice flag to control skb linearization in generic xdp mode.
> >
> > The attribute can be modified through
> >       /sys/class/net/<DEVICE>/xdpgeneric_linearize
> > The default is 1 (on)
> >
> > Motivation: xdp expects linear skbs with some minimum headroom, and
> > generic xdp calls skb_linearize() if needed. The linearization is
> > expensive, and may be unnecessary e.g. when the xdp program does
> > not need access to the whole payload.
> > This sysfs entry allows users to opt out of linearization on a
> > per-device basis (linearization is still performed on cloned skbs).
> >
> > On a kernel instrumented to grab timestamps around the linearization
> > code in netif_receive_generic_xdp, and heavy netperf traffic with 1500b
> > mtu, I see the following times (nanoseconds/pkt)
> >
> > The receiver generally sees larger packets so the difference is more
> > significant.
> >
> > ns/pkt                   RECEIVER                 SENDER
> >
> >                     p50     p90     p99       p50   p90    p99
> >
> > LINEARIZATION:    600ns  1090ns  4900ns     149ns 249ns  460ns
> > NO LINEARIZATION:  40ns    59ns    90ns      40ns  50ns  100ns
> >
> > v1 --> v2 : added Documentation
> > v2 --> v3 : adjusted for skb_cloned
> > v3 --> v4 : renamed to xdpgeneric_linearize, documentation
> >
> > Signed-off-by: Luigi Rizzo <lrizzo@google.com>
>
> Just load your program in cls_bpf. No extensions or knobs needed.
>
> Making xdpgeneric-only extensions without touching native XDP makes
> no sense to me. Is this part of some greater vision?

Yes, native xdp has the same issue when handling packets that exceed a
page (4K+ MTU) or otherwise consist of multiple segments. The issue is
just more acute in generic xdp. But agreed that both need to be solved
together.

Many programs need only access to the header. There currently is not a
way to express this, or for xdp to convey that the buffer covers only
part of the packet.
