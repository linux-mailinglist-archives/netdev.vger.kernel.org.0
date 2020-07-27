Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE3422E42D
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 05:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgG0DBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 23:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgG0DBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 23:01:39 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FBDC0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 20:01:38 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 140so8168858lfi.5
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 20:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JA7ay6HbVK9YvTVVzBYfy6CrLlBGd0hvGBZ5WImuGos=;
        b=Q4+87R/4andiEvAnxgrkrVPRUXuPK4g8gmVsWha5cEMzd+RHyp51mEOnzI/KBorila
         ECon42L+Fx6k+sDYSX52JVJ11I4ZUhX8JU1iYmI2DZAe7l7SIc71aj1s2gWJjysLN2X+
         EpEPn+G6OQhXyATywtQ0gzPjwPQCJLRprNBC3OXgwEUzaUz80shuyd67tKXoHpCLiWSJ
         XgpxM0HoFoEauEoR25iYUVa6SUgbY0c4ji8UDOMz3Yjwto57ZIAIJaApEU1+VHyq6xMa
         pn9h193ZeEKA8hYrHwlgxKhoLMIe6NeIutblbpt+/Oom+KpArzMWuxIoA2UxYXLiJ+06
         8ZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JA7ay6HbVK9YvTVVzBYfy6CrLlBGd0hvGBZ5WImuGos=;
        b=BN2+EDmX2hYPtD0/+kienQPSZFVYgXJcjMIlrdz+T7PVqZE6DI80I6X9O8moI7kB29
         7AB8VRP+xlYNpR7qMWlPx4fepKgBU3CJRyp4Oni5+8k6quZe7UqR/98/XfaefqDVvS5X
         N4gTEM5VcRDYOHxXoonF2MlA7dNWw7CHjJ55N4zfMu5Flkf+SQc6063xDE8Wh6UWHtM5
         70kawvnb6r/ICpZFKJZa5p+epgUHBpBMDrhMyl14i7CUsadJGyQp1uHY9J/zOAR55zbk
         yeQOqCj3Xk+Hdzb2Psvni9Ygx1Gz6Xl3CZpvxtL0ucW/7REa63nGBjtderxSWUdpyAFT
         MTCQ==
X-Gm-Message-State: AOAM530jICVWUqZbmJfDjTqghxKslccfytjn2DAnq434ZbSHqYENSGQH
        gzdo6n/ccu3Ou10v2nsgSnf9Pc8d56VVCGap0i4=
X-Google-Smtp-Source: ABdhPJxKD3Guyf2FLc1NAUCgwVMxO8i6vJAAQPm6BPXD4cdvQesfFNrAu1F9NNcF6voUyxa1lt0hbitNNsp8WrmNB8c=
X-Received: by 2002:a19:ec12:: with SMTP id b18mr10720236lfa.52.1595818897417;
 Sun, 26 Jul 2020 20:01:37 -0700 (PDT)
MIME-Version: 1.0
References: <1587996484-3504-1-git-send-email-fugang.duan@nxp.com>
 <20200727012354.GT28704@pendragon.ideasonboard.com> <20200727020631.GW28704@pendragon.ideasonboard.com>
 <20200727021432.GM1661457@lunn.ch> <20200727023310.GA23988@pendragon.ideasonboard.com>
 <CAFXsbZrf11Nj4rzLJfisPr-fFo-+stt-G3-XQ_Mwus_2z0nsAg@mail.gmail.com> <CAFXsbZrysb6SGisEhgXHzj8NZ5o_EjY-rtiqg3gypgr0w-d-dw@mail.gmail.com>
In-Reply-To: <CAFXsbZrysb6SGisEhgXHzj8NZ5o_EjY-rtiqg3gypgr0w-d-dw@mail.gmail.com>
From:   Chris Healy <cphealy@gmail.com>
Date:   Sun, 26 Jul 2020 20:01:25 -0700
Message-ID: <CAFXsbZpBP_kzsC_dLYezJWo7+dQufoRmaFpJgKJbnn6T=sc5QA@mail.gmail.com>
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

It appears quite a few boards were affected by this micrel PHY driver change:

2ccb0161a0e9eb06f538557d38987e436fc39b8d
80bf72598663496d08b3c0231377db6a99d7fd68
2de00450c0126ec8838f72157577578e85cae5d8
820f8a870f6575acda1bf7f1a03c701c43ed5d79

I just updated the phy-mode with my board from rgmii to rgmii-id and
everything started working fine with net-next again:

eth0      Link encap:Ethernet  HWaddr E6:85:48:8F:93:64
          inet addr:172.16.1.1  Bcast:172.16.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:4643690 errors:0 dropped:0 overruns:0 frame:0
          TX packets:76178 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:2762845502 (2.5 GiB)  TX bytes:5026376 (4.7 MiB)



On Sun, Jul 26, 2020 at 7:40 PM Chris Healy <cphealy@gmail.com> wrote:
>
> Actually, I was a little quick to say it went from broken to working.
>
> With net-next, I'm getting CRC errors on 100% of inbound packets.
> With bcf3440c6dd78bfe5836ec0990fe36d7b4bb7d20 reverted, I drop down to
> a 1% error rate.
>
> This very much feels like a KSZ9031 RGMII timing issue to me...
>
> On Sun, Jul 26, 2020 at 7:35 PM Chris Healy <cphealy@gmail.com> wrote:
> >
> > Hi Laurent,
> >
> > I have the exact same copper PHY.  I just reverted a patch specific to
> > this PHY and went from broken to working.  Give this a try:
> >
> > git revert bcf3440c6dd78bfe5836ec0990fe36d7b4bb7d20
> >
> > Regards,
> >
> > Chris
> >
> > On Sun, Jul 26, 2020 at 7:33 PM Laurent Pinchart
> > <laurent.pinchart@ideasonboard.com> wrote:
> > >
> > > Hi Andrew,
> > >
> > > On Mon, Jul 27, 2020 at 04:14:32AM +0200, Andrew Lunn wrote:
> > > > On Mon, Jul 27, 2020 at 05:06:31AM +0300, Laurent Pinchart wrote:
> > > > > On Mon, Jul 27, 2020 at 04:24:02AM +0300, Laurent Pinchart wrote:
> > > > > > On Mon, Apr 27, 2020 at 10:08:04PM +0800, Fugang Duan wrote:
> > > > > > > This reverts commit 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef.
> > > > > > >
> > > > > > > The commit breaks ethernet function on i.MX6SX, i.MX7D, i.MX8MM,
> > > > > > > i.MX8MQ, and i.MX8QXP platforms. Boot yocto system by NFS mounting
> > > > > > > rootfs will be failed with the commit.
> > > > > >
> > > > > > I'm afraid this commit breaks networking on i.MX7D for me :-( My board
> > > > > > is configured to boot over NFS root with IP autoconfiguration through
> > > > > > DHCP. The DHCP request goes out, the reply it sent back by the server,
> > > > > > but never noticed by the fec driver.
> > > > > >
> > > > > > v5.7 works fine. As 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef was merged
> > > > > > during the v5.8 merge window, I suspect something else cropped in
> > > > > > between 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef and this patch that
> > > > > > needs to be reverted too. We're close to v5.8 and it would be annoying
> > > > > > to see this regression ending up in the released kernel. I can test
> > > > > > patches, but I'm not familiar enough with the driver (or the networking
> > > > > > subsystem) to fix the issue myself.
> > > > >
> > > > > If it can be of any help, I've confirmed that, to get the network back
> > > > > to usable state from v5.8-rc6, I have to revert all patches up to this
> > > > > one. This is the top of my branch, on top of v5.8-rc6:
> > > > >
> > > > > 5bbe80c9efea Revert "net: ethernet: fec: Revert "net: ethernet: fec: Replace interrupt driven MDIO with polled IO""
> > > > > 5462896a08c1 Revert "net: ethernet: fec: Replace interrupt driven MDIO with polled IO"
> > > > > 824a82e2bdfa Revert "net: ethernet: fec: move GPR register offset and bit into DT"
> > > > > bfe330591cab Revert "net: fec: disable correct clk in the err path of fec_enet_clk_enable"
> > > > > 109958cad578 Revert "net: ethernet: fec: prevent tx starvation under high rx load"
> > > >
> > > > OK.
> > > >
> > > > What PHY are you using? A Micrel?
> > >
> > > KSZ9031RNXIA
> > >
> > > > And which DT file?
> > >
> > > It's out of tree.
> > >
> > > &fec1 {
> > >         pinctrl-names = "default";
> > >         pinctrl-0 = <&pinctrl_enet1>;
> > >         assigned-clocks = <&clks IMX7D_ENET1_TIME_ROOT_SRC>,
> > >                           <&clks IMX7D_ENET1_TIME_ROOT_CLK>;
> > >         assigned-clock-parents = <&clks IMX7D_PLL_ENET_MAIN_100M_CLK>;
> > >         assigned-clock-rates = <0>, <100000000>;
> > >         phy-mode = "rgmii";
> > >         phy-handle = <&ethphy0>;
> > >         phy-reset-gpios = <&gpio1 13 GPIO_ACTIVE_LOW>;
> > >         phy-supply = <&reg_3v3_sw>;
> > >         fsl,magic-packet;
> > >         status = "okay";
> > >
> > >         mdio {
> > >                 #address-cells = <1>;
> > >                 #size-cells = <0>;
> > >
> > >                 ethphy0: ethernet-phy@0 {
> > >                         reg = <1>;
> > >                 };
> > >
> > >                 ethphy1: ethernet-phy@1 {
> > >                         reg = <2>;
> > >                 };
> > >         };
> > > };
> > >
> > > I can provide the full DT if needed.
> > >
> > > --
> > > Regards,
> > >
> > > Laurent Pinchart
