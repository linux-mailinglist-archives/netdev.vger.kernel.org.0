Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636861A8C9D
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 22:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633264AbgDNUiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 16:38:52 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:55737 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2633249AbgDNUiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 16:38:50 -0400
Received: from mail-qv1-f54.google.com ([209.85.219.54]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MauFB-1irJEt3wFP-00cOjE; Tue, 14 Apr 2020 22:38:45 +0200
Received: by mail-qv1-f54.google.com with SMTP id s18so638435qvn.1;
        Tue, 14 Apr 2020 13:38:44 -0700 (PDT)
X-Gm-Message-State: AGi0PuaoWkTXRsUOxpOEqlt/1u0b/SP8PHfn2mnH12gv5fZYdiaHISDH
        ChQQVp7IFOhL2+d7JKpR9wJ7sFV7QW2H8+E6kFo=
X-Google-Smtp-Source: APiQypItYypDsjCwUbSgds2sz8DtaSNucgF8fWN3bMg92RuY+7b77MZXAmlayTdn31FZhJ2svnHHXIwy2Ox7TvokgAw=
X-Received: by 2002:a0c:9e2f:: with SMTP id p47mr1723210qve.211.1586896723453;
 Tue, 14 Apr 2020 13:38:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200408202711.1198966-1-arnd@arndb.de> <20200408202711.1198966-6-arnd@arndb.de>
 <20200414201739.GJ19819@pendragon.ideasonboard.com>
In-Reply-To: <20200414201739.GJ19819@pendragon.ideasonboard.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 14 Apr 2020 22:38:27 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0hd5bsezrJS3+GV2nRMui4P5yeD2Rk7wQpJsAZeOCOUg@mail.gmail.com>
Message-ID: <CAK8P3a0hd5bsezrJS3+GV2nRMui4P5yeD2Rk7wQpJsAZeOCOUg@mail.gmail.com>
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
X-Provags-ID: V03:K1:dqrp7JkNNsMQlw1Bdn3hKpX2UowZXiBh5IUBH567D09Ot0xDJgQ
 ROZf4sZj5Ms5EvdwYRNIUDFzKH1fDFGuRDlOp4vqSw0Gu+nMcIxFAZaObOSgt+XOPQ5dy1j
 2VbYT4YfMJjddwZL8i4hcpvsv7oAuR25Kw7Qx0uovkQr5s+WwdrC6hTfNhQL69IkGkESNAI
 hjFEW3xWp/LjO3Ba2r5xA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:SPn/oDEMQI0=:LFfpQIjSq+G7WXlQphcqES
 lcN5Qcv0+PUIB/j7pKfSvAY2kWgeYBEJnKNzs/P7kUs75V74ND5mmfFH1FXI2k/qhgHSN8lm9
 jaIDCm2AmnxxFLdIE5dA4bifDfgzaaCnV+qj9oGZnjnJpwnd6kCltcm0+gVtM+jzR8YFMyID2
 APedZNUXbdU1SxgzufGP2nbgBioZEt5zWDnzEEsqtHe1SRZZ5hP9JT+XvaupS3eoNYYjraHbG
 Fff5eCQpNBSpEGWldQ6XY+J86LF7I1E9nNlCOk1AdMKWjGeTmXUTCV1D/aj+qJ7z6sW+jDGDa
 q/JXJWh11G7uL0iM11OgefhtGffmqR/g3GIMQp2pYwxhrl/SctHkqX+8NeUJPE8BiYyKWDrfz
 /8f0EomIX+8Zr+pDG4EXyN3UQKsNMtgIwZLtCF6H79bLYEpkPunxeoGXbjxJHc6+Byw2cIb2t
 RWdEeQioDptrhMEpj82ptoy1z2COwihIOWgW59dai6IAu6XSFshjBdIQaDJARdVjTDeKdAotR
 iRLX/arW9PvNnXvJWmv2sXb2ba7c2ZUaPZNmel5Xho7KpBXX/vn7XBQ3v/bEEzsVnZS3ogYpL
 VJ+Te6BtHVx/igftfjAkOWuBruPQkKvJK7mLZ3OjBQlo0cWuqc6KrskWR1wemE58lUkUw1Q9w
 F5voovvHVajtVdejoCBeaisvh4zeGcFfvohY/5dbLIdLQ1SA1smKO/0yD1tUp8QBG8aEGLmex
 VGVUh7Gx7O+v23dgSKv7m28XpbkuvWQK9RQYA9Qsw46KefKcWYq0Skgn+R/CApdMxp1hI5rNV
 /YuTlKKzWQ8YLZeSKq78dm+yN+iX0BxtKNmSfbN5zMIT4q+cI8=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 10:17 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Arnd,
>
> Thank you for the patch.
>
> On Wed, Apr 08, 2020 at 10:27:10PM +0200, Arnd Bergmann wrote:
> > The 'imply' statement does not seem to have an effect, as it's
> > still possible to turn the CMM code into a loadable module
> > in a randconfig build, leading to a link error:
> >
> > arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_crtc.o: in function `rcar_du_crtc_atomic_enable':
> > rcar_du_crtc.c:(.text+0xad4): undefined reference to `rcar_lvds_clk_enable'
> > arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_crtc.o: in function `rcar_du_crtc_atomic_disable':
> > rcar_du_crtc.c:(.text+0xd7c): undefined reference to `rcar_lvds_clk_disable'
> > arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_drv.o: in function `rcar_du_init':
> > rcar_du_drv.c:(.init.text+0x4): undefined reference to `rcar_du_of_init'
> > arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_encoder.o: in function `rcar_du_encoder_init':
> >
> > Remove the 'imply', and instead use a silent symbol that defaults
> > to the correct setting.
>
> This will result in the CMM always being selected when DU is, increasing
> the kernel size even for devices that don't need it. I believe we need a
> better construct in Kconfig to fix this.

I had expected this to have the same meaning that we had before the
Kconfig change: whenever the dependencies are available, turn it on,
otherwise leave it disabled.

Can you describe what behavior you actually want instead?
> > --- a/drivers/gpu/drm/rcar-du/Kconfig
> > +++ b/drivers/gpu/drm/rcar-du/Kconfig
> > @@ -4,7 +4,6 @@ config DRM_RCAR_DU
> >       depends on DRM && OF
> >       depends on ARM || ARM64
> >       depends on ARCH_RENESAS || COMPILE_TEST
> > -     imply DRM_RCAR_CMM
> >       imply DRM_RCAR_LVDS
> >       select DRM_KMS_HELPER
> >       select DRM_KMS_CMA_HELPER
> > @@ -15,9 +14,8 @@ config DRM_RCAR_DU
> >         If M is selected the module will be called rcar-du-drm.
> >
> >  config DRM_RCAR_CMM
> > -     tristate "R-Car DU Color Management Module (CMM) Support"
> > +     def_tristate DRM_RCAR_DU
> >       depends on DRM && OF
> > -     depends on DRM_RCAR_DU
> >       help

It would be easy enough to make this a visible 'bool' symbol and
build it into the rcu-du-drm.ko module itself. Would that help you?

       Arnd
