Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 710CAEA22
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 20:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbfD2S3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 14:29:51 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36805 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728962AbfD2S3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 14:29:51 -0400
Received: by mail-wr1-f66.google.com with SMTP id o4so5539748wra.3;
        Mon, 29 Apr 2019 11:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BFZmWgLdy4ykcNe/TIuE4Y6yUre/3XY2vSeqK8r6OmY=;
        b=C72veEyoMpx+St4h0M0XyY/oHvtg3/QKE7xADm0qC7WtPJ1GOYmG6f5+jtDIQZFHTh
         B0MMyqO/CLpT13RWG9qjH4pstogDv5rfFHpX/fc6SNI4KMDzbu3pjD0ytWp0Kv34tfiV
         yErfC9z4Mtmpv8vfeZDgPK3a74It8J3zGFBLoJ+aVe+MMn0VwzKvogm3Wwc5VZ7jNwz5
         mLC2EzGhQ78dbteiRSu7BtdHL5Abpsp962YvAsv9vFczxz23jXOjnKzLE6XmaccVtrAf
         MJzZU2mzqpRrjr/fvKNCuvj6+n30lvXvCVJXatigwe8T+I/KJFEj4G9HyCD5bPp15iwj
         zuAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BFZmWgLdy4ykcNe/TIuE4Y6yUre/3XY2vSeqK8r6OmY=;
        b=YPwj4Cqna5wrFF8sDISg3kxeG2Ov8z68pZ951rzyS6nGM5H8KwwHEjx9Hgj5kaJY0t
         qwAHTeBpdbXGzMp3HiT6yKbAAnfEXV1oMGLbIgR2Lb1/jp070ZT5+/Y/V+r1YowBxv8y
         9LeYVqhUY0ZIUQ9oukJJGe9wnbku1rX7+3EHUveI5iO/FasEvxL0EVvz/gZATuYeBY8/
         Iv73aIo3rhHvh+zkQTz5iKKN8lV+AtVlcbGzebz6fjrPuV2VqZoUrLp3MRA1NRRr0mBY
         WvRzopHchxCFBD4roI8j8PCKWtXaTJmQppx2oEciWzR/rGdfZfQTbO+mscUgEaJgr8q2
         uRZw==
X-Gm-Message-State: APjAAAVCeMyvuYdcu7tLRAjs0JitjCsWuCblHTon9BRkDkZ/Km0ckF+T
        nNkGChfyDUcbsLrLP3QrifpQ/GSWbgUba9c1WjAmPxseaGc=
X-Google-Smtp-Source: APXvYqxvFR2auxcmCUH1Vm273Y/vIr6fBoELXmpxpTYxXcxpaFZEpqxSViNim2HjoPBUi+Lwvx3Z+0sWkGhb6aGz5tk=
X-Received: by 2002:adf:cc8a:: with SMTP id p10mr257791wrj.34.1556562589013;
 Mon, 29 Apr 2019 11:29:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190426212112.5624-1-fancer.lancer@gmail.com>
 <20190426212112.5624-2-fancer.lancer@gmail.com> <20190426214631.GV4041@lunn.ch>
 <20190426233511.qnkgz75ag7axt5lp@mobilestation> <f27df721-47aa-a708-aaee-69be53def814@gmail.com>
In-Reply-To: <f27df721-47aa-a708-aaee-69be53def814@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 29 Apr 2019 21:29:37 +0300
Message-ID: <CA+h21hpTRCrD=FxDr=ihDPr+Pdhu6hXT3xcKs47-NZZZ3D9zyg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: phy: realtek: Change TX-delay setting for
 RGMII modes only
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Apr 2019 at 20:39, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 4/26/19 4:35 PM, Serge Semin wrote:
> > On Fri, Apr 26, 2019 at 11:46:31PM +0200, Andrew Lunn wrote:
> >> On Sat, Apr 27, 2019 at 12:21:12AM +0300, Serge Semin wrote:
> >>> It's prone to problems if delay is cleared out for other than RGMII
> >>> modes. So lets set/clear the TX-delay in the config register only
> >>> if actually RGMII-like interface mode is requested.
> >>>
> >>> Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
> >>>
> >>> ---
> >>>  drivers/net/phy/realtek.c | 16 ++++++++++++----
> >>>  1 file changed, 12 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> >>> index ab567a1923ad..a18cb01158f9 100644
> >>> --- a/drivers/net/phy/realtek.c
> >>> +++ b/drivers/net/phy/realtek.c
> >>> @@ -163,16 +163,24 @@ static int rtl8211c_config_init(struct phy_device *phydev)
> >>>  static int rtl8211f_config_init(struct phy_device *phydev)
> >>>  {
> >>>     int ret;
> >>> -   u16 val = 0;
> >>> +   u16 val;
> >>>
> >>>     ret = genphy_config_init(phydev);
> >>>     if (ret < 0)
> >>>             return ret;
> >>>
> >>> -   /* enable TX-delay for rgmii-id and rgmii-txid, otherwise disable it */
> >>> -   if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> >>> -       phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
> >>> +   /* enable TX-delay for rgmii-id/rgmii-txid, and disable it for rgmii */
> >>> +   switch (phydev->interface) {
> >>> +   case PHY_INTERFACE_MODE_RGMII:
> >>> +           val = 0;
> >>> +           break;
> >>> +   case PHY_INTERFACE_MODE_RGMII_ID:
> >>> +   case PHY_INTERFACE_MODE_RGMII_TXID:
> >>>             val = RTL8211F_TX_DELAY;
> >>> +           break;
> >>> +   default: /* the rest of the modes imply leaving delay as is. */
> >>> +           return 0;
> >>> +   }
> >>
> >> So there is no control of the RX delay?
> >>
> >
> > As you can see it hasn't been there even before this change. So I suppose
> > either the hardware just doesn't support it (although the openly available
> > datasheet states that there is an RXD pin) or the original driver developer
> > decided to set TX-delay only.
> >
> > Just to make sure you understand. I am not working for realtek and don't
> > posses any inside info regarding these PHYs. I was working on a project,
> > which happened to utilize a rtl8211e PHY. We needed to find a way to
> > programmatically change the delays setting. So I searched the Internet
> > and found the U-boot rtl8211f driver and freebsd-folks discussion. This
> > info has been used to write the config_init method for Linux version of the
> > PHY' driver. That's it.
> >
> >> That means PHY_INTERFACE_MODE_RGMII_ID and
> >> PHY_INTERFACE_MODE_RGMII_RXID are not supported, and you should return
> >> -EINVAL.
> >>
> >
> > Apparently the current config_init method doesn't support RXID setting.
> > The patch introduced current function code was submitted by
> > Martin Blumenstingl in 2016:
> > https://patchwork.kernel.org/patch/9447581/
> > and was reviewed by Florian. So we'd better ask him why it was ok to mark
> > the RGMII_ID as supported while only TX-delay could be set.
> > I also failed to find anything regarding programmatic rtl8211f delays setting
> > in the Internet. So at this point we can set TX-delay only for f-model of the PHY.
> >
> > Anyway lets clarify the situation before to proceed further. You are suggesting
> > to return an error in case if either RGMII_ID or RGMII_RXID interface mode is
> > requested to be enabled for the PHY. It's fair seeing the driver can't fully
> > support either of them.
>
> That is how I read Andrew's suggestion and it is reasonable. WRT to the
> original changes from Martin, he is probably the one you would want to
> add to this conversation in case there are any RX delay control knobs
> available, I certainly don't have the datasheet, and Martin's change
> looks and looked reasonable, seemingly independent of the direction of
> this very conversation we are having.
>
> But what about the rest of the modes like GMII, MII
> > and others?
>
> The delays should be largely irrelevant for GMII and MII, since a) the
> PCB is required to have matching length traces, and b) these are not
> double data rate interfaces
>
> > Shouldn't we also return an error instead of leaving a default
> > delay value?
>
> That seems a bit harsh, those could have been configured by firmware,
> whatever before Linux comes up and be correct and valid. We don't know
> of a way to configure it, but that does not mean it does not exist and
> some software is doing it already.
>
> >
> > The same question can be actually asked regarding the config_init method of
> > rtl8211e PHY, which BTW you already tagged as Reviewed-by.
> >
> >> This is where we get into interesting backwards compatibility
> >> issues. Are there any broken DT blobs with rgmii-id or rgmii-rxid,
> >> which will break with such a change?
> >>
> >
> > Not that I am aware of and which simple grep rtl8211 could find. Do you
> > know about one?
> >
> > -Sergey
> >
> >>      Andrew
>
>
> --
> Florian

There seems to be some confusion here.
The "normal" RTL8211F has RXDLY and TXDLY configurable only via pin
strapping (pull-up/pull-down), not via MDIO.
The "1588-capable" RTL8211FS has RXDLY configurable via pin strapping
(different pin than the regular 8211F) and TXDLY via page 0xd08,
register 17, bit 8.
I think setting the Tx delay via MDIO for the normal RTL8211F is snake oil.
Disclaimer: I don't work for Realtek either, so I have no insight on
why it is like that.
From Linux' point of view, there are two aspects:
* Erroring out now will likely just break something that was working
(since it was relying on hardware strapping and the DT phy-mode
property was more or less informative).
* Arguably what is wrong here is the semantics of the phy-mode
bindings for RGMII. It gets said a lot that DT means "hardware
description", not "hardware configuration". So having said that, the
correct interpretation of phy-mode = "rgmii-id" is that the operating
system is informed that RGMII delays were handled in both directions
(either the PHY was strapped, or PCB traces were lengthened). But the
current meaning of "rgmii-id" in practice is an imperative "PHY
driver, please apply delays in both directions" (or MAC driver, if
it's fixed-link).

Thanks,
-Vladimir
