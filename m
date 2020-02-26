Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7251F17078C
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 19:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgBZSWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 13:22:52 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38990 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbgBZSWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 13:22:52 -0500
Received: by mail-ed1-f66.google.com with SMTP id m13so5003736edb.6;
        Wed, 26 Feb 2020 10:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4F5P1PauU1ebi/qO8Sg8RRFuYolggB9ao3VqBLODYOc=;
        b=RDEaga21ySZ72U2wyLsvv547LGdrKjUlXejb8qsNUo+YFMKVWP8sM/rbETj4Zz+ibr
         TMO4UvFdtSsO1ZfN4K0MWAWllIkXsYt75ggtVrrDpJJh/26ooVOpCvLdGbb51LDWiLSf
         4tnoK2g3HnRx9x2mYAirOKx8jukgJCmuWv6H1xogctnhhv4My4uO+w3HZ7HwEZ1LvgwJ
         lNlh7sH1FNsqJA0SdA92V36QN1Pt8GtYt8WRJN2IgTN7e8yJVLnt0FiZCeSa1wpxBCPJ
         tK3n/8wHMQ5Mx180pC9qZrpEuXq3btWQZcTFxR0kLz/57mJzzvu6Wq3WTqoLn1d6nsT2
         nYuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4F5P1PauU1ebi/qO8Sg8RRFuYolggB9ao3VqBLODYOc=;
        b=CWq0/Nwj/V+KAdKmRCtJWpGyq1mbPcTiKaBKhnzqyDJevlraxZmQ+PrkaghMAu2FeW
         q7VANWmGBh2MJFrYZQwZNSQx4CJ/ra7Uje2AbexMTOfkf1Gj8tnB92NDyciN2ZHzdKkA
         71JwuLsAcuA6JfdrvBn/uJ0NioIh3nbChuizOqI7Fo0rJ98Lq8IOsv8S0IgSPHVlmTVI
         vFgIJa1UA93exPn4lOfeoTlIie98CcbMwoQQuWrmpup353gaAGTyqolFuuUUrD71XOxL
         G8D5en5ovvw14O6G22mLuwBDJygJwzHGqLlhpxBhVRJUXybLiOwUxlkKJ9zxVylU9Z8v
         cbbQ==
X-Gm-Message-State: APjAAAUtL2AaqZgcvq6oenmr3fh9sStITbAkmFIdFu7YaGzysI8mLfsK
        naL9g3T1l9js/lJabK/MEQR9iHvzdVf5vI7pZS4=
X-Google-Smtp-Source: APXvYqzNB2eI1k7C3+5x8npyIPGw1ri/9DkGYVNZqj+crpBw+z1oumpxk11mzsPFWqmmwWOEY7cgnFNbkJ+PtccHAoI=
X-Received: by 2002:aa7:c44e:: with SMTP id n14mr622848edr.179.1582741370130;
 Wed, 26 Feb 2020 10:22:50 -0800 (PST)
MIME-Version: 1.0
References: <20200226102312.GX25745@shell.armlinux.org.uk> <E1j6tqv-0003G6-BO@rmk-PC.armlinux.org.uk>
 <CA+h21hrR1Xkx9gwAT2FHqcH38L=xjWiPxmF2Er7-4fHFTrA8pQ@mail.gmail.com>
 <20200226115549.GZ25745@shell.armlinux.org.uk> <CA+h21hqjMBjgQDee8t=Csy5DXVUk9f=PP0hHSDfkuA746ZKzSQ@mail.gmail.com>
 <20200226133614.GA25745@shell.armlinux.org.uk> <CA+h21hqHfC0joRDhCQP6MntFdVaApFiC51xk=tUf3+y-C7sX_Q@mail.gmail.com>
In-Reply-To: <CA+h21hqHfC0joRDhCQP6MntFdVaApFiC51xk=tUf3+y-C7sX_Q@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 26 Feb 2020 20:22:39 +0200
Message-ID: <CA+h21hpzCY=+0U4JgFbqGLS=Sh6SjkSt=4J9e0AGVHKJPOHq1A@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/8] net: phylink: propagate resolved link
 config via mac_link_up()
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Feb 2020 at 20:21, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Wed, 26 Feb 2020 at 15:36, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> >
> > dpaa2 is complicated by the firmware, and that we can't switch the
> > interface mode between (SGMII,1000base-X) and 10G.
> >
> > If the firmware is in "DPMAC_LINK_TYPE_PHY" mode, it expects to be told
> > the current link parameters via the dpmac_set_link_state() call - it
> > isn't clear whether that needs to be called for other modes with the
> > up/down state (firmware API documentation is poor.)
> >
>
> With PCS control in Linux, I am pretty sure that you don't want
> anything other than DPMAC_LINK_TYPE_PHY anyway.
> Basically in DPMAC_LINK_TYPE_FIXED, the MC firmware is in control of
> the PCS and polls its link state to emit link notifications to objects
> connected to the DPMAC. So Linux control of PCS would class with

s/class/clash/

> firmware control of the PCS, leading to undesirable side-effects to
> say the least.
>
> > --
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> > According to speedtest.net: 11.9Mbps down 500kbps up
>
> Regards,
> -Vladimir
