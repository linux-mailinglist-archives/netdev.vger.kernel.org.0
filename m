Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF95C209A4C
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 09:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390224AbgFYHJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 03:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390095AbgFYHJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 03:09:04 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A83C061573;
        Thu, 25 Jun 2020 00:09:04 -0700 (PDT)
Received: from [5.158.153.52] (helo=kurt)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1joM0J-0000oM-Gs; Thu, 25 Jun 2020 09:08:59 +0200
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 3/9] net: dsa: hellcreek: Add PTP clock support
In-Reply-To: <20200624130318.GD7247@localhost>
References: <20200618064029.32168-1-kurt@linutronix.de> <20200618064029.32168-4-kurt@linutronix.de> <20200624130318.GD7247@localhost>
Date:   Thu, 25 Jun 2020 09:08:48 +0200
Message-ID: <87366jaagv.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Richard,

On Wed Jun 24 2020, Richard Cochran wrote:
> On Thu, Jun 18, 2020 at 08:40:23AM +0200, Kurt Kanzenbach wrote:
>
>> diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
>> index a08a10cb5ab7..2d4422fd2567 100644
>> --- a/drivers/net/dsa/hirschmann/hellcreek.h
>> +++ b/drivers/net/dsa/hirschmann/hellcreek.h
>> @@ -234,10 +234,17 @@ struct hellcreek_fdb_entry {
>>  struct hellcreek {
>>  	struct device *dev;
>>  	struct dsa_switch *ds;
>> +	struct ptp_clock *ptp_clock;
>> +	struct ptp_clock_info ptp_clock_info;
>>  	struct hellcreek_port ports[4];
>> +	struct delayed_work overflow_work;
>>  	spinlock_t reg_lock;	/* Switch IP register lock */
>> +	spinlock_t ptp_lock;	/* PTP IP register lock */
>
> Why use a spin lock and not a mutex?

No particular reason. Mutex will also work.

>> +	hellcreek->ptp_clock = ptp_clock_register(&hellcreek->ptp_clock_info,
>> +						  hellcreek->dev);
>> +	if (IS_ERR(hellcreek->ptp_clock))
>> +		return PTR_ERR(hellcreek->ptp_clock);
>
> The ptp_clock_register() can also return NULL:
>
>  * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
>  * support is missing at the configuration level, this function
>  * returns NULL, and drivers are expected to gracefully handle that
>  * case separately.
>

I see, thanks. I guess we could add the missing NULL checks to remove()
and get_ts_info() to handle that case gracefully.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl70TYAACgkQeSpbgcuY
8KY8QhAAjm9p+MAzSXrkMYjS0UShvS1MZcx+iZtM3AP6cnb0FlYEwTqoe837Xvfj
Bff52RCasF/pnplb6q8z3vfHiz8QKqm7OF1hXG5u8ztwkwY47Y1GJdbcqc2Zv1Ix
Np3j8CWHxbPad87OAxiffYsKF4Z30nG/dkQtu6HduG5skvJiD5U0aNz/NR8SYX2S
tA6y3d8eM6NV6y0v1JqHbdgckQR9ZxvmlZ3EW2rGN/q7DetqQp5bd8Aftf0JEdzX
ox1o8BJ06L+/7o5E7k8HyCdkqTY/hEazXTiyl5mAJ69QcDbDTOcrqkrO5mgS8n7J
lkK7KERBQCJ3LmaGbfPk8YzJWMwUHYlaNAH4sPjnUCYubXcIS8X+IA2netgAFJp4
kb7kTM4w6yLf0rBf3VRFZAvX/Q+n7eeO8sCUqtC59ZF/gMphUETSmuElveVoF8VS
Xll3GrRCSVKzol9UvPhRUz4kQ9orzVxCw7mgfKGpm49Dpz0RBm+LJD7I7eX6eRjE
kdj3dt/qDNwekCR7svx2mMQpwcX9CEEElnWvMGoDPICnKzx0YQvwl0r4ifMzEUc7
ruoSHscce3p5jhJaC6mvgRYBQ46WqW1tb3zAZtLpGuEXv6rBhYz/wrnbNVcvOtHy
8OvzJJmVVPenzHLdMUroSnQEhidZcnBohASxYG/HjbbAgQx5XdU=
=4UQV
-----END PGP SIGNATURE-----
--=-=-=--
