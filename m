Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E49668FB5
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 08:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbjAMHzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 02:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236402AbjAMHzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 02:55:09 -0500
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48ED26878B;
        Thu, 12 Jan 2023 23:55:08 -0800 (PST)
Received: from pendragon.ideasonboard.com (85-76-5-15-nat.elisa-mobile.fi [85.76.5.15])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2DBD14D4;
        Fri, 13 Jan 2023 08:55:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1673596505;
        bh=vRdyiqF+PpWa7HcHfhCtuslDgXVXt8V4AOIdljF1BQo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MplxUnHw8ErIF7LyxmuN/+OcdYTL+KHEXJob0ft2ezOhqAVYE3m8P/x5TGmDxunAX
         hNGSu2Rfv8w4h3WiaTzkK6SyygY+7vdn0jtGh9flpoxnn8uBnWmrnoDsTJWb5wUuXu
         ajDTUWUaMexyxBvmwaL7WwO3/s2maPmjOdQvt9qo=
Date:   Fri, 13 Jan 2023 09:55:04 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 01/22] gpu/drm: remove the shmobile drm driver
Message-ID: <Y8EOWGVmwEElKGE4@pendragon.ideasonboard.com>
References: <20230113062339.1909087-1-hch@lst.de>
 <20230113062339.1909087-2-hch@lst.de>
 <Y8EMZ0GI5rtor9xr@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y8EMZ0GI5rtor9xr@pendragon.ideasonboard.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 09:46:49AM +0200, Laurent Pinchart wrote:
> Hi Christoph,
> 
> Thank you for the patch.
> 
> On Fri, Jan 13, 2023 at 07:23:18AM +0100, Christoph Hellwig wrote:
> > This driver depends on ARM && ARCH_SHMOBILE, but ARCH_SHMOBILE can only be
> > set for each/sh, making the driver dead code except for the COMPILE_TEST
> > case.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> No objection from me.
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

To expand a little bit on this, ARCH_SHMOBILE used to be set for the
ARM-based shmobile SoCs too, until

commit 08e735233ea29b17bfec8e4cb302e799d9f920b8
Author: Geert Uytterhoeven <geert+renesas@glider.be>
Date:   Tue Aug 28 17:10:10 2018 +0200

    ARM: shmobile: Remove the ARCH_SHMOBILE Kconfig symbol

    All drivers for Renesas ARM SoCs have gained proper ARCH_RENESAS
    platform dependencies.  Hence finish the conversion from ARCH_SHMOBILE
    to ARCH_RENESAS for Renesas 32-bit ARM SoCs, as started by commit
    9b5ba0df4ea4f940 ("ARM: shmobile: Introduce ARCH_RENESAS").

    Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

merged in v4.20. The DRM shmobile driver's Kconfig entry wasn't updated,
making it dead code indeed.

I haven't tested this driver in ages, hence my lack of objection, but
someone may want to keep it for the pre-R-Car ARM SoCs.

Also, I just noticed that you forgot to update the MAINTAINERS file in
this patch to drop the drivers/gpu/drm/shmobile/ entry.

> > ---
> >  drivers/gpu/drm/Kconfig                       |   2 -
> >  drivers/gpu/drm/Makefile                      |   1 -
> >  drivers/gpu/drm/shmobile/Kconfig              |  12 -
> >  drivers/gpu/drm/shmobile/Makefile             |   8 -
> >  .../gpu/drm/shmobile/shmob_drm_backlight.c    |  82 ---
> >  .../gpu/drm/shmobile/shmob_drm_backlight.h    |  19 -
> >  drivers/gpu/drm/shmobile/shmob_drm_crtc.c     | 683 ------------------
> >  drivers/gpu/drm/shmobile/shmob_drm_crtc.h     |  55 --
> >  drivers/gpu/drm/shmobile/shmob_drm_drv.c      | 303 --------
> >  drivers/gpu/drm/shmobile/shmob_drm_drv.h      |  42 --
> >  drivers/gpu/drm/shmobile/shmob_drm_kms.c      | 150 ----
> >  drivers/gpu/drm/shmobile/shmob_drm_kms.h      |  29 -
> >  drivers/gpu/drm/shmobile/shmob_drm_plane.c    | 261 -------
> >  drivers/gpu/drm/shmobile/shmob_drm_plane.h    |  19 -
> >  drivers/gpu/drm/shmobile/shmob_drm_regs.h     | 310 --------
> >  15 files changed, 1976 deletions(-)
> >  delete mode 100644 drivers/gpu/drm/shmobile/Kconfig
> >  delete mode 100644 drivers/gpu/drm/shmobile/Makefile
> >  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_backlight.c
> >  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_backlight.h
> >  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_crtc.c
> >  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_crtc.h
> >  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_drv.c
> >  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_drv.h
> >  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_kms.c
> >  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_kms.h
> >  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_plane.c
> >  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_plane.h
> >  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_regs.h

-- 
Regards,

Laurent Pinchart
