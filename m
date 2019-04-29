Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF68BEBF3
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 23:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729411AbfD2VMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 17:12:34 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40577 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbfD2VMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 17:12:34 -0400
Received: by mail-lf1-f66.google.com with SMTP id o16so9126700lfl.7;
        Mon, 29 Apr 2019 14:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GXXtIWgznRieIvfPzy275IxGameLBoo3cIWsxAmZHvo=;
        b=Q2gd4BolQUb+0Y4ikvmlxJ9KOR463uaOWErrcyQArd5FIC4BvGiobVca1y/QYz0fUx
         dVt/zfs4YG/CFzCgavnNyF6FxeloedQhkPjLQk6wz7JpkpxEk/y3eHnQ4PCP6+GUqtoR
         QD6ud+EuXqG/pWNqVbBgTOByd+E1Oj6yVZ+FRXuF/b+ba8oWn3dX6LCkuJkg4UBH783b
         4cMY/d7K172Uo3VoFyA0IndB+z05Bf/0i+53Zm/MSaXKJaWcyQsxB1qCZqAuk0k1EYcx
         UkD1nVgFJQe/hRA40ZFUPVtBmEPnvZbeKyywNDIwVcD524/x377XOUaZVZPCbw2LRUGk
         zqaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GXXtIWgznRieIvfPzy275IxGameLBoo3cIWsxAmZHvo=;
        b=Q+p9w+AfDpNYgRyH/nM5TuZ3DQ57fgZz9j9FhJ0IMNHwyeLFAM45AE8/fQCQKhUGZP
         iIuGMZhK2hjt21Ixwb8uxjioCG4vsPZ34JdEm/tl2G5L3MwRGRT+RYRP5r+wuNgEP/Id
         MqwbmpYUpr3Ha6fUUwaGzfY9ca3oN3IEpXnCbXaEgWIyBKTR47vGyvI3nk3QiI4Jb0D5
         a9GMO/w5UkPQgWk7YdHC+Kuei6y+Dcm8xtNYUGBRtPvs5MrTIIvI1wDa2vF9DKyXKwQO
         H/oorbFwG1Qyx3pwOIW9IvcvR80f06D5MbccAubC9qFEnprZ2UIpNdXk2rTa1aO+4Jl2
         a8hQ==
X-Gm-Message-State: APjAAAWXjjF+5N0e40RNvCyy/Fle3JVNzvQmEPMhQfHaOcD95EhDbiLl
        Z6RqsR5xqxZM0gSBPJTi7Q4=
X-Google-Smtp-Source: APXvYqyU/z88g2urNljPzJHm2oHOvgNo0eH+LR4I96nFMDBnQUUjWOpQKGi29TFE38idzaAE+hi5Vw==
X-Received: by 2002:ac2:43a9:: with SMTP id t9mr36180686lfl.6.1556572351103;
        Mon, 29 Apr 2019 14:12:31 -0700 (PDT)
Received: from mobilestation ([5.164.240.123])
        by smtp.gmail.com with ESMTPSA id j19sm7493001lfm.29.2019.04.29.14.12.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Apr 2019 14:12:30 -0700 (PDT)
Date:   Tue, 30 Apr 2019 00:12:27 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: Re: [PATCH v2 2/2] net: phy: realtek: Change TX-delay setting for
 RGMII modes only
Message-ID: <20190429211225.ce7cspqwvlhwdxv6@mobilestation>
References: <20190426212112.5624-1-fancer.lancer@gmail.com>
 <20190426212112.5624-2-fancer.lancer@gmail.com>
 <20190426214631.GV4041@lunn.ch>
 <20190426233511.qnkgz75ag7axt5lp@mobilestation>
 <f27df721-47aa-a708-aaee-69be53def814@gmail.com>
 <CA+h21hpTRCrD=FxDr=ihDPr+Pdhu6hXT3xcKs47-NZZZ3D9zyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpTRCrD=FxDr=ihDPr+Pdhu6hXT3xcKs47-NZZZ3D9zyg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 09:29:37PM +0300, Vladimir Oltean wrote:
> On Mon, 29 Apr 2019 at 20:39, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >
> > On 4/26/19 4:35 PM, Serge Semin wrote:
> > > On Fri, Apr 26, 2019 at 11:46:31PM +0200, Andrew Lunn wrote:
> > >> On Sat, Apr 27, 2019 at 12:21:12AM +0300, Serge Semin wrote:
> > >>> It's prone to problems if delay is cleared out for other than RGMII
> > >>> modes. So lets set/clear the TX-delay in the config register only
> > >>> if actually RGMII-like interface mode is requested.
> > >>>
> > >>> Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
> > >>>
> > >>> ---
> > >>>  drivers/net/phy/realtek.c | 16 ++++++++++++----
> > >>>  1 file changed, 12 insertions(+), 4 deletions(-)
> > >>>
> > >>> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> > >>> index ab567a1923ad..a18cb01158f9 100644
> > >>> --- a/drivers/net/phy/realtek.c
> > >>> +++ b/drivers/net/phy/realtek.c
> > >>> @@ -163,16 +163,24 @@ static int rtl8211c_config_init(struct phy_device *phydev)
> > >>>  static int rtl8211f_config_init(struct phy_device *phydev)
> > >>>  {
> > >>>     int ret;
> > >>> -   u16 val = 0;
> > >>> +   u16 val;
> > >>>
> > >>>     ret = genphy_config_init(phydev);
> > >>>     if (ret < 0)
> > >>>             return ret;
> > >>>
> > >>> -   /* enable TX-delay for rgmii-id and rgmii-txid, otherwise disable it */
> > >>> -   if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> > >>> -       phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
> > >>> +   /* enable TX-delay for rgmii-id/rgmii-txid, and disable it for rgmii */
> > >>> +   switch (phydev->interface) {
> > >>> +   case PHY_INTERFACE_MODE_RGMII:
> > >>> +           val = 0;
> > >>> +           break;
> > >>> +   case PHY_INTERFACE_MODE_RGMII_ID:
> > >>> +   case PHY_INTERFACE_MODE_RGMII_TXID:
> > >>>             val = RTL8211F_TX_DELAY;
> > >>> +           break;
> > >>> +   default: /* the rest of the modes imply leaving delay as is. */
> > >>> +           return 0;
> > >>> +   }
> > >>
> > >> So there is no control of the RX delay?
> > >>
> > >
> > > As you can see it hasn't been there even before this change. So I suppose
> > > either the hardware just doesn't support it (although the openly available
> > > datasheet states that there is an RXD pin) or the original driver developer
> > > decided to set TX-delay only.
> > >
> > > Just to make sure you understand. I am not working for realtek and don't
> > > posses any inside info regarding these PHYs. I was working on a project,
> > > which happened to utilize a rtl8211e PHY. We needed to find a way to
> > > programmatically change the delays setting. So I searched the Internet
> > > and found the U-boot rtl8211f driver and freebsd-folks discussion. This
> > > info has been used to write the config_init method for Linux version of the
> > > PHY' driver. That's it.
> > >
> > >> That means PHY_INTERFACE_MODE_RGMII_ID and
> > >> PHY_INTERFACE_MODE_RGMII_RXID are not supported, and you should return
> > >> -EINVAL.
> > >>
> > >
> > > Apparently the current config_init method doesn't support RXID setting.
> > > The patch introduced current function code was submitted by
> > > Martin Blumenstingl in 2016:
> > > https://patchwork.kernel.org/patch/9447581/
> > > and was reviewed by Florian. So we'd better ask him why it was ok to mark
> > > the RGMII_ID as supported while only TX-delay could be set.
> > > I also failed to find anything regarding programmatic rtl8211f delays setting
> > > in the Internet. So at this point we can set TX-delay only for f-model of the PHY.
> > >
> > > Anyway lets clarify the situation before to proceed further. You are suggesting
> > > to return an error in case if either RGMII_ID or RGMII_RXID interface mode is
> > > requested to be enabled for the PHY. It's fair seeing the driver can't fully
> > > support either of them.
> >
> > That is how I read Andrew's suggestion and it is reasonable. WRT to the
> > original changes from Martin, he is probably the one you would want to
> > add to this conversation in case there are any RX delay control knobs
> > available, I certainly don't have the datasheet, and Martin's change
> > looks and looked reasonable, seemingly independent of the direction of
> > this very conversation we are having.
> >
> > But what about the rest of the modes like GMII, MII
> > > and others?
> >
> > The delays should be largely irrelevant for GMII and MII, since a) the
> > PCB is required to have matching length traces, and b) these are not
> > double data rate interfaces
> >
> > > Shouldn't we also return an error instead of leaving a default
> > > delay value?
> >
> > That seems a bit harsh, those could have been configured by firmware,
> > whatever before Linux comes up and be correct and valid. We don't know
> > of a way to configure it, but that does not mean it does not exist and
> > some software is doing it already.
> >
> > >
> > > The same question can be actually asked regarding the config_init method of
> > > rtl8211e PHY, which BTW you already tagged as Reviewed-by.
> > >
> > >> This is where we get into interesting backwards compatibility
> > >> issues. Are there any broken DT blobs with rgmii-id or rgmii-rxid,
> > >> which will break with such a change?
> > >>
> > >
> > > Not that I am aware of and which simple grep rtl8211 could find. Do you
> > > know about one?
> > >
> > > -Sergey
> > >
> > >>      Andrew
> >
> >
> > --
> > Florian
> 
> There seems to be some confusion here.
> The "normal" RTL8211F has RXDLY and TXDLY configurable only via pin
> strapping (pull-up/pull-down), not via MDIO.
> The "1588-capable" RTL8211FS has RXDLY configurable via pin strapping
> (different pin than the regular 8211F) and TXDLY via page 0xd08,
> register 17, bit 8.
> I think setting the Tx delay via MDIO for the normal RTL8211F is snake oil.
> Disclaimer: I don't work for Realtek either, so I have no insight on
> why it is like that.
> From Linux' point of view, there are two aspects:
> * Erroring out now will likely just break something that was working
> (since it was relying on hardware strapping and the DT phy-mode
> property was more or less informative).
> * Arguably what is wrong here is the semantics of the phy-mode
> bindings for RGMII. It gets said a lot that DT means "hardware
> description", not "hardware configuration". So having said that, the
> correct interpretation of phy-mode = "rgmii-id" is that the operating
> system is informed that RGMII delays were handled in both directions
> (either the PHY was strapped, or PCB traces were lengthened). But the
> current meaning of "rgmii-id" in practice is an imperative "PHY
> driver, please apply delays in both directions" (or MAC driver, if
> it's fixed-link).
> 
> Thanks,
> -Vladimir

Hello Vladimir, Florian and Andrew

Thanks for your comments on this matter. Let me sum my understanding of
this up so we'd set a checkpoint of the rtl8211* interface delays
discussion.

rtl8211(e|f) TX/RX delays can be configured either by external pins
strapping or via software registers. This is one of the clue to provide
a proper config_init method code. But not all rtl8211f phys provide
that software register, and if they do it only concerns TX-delay (as we
aware of). So we need to take this into account when creating the updated
versions of these functions.

(Martin, I also Cc'ed you in this discussion, so if you have anything to
say in this matter, please don't hesitate to comment.)

As Vladimir fairly pointed out DT should be considered as a "hardware
description", and not a "hardware configuration". But I would correct
the interpretation you suggested a bit. Current phy-mode property meaning
I would explain as a MAC-PHY interface description (so it complies with
"DT - hardware description" rule). So "rgmii" means TXC/RXC, TXD[4] RXD[4],
RX_CTL lanes, etc; "gmii" - GTXCLK, TXCLK/RXCLK, TXD[8], RXD[8],
TXEN, RXEN, COL, CS lanes, etc and so on. The "-*id" suffixes are something
that describe the logical signal delays, which due to the physical lanes design
might be required so the corresponding "{r,g,rg}mii" interface would work
correctly.

Then in accordance with the phy-mode property value MAC and PHY drivers
determine which way the MAC and PHY are connected to each other and how
their settings are supposed to be customized to comply with it. This
interpretation perfectly fits with the "DT is the hardware description"
rule.

Finally I dig into the available rtl8211(e|f) datasheets a bit deeper
and found out, that rtl8211f PHYs provide the RGMII interface only.
While there is only one model of rtl8211e PHY which aside from the default
RGMII-interface can work over MII/GMII-interfaces (which BTW can be
enabled via a pin strapping and via a register I used for delay
settings). So even if MAC provides a way to enable MII/GMII/RGMII/SGMII/etc
interfaces the PHY driver should refuse to work over interfaces
it' device doesn't support by design. This is what lacks the current
rtl8211(f|e)_config_init methods design. (Andrew also might have
suggested something like this, though I am not sure I fully understood
what he meant.)

So as all of this info must be taken into account to create a proper driver
rtl8211(e|f) config_init methods. As I see it we need to provide the following
alterations to the realtek driver:
rtl8211f config_init:
- RGMII-interface is only supported, so return an error if any other
interface mode is requested. Andrew also suggested to accept
the PHY_INTERFACE_MODE_NA mode as an implication to leave the mode as is.
Although I have a doubt about this since none of the PHY' drivers
does this at the moment. Any comment on this?
- phy-mode = "rgmii", no delays need to be set on the PHY side, so clear
{page=0xd08, register=0x11, bit=8} bit and rely on the RXD pin being pulled
low (RX delay is also disabled).
- phy-mode = "rgmii-id", all delays are supposed to be set on the PHY side.
We can manually set the TX-delay, while RX-delay is set over an external pin.
So set the {page=0xd08, register=0x11, bit=8} bit only, and rely on the
hardware designer pulling the RXD pin high.
- phy-mode = "rgmii-txid", set the {page=0xd08, register=0x11, bit=8} bit only,
and rely on the hardware designer pulling the RXD pin low.
- phy-mode = "rgmii-rxid", clear the {page=0xd08, register=0x11, bit=8} bit only,
and rely on the hardware designer pulling the RXD pin high.

rtl8211e config_init:
- MII/GMII/RGMII-interfaces are only supported, so return an error if any other
interface mode is requested. The same thought about PHY_INTERFACE_MODE_NA is
applicable here. 
- MII/GMII-interface can be enabled via the Mode pin strapping or via the
configuration register I've used to set the delays. So use it to enable/disable
either MII/GMII or RGMII interface mode.
- phy-mode = ("rgmii"|"rgmii-id"|"rgmii-txid"|"rgmii-rxid") - enable and disable
the TX/RX-delay bits of the corresponding register, since either of these modes
can be configured by software.


Could you comment on these thoughts so we'd finally come up with a final
decision and I'd send out a new version of the patchset.

-Sergey
