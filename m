Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B673412D61
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 05:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbhIUD0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 23:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351595AbhIUCkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 22:40:04 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A501C08E935;
        Mon, 20 Sep 2021 19:16:25 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r2so19283507pgl.10;
        Mon, 20 Sep 2021 19:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gEQUmF5qAOUpNTdIXxk8/9tLYK1uPImf5fKr1IDf3wE=;
        b=dH71tSrltEBunSDXVlVaU3sPJQ4lHi6n+2yF3QjOwBDKUzoF7Jx6HB4peLJNylBGZ4
         6fwkElgfomgWmhSd48/TOlahdYZND3eC9W3qEko1I55O9Xc0Mh9bCBGyus6Rgon4TEFI
         cPC+JJlQgpe7uaow4flJcD0FcyPRngvJMjF07a2VShhdRmbsBqZosVzDhjWweBpTbcJz
         TuAM802/bo5an0K6xx6KKjwnjW5bMwJC7oinbh0Xanq/HRYJSTRJA6diz+kF1QkcSGU5
         bSE+UdOkrOir2Nc+lgKyZ7B0/iK2L7mZnaQpS6FlO2fSk/5g8X33iVlHdtNtvwPsPOiv
         WQdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gEQUmF5qAOUpNTdIXxk8/9tLYK1uPImf5fKr1IDf3wE=;
        b=OJHBRr6JLXh+38fosNShgZPtJGjZ6gPO0mHZOCaaItJw7D3c04m4SaoFiqXTHbwwH9
         4PgXYNYO3u6DKkGxmTkJKbOrpEn56XaW3iN/mTMEIbldcMA4fdd3HAVeRjojTVvCQPfO
         Cl6y3waad+j2k/rYP1iJUS5vVPv7GW9zKTP9K0P7YyvDETOxkORfoGWSdotff2RxqrqL
         G6DHsrCBWqxFO9zh/jkONb7Ngv0UX5uofBr2me25bkfUYSH36vNu35Ky3xyv8fVJgjtP
         vfAy2salKo3PAlhe6ZKi413NCslLQm10hfSmXxyPATDVvakEV6UakhdJPHKqPsX6cKCQ
         mT2w==
X-Gm-Message-State: AOAM531HmyGRqAelcVyT2THggiAZz3d9BBJvOW+kW0WRe66Zj6kZBRKV
        HCEU4V5p3X+U1g9mK45hzYo=
X-Google-Smtp-Source: ABdhPJwnjvH24pjyfzqJg0BEyKsBsGTpNfTMz2JSfhhUmz9D38nJnvCvThJdrs3xEgf+qu1l5tIDBQ==
X-Received: by 2002:a63:2047:: with SMTP id r7mr25616446pgm.398.1632190584450;
        Mon, 20 Sep 2021 19:16:24 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id n15sm624615pjj.36.2021.09.20.19.16.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 19:16:23 -0700 (PDT)
Message-ID: <4c552594-5923-ba55-af2f-8a0f86936fca@gmail.com>
Date:   Mon, 20 Sep 2021 19:16:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH net 1/2] net: dsa: don't allocate the slave_mii_bus using
 devres
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
References: <20210920214209.1733768-1-vladimir.oltean@nxp.com>
 <20210920214209.1733768-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210920214209.1733768-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/20/2021 2:42 PM, Vladimir Oltean wrote:
> The Linux device model permits both the ->shutdown and ->remove driver
> methods to get called during a shutdown procedure. Example: a DSA switch
> which sits on an SPI bus, and the SPI bus driver calls this on its
> ->shutdown method:
> 
> spi_unregister_controller
> -> device_for_each_child(&ctlr->dev, NULL, __unregister);
>     -> spi_unregister_device(to_spi_device(dev));
>        -> device_del(&spi->dev);
> 
> So this is a simple pattern which can theoretically appear on any bus,
> although the only other buses on which I've been able to find it are
> I2C:
> 
> i2c_del_adapter
> -> device_for_each_child(&adap->dev, NULL, __unregister_client);
>     -> i2c_unregister_device(client);
>        -> device_unregister(&client->dev);
> 
> The implication of this pattern is that devices on these buses can be
> unregistered after having been shut down. The drivers for these devices
> might choose to return early either from ->remove or ->shutdown if the
> other callback has already run once, and they might choose that the
> ->shutdown method should only perform a subset of the teardown done by
> ->remove (to avoid unnecessary delays when rebooting).
> 
> So in other words, the device driver may choose on ->remove to not
> do anything (therefore to not unregister an MDIO bus it has registered
> on ->probe), because this ->remove is actually triggered by the
> device_shutdown path, and its ->shutdown method has already run and done
> the minimally required cleanup.
> 
> This used to be fine until the blamed commit, but now, the following
> BUG_ON triggers:
> 
> void mdiobus_free(struct mii_bus *bus)
> {
> 	/* For compatibility with error handling in drivers. */
> 	if (bus->state == MDIOBUS_ALLOCATED) {
> 		kfree(bus);
> 		return;
> 	}
> 
> 	BUG_ON(bus->state != MDIOBUS_UNREGISTERED);
> 	bus->state = MDIOBUS_RELEASED;
> 
> 	put_device(&bus->dev);
> }
> 
> In other words, there is an attempt to free an MDIO bus which was not
> unregistered. The attempt to free it comes from the devres release
> callbacks of the SPI device, which are executed after the device is
> unregistered.
> 
> I'm not saying that the fact that MDIO buses allocated using devres
> would automatically get unregistered wasn't strange. I'm just saying
> that the commit didn't care about auditing existing call paths in the
> kernel, and now, the following code sequences are potentially buggy:
> 
> (a) devm_mdiobus_alloc followed by plain mdiobus_register, for a device
>      located on a bus that unregisters its children on shutdown. After
>      the blamed patch, either both the alloc and the register should use
>      devres, or none should.
> 
> (b) devm_mdiobus_alloc followed by plain mdiobus_register, and then no
>      mdiobus_unregister at all in the remove path. After the blamed
>      patch, nobody unregisters the MDIO bus anymore, so this is even more
>      buggy than the previous case which needs a specific bus
>      configuration to be seen, this one is an unconditional bug.
> 
> In this case, DSA falls into category (a), it tries to be helpful and
> registers an MDIO bus on behalf of the switch, which might be on such a
> bus. I've no idea why it does it under devres.
> 
> It does this on probe:
> 
> 	if (!ds->slave_mii_bus && ds->ops->phy_read)
> 		alloc and register mdio bus
> 
> and this on remove:
> 
> 	if (ds->slave_mii_bus && ds->ops->phy_read)
> 		unregister mdio bus
> 
> I _could_ imagine using devres because the condition used on remove is
> different than the condition used on probe. So strictly speaking, DSA
> cannot determine whether the ds->slave_mii_bus it sees on remove is the
> ds->slave_mii_bus that _it_ has allocated on probe. Using devres would
> have solved that problem. But nonetheless, the existing code already
> proceeds to unregister the MDIO bus, even though it might be
> unregistering an MDIO bus it has never registered. So I can only guess
> that no driver that implements ds->ops->phy_read also allocates and
> registers ds->slave_mii_bus itself.
> 
> So in that case, if unregistering is fine, freeing must be fine too.
> 
> Stop using devres and free the MDIO bus manually. This will make devres
> stop attempting to free a still registered MDIO bus on ->shutdown.
> 
> Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
> Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
