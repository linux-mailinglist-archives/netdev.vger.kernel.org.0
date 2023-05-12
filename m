Return-Path: <netdev+bounces-2099-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12C1F7003D8
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:33:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43868281A31
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E464BE54;
	Fri, 12 May 2023 09:33:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9FDBA32
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:33:19 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD5911B4B;
	Fri, 12 May 2023 02:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=0FWTt3842+JW+mHTSOa/9O6/h7lsiGm32xHAyK2K/j4=; b=CV7UNL90ri9ok1p9Fzss+uI/L/
	VfCwCRHuUqwkBRdtAbAv+luNMrL7Jb16CXbCLPGDv6Nr9AcfNcICv7nsI+WC3Iw3Hrlr6AOktw5H6
	VYVXyJAlTybiMKIkjxhjxAo3llSWsD9u5+SCs9SuX9sZpT3DYrfq8lScKuBZJwqjGHXkQF40nEaYc
	qp/SWC0fOYtQE3WX8h8BHzsK2jW+6VzjPC8CHBAWhiJHE80OuJksIXG4oYCQNgV5lO3B1oJZGk0ym
	SuG/4rNuRvT9oCIeETYkq6u6OPOBDYpcj36X3sg+L8SLSen2zsSwkYCNUn/tUxDiJm5ox2yW7o2uL
	+XVN5tgA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41248)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pxP8b-00084B-Cd; Fri, 12 May 2023 10:32:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pxP8Y-0004xA-E8; Fri, 12 May 2023 10:32:30 +0100
Date: Fri, 12 May 2023 10:32:30 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
	andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
	jsd@semihalf.com, Jose.Abreu@synopsys.com, andrew@lunn.ch,
	hkallweit1@gmail.com, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v7 6/9] net: txgbe: Support GPIO to SFP socket
Message-ID: <ZF4Hri1yzpeq4X3T@shell.armlinux.org.uk>
References: <20230509022734.148970-1-jiawenwu@trustnetic.com>
 <20230509022734.148970-7-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509022734.148970-7-jiawenwu@trustnetic.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 10:27:31AM +0800, Jiawen Wu wrote:
> Register GPIO chip and handle GPIO IRQ for SFP socket.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> ---
>  drivers/net/ethernet/wangxun/Kconfig          |   2 +
>  drivers/net/ethernet/wangxun/libwx/wx_lib.c   |   3 +-
>  drivers/net/ethernet/wangxun/libwx/wx_type.h  |   2 +
>  .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  20 +-
>  .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 228 ++++++++++++++++++
>  .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  27 +++
>  6 files changed, 263 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
> index 90812d76181d..73f4492928c0 100644
> --- a/drivers/net/ethernet/wangxun/Kconfig
> +++ b/drivers/net/ethernet/wangxun/Kconfig
> @@ -41,6 +41,8 @@ config TXGBE
>  	tristate "Wangxun(R) 10GbE PCI Express adapters support"
>  	depends on PCI
>  	select I2C_DESIGNWARE_PLATFORM
> +	select GPIOLIB_IRQCHIP
> +	select GPIOLIB
>  	select REGMAP
>  	select COMMON_CLK
>  	select LIBWX
> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> index 1e8d8b7b0c62..590215303d45 100644
> --- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> +++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> @@ -1348,7 +1348,8 @@ void wx_free_irq(struct wx *wx)
>  		free_irq(entry->vector, q_vector);
>  	}
>  
> -	free_irq(wx->msix_entries[vector].vector, wx);
> +	if (wx->mac.type == wx_mac_em)
> +		free_irq(wx->msix_entries[vector].vector, wx);
>  }
>  EXPORT_SYMBOL(wx_free_irq);
>  
> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
> index 97bce855bc60..d151d6f79022 100644
> --- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
> +++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
> @@ -79,7 +79,9 @@
>  #define WX_GPIO_INTMASK              0x14834
>  #define WX_GPIO_INTTYPE_LEVEL        0x14838
>  #define WX_GPIO_POLARITY             0x1483C
> +#define WX_GPIO_INTSTATUS            0x14844
>  #define WX_GPIO_EOI                  0x1484C
> +#define WX_GPIO_EXT                  0x14850
>  
>  /*********************** Transmit DMA registers **************************/
>  /* transmit global control */
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> index e10296abf5b4..ded04e9e136f 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> @@ -82,6 +82,8 @@ static int txgbe_enumerate_functions(struct wx *wx)
>   **/
>  static void txgbe_irq_enable(struct wx *wx, bool queues)
>  {
> +	wr32(wx, WX_PX_MISC_IEN, TXGBE_PX_MISC_IEN_MASK);
> +
>  	/* unmask interrupt */
>  	wx_intr_enable(wx, TXGBE_INTR_MISC(wx));
>  	if (queues)
> @@ -129,17 +131,6 @@ static irqreturn_t txgbe_intr(int __always_unused irq, void *data)
>  	return IRQ_HANDLED;
>  }
>  
> -static irqreturn_t txgbe_msix_other(int __always_unused irq, void *data)
> -{
> -	struct wx *wx = data;
> -
> -	/* re-enable the original interrupt state */
> -	if (netif_running(wx->netdev))
> -		txgbe_irq_enable(wx, false);
> -
> -	return IRQ_HANDLED;
> -}
> -
>  /**
>   * txgbe_request_msix_irqs - Initialize MSI-X interrupts
>   * @wx: board private structure
> @@ -171,13 +162,6 @@ static int txgbe_request_msix_irqs(struct wx *wx)
>  		}
>  	}
>  
> -	err = request_irq(wx->msix_entries[vector].vector,
> -			  txgbe_msix_other, 0, netdev->name, wx);
> -	if (err) {
> -		wx_err(wx, "request_irq for msix_other failed: %d\n", err);
> -		goto free_queue_irqs;
> -	}
> -
>  	return 0;
>  
>  free_queue_irqs:
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
> index 23fa7311db45..8085616a9146 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
> @@ -2,6 +2,9 @@
>  /* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
>  
>  #include <linux/platform_device.h>
> +#include <linux/gpio/consumer.h>
> +#include <linux/gpio/machine.h>
> +#include <linux/gpio/driver.h>
>  #include <linux/gpio/property.h>
>  #include <linux/regmap.h>
>  #include <linux/clkdev.h>
> @@ -10,6 +13,7 @@
>  #include <linux/pci.h>
>  
>  #include "../libwx/wx_type.h"
> +#include "../libwx/wx_hw.h"
>  #include "txgbe_type.h"
>  #include "txgbe_phy.h"
>  
> @@ -74,6 +78,224 @@ static int txgbe_swnodes_register(struct txgbe *txgbe)
>  	return software_node_register_node_group(nodes->group);
>  }
>  
> +static int txgbe_gpio_get(struct gpio_chip *chip, unsigned int offset)
> +{
> +	struct wx *wx = gpiochip_get_data(chip);
> +	struct txgbe *txgbe = wx->priv;
> +	int val;
> +
> +	val = rd32m(wx, WX_GPIO_EXT, BIT(offset));
> +
> +	txgbe->gpio_orig &= ~BIT(offset);
> +	txgbe->gpio_orig |= val;

You seem to be using this as a way to implement triggering interrupts on
both levels. Reading the GPIO value using the GPIO functions should not
change the interrupt state, so this is wrong.

> +
> +	return !!(val & BIT(offset));
> +}
> +
> +static int txgbe_gpio_get_direction(struct gpio_chip *chip, unsigned int offset)
> +{
> +	struct wx *wx = gpiochip_get_data(chip);
> +	u32 val;
> +
> +	val = rd32(wx, WX_GPIO_DDR);
> +	if (BIT(offset) & val)
> +		return GPIO_LINE_DIRECTION_OUT;
> +
> +	return GPIO_LINE_DIRECTION_IN;
> +}
> +
> +static int txgbe_gpio_direction_in(struct gpio_chip *chip, unsigned int offset)
> +{
> +	struct wx *wx = gpiochip_get_data(chip);
> +
> +	wr32m(wx, WX_GPIO_DDR, BIT(offset), 0);
> +
> +	return 0;
> +}
> +
> +static int txgbe_gpio_direction_out(struct gpio_chip *chip, unsigned int offset,
> +				    int val)
> +{
> +	struct wx *wx = gpiochip_get_data(chip);
> +	u32 mask;
> +
> +	mask = BIT(offset) | BIT(offset - 1);
> +	if (val)
> +		wr32m(wx, WX_GPIO_DR, mask, mask);
> +	else
> +		wr32m(wx, WX_GPIO_DR, mask, 0);

Why are you writing two neighbouring bits here? If GPIO 0 is requested
to change, offset will be zero, and BIT(-1) is probably not what you
want.

Moreover, if requesting a change to GPIO 3, BIT(offset - 1) will also
hit GPIO 2.

Maybe there's a "* 2" missing here?

If this code is in fact correct, it needs a comment to explain what's
going on here.

> +
> +	wr32m(wx, WX_GPIO_DDR, BIT(offset), BIT(offset));
> +
> +	return 0;
> +}
> +
> +static void txgbe_gpio_irq_ack(struct irq_data *d)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +	irq_hw_number_t hwirq = irqd_to_hwirq(d);
> +	struct wx *wx = gpiochip_get_data(gc);
> +
> +	wr32(wx, WX_GPIO_EOI, BIT(hwirq));
> +}
> +
> +static void txgbe_gpio_irq_mask(struct irq_data *d)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +	irq_hw_number_t hwirq = irqd_to_hwirq(d);
> +	struct wx *wx = gpiochip_get_data(gc);
> +
> +	gpiochip_disable_irq(gc, hwirq);
> +
> +	wr32m(wx, WX_GPIO_INTMASK, BIT(hwirq), BIT(hwirq));
> +}
> +
> +static void txgbe_gpio_irq_unmask(struct irq_data *d)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +	irq_hw_number_t hwirq = irqd_to_hwirq(d);
> +	struct wx *wx = gpiochip_get_data(gc);
> +
> +	gpiochip_enable_irq(gc, hwirq);
> +
> +	wr32m(wx, WX_GPIO_INTMASK, BIT(hwirq), 0);
> +}
> +
> +static int txgbe_gpio_set_type(struct irq_data *d, unsigned int type)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +	irq_hw_number_t hwirq = irqd_to_hwirq(d);
> +	struct wx *wx = gpiochip_get_data(gc);
> +	u32 level, polarity;
> +
> +	level = rd32(wx, WX_GPIO_INTTYPE_LEVEL);
> +	polarity = rd32(wx, WX_GPIO_POLARITY);
> +
> +	switch (type) {
> +	case IRQ_TYPE_EDGE_BOTH:
> +		level |= BIT(hwirq);
> +		break;
> +	case IRQ_TYPE_EDGE_RISING:
> +		level |= BIT(hwirq);
> +		polarity |= BIT(hwirq);
> +		break;
> +	case IRQ_TYPE_EDGE_FALLING:
> +		level |= BIT(hwirq);

Are you sure you've got this correct. "level" gets set when edge cases
are requested and cleared when level cases are requested. It seems that
the register really selects edge-mode if the bit is set? Is it described
in the documentation as "not level" ?

> +		polarity &= ~BIT(hwirq);
> +		break;
> +	case IRQ_TYPE_LEVEL_HIGH:
> +		level &= ~BIT(hwirq);
> +		polarity |= BIT(hwirq);
> +		break;
> +	case IRQ_TYPE_LEVEL_LOW:
> +		level &= ~BIT(hwirq);
> +		polarity &= ~BIT(hwirq);
> +		break;
> +	}
> +
> +	if (type & IRQ_TYPE_LEVEL_MASK)
> +		irq_set_handler_locked(d, handle_level_irq);
> +	else if (type & IRQ_TYPE_EDGE_BOTH)
> +		irq_set_handler_locked(d, handle_edge_irq);

So what handler do we end up with if a GPIO is initially requested for
a level IRQ, released, and then requested for an edge IRQ?

Secondly, a more general comment. You are using the masks here, and we
can see from the above that there is a pattern to the setting of level
and polarity. Also, IMHO there's a simpler way to do this:

	u32 level, polarity, mask, val;

	mask = BIT(hwirq);

	if (type & IRQ_TYPE_LEVEL_MASK) {
		level = 0;
		irq_set_handler_locked(d, handle_level_irq);
	} else {
		level = mask;
		/* fixme: irq_set_handler_locked(handle_edge_irq); ? */
	}

	if (type == IRQ_TYPE_EDGE_RISING || type == IRQ_TYPE_LEVEL_HIGH)
		polarity = mask;
	else
		polarity = 0;

	/* fixme: what does this register do, and why is it configured
	 * here?
	 */
	wr32m(wx, WX_GPIO_INTEN, mask, mask);

	wr32m(wx, WX_GPIO_INTTYPE_LEVEL, mask, level);
	if (type != IRQ_TYPE_EDGE_BOTH)
		wr32m(wx, WX_GPIO_POLARITY, mask, polarity);

Now, as for both-edge interrupts, this needs further thought. As I say
above, using the _get method to update the internal interrupt state
won't be reliable.

If the hardware has no way to trigger on both edges, then it's going to
take some additional complexity to make this work. Firstly, you need to
record which interrupts are using both-edges in the driver, so you know
which need extra work in the interrupt handler.

Secondly, you still need to configure the polarity as best you can to
pick up the first change in state here. That means reading the current
GPIO state, and configuring the GPIO polarity correctly here. It's
going to be racy with the hardware, so the closer together you can get
the GPIO state-to-polarity-set the better in terms of the size of the
race window.

> +static void txgbe_irq_handler(struct irq_desc *desc)
> +{
> +	struct irq_chip *chip = irq_desc_get_chip(desc);
> +	struct wx *wx = irq_desc_get_handler_data(desc);
> +	struct txgbe *txgbe = wx->priv;
> +	irq_hw_number_t hwirq;
> +	unsigned long gpioirq;
> +	struct gpio_chip *gc;
> +	u32 gpio;
> +
> +	chained_irq_enter(chip, desc);
> +
> +	gpioirq = rd32(wx, WX_GPIO_INTSTATUS);

Does reading INTSTATUS clear down any of the pending status bits?

> +
> +	/* workaround for hysteretic gpio interrupts */
> +	gpio = rd32(wx, WX_GPIO_EXT);
> +	if (!gpioirq)
> +		gpioirq = txgbe->gpio_orig ^ gpio;

This doesn't solve the both-edge case, because this will only get
evaluated if some other GPIO also happens to raise an interrupt.

For any GPIOs should have both-edge applied, you need to read the
current state of the GPIO and program the polarity appropriately,
then re-read the GPIO to see if it changed state during that race
and handle that as best that can be.

The problem is that making both-edge work reliably on hardware that
doesn't support both-edge will always be rather racy.

> +
> +	gc = txgbe->gpio;
> +	for_each_set_bit(hwirq, &gpioirq, gc->ngpio)
> +		generic_handle_domain_irq(gc->irq.domain, hwirq);
> +
> +	chained_irq_exit(chip, desc);
> +
> +	/* unmask interrupt */
> +	if (netif_running(wx->netdev))
> +		wx_intr_enable(wx, TXGBE_INTR_MISC(wx));

Why does this depend on whether the network interface is running, and
why is it done at the end of the interrupt handler? Maybe this needs a
better comment in the code explaining what it's actually doing?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

