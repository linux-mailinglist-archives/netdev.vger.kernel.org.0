Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2785923DD1C
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbgHFRB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729618AbgHFRAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 13:00:31 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC395C0A3BE2;
        Thu,  6 Aug 2020 06:53:05 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id c10so5494140edk.6;
        Thu, 06 Aug 2020 06:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eZ1hvjI2k7PxapIbdDWM4KmvIBLycDrwWJ/PVRnPpkE=;
        b=GZbdJjRb6J3NI0p+e+Jlu/Yb9KW6femyZPr8xmUW3Ev9AHe/8SbyjkhDwSgTn2Zj2G
         0HzjXU3Adq2o4ctN5RGobireeGGLVWs4gNto89bugMQ27oS8rhx9Zm9nA0nyjv4Hbl9L
         jwCCzHPRGEcuSX1v3MhQGnjFKhu1KKg9CbQvIZn3aEL5BTxJafhZBpx2CknP/YNmkNmS
         2rfAcnHgnia2eEQMe5seDpBMtftR/GKu81UpZ2RfBpvxeHO6JEQ5iWQSi7JPugaWZlBR
         hohFfqoO/V3O34b5D2P2dlE9WyE1ym1KF8QjS1+Hk6b0WlfSFud9wb3T+c3iPvKRnsW0
         WG5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eZ1hvjI2k7PxapIbdDWM4KmvIBLycDrwWJ/PVRnPpkE=;
        b=KjpZkTe5uUgPj3fHWDe5x+8RsiKNjI14d90UfpU2vGmnRq2X7LJV02sxr5GvtO8yRC
         2NA2CHQFlmg067wQbvX4Cztkr9on6stgiNl8VCh9ElqjzgfgVdPzOqpc05tme4KcqVXy
         E8tkzDUBiToqRXLHtXTHvrtOj40XJvuqDXHgnkIXCECoATFmm0zcvt8Yo83+X3aV5rfQ
         c1d1wUgE0vQxfBcKRqzi26BZLWeiYyQNyjOacs2F2OTII1cHLUaBrDXajL359yXW42K7
         B5Ewxa5u+LY1KvYfxa9Smrn8z/CaWwvvLtRc+I3bXQPPja1F+AVuVg4xWDljLuy76vFg
         CVpA==
X-Gm-Message-State: AOAM530zYfE6ITnFiAChFsXD1MWeg0d56FUecUteuDt3TL5teULC0UqU
        yIjQJkH+XUyNwEyvkj2d84CjNiUM
X-Google-Smtp-Source: ABdhPJwrtn8TBnvxrR4dTun1NmGyvo2avAxmYKxn0etadYxcZgnXT6X6AB0m+uy9guGlcRr66J7LGg==
X-Received: by 2002:a05:6402:1427:: with SMTP id c7mr4290420edx.245.1596721974488;
        Thu, 06 Aug 2020 06:52:54 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id c18sm3834642eja.13.2020.08.06.06.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 06:52:52 -0700 (PDT)
Date:   Thu, 6 Aug 2020 15:52:51 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     John Stultz <john.stultz@linaro.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Ferry Toth <fntoth@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>,
        netdev <netdev@vger.kernel.org>, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>
Subject: Re: [PATCH v3 1/3] driver core: Revert default
 driver_deferred_probe_timeout value to 0
Message-ID: <20200806135251.GB3351349@ulmo>
References: <20200422203245.83244-1-john.stultz@linaro.org>
 <20200422203245.83244-2-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
Content-Disposition: inline
In-Reply-To: <20200422203245.83244-2-john.stultz@linaro.org>
User-Agent: Mutt/1.14.4 (2020-06-18)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 22, 2020 at 08:32:43PM +0000, John Stultz wrote:
> This patch addresses a regression in 5.7-rc1+
>=20
> In commit c8c43cee29f6 ("driver core: Fix
> driver_deferred_probe_check_state() logic"), we both cleaned up
> the logic and also set the default driver_deferred_probe_timeout
> value to 30 seconds to allow for drivers that are missing
> dependencies to have some time so that the dependency may be
> loaded from userland after initcalls_done is set.
>=20
> However, Yoshihiro Shimoda reported that on his device that
> expects to have unmet dependencies (due to "optional links" in
> its devicetree), was failing to mount the NFS root.
>=20
> In digging further, it seemed the problem was that while the
> device properly probes after waiting 30 seconds for any missing
> modules to load, the ip_auto_config() had already failed,
> resulting in NFS to fail. This was due to ip_auto_config()
> calling wait_for_device_probe() which doesn't wait for the
> driver_deferred_probe_timeout to fire.
>=20
> Fixing that issue is possible, but could also introduce 30
> second delays in bootups for users who don't have any
> missing dependencies, which is not ideal.
>=20
> So I think the best solution to avoid any regressions is to
> revert back to a default timeout value of zero, and allow
> systems that need to utilize the timeout in order for userland
> to load any modules that supply misisng dependencies in the dts
> to specify the timeout length via the exiting documented boot
> argument.
>=20
> Thanks to Geert for chasing down that ip_auto_config was why NFS
> was failing in this case!
>=20
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
> Cc: Basil Eljuse <Basil.Eljuse@arm.com>
> Cc: Ferry Toth <fntoth@gmail.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Anders Roxell <anders.roxell@linaro.org>
> Cc: netdev <netdev@vger.kernel.org>
> Cc: linux-pm@vger.kernel.org
> Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Fixes: c8c43cee29f6 ("driver core: Fix driver_deferred_probe_check_state(=
) logic")
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/base/dd.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)

Sorry for being a bit late to the party, but this breaks suspend/resume
support on various Tegra devices. I've only noticed now because, well,
suspend/resume have been broken for other reasons for a little while and
it's taken us a bit to resolve those issues.

But now that those other issues have been fixed, I've started seeing an
issue where after resume from suspend some of the I2C controllers are no
longer working. The reason for this is that they share pins with DP AUX
controllers via the pinctrl framework. The DP AUX driver registers as
part of the DRM/KMS driver, which usually happens in userspace. Since
the deferred probe timeout was set to 0 by default this no longer works
because no pinctrl states are assigned to the I2C controller and
therefore upon resume the pins cannot be configured for I2C operation.

I'm also somewhat confused by this patch and a few before because they
claim that they restore previous default behaviour, but that's just not
true. Originally when this timeout was introduced it was -1, which meant
that there was no timeout at all and hence users had to opt-in if they
wanted to use a deferred probe timeout.

But now after this series the default is for there to be a very short
timeout, which in turn causes existing use-cases to potentially break.
I'm also going to suggest here that in most cases a driver will require
the resources that it asks for, so the case that Yoshihiro described and
that this patch is meant to fix sounds to me like it's the odd one out
rather than the other way around.

But I realize that that's not very constructive. So perhaps we can find
some other way for drivers to advertise that their dependencies are
optional? I came up with the below patch, which restores suspend/resume
on Tegra and could be used in conjunction with a patch that opts into
this behaviour for the problematic driver in Yoshihiro's case to make
this again work for everyone.

--- >8 ---
=46rom a95f8f41b8a32dee3434db4f0515af7376d1873a Mon Sep 17 00:00:00 2001
=46rom: Thierry Reding <treding@nvidia.com>
Date: Thu, 6 Aug 2020 14:51:59 +0200
Subject: [PATCH] driver core: Do not ignore dependencies by default

Many drivers do require the resources that they ask for and timing out
may not always be an option. While there is a way to allow probing to
continue to be deferred for some time after the system has booted, the
fact that this is controlled via a command-line parameter is undesired
because it require manual intervention, whereas in can be avoid in the
majority of cases.

Instead of requiring users to edit the kernel command-line, add a way
for drivers to specify whether or not their dependencies are optional
so that they can continue deferring probe indefinitely.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/base/dd.c             | 2 +-
 include/linux/device/driver.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 857b0a928e8d..11e747070eae 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -279,7 +279,7 @@ int driver_deferred_probe_check_state(struct device *de=
v)
 		return -ENODEV;
 	}
=20
-	if (!driver_deferred_probe_timeout && initcalls_done) {
+	if (dev->driver->ignore_dependencies && !driver_deferred_probe_timeout &&=
 initcalls_done) {
 		dev_warn(dev, "deferred probe timeout, ignoring dependency\n");
 		return -ETIMEDOUT;
 	}
diff --git a/include/linux/device/driver.h b/include/linux/device/driver.h
index ee7ba5b5417e..6994455e8a2e 100644
--- a/include/linux/device/driver.h
+++ b/include/linux/device/driver.h
@@ -100,6 +100,7 @@ struct device_driver {
 	const char		*mod_name;	/* used for built-in modules */
=20
 	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
+	bool ignore_dependencies;	/* ignores dependencies */
 	enum probe_type probe_type;
=20
 	const struct of_device_id	*of_match_table;
--=20
2.27.0
--- >8 ---

Although, thinking about it a bit more it sounds to me like an even
better approach would be to make this part of the API where a resource
is requested. There are in fact already APIs that can request optional
resources (such as regulator_get_optional()), so I think it would make
more sense for any driver that can live without a resource to request
it with an optional flag, which in turn could then trigger this code
path for the deferred probe timeout. For anyone that really needs the
resources that they request, they really shouldn't have to jump through
hoops to get there.

Thierry

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl8sCy8ACgkQ3SOs138+
s6GvwhAAnB1zEygGH/A1YRgS2NGGwPGWTkHasFfcxAv3MpbRYWsI+DzDblqiUNh+
T50wVC81N486hkhmJPusc9DQSCVZff1EuR75R0uhR+RVTHsVL5LaL/wo3ful5v3J
Pmi66IUoPj8HjBt+hxrcLMPKLOwG/j38OXU4GJaTLbG45Sdr1fkkZOte7NmfuP9p
IMXE3Dc0hzwfcw8vdAOdNMxAnR+DE0Rw6K6N8RMkYxbCHAStLGzDV1NpOHM7hjqQ
ymxXyTajPv17sx9Tg4NeIH4ANh73IHhSCPEKOGUykktgsGFhYrxwYSlK+9dnSRb2
trDPIa+4gwrI1R8iMogmqWApSkkaeRWNaJPxBOyg+mHq3H3KCcQLxcb1KGwTioIL
cbdlVtsIYJtDiT0TqFWREBRYVcvWA2hT/VNq9G0aIYyzW1r5GwAjKKpruky1rg3f
jzU/jiJJn5fgOLK4s87sqw9dStTyGZlXBhX5/yDJaDxNNU2jPwn6CIB6PZWsWdan
paSxpleHQhgcD9kS7Qru3mDxvsQzPx4DHv8wQkUOX/AeRYXiB38RNg4c9M1YwOFp
jxUJqwXTyQdtOjblN5HZyEDCkIUUV0qVg486WKkktuep7nMQHOCDiWY/WYXmpL/u
Uf0sYgl2bQPssMBhHpD6rr7G6Tr6Vzt/JjP8QdrAV1qlo9+IuR0=
=MKXR
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--
