Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E90548DEF9
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 21:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbiAMUbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 15:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234226AbiAMUbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 15:31:40 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4799AC061753
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 12:31:39 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id q25so27489052edb.2
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 12:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tMU7ATelbQO7f9KBaWTTaHdYIT+hN6tjXW5Vrd1NXNw=;
        b=I8PuQGAdDFsrGREu2v8uAPz2+yeEfKPJI1R2NLafiot8aN608ShnCd2qbFqf9eU0I2
         wCIf4epPzW21N5LCeQyIfjNSgtXjLySDqmhM8X675+uB7airRt4XV/WQqB1UNIpoFaN1
         xVFKann6iTrVX7sAfY4CSP7NGBnUPg2TStNz19JUr1Uen19MRIjOEtVDQp4UdAz5ibeY
         cRNUFgiqGZeX/oqC7vemnB+VvVlo0Ong7amrww+Xl7C7nH5JUED4Diw+GydRmpKdgcp2
         EWlJ2S/n39VrpjmG7h9gHIZ3Fw27UUFY9hcxrGFWccXqOu7vbVG0QyxHfowSZIdWVpN2
         3i0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tMU7ATelbQO7f9KBaWTTaHdYIT+hN6tjXW5Vrd1NXNw=;
        b=J2ESCUur2KPb3H2qgxWKeWnAs5JzyLXAvYU+zYQABB7h2m61dnGuLgdk0nB1TEyVww
         oy7eEYXrUWoDdl+b9Hd8f4ZYOjQLghVNeJcg+dJxyWsvzgb2bIAChWbFKo4liqBlT+eE
         Y0juQAHoTGqPcHzwi2T5jx9p/J+Yi/VXWe0QQIFU3333R5Y+9GA3TL7ECdfVHDwv225H
         u3/PbH2VphnIPFAmyGVP0lQOHlSRgZPF2wYVKMvZSy3j86ML4ThvFax5/93ALy8SOiyi
         gmojR5yeJr9lJOWkqvJCKEI8gT4jJ/mKrHCG7unwDGtD2rXniEc399yDdcL8ZCkCs9wk
         7EKw==
X-Gm-Message-State: AOAM532KVJ20dcuYRYK6TY0Vwt2yey/h0vdg1cGOn7kD30Qoesy0FsWb
        yf/unJ7oT7LSHj/YpVVahlYCUPsYPUwvSX5e3KsYUw==
X-Google-Smtp-Source: ABdhPJwdj1Lqa4sGgL48glUazbCc/s/3zUby++2vwRwvsFmwk0pUdJ3t1YO3ApDYPjMM0YZ3WpTKKiNBBF3sYcib4VU=
X-Received: by 2002:a17:906:d542:: with SMTP id cr2mr4870852ejc.720.1642105896445;
 Thu, 13 Jan 2022 12:31:36 -0800 (PST)
MIME-Version: 1.0
References: <20220110195449.12448-2-s.shtylyov@omp.ru> <20220110201014.mtajyrfcfznfhyqm@pengutronix.de>
 <YdyilpjC6rtz6toJ@lunn.ch> <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de> <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de> <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <20220113110831.wvwbm75hbfysbn2d@pengutronix.de> <YeA7CjOyJFkpuhz/@sirena.org.uk>
 <20220113194358.xnnbhsoyetihterb@pengutronix.de>
In-Reply-To: <20220113194358.xnnbhsoyetihterb@pengutronix.de>
From:   Guenter Roeck <groeck@google.com>
Date:   Thu, 13 Jan 2022 12:31:24 -0800
Message-ID: <CABXOdTffNQL6tgB+YxJZpK0yMnacS0C0VLKwvQPes+NyEwBjuQ@mail.gmail.com>
Subject: Re: [PATCH] driver core: platform: Rename platform_get_irq_optional()
 to platform_get_irq_silent()
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Mark Brown <broonie@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        KVM list <kvm@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org, Jiri Slaby <jirislaby@kernel.org>,
        openipmi-developer@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        Saravanan Sekar <sravanhome@gmail.com>,
        Corey Minyard <minyard@acm.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Sebastian Reichel <sre@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        platform-driver-x86@vger.kernel.org,
        Benson Leung <bleung@chromium.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-edac@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 11:44 AM Uwe Kleine-K=C3=B6nig
<u.kleine-koenig@pengutronix.de> wrote:
>
> The subsystems regulator, clk and gpio have the concept of a dummy
> resource. For regulator, clk and gpio there is a semantic difference
> between the regular _get() function and the _get_optional() variant.
> (One might return the dummy resource, the other won't. Unfortunately
> which one implements which isn't the same for these three.) The
> difference between platform_get_irq() and platform_get_irq_optional() is
> only that the former might emit an error message and the later won't.
>
> To prevent people's expectations that there is a semantic difference
> between these too, rename platform_get_irq_optional() to
> platform_get_irq_silent() to make the actual difference more obvious.
>
> The #define for the old name can and should be removed once all patches
> currently in flux still relying on platform_get_irq_optional() are
> fixed.
>
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>


For watchdog:

Acked-by: Guenter Roeck <groeck@chromium.org>

>
> ---
> Hello,
>
> On Thu, Jan 13, 2022 at 02:45:30PM +0000, Mark Brown wrote:
> > On Thu, Jan 13, 2022 at 12:08:31PM +0100, Uwe Kleine-K=C3=B6nig wrote:
> >
> > > This is all very unfortunate. In my eyes b) is the most sensible
> > > sense, but the past showed that we don't agree here. (The most annoyi=
ng
> > > part of regulator_get is the warning that is emitted that regularily
> > > makes customers ask what happens here and if this is fixable.)
> >
> > Fortunately it can be fixed, and it's safer to clearly specify things.
> > The prints are there because when the description is wrong enough to
> > cause things to blow up we can fail to boot or run messily and
> > forgetting to describe some supplies (or typoing so they haven't done
> > that) and people were having a hard time figuring out what might've
> > happened.
>
> Yes, that's right. I sent a patch for such a warning in 2019 and pinged
> occationally. Still waiting for it to be merged :-\
> (https://lore.kernel.org/r/20190625100412.11815-1-u.kleine-koenig@pengutr=
onix.de)
>
> > > I think at least c) is easy to resolve because
> > > platform_get_irq_optional() isn't that old yet and mechanically
> > > replacing it by platform_get_irq_silent() should be easy and safe.
> > > And this is orthogonal to the discussion if -ENOXIO is a sensible ret=
urn
> > > value and if it's as easy as it could be to work with errors on irq
> > > lookups.
> >
> > It'd certainly be good to name anything that doesn't correspond to one
> > of the existing semantics for the API (!) something different rather
> > than adding yet another potentially overloaded meaning.
>
> It seems we're (at least) three who agree about this. Here is a patch
> fixing the name.
>
> Best regards
> Uwe
>
>  drivers/base/platform.c                           | 12 ++++++------
>  drivers/char/ipmi/bt-bmc.c                        |  2 +-
>  drivers/char/ipmi/ipmi_si_platform.c              |  4 ++--
>  drivers/char/tpm/tpm_tis.c                        |  2 +-
>  drivers/counter/interrupt-cnt.c                   |  2 +-
>  drivers/cpufreq/qcom-cpufreq-hw.c                 |  2 +-
>  drivers/dma/mmp_pdma.c                            |  2 +-
>  drivers/edac/xgene_edac.c                         |  2 +-
>  drivers/gpio/gpio-altera.c                        |  2 +-
>  drivers/gpio/gpio-dwapb.c                         |  2 +-
>  drivers/gpio/gpio-mvebu.c                         |  2 +-
>  drivers/gpio/gpio-realtek-otto.c                  |  2 +-
>  drivers/gpio/gpio-tqmx86.c                        |  2 +-
>  drivers/gpio/gpio-xilinx.c                        |  2 +-
>  drivers/gpu/drm/v3d/v3d_irq.c                     |  2 +-
>  drivers/i2c/busses/i2c-brcmstb.c                  |  2 +-
>  drivers/i2c/busses/i2c-ocores.c                   |  2 +-
>  drivers/i2c/busses/i2c-pca-platform.c             |  2 +-
>  drivers/irqchip/irq-renesas-intc-irqpin.c         |  2 +-
>  drivers/irqchip/irq-renesas-irqc.c                |  2 +-
>  drivers/mfd/intel_pmc_bxt.c                       |  2 +-
>  drivers/mmc/host/sh_mmcif.c                       |  2 +-
>  drivers/mtd/nand/raw/brcmnand/brcmnand.c          |  2 +-
>  drivers/mtd/nand/raw/renesas-nand-controller.c    |  2 +-
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c    |  2 +-
>  drivers/net/ethernet/davicom/dm9000.c             |  2 +-
>  drivers/net/ethernet/freescale/fec_ptp.c          |  2 +-
>  drivers/net/ethernet/marvell/mvmdio.c             |  2 +-
>  drivers/net/ethernet/ti/davinci_emac.c            |  2 +-
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c |  4 ++--
>  drivers/perf/arm_smmuv3_pmu.c                     |  2 +-
>  drivers/phy/renesas/phy-rcar-gen3-usb2.c          |  2 +-
>  drivers/pinctrl/bcm/pinctrl-iproc-gpio.c          |  2 +-
>  drivers/pinctrl/intel/pinctrl-baytrail.c          |  2 +-
>  drivers/pinctrl/intel/pinctrl-lynxpoint.c         |  2 +-
>  drivers/pinctrl/pinctrl-keembay.c                 |  2 +-
>  drivers/pinctrl/samsung/pinctrl-samsung.c         |  2 +-
>  drivers/platform/chrome/cros_ec_lpc.c             |  2 +-
>  drivers/platform/x86/hp_accel.c                   |  2 +-
>  drivers/platform/x86/intel/punit_ipc.c            |  2 +-
>  drivers/platform/x86/intel_scu_pltdrv.c           |  2 +-
>  drivers/power/supply/mp2629_charger.c             |  2 +-
>  drivers/rtc/rtc-m48t59.c                          |  2 +-
>  drivers/spi/spi-hisi-sfc-v3xx.c                   |  2 +-
>  drivers/spi/spi-mtk-nor.c                         |  2 +-
>  drivers/thermal/rcar_gen3_thermal.c               |  2 +-
>  drivers/tty/serial/8250/8250_mtk.c                |  2 +-
>  drivers/tty/serial/altera_jtaguart.c              |  2 +-
>  drivers/tty/serial/altera_uart.c                  |  2 +-
>  drivers/tty/serial/imx.c                          |  4 ++--
>  drivers/tty/serial/qcom_geni_serial.c             |  2 +-
>  drivers/tty/serial/sh-sci.c                       |  2 +-
>  drivers/uio/uio_pdrv_genirq.c                     |  2 +-
>  drivers/usb/phy/phy-tegra-usb.c                   |  2 +-
>  drivers/vfio/platform/vfio_platform.c             |  2 +-
>  drivers/watchdog/dw_wdt.c                         |  2 +-
>  drivers/watchdog/orion_wdt.c                      |  4 ++--
>  drivers/watchdog/qcom-wdt.c                       |  2 +-
>  include/linux/platform_device.h                   |  9 ++++++++-
>  sound/soc/dwc/dwc-i2s.c                           |  2 +-
>  sound/soc/intel/keembay/kmb_platform.c            |  2 +-
>  61 files changed, 77 insertions(+), 70 deletions(-)
>
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 6cb04ac48bf0..acb9962b9889 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -149,7 +149,7 @@ EXPORT_SYMBOL_GPL(devm_platform_ioremap_resource_byna=
me);
>  #endif /* CONFIG_HAS_IOMEM */
>
>  /**
> - * platform_get_irq_optional - get an optional IRQ for a device
> + * platform_get_irq_silent - get an optional IRQ for a device
>   * @dev: platform device
>   * @num: IRQ number index
>   *
> @@ -160,13 +160,13 @@ EXPORT_SYMBOL_GPL(devm_platform_ioremap_resource_by=
name);
>   *
>   * For example::
>   *
> - *             int irq =3D platform_get_irq_optional(pdev, 0);
> + *             int irq =3D platform_get_irq_silent(pdev, 0);
>   *             if (irq < 0)
>   *                     return irq;
>   *
>   * Return: non-zero IRQ number on success, negative error number on fail=
ure.
>   */
> -int platform_get_irq_optional(struct platform_device *dev, unsigned int =
num)
> +int platform_get_irq_silent(struct platform_device *dev, unsigned int nu=
m)
>  {
>         int ret;
>  #ifdef CONFIG_SPARC
> @@ -234,7 +234,7 @@ int platform_get_irq_optional(struct platform_device =
*dev, unsigned int num)
>         WARN(ret =3D=3D 0, "0 is an invalid IRQ number\n");
>         return ret;
>  }
> -EXPORT_SYMBOL_GPL(platform_get_irq_optional);
> +EXPORT_SYMBOL_GPL(platform_get_irq_silent);
>
>  /**
>   * platform_get_irq - get an IRQ for a device
> @@ -257,7 +257,7 @@ int platform_get_irq(struct platform_device *dev, uns=
igned int num)
>  {
>         int ret;
>
> -       ret =3D platform_get_irq_optional(dev, num);
> +       ret =3D platform_get_irq_silent(dev, num);
>         if (ret < 0)
>                 return dev_err_probe(&dev->dev, ret,
>                                      "IRQ index %u not found\n", num);
> @@ -276,7 +276,7 @@ int platform_irq_count(struct platform_device *dev)
>  {
>         int ret, nr =3D 0;
>
> -       while ((ret =3D platform_get_irq_optional(dev, nr)) >=3D 0)
> +       while ((ret =3D platform_get_irq_silent(dev, nr)) >=3D 0)
>                 nr++;
>
>         if (ret =3D=3D -EPROBE_DEFER)
> diff --git a/drivers/char/ipmi/bt-bmc.c b/drivers/char/ipmi/bt-bmc.c
> index 7450904e330a..73bdbc59c9d0 100644
> --- a/drivers/char/ipmi/bt-bmc.c
> +++ b/drivers/char/ipmi/bt-bmc.c
> @@ -379,7 +379,7 @@ static int bt_bmc_config_irq(struct bt_bmc *bt_bmc,
>         int rc;
>         u32 reg;
>
> -       bt_bmc->irq =3D platform_get_irq_optional(pdev, 0);
> +       bt_bmc->irq =3D platform_get_irq_silent(pdev, 0);
>         if (bt_bmc->irq < 0)
>                 return bt_bmc->irq;
>
> diff --git a/drivers/char/ipmi/ipmi_si_platform.c b/drivers/char/ipmi/ipm=
i_si_platform.c
> index 505cc978c97a..4c666eed24d9 100644
> --- a/drivers/char/ipmi/ipmi_si_platform.c
> +++ b/drivers/char/ipmi/ipmi_si_platform.c
> @@ -192,7 +192,7 @@ static int platform_ipmi_probe(struct platform_device=
 *pdev)
>         else
>                 io.slave_addr =3D slave_addr;
>
> -       io.irq =3D platform_get_irq_optional(pdev, 0);
> +       io.irq =3D platform_get_irq_silent(pdev, 0);
>         if (io.irq > 0)
>                 io.irq_setup =3D ipmi_std_irq_setup;
>         else
> @@ -368,7 +368,7 @@ static int acpi_ipmi_probe(struct platform_device *pd=
ev)
>                 io.irq =3D tmp;
>                 io.irq_setup =3D acpi_gpe_irq_setup;
>         } else {
> -               int irq =3D platform_get_irq_optional(pdev, 0);
> +               int irq =3D platform_get_irq_silent(pdev, 0);
>
>                 if (irq > 0) {
>                         io.irq =3D irq;
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index d3f2e5364c27..3e6785ad62f2 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -318,7 +318,7 @@ static int tpm_tis_plat_probe(struct platform_device =
*pdev)
>         }
>         tpm_info.res =3D *res;
>
> -       tpm_info.irq =3D platform_get_irq_optional(pdev, 0);
> +       tpm_info.irq =3D platform_get_irq_silent(pdev, 0);
>         if (tpm_info.irq <=3D 0) {
>                 if (pdev !=3D force_pdev)
>                         tpm_info.irq =3D -1;
> diff --git a/drivers/counter/interrupt-cnt.c b/drivers/counter/interrupt-=
cnt.c
> index 8514a87fcbee..65b9254e63a9 100644
> --- a/drivers/counter/interrupt-cnt.c
> +++ b/drivers/counter/interrupt-cnt.c
> @@ -155,7 +155,7 @@ static int interrupt_cnt_probe(struct platform_device=
 *pdev)
>         if (!priv)
>                 return -ENOMEM;
>
> -       priv->irq =3D platform_get_irq_optional(pdev,  0);
> +       priv->irq =3D platform_get_irq_silent(pdev,  0);
>         if (priv->irq =3D=3D -ENXIO)
>                 priv->irq =3D 0;
>         else if (priv->irq < 0)
> diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpu=
freq-hw.c
> index 05f3d7876e44..3d1fe9ba98a7 100644
> --- a/drivers/cpufreq/qcom-cpufreq-hw.c
> +++ b/drivers/cpufreq/qcom-cpufreq-hw.c
> @@ -374,7 +374,7 @@ static int qcom_cpufreq_hw_lmh_init(struct cpufreq_po=
licy *policy, int index)
>          * Look for LMh interrupt. If no interrupt line is specified /
>          * if there is an error, allow cpufreq to be enabled as usual.
>          */
> -       data->throttle_irq =3D platform_get_irq_optional(pdev, index);
> +       data->throttle_irq =3D platform_get_irq_silent(pdev, index);
>         if (data->throttle_irq =3D=3D -ENXIO)
>                 return 0;
>         if (data->throttle_irq < 0)
> diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
> index a23563cd118b..707ac21652a6 100644
> --- a/drivers/dma/mmp_pdma.c
> +++ b/drivers/dma/mmp_pdma.c
> @@ -1059,7 +1059,7 @@ static int mmp_pdma_probe(struct platform_device *o=
p)
>         pdev->dma_channels =3D dma_channels;
>
>         for (i =3D 0; i < dma_channels; i++) {
> -               if (platform_get_irq_optional(op, i) > 0)
> +               if (platform_get_irq_silent(op, i) > 0)
>                         irq_num++;
>         }
>
> diff --git a/drivers/edac/xgene_edac.c b/drivers/edac/xgene_edac.c
> index 2ccd1db5e98f..87aa537f3b72 100644
> --- a/drivers/edac/xgene_edac.c
> +++ b/drivers/edac/xgene_edac.c
> @@ -1916,7 +1916,7 @@ static int xgene_edac_probe(struct platform_device =
*pdev)
>                 int i;
>
>                 for (i =3D 0; i < 3; i++) {
> -                       irq =3D platform_get_irq_optional(pdev, i);
> +                       irq =3D platform_get_irq_silent(pdev, i);
>                         if (irq < 0) {
>                                 dev_err(&pdev->dev, "No IRQ resource\n");
>                                 rc =3D -EINVAL;
> diff --git a/drivers/gpio/gpio-altera.c b/drivers/gpio/gpio-altera.c
> index b59fae993626..a1a7d8c0ef13 100644
> --- a/drivers/gpio/gpio-altera.c
> +++ b/drivers/gpio/gpio-altera.c
> @@ -266,7 +266,7 @@ static int altera_gpio_probe(struct platform_device *=
pdev)
>         altera_gc->mmchip.gc.owner              =3D THIS_MODULE;
>         altera_gc->mmchip.gc.parent             =3D &pdev->dev;
>
> -       altera_gc->mapped_irq =3D platform_get_irq_optional(pdev, 0);
> +       altera_gc->mapped_irq =3D platform_get_irq_silent(pdev, 0);
>
>         if (altera_gc->mapped_irq < 0)
>                 goto skip_irq;
> diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
> index b0f3aca61974..133153a40808 100644
> --- a/drivers/gpio/gpio-dwapb.c
> +++ b/drivers/gpio/gpio-dwapb.c
> @@ -543,7 +543,7 @@ static void dwapb_get_irq(struct device *dev, struct =
fwnode_handle *fwnode,
>
>         for (j =3D 0; j < pp->ngpio; j++) {
>                 if (has_acpi_companion(dev))
> -                       irq =3D platform_get_irq_optional(to_platform_dev=
ice(dev), j);
> +                       irq =3D platform_get_irq_silent(to_platform_devic=
e(dev), j);
>                 else
>                         irq =3D fwnode_irq_get(fwnode, j);
>                 if (irq > 0)
> diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
> index 4c1f9e1091b7..eaaf6fd54d79 100644
> --- a/drivers/gpio/gpio-mvebu.c
> +++ b/drivers/gpio/gpio-mvebu.c
> @@ -1291,7 +1291,7 @@ static int mvebu_gpio_probe(struct platform_device =
*pdev)
>          * pins.
>          */
>         for (i =3D 0; i < 4; i++) {
> -               int irq =3D platform_get_irq_optional(pdev, i);
> +               int irq =3D platform_get_irq_silent(pdev, i);
>
>                 if (irq < 0)
>                         continue;
> diff --git a/drivers/gpio/gpio-realtek-otto.c b/drivers/gpio/gpio-realtek=
-otto.c
> index bd75401b549d..b945049c1a39 100644
> --- a/drivers/gpio/gpio-realtek-otto.c
> +++ b/drivers/gpio/gpio-realtek-otto.c
> @@ -289,7 +289,7 @@ static int realtek_gpio_probe(struct platform_device =
*pdev)
>         ctrl->gc.ngpio =3D ngpios;
>         ctrl->gc.owner =3D THIS_MODULE;
>
> -       irq =3D platform_get_irq_optional(pdev, 0);
> +       irq =3D platform_get_irq_silent(pdev, 0);
>         if (!(dev_flags & GPIO_INTERRUPTS_DISABLED) && irq > 0) {
>                 girq =3D &ctrl->gc.irq;
>                 girq->chip =3D &realtek_gpio_irq_chip;
> diff --git a/drivers/gpio/gpio-tqmx86.c b/drivers/gpio/gpio-tqmx86.c
> index 5b103221b58d..16afb563f813 100644
> --- a/drivers/gpio/gpio-tqmx86.c
> +++ b/drivers/gpio/gpio-tqmx86.c
> @@ -236,7 +236,7 @@ static int tqmx86_gpio_probe(struct platform_device *=
pdev)
>         struct resource *res;
>         int ret, irq;
>
> -       irq =3D platform_get_irq_optional(pdev, 0);
> +       irq =3D platform_get_irq_silent(pdev, 0);
>         if (irq < 0 && irq !=3D -ENXIO)
>                 return irq;
>
> diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
> index b6d3a57e27ed..a451bd19d501 100644
> --- a/drivers/gpio/gpio-xilinx.c
> +++ b/drivers/gpio/gpio-xilinx.c
> @@ -658,7 +658,7 @@ static int xgpio_probe(struct platform_device *pdev)
>
>         xgpio_save_regs(chip);
>
> -       chip->irq =3D platform_get_irq_optional(pdev, 0);
> +       chip->irq =3D platform_get_irq_silent(pdev, 0);
>         if (chip->irq <=3D 0)
>                 goto skip_irq;
>
> diff --git a/drivers/gpu/drm/v3d/v3d_irq.c b/drivers/gpu/drm/v3d/v3d_irq.=
c
> index e714d5318f30..8c88a1958fd4 100644
> --- a/drivers/gpu/drm/v3d/v3d_irq.c
> +++ b/drivers/gpu/drm/v3d/v3d_irq.c
> @@ -214,7 +214,7 @@ v3d_irq_init(struct v3d_dev *v3d)
>                 V3D_CORE_WRITE(core, V3D_CTL_INT_CLR, V3D_CORE_IRQS);
>         V3D_WRITE(V3D_HUB_INT_CLR, V3D_HUB_IRQS);
>
> -       irq1 =3D platform_get_irq_optional(v3d_to_pdev(v3d), 1);
> +       irq1 =3D platform_get_irq_silent(v3d_to_pdev(v3d), 1);
>         if (irq1 =3D=3D -EPROBE_DEFER)
>                 return irq1;
>         if (irq1 > 0) {
> diff --git a/drivers/i2c/busses/i2c-brcmstb.c b/drivers/i2c/busses/i2c-br=
cmstb.c
> index 490ee3962645..0e53d149a207 100644
> --- a/drivers/i2c/busses/i2c-brcmstb.c
> +++ b/drivers/i2c/busses/i2c-brcmstb.c
> @@ -646,7 +646,7 @@ static int brcmstb_i2c_probe(struct platform_device *=
pdev)
>                 int_name =3D NULL;
>
>         /* Get the interrupt number */
> -       dev->irq =3D platform_get_irq_optional(pdev, 0);
> +       dev->irq =3D platform_get_irq_silent(pdev, 0);
>
>         /* disable the bsc interrupt line */
>         brcmstb_i2c_enable_disable_irq(dev, INT_DISABLE);
> diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-oco=
res.c
> index a0af027db04c..c6d21b833964 100644
> --- a/drivers/i2c/busses/i2c-ocores.c
> +++ b/drivers/i2c/busses/i2c-ocores.c
> @@ -682,7 +682,7 @@ static int ocores_i2c_probe(struct platform_device *p=
dev)
>
>         init_waitqueue_head(&i2c->wait);
>
> -       irq =3D platform_get_irq_optional(pdev, 0);
> +       irq =3D platform_get_irq_silent(pdev, 0);
>         /*
>          * Since the SoC does have an interrupt, its DT has an interrupt
>          * property - But this should be bypassed as the IRQ logic in thi=
s
> diff --git a/drivers/i2c/busses/i2c-pca-platform.c b/drivers/i2c/busses/i=
2c-pca-platform.c
> index 86d4f75ef8d3..783b474097f7 100644
> --- a/drivers/i2c/busses/i2c-pca-platform.c
> +++ b/drivers/i2c/busses/i2c-pca-platform.c
> @@ -138,7 +138,7 @@ static int i2c_pca_pf_probe(struct platform_device *p=
dev)
>         int ret =3D 0;
>         int irq;
>
> -       irq =3D platform_get_irq_optional(pdev, 0);
> +       irq =3D platform_get_irq_silent(pdev, 0);
>         /* If irq is 0, we do polling. */
>         if (irq < 0)
>                 irq =3D 0;
> diff --git a/drivers/irqchip/irq-renesas-intc-irqpin.c b/drivers/irqchip/=
irq-renesas-intc-irqpin.c
> index 37f9a4499fdb..934669b20d0d 100644
> --- a/drivers/irqchip/irq-renesas-intc-irqpin.c
> +++ b/drivers/irqchip/irq-renesas-intc-irqpin.c
> @@ -417,7 +417,7 @@ static int intc_irqpin_probe(struct platform_device *=
pdev)
>
>         /* allow any number of IRQs between 1 and INTC_IRQPIN_MAX */
>         for (k =3D 0; k < INTC_IRQPIN_MAX; k++) {
> -               ret =3D platform_get_irq_optional(pdev, k);
> +               ret =3D platform_get_irq_silent(pdev, k);
>                 if (ret =3D=3D -ENXIO)
>                         break;
>                 if (ret < 0)
> diff --git a/drivers/irqchip/irq-renesas-irqc.c b/drivers/irqchip/irq-ren=
esas-irqc.c
> index 909325f88239..95ff42746e95 100644
> --- a/drivers/irqchip/irq-renesas-irqc.c
> +++ b/drivers/irqchip/irq-renesas-irqc.c
> @@ -141,7 +141,7 @@ static int irqc_probe(struct platform_device *pdev)
>
>         /* allow any number of IRQs between 1 and IRQC_IRQ_MAX */
>         for (k =3D 0; k < IRQC_IRQ_MAX; k++) {
> -               ret =3D platform_get_irq_optional(pdev, k);
> +               ret =3D platform_get_irq_silent(pdev, k);
>                 if (ret =3D=3D -ENXIO)
>                         break;
>                 if (ret < 0)
> diff --git a/drivers/mfd/intel_pmc_bxt.c b/drivers/mfd/intel_pmc_bxt.c
> index 9f01d38acc7f..dc58dfd87043 100644
> --- a/drivers/mfd/intel_pmc_bxt.c
> +++ b/drivers/mfd/intel_pmc_bxt.c
> @@ -309,7 +309,7 @@ static int intel_pmc_get_resources(struct platform_de=
vice *pdev,
>         struct resource *res;
>         int ret;
>
> -       scu_data->irq =3D platform_get_irq_optional(pdev, 0);
> +       scu_data->irq =3D platform_get_irq_silent(pdev, 0);
>
>         res =3D platform_get_resource(pdev, IORESOURCE_MEM,
>                                     PLAT_RESOURCE_IPC_INDEX);
> diff --git a/drivers/mmc/host/sh_mmcif.c b/drivers/mmc/host/sh_mmcif.c
> index bcc595c70a9f..aa5579520b06 100644
> --- a/drivers/mmc/host/sh_mmcif.c
> +++ b/drivers/mmc/host/sh_mmcif.c
> @@ -1396,7 +1396,7 @@ static int sh_mmcif_probe(struct platform_device *p=
dev)
>         const char *name;
>
>         irq[0] =3D platform_get_irq(pdev, 0);
> -       irq[1] =3D platform_get_irq_optional(pdev, 1);
> +       irq[1] =3D platform_get_irq_silent(pdev, 1);
>         if (irq[0] < 0)
>                 return -ENXIO;
>
> diff --git a/drivers/mtd/nand/raw/brcmnand/brcmnand.c b/drivers/mtd/nand/=
raw/brcmnand/brcmnand.c
> index f75929783b94..2aa10a1755ba 100644
> --- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
> +++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
> @@ -2955,7 +2955,7 @@ static int brcmnand_edu_setup(struct platform_devic=
e *pdev)
>                 /* initialize edu */
>                 brcmnand_edu_init(ctrl);
>
> -               ctrl->edu_irq =3D platform_get_irq_optional(pdev, 1);
> +               ctrl->edu_irq =3D platform_get_irq_silent(pdev, 1);
>                 if (ctrl->edu_irq < 0) {
>                         dev_warn(dev,
>                                  "FLASH EDU enabled, using ctlrdy irq\n")=
;
> diff --git a/drivers/mtd/nand/raw/renesas-nand-controller.c b/drivers/mtd=
/nand/raw/renesas-nand-controller.c
> index 428e08362956..c33958bda059 100644
> --- a/drivers/mtd/nand/raw/renesas-nand-controller.c
> +++ b/drivers/mtd/nand/raw/renesas-nand-controller.c
> @@ -1354,7 +1354,7 @@ static int rnandc_probe(struct platform_device *pde=
v)
>                 goto disable_hclk;
>
>         rnandc_dis_interrupts(rnandc);
> -       irq =3D platform_get_irq_optional(pdev, 0);
> +       irq =3D platform_get_irq_silent(pdev, 0);
>         if (irq =3D=3D -EPROBE_DEFER) {
>                 ret =3D irq;
>                 goto disable_eclk;
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net=
/ethernet/broadcom/genet/bcmgenet.c
> index 226f4403cfed..4cfc62a5380a 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -3989,7 +3989,7 @@ static int bcmgenet_probe(struct platform_device *p=
dev)
>                 err =3D priv->irq1;
>                 goto err;
>         }
> -       priv->wol_irq =3D platform_get_irq_optional(pdev, 2);
> +       priv->wol_irq =3D platform_get_irq_silent(pdev, 2);
>
>         priv->base =3D devm_platform_ioremap_resource(pdev, 0);
>         if (IS_ERR(priv->base)) {
> diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet=
/davicom/dm9000.c
> index 0985ab216566..43f181e13bab 100644
> --- a/drivers/net/ethernet/davicom/dm9000.c
> +++ b/drivers/net/ethernet/davicom/dm9000.c
> @@ -1508,7 +1508,7 @@ dm9000_probe(struct platform_device *pdev)
>                 goto out;
>         }
>
> -       db->irq_wake =3D platform_get_irq_optional(pdev, 1);
> +       db->irq_wake =3D platform_get_irq_silent(pdev, 1);
>         if (db->irq_wake >=3D 0) {
>                 dev_dbg(db->dev, "wakeup irq %d\n", db->irq_wake);
>
> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ether=
net/freescale/fec_ptp.c
> index af99017a5453..dc65bb1caad4 100644
> --- a/drivers/net/ethernet/freescale/fec_ptp.c
> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> @@ -612,7 +612,7 @@ void fec_ptp_init(struct platform_device *pdev, int i=
rq_idx)
>
>         irq =3D platform_get_irq_byname_optional(pdev, "pps");
>         if (irq < 0)
> -               irq =3D platform_get_irq_optional(pdev, irq_idx);
> +               irq =3D platform_get_irq_silent(pdev, irq_idx);
>         /* Failure to get an irq is not fatal,
>          * only the PTP_CLOCK_PPS clock events should stop
>          */
> diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet=
/marvell/mvmdio.c
> index ef878973b859..cdf4ff41bd66 100644
> --- a/drivers/net/ethernet/marvell/mvmdio.c
> +++ b/drivers/net/ethernet/marvell/mvmdio.c
> @@ -349,7 +349,7 @@ static int orion_mdio_probe(struct platform_device *p=
dev)
>         }
>
>
> -       dev->err_interrupt =3D platform_get_irq_optional(pdev, 0);
> +       dev->err_interrupt =3D platform_get_irq_silent(pdev, 0);
>         if (dev->err_interrupt > 0 &&
>             resource_size(r) < MVMDIO_ERR_INT_MASK + 4) {
>                 dev_err(&pdev->dev,
> diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/etherne=
t/ti/davinci_emac.c
> index 31df3267a01a..30d5a785d485 100644
> --- a/drivers/net/ethernet/ti/davinci_emac.c
> +++ b/drivers/net/ethernet/ti/davinci_emac.c
> @@ -1455,7 +1455,7 @@ static int emac_dev_open(struct net_device *ndev)
>
>         /* Request IRQ */
>         if (dev_of_node(&priv->pdev->dev)) {
> -               while ((ret =3D platform_get_irq_optional(priv->pdev, res=
_num)) !=3D -ENXIO) {
> +               while ((ret =3D platform_get_irq_silent(priv->pdev, res_n=
um)) !=3D -ENXIO) {
>                         if (ret < 0)
>                                 goto rollback;
>
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/=
net/ethernet/xilinx/xilinx_axienet_main.c
> index 23ac353b35fe..5be7e93d4087 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -1961,13 +1961,13 @@ static int axienet_probe(struct platform_device *=
pdev)
>                 lp->rx_irq =3D irq_of_parse_and_map(np, 1);
>                 lp->tx_irq =3D irq_of_parse_and_map(np, 0);
>                 of_node_put(np);
> -               lp->eth_irq =3D platform_get_irq_optional(pdev, 0);
> +               lp->eth_irq =3D platform_get_irq_silent(pdev, 0);
>         } else {
>                 /* Check for these resources directly on the Ethernet nod=
e. */
>                 lp->dma_regs =3D devm_platform_get_and_ioremap_resource(p=
dev, 1, NULL);
>                 lp->rx_irq =3D platform_get_irq(pdev, 1);
>                 lp->tx_irq =3D platform_get_irq(pdev, 0);
> -               lp->eth_irq =3D platform_get_irq_optional(pdev, 2);
> +               lp->eth_irq =3D platform_get_irq_silent(pdev, 2);
>         }
>         if (IS_ERR(lp->dma_regs)) {
>                 dev_err(&pdev->dev, "could not map DMA regs\n");
> diff --git a/drivers/perf/arm_smmuv3_pmu.c b/drivers/perf/arm_smmuv3_pmu.=
c
> index c49108a72865..c4a709470398 100644
> --- a/drivers/perf/arm_smmuv3_pmu.c
> +++ b/drivers/perf/arm_smmuv3_pmu.c
> @@ -852,7 +852,7 @@ static int smmu_pmu_probe(struct platform_device *pde=
v)
>                 smmu_pmu->reloc_base =3D smmu_pmu->reg_base;
>         }
>
> -       irq =3D platform_get_irq_optional(pdev, 0);
> +       irq =3D platform_get_irq_silent(pdev, 0);
>         if (irq > 0)
>                 smmu_pmu->irq =3D irq;
>
> diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renes=
as/phy-rcar-gen3-usb2.c
> index 9de617ca9daa..9cbd4e396f0f 100644
> --- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
> +++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
> @@ -672,7 +672,7 @@ static int rcar_gen3_phy_usb2_probe(struct platform_d=
evice *pdev)
>
>         channel->obint_enable_bits =3D USB2_OBINT_BITS;
>         /* get irq number here and request_irq for OTG in phy_init */
> -       channel->irq =3D platform_get_irq_optional(pdev, 0);
> +       channel->irq =3D platform_get_irq_silent(pdev, 0);
>         channel->dr_mode =3D rcar_gen3_get_dr_mode(dev->of_node);
>         if (channel->dr_mode !=3D USB_DR_MODE_UNKNOWN) {
>                 int ret;
> diff --git a/drivers/pinctrl/bcm/pinctrl-iproc-gpio.c b/drivers/pinctrl/b=
cm/pinctrl-iproc-gpio.c
> index 52fa2f4cd618..1acf9355ab44 100644
> --- a/drivers/pinctrl/bcm/pinctrl-iproc-gpio.c
> +++ b/drivers/pinctrl/bcm/pinctrl-iproc-gpio.c
> @@ -848,7 +848,7 @@ static int iproc_gpio_probe(struct platform_device *p=
dev)
>                                                         "gpio-ranges");
>
>         /* optional GPIO interrupt support */
> -       irq =3D platform_get_irq_optional(pdev, 0);
> +       irq =3D platform_get_irq_silent(pdev, 0);
>         if (irq > 0) {
>                 struct irq_chip *irqc;
>                 struct gpio_irq_chip *girq;
> diff --git a/drivers/pinctrl/intel/pinctrl-baytrail.c b/drivers/pinctrl/i=
ntel/pinctrl-baytrail.c
> index 4c01333e1406..cc5a74aea6e5 100644
> --- a/drivers/pinctrl/intel/pinctrl-baytrail.c
> +++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
> @@ -1568,7 +1568,7 @@ static int byt_gpio_probe(struct intel_pinctrl *vg)
>  #endif
>
>         /* set up interrupts  */
> -       irq =3D platform_get_irq_optional(pdev, 0);
> +       irq =3D platform_get_irq_silent(pdev, 0);
>         if (irq > 0) {
>                 struct gpio_irq_chip *girq;
>
> diff --git a/drivers/pinctrl/intel/pinctrl-lynxpoint.c b/drivers/pinctrl/=
intel/pinctrl-lynxpoint.c
> index 561fa322b0b4..984c5c0b4304 100644
> --- a/drivers/pinctrl/intel/pinctrl-lynxpoint.c
> +++ b/drivers/pinctrl/intel/pinctrl-lynxpoint.c
> @@ -879,7 +879,7 @@ static int lp_gpio_probe(struct platform_device *pdev=
)
>         gc->parent =3D dev;
>
>         /* set up interrupts  */
> -       irq =3D platform_get_irq_optional(pdev, 0);
> +       irq =3D platform_get_irq_silent(pdev, 0);
>         if (irq > 0) {
>                 struct gpio_irq_chip *girq;
>
> diff --git a/drivers/pinctrl/pinctrl-keembay.c b/drivers/pinctrl/pinctrl-=
keembay.c
> index 152c35bce8ec..628f642ec220 100644
> --- a/drivers/pinctrl/pinctrl-keembay.c
> +++ b/drivers/pinctrl/pinctrl-keembay.c
> @@ -1490,7 +1490,7 @@ static int keembay_gpiochip_probe(struct keembay_pi=
nctrl *kpc,
>                 struct keembay_gpio_irq *kmb_irq =3D &kpc->irq[i];
>                 int irq;
>
> -               irq =3D platform_get_irq_optional(pdev, i);
> +               irq =3D platform_get_irq_silent(pdev, i);
>                 if (irq <=3D 0)
>                         continue;
>
> diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/=
samsung/pinctrl-samsung.c
> index 0f6e9305fec5..47160ec0407c 100644
> --- a/drivers/pinctrl/samsung/pinctrl-samsung.c
> +++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
> @@ -1108,7 +1108,7 @@ static int samsung_pinctrl_probe(struct platform_de=
vice *pdev)
>         }
>         drvdata->dev =3D dev;
>
> -       ret =3D platform_get_irq_optional(pdev, 0);
> +       ret =3D platform_get_irq_silent(pdev, 0);
>         if (ret < 0 && ret !=3D -ENXIO)
>                 return ret;
>         if (ret > 0)
> diff --git a/drivers/platform/chrome/cros_ec_lpc.c b/drivers/platform/chr=
ome/cros_ec_lpc.c
> index d6306d2a096f..30f06d4b6ad8 100644
> --- a/drivers/platform/chrome/cros_ec_lpc.c
> +++ b/drivers/platform/chrome/cros_ec_lpc.c
> @@ -397,7 +397,7 @@ static int cros_ec_lpc_probe(struct platform_device *=
pdev)
>          * Some boards do not have an IRQ allotted for cros_ec_lpc,
>          * which makes ENXIO an expected (and safe) scenario.
>          */
> -       irq =3D platform_get_irq_optional(pdev, 0);
> +       irq =3D platform_get_irq_silent(pdev, 0);
>         if (irq > 0)
>                 ec_dev->irq =3D irq;
>         else if (irq !=3D -ENXIO) {
> diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_ac=
cel.c
> index e9f852f7c27f..bffc9093a629 100644
> --- a/drivers/platform/x86/hp_accel.c
> +++ b/drivers/platform/x86/hp_accel.c
> @@ -305,7 +305,7 @@ static int lis3lv02d_probe(struct platform_device *de=
vice)
>         lis3_dev.write =3D lis3lv02d_acpi_write;
>
>         /* obtain IRQ number of our device from ACPI */
> -       ret =3D platform_get_irq_optional(device, 0);
> +       ret =3D platform_get_irq_silent(device, 0);
>         if (ret > 0)
>                 lis3_dev.irq =3D ret;
>
> diff --git a/drivers/platform/x86/intel/punit_ipc.c b/drivers/platform/x8=
6/intel/punit_ipc.c
> index 66bb39fd0ef9..2f22d5de767a 100644
> --- a/drivers/platform/x86/intel/punit_ipc.c
> +++ b/drivers/platform/x86/intel/punit_ipc.c
> @@ -277,7 +277,7 @@ static int intel_punit_ipc_probe(struct platform_devi=
ce *pdev)
>
>         platform_set_drvdata(pdev, punit_ipcdev);
>
> -       irq =3D platform_get_irq_optional(pdev, 0);
> +       irq =3D platform_get_irq_silent(pdev, 0);
>         if (irq < 0) {
>                 dev_warn(&pdev->dev, "Invalid IRQ, using polling mode\n")=
;
>         } else {
> diff --git a/drivers/platform/x86/intel_scu_pltdrv.c b/drivers/platform/x=
86/intel_scu_pltdrv.c
> index 56ec6ae4c824..2d3e5174da8e 100644
> --- a/drivers/platform/x86/intel_scu_pltdrv.c
> +++ b/drivers/platform/x86/intel_scu_pltdrv.c
> @@ -23,7 +23,7 @@ static int intel_scu_platform_probe(struct platform_dev=
ice *pdev)
>         struct intel_scu_ipc_dev *scu;
>         const struct resource *res;
>
> -       scu_data.irq =3D platform_get_irq_optional(pdev, 0);
> +       scu_data.irq =3D platform_get_irq_silent(pdev, 0);
>         res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         if (!res)
>                 return -ENOMEM;
> diff --git a/drivers/power/supply/mp2629_charger.c b/drivers/power/supply=
/mp2629_charger.c
> index bdf924b73e47..e279a4bdf6a4 100644
> --- a/drivers/power/supply/mp2629_charger.c
> +++ b/drivers/power/supply/mp2629_charger.c
> @@ -580,7 +580,7 @@ static int mp2629_charger_probe(struct platform_devic=
e *pdev)
>         charger->dev =3D dev;
>         platform_set_drvdata(pdev, charger);
>
> -       irq =3D platform_get_irq_optional(to_platform_device(dev->parent)=
, 0);
> +       irq =3D platform_get_irq_silent(to_platform_device(dev->parent), =
0);
>         if (irq < 0) {
>                 dev_err(dev, "get irq fail: %d\n", irq);
>                 return irq;
> diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
> index f0f6b9b6daec..aebc8a73acfe 100644
> --- a/drivers/rtc/rtc-m48t59.c
> +++ b/drivers/rtc/rtc-m48t59.c
> @@ -421,7 +421,7 @@ static int m48t59_rtc_probe(struct platform_device *p=
dev)
>         /* Try to get irq number. We also can work in
>          * the mode without IRQ.
>          */
> -       m48t59->irq =3D platform_get_irq_optional(pdev, 0);
> +       m48t59->irq =3D platform_get_irq_silent(pdev, 0);
>         if (m48t59->irq <=3D 0)
>                 m48t59->irq =3D NO_IRQ;
>
> diff --git a/drivers/spi/spi-hisi-sfc-v3xx.c b/drivers/spi/spi-hisi-sfc-v=
3xx.c
> index d3a23b1c2a4c..76f4934a23e7 100644
> --- a/drivers/spi/spi-hisi-sfc-v3xx.c
> +++ b/drivers/spi/spi-hisi-sfc-v3xx.c
> @@ -451,7 +451,7 @@ static int hisi_sfc_v3xx_probe(struct platform_device=
 *pdev)
>                 goto err_put_master;
>         }
>
> -       host->irq =3D platform_get_irq_optional(pdev, 0);
> +       host->irq =3D platform_get_irq_silent(pdev, 0);
>         if (host->irq =3D=3D -EPROBE_DEFER) {
>                 ret =3D -EPROBE_DEFER;
>                 goto err_put_master;
> diff --git a/drivers/spi/spi-mtk-nor.c b/drivers/spi/spi-mtk-nor.c
> index 5c93730615f8..64aec31355bb 100644
> --- a/drivers/spi/spi-mtk-nor.c
> +++ b/drivers/spi/spi-mtk-nor.c
> @@ -828,7 +828,7 @@ static int mtk_nor_probe(struct platform_device *pdev=
)
>
>         mtk_nor_init(sp);
>
> -       irq =3D platform_get_irq_optional(pdev, 0);
> +       irq =3D platform_get_irq_silent(pdev, 0);
>
>         if (irq < 0) {
>                 dev_warn(sp->dev, "IRQ not available.");
> diff --git a/drivers/thermal/rcar_gen3_thermal.c b/drivers/thermal/rcar_g=
en3_thermal.c
> index 43eb25b167bc..ef6c6880a943 100644
> --- a/drivers/thermal/rcar_gen3_thermal.c
> +++ b/drivers/thermal/rcar_gen3_thermal.c
> @@ -429,7 +429,7 @@ static int rcar_gen3_thermal_request_irqs(struct rcar=
_gen3_thermal_priv *priv,
>         int ret, irq;
>
>         for (i =3D 0; i < 2; i++) {
> -               irq =3D platform_get_irq_optional(pdev, i);
> +               irq =3D platform_get_irq_silent(pdev, i);
>                 if (irq < 0)
>                         return irq;
>
> diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250=
/8250_mtk.c
> index fb65dc601b23..1f4cbe37627e 100644
> --- a/drivers/tty/serial/8250/8250_mtk.c
> +++ b/drivers/tty/serial/8250/8250_mtk.c
> @@ -585,7 +585,7 @@ static int mtk8250_probe(struct platform_device *pdev=
)
>                 goto err_pm_disable;
>         }
>
> -       data->rx_wakeup_irq =3D platform_get_irq_optional(pdev, 1);
> +       data->rx_wakeup_irq =3D platform_get_irq_silent(pdev, 1);
>
>         return 0;
>
> diff --git a/drivers/tty/serial/altera_jtaguart.c b/drivers/tty/serial/al=
tera_jtaguart.c
> index 37bffe406b18..1cd2bdee3d40 100644
> --- a/drivers/tty/serial/altera_jtaguart.c
> +++ b/drivers/tty/serial/altera_jtaguart.c
> @@ -439,7 +439,7 @@ static int altera_jtaguart_probe(struct platform_devi=
ce *pdev)
>         else
>                 return -ENODEV;
>
> -       irq =3D platform_get_irq_optional(pdev, 0);
> +       irq =3D platform_get_irq_silent(pdev, 0);
>         if (irq < 0 && irq !=3D -ENXIO)
>                 return irq;
>         if (irq > 0)
> diff --git a/drivers/tty/serial/altera_uart.c b/drivers/tty/serial/altera=
_uart.c
> index 64a352b40197..415883ccfbbd 100644
> --- a/drivers/tty/serial/altera_uart.c
> +++ b/drivers/tty/serial/altera_uart.c
> @@ -576,7 +576,7 @@ static int altera_uart_probe(struct platform_device *=
pdev)
>         else
>                 return -EINVAL;
>
> -       ret =3D platform_get_irq_optional(pdev, 0);
> +       ret =3D platform_get_irq_silent(pdev, 0);
>         if (ret < 0 && ret !=3D -ENXIO)
>                 return ret;
>         if (ret > 0)
> diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
> index df8a0c8b8b29..8791f51e52cb 100644
> --- a/drivers/tty/serial/imx.c
> +++ b/drivers/tty/serial/imx.c
> @@ -2258,8 +2258,8 @@ static int imx_uart_probe(struct platform_device *p=
dev)
>         rxirq =3D platform_get_irq(pdev, 0);
>         if (rxirq < 0)
>                 return rxirq;
> -       txirq =3D platform_get_irq_optional(pdev, 1);
> -       rtsirq =3D platform_get_irq_optional(pdev, 2);
> +       txirq =3D platform_get_irq_silent(pdev, 1);
> +       rtsirq =3D platform_get_irq_silent(pdev, 2);
>
>         sport->port.dev =3D &pdev->dev;
>         sport->port.mapbase =3D res->start;
> diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/q=
com_geni_serial.c
> index aedc38893e6c..893922e520a9 100644
> --- a/drivers/tty/serial/qcom_geni_serial.c
> +++ b/drivers/tty/serial/qcom_geni_serial.c
> @@ -1406,7 +1406,7 @@ static int qcom_geni_serial_probe(struct platform_d=
evice *pdev)
>         uport->has_sysrq =3D IS_ENABLED(CONFIG_SERIAL_QCOM_GENI_CONSOLE);
>
>         if (!console)
> -               port->wakeup_irq =3D platform_get_irq_optional(pdev, 1);
> +               port->wakeup_irq =3D platform_get_irq_silent(pdev, 1);
>
>         if (of_property_read_bool(pdev->dev.of_node, "rx-tx-swap"))
>                 port->rx_tx_swap =3D true;
> diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
> index 968967d722d4..f2fb298b3aed 100644
> --- a/drivers/tty/serial/sh-sci.c
> +++ b/drivers/tty/serial/sh-sci.c
> @@ -2860,7 +2860,7 @@ static int sci_init_single(struct platform_device *=
dev,
>
>         for (i =3D 0; i < ARRAY_SIZE(sci_port->irqs); ++i) {
>                 if (i)
> -                       sci_port->irqs[i] =3D platform_get_irq_optional(d=
ev, i);
> +                       sci_port->irqs[i] =3D platform_get_irq_silent(dev=
, i);
>                 else
>                         sci_port->irqs[i] =3D platform_get_irq(dev, i);
>         }
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.=
c
> index 63258b6accc4..a2673a8ebd3f 100644
> --- a/drivers/uio/uio_pdrv_genirq.c
> +++ b/drivers/uio/uio_pdrv_genirq.c
> @@ -160,7 +160,7 @@ static int uio_pdrv_genirq_probe(struct platform_devi=
ce *pdev)
>         priv->pdev =3D pdev;
>
>         if (!uioinfo->irq) {
> -               ret =3D platform_get_irq_optional(pdev, 0);
> +               ret =3D platform_get_irq_silent(pdev, 0);
>                 uioinfo->irq =3D ret;
>                 if (ret =3D=3D -ENXIO)
>                         uioinfo->irq =3D UIO_IRQ_NONE;
> diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-=
usb.c
> index 68cd4b68e3a2..5237c62f60f0 100644
> --- a/drivers/usb/phy/phy-tegra-usb.c
> +++ b/drivers/usb/phy/phy-tegra-usb.c
> @@ -1353,7 +1353,7 @@ static int tegra_usb_phy_probe(struct platform_devi=
ce *pdev)
>                 return -ENOMEM;
>
>         tegra_phy->soc_config =3D of_device_get_match_data(&pdev->dev);
> -       tegra_phy->irq =3D platform_get_irq_optional(pdev, 0);
> +       tegra_phy->irq =3D platform_get_irq_silent(pdev, 0);
>
>         res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         if (!res) {
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platfor=
m/vfio_platform.c
> index 68a1c87066d7..60b4f5ce5aa1 100644
> --- a/drivers/vfio/platform/vfio_platform.c
> +++ b/drivers/vfio/platform/vfio_platform.c
> @@ -33,7 +33,7 @@ static int get_platform_irq(struct vfio_platform_device=
 *vdev, int i)
>  {
>         struct platform_device *pdev =3D (struct platform_device *) vdev-=
>opaque;
>
> -       return platform_get_irq_optional(pdev, i);
> +       return platform_get_irq_silent(pdev, i);
>  }
>
>  static int vfio_platform_probe(struct platform_device *pdev)
> diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
> index cd578843277e..9c792ab66a83 100644
> --- a/drivers/watchdog/dw_wdt.c
> +++ b/drivers/watchdog/dw_wdt.c
> @@ -617,7 +617,7 @@ static int dw_wdt_drv_probe(struct platform_device *p=
dev)
>          * pending either until the next watchdog kick event or up to the
>          * system reset.
>          */
> -       ret =3D platform_get_irq_optional(pdev, 0);
> +       ret =3D platform_get_irq_silent(pdev, 0);
>         if (ret > 0) {
>                 ret =3D devm_request_irq(dev, ret, dw_wdt_irq,
>                                        IRQF_SHARED | IRQF_TRIGGER_RISING,
> diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
> index 127eefc9161d..c533fbb37895 100644
> --- a/drivers/watchdog/orion_wdt.c
> +++ b/drivers/watchdog/orion_wdt.c
> @@ -602,7 +602,7 @@ static int orion_wdt_probe(struct platform_device *pd=
ev)
>                 set_bit(WDOG_HW_RUNNING, &dev->wdt.status);
>
>         /* Request the IRQ only after the watchdog is disabled */
> -       irq =3D platform_get_irq_optional(pdev, 0);
> +       irq =3D platform_get_irq_silent(pdev, 0);
>         if (irq > 0) {
>                 /*
>                  * Not all supported platforms specify an interrupt for t=
he
> @@ -617,7 +617,7 @@ static int orion_wdt_probe(struct platform_device *pd=
ev)
>         }
>
>         /* Optional 2nd interrupt for pretimeout */
> -       irq =3D platform_get_irq_optional(pdev, 1);
> +       irq =3D platform_get_irq_silent(pdev, 1);
>         if (irq > 0) {
>                 orion_wdt_info.options |=3D WDIOF_PRETIMEOUT;
>                 ret =3D devm_request_irq(&pdev->dev, irq, orion_wdt_pre_i=
rq,
> diff --git a/drivers/watchdog/qcom-wdt.c b/drivers/watchdog/qcom-wdt.c
> index 0d2209c5eaca..f1bbfed047a1 100644
> --- a/drivers/watchdog/qcom-wdt.c
> +++ b/drivers/watchdog/qcom-wdt.c
> @@ -257,7 +257,7 @@ static int qcom_wdt_probe(struct platform_device *pde=
v)
>         }
>
>         /* check if there is pretimeout support */
> -       irq =3D platform_get_irq_optional(pdev, 0);
> +       irq =3D platform_get_irq_silent(pdev, 0);
>         if (data->pretimeout && irq > 0) {
>                 ret =3D devm_request_irq(dev, irq, qcom_wdt_isr, 0,
>                                        "wdt_bark", &wdt->wdd);
> diff --git a/include/linux/platform_device.h b/include/linux/platform_dev=
ice.h
> index 7c96f169d274..6d495f15f717 100644
> --- a/include/linux/platform_device.h
> +++ b/include/linux/platform_device.h
> @@ -69,7 +69,14 @@ extern void __iomem *
>  devm_platform_ioremap_resource_byname(struct platform_device *pdev,
>                                       const char *name);
>  extern int platform_get_irq(struct platform_device *, unsigned int);
> -extern int platform_get_irq_optional(struct platform_device *, unsigned =
int);
> +extern int platform_get_irq_silent(struct platform_device *, unsigned in=
t);
> +
> +/*
> + * platform_get_irq_optional was recently renamed to platform_get_irq_si=
lent.
> + * Fixup users to not break patches that were created before the rename.
> + */
> +#define platform_get_irq_optional(pdev, index) platform_get_irq_silent(p=
dev, index)
> +
>  extern int platform_irq_count(struct platform_device *);
>  extern int devm_platform_get_irqs_affinity(struct platform_device *dev,
>                                            struct irq_affinity *affd,
> diff --git a/sound/soc/dwc/dwc-i2s.c b/sound/soc/dwc/dwc-i2s.c
> index 5cb58929090d..f7cfe8f7cce0 100644
> --- a/sound/soc/dwc/dwc-i2s.c
> +++ b/sound/soc/dwc/dwc-i2s.c
> @@ -642,7 +642,7 @@ static int dw_i2s_probe(struct platform_device *pdev)
>
>         dev->dev =3D &pdev->dev;
>
> -       irq =3D platform_get_irq_optional(pdev, 0);
> +       irq =3D platform_get_irq_silent(pdev, 0);
>         if (irq >=3D 0) {
>                 ret =3D devm_request_irq(&pdev->dev, irq, i2s_irq_handler=
, 0,
>                                 pdev->name, dev);
> diff --git a/sound/soc/intel/keembay/kmb_platform.c b/sound/soc/intel/kee=
mbay/kmb_platform.c
> index a6fb74ba1c42..ee0159b7e9f6 100644
> --- a/sound/soc/intel/keembay/kmb_platform.c
> +++ b/sound/soc/intel/keembay/kmb_platform.c
> @@ -882,7 +882,7 @@ static int kmb_plat_dai_probe(struct platform_device =
*pdev)
>         kmb_i2s->use_pio =3D !(of_property_read_bool(np, "dmas"));
>
>         if (kmb_i2s->use_pio) {
> -               irq =3D platform_get_irq_optional(pdev, 0);
> +               irq =3D platform_get_irq_silent(pdev, 0);
>                 if (irq > 0) {
>                         ret =3D devm_request_irq(dev, irq, kmb_i2s_irq_ha=
ndler, 0,
>                                                pdev->name, kmb_i2s);
> --
> 2.34.1
>
>
>
> --
> Pengutronix e.K.                           | Uwe Kleine-K=C3=B6nig       =
     |
> Industrial Linux Solutions                 | https://www.pengutronix.de/ =
|
