Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2BD3BDDA2
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 20:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhGFSyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 14:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbhGFSyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 14:54:03 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60058C0613DF
        for <netdev@vger.kernel.org>; Tue,  6 Jul 2021 11:51:24 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 17so20108798pfz.4
        for <netdev@vger.kernel.org>; Tue, 06 Jul 2021 11:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CUB/wg8JoGmq3NIMuzXfvTu1/LaQA3sJa9mgD0RKZNM=;
        b=NCdUcCEYBEoF+OVX9fy25TDeiKDiyu7MS8rvWeBmnwWDnPpc5+QhpNeuAg5+M01lgv
         DRH8QNEoIXVvsAW/9oBoS2NReA9bsV6Hj2cFB9jLLFtRzn+HzyElennnBW9tDomDrZF/
         XkbSLC4duPiBx+pb77e5uH0fYLMkjK217pwgB1wYqGKrM1h34OqVCa5M9I67oCpiuU+f
         pbgZ3PKaRiScHxRehdZaD+636T/YBbbzOrYq9ouzPlMVA0x6yucHaPT19ze0f0ZjxqqZ
         KMetsaE3O5ReiI2mpGtW6/n68aQ7RKzzGVSyyRz/qTwzg+JiHPzeut5+sQawTaXHwNB/
         HKBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CUB/wg8JoGmq3NIMuzXfvTu1/LaQA3sJa9mgD0RKZNM=;
        b=QyT1TGIMCsIPOsHTDbQdZXZ5VH/o+GyH6aEOP1pip1l2ggvdRZRFW1tdd3tP/TuzyY
         BZ41/qQScCradSEdnEQdXWF6q0UjFYAR1GaKpnthNsYDUhNOxdDcPFAohozQgvPtLdPp
         Akhckj/7q9Tm9W2y9/6Waxx79vP8xmNFK98IX9mVrQWuMzlmH8fhy4oBAlG34uK8bWos
         h2yOyNSSqsNVlAJE8DLdjX3ahFFV6nZpAAKuFzWNMQJ1oo0g+rYAnPI4yreN7KUUZXWR
         arwvrhtUgf+2VcPSQ1XlWfDgtwri7YVfeKNBvVY74ZO99PkhIcW6IbawxxNquZHfz4TA
         PTvA==
X-Gm-Message-State: AOAM530aqM5c3Nrga6krzaAia3SkYOxl46kbGRs21zcM5ITxoB6dlyQr
        8wtKv3M1VAHAb67sWGmvZw9I4YuXdnFZa9T99STcYw==
X-Google-Smtp-Source: ABdhPJyL0D13WbWlA6qnw/Xmlwa19pDI+XNQ21Npie/wgUkDgmHM1zT9YORdF5DHiOOYSSe1zuHfWr+DfQo+lHkX354=
X-Received: by 2002:a63:4c3:: with SMTP id 186mr12014592pge.240.1625597483385;
 Tue, 06 Jul 2021 11:51:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210706154803.1631813-1-u.kleine-koenig@pengutronix.de> <20210706154803.1631813-5-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20210706154803.1631813-5-u.kleine-koenig@pengutronix.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 6 Jul 2021 11:51:12 -0700
Message-ID: <CAPcyv4gxjV7Xj8AN6aCkSLSi=yT6GdcAyigK6Au3mZQ1idBxJg@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] bus: Make remove callback return void
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel@pengutronix.de, Cornelia Huck <cohuck@redhat.com>,
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
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-sunxi@lists.linux.dev, linux-cxl@vger.kernel.org,
        nvdimm@lists.linux.dev, dmaengine@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux-fpga@vger.kernel.org,
        linux-input@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-i3c@lists.infradead.org,
        industrypack-devel@lists.sourceforge.net,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-ntb@googlegroups.com,
        linux-pci@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-scsi@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-arm-msm@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-staging@lists.linux.dev,
        greybus-dev@lists.linaro.org, target-devel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Johannes Thumshirn <jth@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 6, 2021 at 8:51 AM Uwe Kleine-K=C3=B6nig
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

>  drivers/cxl/core.c                        | 3 +--
>  drivers/dax/bus.c                         | 4 +---
>  drivers/nvdimm/bus.c                      | 3 +--

For CXL, DAX, and NVDIMM

Acked-by: Dan Williams <dan.j.williams@intel.com>
