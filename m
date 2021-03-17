Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66CB33E86B
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 05:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhCQE0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 00:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhCQEZ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 00:25:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27F3764F9E;
        Wed, 17 Mar 2021 04:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615955158;
        bh=b0+guY3uHI/7UugdBIJZaedLb8084zSH7Fj2VTny2X0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZnTO7xz3vXP2Hf3iarFYTkOy0PTS63Wwsd6gQE4Sklk4G9sX/pd5jC78A3wO+QrNo
         rCOBENUMFbAvxpj2Bdkrls0VFfqJ3FiRzw45r4MCdpzcC0vFkP1fXhlj6N+hod6RhI
         0caOQfvz+18hHQu6dcxqShjZ0CjLMxgyf1on3dpS7pKxBmpnbDF3PIoro33h5aAdnu
         iiOJRlTEDqLRVzUN3V4iuKv8Vd6EvxHP82AN3+bG7xP81PHIujuNKe9bWWsBO11ak1
         0YcZEJDZNUQRdHtCvJDAz+T+800RykOSqCTdtghpS00lMdv1T/OxaLn07ALduFYk0W
         htpuRlHqcfXhw==
Date:   Wed, 17 Mar 2021 06:25:54 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v5 03/24] wfx: add Makefile/Kconfig
Message-ID: <YFGE0t5LQuPp0M5h@unreal>
References: <20210315132501.441681-1-Jerome.Pouiller@silabs.com>
 <20210315132501.441681-4-Jerome.Pouiller@silabs.com>
 <YE95OCx5hWRedi+W@unreal>
 <1718324.Ee3sdLpQUQ@pc-42>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1718324.Ee3sdLpQUQ@pc-42>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 05:21:35PM +0100, Jérôme Pouiller wrote:
> Hi Leon,
>
> On Monday 15 March 2021 16:11:52 CET Leon Romanovsky wrote:
> > On Mon, Mar 15, 2021 at 02:24:40PM +0100, Jerome Pouiller wrote:
> > > From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > >
> > > Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > > ---
> > >  drivers/net/wireless/silabs/wfx/Kconfig  | 12 +++++++++++
> > >  drivers/net/wireless/silabs/wfx/Makefile | 26 ++++++++++++++++++++++++
> > >  2 files changed, 38 insertions(+)
> > >  create mode 100644 drivers/net/wireless/silabs/wfx/Kconfig
> > >  create mode 100644 drivers/net/wireless/silabs/wfx/Makefile
> > >
> > > diff --git a/drivers/net/wireless/silabs/wfx/Kconfig b/drivers/net/wireless/silabs/wfx/Kconfig
> > > new file mode 100644
> > > index 000000000000..3be4b1e735e1
> > > --- /dev/null
> > > +++ b/drivers/net/wireless/silabs/wfx/Kconfig
> > > @@ -0,0 +1,12 @@
> > > +config WFX
> > > +     tristate "Silicon Labs wireless chips WF200 and further"
> > > +     depends on MAC80211
> > > +     depends on MMC || !MMC # do not allow WFX=y if MMC=m
> > > +     depends on (SPI || MMC)
> > > +     help
> > > +       This is a driver for Silicons Labs WFxxx series (WF200 and further)
> > > +       chipsets. This chip can be found on SPI or SDIO buses.
> > > +
> > > +       Silabs does not use a reliable SDIO vendor ID. So, to avoid conflicts,
> > > +       the driver won't probe the device if it is not also declared in the
> > > +       Device Tree.
> > > diff --git a/drivers/net/wireless/silabs/wfx/Makefile b/drivers/net/wireless/silabs/wfx/Makefile
> > > new file mode 100644
> > > index 000000000000..f399962c8619
> > > --- /dev/null
> > > +++ b/drivers/net/wireless/silabs/wfx/Makefile
> > > @@ -0,0 +1,26 @@
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +
> > > +# Necessary for CREATE_TRACE_POINTS
> > > +CFLAGS_debug.o = -I$(src)
> >
> > I wonder if it is still relevant outside of the staging tree.
>
> It seems this pattern is common in the main tree. You suggest to relocate
> trace.h to include/trace/events?

No, leave it as it. Sorry for the noise.

Thanks

>
> --
> Jérôme Pouiller
>
>
