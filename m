Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B442DF457
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 08:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgLTHu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 02:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbgLTHuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 02:50:23 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1CCC0613CF
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 23:49:40 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id 6so9215404ejz.5
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 23:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A22xGkuarplT6DM77+z2TR/niVmDd1acPTOJR9qrPwI=;
        b=ganNR8pFou//9DNyRhpOJ+HqIB1rseT6vyDOgT4xkaPj+C0DwPIBmc+9OK054mJZ8q
         9VBN1R2PbOsCQXLbiFyByR2ZFDfb0cVKHiG+q9NV7sJsNkHTpUWDJZWOZyUgSdyI8w/G
         1BSAiXnzO+bN0FxvJdM4l+dI2vIdO/mKyy1+d/UjbckzZ9dGyiGiRbOXXlfqXhupFzN/
         BbhvF2xeRLhb+BCJXOoni3rtqAVym/wjHy3rnYTKo9waw8o+uBnvPfwVmHL5XcCLft+T
         2BdMicR/V5WXYX21fnAqwmEUJjP2Ju4DQbaQUck73Gxawy9i8Q74UqJw9opEmJ011LqP
         B3Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A22xGkuarplT6DM77+z2TR/niVmDd1acPTOJR9qrPwI=;
        b=VQSPfevkQZQcKpZ6dR7hpe7TbIiBCWta/DawAV3gYqw7dZaN4uE5aJn9n0110jj4EB
         GVa+ob1tHgmQAXi1JcXos8V7KsCTbhtUmqyQtPCCRVgTbCYhVP7PEYm5wFNVuVZslfmH
         GSIvv2ar1b3Cnv3oYGPDqFFQBwOngawHPncrWFW0WOkrg42X55+XN/y8mn/DKZe3/qpU
         ZtHq8zNpvvo9PyBA8Xo2qFgki7gkMZ2TJKasV3d4VFSxro+e66lI4W1pI3dMJA1j0fXF
         AOygb6MmF7A9pJXbqJNR8LpYnw6VE2ipOOR/PSAVJIf3wIMoxhcRKwNs3ODuHqyk+AxR
         Qifw==
X-Gm-Message-State: AOAM5311r3uU7PF84uTFVMpfzEhDdpeelQkq8bewimLDdaQ3TqeNz3bB
        hm+A4ul0P9lU7I1DEboyWd0=
X-Google-Smtp-Source: ABdhPJxHoxa+ITZGEhggI+npHIxqq1FJ6HxRN8A97IlWp9ve3CXBm1o/8L4pLHK9jA3oVEOzi4mEwQ==
X-Received: by 2002:a17:906:f0c9:: with SMTP id dk9mr10982091ejb.51.1608450578929;
        Sat, 19 Dec 2020 23:49:38 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id i26sm7574335eja.23.2020.12.19.23.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 23:49:38 -0800 (PST)
Date:   Sun, 20 Dec 2020 09:49:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Ungerer <gerg@kernel.org>,
        Rene van Dorst <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: rename MT7621 compatible
Message-ID: <20201220074936.ic2mtta7ihg7n3or@skbuf>
References: <20201219162153.23126-1-dqfext@gmail.com>
 <20201219162601.GE3008889@lunn.ch>
 <47673b0d-1da8-d93e-8b56-995a651aa7fd@gmail.com>
 <20201219194831.5mjlmjfbcpggrh45@skbuf>
 <CALW65jYtW7EEnXuj2dGSDwYC=3sBLCP0Q9J=tMozkrP6W0gq0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jYtW7EEnXuj2dGSDwYC=3sBLCP0Q9J=tMozkrP6W0gq0w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 20, 2020 at 12:48:08PM +0800, DENG Qingfang wrote:
> Hi Vladimir,
> 
> On Sun, Dec 20, 2020 at 3:48 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > Hi Andrew, Florian,
> >
> > On Sat, Dec 19, 2020 at 09:07:13AM -0800, Florian Fainelli wrote:
> > > On 12/19/2020 8:26 AM, Andrew Lunn wrote:
> > > >> --- a/drivers/net/dsa/mt7530.c
> > > >> +++ b/drivers/net/dsa/mt7530.c
> > > >> @@ -2688,7 +2688,7 @@ static const struct mt753x_info mt753x_table[] = {
> > > >>  };
> > > >>
> > > >>  static const struct of_device_id mt7530_of_match[] = {
> > > >> -  { .compatible = "mediatek,mt7621", .data = &mt753x_table[ID_MT7621], },
> > > >> +  { .compatible = "mediatek,mt7621-gsw", .data = &mt753x_table[ID_MT7621], },
> > > >>    { .compatible = "mediatek,mt7530", .data = &mt753x_table[ID_MT7530], },
> > > >>    { .compatible = "mediatek,mt7531", .data = &mt753x_table[ID_MT7531], },
> > > >>    { /* sentinel */ },
> > > >
> > > > This will break backwards compatibility with existing DT blobs. You
> > > > need to keep the old "mediatek,mt7621", but please add a comment that
> > > > it is deprecated.
> > >
> > > Besides, adding -gsw would make it inconsistent with the existing
> > > matching compatible strings. While it's not ideal to have the same
> > > top-level SoC compatible and having another sub-node within that SoC's
> > > DTS have the same compatible, given this would be break backwards
> > > compatibility, cannot you stay with what is defined today?
> >
> > The MT7621 device tree is in staging. I suppose that some amount of
> > breaking changes could be tolerated?
> >
> > But Qingfang, I'm confused when looking at drivers/staging/mt7621-dts/mt7621.dtsi.
> >
> > /ethernet@1e100000/mdio-bus {
> >         switch0: switch0@0 {
> >                 compatible = "mediatek,mt7621";
> >                 #address-cells = <1>;
> >                 #size-cells = <0>;
> >                 reg = <0>;
> >                 mediatek,mcm;
> >                 resets = <&rstctrl 2>;
> >                 reset-names = "mcm";
> >
> >                 ports {
> >                         #address-cells = <1>;
> >                         #size-cells = <0>;
> >                         reg = <0>;
> >                         port@0 {
> >                                 status = "off";
> >                                 reg = <0>;
> >                                 label = "lan0";
> >                         };
> >                         port@1 {
> >                                 status = "off";
> >                                 reg = <1>;
> >                                 label = "lan1";
> >                         };
> >                         port@2 {
> >                                 status = "off";
> >                                 reg = <2>;
> >                                 label = "lan2";
> >                         };
> >                         port@3 {
> >                                 status = "off";
> >                                 reg = <3>;
> >                                 label = "lan3";
> >                         };
> >                         port@4 {
> >                                 status = "off";
> >                                 reg = <4>;
> >                                 label = "lan4";
> >                         };
> >                         port@6 {
> >                                 reg = <6>;
> >                                 label = "cpu";
> >                                 ethernet = <&gmac0>;
> >                                 phy-mode = "trgmii";
> >                                 fixed-link {
> >                                         speed = <1000>;
> >                                         full-duplex;
> >                                 };
> >                         };
> >                 };
> >         };
> > };
> >
> > / {
> >         gsw: gsw@1e110000 {
> >                 compatible = "mediatek,mt7621-gsw";
> >                 reg = <0x1e110000 0x8000>;
> >                 interrupt-parent = <&gic>;
> >                 interrupts = <GIC_SHARED 23 IRQ_TYPE_LEVEL_HIGH>;
> >         };
> > };
> >
> > What is the platform device at the memory address 1e110000?
> > There is no driver for it. The documentation only has me even more
> > confused:
> >
> > Mediatek Gigabit Switch
> > =======================
> >
> > The mediatek gigabit switch can be found on Mediatek SoCs (mt7620, mt7621).
> >
> > Required properties:
> > - compatible: Should be "mediatek,mt7620-gsw" or "mediatek,mt7621-gsw"
> > - reg: Address and length of the register set for the device
> > - interrupts: Should contain the gigabit switches interrupt
> > - resets: Should contain the gigabit switches resets
> > - reset-names: Should contain the reset names "gsw"
> >
> > Example:
> >
> > gsw@10110000 {
> >         compatible = "ralink,mt7620-gsw";     <- notice how even the example is bad and inconsistent
> >         reg = <0x10110000 8000>;
> >
> >         resets = <&rstctrl 23>;
> >         reset-names = "gsw";
> >
> >         interrupt-parent = <&intc>;
> >         interrupts = <17>;
> > };
> >
> > Does the MT7621 contain two Ethernet switches, one accessed over MMIO
> > and another over MDIO? Or is it the same switch? I don't understand.
> > What is the relationship between the new compatible that you're
> > proposing, Qingfang, and the existing device tree bindings?
> 
> The current dtsi is copied from OpenWrt, so the existing "mt7621-gsw"
> / "mt7620-gsw" compatible is for their swconfig driver.
> MT7621 has only one switch, accessed over MDIO, so the reg property
> has no effect.
> 
> Should this patch be accepted, the existing gsw nodes can be dropped.

But still, what is at memory address 0x1e110000, if the switch is
accessed over MDIO?
