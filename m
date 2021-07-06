Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99713BC9B1
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 12:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhGFK14 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Jul 2021 06:27:56 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:36467 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbhGFK1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 06:27:47 -0400
Received: by mail-lj1-f176.google.com with SMTP id a6so28460117ljq.3;
        Tue, 06 Jul 2021 03:25:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=QFd4cSgjRlNs6aAHRKVeotkaIh4ASKGZEfmqK4rh/rE=;
        b=oXNQLlxPzgnBZq3/xXAjJVT8XHqb1xY+dFLjzkWT1y3jEvKSxAghVIBui0SS6a3/bI
         JZZLaxGwN5E0qqqu3F52dhi5N1H5vrtZOP9aHdPX2DMetNZEmfn/IXnmKCMENmeqvxVw
         YgqdPrslv4mBqobeMwFnhkXmgD9xA9GBYU3Fs4ti/7H+9K5rHk6b7wA5EL/3Ouwlnwk+
         OkgxiKe36VdwMjh2xWkkZ5iJmluttilYozIYYMklu0Q7vPWsivWcw82Vwqwrbsr2yiQ3
         ZFATje5BAlbmuOoVIXYgGg0L4YauJEuN/pKobTxpqMGmYsEBtySNusGMe8oq7Vr7ZAZa
         10Qg==
X-Gm-Message-State: AOAM533P/ev3NzipRRn0DyIqrWWGF6yde0bCVt/BvIPLPwAijrmAcnl0
        scuAgyK2Nte2lT2YQyrivglSSu4qYMlF7pRa
X-Google-Smtp-Source: ABdhPJy8AmWLrKOXx+y7IJatZbIV3rjFDuY7qybYol0qx3/u1ge1N8+PGGzIxdH3J02UxjGmQ6EQJA==
X-Received: by 2002:a2e:92cd:: with SMTP id k13mr14417894ljh.282.1625567103983;
        Tue, 06 Jul 2021 03:25:03 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id v5sm156756lfr.299.2021.07.06.03.25.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 03:25:03 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id a18so2239235ljk.6;
        Tue, 06 Jul 2021 03:25:03 -0700 (PDT)
X-Received: by 2002:a2e:1409:: with SMTP id u9mr9759960ljd.94.1625567102788;
 Tue, 06 Jul 2021 03:25:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210706095037.1425211-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20210706095037.1425211-1-u.kleine-koenig@pengutronix.de>
Reply-To: wens@csie.org
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Tue, 6 Jul 2021 18:24:51 +0800
X-Gmail-Original-Message-ID: <CAGb2v65WCwDkCzf26urwM91nEWGPAzMHSMFX73WQsFQoWhr8JA@mail.gmail.com>
Message-ID: <CAGb2v65WCwDkCzf26urwM91nEWGPAzMHSMFX73WQsFQoWhr8JA@mail.gmail.com>
Subject: Re: [PATCH] bus: Make remove callback return void
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
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
        Mathieu Poirier <mathieu.poirier@linaro.org>,
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
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-sunxi@lists.linux.dev, linux-cxl@vger.kernel.org,
        nvdimm@lists.linux.dev,
        "open list:DMA GENERIC OFFLOAD ENGINE SUBSYSTEM" 
        <dmaengine@vger.kernel.org>, linux1394-devel@lists.sourceforge.net,
        linux-fpga@vger.kernel.org, linux-input@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-i3c@lists.infradead.org,
        industrypack-devel@lists.sourceforge.net,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-ntb@googlegroups.com,
        PCI <linux-pci@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Linux-ALSA <alsa-devel@alsa-project.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-spi@vger.kernel.org, linux-staging@lists.linux.dev,
        greybus-dev@lists.linaro.org, target-devel@vger.kernel.org,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 6, 2021 at 5:54 PM Uwe Kleine-König
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
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
>
> this patch depends on "PCI: endpoint: Make struct pci_epf_driver::remove
> return void" that is not yet applied, see
> https://lore.kernel.org/r/20210223090757.57604-1-u.kleine-koenig@pengutronix.de.
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

>  drivers/bus/sunxi-rsb.c                   | 4 +---

Acked-by: Chen-Yu Tsai <wens@csie.org>
