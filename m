Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206DE23ED49
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 14:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgHGM0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 08:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728270AbgHGM0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 08:26:18 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428B7C061574;
        Fri,  7 Aug 2020 05:26:18 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id l23so1115082edv.11;
        Fri, 07 Aug 2020 05:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5dUj8K6+0mWlPErYm2rq9Z+oT0LCcA9o+12DiBmzbSQ=;
        b=WDFgU83hLdOo0WtdeU8MKHJJWboDIYk1VGX73Jkv5w7FRjpjvJ4AR2G4+YjAHgwtCv
         ssB7vfH+DdmTWFUwof5wCLiIlE06tTU+J2+wuLm4zKa0NoZDQcDAiFgEToM6Dkp/jp9X
         6H0L9VwJPMoj2Pq8CmHgx2c2wtUE5AuQlRTR7ebMdnP38KT/2U4Lzic+87BaOincr5fH
         n+THyrUJwM23w4K2JIdmW1cg4NqYYERVD55E3VOikoVmFxt9iiuXdiBvdnNk7rL6koyw
         Baamnnr/IEi6qrKKqxXpUcBUF2ng1P+9tmeDPKzpLRmKc6mpewZ75Tb9UKEujGBH9ACk
         TtCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5dUj8K6+0mWlPErYm2rq9Z+oT0LCcA9o+12DiBmzbSQ=;
        b=kCXaJOE2Ooeivd7Hhxysx2dbGJ2CAnoii6J63NW6huO0/vC9wSewHX78sfgIcrF+ST
         oFMxNhPgK3ORmTgnPUWwT72gzEigmx6xnAC9C8hhCBKVsyeoN+7MX7q0KVsmAy145cZR
         r/WR4MSy5G29qWCc4qnh2M2+TtqAmhRL4wrMRPkOEf4cMhnurDpx6wouZ5j/0LZ1i8jh
         P6XzRut9U9KdZCt6zoEWctjuA4LpzRHaKHhrEs8luoahgIScHRSmELfyFTJZ/SkmLZGe
         rQwh3QvwZDnjWprueh+BjXRBQbySEZHJAWFbauKNhgw8GJqMKCJDayr35cXKmCb7d9d3
         Bxnw==
X-Gm-Message-State: AOAM532akTMNbA0wEWmdRy9v9mGaOLwkZLz579KO6MNsVbpHzrrS6/v4
        RRux9hqF58GzpwzJwA6Pqcs=
X-Google-Smtp-Source: ABdhPJz/+YjRdPSfSVfWr+74o3qMiwLruDOMxFS004OP2q+pyStRRrfW3AX71Ks1oE7MQ/aXkFymNQ==
X-Received: by 2002:aa7:d70a:: with SMTP id t10mr8421207edq.68.1596803176237;
        Fri, 07 Aug 2020 05:26:16 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id h9sm5915255ejt.50.2020.08.07.05.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 05:26:14 -0700 (PDT)
Date:   Fri, 7 Aug 2020 14:26:13 +0200
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
Message-ID: <20200807122613.GA524643@ulmo>
References: <20200422203245.83244-1-john.stultz@linaro.org>
 <20200422203245.83244-2-john.stultz@linaro.org>
 <20200806135251.GB3351349@ulmo>
 <CALAqxLU=a+KXKya2FkgCuYyw5ttZJ_NXjNbszFzSjP49wMN84g@mail.gmail.com>
 <20200807110244.GB94549@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <20200807110244.GB94549@ulmo>
User-Agent: Mutt/1.14.4 (2020-06-18)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 07, 2020 at 01:02:44PM +0200, Thierry Reding wrote:
> On Thu, Aug 06, 2020 at 07:09:16PM -0700, John Stultz wrote:
> > On Thu, Aug 6, 2020 at 6:52 AM Thierry Reding <thierry.reding@gmail.com=
> wrote:
> > >
> > > On Wed, Apr 22, 2020 at 08:32:43PM +0000, John Stultz wrote:
> > > > This patch addresses a regression in 5.7-rc1+
> > > >
> > > > In commit c8c43cee29f6 ("driver core: Fix
> > > > driver_deferred_probe_check_state() logic"), we both cleaned up
> > > > the logic and also set the default driver_deferred_probe_timeout
> > > > value to 30 seconds to allow for drivers that are missing
> > > > dependencies to have some time so that the dependency may be
> > > > loaded from userland after initcalls_done is set.
> > > >
> > > > However, Yoshihiro Shimoda reported that on his device that
> > > > expects to have unmet dependencies (due to "optional links" in
> > > > its devicetree), was failing to mount the NFS root.
> > > >
> > > > In digging further, it seemed the problem was that while the
> > > > device properly probes after waiting 30 seconds for any missing
> > > > modules to load, the ip_auto_config() had already failed,
> > > > resulting in NFS to fail. This was due to ip_auto_config()
> > > > calling wait_for_device_probe() which doesn't wait for the
> > > > driver_deferred_probe_timeout to fire.
> > > >
> > > > Fixing that issue is possible, but could also introduce 30
> > > > second delays in bootups for users who don't have any
> > > > missing dependencies, which is not ideal.
> > > >
> > > > So I think the best solution to avoid any regressions is to
> > > > revert back to a default timeout value of zero, and allow
> > > > systems that need to utilize the timeout in order for userland
> > > > to load any modules that supply misisng dependencies in the dts
> > > > to specify the timeout length via the exiting documented boot
> > > > argument.
> > > >
> > > > Thanks to Geert for chasing down that ip_auto_config was why NFS
> > > > was failing in this case!
> > > >
> > > > Cc: "David S. Miller" <davem@davemloft.net>
> > > > Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> > > > Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> > > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> > > > Cc: Rob Herring <robh@kernel.org>
> > > > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > > > Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > > > Cc: Robin Murphy <robin.murphy@arm.com>
> > > > Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> > > > Cc: Sudeep Holla <sudeep.holla@arm.com>
> > > > Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
> > > > Cc: Basil Eljuse <Basil.Eljuse@arm.com>
> > > > Cc: Ferry Toth <fntoth@gmail.com>
> > > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > > Cc: Anders Roxell <anders.roxell@linaro.org>
> > > > Cc: netdev <netdev@vger.kernel.org>
> > > > Cc: linux-pm@vger.kernel.org
> > > > Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > > > Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > > > Fixes: c8c43cee29f6 ("driver core: Fix driver_deferred_probe_check_=
state() logic")
> > > > Signed-off-by: John Stultz <john.stultz@linaro.org>
> > > > ---
> > > >  drivers/base/dd.c | 13 ++-----------
> > > >  1 file changed, 2 insertions(+), 11 deletions(-)
> > >
> > > Sorry for being a bit late to the party, but this breaks suspend/resu=
me
> > > support on various Tegra devices. I've only noticed now because, well,
> > > suspend/resume have been broken for other reasons for a little while =
and
> > > it's taken us a bit to resolve those issues.
> > >
> > > But now that those other issues have been fixed, I've started seeing =
an
> > > issue where after resume from suspend some of the I2C controllers are=
 no
> > > longer working. The reason for this is that they share pins with DP A=
UX
> > > controllers via the pinctrl framework. The DP AUX driver registers as
> > > part of the DRM/KMS driver, which usually happens in userspace. Since
> > > the deferred probe timeout was set to 0 by default this no longer wor=
ks
> > > because no pinctrl states are assigned to the I2C controller and
> > > therefore upon resume the pins cannot be configured for I2C operation.
> >=20
> > Oof. My apologies!
> >=20
> > > I'm also somewhat confused by this patch and a few before because they
> > > claim that they restore previous default behaviour, but that's just n=
ot
> > > true. Originally when this timeout was introduced it was -1, which me=
ant
> > > that there was no timeout at all and hence users had to opt-in if they
> > > wanted to use a deferred probe timeout.
> >=20
> > I don't think that's quite true, since the point of my original
> > changes were to avoid troubles I was seeing with drivers not loading
> > because once the timeout fired after init, driver loading would fail
> > with ENODEV instead of returning EPROBE_DEFER. The logic that existed
> > was buggy so the timeout handling didn't really work (changing the
> > boot argument wouldn't help, because after init the logic would return
> > ENODEV before it checked the timeout value).
> >=20
> > That said, looking at it now, I do realize the
> > driver_deferred_probe_check_state_continue() logic in effect never
> > returned ETIMEDOUT before was consolidated in the earlier changes, and
> > now we've backed the default timeout to 0, old user (see bec6c0ecb243)
> > will now get ETIMEDOUT where they wouldn't before.
> >=20
> > So would the following fix it up for you? (sorry its whitespace corrupt=
ed)
> >=20
> > diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
> > index c6fe7d64c913..c7448be64d07 100644
> > --- a/drivers/pinctrl/devicetree.c
> > +++ b/drivers/pinctrl/devicetree.c
> > @@ -129,9 +129,8 @@ static int dt_to_map_one_config(struct pinctrl *p,
> >                 if (!np_pctldev || of_node_is_root(np_pctldev)) {
> >                         of_node_put(np_pctldev);
> >                         ret =3D driver_deferred_probe_check_state(p->de=
v);
> > -                       /* keep deferring if modules are enabled
> > unless we've timed out */
> > -                       if (IS_ENABLED(CONFIG_MODULES) && !allow_defaul=
t &&
> > -                           (ret =3D=3D -ENODEV))
> > +                       /* keep deferring if modules are enabled */
> > +                       if (IS_ENABLED(CONFIG_MODULES) &&
> > !allow_default && ret < 0)
> >                                 ret =3D -EPROBE_DEFER;
> >                         return ret;
> >                 }
> >=20
> > (you could probably argue calling driver_deferred_probe_check_state
> > checking ret at all is silly here, since EPROBE_DEFER is the only
> > option you want)
>=20
> Just by looking at it I would've said, yes, this looks like it would fix
> it. However, upon giving this a try, I see the same pinmux issues as I
> was seeing before. I'm going to have to dig a little deeper to see if I
> can find out why that is, because it isn't obvious to me right away.

Oh, nevermind. I managed to somehow mess up the device tree. With that
fixed the above also restores the pinmux attachment for the I2C
controller and suspend/resume works fine.

Thierry

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl8tSGEACgkQ3SOs138+
s6GHfw/9H5nN8XGczSUnK43wnJxGY4HA8YTW551cMKpvCvXhrbIPrKXv24xMsbG7
F6Q7yFSCN77hFklgMRGjW+2tlDOBYwpor/J/nqjhJ5poXSyBrgM0qi78Nq8g2JR1
p4AdHAUc9pzlxYW+u4MOgEVjDkYMA7cOX335m5ldK1CrQcVsmLbkbwLxRExH/sdz
FpfrI8zCQlxw+px6oiMo/D7cqutYuW7H/D+CY5jHQ8jSbtBkCbpxRgTRO2sOScVz
5jlbT0iRqw1GZCxDRLWyOo+75HoIDpNDCofM1cWlhwiOcnhgSqHuDDVOVcfdko7L
JQqJEKPyG99X6MWZ4oe2jqANUr+GmJ9BqwhTF3qSS7yUiT5t3lCUmXMKh3FGwJQO
bDC0MjFpJDa573N++0tIA9qf1loO3M7mW+kpn80p8T0et32pUT5+RFYtRFYo6/QW
7/YffEpbULMylGulfBx+0gERn/B37teEWfjiH0xF6+DJwemchhM9BZ4GfsQUcyz/
pm5gni9Vs8f1Nj9zbbAtZ9YI4ZMckuDpecBN3bsAZc/QiRdSS3CZB0ZVV81FsrHH
aOGP21IBXq3GUE33pTDh+NygXsnUROAbMhlbhMQL2EN61anTx1btijhQaNu8tGh1
isN1RME//+SnLg+6SeUH9L5/sMlIglIKjtGludz3KCJldgsmFfE=
=q/a7
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
