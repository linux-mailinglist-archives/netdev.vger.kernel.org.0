Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB70321396E
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 13:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgGCLiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 07:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgGCLiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 07:38:00 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D422C08C5DE
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 04:38:00 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id n24so24249376otr.13
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 04:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dyp1m58oAyQtsHXm22tL6xxuBEsc0oVbE4YcBDP5SuA=;
        b=gwcpJzWtocnEZpNrUX3T+fJGP8MREn3ffK4uAC5bYVo/jo2LcOKAEIK0I56mXw8Yf+
         PTWj6fZ2LirhELghw8oVXWL24pbM7Ghp/9E4BY1cpElUCsZf3tCd+CEBZho0wKzMjpWM
         6Fq1fH+kMkTB1zHXgu3MlJ+iHmVMN+UxjjRJz4Ugccu5hkhDK+EF3rfHExECUg7hRYBn
         HLtpMtFVIACf/JkE2ur7k0QK7NJ3+AL5jFSjXMKHgQZlgvEYjq+aPznKfFHnvkY1shaL
         jaUUgtdQgbFhI8J6NuwfDwXiyH2i1Hxkm6oB34xlbZYhR15Udv/Nk9yIrWCWxoTO8cL+
         xzxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dyp1m58oAyQtsHXm22tL6xxuBEsc0oVbE4YcBDP5SuA=;
        b=Bjx7kdr9hIV/gNiaa9Zjtks1wFygDyUq3I8YswF8Gps6IHnHsKndsimr4YBr8bJvOf
         o0mlANzaj5c1kwBo3ZThiP7QOmVsF1yqLCi3DKEGttZfZlLtqP87VFrVWvWxQpLu647r
         v4vXELNiPG/VjF47yeQctEtoQ2IkURvbqNDQwd2GtWGIXPWZHO7aWjC7mAxwK+Fs9wmu
         rlMxBortYx/0Feb37ZoklKj/El56NVDgmOzNqARO4NS50ZmyAUeYxM3TlqoZ5xVb06Wt
         HT8qK8dknIapyIzNt9DWu3nkJVnpnkzb2D7PTDqhlVYoeZMHffzotCZ3bKn7sGph1xPW
         XIwA==
X-Gm-Message-State: AOAM533YgK1RJZo3yOLI5V9NPgcheFaxNgIY5RzsXeH5hRoKrAg4lwfb
        nlB/6NBC38+3tHNBT6sfEg1OsGqcvnXsMO8PGQA7lA==
X-Google-Smtp-Source: ABdhPJy8b53E4/ch5xCgMcf3cIE+8dqAJ1flSUnTR++fzzjUTdp0KDGByy6n2PThI12LZgWutzc4FGsaIDtXmwNDXqo=
X-Received: by 2002:a05:6830:18f6:: with SMTP id d22mr13766166otf.243.1593776279661;
 Fri, 03 Jul 2020 04:37:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200702103001.233961-1-robert.marko@sartura.hr>
 <20200702103001.233961-3-robert.marko@sartura.hr> <e4921b83-0c80-65ad-6ddd-be2a12347d9c@gmail.com>
In-Reply-To: <e4921b83-0c80-65ad-6ddd-be2a12347d9c@gmail.com>
From:   Robert Marko <robert.marko@sartura.hr>
Date:   Fri, 3 Jul 2020 13:37:48 +0200
Message-ID: <CA+HBbNHbyS3viFc90KDWW=dwkA9yRSuQ15fg9EzApmrP8JSR3Q@mail.gmail.com>
Subject: Re: [net-next,PATCH 2/4] net: mdio-ipq4019: add clock support
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        robh+dt@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 9:59 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 7/2/2020 3:29 AM, Robert Marko wrote:
> > Some newer SoC-s have a separate MDIO clock that needs to be enabled.
> > So lets add support for handling the clocks to the driver.
> >
> > Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> > ---
> >  drivers/net/phy/mdio-ipq4019.c | 28 +++++++++++++++++++++++++++-
> >  1 file changed, 27 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/phy/mdio-ipq4019.c b/drivers/net/phy/mdio-ipq4019.c
> > index 0e78830c070b..7660bf006da0 100644
> > --- a/drivers/net/phy/mdio-ipq4019.c
> > +++ b/drivers/net/phy/mdio-ipq4019.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/iopoll.h>
> >  #include <linux/of_address.h>
> >  #include <linux/of_mdio.h>
> > +#include <linux/clk.h>
> >  #include <linux/phy.h>
> >  #include <linux/platform_device.h>
> >
> > @@ -24,8 +25,12 @@
> >  #define IPQ4019_MDIO_TIMEOUT 10000
> >  #define IPQ4019_MDIO_SLEEP           10
> >
> > +#define QCA_MDIO_CLK_DEFAULT_RATE    100000000
>
> 100MHz? Is not that going to be a tad too much for most MDIO devices out
> there?
This is not the actual MDIO bus clock, that is the clock frequency
that SoC clock generator produces.
MDIO controller has an internal divider set up for that 100MHz, I
don't know the actual MDIO bus clock
frequency as it's not listed anywhere.
> --
> Florian
