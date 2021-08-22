Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D303F4245
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 01:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbhHVXLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 19:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhHVXLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 19:11:45 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C76FC061575;
        Sun, 22 Aug 2021 16:11:03 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id ia27so10808966ejc.10;
        Sun, 22 Aug 2021 16:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=7QGoM4tcK5vkzIS0n+cv6yXG9W2hzXnh8S6NLAqs4F8=;
        b=XgPUfQgGuYh1dn4g44W8Dyo7/gMqAF5GCzcZioOCz07yj/capZ89PgdQI78ZkAvXvR
         jdFvWdPf9zJyrk+HaYfbQDaE1cmW1+gZRAs7JoimsuDsaSEfi/n6DT8veIO5EOXSUV2e
         LqQhrx7PJ1MrmaHGW1EKiNaZWwbVkPAuMgzvwwBnM9gbB7TZ69yQBpXyP0CAIZMopsFu
         6PlNFtnyWvLHZaa1yQJwOB2JDiajf/UHGG+C7CAHowk+YysHSIetvLFwRSM7TKnpwWmU
         3qTlzTqSsTwT5O8jpDEoMhOA3PyDXGHGyWgaah7i6HzVa7FcrtufjdtbbV/1KRenTNOn
         6/GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=7QGoM4tcK5vkzIS0n+cv6yXG9W2hzXnh8S6NLAqs4F8=;
        b=L7M2+LvxANlm83BtRzB8cusGfwR+ozUNRIOWQrakpQ+xQTTwMhP3SEkbdSARNtgTbD
         y+fgWc1+PLIGZ+EOjjfw/ET+oMckdtnc575yoNiBhzal5rYPHNyJ2TitEJygrB7HIUn+
         +u7wPF2Zl7MOdyFMW25ehUJuVPBzCbmEQvnOOp7ZetNgjVJx9BJKePLW2AWzgB44Aw0l
         XMvGheNsyX/42Ew2iYLc3IaMY1RGuVWJo1nQsf6ZQb74tJEi321vfzOnShuZXBM4dF05
         xK6hTRxG5kPTuBEqROw02HtNk9zH2pzsTjJaoDbWxJw+7CkitSrkEn/LpsZr86HjpqeV
         UHQQ==
X-Gm-Message-State: AOAM530rKQ2JBPXQzMMM69LED6LwYFjqRw0YwR5uIamrgIiM1GqRO9ch
        MRTcUssXT2XQ76mHVvHctzw=
X-Google-Smtp-Source: ABdhPJzzgDuTN/0aAer4kf7S7J0CBNx1AYhhZpUR8hRpmK0h8dwIQ/OfZ/oSzcpnOa/ZUtUAujT31Q==
X-Received: by 2002:a17:906:8804:: with SMTP id zh4mr3980934ejb.395.1629673861702;
        Sun, 22 Aug 2021 16:11:01 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id s3sm6400008ejm.49.2021.08.22.16.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 16:11:01 -0700 (PDT)
Date:   Mon, 23 Aug 2021 02:10:59 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 1/5] net: dsa: realtek-smi: fix mdio_free
 bug on module unload
Message-ID: <20210822231059.l2xkesbvrfyqgbve@skbuf>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-2-alvin@pqrs.dk>
 <20210822215442.a2xywnodg7qwf2b5@skbuf>
 <65997ecd-d405-c258-89d2-d6418c3ae2c4@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <65997ecd-d405-c258-89d2-d6418c3ae2c4@bang-olufsen.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 10:42:23PM +0000, Alvin Šipraga wrote:
> > Objection: dsa_switch_teardown has:
> >
> > 	if (ds->slave_mii_bus && ds->ops->phy_read)
> > 		mdiobus_unregister(ds->slave_mii_bus);
>
> This is unregistering an mdiobus registered in dsa_switch_setup:
>
> 	if (!ds->slave_mii_bus && ds->ops->phy_read) {
> 		ds->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
> 		if (!ds->slave_mii_bus) {
> 			err = -ENOMEM;
> 			goto teardown;
> 		}
>
> 		dsa_slave_mii_bus_init(ds);
>
> 		err = mdiobus_register(ds->slave_mii_bus);
> 		if (err < 0)
> 			goto teardown;
> 	}
>
> However, we don't enter this codepath because:
>
> - ds->slave_mii_bus is already set in the call to ds->ops->setup()
> before the code snippet above;
> - ds->ops->phy_read is not set.
>
> We don't want to either, since we want to use of_mdiobus_register().
>
> >
> > The realtek_smi_setup_mdio function does:
> >
> > 	smi->ds->slave_mii_bus = smi->slave_mii_bus;
> >
> > so I would expect that this would result in a double unregister on some
> > systems.
> >
> > I haven't went through your new driver, but I wonder whether you have
> > the phy_read and phy_write methods implemented? Maybe that is the
> > difference?
>
> Right, phy_read/phy_write are not set in the dsa_switch_ops of
> rtl8365mb. So we should be safe.

Correct, DSA only unregisters the ds->slave_mii_bus it has registered,
which is provided when the driver implements phy_read and/or phy_write
but does not set/register ds->slave_mii_bus itself. The patch is fine.

>
> It did get me thinking that it would be nice if dsa_register_switch()
> could call of_mdiobus_register() when necessary, since the snippet above
> (and its call to dsa_slave_mii_bus_init()) is almost same as
> realtek_smi_setup_mdio(). It would simplify some logic in realtek-smi
> drivers and obviate the need for this patch. I am not sure what the
> right approach to this would be but with some pointers I can give it a shot.

I don't think DSA could call of_mdiobus_register, since you would need
to pass it the OF node you want and the read/write ops for the bus and
its name and a place to store it (one DSA switch might have more than
one MDIO bus), and I just fail to see the point of doing that.

The whole point of having ds->slave_mii_bus (either allocated by the
driver or by DSA) is to access the PHY registers of a port under a very
narrow set of assumptions: it implicitly assumes that the port N has a
PHY at MDIO address N, as opposed to doing the usual which is to follow
the phy-handle, and that there is a single internal MDIO bus. DSA will
do this as last resort in dsa_slave_phy_setup. But if you use
of_mdiobus_register, just put a phy-handle in the device tree and be
done, you don't need ds->ops->phy_read or ds->ops->phy_write, nor can
you/should you overload these pointers for DSA to do the
of_mdiobus_register for you.

> >
> >>   static enum dsa_tag_protocol rtl8366_get_tag_protocol(struct dsa_switch *ds,
> >>   						      int port,
> >>   						      enum dsa_tag_protocol mp)
> >> @@ -1505,6 +1512,7 @@ static int rtl8366rb_detect(struct realtek_smi *smi)
> >>   static const struct dsa_switch_ops rtl8366rb_switch_ops = {
> >>   	.get_tag_protocol = rtl8366_get_tag_protocol,
> >>   	.setup = rtl8366rb_setup,
> >> +	.teardown = rtl8366rb_teardown,
> >>   	.phylink_mac_link_up = rtl8366rb_mac_link_up,
> >>   	.phylink_mac_link_down = rtl8366rb_mac_link_down,
> >>   	.get_strings = rtl8366_get_strings,
> >> --
> >> 2.32.0
> >>
