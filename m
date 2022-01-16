Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5DF48FF87
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 23:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236385AbiAPWsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 17:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbiAPWsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 17:48:16 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE58C061574;
        Sun, 16 Jan 2022 14:48:16 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id c126-20020a1c9a84000000b00346f9ebee43so18572167wme.4;
        Sun, 16 Jan 2022 14:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fMXxzWLOUHB7TFH622yZfY/BCxhuTlONmrOXtpuUffc=;
        b=NAtdmYzjVXFHDQpKQPEImXSU+peoKoKcfZzFvNhjqghBUSi/PBskMAl6Q1l9wN/Lm+
         kI4asrE4RLdVxYiDVFYaUkK7wCGjMkUOi8LFLxz7quOOdZvivFe8BSot7KNvqH8DHDL9
         dtXNvUc1+IYAxLhTrlByDb+6wLLIQqjq/y+wNyvMn+WYLWZB1H3aFNkXAOYg2427Fo/d
         tAttpF6USd04fzdLzsjks8l2HcMhyqPqPInfDg1ErZymMCrZH8EIYfTdYsqo6u1mTzMD
         oDidB0LCWtoqmZWZugxyJWzq2O3XTpXnema2S0a9Ju0cai3rUXUPjqjGMSr1GWWVVv+v
         mTyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fMXxzWLOUHB7TFH622yZfY/BCxhuTlONmrOXtpuUffc=;
        b=4sIa69We2+sOG3VJeW0lyO6D0rXLCRSuG7LWYuql20lm35/xRtEetLQLL/ncM43KEO
         SGkeiwe175UlLltxTyKcdRfwY56PWO1alNVBtVAnECSA6NZFke9L4a3t/9HuwLt+ulBw
         ak0tn5Aocjoso+4ARqs+KGFIve9WB84lGSr9WXy/UCfeW8fczMM9D5UU89v8f5TGKv7b
         Yug6N1KstyNRm8aXKxOGYo1ouA1hjg75w7Frk/zxPGjicEY9LAwtT2K4IchkN+RJRd33
         5FbQ5wzhFnOB7XBZzDCTG5Gt2hOdbhIshitHALPC/OBlnjr3+xlRecN7iGZI/jJb9EG6
         39SQ==
X-Gm-Message-State: AOAM533AJ3jhcfdmd1SRczdQLyVxgQPi9gxSvahHP13im7Pl+OG0P8S0
        cejrGpXB2M8xNNh9qgjnN+Fr/QvBiElMBFrQcTg=
X-Google-Smtp-Source: ABdhPJzkodFeUzDlLPbWc/+tvYcRu+QOGzhFJCZM6CGTXtSt0JRJrCqVPMZWOdC/Dz3oK2Tu+nJw+7LqSV/wN+SR9G0=
X-Received: by 2002:a5d:4a02:: with SMTP id m2mr17091167wrq.154.1642373294926;
 Sun, 16 Jan 2022 14:48:14 -0800 (PST)
MIME-Version: 1.0
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
 <20220112173312.764660-28-miquel.raynal@bootlin.com> <CAB_54W5ojqi2obtNLihCMXsZkh+aN_cVbSTRptq3=PXkpknzJQ@mail.gmail.com>
 <20220113102954.7a0e213e@xps13> <CAB_54W6vnay29dBxpn4EPQXgx1HEXfPm5vsms0q-NpPa2NhE_g@mail.gmail.com>
 <20220114193740.600f5f33@xps13>
In-Reply-To: <20220114193740.600f5f33@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 16 Jan 2022 17:48:03 -0500
Message-ID: <CAB_54W4MP0t1+PQG1hdyLrxhu7+VGUZFaFO85u=Qea095-P8hg@mail.gmail.com>
Subject: Re: [wpan-next v2 27/27] net: ieee802154: ca8210: Refuse most of the
 scan operations
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 14 Jan 2022 at 13:37, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Thu, 13 Jan 2022 20:00:53 -0500:
>
> > Hi,
> >
> > On Thu, 13 Jan 2022 at 04:30, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > alex.aring@gmail.com wrote on Wed, 12 Jan 2022 17:48:59 -0500:
> > >
> > > > Hi,
> > > >
> > > > On Wed, 12 Jan 2022 at 12:34, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > >
> > > > > The Cascada 8210 hardware transceiver is kind of a hardMAC which
> > > > > interfaces with the softMAC and in practice does not support sending
> > > > > anything else than dataframes. This means we cannot send any BEACON_REQ
> > > > > during active scans nor any BEACON in general. Refuse these operations
> > > > > officially so that the user is aware of the limitation.
> > > > >
> > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > > ---
> > > > >  drivers/net/ieee802154/ca8210.c | 25 ++++++++++++++++++++++++-
> > > > >  1 file changed, 24 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> > > > > index d3a9e4fe05f4..49c274280e3c 100644
> > > > > --- a/drivers/net/ieee802154/ca8210.c
> > > > > +++ b/drivers/net/ieee802154/ca8210.c
> > > > > @@ -2385,6 +2385,25 @@ static int ca8210_set_promiscuous_mode(struct ieee802154_hw *hw, const bool on)
> > > > >         return link_to_linux_err(status);
> > > > >  }
> > > > >
> > > > > +static int ca8210_enter_scan_mode(struct ieee802154_hw *hw,
> > > > > +                                 struct cfg802154_scan_request *request)
> > > > > +{
> > > > > +       /* This xceiver can only send dataframes */
> > > > > +       if (request->type != NL802154_SCAN_PASSIVE)
> > > > > +               return -EOPNOTSUPP;
> > > > > +
> > > > > +       return 0;
> > > > > +}
> > > > > +
> > > > > +static int ca8210_enter_beacons_mode(struct ieee802154_hw *hw,
> > > > > +                                    struct cfg802154_beacons_request *request)
> > > > > +{
> > > > > +       /* This xceiver can only send dataframes */
> > > > > +       return -EOPNOTSUPP;
> > > > > +}
> > > > > +
> > > > > +static void ca8210_exit_scan_beacons_mode(struct ieee802154_hw *hw) { }
> > > > > +
> > > > >  static const struct ieee802154_ops ca8210_phy_ops = {
> > > > >         .start = ca8210_start,
> > > > >         .stop = ca8210_stop,
> > > > > @@ -2397,7 +2416,11 @@ static const struct ieee802154_ops ca8210_phy_ops = {
> > > > >         .set_cca_ed_level = ca8210_set_cca_ed_level,
> > > > >         .set_csma_params = ca8210_set_csma_params,
> > > > >         .set_frame_retries = ca8210_set_frame_retries,
> > > > > -       .set_promiscuous_mode = ca8210_set_promiscuous_mode
> > > > > +       .set_promiscuous_mode = ca8210_set_promiscuous_mode,
> > > > > +       .enter_scan_mode = ca8210_enter_scan_mode,
> > > > > +       .exit_scan_mode = ca8210_exit_scan_beacons_mode,
> > > > > +       .enter_beacons_mode = ca8210_enter_beacons_mode,
> > > > > +       .exit_beacons_mode = ca8210_exit_scan_beacons_mode,
> > > > >  };
> > > >
> > > > so there is no flag that this driver can't support scanning currently
> > > > and it works now because the offload functionality will return
> > > > -ENOTSUPP? This is misleading because I would assume if it's not
> > > > supported we can do it by software which the driver can't do.
> > >
> > > I believe there is a misunderstanding.
> > >
> > > This is what I have understood from your previous comments in v1:
> > > "This driver does not support transmitting anything else than
> > > datagrams", which is what I assumed was a regular data packet. IOW,
> > > sending a MAC_CMD such as a beacon request or sending a beacon was not
> > > supported physically by the hardware. Hence, most of the scans
> > > operations cannot be performed and must be rejected (all but a passive
> > > scan, assuming that receiving beacons was okay).
> > >
> >
> > and I said that this driver is a HardMAC transceiver connected to the
> > SoftMAC layer which is already wrong to exist (very special handling
> > is required here).
> > dataframes here are "data" type frames and I suppose it's also not
> > able to deliver/receive other types than data to mac802154.
> >
> > It seems the author of this driver is happy to have data frames only
> > but we need to take care that additional mac802154 handling is simply
> > not possible to do here.
> >
> > > Please mind the update in that hook which currently is just an FYI from
> > > the mac to the drivers and not a "do it by yourself" injunction. So
> > > answering -EOPNOTSUPP to the mac here does not mean:
> > >         "I cannot handle it by myself, the scan cannot happen"
> > > but
> > >         "I cannot handle the forged frames, so let's just not try"
> > >
> >
> > The problem here is that a SoftMAC transceiver should always be
> > capable of doing it by software so the "but case" makes no sense in
> > this layer.
> > On a mac802154 layer and "offload" driver functions as they are and
> > they report me "-ENOTSUPP", I would assume that I can go back and do
> > it by software which again should always be possible to do in
> > mac802154.
> >
> > > > ... I see that the offload functions now are getting used and have a
> > > > reason to be upstream, but the use of it is wrong.
> > >
> > > As a personal matter of taste, I don't like flags when it comes to
> > > something complex like supporting a specific operation. Just in the
> > > scanning procedure there are 4 different actions and a driver might
> > > support only a subset of these, which is totally fine but hard to
> > > properly describe by well-named flags. Here the driver hooks say to
> > > the driver which are interested "here is what is going to happen" and
> > > then they can:
> > > - ignore the details by just not implementing the hooks, let the mac do
> > >   its job, they will then transmit the relevant frames forged by the
> > >   mac
> > > - eventually enter a specific mode internally for this operation, but
> > >   basically do the same as above, ie. transmitting the frames forged
> > >   by the mac
> > > - refuse the operation by returning an error code if something cannot
> > >   be done
> > >
> > > I've experienced a number of situations in the MTD world and later with
> > > IIO drivers where flags have been remodeled and reused in different
> > > manners, until the flag description gets totally wrong and
> > > undescriptive regarding what it actually does. Hence my main idea of
> > > letting drivers refuse these operations instead of having the mac doing
> > > it for them.
> > >
> > > I can definitely use flags if you want, but in this case, what flags do
> > > you want to see?
> > >
> >
> > Do some phy quirks flags which indicate that the transceiver is not
> > capable of doing scan operation by software. Or just use a boolean in
> > phy capabilities (but don't export them to userspace, note that this
> > flag should be removed later) if this operation is not allowed.
>
> I've added a phy flag to distinguish this driver as early as possible.

I was thinking about this a lot and I think the driver is already
buggy in many ways e.g. what happens when we do AF_PACKET raw sockets
and do some different frame types than data. I have no idea, maybe we
should leave it as it is... and simply don't care? Maybe the driver
needs to drop a lot of frames if they are different... it runs already
different than other transceivers which we don't check at all.

- Alex
