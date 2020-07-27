Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D4322E40D
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 04:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgG0CkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 22:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgG0CkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 22:40:25 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABBFC0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 19:40:24 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id v4so5845383ljd.0
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 19:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O/KSe4vu0KrhSla7hbewzJZy13ky/8IuM6vPc62kx9g=;
        b=G2Mky+5fwakgX6donxLbNnxpCgYAbY/s18HbtzmWUK4ubksGsjvQuhfeyDCG8op4QD
         3e8d15ar0CvKz0E1gipVeTsRLxKP8RadPTaiKufHFpgUHUTFWadPKyAtpY02j+JxtPq7
         TzhnhXZECWyrwfgZvqRDosqCw68q6PrQXBCGOGEvQzsR14Nt862DNwG0U8QidVMBqK85
         8m8IxN9f6hhgEt8UhPRUQ2O2WwiNxExpKKVm1ZcrtUA6SAWt0fBWof/2pqABL66DSUQf
         bZqMFlSgm4lS3C7s/nbsfmE9Udq5cDSoXsvOa8eoydUOnHubEp3Ev4lMbVrarWP3TDyT
         ZYug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O/KSe4vu0KrhSla7hbewzJZy13ky/8IuM6vPc62kx9g=;
        b=mok+OR+SwAIw5HtewBq/+Lo3KnEZ8p9TfC4tWWD2cYj61ba3wJdu5+V/sF/ofztQtb
         YcbRDgmjlJYlUwzHOnY9A5drqsihIkJMLvM2ZM+DzoPZgznsPspbkE86/m5KDlBh3tEc
         6G1eZ+DSolyVXLPmJco4B1iYZ4QmcVt+PfJw4RTGIpTTgl70z9ANFDPSamXkywXxLvMa
         eSx38WrBaaVlxUZLqtTKNtZ1VcLlrOqwkzHbNB3jPe5PwN89njSCpys97WLtD/JA+WTl
         8u2jJE81Yr0+rOuTlfigwk5lvdFy/3pJwnPRps5TwWB6zTkQrOBUw04UamRo8RCOOzdM
         9diA==
X-Gm-Message-State: AOAM531JT+56yy+Q5fhH+fHor2ogqrEg1pvtgWoiCcfGAUJP3/fVyMFv
        p5QQO4uiko/M4LOtRJrqT4aHw7nxcNrzAoBLGrw=
X-Google-Smtp-Source: ABdhPJxb6OzMlaUBkWX19TCaosbxqNa0JYNLGVIiNES6jNx9OTpUkEP75hXA67NybOTXW5mRmQprmWaesWL0Tuj+KTY=
X-Received: by 2002:a2e:545c:: with SMTP id y28mr3757263ljd.448.1595817623107;
 Sun, 26 Jul 2020 19:40:23 -0700 (PDT)
MIME-Version: 1.0
References: <1587996484-3504-1-git-send-email-fugang.duan@nxp.com>
 <20200727012354.GT28704@pendragon.ideasonboard.com> <20200727020631.GW28704@pendragon.ideasonboard.com>
 <20200727021432.GM1661457@lunn.ch> <20200727023310.GA23988@pendragon.ideasonboard.com>
 <CAFXsbZrf11Nj4rzLJfisPr-fFo-+stt-G3-XQ_Mwus_2z0nsAg@mail.gmail.com>
In-Reply-To: <CAFXsbZrf11Nj4rzLJfisPr-fFo-+stt-G3-XQ_Mwus_2z0nsAg@mail.gmail.com>
From:   Chris Healy <cphealy@gmail.com>
Date:   Sun, 26 Jul 2020 19:40:11 -0700
Message-ID: <CAFXsbZrysb6SGisEhgXHzj8NZ5o_EjY-rtiqg3gypgr0w-d-dw@mail.gmail.com>
Subject: Re: [RESENT PATCH net--stat 1/1] net: ethernet: fec: Revert "net:
 ethernet: fec: Replace interrupt driven MDIO with polled IO"
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Actually, I was a little quick to say it went from broken to working.

With net-next, I'm getting CRC errors on 100% of inbound packets.
With bcf3440c6dd78bfe5836ec0990fe36d7b4bb7d20 reverted, I drop down to
a 1% error rate.

This very much feels like a KSZ9031 RGMII timing issue to me...

On Sun, Jul 26, 2020 at 7:35 PM Chris Healy <cphealy@gmail.com> wrote:
>
> Hi Laurent,
>
> I have the exact same copper PHY.  I just reverted a patch specific to
> this PHY and went from broken to working.  Give this a try:
>
> git revert bcf3440c6dd78bfe5836ec0990fe36d7b4bb7d20
>
> Regards,
>
> Chris
>
> On Sun, Jul 26, 2020 at 7:33 PM Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> >
> > Hi Andrew,
> >
> > On Mon, Jul 27, 2020 at 04:14:32AM +0200, Andrew Lunn wrote:
> > > On Mon, Jul 27, 2020 at 05:06:31AM +0300, Laurent Pinchart wrote:
> > > > On Mon, Jul 27, 2020 at 04:24:02AM +0300, Laurent Pinchart wrote:
> > > > > On Mon, Apr 27, 2020 at 10:08:04PM +0800, Fugang Duan wrote:
> > > > > > This reverts commit 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef.
> > > > > >
> > > > > > The commit breaks ethernet function on i.MX6SX, i.MX7D, i.MX8MM,
> > > > > > i.MX8MQ, and i.MX8QXP platforms. Boot yocto system by NFS mounting
> > > > > > rootfs will be failed with the commit.
> > > > >
> > > > > I'm afraid this commit breaks networking on i.MX7D for me :-( My board
> > > > > is configured to boot over NFS root with IP autoconfiguration through
> > > > > DHCP. The DHCP request goes out, the reply it sent back by the server,
> > > > > but never noticed by the fec driver.
> > > > >
> > > > > v5.7 works fine. As 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef was merged
> > > > > during the v5.8 merge window, I suspect something else cropped in
> > > > > between 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef and this patch that
> > > > > needs to be reverted too. We're close to v5.8 and it would be annoying
> > > > > to see this regression ending up in the released kernel. I can test
> > > > > patches, but I'm not familiar enough with the driver (or the networking
> > > > > subsystem) to fix the issue myself.
> > > >
> > > > If it can be of any help, I've confirmed that, to get the network back
> > > > to usable state from v5.8-rc6, I have to revert all patches up to this
> > > > one. This is the top of my branch, on top of v5.8-rc6:
> > > >
> > > > 5bbe80c9efea Revert "net: ethernet: fec: Revert "net: ethernet: fec: Replace interrupt driven MDIO with polled IO""
> > > > 5462896a08c1 Revert "net: ethernet: fec: Replace interrupt driven MDIO with polled IO"
> > > > 824a82e2bdfa Revert "net: ethernet: fec: move GPR register offset and bit into DT"
> > > > bfe330591cab Revert "net: fec: disable correct clk in the err path of fec_enet_clk_enable"
> > > > 109958cad578 Revert "net: ethernet: fec: prevent tx starvation under high rx load"
> > >
> > > OK.
> > >
> > > What PHY are you using? A Micrel?
> >
> > KSZ9031RNXIA
> >
> > > And which DT file?
> >
> > It's out of tree.
> >
> > &fec1 {
> >         pinctrl-names = "default";
> >         pinctrl-0 = <&pinctrl_enet1>;
> >         assigned-clocks = <&clks IMX7D_ENET1_TIME_ROOT_SRC>,
> >                           <&clks IMX7D_ENET1_TIME_ROOT_CLK>;
> >         assigned-clock-parents = <&clks IMX7D_PLL_ENET_MAIN_100M_CLK>;
> >         assigned-clock-rates = <0>, <100000000>;
> >         phy-mode = "rgmii";
> >         phy-handle = <&ethphy0>;
> >         phy-reset-gpios = <&gpio1 13 GPIO_ACTIVE_LOW>;
> >         phy-supply = <&reg_3v3_sw>;
> >         fsl,magic-packet;
> >         status = "okay";
> >
> >         mdio {
> >                 #address-cells = <1>;
> >                 #size-cells = <0>;
> >
> >                 ethphy0: ethernet-phy@0 {
> >                         reg = <1>;
> >                 };
> >
> >                 ethphy1: ethernet-phy@1 {
> >                         reg = <2>;
> >                 };
> >         };
> > };
> >
> > I can provide the full DT if needed.
> >
> > --
> > Regards,
> >
> > Laurent Pinchart
