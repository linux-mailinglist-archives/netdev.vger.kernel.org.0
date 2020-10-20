Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624832936FA
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 10:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389448AbgJTIsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 04:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389337AbgJTIsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 04:48:04 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398C9C061755
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 01:48:04 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h5so1096562wrv.7
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 01:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LXyAg9hcDD8VFPSdZOXejRQpIbfpi1YJ4IZqycAiC4I=;
        b=awFwRfUikFbE0LrmYKXiQdTIhY/teG2EAUOOp4HH+ihN/XGig7mlnYI5z5gRPJCc3Y
         rfeu23On8Eh7xTCJ5Lcb8T4zwE3ZQUxdfz3fbUYRShAHEKPgkRLA17WcWkB/OMFHyf5p
         aQTC3OTnaB/0pQkbY1FRKrPZIxMEAbEFZQbURkmwlm2Qq2y4KyqQ4LpvyB1MtwFeLmpN
         HeO4eKDB4oliUWQhPCqABrh9PQfargDQqVwl9DyuQVzRB6MLTjmFxFq4TVwNjtD6CvAr
         6QcQ7BrwOGNQKFUzpebQThHSYz2UsXTuQfxiKCyuzfq8eJe1pOIRgPytet3pkilL1U0N
         cOzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LXyAg9hcDD8VFPSdZOXejRQpIbfpi1YJ4IZqycAiC4I=;
        b=o6KNBMqBVSKbzDPeshamuE4SDJJ32EitXlaHulf49qgPox8b2cYwPBLYG8C7nd9vAk
         6P57lVpP0frPyje4CSMkXTLxuy4O74/zsbMRyKq2JUdPnwLsynEY4lJkvHpUPTRwY2rt
         czOMTy1+CXNQfwjonPuDg6N2SXmofNATjlhWuPLxjiIiW2C6hOeeNlR3k4lFoiQbr4rw
         cmIeQexR7mJEQmA3MNTLFoEkn7+XD9kbpW1fV4OfBpPJaBku1HomKZ6fqgziXiWyPDWE
         5ger0aRvcFiPW2UTFUKfyUG7Mlj95/eMOU7L3dV62QZJX98wX8DiiCqseoxO5tZQ6D0T
         hHiw==
X-Gm-Message-State: AOAM532MsipovNDyTLdCK6uG8hK5RLksy5GOyEvEix9lvDaywj1AmOe/
        xRQ8MMwXgNgvq5DYB2QM2sZwIQ==
X-Google-Smtp-Source: ABdhPJyKjr2tTwnUbmqSxstyUCPQVPzkaOKs3cIY8TIHg8EpU2DTLNqT9e4sTKkMBaltYNJ1BJiwJA==
X-Received: by 2002:a5d:4e8d:: with SMTP id e13mr2215445wru.368.1603183682935;
        Tue, 20 Oct 2020 01:48:02 -0700 (PDT)
Received: from apalos.home (athedsl-246545.home.otenet.gr. [85.73.10.175])
        by smtp.gmail.com with ESMTPSA id i10sm2124614wrq.27.2020.10.20.01.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 01:48:02 -0700 (PDT)
Date:   Tue, 20 Oct 2020 11:47:59 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Jassi Brar <jaswinder.singh@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Serge Semin <fancer.lancer@gmail.com>
Subject: Re: [PATCH net] netsec: ignore 'phy-mode' device property on ACPI
 systems
Message-ID: <20201020084759.GA1837463@apalos.home>
References: <20201018163625.2392-1-ardb@kernel.org>
 <20201018175218.GG456889@lunn.ch>
 <20201018203225.GA1790657@apalos.home>
 <CAMj1kXEtLx_5_Hyuk=nU6PhnYZm3F33uWGiRHH2Yb3X2ENxRSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEtLx_5_Hyuk=nU6PhnYZm3F33uWGiRHH2Yb3X2ENxRSw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ard, 

On Mon, Oct 19, 2020 at 08:30:45AM +0200, Ard Biesheuvel wrote:
> On Sun, 18 Oct 2020 at 22:32, Ilias Apalodimas
> <ilias.apalodimas@linaro.org> wrote:
> >
> > On Sun, Oct 18, 2020 at 07:52:18PM +0200, Andrew Lunn wrote:
> > > > --- a/Documentation/devicetree/bindings/net/socionext-netsec.txt
> > > > +++ b/Documentation/devicetree/bindings/net/socionext-netsec.txt
> > > > @@ -30,7 +30,9 @@ Optional properties: (See ethernet.txt file in the same directory)
> > > >  - max-frame-size: See ethernet.txt in the same directory.
> > > >
> > > >  The MAC address will be determined using the optional properties
> > > > -defined in ethernet.txt.
> > > > +defined in ethernet.txt. The 'phy-mode' property is required, but may
> > > > +be set to the empty string if the PHY configuration is programmed by
> > > > +the firmware or set by hardware straps, and needs to be preserved.
> > >
> > > In general, phy-mode is not mandatory. of_get_phy_mode() does the
> > > right thing if it is not found, it sets &priv->phy_interface to
> > > PHY_INTERFACE_MODE_NA, but returns -ENODEV. Also, it does not break
> > > backwards compatibility to convert a mandatory property to
> > > optional. So you could just do
> > >
> > >       of_get_phy_mode(pdev->dev.of_node, &priv->phy_interface);
> > >
> > > skip all the error checking, and document it as optional.
> >
> > Why ?
> > The patch as is will not affect systems built on any firmware implementations
> > that use ACPI and somehow configure the hardware.
> > Although the only firmware implementations I am aware of on upsteream are based
> > on EDK2, I prefer the explicit error as is now, in case a firmware does on
> > initialize the PHY properly (and is using a DT).
> >
> 
> We will also lose the ability to report bogus values for phy-mode this
> way, so I think we should stick with the check.

I hope Andrew is fine with the current changes

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
