Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CA84250F8
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 12:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240866AbhJGK0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 06:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231825AbhJGK0r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 06:26:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F60C60C4C;
        Thu,  7 Oct 2021 10:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633602294;
        bh=ovURSsNma7DN09CRPZqqCrVNUPMHPnGPJNUWoT0IKso=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kEOtFaILmndWWmHB4pF4w+OtT4NgSPduEzpl5Uh76av0g2xdnWNhz2PXPo0Z/d1pB
         Y+EwBnWdBi4QRZ53FPpIyLBr8+vBHAu656j1RP9b6itykzJsbZXS+FGh2FKUTBenlA
         VAmKqYcJWM23OolwNasAs7V52STFtYtMmjIQEv1aDkDIU+iLxy0RcQSixLHY4BQoZw
         dRtrr6ZV7cMZExuglqI+9CNQOQ9DvCzZ+kEbeiZbvnUilTR41xN+3n1EeF2jDJIkwG
         gRYnnJHPyUE/GkXG9FHlqIo0A9J0AO/wEJBm2ocBP3hOJ0vLyx7TV2Y5XUSgo24asi
         6ylGqg+mwdijw==
Received: by pali.im (Postfix)
        id 0193A81A; Thu,  7 Oct 2021 12:24:51 +0200 (CEST)
Date:   Thu, 7 Oct 2021 12:24:51 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v7 08/24] wfx: add bus_sdio.c
Message-ID: <20211007102451.gfqw7ucvwqxcgw4m@pali>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
 <149139701.nbvtKH4F0p@pc-42>
 <CAPDyKFr62Kykg3=9WiXAV8UToqjw8gj4t6bbM7pGQ+iGGQRLmg@mail.gmail.com>
 <4117481.h6P39bWmWk@pc-42>
 <87czohckal.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87czohckal.fsf@codeaurora.org>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 07 October 2021 11:26:42 Kalle Valo wrote:
> Jérôme Pouiller <jerome.pouiller@silabs.com> writes:
> > On Wednesday 6 October 2021 17:02:07 CEST Ulf Hansson wrote:
> >> On Tue, 5 Oct 2021 at 10:14, Jérôme Pouiller <jerome.pouiller@silabs.com> wrote:
> >> > On Friday 1 October 2021 17:23:16 CEST Ulf Hansson wrote:
> >> > > On Thu, 30 Sept 2021 at 19:06, Pali Rohár <pali@kernel.org> wrote:
> >> > > > On Thursday 30 September 2021 18:51:09 Jérôme Pouiller wrote:
> >> > > > > On Thursday 30 September 2021 12:07:55 CEST Ulf Hansson wrote:
> >> > > > > > On Mon, 20 Sept 2021 at 18:12, Jerome Pouiller
> >> > > > > > <Jerome.Pouiller@silabs.com> wrote:
> >> > > > > > >
> >> > > > > > > From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> >> > > > > > >
> >> > > > > > > Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> >> > > > > > > ---
> >> > > > > > >  drivers/net/wireless/silabs/wfx/bus_sdio.c | 261 +++++++++++++++++++++
> >> > > > > > >  1 file changed, 261 insertions(+)
> >> > > > > > >  create mode 100644 drivers/net/wireless/silabs/wfx/bus_sdio.c
> >> > > > > > >
> >> > > > > > > diff --git a/drivers/net/wireless/silabs/wfx/bus_sdio.c
> >> > > > > > > b/drivers/net/wireless/silabs/wfx/bus_sdio.c
> >> > > > > >
> >> > > > > > [...]
> >> > > > > >
> >> > > > > > > +
> >> > > > > > > +static int wfx_sdio_probe(struct sdio_func *func,
> >> > > > > > > +                         const struct sdio_device_id *id)
> >> > > > > > > +{
> >> > > > > > > +       struct device_node *np = func->dev.of_node;
> >> > > > > > > +       struct wfx_sdio_priv *bus;
> >> > > > > > > +       int ret;
> >> > > > > > > +
> >> > > > > > > +       if (func->num != 1) {
> >> > > > > > > + dev_err(&func->dev, "SDIO function number is %d while
> >> > > > > > > it should always be 1 (unsupported chip?)\n",
> >> > > > > > > +                       func->num);
> >> > > > > > > +               return -ENODEV;
> >> > > > > > > +       }
> >> > > > > > > +
> >> > > > > > > +       bus = devm_kzalloc(&func->dev, sizeof(*bus), GFP_KERNEL);
> >> > > > > > > +       if (!bus)
> >> > > > > > > +               return -ENOMEM;
> >> > > > > > > +
> >> > > > > > > +       if (!np || !of_match_node(wfx_sdio_of_match, np)) {
> >> > > > > > > + dev_warn(&func->dev, "no compatible device found in
> >> > > > > > > DT\n");
> >> > > > > > > +               return -ENODEV;
> >> > > > > > > +       }
> >> > > > > > > +
> >> > > > > > > +       bus->func = func;
> >> > > > > > > +       bus->of_irq = irq_of_parse_and_map(np, 0);
> >> > > > > > > +       sdio_set_drvdata(func, bus);
> >> > > > > > > +       func->card->quirks |= MMC_QUIRK_LENIENT_FN0 |
> >> > > > > > > +                             MMC_QUIRK_BLKSZ_FOR_BYTE_MODE |
> >> > > > > > > +                             MMC_QUIRK_BROKEN_BYTE_MODE_512;
> >> > > > > >
> >> > > > > > I would rather see that you add an SDIO_FIXUP for the SDIO card, to
> >> > > > > > the sdio_fixup_methods[], in drivers/mmc/core/quirks.h, instead of
> >> > > > > > this.
> >> > > > >
> >> > > > > In the current patch, these quirks are applied only if the device appears
> >> > > > > in the device tree (see the condition above). If I implement them in
> >> > > > > drivers/mmc/core/quirks.h they will be applied as soon as the device is
> >> > > > > detected. Is it what we want?
> >> > > > >
> >> > > > > Note: we already have had a discussion about the strange VID/PID declared
> >> > > > > by this device:
> >> > > > >   https://www.spinics.net/lists/netdev/msg692577.html
> >> > > >
> >> > > > Yes, vendor id 0x0000 is invalid per SDIO spec. So based on this vendor
> >> > > > id, it is not possible to write any quirk in mmc/sdio generic code.
> >> > > >
> >> > > > Ulf, but maybe it could be possible to write quirk based on OF
> >> > > > compatible string?
> >> > >
> >> > > Yes, that would be better in my opinion.
> >> > >
> >> > > We already have DT bindings to describe embedded SDIO cards (a subnode
> >> > > to the mmc controller node), so we should be able to extend that I
> >> > > think.
> >> >
> >> > So, this feature does not yet exist? Do you consider it is a blocker for
> >> > the current patch?
> >> 
> >> Yes, sorry. I think we should avoid unnecessary hacks in SDIO func
> >> drivers, especially those that deserve to be fixed in the mmc core.
> >> 
> >> Moreover, we already support the similar thing for eMMC cards, plus
> >> that most parts are already done for SDIO too.
> >> 
> >> >
> >> > To be honest, I don't really want to take over this change in mmc/core.
> >> 
> >> I understand. Allow me a couple of days, then I can post a patch to
> >> help you out.
> >
> > Great! Thank you. I apologize for the extra work due to this invalid
> > vendor id.
> 
> BTW please escalate in your company how HORRIBLE it is that you
> manufacture SDIO devices without proper device ids, and make sure that
> all your future devices have officially assigned ids. I cannot stress
> enough how important that is for the Linux community!

Absolutely! Please really escalate this problem in your company and
properly ask USB-IF for assigning PCMCIA vendor ID as USB-IF maintains
PCMCIA vendor database and PCMCIA ids are used in SDIO devices:
https://lore.kernel.org/linux-mmc/20210607140216.64iuprp3siggslrk@pali/
