Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6070C230B7C
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 15:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbgG1N36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 09:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729044AbgG1N36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 09:29:58 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34457C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 06:29:58 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595942995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+wOUERqGNHkXdTw5B95UgJ1wSKNRBrZ7nRvV2DO9x2c=;
        b=TmlFws/imKX5D+fp+CSucvykfbk0VZR+UbqUiCoQiZckdWHkN0IvFDNmnRUABbUAIFxw1S
        kzRJZ3fJqrMb3TlG8kDc/MgkVTPY5HUtKMb1cbkncEciPHkUeBQpE4OSwaaQ/BANsiKXu+
        E6vhGDMuJ1cWPFMxeUg5scUjWLgBpeq+i03a465uwtOExFQ4z36Sd0MbdxDCKB9uGLzfv+
        CM6lMU6foh3wxqCNbSgpZDAh0vlKdJgHgjRfSriAlWBf6BjTQKkQ8sy+/XEiDc/c/WKtYG
        yN+0D6VbUJpwyNQW4fUFZI29rd4tpxxQva6mPnNHqA0JbAt1CS1NhjuKNqxSHA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595942995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+wOUERqGNHkXdTw5B95UgJ1wSKNRBrZ7nRvV2DO9x2c=;
        b=kkjEK4V2eklV55foOtwiXlvN6bRgCCVMNe+Vy5ZN4kVayL6UVcKcz3o+zagW/0cKTzhK+R
        jday0SN0LykDBaDA==
To:     Petr Machata <petrm@mellanox.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 4/9] mlxsw: spectrum_ptp: Use generic helper function
In-Reply-To: <87a6zli04l.fsf@mellanox.com>
References: <20200727090601.6500-1-kurt@linutronix.de> <20200727090601.6500-5-kurt@linutronix.de> <87a6zli04l.fsf@mellanox.com>
Date:   Tue, 28 Jul 2020 15:29:44 +0200
Message-ID: <875za7sr7b.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon Jul 27 2020, Petr Machata wrote:
> So this looks good, and works, but I'm wondering about one thing.

Thanks for testing.

>
> Your code (and evidently most drivers as well) use a different check
> than mlxsw, namely skb->len + ETH_HLEN < X. When I print_hex_dump()
> skb_mac_header(skb), skb->len in mlxsw with some test packet, I get e.g.
> this:
>
>     00000000259a4db7: 01 00 5e 00 01 81 00 02 c9 a4 e4 e1 08 00 45 00  ..=
^...........E.
>     000000005f29f0eb: 00 48 0d c9 40 00 01 11 c8 59 c0 00 02 01 e0 00  .H=
..@....Y......
>     00000000f3663e9e: 01 81 01 3f 01 3f 00 34 9f d3 00 02 00 2c 00 00  ..=
.?.?.4.....,..
>                             ^sp^^ ^dp^^ ^len^ ^cks^       ^len^
>     00000000b3914606: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02  ..=
..............
>     000000002e7828ea: c9 ff fe a4 e4 e1 00 01 09 fa 00 00 00 00 00 00  ..=
..............
>     000000000b98156e: 00 00 00 00 00 00                                ..=
....
>
> Both UDP and PTP length fields indicate that the payload ends exactly at
> the end of the dump. So apparently skb->len contains all the payload
> bytes, including the Ethernet header.
>
> Is that the case for other drivers as well? Maybe mlxsw is just missing
> some SKB magic in the driver.

So I run some tests (on other hardware/drivers) and it seems like that
the skb->len usually doesn't include the ETH_HLEN. Therefore, it is
added to the check.

Looking at the driver code:

|static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u8 local_port,
|					void *trap_ctx)
|{
|	[...]
|	/* The sample handler expects skb->data to point to the start of the
|	 * Ethernet header.
|	 */
|	skb_push(skb, ETH_HLEN);
|	mlxsw_sp_sample_receive(mlxsw_sp, skb, local_port);
|}

Maybe that's the issue here?

I was also wondering about something else in that driver driver: The
parsing code allows for ptp v1, but the message type was always fetched
from offset 0 in the header. Is that indented?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8gKEgACgkQeSpbgcuY
8KZd7BAAlJlDzt6cIr6wbgSIT/kavnRQvmojnqsYzu+fK5Hf9SfS8OGuD6LoqoIO
x+aErzD9dEDBEIIsl9wEiND0lY8Lj3Pmu3hn5cqcYIVttmXRWK55ongqUfc+oI2p
UniZpEnhCw5p0hNATre5rpRbGBlKhkMvR78KVxJOAh+QO68C+hi5WpvegCNi2kAS
41QpuuuELka8iAhcUwSL3yYpjd9PxOomp2eCxarkQ5mcwkt9zEfsNTsF14yUffE0
BJ7pULPGyKy44ddzJckcRAub4BKS+4522B/5oUg7SOrUQBSpg8IJERJv2o2ismFZ
CZYl8fwHMTBzl8cj8GEGOjLv/x4mXEXAvqJxcO+YfsQNe+81OnFsm+5WSCvFAVj1
6Shk65hVfabXnqVKOvIJlFkAaG1kj5mbHMCWr4WAdv+ZixaAxxm+BCc+OWEzKvKN
tu2UBv+mK4CzvNhM9CRjr5vCsxU0CEjuiWwd4Va1jomxqDfYw/EEYR0wM0tA5LD7
deYcV1z7jk4CqrIyXLsMfxBXuJqw76+4aiKS+9TcWNMc3UEGDW7bP+SC2jyKj2eC
4r/WQwqHA+m2ZzINN4FTqMLQdpmkwjxwlnp36VS41IvDsyIx840uxoKEHEkxR3rH
XSe4vJnZSX+4IZaJPdcr0I+cepYm0PyFEbDz7WSec4kZEMi8FwE=
=smkT
-----END PGP SIGNATURE-----
--=-=-=--
