Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC75321275
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 09:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhBVI55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 03:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhBVI5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 03:57:47 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B93C061574;
        Mon, 22 Feb 2021 00:57:07 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id n10so9815028pgl.10;
        Mon, 22 Feb 2021 00:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=asA/ItuewNg3IaZAJfPBjAM64gPw1m4pIHql4x7Kuio=;
        b=IWTV9+HGz0K2zdIVzHNUcTh6DWCQ3j1Wny8OfWn7zXAKSXh9LTxGlBLqxgYe/nQHQT
         ugNg+KPj7JloYQIiJjOsC1THr2+DX8oPRU1FrBdE4LPsGYVpr733MCBBw0pR0TcjSKbG
         Qv1EooV7Nl0lE+srKk6wuEo3ctOfOvubtJyU0pK+4iz4ESjLttuijI3t2w8OxQgzyyVC
         EMwgaPxr6umSDdLr0oq8bOZpGv+X5mrqaXk1hDynpBR5xQrPw0P2JrpEjuVG26HIK7Yb
         XK0kB3RTIv3MHZELpzMusTykJGAbnJC3h5+LOVkvWZh/ZBlXminZ8dbH4A/SwjYxAqIE
         2f/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=asA/ItuewNg3IaZAJfPBjAM64gPw1m4pIHql4x7Kuio=;
        b=q6JTdKl8Txx4IttCRVbeEVeoz6Eq9xE7LOkNrQJUFwi12TbjAw3Hw8uLAgFkOL+JOV
         4kf0DikrylLy/BRHCNV0laRqzsBey8mUeUKP3O0s3WjDi3l45pA1oAysXpOe6ebcrcu1
         vfWRkXjM6otMXvdSk+TfZBCA1h1WaXZxkLpNsiNL7gtF4CWHM0WoDlkgdF36M+boxUXU
         yd4anCMre7a2xt3pAzo/rbWzv2jcRc8a4QCS9g01EvFMMI7nSneuy8b4sppajUkiJ5AK
         Lm7D7nWWY9Ot8uz33As/z0ncJWsdaJjz9mEXkOkcdNBgVZB+8zMMEBK+P8/1KaET+sE9
         EqTw==
X-Gm-Message-State: AOAM530LHZDT5PqKtfKfe62cWpL6dFOD10rjLEHzv8xyAzxSrGjxGDR3
        55xsc/BqEloktnIo7dPg6vWEAk6UEC+TuZxwfvM=
X-Google-Smtp-Source: ABdhPJyFar9hcVrJw5G6ESx551HbJp+wWd1Ee9awynL0SbxLrNk71STdxQuORgAGTEhKmOtcAIJxfy8ptPZYJm8MMmk=
X-Received: by 2002:aa7:9ad2:0:b029:1e5:f0e6:2fcd with SMTP id
 x18-20020aa79ad20000b02901e5f0e62fcdmr21221070pfp.4.1613984226945; Mon, 22
 Feb 2021 00:57:06 -0800 (PST)
MIME-Version: 1.0
References: <20210216201813.60394-1-xie.he.0141@gmail.com> <YC4sB9OCl5mm3JAw@unreal>
 <CAJht_EN2ZO8r-dpou5M4kkg3o3J5mHvM7NdjS8nigRCGyih7mg@mail.gmail.com>
 <YC5DVTHHd6OOs459@unreal> <CAJht_EOhu+Wsv91yDS5dEt+YgSmGsBnkz=igeTLibenAgR=Tew@mail.gmail.com>
 <YC7GHgYfGmL2wVRR@unreal> <CAJht_EPZ7rVFd-XD6EQD2VJTDtmZZv0HuZvii+7=yhFgVz68VQ@mail.gmail.com>
 <CAJht_EPPMhB0JTtjWtMcGbRYNiZwJeMLWSC5hS6WhWuw5FgZtg@mail.gmail.com>
 <20210219103948.6644e61f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EOru3pW6AHN4QVjiaERpLSfg-0G0ZEaqU_hkhX1acv0HQ@mail.gmail.com> <906d8114f1965965749f1890680f2547@dev.tdt.de>
In-Reply-To: <906d8114f1965965749f1890680f2547@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 22 Feb 2021 00:56:56 -0800
Message-ID: <CAJht_EPBJhhdCBoon=WMuPBk-sxaeYOq3veOpAd2jq5kFqQHBg@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v4] net: hdlc_x25: Queue outgoing LAPB frames
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 21, 2021 at 11:14 PM Martin Schiller <ms@dev.tdt.de> wrote:
>
> I'm not really happy with this change because it breaks compatibility.
> We then suddenly have 2 interfaces; the X.25 routings are to be set via
> the "new" hdlc<x>_x25 interfaces instead of the hdlc<x> interfaces.
>
> I currently just don't have a nicer solution to fix this queueing
> problem either. On the other hand, since the many years we have been
> using the current state, I have never noticed any problems with
> discarded frames. So it might be more a theoretical problem than a
> practical one.

This problem becomes very serious when we use AF_PACKET sockets,
because the majority of frames would be dropped by the hardware
driver, which significantly impacts transmission speed. What I am
really doing is to enable adequate support for AF_PACKET sockets,
allowing users to use the bare (raw) LAPB protocol. If we take this
into consideration, this problem is no longer just a theoretical
problem, but a real practical issue.

If we don't want to break backward compatibility, there is another option:
We can create a new API for the HDLC subsystem for stopping/restarting
the TX queue, and replace all HDLC hardware drivers' netif_stop_queue
and netif_wake_queue calls with calls to this new API. This new API
would then call hdlc_x25 to stop/restart its internal queue.

But this option would require modifying all HDLC hardware drivers'
code, and frankly, not all HDLC hardware drivers' developers care
about running X.25 protocols on their hardware. So this would cause
both hardware driver instabilities and confusion for hardware driver
developers.
