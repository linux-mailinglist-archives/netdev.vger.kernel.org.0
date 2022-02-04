Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2964AA399
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354649AbiBDWy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:54:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43270 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231162AbiBDWy4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 17:54:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oy+ZGHqwRh7hOUZO4LcUt2H3aLODsyQ1hM4QpkJBUNY=; b=VKrwU16yfq7AedImRakIOxhI/n
        DfZ7Ciogw9mjqS2uyRhJvAaETrZRNYez3Q60zkdmdCfLmKwiI77aLRya6OVOIVOjiYfB7ElsZL+Cf
        FTxEs7PlZmNh/iWXeni+EkCsEGWizeRY2GbVEc3auGUbyT5KuALVRVQza3d/kH9l1qII=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nG7TU-004KaN-HT; Fri, 04 Feb 2022 23:54:40 +0100
Date:   Fri, 4 Feb 2022 23:54:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Martin Schiller <ms@dev.tdt.de>, Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>, hkallweit1@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v3] net: phy: intel-xway: enable integrated led
 functions
Message-ID: <Yf2usAHGZSUDvLln@lunn.ch>
References: <20210421055047.22858-1-ms@dev.tdt.de>
 <CAJ+vNU1=4sDmGXEzPwp0SCq4_p0J-odw-GLM=Qyi7zQnVHwQRA@mail.gmail.com>
 <YfspazpWoKuHEwPU@lunn.ch>
 <CAJ+vNU2v9WD2kzB9uTD5j6DqnBBKhv-XOttKLoZ-VzkwdzwjXw@mail.gmail.com>
 <YfwEvgerYddIUp1V@lunn.ch>
 <CAJ+vNU1qY1VJgw1QRsbmED6-TLQP2wwxSYb+bXfqZ3wiObLgHg@mail.gmail.com>
 <YfxtglvVDx2JJM9w@lunn.ch>
 <CAJ+vNU1td9aizbws-uZ-p-fEzsD8rJVS-mZn4TT2YFn9PY2n_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ+vNU1td9aizbws-uZ-p-fEzsD8rJVS-mZn4TT2YFn9PY2n_w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The PHY_INTERRFACE_MODE_NA is a neat trick that I will remember but it
> would only help with the rgmii delay issue and not the LED issue (this
> patch). The GPY111 has some really nasty errata that is going to cause
> me to have a very hackish work-around anyway and I will be disabling
> the PHY driver to stay out of the way of that workaround

Well, ideally we want the workaround for the erratas in the kernel
drivers. In the long run, you will get less surprises if you add what
you need to Linux, not hide stuff away in the bootloader.

> As far as changing a driver to force a LED configuration with no dt
> binding input (like this patch does) it feels wrong for exactly the
> same reason - LED configuration for this PHY can be done via
> pin-strapping and this driver now undoes that with this patch.

Is it possible to read the pin strapping pins? If we know it has been
pin strapped, then a patch to detect this and not change the LED
configuration seems very likely to be accepted.

      Andrew
