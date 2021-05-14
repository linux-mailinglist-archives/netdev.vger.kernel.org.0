Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27204380CD6
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 17:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbhENP1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 11:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbhENP07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 11:26:59 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1532C061574;
        Fri, 14 May 2021 08:25:47 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id i4so39314158ybe.2;
        Fri, 14 May 2021 08:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vqCUlgEhU2vMEHObdxNGJkUzrl21MYKxGafI7N4a84s=;
        b=ClpN339cc1cnyFhsMokqbR+Pcw5ZIT88FYVY557pVaa609Kd9FBTClI0MRaUJbqZ8L
         aixexHzYPwcFd+6VjXVAFI+zJISkzIabGyaoQ1Aah1bH8CQHoDd0jaa3MH1nPxkABEpW
         f2FZdZUH6vCGoKnsjU8wFVLbu9B3TFQH463gd9bzYdknttYQtC58EksSl0aLzCuLS45C
         aySBwbkfF+bcgmfZH/rCPpxtLRVtai7eHAK1PGQ6NdmfGu3pQpIiDIddwDKrlcvibRWs
         CIpPwjIMurCbBccN+lGip53scfInyVoPz8266s2//0YbYCd4z6T3xXgM9VHaOVqw0GO0
         8yiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vqCUlgEhU2vMEHObdxNGJkUzrl21MYKxGafI7N4a84s=;
        b=eNG/lekjzp4pqLO9xItnvFxwMXRKIeb3dWaKPRImBT1VRiB3qrQiQxC82eD9eFt351
         lc7Tm8QiXLZrRcX4PtLEvbmLvkvKvCx3wcVlFdoXqDC45QI7/UsLa0fo3O6JqOrDWsvS
         Yilft3Lz5ITeNRlBWyvIaeSFv1mUJUd7Jc4FbCCUzyStlrRYv8VNvtVX72XmLKSMekHd
         zsAWsb/DxGYs1BgcPEgIhS4eulJJRuQVqMRe3Qhcboamn4GsJK4lDKsMC3Jo0ert/n2L
         sS/pzsLiuJ2XpP42aBeX+y98VtpH4qCSleb5Zw4W2Bl5MHT5OVcbjpFr8rzmB0rfds2H
         J1yw==
X-Gm-Message-State: AOAM531uVWUE1vLkEsZxwWHLbvyYTTXkmAxG3phAKiaCv5kHloYRSEZs
        G8OHsTWVQ71veYZD/8l4l/q8yVF1+tg/DY77nu5am7GGXm49NQ==
X-Google-Smtp-Source: ABdhPJx04DscHLr+Tp32e93DCe+zWPSXZGHy3f/l+WhpgVsCc4QIzwzlDQXs4nwHoYPjm8LgnhGO3dXA/+RgqApDaHQ=
X-Received: by 2002:a25:4d56:: with SMTP id a83mr57525294ybb.437.1621005946841;
 Fri, 14 May 2021 08:25:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210514115826.3025223-1-pgwipeout@gmail.com> <YJ56G23e930pg4Iv@lunn.ch>
 <CAMdYzYrSB0G7jfG9fo85X0DxVG_r-qaWUyVAa5paAW0ugLvoxw@mail.gmail.com> <YJ6OqpRTo+rlfb51@lunn.ch>
In-Reply-To: <YJ6OqpRTo+rlfb51@lunn.ch>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Fri, 14 May 2021 11:25:35 -0400
Message-ID: <CAMdYzYrdNqDZdkCj5Jf9+MmGtZgy263cYmwWkB3rZY02dPefYw@mail.gmail.com>
Subject: Re: [PATCH v3] net: phy: add driver for Motorcomm yt8511 phy
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 10:52 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > I also wonder about bits 15:12 of PHY EXT ODH: Delay and driver
> > > strength CFG register.
> >
> > The default value *works*, and from an emi perspective we want the
> > lowest strength single that is reliable.
>
> I was not meaning signal strength, but Txc_delay_sel_fe,
>
>   selecte tx_clk_rgmii delay in chip which is used to latch txd_rgmii
>   in 100BT/10BTe mode. 150ps step. Default value 15 means about 2ns
>   clock delay compared to txd_rgmii in typical cornor.
>
> [Typos courtesy of the datasheet, not me!]
>
> This sounds like more RGMII delays. It seems like PHY EXT 0CH is about
> 1G mode, and PHY EXT 0DH is about 10/100 mode. I think you probably
> need to set this bits as well. Have you tested against a link peer at
> 10 Half? 100 Full?

Good Catch!

Guess I'll have to set that too, anything else you'd recommend looking into?

>
>    Andrew
