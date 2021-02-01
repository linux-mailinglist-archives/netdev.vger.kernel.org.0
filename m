Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C634C30B131
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 21:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbhBAUB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 15:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232970AbhBAUBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 15:01:34 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC90C061788
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 12:00:53 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id l9so26351758ejx.3
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 12:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f0tXe4AWrAn0r+44UyOKkZLPKxkqRxzW9CD7J1bYG6k=;
        b=Q4SQo+Jmw5A5MkCzT5/NrDVsVxnHJmtkxRIa+erLCJ+D8soAm8QEcmOHc7HhDDXHkL
         f1K/SGDS2wQvkVAhAfLbHynEDBacX5UKf7tUpTxttK9REoRxDe2j0sZRJxvXXgk4Vv1m
         zAewnkjM59Vh9nvZbseW8Ypf9Lay72QoEkdcnB+dZOGt0U1Swc76aI9Yv74f1b2PNdap
         3LMkgHqxOYjS57fZxDUF9bX3Ww+vTn5/NY4uO+qxaNg1EqaimBxPCY2L4CZ5FOO3m3GJ
         e4dnpYtVtA3Cs9HZNXIdT1EGGbDi/6yZDSTX03/zekBvKshJ+CtKTPN/s4EfJTacC8Rw
         /ANQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f0tXe4AWrAn0r+44UyOKkZLPKxkqRxzW9CD7J1bYG6k=;
        b=dwi1hCAN4R9HD0Rv/m9216Ed+a6mRvCK2AcfswKmTuLlSTHadH4fBg6lStOQZ1EJuU
         fC/Lq49bVLPX/jVanKEU80Qm8r3iM2mZw11seUgZVJ8PkT4S5gpf4IuqrtZGeO2U4naZ
         IgwTFbuNrJCvdiz4LkC/R6qY1NQWvYo9bnB8Y1hkMoYMsgIhM9xmDQqpenRmiSqO59OM
         grtZG1UuStAV3EdKKpWaAycrCJQpbMZRgUbcEub8KpBqC9dbo+HOF5KXEkDAaz3Jp3Oi
         Rj9NG6ZFn9iYscqmEypPak0g4JA3u/XYFRz4JWlIPuYzh1qi1my1OKz+eDDYezOCQwb3
         w6bw==
X-Gm-Message-State: AOAM533kjKEvrmK2eV+EcVi9zuFItNglV/IE2bnf3EF3ioeOkLTfDfkw
        rZ6ug4G63y19kr+EBzd4Z13jwC+esyS5qFwQ86Xs7w==
X-Google-Smtp-Source: ABdhPJxnsK3shUePIHt+JO+OpiYVaQ//vWk6ZQzaF1AD3mpl8h9jv4/biHijtRU+3SXtYf6Db9inaVIGlxE6FXJGQeY=
X-Received: by 2002:a17:907:a06f:: with SMTP id ia15mr19434321ejc.328.1612209651870;
 Mon, 01 Feb 2021 12:00:51 -0800 (PST)
MIME-Version: 1.0
References: <1611766877-16787-1-git-send-email-loic.poulain@linaro.org>
 <1611766877-16787-3-git-send-email-loic.poulain@linaro.org>
 <20210129182108.771dc2fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <0bd01c51c592aa24c2dabc8e3afcbdbe9aa23bdc.camel@redhat.com>
 <CAMZdPi_-b9GWrOcj8GBX8jnxyZN9WZ6nr9KPzXPZZKWfyPW3sQ@mail.gmail.com> <408a5a3589c2acbe59824a8dbee8cbcd2afefbf4.camel@redhat.com>
In-Reply-To: <408a5a3589c2acbe59824a8dbee8cbcd2afefbf4.camel@redhat.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 1 Feb 2021 21:08:00 +0100
Message-ID: <CAMZdPi8vBuFz-K8hVgvaKMw8ve=4w3wm7oQwV18XqZzCyHDXag@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: mhi: Add mbim proto
To:     Dan Williams <dcbw@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?Q2FybCBZaW4o5q635byg5oiQKQ==?= <carl.yin@quectel.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 at 19:53, Dan Williams <dcbw@redhat.com> wrote:
>
> On Mon, 2021-02-01 at 19:27 +0100, Loic Poulain wrote:
> > On Mon, 1 Feb 2021 at 19:17, Dan Williams <dcbw@redhat.com> wrote:
> > > On Fri, 2021-01-29 at 18:21 -0800, Jakub Kicinski wrote:
> > > > On Wed, 27 Jan 2021 18:01:17 +0100 Loic Poulain wrote:
> > > > > MBIM has initially been specified by USB-IF for transporting
> > > > > data
> > > > > (IP)
> > > > > between a modem and a host over USB. However some modern modems
> > > > > also
> > > > > support MBIM over PCIe (via MHI). In the same way as
> > > > > QMAP(rmnet),
> > > > > it
> > > > > allows to aggregate IP packets and to perform context
> > > > > multiplexing.
> > > > >
> > > > > This change adds minimal MBIM support to MHI, allowing to
> > > > > support
> > > > > MBIM
> > > > > only modems. MBIM being based on USB NCM, it reuses some
> > > > > helpers
> > > > > from
> > > > > the USB stack, but the cdc-mbim driver is too USB coupled to be
> > > > > reused.
> > > > >
> > > > > At some point it would be interesting to move on a factorized
> > > > > solution,
> > > > > having a generic MBIM network lib or dedicated MBIM netlink
> > > > > virtual
> > > > > interface support.
> > >
> > > What would a kernel-side MBIM netlink interface do?  Just data-
> > > plane
> > > stuff (like channel setup to create new netdevs), or are you
> > > thinking
> > > about control-plane stuff like APN definition, radio scans, etc?
> >
> > Just the data-plane (mbim encoding/decoding/muxing).
>
> Ah yes :) If so, then fully agree.
>
> But is that really specific to MBIM? eg, same kinds of things happen
> for QMI. Johannes referred to a more generic WWAN framework that we had
> discussed 1.5+ years ago to address these issues. Might be worth
> restarting that, perhaps simplifying, and figuring out the minimal set
> of generic bits needed to describe/add/delete a data channel for WWAN
> control protocols.
> Dan
>

Right, it's not specific to MBIM, it would be just about decoupling
protocol from transport (though MBIM is originally specified with USB
transport). Having a WWAN framework/subsystem would indeed make sense,
at least to structure the way all modems services/channels are exposed
and grouped (today we have netdev, chardev, tty, etc) but it's far
beyond this series, I'm not against restarting the discussion though.

Regards,
Loic
