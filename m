Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0891D50373
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 09:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbfFXHbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 03:31:55 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:36373 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727954AbfFXHbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 03:31:55 -0400
Received: from localhost (alyon-656-1-672-152.w92-137.abo.wanadoo.fr [92.137.69.152])
        (Authenticated sender: gregory.clement@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 846E8100010;
        Mon, 24 Jun 2019 07:31:36 +0000 (UTC)
From:   Gregory CLEMENT <gregory.clement@bootlin.com>
To:     Phong Tran <tranmanphong@gmail.com>, mark.rutland@arm.com,
        kstewart@linuxfoundation.org, songliubraving@fb.com,
        andrew@lunn.ch, peterz@infradead.org, nsekhar@ti.com,
        ast@kernel.org, jolsa@redhat.com, netdev@vger.kernel.org,
        gerg@uclinux.org, lorenzo.pieralisi@arm.com, will@kernel.org,
        linux-samsung-soc@vger.kernel.org, daniel@iogearbox.net,
        tranmanphong@gmail.com, festevam@gmail.com, allison@lohutok.net,
        linux@armlinux.org.uk, krzk@kernel.org, haojian.zhuang@gmail.com,
        bgolaszewski@baylibre.com, tony@atomide.com, mingo@redhat.com,
        linux-imx@nxp.com, yhs@fb.com, sebastian.hesselbarth@gmail.com,
        illusionist.neo@gmail.com, jason@lakedaemon.net,
        liviu.dudau@arm.com, s.hauer@pengutronix.de, acme@kernel.org,
        lkundrak@v3.sk, robert.jarzmik@free.fr, dmg@turingmachine.org,
        swinslow@gmail.com, namhyung@kernel.org, tglx@linutronix.de,
        linux-omap@vger.kernel.org, alexander.sverdlin@gmail.com,
        linux-arm-kernel@lists.infradead.org, info@metux.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        alexander.shishkin@linux.intel.com, hsweeten@visionengravers.com,
        kgene@kernel.org, kernel@pengutronix.de, sudeep.holla@arm.com,
        bpf@vger.kernel.org, shawnguo@kernel.org, kafai@fb.com,
        daniel@zonque.org
Subject: Re: [PATCH 10/15] ARM: orion5x: cleanup cppcheck shifting errors
In-Reply-To: <20190623151313.970-11-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com> <20190623151313.970-11-tranmanphong@gmail.com>
Date:   Mon, 24 Jun 2019 09:31:37 +0200
Message-ID: <871rzjmobq.fsf@FE-laptop>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Phong,

> [arch/arm/mach-orion5x/pci.c:281]: (error) Shifting signed 32-bit value
> by 31 bits is undefined behaviour
> [arch/arm/mach-orion5x/pci.c:305]: (error) Shifting signed 32-bit value
> by 31 bits is undefined behaviour
>

While Andrew was Ok with this version, I will wait for your v2 using
BIT() marcro.

Thanks,

Gregory


> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> ---
>  arch/arm/mach-orion5x/pci.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/mach-orion5x/pci.c b/arch/arm/mach-orion5x/pci.c
> index 76951bfbacf5..1b2c077ee7b8 100644
> --- a/arch/arm/mach-orion5x/pci.c
> +++ b/arch/arm/mach-orion5x/pci.c
> @@ -200,13 +200,13 @@ static int __init pcie_setup(struct pci_sys_data *sys)
>  /*
>   * PCI_MODE bits
>   */
> -#define PCI_MODE_64BIT			(1 << 2)
> -#define PCI_MODE_PCIX			((1 << 4) | (1 << 5))
> +#define PCI_MODE_64BIT			(1U << 2)
> +#define PCI_MODE_PCIX			((1U << 4) | (1U << 5))
>  
>  /*
>   * PCI_CMD bits
>   */
> -#define PCI_CMD_HOST_REORDER		(1 << 29)
> +#define PCI_CMD_HOST_REORDER		(1U << 29)
>  
>  /*
>   * PCI_P2P_CONF bits
> @@ -223,7 +223,7 @@ static int __init pcie_setup(struct pci_sys_data *sys)
>  #define PCI_CONF_FUNC(func)		(((func) & 0x3) << 8)
>  #define PCI_CONF_DEV(dev)		(((dev) & 0x1f) << 11)
>  #define PCI_CONF_BUS(bus)		(((bus) & 0xff) << 16)
> -#define PCI_CONF_ADDR_EN		(1 << 31)
> +#define PCI_CONF_ADDR_EN		(1U << 31)
>  
>  /*
>   * Internal configuration space
> -- 
> 2.11.0
>

-- 
Gregory Clement, Bootlin
Embedded Linux and Kernel engineering
http://bootlin.com
