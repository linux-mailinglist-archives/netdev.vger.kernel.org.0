Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9EF1FCC68
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 13:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgFQLcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 07:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgFQLcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 07:32:22 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096A5C061573
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 04:32:22 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id k8so1668188edq.4
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 04:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nfbmmuhZ1Ils/7SqoM25z4huCwIsjLlmdoRG7aHfHVE=;
        b=sB7n2nYs7YpdAV29qHe0ofg1/oQIDoQcROA2t+Y3vlm00PUzSfAEFaK2mD0uRegcf2
         p1RxelrwcKvfJYElLPk9a1ZWjZ/rX0io8rMTXUsneVBBKds/vt4Tep5gRv+JFdeb62QF
         zxIJDM+nCi6NMh2840kx5B3MCm17nTFugvtRXWNjVhCENlRD+5UIuKHBJgx9fsevHuz2
         lOpLaoAYAkztk9MMxusr+lTEj9jh8XJ1M/4pk+QpxN/ILjvHDbk5NyCUjlAt85BT7Oxb
         or48NVF6L7wBzOWOhhhUULiR9g7remB8UcqOaVG5K73odmhmKrccJEIyjW4LJYjueu/c
         Aj3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nfbmmuhZ1Ils/7SqoM25z4huCwIsjLlmdoRG7aHfHVE=;
        b=lzzTJ1QuoFJ1InhP7k5dO5sTCjY9JEnZlyIeZhbSBVFHBN0AAodaaEKhy++ovDa+GU
         YTucQai+9+V7mM325T6cSh5DRUr9g3i0bE3QJfqp9RJUAEpMYtrgYAquoOC25cyA6elb
         at5g2r7AJlMby0ZEm2yF/QpBgMFuq/4bde6YF6vZE3V0F/o8a2/oDCMB6YE1zNJw6N7p
         8gikvzR/mA50w4+QGTtBXjqbm1i+4I62HgWgi5un+tZsqfsvCCFb1tv1xo5PlT4VvcBh
         UvD2onKzfNcaCuSeMeiPnsHW9T05P3h0ttjDCFDwK5zmyV8ejVC3UWIEkp60WiHUtlLy
         wY2A==
X-Gm-Message-State: AOAM533vLhtUZUyfbPshxs8QrpzFuo+bgdX8yb0mGfIEObHFJXDxHIfS
        lXbLLZRTIeRhbX7Qd8w/pbOXMtkOYvxu/e1Pn7I=
X-Google-Smtp-Source: ABdhPJx06eMzzgyQj5sVIAKLOg0cDmTqVazkB1AF0dnk31YGzozSKCcuetRnjdK7VmjBein59Qg8AzR0xygUJlSZXyY=
X-Received: by 2002:a05:6402:362:: with SMTP id s2mr6908368edw.337.1592393540713;
 Wed, 17 Jun 2020 04:32:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200616074955.GA9092@laureti-dev> <20200617105518.GO1551@shell.armlinux.org.uk>
In-Reply-To: <20200617105518.GO1551@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 17 Jun 2020 14:32:09 +0300
Message-ID: <CA+h21hotpF58RrKsZsET9XT-vVD3EHPZ=kjQ2mKVT2ix5XAt=A@mail.gmail.com>
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Helmut Grohne <helmut.grohne@intenta.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020 at 13:56, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Tue, Jun 16, 2020 at 09:49:56AM +0200, Helmut Grohne wrote:
> > The macb driver does not support configuring rgmii delays. At least for
> > the Zynq GEM, delays are not supported by the hardware at all. However,
> > the driver happily accepts and ignores any such delays.
> >
> > When operating in a mac to phy connection, the delay setting applies to
> > the phy. Since the MAC does not support delays, the phy must provide
> > them and the only supported mode is rgmii-id.  However, in a fixed mac
> > to mac connection, the delay applies to the mac itself. Therefore the
> > only supported rgmii mode is rgmii.
>
> This seems incorrect - see the phy documentation in
> Documentation/networking/phy.rst:
>
> * PHY_INTERFACE_MODE_RGMII: the PHY is not responsible for inserting any
>   internal delay by itself, it assumes that either the Ethernet MAC (if capable
>   or the PCB traces) insert the correct 1.5-2ns delay
>
> * PHY_INTERFACE_MODE_RGMII_TXID: the PHY should insert an internal delay
>   for the transmit data lines (TXD[3:0]) processed by the PHY device
>
> * PHY_INTERFACE_MODE_RGMII_RXID: the PHY should insert an internal delay
>   for the receive data lines (RXD[3:0]) processed by the PHY device
>
> * PHY_INTERFACE_MODE_RGMII_ID: the PHY should insert internal delays for
>   both transmit AND receive data lines from/to the PHY device
>
> Note that PHY_INTERFACE_MODE_RGMII, the delay can be added by _either_
> the MAC or by PCB trace routing.
>

What does it mean "can" be added? Is it or is it not added? As a MAC
driver, what do you do?

> The individual RGMII delay modes are more about what the PHY itself is
> asked to do with respect to inserting delays, so I don't think your
> patch makes sense.
>

We all read the phy-mode documentation, but we aren't really any
smarter. That document completely fails to address the existence of
PCB traces.
Helmut's link points to some more discussion around this topic.

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
