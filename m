Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840D23BD9A5
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 17:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhGFPOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 11:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbhGFPOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 11:14:17 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAA1C061787
        for <netdev@vger.kernel.org>; Tue,  6 Jul 2021 08:11:36 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id g3so21076644ilj.7
        for <netdev@vger.kernel.org>; Tue, 06 Jul 2021 08:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4MFz8ETd/nmuIWZiubiifP+Omq2X9iSE9tCmj3gucYM=;
        b=IvCXivhuxpkQcwCSP/v/Rrn0oejjH/xBgjRtfoGhDm7lPAT9ogutmMgacy+clPyi90
         DRK6HgR8AmsyVM4QORABjf/IAyGQ3UrkgNOTqIRMXsHteuk6/x/Br3dCjgnqoJCe77/0
         NoZ6+4GEFW/mdLd6ihS8LHap9sTax8kG5BzSjYrBjsLKheGiGE55U68yC8yRpvGR3lrH
         i1lwKI80NFV0bQ+s0xhkaB3n4XHhOaW+jqS4RzYr17yLCz7jyCyj2zJOvQd/bsO7dMy8
         2ctnoUx7hTSh3dWCQ/T9gwlXwnhJ8TT3KyPZF8lHiLfnzYjBh4g93fOsXwM2kjJbuutz
         CEWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4MFz8ETd/nmuIWZiubiifP+Omq2X9iSE9tCmj3gucYM=;
        b=qpYR1vVHPt977v7nieabDsyJeftpFVfQuSgOgMJB49bH2p2/GpJKov1s+uSayPNjty
         mFS6ECF7uaghrmxkISDNFfkxoxDqZJVxt0doRKRo2/w29hA+ruGjBi3MKrSxYN7AyQ5t
         yunvQoB7K70l1uDEEXrCtl+UH8RN4Wu/j3CDjkfDSLWq8xFGhfFePOwym9HkxelouUV5
         iizRQDSYcRqSOY5fREHFbHxbqcAzXLF7CkiY/olCDMQYnx4uY4GNl99JY3/XAwro8+Ja
         Qb7JBuaRmtYw8yWMfDMdcX1GuGHe1UEHdrMV/ozOKjb07PKDybBvAk2H7qvuY37dSZ78
         NF3Q==
X-Gm-Message-State: AOAM5328WCJyp9aNBJelo7ensjcTVJjCA/ahuEZn5NuvXb7qgDkQqnhf
        fAXzkBSwKg8eGTZNpl4XJSmhrx+VUlBF4SRIt9ASQg==
X-Google-Smtp-Source: ABdhPJzdclmD8PsHwW9RgRKWE0tJHszXQy4UssslzUqRBaLI9w/Jj1BdJnRyjKvoHgub8buDAUaWux7OCTROnp7miaQ=
X-Received: by 2002:a05:6e02:1a0f:: with SMTP id s15mr14885840ild.58.1625584295743;
 Tue, 06 Jul 2021 08:11:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210706095037.1425211-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20210706095037.1425211-1-u.kleine-koenig@pengutronix.de>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Tue, 6 Jul 2021 09:11:24 -0600
Message-ID: <CANLsYkz_k3rBETkFWd9mm+Lgfcyp=YgiAM8rq8DaqaOcSofEkA@mail.gmail.com>
Subject: Re: [PATCH] bus: Make remove callback return void
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        Geoff Levand <geoff@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Wu Hao <hao.wu@intel.com>, Tom Rix <trix@redhat.com>,
        Moritz Fischer <mdf@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Johannes Thumshirn <morbidrsa@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jon Mason <jdmason@kudzu.us>, Allen Hubbe <allenbh@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thorsten Scherer <t.scherer@eckelmann.de>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>, Michael Buesch <m@bues.ch>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Martyn Welch <martyn@welchs.me.uk>,
        Manohar Vanga <manohar.vanga@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Marc Zyngier <maz@kernel.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Samuel Holland <samuel@sholland.org>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joey Pabalan <jpabalanb@gmail.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Frank Li <lznuaa@gmail.com>,
        Mike Christie <michael.christie@oracle.com>,
        Bodo Stroesser <bostroesser@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        SeongJae Park <sjpark@amazon.de>,
        Julien Grall <jgrall@amazon.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-sunxi@lists.linux.dev,
        linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
        dmaengine@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-fpga@vger.kernel.org, linux-input@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-i3c@lists.infradead.org,
        industrypack-devel@lists.sourceforge.net,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-ntb@googlegroups.com,
        linux-pci@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc <linux-remoteproc@vger.kernel.org>,
        linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-spi@vger.kernel.org, linux-staging@lists.linux.dev,
        greybus-dev@lists.linaro.org, target-devel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Jul 2021 at 03:56, Uwe Kleine-K=C3=B6nig
<u.kleine-koenig@pengutronix.de> wrote:
>
> The driver core ignores the return value of this callback because there
> is only little it can do when a device disappears.
>
> This is the final bit of a long lasting cleanup quest where several
> buses were converted to also return void from their remove callback.
> Additionally some resource leaks were fixed that were caused by drivers
> returning an error code in the expectation that the driver won't go
> away.
>
> With struct bus_type::remove returning void it's prevented that newly
> implemented buses return an ignored error code and so don't anticipate
> wrong expectations for driver authors.
>
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
>
> this patch depends on "PCI: endpoint: Make struct pci_epf_driver::remove
> return void" that is not yet applied, see
> https://lore.kernel.org/r/20210223090757.57604-1-u.kleine-koenig@pengutro=
nix.de.
>
> I tested it using allmodconfig on amd64 and arm, but I wouldn't be
> surprised if I still missed to convert a driver. So it would be great to
> get this into next early after the merge window closes.
>
> I send this mail to all people that get_maintainer.pl emits for this
> patch. I wonder how many recipents will refuse this mail because of the
> long Cc: list :-)
>
> Best regards
> Uwe
>
>  arch/arm/common/locomo.c                  | 3 +--
>  arch/arm/common/sa1111.c                  | 4 +---
>  arch/arm/mach-rpc/ecard.c                 | 4 +---
>  arch/mips/sgi-ip22/ip22-gio.c             | 3 +--
>  arch/parisc/kernel/drivers.c              | 5 ++---
>  arch/powerpc/platforms/ps3/system-bus.c   | 3 +--
>  arch/powerpc/platforms/pseries/ibmebus.c  | 3 +--
>  arch/powerpc/platforms/pseries/vio.c      | 3 +--
>  drivers/acpi/bus.c                        | 3 +--
>  drivers/amba/bus.c                        | 4 +---
>  drivers/base/auxiliary.c                  | 4 +---
>  drivers/base/isa.c                        | 4 +---
>  drivers/base/platform.c                   | 4 +---
>  drivers/bcma/main.c                       | 6 ++----
>  drivers/bus/sunxi-rsb.c                   | 4 +---
>  drivers/cxl/core.c                        | 3 +--
>  drivers/dax/bus.c                         | 4 +---
>  drivers/dma/idxd/sysfs.c                  | 4 +---
>  drivers/firewire/core-device.c            | 4 +---
>  drivers/firmware/arm_scmi/bus.c           | 4 +---
>  drivers/firmware/google/coreboot_table.c  | 4 +---
>  drivers/fpga/dfl.c                        | 4 +---
>  drivers/hid/hid-core.c                    | 4 +---
>  drivers/hid/intel-ish-hid/ishtp/bus.c     | 4 +---
>  drivers/hv/vmbus_drv.c                    | 5 +----
>  drivers/hwtracing/intel_th/core.c         | 4 +---
>  drivers/i2c/i2c-core-base.c               | 5 +----
>  drivers/i3c/master.c                      | 4 +---
>  drivers/input/gameport/gameport.c         | 3 +--
>  drivers/input/serio/serio.c               | 3 +--
>  drivers/ipack/ipack.c                     | 4 +---
>  drivers/macintosh/macio_asic.c            | 4 +---
>  drivers/mcb/mcb-core.c                    | 4 +---
>  drivers/media/pci/bt8xx/bttv-gpio.c       | 3 +--
>  drivers/memstick/core/memstick.c          | 3 +--
>  drivers/mfd/mcp-core.c                    | 3 +--
>  drivers/misc/mei/bus.c                    | 4 +---
>  drivers/misc/tifm_core.c                  | 3 +--
>  drivers/mmc/core/bus.c                    | 4 +---
>  drivers/mmc/core/sdio_bus.c               | 4 +---
>  drivers/net/netdevsim/bus.c               | 3 +--
>  drivers/ntb/core.c                        | 4 +---
>  drivers/ntb/ntb_transport.c               | 4 +---
>  drivers/nvdimm/bus.c                      | 3 +--
>  drivers/pci/endpoint/pci-epf-core.c       | 4 +---
>  drivers/pci/pci-driver.c                  | 3 +--
>  drivers/pcmcia/ds.c                       | 4 +---
>  drivers/platform/surface/aggregator/bus.c | 4 +---
>  drivers/platform/x86/wmi.c                | 4 +---
>  drivers/pnp/driver.c                      | 3 +--
>  drivers/rapidio/rio-driver.c              | 4 +---
>  drivers/rpmsg/rpmsg_core.c                | 4 +---

Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
