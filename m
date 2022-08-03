Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC615886CA
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 07:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234691AbiHCFfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 01:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbiHCFfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 01:35:31 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB72DE88;
        Tue,  2 Aug 2022 22:35:30 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1659504927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=of5s/GrpfKIG2nNHo7KYLFYpM2HrnVQoxme/WggIQw0=;
        b=WmX4OWsBX6KI4lZDXjaPSyhTd+5grQt5pKb4w7pzJ8HDI6W7+xqaCuErEaFK4JcCqmAczy
        rX9oeBkBjn+CD4XTSEKr7iFP7m0NzWGhbN4BYqSu7ehf8hYCVx7C4E+CtyJKBkqSrBb+am
        T76kNR6ksDE48s3neOWf3Qm8mayFiTwCRYwvzodVBa8+KbDulguzBMGAFwVda2nmwig4mX
        hFTgLgkJ5ifN74oBiu48DC4jgO1sCGgDlWaZbV29F9diVj6S/eS/IQos83m6u91MKf0l4z
        LhHaWKNvnXuu1QnASeMqTRv1Nx+5wnnOUVCCDIvKVv7r2Qsu3O1X0hkh150pfg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1659504927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=of5s/GrpfKIG2nNHo7KYLFYpM2HrnVQoxme/WggIQw0=;
        b=dbfcyQAPM/b866N1w0S77xu+TTBarNfUR/b7yKoBnhv2mmQm0C5r9rdfv3jgxMbIRW4T/m
        x8Lsz8JrNh6GewCQ==
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v1 1/1] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
In-Reply-To: <20220802212144.6743-1-andriy.shevchenko@linux.intel.com>
References: <20220802212144.6743-1-andriy.shevchenko@linux.intel.com>
Date:   Wed, 03 Aug 2022 07:35:25 +0200
Message-ID: <87h72tga8y.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed Aug 03 2022, Andy Shevchenko wrote:
> LED core provides a helper to parse default state from firmware node.
> Use it instead of custom implementation.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/net/dsa/hirschmann/hellcreek_ptp.c | 45 ++++++++++++----------
>  1 file changed, 24 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/dsa=
/hirschmann/hellcreek_ptp.c
> index b28baab6d56a..793b2c296314 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek_ptp.c
> +++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
> @@ -297,7 +297,8 @@ static enum led_brightness hellcreek_led_is_gm_get(st=
ruct led_classdev *ldev)
>  static int hellcreek_led_setup(struct hellcreek *hellcreek)
>  {
>  	struct device_node *leds, *led =3D NULL;
> -	const char *label, *state;
> +	enum led_default_state state;
> +	const char *label;
>  	int ret =3D -EINVAL;
>=20=20
>  	of_node_get(hellcreek->dev->of_node);
> @@ -318,16 +319,17 @@ static int hellcreek_led_setup(struct hellcreek *he=
llcreek)
>  	ret =3D of_property_read_string(led, "label", &label);
>  	hellcreek->led_sync_good.name =3D ret ? "sync_good" : label;
>=20=20
> -	ret =3D of_property_read_string(led, "default-state", &state);
> -	if (!ret) {
> -		if (!strcmp(state, "on"))
> -			hellcreek->led_sync_good.brightness =3D 1;
> -		else if (!strcmp(state, "off"))
> -			hellcreek->led_sync_good.brightness =3D 0;
> -		else if (!strcmp(state, "keep"))
> -			hellcreek->led_sync_good.brightness =3D
> -				hellcreek_get_brightness(hellcreek,
> -							 STATUS_OUT_SYNC_GOOD);
> +	state =3D led_init_default_state_get(of_fwnode_handle(led));

Applied your patch to net-next/master and this yields:

|drivers/net/dsa/hirschmann/hellcreek_ptp.c: In function =E2=80=98hellcreek=
_led_setup=E2=80=99:
|drivers/net/dsa/hirschmann/hellcreek_ptp.c:430:10: error: implicit declara=
tion of function =E2=80=98led_init_default_state_get=E2=80=99; did you mean=
 =E2=80=98led_get_default_pattern=E2=80=99? [-Werror=3Dimplicit-function-de=
claration]
|  430 |  state =3D led_init_default_state_get(of_fwnode_handle(led));
|      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~
|      |          led_get_default_pattern

The header is missing:

|diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/dsa/=
hirschmann/hellcreek_ptp.c
|index df339f3e1803..430f39172d58 100644
|--- a/drivers/net/dsa/hirschmann/hellcreek_ptp.c
|+++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
|@@ -14,6 +14,8 @@
| #include "hellcreek_ptp.h"
| #include "hellcreek_hwtstamp.h"
|=20
|+#include "../../../leds/leds.h"
|+
| u16 hellcreek_ptp_read(struct hellcreek *hellcreek, unsigned int offset)
| {
|        return readw(hellcreek->ptp_base + offset);

Maybe move led_init_default_state_get() to linux/leds.h?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmLqCR0THGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgs5jEACDZPp4PgbekX+qETswvPxgCivFAU0B
eSCF2KF+I8hMSi1ObuzwbXWyZ4uoZi0m7Wf3uGh5t/5J1nOEAovHnl6Xwy7SCPzH
plE9azrmQhXj91UpjkU26pm/uWIluWu5Kh0pXxgCgrQSO8IOc/rWNe30SP5zxI0w
Lvp5mp7btYvoybOiASMGfxToKIYjX2H8fOzBBpaF9YQgmokbaO4RvoW6Rt9PPGAI
D0Hk2RehV96Lz9ABJL5yXDcqd9ALluTiDCnd3x9+OSYzX0cDwd6urOeKgDhDm0B3
guWy0LV5t7ItOc0rls27Dn465AgVNvz7FxPatFKYo9ZU69UjJrTrNGLz84J5pfx5
LLV0W772wa+wsi/yrE0mm2n5T1W1XZ4UOCoZ2QsLgGtqqEEuzpZ2MQMrhJMp3aHg
6fG4es2W1vXgvGpdr4IKKH3Y3DewSQYLNRTVuobtvI1bmSAwUlKgsSqOeEYlR2zs
q5VJ0LgonIrCci+rVKh86L5kUUDvvY7WlgC7EGsPokQSjBJGcQeKy1ZUkZRooKlx
V4ODkzLb4L4255T0cYNQF941XdZR1AXV7i9kcLKXOo0qy17jxSLXJo0krBXEyXoJ
YaiiUPtD6lwqDT9ICOwwxYLGmrwbOPLuLqyq+5F9xWYVM+IIc4HyM9NMsm1+8k7b
PAdypMcuQV+0hw==
=UtYG
-----END PGP SIGNATURE-----
--=-=-=--
