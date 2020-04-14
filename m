Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D319D1A8D50
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 23:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633713AbgDNVKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 17:10:34 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:35569 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733025AbgDNVKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 17:10:30 -0400
Received: from mail-qt1-f172.google.com ([209.85.160.172]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1M2w0K-1jPZHx48w0-003MvL; Tue, 14 Apr 2020 23:10:26 +0200
Received: by mail-qt1-f172.google.com with SMTP id s30so11570542qth.2;
        Tue, 14 Apr 2020 14:10:25 -0700 (PDT)
X-Gm-Message-State: AGi0PuZy+Fwkk0wHRtar9vwfFhqYovV5Kvg1DUcY4CACvSE1JrRFNg29
        d2qfkznoikgUdl4ttQJMMmFAOfzxo4yEJBpElyI=
X-Google-Smtp-Source: APiQypIfZFDXhI4lfhgtQhLYBcr5CwllPu4hW9XiyLfwj2+0CNULa+LPLq/UglD75HRb9VggpbRIiRppC0fPBwcpn5M=
X-Received: by 2002:ac8:296f:: with SMTP id z44mr16506720qtz.18.1586898624486;
 Tue, 14 Apr 2020 14:10:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200408202711.1198966-1-arnd@arndb.de> <20200408202711.1198966-6-arnd@arndb.de>
 <20200414201739.GJ19819@pendragon.ideasonboard.com> <CAK8P3a0hd5bsezrJS3+GV2nRMui4P5yeD2Rk7wQpJsAZeOCOUg@mail.gmail.com>
 <20200414205158.GM19819@pendragon.ideasonboard.com>
In-Reply-To: <20200414205158.GM19819@pendragon.ideasonboard.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 14 Apr 2020 23:10:08 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1PZbwdvdH_Gi9UQVUz2+_a8QDxKuWLqPtjhK1stxzMBQ@mail.gmail.com>
Message-ID: <CAK8P3a1PZbwdvdH_Gi9UQVUz2+_a8QDxKuWLqPtjhK1stxzMBQ@mail.gmail.com>
Subject: Re: [RFC 5/6] drm/rcar-du: fix selection of CMM driver
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:a8WGAT5AJthQDNS/7Nj8B52n5j60+HG2fzoN+gb2gdj3gP/Jmmx
 3SE3HImIDUxg7ZE5314iDoJa4HnsHCm+jX7iNq+huSyITSd/qpiuOFo7h5hTPrGWgaCQoN/
 +TIlnb6SmdPVP7uRMde1hCk5woxeuOxJ0LJUI/K/pdwDM5Dp2Xd96PLSmuNPbuKkbm7sCgI
 Yh1HKrL1EdCRzhDOCBtkw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vc+0jWPD8GU=:t2YtIX2F85uzHoov9/daVy
 v5bwqmf6AOehFpMLBYwjQ93cDcnxd4zTvNXPtZd0SLoye9GuzUnnd3chRS7JOXz9f443p+ktf
 yT+qjz0LykHBIbsiUMAxsU5zVvxHaOyEjeJfyCBuQZTXFwzKCR7Fu25//EN0cdI/0qnw7kjM0
 fArbEUmn3vqOeGEE0sdWkTHDNPMwjAg612sLh2r0rYq1Z7enWAcwrQNFNXoecxibFxdDJz9kf
 Qjd5r7vMgCBOSEGmNhMk/Wgn5QtPP9+Ue2sDu3qqz2V1u4U9s3lEjbm6aBIun4t9nyzoL6yfu
 hcRYQg8ozaqRg77WnDZCY7nMtY2dhi9VKl7Hoxdq66uDGCjxL+DTKpfWcf8p6j6Obyw7apSak
 VFmdQx3/4FKuu9xLS/efchZ14z06X/XN0EQTILjFSGCGs/tuMMK+m6cQ1fuiyzADlKz8klwk+
 aaZB1oXNY97dGROFHGyZBAX+ObIdzSsjyDuh4i01sWMRVfsAUF06Dz7bTUS4OKKgq2Gcs09Az
 EY+WEf95JvIKPLOGNKf2eS55NUixc3LmL9p+78gBs2XOpIe9dvyUjZpmrQUzNAOf5LBD/TuaI
 tFBwz5ejlY3exAdXOrEM4H3A5+h8p+Y5SFhyCnsW2CgppPC9ce79IeDfmAJ1BKOBxRnzKZP9R
 dzOY2qsbNQgMAIPk91JJVcqIjLD5uJHFPkZ76/u4pVdMO8LCgTg/2JRir8xFKXcxKfqqLKjbO
 sxE/uolwifZ90Pr7GvegjjiGlOPJ0lOMP88Tyz2/HVMCFO81H9KxV6fZS+7npfpdfFPOi89RL
 tmM2VWADXOEZeTQXW71eaYACIoF04ObCEwAeh9DOT1jKZuNLb8=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 10:52 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Arnd,
>
> On Tue, Apr 14, 2020 at 10:38:27PM +0200, Arnd Bergmann wrote:
> > On Tue, Apr 14, 2020 at 10:17 PM Laurent Pinchart wrote:
> > > On Wed, Apr 08, 2020 at 10:27:10PM +0200, Arnd Bergmann wrote:
> > > > The 'imply' statement does not seem to have an effect, as it's
> > > > still possible to turn the CMM code into a loadable module
> > > > in a randconfig build, leading to a link error:
> > > >
> > > > arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_crtc.o: in function `rcar_du_crtc_atomic_enable':
> > > > rcar_du_crtc.c:(.text+0xad4): undefined reference to `rcar_lvds_clk_enable'
> > > > arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_crtc.o: in function `rcar_du_crtc_atomic_disable':
> > > > rcar_du_crtc.c:(.text+0xd7c): undefined reference to `rcar_lvds_clk_disable'
> > > > arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_drv.o: in function `rcar_du_init':
> > > > rcar_du_drv.c:(.init.text+0x4): undefined reference to `rcar_du_of_init'
> > > > arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_encoder.o: in function `rcar_du_encoder_init':
> > > >
> > > > Remove the 'imply', and instead use a silent symbol that defaults
> > > > to the correct setting.
> > >
> > > This will result in the CMM always being selected when DU is, increasing
> > > the kernel size even for devices that don't need it. I believe we need a
> > > better construct in Kconfig to fix this.
> >
> > I had expected this to have the same meaning that we had before the
> > Kconfig change: whenever the dependencies are available, turn it on,
> > otherwise leave it disabled.
> >
> > Can you describe what behavior you actually want instead?
>
> Doesn't "imply" mean it gets selected by default but can be manually
> disabled ?

That may be what it means now (I still don't understand how it's defined
as of v5.7-rc1), but traditionally it was more like a 'select if all
dependencies
are met'.

> > > > --- a/drivers/gpu/drm/rcar-du/Kconfig
> > > > +++ b/drivers/gpu/drm/rcar-du/Kconfig
> > > > @@ -4,7 +4,6 @@ config DRM_RCAR_DU
> > > >       depends on DRM && OF
> > > >       depends on ARM || ARM64
> > > >       depends on ARCH_RENESAS || COMPILE_TEST
> > > > -     imply DRM_RCAR_CMM
> > > >       imply DRM_RCAR_LVDS
> > > >       select DRM_KMS_HELPER
> > > >       select DRM_KMS_CMA_HELPER
> > > > @@ -15,9 +14,8 @@ config DRM_RCAR_DU
> > > >         If M is selected the module will be called rcar-du-drm.
> > > >
> > > >  config DRM_RCAR_CMM
> > > > -     tristate "R-Car DU Color Management Module (CMM) Support"
> > > > +     def_tristate DRM_RCAR_DU
> > > >       depends on DRM && OF
> > > > -     depends on DRM_RCAR_DU
> > > >       help
> >
> > It would be easy enough to make this a visible 'bool' symbol and
> > build it into the rcu-du-drm.ko module itself. Would that help you?
>
> That could indeed simplify a few things. I wonder if it could introduce
> a few small issues though (but likely nothing we can't fix). The two
> that come to mind are the fact that the module would have two
> MODULE_DESCRIPTION and MODULE_LICENSE entries (I have no idea if that
> could cause breakages), and that it could make module unloading more
> difficult as the CMM being used by the DU would increase the refcount on
> the module. I think the latter could be worked around by manually
> unbinding the DU device through sysfs before unloading the module (and I
> can't say for sure that unloading the DU module is not broken today
> *innocent and naive look* :-)).

In that case, a Makefile trick could also work, doing

ifdef CONFIG_DRM_RCAR_CMM
obj-$(CONFIG_DRM_RCAR_DU) += rcar-cmm.o
endif

Thereby making the cmm module have the same state (y or m) as
the du module whenever the option is enabled.

       Arnd
