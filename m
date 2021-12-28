Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB90480952
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 13:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhL1Myw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 07:54:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45878 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbhL1Myr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 07:54:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55AA6B811D9;
        Tue, 28 Dec 2021 12:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4546BC36AE8;
        Tue, 28 Dec 2021 12:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640696083;
        bh=Gap0GwZ7QhskHCBuxCWJ0ehIbXdcDMw/3DRBfuFroAo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uT1Bi526RdiqCovjK+BsZ0LQ21O6eAGdLfperJgxt/T4KZXCQHLowjI+U/BnL+30l
         HJRegFW6ceEx7gRTUzAnY/lOi8+345syFMoVZJg23IyMTVv8lxOmatGJsejunnysTY
         b7cgtAhK1rV1ciaHNDicksS8OtcQVVqsJ8fTaLs35K3JpOGyDL1M7tu/pQlaK0TC5o
         847l3oZwcFMOo4LfbX6OTisn674FFeznktD1n6AMeVW9VoFWIsJndv9O02I/tcIR5D
         xfPFEZmvAPeSdi4V+6+pSCDV5v0lZDnuzytqnQmuAjGw0iIL513WDap3bYMORE0U6k
         6wPKV3GCt3SBA==
Date:   Tue, 28 Dec 2021 13:54:25 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Message-ID: <20211228135425.0a69168c@coco.lan>
In-Reply-To: <b1475f6aecb752a858941f44a957b2183cd68405.camel@linux.ibm.com>
References: <20211227164317.4146918-1-schnelle@linux.ibm.com>
        <20211227164317.4146918-2-schnelle@linux.ibm.com>
        <YcrJAwsKIxxX18pW@kroah.com>
        <20211228101435.3a55b983@coco.lan>
        <b1475f6aecb752a858941f44a957b2183cd68405.camel@linux.ibm.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, 28 Dec 2021 11:58:55 +0100
Niklas Schnelle <schnelle@linux.ibm.com> escreveu:

> On Tue, 2021-12-28 at 10:15 +0100, Mauro Carvalho Chehab wrote:
> > Em Tue, 28 Dec 2021 09:21:23 +0100
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> escreveu:
> >   
> > > On Mon, Dec 27, 2021 at 05:42:46PM +0100, Niklas Schnelle wrote:  
> > > > --- a/drivers/pci/Kconfig
> > > > +++ b/drivers/pci/Kconfig
> > > > @@ -23,6 +23,17 @@ menuconfig PCI
> > > >  
> > > >  if PCI
> > > >  
> > > > +config LEGACY_PCI
> > > > +	bool "Enable support for legacy PCI devices"
> > > > +	depends on HAVE_PCI
> > > > +	help
> > > > +	   This option enables support for legacy PCI devices. This includes
> > > > +	   PCI devices attached directly or via a bridge on a PCI Express bus.
> > > > +	   It also includes compatibility features on PCI Express devices which
> > > > +	   make use of legacy I/O spaces.    
> > 
> > This Kconfig doesn't seem what it is needed there, as this should be an 
> > arch-dependent feature, and not something that the poor user should be
> > aware if a given architecture supports it or not. Also, the above will keep
> > causing warnings or errors with randconfigs.
> > 
> > Also, the "depends on HAVE_CPI" is bogus, as PCI already depends on 
> > HAVE_PCI:  
> 
> Ah yes you're right.
> 
> > 
> > 	menuconfig PCI
> > 	bool "PCI support"
> > 	depends on HAVE_PCI
> > 	help
> > 	  This option enables support for the PCI local bus, including
> > 	  support for PCI-X and the foundations for PCI Express support.
> > 	  Say 'Y' here unless you know what you are doing.
> > 
> > So, instead, I would expect that a new HAVE_xxx option would be
> > added at arch/*/Kconfig, like:
> > 
> > 	config X86
> > 		...
> > 		select HAVE_PCI_DIRECT_IO
> > 
> > It would also make sense to document it at Documentation/features/.  
> 
> I'll look into that, thanks.
> 
> >   
> > > All you really care about is the "legacy" I/O spaces here, this isn't
> > > tied to PCI specifically at all, right?
> > > 
> > > So why not just have a OLD_STYLE_IO config option or something like
> > > that, to show that it's the i/o functions we care about here, not PCI at
> > > all?
> > > 
> > > And maybe not call it "old" or "legacy" as time constantly goes forward,
> > > just describe it as it is, "DIRECT_IO"?  
> > 
> > Agreed. HAVE_PCI_DIRECT_IO (or something similar) seems a more appropriate
> > name for it.
> > 
> > Thanks,
> > Mauro  
> 
> Hmm, I might be missing something here but that sounds a lot like the
> HAS_IOPORT option added in patch 02.
> 
> We add both LEGACY_PCI and HAS_IOPORT to differentiate between two
> cases. HAS_IOPORT is for PC-style devices that are not on a PCI card
> while LEGACY_PCI is for PCI drivers that require port I/O. 

I didn't look at the other patches on this series, but why it is needed
to deal with them on a separate way? Won't "PCI" and "HAS_IOPORT" be enough? 

I mean, are there any architecture where HAVE_PCI=y and HAS_IOPORT=y
where LEGACY_PCI shall be "n"?

> This
> includes pre-PCIe devices as well as PCIe devices which require
> features like I/O spaces. The "legacy" naming is comes from the PCIe
> spec which in section 2.1.1.2 says "PCI Express supports I/O Space for
> compatibility with legacy devices which require their use. Future
> revisions of this specification may deprecate the use of I/O Space."

I would still avoid calling it LEGACY_PCI, as this sounds too generic.

I didn't read the PCI/PCIe specs, but I suspect that are a lot more
features that were/will be deprecated on PCI specs as time goes by.

So, I would, instead, use something like PCI_LEGACY_IO_SPACE or 
HAVE_PCI_LEGACY_IO_SPACE, in order to let it clear what "legacy"
means.

> These two separate config options allow us to compile without support
> for these legacy PCI devices even on a system where inb()/outb() and
> friends are required for some PC style devices and for example ACPI.

Hmm... why this patch make SND_BT87X dependent on LEGACY_PCI?

> @@ -172,6 +177,7 @@ config SND_AZT3328
>  
>  config SND_BT87X
>  	tristate "Bt87x Audio Capture"
> +	depends on LEGACY_PCI
>  	select SND_PCM
>  	help
>  	  If you want to record audio from TV cards based on

I couldn't find any usage of inb/outb & friends on it:

	$ grep -E '(inb|outb|inw|outw|inl|outl)\b' ./sound/pci/bt87x.c

It uses, instead, readl/writel:

	static inline u32 snd_bt87x_readl(struct snd_bt87x *chip, u32 reg)
	{
	        return readl(chip->mmio + reg);
	}

	static inline void snd_bt87x_writel(struct snd_bt87x *chip, u32 reg, u32 value)
	{
	        writel(value, chip->mmio + reg);
	}

I failed to see what makes it different from VIDEO_BT848 and
DVB_BT8XX drivers. They all support exactly the same chipset:
Brooktree/Conexant BT8xx. On those devices, depending on the exact
model, up to three separate interfaces are provided, each one with
its own Kconfig var:

	- audio I/O (SND_BT87X);
	- video I/O (VIDEO_BT848);
	- MPEG-TS I/O (DVB_BT8XX).

Thanks,
Mauro
