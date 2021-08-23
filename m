Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E9A3F5331
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 00:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbhHWWJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 18:09:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229800AbhHWWJV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 18:09:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40270613CD;
        Mon, 23 Aug 2021 22:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629756518;
        bh=/UczgWwigc1TOQ0MtIShvCxZpfCTa18aq1rdTT2fNyg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jLW5BSFNUEyvl25xy68xdaRmbDWuPAz7zNzdB6Nygeqqz/iaK8wWhust/rWdROcXI
         Iou/RGWfAhtFVSVwsav/vZlqsVxgH4bMtP68fTAkBp6WwfRggsqm9DxAHqn/EP1T8u
         Bw8PTvjZ3qPtmVYu23EvCqz1HNMzmRsreO0EP1ZMYyP47/Ole9x/VXNmD+pmrjkThg
         RF5Je730VIJfzv3CIfbPELn/o5CtBRi8S+MJ/SgNRfTJj+g2b/u4/DISHpoaFO9246
         KUxVeNuxIsCJ6lG60NUnHaZmp5CVhjTGFVshw9k8ohcLGhCwzqKfJswG02lbcAkNYT
         ZEIrXmH6tOyJA==
Received: by mail-ed1-f44.google.com with SMTP id q17so6588336edv.2;
        Mon, 23 Aug 2021 15:08:38 -0700 (PDT)
X-Gm-Message-State: AOAM5329SoJ8vWVWgC9K8Eqc2KHHSZwnTJyawcjxpJvdDMKsNJezEDIQ
        +5m3YY+6WhP3EdV7u2am1/6W+60X5pIDNwIJHA==
X-Google-Smtp-Source: ABdhPJy5+meB7jw8V1qyuzca3p+iwjIy9KKZwNe2E7gMCzT2w3EAMENGdDsXcVPOwbQQyVGQB//EYd6Vr/FSexqiARU=
X-Received: by 2002:a05:6402:1215:: with SMTP id c21mr39845422edw.137.1629756516853;
 Mon, 23 Aug 2021 15:08:36 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210823120849eucas1p11d3919886444358472be3edd1c662755@eucas1p1.samsung.com>
 <20210818021717.3268255-1-saravanak@google.com> <0a2c4106-7f48-2bb5-048e-8c001a7c3fda@samsung.com>
 <CAGETcx_xJCqOWtwZ9Ee2+0sPGNLM5=F=djtbdYENkAYZa0ynqQ@mail.gmail.com>
 <YSP91FfbzUHKiv+L@lunn.ch> <CAGETcx8j+bOPL_-qFzHHJkX41Ljzq8HBkbBqtd4E0-2u6a3_Hg@mail.gmail.com>
In-Reply-To: <CAGETcx8j+bOPL_-qFzHHJkX41Ljzq8HBkbBqtd4E0-2u6a3_Hg@mail.gmail.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 23 Aug 2021 17:08:25 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKXR=Kkx+yKcYv7R3uAeff_HLKSPGr5Y2RBC_=VJmypJQ@mail.gmail.com>
Message-ID: <CAL_JsqKXR=Kkx+yKcYv7R3uAeff_HLKSPGr5Y2RBC_=VJmypJQ@mail.gmail.com>
Subject: Re: [PATCH v2] of: property: fw_devlink: Add support for "phy-handle" property
To:     Saravana Kannan <saravanak@google.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Frank Rowand <frowand.list@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 3:49 PM Saravana Kannan <saravanak@google.com> wrote:
>
> On Mon, Aug 23, 2021 at 12:58 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > PHY seems to be one of those cases where it's okay to have the
> > > compatible property but also okay to not have it.
> >
> > Correct. They are like PCI or USB devices. You can ask it, what are
> > you? There are two registers in standard locations which give you a
> > vendor and product ID. We use that to find the correct driver.
>
> For all the cases of PHYs that currently don't need any compatible
> string, requiring a compatible string of type "ethernet-phy-standard"
> would have been nice. That would have made PHYs consistent with the
> general DT norm of "you need a compatible string to be matched with
> the device". Anyway, it's too late to do that now. So I'll have to
> deal with this some other way (I have a bunch of ideas, so it's not
> the end of the world).

This is not the first time the need for compatible strings for MDIO
devices has come up, but MDIO devices are special (evidently). I
should have taken a harder stance on this which should be simply, if
your device requires having a node in DT, then it requires a
compatible string.

Rob
