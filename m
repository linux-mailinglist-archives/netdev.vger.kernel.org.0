Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43641ECD5
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbfD2WhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:37:13 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33362 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729481AbfD2WhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 18:37:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id s18so18413657wrp.0;
        Mon, 29 Apr 2019 15:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7S4KMd/ygX8leVdrYwsDdPFvu75RsDdgYnaRdFkfSlo=;
        b=nFYC7P674cz/E2itH/J0cSRnPHW3/1akR3zLMtHooEEcvNBy+f5SqPK60HJhcklGh+
         YWzxO3exQywWoStjjKPD/U+77w98cakVgF3gCBSwjS60SuM7+bNZUk+4ItNhWEel3RcJ
         me0KFZ6c5LRSYPxC5lHhF7jT+8eJLmj8VKrjqyj/mBgzWJDl79ZhsSteK1N9M3zd9mqT
         4lVhL1NNVsMK/rBSB2zGjTvg2oZJaEUrjUI9POM9kPrbIgnTn5nJ2bz2M6SdEut4YX6r
         K0Jtyzg/hIBV9jv3TOs0Iia0wqEhk2eJeOW+HjtruPEcwZ06D+h1kuVp6DRUVxLF5po1
         CEbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7S4KMd/ygX8leVdrYwsDdPFvu75RsDdgYnaRdFkfSlo=;
        b=YdB4AR7PDRUPYEOKwepOE4z3ovFNUU4b0CgOYuZGM7NP9mLrXoV/TbZaeSBNUf3WhI
         cLihPnTvAEWnoaFv728cynjnDNsG9gn0RpVwCS1NtMlJBpBRxmiH7MLfhnntznKwNvV3
         DeUC0+Lj4wsXqM8JPbrTjIDnNJBS7Xdvd6+flVUvAc0J8rIYuxQDM9fTLhA4gNVb4NLI
         veUy7y7keJ063zmBY5gr93BBN32wAOuBM/Aeai/khjcSGdiYG0bTnEGPBCNkxhDJ89Hr
         oHmd+cmg3JtlKA2I4qzJCZpYBK5unAaY/kwrKyMJA66fqyf+txkzCykn+mXj1Aaoy5Qe
         UHqQ==
X-Gm-Message-State: APjAAAV32EUWZGOC0R2jXAZ7eCQHFnf+/Rd4CD2M63Ij+BT3zrXyAI6M
        3Nxm6Bv3Rvk14d+VjZcXwQhCeHxnoK8ucqI4sWM=
X-Google-Smtp-Source: APXvYqzI2ecTN/5fDOorWY1Zw8iQHxFjaUifdyaEBljhP3vhMHBcJ/HHG+zoT67Hzqgs2vQ9TlSpR9eYzHuNDKOkxYk=
X-Received: by 2002:adf:cc8a:: with SMTP id p10mr885723wrj.34.1556577430282;
 Mon, 29 Apr 2019 15:37:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190426212112.5624-1-fancer.lancer@gmail.com>
 <20190426212112.5624-2-fancer.lancer@gmail.com> <20190426214631.GV4041@lunn.ch>
 <20190426233511.qnkgz75ag7axt5lp@mobilestation> <f27df721-47aa-a708-aaee-69be53def814@gmail.com>
 <CA+h21hpTRCrD=FxDr=ihDPr+Pdhu6hXT3xcKs47-NZZZ3D9zyg@mail.gmail.com> <20190429211225.ce7cspqwvlhwdxv6@mobilestation>
In-Reply-To: <20190429211225.ce7cspqwvlhwdxv6@mobilestation>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 30 Apr 2019 01:36:59 +0300
Message-ID: <CA+h21hrbrc7NKrdhrEk-t7+atj-EdNfEpmy85XK7dOr4Cyj-ag@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: phy: realtek: Change TX-delay setting for
 RGMII modes only
To:     Serge Semin <fancer.lancer@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Serge,

On Tue, 30 Apr 2019 at 00:12, Serge Semin <fancer.lancer@gmail.com> wrote:
>
> On Mon, Apr 29, 2019 at 09:29:37PM +0300, Vladimir Oltean wrote:
> > On Mon, 29 Apr 2019 at 20:39, Florian Fainelli <f.fainelli@gmail.com> wrote:
> > >
> > > On 4/26/19 4:35 PM, Serge Semin wrote:
> > > > On Fri, Apr 26, 2019 at 11:46:31PM +0200, Andrew Lunn wrote:
> > > >> On Sat, Apr 27, 2019 at 12:21:12AM +0300, Serge Semin wrote:
> > > >>> It's prone to problems if delay is cleared out for other than RGMII
> > > >>> modes. So lets set/clear the TX-delay in the config register only
> > > >>> if actually RGMII-like interface mode is requested.
> > > >>>
> > > >>> Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
> > > >>>
> > > >>> ---
> > > >>>  drivers/net/phy/realtek.c | 16 ++++++++++++----
> > > >>>  1 file changed, 12 insertions(+), 4 deletions(-)
> > > >>>
> > > >>> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> > > >>> index ab567a1923ad..a18cb01158f9 100644
> > > >>> --- a/drivers/net/phy/realtek.c
> > > >>> +++ b/drivers/net/phy/realtek.c
> > > >>> @@ -163,16 +163,24 @@ static int rtl8211c_config_init(struct phy_device *phydev)
> > > >>>  static int rtl8211f_config_init(struct phy_device *phydev)
> > > >>>  {
> > > >>>     int ret;
> > > >>> -   u16 val = 0;
> > > >>> +   u16 val;
> > > >>>
> > > >>>     ret = genphy_config_init(phydev);
> > > >>>     if (ret < 0)
> > > >>>             return ret;
> > > >>>
> > > >>> -   /* enable TX-delay for rgmii-id and rgmii-txid, otherwise disable it */
> > > >>> -   if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> > > >>> -       phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
> > > >>> +   /* enable TX-delay for rgmii-id/rgmii-txid, and disable it for rgmii */
> > > >>> +   switch (phydev->interface) {
> > > >>> +   case PHY_INTERFACE_MODE_RGMII:
> > > >>> +           val = 0;
> > > >>> +           break;
> > > >>> +   case PHY_INTERFACE_MODE_RGMII_ID:
> > > >>> +   case PHY_INTERFACE_MODE_RGMII_TXID:
> > > >>>             val = RTL8211F_TX_DELAY;
> > > >>> +           break;
> > > >>> +   default: /* the rest of the modes imply leaving delay as is. */
> > > >>> +           return 0;
> > > >>> +   }
> > > >>
> > > >> So there is no control of the RX delay?
> > > >>
> > > >
> > > > As you can see it hasn't been there even before this change. So I suppose
> > > > either the hardware just doesn't support it (although the openly available
> > > > datasheet states that there is an RXD pin) or the original driver developer
> > > > decided to set TX-delay only.
> > > >
> > > > Just to make sure you understand. I am not working for realtek and don't
> > > > posses any inside info regarding these PHYs. I was working on a project,
> > > > which happened to utilize a rtl8211e PHY. We needed to find a way to
> > > > programmatically change the delays setting. So I searched the Internet
> > > > and found the U-boot rtl8211f driver and freebsd-folks discussion. This
> > > > info has been used to write the config_init method for Linux version of the
> > > > PHY' driver. That's it.
> > > >
> > > >> That means PHY_INTERFACE_MODE_RGMII_ID and
> > > >> PHY_INTERFACE_MODE_RGMII_RXID are not supported, and you should return
> > > >> -EINVAL.
> > > >>
> > > >
> > > > Apparently the current config_init method doesn't support RXID setting.
> > > > The patch introduced current function code was submitted by
> > > > Martin Blumenstingl in 2016:
> > > > https://patchwork.kernel.org/patch/9447581/
> > > > and was reviewed by Florian. So we'd better ask him why it was ok to mark
> > > > the RGMII_ID as supported while only TX-delay could be set.
> > > > I also failed to find anything regarding programmatic rtl8211f delays setting
> > > > in the Internet. So at this point we can set TX-delay only for f-model of the PHY.
> > > >
> > > > Anyway lets clarify the situation before to proceed further. You are suggesting
> > > > to return an error in case if either RGMII_ID or RGMII_RXID interface mode is
> > > > requested to be enabled for the PHY. It's fair seeing the driver can't fully
> > > > support either of them.
> > >
> > > That is how I read Andrew's suggestion and it is reasonable. WRT to the
> > > original changes from Martin, he is probably the one you would want to
> > > add to this conversation in case there are any RX delay control knobs
> > > available, I certainly don't have the datasheet, and Martin's change
> > > looks and looked reasonable, seemingly independent of the direction of
> > > this very conversation we are having.
> > >
> > > But what about the rest of the modes like GMII, MII
> > > > and others?
> > >
> > > The delays should be largely irrelevant for GMII and MII, since a) the
> > > PCB is required to have matching length traces, and b) these are not
> > > double data rate interfaces
> > >
> > > > Shouldn't we also return an error instead of leaving a default
> > > > delay value?
> > >
> > > That seems a bit harsh, those could have been configured by firmware,
> > > whatever before Linux comes up and be correct and valid. We don't know
> > > of a way to configure it, but that does not mean it does not exist and
> > > some software is doing it already.
> > >
> > > >
> > > > The same question can be actually asked regarding the config_init method of
> > > > rtl8211e PHY, which BTW you already tagged as Reviewed-by.
> > > >
> > > >> This is where we get into interesting backwards compatibility
> > > >> issues. Are there any broken DT blobs with rgmii-id or rgmii-rxid,
> > > >> which will break with such a change?
> > > >>
> > > >
> > > > Not that I am aware of and which simple grep rtl8211 could find. Do you
> > > > know about one?
> > > >
> > > > -Sergey
> > > >
> > > >>      Andrew
> > >
> > >
> > > --
> > > Florian
> >
> > There seems to be some confusion here.
> > The "normal" RTL8211F has RXDLY and TXDLY configurable only via pin
> > strapping (pull-up/pull-down), not via MDIO.
> > The "1588-capable" RTL8211FS has RXDLY configurable via pin strapping
> > (different pin than the regular 8211F) and TXDLY via page 0xd08,
> > register 17, bit 8.
> > I think setting the Tx delay via MDIO for the normal RTL8211F is snake oil.
> > Disclaimer: I don't work for Realtek either, so I have no insight on
> > why it is like that.
> > From Linux' point of view, there are two aspects:
> > * Erroring out now will likely just break something that was working
> > (since it was relying on hardware strapping and the DT phy-mode
> > property was more or less informative).
> > * Arguably what is wrong here is the semantics of the phy-mode
> > bindings for RGMII. It gets said a lot that DT means "hardware
> > description", not "hardware configuration". So having said that, the
> > correct interpretation of phy-mode = "rgmii-id" is that the operating
> > system is informed that RGMII delays were handled in both directions
> > (either the PHY was strapped, or PCB traces were lengthened). But the
> > current meaning of "rgmii-id" in practice is an imperative "PHY
> > driver, please apply delays in both directions" (or MAC driver, if
> > it's fixed-link).
> >
> > Thanks,
> > -Vladimir
>
> Hello Vladimir, Florian and Andrew
>
> Thanks for your comments on this matter. Let me sum my understanding of
> this up so we'd set a checkpoint of the rtl8211* interface delays
> discussion.
>
> rtl8211(e|f) TX/RX delays can be configured either by external pins
> strapping or via software registers. This is one of the clue to provide
> a proper config_init method code. But not all rtl8211f phys provide
> that software register, and if they do it only concerns TX-delay (as we
> aware of). So we need to take this into account when creating the updated
> versions of these functions.
>
> (Martin, I also Cc'ed you in this discussion, so if you have anything to
> say in this matter, please don't hesitate to comment.)
>
> As Vladimir fairly pointed out DT should be considered as a "hardware
> description", and not a "hardware configuration". But I would correct
> the interpretation you suggested a bit. Current phy-mode property meaning
> I would explain as a MAC-PHY interface description (so it complies with
> "DT - hardware description" rule). So "rgmii" means TXC/RXC, TXD[4] RXD[4],
> RX_CTL lanes, etc; "gmii" - GTXCLK, TXCLK/RXCLK, TXD[8], RXD[8],
> TXEN, RXEN, COL, CS lanes, etc and so on. The "-*id" suffixes are something
> that describe the logical signal delays, which due to the physical lanes design
> might be required so the corresponding "{r,g,rg}mii" interface would work
> correctly.
>

As Andrew pointed out, only RGMII needs clock skew, mainly because it
is an interface with source-synchronous clocking that runs at 125 MHz
(when the link speed is 1000 Mbps, otherwise the delays are less
important) and is double data rate (data gets sampled on both rising
and falling clock edges).
Moreover, RGMII *always* needs clock skew. As a fact, all delays
applied on RX and RX, by the PHY, MAC or traces, should always amount
to a logical "rgmii-id". There's nothing that needs to be described
about that. Everybody knows it.
What Linux gets told through the phy-mode property for RGMII is where
there's extra stuff to do, and where there's nothing to do. There are
also unwritten rules about whose job it is to apply the clock skew
(MAC or PHY).That is 100% configuration and 0% description.

> Then in accordance with the phy-mode property value MAC and PHY drivers
> determine which way the MAC and PHY are connected to each other and how
> their settings are supposed to be customized to comply with it. This
> interpretation perfectly fits with the "DT is the hardware description"
> rule.
>

Most of the phy-mode properties really mean nothing. I changed the
phy-mode from "sgmii" to "rgmii" on a PHY binding I had at hand and
nothing happened (traffic still runs normally). I think this behavior
is 100% within expectation.

> Finally I dig into the available rtl8211(e|f) datasheets a bit deeper
> and found out, that rtl8211f PHYs provide the RGMII interface only.
> While there is only one model of rtl8211e PHY which aside from the default
> RGMII-interface can work over MII/GMII-interfaces (which BTW can be
> enabled via a pin strapping and via a register I used for delay
> settings). So even if MAC provides a way to enable MII/GMII/RGMII/SGMII/etc
> interfaces the PHY driver should refuse to work over interfaces
> it' device doesn't support by design. This is what lacks the current
> rtl8211(f|e)_config_init methods design. (Andrew also might have
> suggested something like this, though I am not sure I fully understood
> what he meant.)
>
> So as all of this info must be taken into account to create a proper driver
> rtl8211(e|f) config_init methods. As I see it we need to provide the following
> alterations to the realtek driver:
> rtl8211f config_init:
> - RGMII-interface is only supported, so return an error if any other
> interface mode is requested. Andrew also suggested to accept
> the PHY_INTERFACE_MODE_NA mode as an implication to leave the mode as is.
> Although I have a doubt about this since none of the PHY' drivers
> does this at the moment. Any comment on this?

I think this is way overboard, since "configuring the interface as
SGMII" is not something that software alone can do (and many times,
the software can't do anything at all to make a MAC speak SGMII vs
RGMII vs whatever else). And there are times when the software can't
even know what the MAC speaks, unless the driver hardcodes it. So the
phy-mode checking would only protect against mismatches of hardcoded
values. So it would error out whilst the hardware would keep working
and minding its own business as if nothing happened... You can't
really connect an RGMII MAC to an SGMII PHY, in real life :)

> - phy-mode = "rgmii", no delays need to be set on the PHY side, so clear
> {page=0xd08, register=0x11, bit=8} bit and rely on the RXD pin being pulled
> low (RX delay is also disabled).
> - phy-mode = "rgmii-id", all delays are supposed to be set on the PHY side.
> We can manually set the TX-delay, while RX-delay is set over an external pin.
> So set the {page=0xd08, register=0x11, bit=8} bit only, and rely on the
> hardware designer pulling the RXD pin high.
> - phy-mode = "rgmii-txid", set the {page=0xd08, register=0x11, bit=8} bit only,
> and rely on the hardware designer pulling the RXD pin low.
> - phy-mode = "rgmii-rxid", clear the {page=0xd08, register=0x11, bit=8} bit only,
> and rely on the hardware designer pulling the RXD pin high.
>

I would remove the portions where you say "rely on hw doing
this/that". The phy-mode only concerns software (MDIO) business. The
"hardware description vs hardware configuration" on my part is just
wishful thinking. You *can* have the phy-mode as "rgmii-txid" and the
RXDLY pin enabled in the strapping config, and that would amount to a
total, logical "rgmii-id" on the PHY, and it would be fine (Linux not
having an accurate "hardware description" of the system).

> rtl8211e config_init:
> - MII/GMII/RGMII-interfaces are only supported, so return an error if any other
> interface mode is requested. The same thought about PHY_INTERFACE_MODE_NA is
> applicable here.
> - MII/GMII-interface can be enabled via the Mode pin strapping or via the
> configuration register I've used to set the delays. So use it to enable/disable
> either MII/GMII or RGMII interface mode.
> - phy-mode = ("rgmii"|"rgmii-id"|"rgmii-txid"|"rgmii-rxid") - enable and disable
> the TX/RX-delay bits of the corresponding register, since either of these modes
> can be configured by software.
>
>
> Could you comment on these thoughts so we'd finally come up with a final
> decision and I'd send out a new version of the patchset.

Erroring out on rgmii-rxid and rgmii-id is probably justifiable, but
then again, just because you can, doesn't mean you should. Could you
please explain again what problem this is trying to solve? I only see
the problems that this will create :)

>
> -Sergey

Thanks,
-Vladimir
