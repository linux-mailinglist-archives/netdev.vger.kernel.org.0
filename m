Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FD123EBE7
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 13:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgHGLEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 07:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgHGLCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 07:02:49 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494BFC061574;
        Fri,  7 Aug 2020 04:02:49 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id jp10so1656107ejb.0;
        Fri, 07 Aug 2020 04:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CW9K8m3sbTZhCuvb3AtI1K8etYarA3d1t4JKk79x1xY=;
        b=bdWVWeVy9cKMg0boqhrXO/+2rjGnLp2b8mnuASqSs6P9z0mupN+w99Mv9QtGWe94PF
         H3+6RB1TWhiYrGYxY/+9O/3qAkPKU2EbLI3DvkG90ONRAl3rmUMX6kocjkkD8+DpBfn/
         r/zV3ZxluurgwCw4j/RbJ295GTY4HpXtpAd4MIvpTFCLMt4/DyXgDH8SHrZYGiDwkxgq
         eHT9gfvVy5KyqavuLyt9rqZ4YEd3RuL+GxVHKFUw7pendJ4yRHPOsj4ZM9UCGqRWbdvr
         gV7R3M6hEGdVY4Y6Pz1qA/KfpODNJ5EGGbNaf7gJ6rxT/atsifljTqKRW0pjWO8rU246
         PZ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CW9K8m3sbTZhCuvb3AtI1K8etYarA3d1t4JKk79x1xY=;
        b=sVlzF85qlFh2xZIaPDTir+4N/0JEL0dyOpEVc/2nnd19iIedbNUNaB5ECBVpGGJUvy
         3cV/d5zs4zb40dxz/V6PSYEJpMWykJHPCj7UIODNKZ/J/4Q0LsOhMZI5QyFS7exgTB6h
         g1uCZYGtb4APkx6+V1j2Xa2JgZIU8A853H7VWW0UwKDn3IsTF57pm9vtzD2ivvHUFD+P
         D6Cj61fDl0n2NaC27alaWRaKfRdO2zd3LfuXvTa1TzW0DFOX6TMkVZTbSF2QjRbMPhIB
         u5F5HY7seFHtRYphFGtHTdGJ8My1pbRgjm4exl8CXWEYnE4LflNHBvZzFT+7StLQRFax
         2BJQ==
X-Gm-Message-State: AOAM532Q6F5c/3DJ21yRr6argehLGMVUggS7IW3Q2gs+pxjza5H8H+j1
        lJVS3vYFfoDInF1yh/vmgGg=
X-Google-Smtp-Source: ABdhPJznSwAlUWQGGYmd+A4XczlUyTa320ncn2QlV8qxgDGORQlxykdoH/Hjaaol87b4QJKX6AZjVQ==
X-Received: by 2002:a17:906:b815:: with SMTP id dv21mr8566827ejb.517.1596798167601;
        Fri, 07 Aug 2020 04:02:47 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id m13sm5276307eds.10.2020.08.07.04.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 04:02:46 -0700 (PDT)
Date:   Fri, 7 Aug 2020 13:02:44 +0200
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
        netdev <netdev@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-tegra@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>
Subject: Re: [PATCH v3 1/3] driver core: Revert default
 driver_deferred_probe_timeout value to 0
Message-ID: <20200807110244.GB94549@ulmo>
References: <20200422203245.83244-1-john.stultz@linaro.org>
 <20200422203245.83244-2-john.stultz@linaro.org>
 <20200806135251.GB3351349@ulmo>
 <CALAqxLU=a+KXKya2FkgCuYyw5ttZJ_NXjNbszFzSjP49wMN84g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
In-Reply-To: <CALAqxLU=a+KXKya2FkgCuYyw5ttZJ_NXjNbszFzSjP49wMN84g@mail.gmail.com>
User-Agent: Mutt/1.14.4 (2020-06-18)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 06, 2020 at 07:09:16PM -0700, John Stultz wrote:
> On Thu, Aug 6, 2020 at 6:52 AM Thierry Reding <thierry.reding@gmail.com> =
wrote:
> >
> > On Wed, Apr 22, 2020 at 08:32:43PM +0000, John Stultz wrote:
> > > This patch addresses a regression in 5.7-rc1+
> > >
> > > In commit c8c43cee29f6 ("driver core: Fix
> > > driver_deferred_probe_check_state() logic"), we both cleaned up
> > > the logic and also set the default driver_deferred_probe_timeout
> > > value to 30 seconds to allow for drivers that are missing
> > > dependencies to have some time so that the dependency may be
> > > loaded from userland after initcalls_done is set.
> > >
> > > However, Yoshihiro Shimoda reported that on his device that
> > > expects to have unmet dependencies (due to "optional links" in
> > > its devicetree), was failing to mount the NFS root.
> > >
> > > In digging further, it seemed the problem was that while the
> > > device properly probes after waiting 30 seconds for any missing
> > > modules to load, the ip_auto_config() had already failed,
> > > resulting in NFS to fail. This was due to ip_auto_config()
> > > calling wait_for_device_probe() which doesn't wait for the
> > > driver_deferred_probe_timeout to fire.
> > >
> > > Fixing that issue is possible, but could also introduce 30
> > > second delays in bootups for users who don't have any
> > > missing dependencies, which is not ideal.
> > >
> > > So I think the best solution to avoid any regressions is to
> > > revert back to a default timeout value of zero, and allow
> > > systems that need to utilize the timeout in order for userland
> > > to load any modules that supply misisng dependencies in the dts
> > > to specify the timeout length via the exiting documented boot
> > > argument.
> > >
> > > Thanks to Geert for chasing down that ip_auto_config was why NFS
> > > was failing in this case!
> > >
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> > > Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> > > Cc: Rob Herring <robh@kernel.org>
> > > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > > Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > > Cc: Robin Murphy <robin.murphy@arm.com>
> > > Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> > > Cc: Sudeep Holla <sudeep.holla@arm.com>
> > > Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
> > > Cc: Basil Eljuse <Basil.Eljuse@arm.com>
> > > Cc: Ferry Toth <fntoth@gmail.com>
> > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > Cc: Anders Roxell <anders.roxell@linaro.org>
> > > Cc: netdev <netdev@vger.kernel.org>
> > > Cc: linux-pm@vger.kernel.org
> > > Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > > Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > > Fixes: c8c43cee29f6 ("driver core: Fix driver_deferred_probe_check_st=
ate() logic")
> > > Signed-off-by: John Stultz <john.stultz@linaro.org>
> > > ---
> > >  drivers/base/dd.c | 13 ++-----------
> > >  1 file changed, 2 insertions(+), 11 deletions(-)
> >
> > Sorry for being a bit late to the party, but this breaks suspend/resume
> > support on various Tegra devices. I've only noticed now because, well,
> > suspend/resume have been broken for other reasons for a little while and
> > it's taken us a bit to resolve those issues.
> >
> > But now that those other issues have been fixed, I've started seeing an
> > issue where after resume from suspend some of the I2C controllers are no
> > longer working. The reason for this is that they share pins with DP AUX
> > controllers via the pinctrl framework. The DP AUX driver registers as
> > part of the DRM/KMS driver, which usually happens in userspace. Since
> > the deferred probe timeout was set to 0 by default this no longer works
> > because no pinctrl states are assigned to the I2C controller and
> > therefore upon resume the pins cannot be configured for I2C operation.
>=20
> Oof. My apologies!
>=20
> > I'm also somewhat confused by this patch and a few before because they
> > claim that they restore previous default behaviour, but that's just not
> > true. Originally when this timeout was introduced it was -1, which meant
> > that there was no timeout at all and hence users had to opt-in if they
> > wanted to use a deferred probe timeout.
>=20
> I don't think that's quite true, since the point of my original
> changes were to avoid troubles I was seeing with drivers not loading
> because once the timeout fired after init, driver loading would fail
> with ENODEV instead of returning EPROBE_DEFER. The logic that existed
> was buggy so the timeout handling didn't really work (changing the
> boot argument wouldn't help, because after init the logic would return
> ENODEV before it checked the timeout value).
>=20
> That said, looking at it now, I do realize the
> driver_deferred_probe_check_state_continue() logic in effect never
> returned ETIMEDOUT before was consolidated in the earlier changes, and
> now we've backed the default timeout to 0, old user (see bec6c0ecb243)
> will now get ETIMEDOUT where they wouldn't before.
>=20
> So would the following fix it up for you? (sorry its whitespace corrupted)
>=20
> diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
> index c6fe7d64c913..c7448be64d07 100644
> --- a/drivers/pinctrl/devicetree.c
> +++ b/drivers/pinctrl/devicetree.c
> @@ -129,9 +129,8 @@ static int dt_to_map_one_config(struct pinctrl *p,
>                 if (!np_pctldev || of_node_is_root(np_pctldev)) {
>                         of_node_put(np_pctldev);
>                         ret =3D driver_deferred_probe_check_state(p->dev);
> -                       /* keep deferring if modules are enabled
> unless we've timed out */
> -                       if (IS_ENABLED(CONFIG_MODULES) && !allow_default =
&&
> -                           (ret =3D=3D -ENODEV))
> +                       /* keep deferring if modules are enabled */
> +                       if (IS_ENABLED(CONFIG_MODULES) &&
> !allow_default && ret < 0)
>                                 ret =3D -EPROBE_DEFER;
>                         return ret;
>                 }
>=20
> (you could probably argue calling driver_deferred_probe_check_state
> checking ret at all is silly here, since EPROBE_DEFER is the only
> option you want)

Just by looking at it I would've said, yes, this looks like it would fix
it. However, upon giving this a try, I see the same pinmux issues as I
was seeing before. I'm going to have to dig a little deeper to see if I
can find out why that is, because it isn't obvious to me right away.

>=20
> > But now after this series the default is for there to be a very short
> > timeout, which in turn causes existing use-cases to potentially break.
> > I'm also going to suggest here that in most cases a driver will require
> > the resources that it asks for, so the case that Yoshihiro described and
> > that this patch is meant to fix sounds to me like it's the odd one out
> > rather than the other way around.
> >
> > But I realize that that's not very constructive. So perhaps we can find
> > some other way for drivers to advertise that their dependencies are
> > optional? I came up with the below patch, which restores suspend/resume
> > on Tegra and could be used in conjunction with a patch that opts into
> > this behaviour for the problematic driver in Yoshihiro's case to make
> > this again work for everyone.
> >
> > --- >8 ---
> > From a95f8f41b8a32dee3434db4f0515af7376d1873a Mon Sep 17 00:00:00 2001
> > From: Thierry Reding <treding@nvidia.com>
> > Date: Thu, 6 Aug 2020 14:51:59 +0200
> > Subject: [PATCH] driver core: Do not ignore dependencies by default
> >
> > Many drivers do require the resources that they ask for and timing out
> > may not always be an option. While there is a way to allow probing to
> > continue to be deferred for some time after the system has booted, the
> > fact that this is controlled via a command-line parameter is undesired
> > because it require manual intervention, whereas in can be avoid in the
> > majority of cases.
> >
> > Instead of requiring users to edit the kernel command-line, add a way
> > for drivers to specify whether or not their dependencies are optional
> > so that they can continue deferring probe indefinitely.
> >
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> >  drivers/base/dd.c             | 2 +-
> >  include/linux/device/driver.h | 1 +
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> > index 857b0a928e8d..11e747070eae 100644
> > --- a/drivers/base/dd.c
> > +++ b/drivers/base/dd.c
> > @@ -279,7 +279,7 @@ int driver_deferred_probe_check_state(struct device=
 *dev)
> >                 return -ENODEV;
> >         }
> >
> > -       if (!driver_deferred_probe_timeout && initcalls_done) {
> > +       if (dev->driver->ignore_dependencies && !driver_deferred_probe_=
timeout && initcalls_done) {
> >                 dev_warn(dev, "deferred probe timeout, ignoring depende=
ncy\n");
> >                 return -ETIMEDOUT;
> >         }
> > diff --git a/include/linux/device/driver.h b/include/linux/device/drive=
r.h
> > index ee7ba5b5417e..6994455e8a2e 100644
> > --- a/include/linux/device/driver.h
> > +++ b/include/linux/device/driver.h
> > @@ -100,6 +100,7 @@ struct device_driver {
> >         const char              *mod_name;      /* used for built-in mo=
dules */
> >
> >         bool suppress_bind_attrs;       /* disables bind/unbind via sys=
fs */
> > +       bool ignore_dependencies;       /* ignores dependencies */
> >         enum probe_type probe_type;
> >
> >         const struct of_device_id       *of_match_table;
> > --
> > 2.27.0
> > --- >8 ---
> >
> > Although, thinking about it a bit more it sounds to me like an even
> > better approach would be to make this part of the API where a resource
> > is requested. There are in fact already APIs that can request optional
> > resources (such as regulator_get_optional()), so I think it would make
> > more sense for any driver that can live without a resource to request
> > it with an optional flag, which in turn could then trigger this code
> > path for the deferred probe timeout. For anyone that really needs the
> > resources that they request, they really shouldn't have to jump through
> > hoops to get there.
>=20
> I do like these suggestions. I feel like the optional dt links
> handling is very opaque as there's no real way to tell if a dt link is
> truly optional or not. Having the timeout is a really subtle and
> implicit way of getting that optional link handling behavior.

Agreed. Handling this implicitly is pretty wonky and as evidenced by
these two cases bound to break one way or another.

Thierry

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl8tNNAACgkQ3SOs138+
s6GswQ//VAyLD+461fwoPobDZHUA7BdbkHkBSg+PLlZ4b5HpdTF9/B2MD/6PPeBK
V+zN++MO18ctQrAkpBWLmhKBwi71GDDNyGULruzOKy67AVVnKFbO0pzPiJDGljKD
z8cDNV0cUJAvQu/84NdkxDv5JRVzrC6fZEg00OQxu3810cLRPLshgS2S9QuIac6Q
E3s6BP+OcxTHGwX3xLu4DirsVn6BclZiz+uBPDHPNRFCI0vBYZJvfp1v7T0qy3wS
9/iX7vOZ7C0+zuJKMPA7b09hZkDdEjVxBpc5/ePEYFKEh5ZY6m3IHz5OQTDXPiMT
3VtW5xwf0vij/D4cHwjwxumKimqLDWbr0VqcC3dIgER2qUsd7gm9sWhtOl00KN5Y
bpE/TNFIXP2/vGx7Kvu8/ZcCgtetvtnU6nZl9Y3Uc90Iee/NuiaRP+ZY7ZXbCCrn
S+vAZxfjPIW9UUpCfXBAkB9iQymzb0TtV3sg+Rh2bboxFsAFwn50nCKdSMd71yAX
diXp3Iy+q2JNJpQdjlA3TQ6E2iPoAkcFYkDPbrwENXp6cIgZ1iUxliiNf8cbUXPi
/6HPav137uNtOu2kA2ECuK1SRHAZ+Yfyr0UMMVw1UR7YKmqfhZ2sUSfXIn0/z73k
w7Oc4182MHJGr9wF+esKCm73h2YRmJlFoCEduzYtWScQqcre3hI=
=PgyH
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
