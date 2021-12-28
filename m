Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA374807AC
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 10:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbhL1JPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 04:15:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56350 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbhL1JPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 04:15:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E43C6117A;
        Tue, 28 Dec 2021 09:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36527C36AE7;
        Tue, 28 Dec 2021 09:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640682932;
        bh=GhkQipbGlKDnWFYSWHR8QJ9jDw3XiA0zWUSH0TczCbE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dYWghGQbT+zkKYVLv1Zhab/gyFy9VpZvbxpbFRNzp3Lo5J6P/Q+Wf9wZJ3oL1Y4nF
         96QRZWFgrpKChm6T6ENMeuTcDkoRMS//XW4vNdMJB4gLdNcNmX96GZTLdULruuieLb
         emRGzvA33ANfq1HyCg7yWlEMSY81FT51jd/pZeMOMTkwWI2S8tmDueYyTyJr7hwGcG
         yL5P+Au50kwMpsldooh4cVnB+oQkMDs7kWcv4culv3nNyxGHHdqsdStKVVXhf5e3AJ
         K3RgIP6/xYabneVHyG9NqbWuq3dYLRaZSL3QAii2RDYrapQzGorXDljBWHF9TwGY4F
         k139XXS0mA/xw==
Date:   Tue, 28 Dec 2021 10:15:16 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        John Garry <john.garry@huawei.com>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Kalle Valo <kvalo@kernel.org>, Jouni Malinen <j@w1.fi>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Jiri Slaby <jirislaby@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-csky@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        linux-media@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-wireless@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        linux-spi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-watchdog@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [RFC 01/32] Kconfig: introduce and depend on LEGACY_PCI
Message-ID: <20211228101435.3a55b983@coco.lan>
In-Reply-To: <YcrJAwsKIxxX18pW@kroah.com>
References: <20211227164317.4146918-1-schnelle@linux.ibm.com>
        <20211227164317.4146918-2-schnelle@linux.ibm.com>
        <YcrJAwsKIxxX18pW@kroah.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, 28 Dec 2021 09:21:23 +0100
Greg Kroah-Hartman <gregkh@linuxfoundation.org> escreveu:

> On Mon, Dec 27, 2021 at 05:42:46PM +0100, Niklas Schnelle wrote:
> > --- a/drivers/pci/Kconfig
> > +++ b/drivers/pci/Kconfig
> > @@ -23,6 +23,17 @@ menuconfig PCI
> >  
> >  if PCI
> >  
> > +config LEGACY_PCI
> > +	bool "Enable support for legacy PCI devices"
> > +	depends on HAVE_PCI
> > +	help
> > +	   This option enables support for legacy PCI devices. This includes
> > +	   PCI devices attached directly or via a bridge on a PCI Express bus.
> > +	   It also includes compatibility features on PCI Express devices which
> > +	   make use of legacy I/O spaces.  

This Kconfig doesn't seem what it is needed there, as this should be an 
arch-dependent feature, and not something that the poor user should be
aware if a given architecture supports it or not. Also, the above will keep
causing warnings or errors with randconfigs.

Also, the "depends on HAVE_CPI" is bogus, as PCI already depends on 
HAVE_PCI:

	menuconfig PCI
	bool "PCI support"
	depends on HAVE_PCI
	help
	  This option enables support for the PCI local bus, including
	  support for PCI-X and the foundations for PCI Express support.
	  Say 'Y' here unless you know what you are doing.

So, instead, I would expect that a new HAVE_xxx option would be
added at arch/*/Kconfig, like:

	config X86
		...
		select HAVE_PCI_DIRECT_IO

It would also make sense to document it at Documentation/features/.

> 
> All you really care about is the "legacy" I/O spaces here, this isn't
> tied to PCI specifically at all, right?
> 
> So why not just have a OLD_STYLE_IO config option or something like
> that, to show that it's the i/o functions we care about here, not PCI at
> all?
> 
> And maybe not call it "old" or "legacy" as time constantly goes forward,
> just describe it as it is, "DIRECT_IO"?

Agreed. HAVE_PCI_DIRECT_IO (or something similar) seems a more appropriate
name for it.

Thanks,
Mauro
