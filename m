Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF48D45AC80
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 20:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240048AbhKWTdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 14:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239954AbhKWTda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 14:33:30 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8127EC061714
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 11:30:21 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id x15so96200583edv.1
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 11:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hqd4dcRCG//URmJS7kNBRJSe3g861c87Ppm6Xh6ZhdU=;
        b=MQe3KvFxbtftqHB4bTGwDKGPmdLEWUIC81WsE+32uMqHuNcyEChjojnFrMCmRlcm0J
         8FFcdpibiCV1CSVUTuccPwu7q9EI1oDbnA8/q66Q3Jh2GCEHAcB25ErQ4UTMGUVhs+L/
         IT6fZcUVJjtq4AW3bcFG/QEMuTwdMuUf46GHh5Ccewi0dbsbZkZ+kIVHKA4e6WM9Vb8S
         yRk8Z/P3MjBTgU5rvi/o2ctzkolS3cj6ZnytXrph4MbKDiBlx/pNuJyNAoWNHApk3Wt2
         LJEX7c3U+pwUH8ACKqUnt7Hjusm8xUfAo/Oxy0vNhDYIdOqd+V4Qssrop+nxfRh9otnS
         i6Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hqd4dcRCG//URmJS7kNBRJSe3g861c87Ppm6Xh6ZhdU=;
        b=LPhtHFaNSKrBwai2A84Wl01V7PCc1wsxwboPw6O2FwTzglT4uOydhEZwawIMyyVCWF
         8FoybIvY4FFX7OgN+9TlmLpa0wGldW9SaoBEuneCV+iGf9EpTuwiO2WbUD3DwsBEyspR
         Hyy6q5gXDmTB4QPIxsGIUj8HXDVuDNFxaBksxKxMFWwlIwnAkpgOWtR1Rg8o64Tldfz3
         xk9oftws/oO/p9VLFqN3VsSNid4OOf0EeOszCVv2+X2q0QAw6F6KbmJCAjNSt8BFXlu8
         trApaPwIvbvOUYlS9y7NxJVlubbEoSFdPoCLrk/ZYDVMgS4IbIJj3tGr9zP89dvSogBZ
         TLXg==
X-Gm-Message-State: AOAM533u0sbnpvDT8zd/1d3RFou7udnE7ejoD6C5G5EbhUOdWN7G/ddD
        x1UsuwKxursbdiM5fZhC7w0=
X-Google-Smtp-Source: ABdhPJyeBX7C35H+vad5xry1HQP5yueUnlNXETzdy3KzVPuCmU0Ddc86U/OLTxdsLgg328XWfnOzlg==
X-Received: by 2002:a17:906:dc91:: with SMTP id cs17mr11147526ejc.461.1637695819985;
        Tue, 23 Nov 2021 11:30:19 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id r25sm6282389edt.21.2021.11.23.11.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 11:30:19 -0800 (PST)
Date:   Tue, 23 Nov 2021 21:30:17 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Chris Snook <chris.snook@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 8/8] net: phylink: allow PCS to be removed
Message-ID: <20211123193017.rtvxyvb3oheqoxlz@skbuf>
References: <YZy59OTNCpKoPZT/@shell.armlinux.org.uk>
 <E1mpSba-00BXp6-9e@rmk-PC.armlinux.org.uk>
 <20211123120825.jvuh7444wdxzugbo@skbuf>
 <YZ0R6T33DNTW80SU@shell.armlinux.org.uk>
 <90262b1c-fee2-f906-69df-1171ff241077@seco.com>
 <20211123181515.qqo7e4xbuu2ntwgt@skbuf>
 <472ce8f0-a592-ce5b-0005-7d765b2d0e93@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472ce8f0-a592-ce5b-0005-7d765b2d0e93@seco.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 02:04:03PM -0500, Sean Anderson wrote:
> On 11/23/21 1:15 PM, Vladimir Oltean wrote:
> > On Tue, Nov 23, 2021 at 12:30:33PM -0500, Sean Anderson wrote:
> > > On 11/23/21 11:08 AM, Russell King (Oracle) wrote:
> > > > On Tue, Nov 23, 2021 at 02:08:25PM +0200, Vladimir Oltean wrote:
> > > > > On Tue, Nov 23, 2021 at 10:00:50AM +0000, Russell King (Oracle) wrote:
> > > > > > Allow phylink_set_pcs() to be called with a NULL pcs argument to remove
> > > > > > the PCS from phylink. This is only supported on non-legacy drivers
> > > > > > where doing so will have no effect on the mac_config() calling
> > > > > > behaviour.
> > > > > >
> > > > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > > > > ---
> > > > > >  drivers/net/phy/phylink.c | 20 +++++++++++++++-----
> > > > > >  1 file changed, 15 insertions(+), 5 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > > > > > index a935655c39c0..9f0f0e0aad55 100644
> > > > > > --- a/drivers/net/phy/phylink.c
> > > > > > +++ b/drivers/net/phy/phylink.c
> > > > > > @@ -1196,15 +1196,25 @@ EXPORT_SYMBOL_GPL(phylink_create);
> > > > > >   * in mac_prepare() or mac_config() methods if it is desired to dynamically
> > > > > >   * change the PCS.
> > > > > >   *
> > > > > > - * Please note that there are behavioural changes with the mac_config()
> > > > > > - * callback if a PCS is present (denoting a newer setup) so removing a PCS
> > > > > > - * is not supported, and if a PCS is going to be used, it must be registered
> > > > > > - * by calling phylink_set_pcs() at the latest in the first mac_config() call.
> > > > > > + * Please note that for legacy phylink users, there are behavioural changes
> > > > > > + * with the mac_config() callback if a PCS is present (denoting a newer setup)
> > > > > > + * so removing a PCS is not supported. If a PCS is going to be used, it must
> > > > > > + * be registered by calling phylink_set_pcs() at the latest in the first
> > > > > > + * mac_config() call.
> > > > > > + *
> > > > > > + * For modern drivers, this may be called with a NULL pcs argument to
> > > > > > + * disconnect the PCS from phylink.
> > > > > >   */
> > > > > >  void phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)
> > > > > >  {
> > > > > > +	if (pl->config->legacy_pre_march2020 && pl->pcs && !pcs) {
> > > > > > +		phylink_warn(pl,
> > > > > > +			     "Removing PCS is not supported in a legacy driver");
> > > > > > +		return;
> > > > > > +	}
> > > > > > +
> > > > > >  	pl->pcs = pcs;
> > > > > > -	pl->pcs_ops = pcs->ops;
> > > > > > +	pl->pcs_ops = pcs ? pcs->ops : NULL;
> > > > > >  }
> > > > > >  EXPORT_SYMBOL_GPL(phylink_set_pcs);
> > > > > >
> > > > > > --
> > > > > > 2.30.2
> > > > > >
> > > > >
> > > > > I've read the discussion at
> > > > > https://lore.kernel.org/netdev/cfcb368f-a785-9ea5-c446-1906eacd8c03@seco.com/
> > > > > and I still am not sure that I understand what is the use case behind
> > > > > removing a PCS?
> > > >
> > > > Passing that to Sean to answer in detail...
> > > 
> > > My original feedback was regarding selecting the correct PCS to use. In
> > > response to the question "What PCS do you want to use for this phy
> > > interface mode?" a valid response is "I don't need a PCS," even if for a
> > > different mode a valid response might be "Please use X PCS."
> > 
> > Yes, but that is not a reason why you'd want to _remove_ one. Just don't
> > call phylink_set_pcs() in the first place, there you go, no PCS.
> 
> Yeah.
> 
> > > Because this function is used in validate(), it is necessary to
> > > evaluate "what-if" scenarios, even if a scenario requiring a PCS and
> > > one requiring no PCS would never actually be configured.
> > 
> > Yes, but on the same port on the same board? The MAC-side PCS is an
> > integral part of serial Ethernet links, be it modeled as a discrete part
> > by hardware manufacturers or not. We are effectively talking about a
> > situation where a serial link would become parallel, or the other way
> > around. Have you seen such a thing?
> 
> I have not. It's certainly possible to create (since the serial link
> often uses different physical pins from the parallel link). I think
> we can cross that bridge if/when we ever come to it.

So what do you mean, something like a MAC which can be routed dynamically
via pinctrl either to RGMII or to a SERDES lane? I would expect that
would require rather intricate interaction with the net device driver.
Can that be done today from user space, even in principle?

> > > Typically the PCS is physically attached to the next layer in the link,
> > > even if the hardware could be configured not to use the PCS. So it does
> > > not usually make sense to configure a link to use modes both requiring a
> > > PCS and requiring no PCS. However, it is possible that such a system
> > > could exist. Most systems should use `phy-mode` to restrict the phy
> > > interfaces modes to whatever makes sense for the board. I think Marek's
> > > series (and specifically [1]) is an good step in this regard.
> > > 
> > > --Sean
> > > 
> > > [1] https://lore.kernel.org/netdev/20211123164027.15618-5-kabel@kernel.org/
> > 
> > Marek's patches are for reconfiguring the SERDES protocol on the same
> > lanes. But the lanes are still physically there, and you'd need a PCS to
> > talk to them no matter what you do, they won't magically turn into RGMII.
> > If you need to switch the MAC PCS you're configuring with another MAC
> > PCS (within the same hardware block more or less) due to the fact that
> > the SERDES protocol is changing, that doesn't count as removing the PCS,
> > does it? Or what are you thinking of when you say PCS? Phylink doesn't
> > support any other kind of PCS than a MAC-side PCS.
> 
> I mean that with that patch applied, phylink will no longer try and
> validate modes which aren't supported on a particular board (see
> phylink_validate_any). Although, it looks like set_pcs never was called
> in the validate path in the first place (looks like I misremembered).

Sorry if you feel like I am asking too many questions. I just want to
understand what I'm being asked to review here :)

So going back to the initial question. What use case do these patches
help to make some progress with?

As far as I understand, being able to call phylink_set_pcs(NULL) is
basically the end goal of it. Sorry if I'm misinterpreting, Russell says
in the cover letter that "we now need to allow the PCS to be optional
for modern drivers". I really don't know how to interpret what
"optional" means. Just judging from that phrase, I don't interpret
"optional" as "having the ability to remove it dynamically", but rather
"the same driver can either interact with phylink using a pcs [on some
ports] or without a pcs [on other ports]".  But that deeply confuses me
because that's already supported, and many drivers make use of that
ability already, this is why the pl->pcs_ops checks are there.
