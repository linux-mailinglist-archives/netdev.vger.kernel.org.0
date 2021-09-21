Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9F0413141
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 12:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhIUKJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 06:09:31 -0400
Received: from mout.gmx.net ([212.227.17.21]:56905 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229833AbhIUKJ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 06:09:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1632218864;
        bh=QZxXmLWDDXyrpBcPm6Htc27LFauCgm5JyGZwbhwuKDY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=FCD9yQ4BTL6mepYHdacT2VlA/5kBUUKLyuVturdfmPvNT3nXLEdEsse4d75oMyZOI
         dehNl25vd25vDV5beifzSb9U4f/dSDYtSFFGL6pgiNmyIuoDH7oXZTcooS1yOX8Zm2
         W1E7JCS6HQjb2+3OjbuNjC/E1qT7r5t1MhieIRwM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([46.223.119.124]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M59C8-1mTicO0244-001BKO; Tue, 21
 Sep 2021 12:07:44 +0200
Subject: Re: [PATCH net 1/2] net: dsa: don't allocate the slave_mii_bus using
 devres
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>
References: <20210920214209.1733768-1-vladimir.oltean@nxp.com>
 <20210920214209.1733768-2-vladimir.oltean@nxp.com>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <95836a0f-a2fd-f557-d8e6-aea044552be4@gmx.de>
Date:   Tue, 21 Sep 2021 12:07:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210920214209.1733768-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:NkAVTnEyhm2vdK9QUdzen/J3N5gtCaSWa0P6AkNwoCQ0amYDijW
 2C1tZ+WS+V+PC7elFG6xVPcQn4/VOVUQxxIoECBqIj/dKmXuSMT2u6X2vMqdyIMOwyGfsfh
 Ck/NQshr7dgzFY2L8PYZjc9rQiWyvJMUF2P9r1gwY/ssmcNrGSGjIg3XEg+EYDPkv9DZYjY
 iFuvlYBrNmjOEk8VSEOPw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wtBxQQDx5hM=:z9y8MdAg8U14iyTYDVsdSn
 7Y1aSWwowYcW3BPzr0PRkRJH8zfeETUccrA9VisCuOcmTau1S3W73G7lhWdu3lbNDQwv8gX7P
 chBFy4F4u9vCtaizSfEE4Cjk0s88xqyj1ObLfh7NtNqvLXu+/x3W7WlxUbgveJGME+ibp+P6O
 rXxNZBY31znaqvW8+VGKDRGy/22HvzbXpojHbKSy5z5+mQBHUBaS1lpEHSvdnEOus0OswNeNm
 5JIvT2H1+tYHl0qUjlotuovfWiAqGrdkKjWK7yCf1+fIoS2cDUaLL4V9X59/NIiQCJwyxUpH+
 6xUI/aCRliQjfRPpdxCtKa30J9c6fsYjGion43e36AU0kdq1nDqkyDdlaAIJl+tGK7jDXzgo1
 5H+OFTFGhdh8T/UEAyRfi+aHsYc8B4S+EkE3p/LpGbVFc2BQCJEjFPkPLyyHrwzDV8ESe12KX
 yC/Z+ptwwf3l9EhpJ+VQeE/zQoL+IHJH+2hOpoJoGFjbFgzf3GaO0skz8L8VWqrnWD/ozDW/k
 Krtvr4oLuKGn/YV5N7esNyR847uMob7hZX2x+na2+tgJvjWwyUFUL70lnswiqghfvfXN+VfSs
 69PDfqHIEyLobBaRNK2UHEclVMa/sSH8xp/iGGzPwSdtuMSU5pPiP1JHmSs5GtrmW7e/ZX8zT
 AXt1cuNy6YRiw3SDPltsVlBsKNvn7u1Aw2gSQLwr9XShlzD0Bv4Q2TrV9MUgt3zbNq1at94gi
 88UVJXSKb32yYn8mtGmZND5CV1tbnY25QNfAi/bXlrRgKfEA4l5Hvf3SgAJQw7USYSYSXI3rK
 NI+UTPjScU6q3OmPcnRynr6n0qnqa6CHc02pIbBHu37PPFQyb0HqErs6joCNOJXwRr0PS5qwl
 Nw8lk/FxF3R8OG7msImlKMt/rV07S4lXo3LZi2tO6MJFWFp5C+ORdof6qJ/+zo/VFtKhiZhVP
 AwnwDYku2HASuQNyyG2+FX/g5Q96qP/UhJZ+eQRjUUYnI0sbucMNAEnH7Zvr4KAHvXIxly8V5
 /johf6CeL1h6H3HsTmiXUWycQcT5EMpHqycsfqH8wxq9nAZQWR9bxJPp/tkHbu5z0HAz2H9ac
 tWp6fMfIaIJkf0=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Vladimir,

On 20.09.21 at 23:42, Vladimir Oltean wrote:
> The Linux device model permits both the ->shutdown and ->remove driver
> methods to get called during a shutdown procedure. Example: a DSA switch
> which sits on an SPI bus, and the SPI bus driver calls this on its
> ->shutdown method:
>
> spi_unregister_controller
> -> device_for_each_child(&ctlr->dev, NULL, __unregister);
>    -> spi_unregister_device(to_spi_device(dev));
>       -> device_del(&spi->dev);
>
> So this is a simple pattern which can theoretically appear on any bus,
> although the only other buses on which I've been able to find it are
> I2C:
>
> i2c_del_adapter
> -> device_for_each_child(&adap->dev, NULL, __unregister_client);
>    -> i2c_unregister_device(client);
>       -> device_unregister(&client->dev);
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
> 	if (bus->state =3D=3D MDIOBUS_ALLOCATED) {
> 		kfree(bus);
> 		return;
> 	}
>
> 	BUG_ON(bus->state !=3D MDIOBUS_UNREGISTERED);
> 	bus->state =3D MDIOBUS_RELEASED;
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
>     located on a bus that unregisters its children on shutdown. After
>     the blamed patch, either both the alloc and the register should use
>     devres, or none should.
>
> (b) devm_mdiobus_alloc followed by plain mdiobus_register, and then no
>     mdiobus_unregister at all in the remove path. After the blamed
>     patch, nobody unregisters the MDIO bus anymore, so this is even more
>     buggy than the previous case which needs a specific bus
>     configuration to be seen, this one is an unconditional bug.
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
> Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_regis=
ter()")
> Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/dsa/dsa2.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index f14897d9b31d..274018e9171c 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -880,7 +880,7 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  	devlink_params_publish(ds->devlink);
>
>  	if (!ds->slave_mii_bus && ds->ops->phy_read) {
> -		ds->slave_mii_bus =3D devm_mdiobus_alloc(ds->dev);
> +		ds->slave_mii_bus =3D mdiobus_alloc();
>  		if (!ds->slave_mii_bus) {
>  			err =3D -ENOMEM;
>  			goto teardown;
> @@ -890,13 +890,16 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>
>  		err =3D mdiobus_register(ds->slave_mii_bus);
>  		if (err < 0)
> -			goto teardown;
> +			goto free_slave_mii_bus;
>  	}
>
>  	ds->setup =3D true;
>
>  	return 0;
>
> +free_slave_mii_bus:
> +	if (ds->slave_mii_bus && ds->ops->phy_read)
> +		mdiobus_free(ds->slave_mii_bus);
>  teardown:
>  	if (ds->ops->teardown)
>  		ds->ops->teardown(ds);
> @@ -921,8 +924,11 @@ static void dsa_switch_teardown(struct dsa_switch *=
ds)
>  	if (!ds->setup)
>  		return;
>
> -	if (ds->slave_mii_bus && ds->ops->phy_read)
> +	if (ds->slave_mii_bus && ds->ops->phy_read) {
>  		mdiobus_unregister(ds->slave_mii_bus);
> +		mdiobus_free(ds->slave_mii_bus);
> +		ds->slave_mii_bus =3D NULL;
> +	}
>
>  	dsa_switch_unregister_notifier(ds);
>
>

I applied this patch on top of your series "Make DSA switch drivers compat=
ible with
masters which unregister on shutdown" and now the shutdown works as expect=
ed (i.e.
no hang as without your patches and no kernel BUG as with only the above m=
entioned
series applied).

Great job, thanks a lot!

FWIW:
Tested-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

Best Regards,
Lino


