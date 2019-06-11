Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CADC13C5CA
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 10:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404662AbfFKIQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 04:16:04 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:40425 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403996AbfFKIQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 04:16:04 -0400
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1habwb-0003K3-2W; Tue, 11 Jun 2019 10:15:49 +0200
Message-ID: <1560240943.13886.1.camel@pengutronix.de>
Subject: Re: [PATCH 5/8] drivers: media: coda: fix warning same module names
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Matt Redfearn <matt.redfearn@thinci.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "marex@denx.de" <marex@denx.de>,
        "stefan@agner.ch" <stefan@agner.ch>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "a.hajda@samsung.com" <a.hajda@samsung.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date:   Tue, 11 Jun 2019 10:15:43 +0200
In-Reply-To: <c2ff2c77-5c14-4bc4-f59c-7012d272ec76@thinci.com>
References: <20190606094722.23816-1-anders.roxell@linaro.org>
         <d6b79ee0-07c6-ad81-16b0-8cf929cc214d@xs4all.nl>
         <CADYN=9KY5=FzrkC7MKj9QnG-eM1NVuL00w8Xv4yU2r05rhr7WQ@mail.gmail.com>
         <c2ff2c77-5c14-4bc4-f59c-7012d272ec76@thinci.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 2019-06-10 at 13:14 +0000, Matt Redfearn wrote:
> 
> On 10/06/2019 14:03, Anders Roxell wrote:
> > On Thu, 6 Jun 2019 at 12:13, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > 
> > > On 6/6/19 11:47 AM, Anders Roxell wrote:
> > > > When building with CONFIG_VIDEO_CODA and CONFIG_CODA_FS enabled as
> > > > loadable modules, we see the following warning:
> > > > 
> > > > warning: same module names found:
> > > >    fs/coda/coda.ko
> > > >    drivers/media/platform/coda/coda.ko
> > > > 
> > > > Rework so media coda matches the config fragment. Leaving CODA_FS as is
> > > > since thats a well known module.
> > > > 
> > > > Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> > > > ---
> > > >   drivers/media/platform/coda/Makefile | 4 ++--
> > > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/media/platform/coda/Makefile b/drivers/media/platform/coda/Makefile
> > > > index 54e9a73a92ab..588e6bf7c190 100644
> > > > --- a/drivers/media/platform/coda/Makefile
> > > > +++ b/drivers/media/platform/coda/Makefile
> > > > @@ -1,6 +1,6 @@
> > > >   # SPDX-License-Identifier: GPL-2.0-only
> > > > 
> > > > -coda-objs := coda-common.o coda-bit.o coda-gdi.o coda-h264.o coda-mpeg2.o coda-mpeg4.o coda-jpeg.o
> > > > +video-coda-objs := coda-common.o coda-bit.o coda-gdi.o coda-h264.o coda-mpeg2.o coda-mpeg4.o coda-jpeg.o
> > > > 
> > > > -obj-$(CONFIG_VIDEO_CODA) += coda.o
> > > > +obj-$(CONFIG_VIDEO_CODA) += video-coda.o
> > > 
> > > How about imx-coda? video-coda suggests it is part of the video subsystem,
> > > which it isn't.
> > 
> > I'll resend a v2 shortly with imx-coda instead.

I'd be in favor of calling it "coda-vpu" instead.

> What about other vendor SoCs implementing the Coda IP block which are 
> not an imx? I'd prefer a more generic name - maybe media-coda.

Right, this driver can be used on other SoCs [1].

[1] https://www.mail-archive.com/linux-media@vger.kernel.org/msg146498.html

regards
Philipp
