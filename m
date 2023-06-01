Return-Path: <netdev+bounces-7179-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C45DA71F04B
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:08:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 186221C2104D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AEEA4252B;
	Thu,  1 Jun 2023 17:08:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4430813AC3
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:08:54 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BAD192;
	Thu,  1 Jun 2023 10:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685639331; x=1717175331;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=a1CxtjtuQXFTHCAKgij6gVUT+yLSI2sxEfoiHt43Z6g=;
  b=jZX2mm4fCTsvbPd/txZU9peooLWYSj66cx4QZh+yNuc+0R9Q9vWT4nym
   AlQ2PgqcAh5sMRc+tUaZqau8Kpe/ulKZiXVuza5yTCg6otcPeqsdSt2+d
   RmnIGYkYCaDgoW933Pf+GvzSLpz7IncCk4rN6RG/T39lYHZpog2o65ESM
   J/D5FUjkTUq3n9kScf+j5zLsMTmbIyQLPWWCf16A7Msf3u83au3SkopD2
   1HgHq0TAqS2EwGqjChGhssX9tgV7GW/pOQI/UfUApnw+bynDHsVHW6CyT
   X+31fRxp52JAQtSjQb16ATy6PEm6vK5AqH3fDcai7whpxpwcJtSaX3K62
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="441985362"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="441985362"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 10:08:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="831647014"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="831647014"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga004.jf.intel.com with ESMTP; 01 Jun 2023 10:07:59 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1q4lmH-000Syj-1f;
	Thu, 01 Jun 2023 20:07:57 +0300
Date: Thu, 1 Jun 2023 20:07:57 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
	linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v10 6/9] net: txgbe: Support GPIO to SFP socket
Message-ID: <ZHjQbaFjD3D45C/v@smile.fi.intel.com>
References: <20230601030140.687493-1-jiawenwu@trustnetic.com>
 <20230601030140.687493-7-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601030140.687493-7-jiawenwu@trustnetic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 11:01:37AM +0800, Jiawen Wu wrote:
> Register GPIO chip and handle GPIO IRQ for SFP socket.

LGTM, but one comment below.
After addressing,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> ---
>  drivers/net/ethernet/wangxun/Kconfig          |   2 +
>  drivers/net/ethernet/wangxun/libwx/wx_lib.c   |   3 +-
>  drivers/net/ethernet/wangxun/libwx/wx_type.h  |   3 +
>  .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  20 +-
>  .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 248 ++++++++++++++++++
>  .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  23 ++
>  6 files changed, 280 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
> index 59f3a3f492cf..3744735fa708 100644
> --- a/drivers/net/ethernet/wangxun/Kconfig
> +++ b/drivers/net/ethernet/wangxun/Kconfig
> @@ -47,6 +47,8 @@ config TXGBE
>  	select PHYLINK
>  	select HWMON if TXGBE=y
>  	select SFP
> +	select GPIOLIB
> +	select GPIOLIB_IRQCHIP
>  	select LIBWX
>  	help
>  	  This driver supports Wangxun(R) 10GbE PCI Express family of
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
> index f59066d7375c..297c389fa890 100644
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
> @@ -643,6 +645,7 @@ struct wx {
>  	bool wol_enabled;
>  	bool ncsi_enabled;
>  	bool gpio_ctrl;
> +	raw_spinlock_t gpio_lock;
>  
>  	/* Tx fast path data */
>  	int num_tx_queues;
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
> index d95dc131e91b..32fff693e073 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
> @@ -1,6 +1,8 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
>  
> +#include <linux/gpio/machine.h>
> +#include <linux/gpio/driver.h>
>  #include <linux/gpio/property.h>
>  #include <linux/clk-provider.h>
>  #include <linux/clkdev.h>
> @@ -10,6 +12,7 @@
>  #include <linux/regmap.h>
>  
>  #include "../libwx/wx_type.h"
> +#include "../libwx/wx_hw.h"
>  #include "txgbe_type.h"
>  #include "txgbe_phy.h"
>  
> @@ -74,6 +77,245 @@ static int txgbe_swnodes_register(struct txgbe *txgbe)
>  	return software_node_register_node_group(nodes->group);
>  }
>  
> +static int txgbe_gpio_get(struct gpio_chip *chip, unsigned int offset)
> +{
> +	struct wx *wx = gpiochip_get_data(chip);
> +	int val;
> +
> +	val = rd32m(wx, WX_GPIO_EXT, BIT(offset));
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
> +	unsigned long flags;
> +
> +	raw_spin_lock_irqsave(&wx->gpio_lock, flags);
> +	wr32m(wx, WX_GPIO_DDR, BIT(offset), 0);
> +	raw_spin_unlock_irqrestore(&wx->gpio_lock, flags);
> +
> +	return 0;
> +}
> +
> +static int txgbe_gpio_direction_out(struct gpio_chip *chip, unsigned int offset,
> +				    int val)
> +{
> +	struct wx *wx = gpiochip_get_data(chip);
> +	unsigned long flags;
> +	u32 set;
> +
> +	set = val ? BIT(offset) : 0;
> +
> +	raw_spin_lock_irqsave(&wx->gpio_lock, flags);
> +	wr32m(wx, WX_GPIO_DR, BIT(offset), set);
> +	wr32m(wx, WX_GPIO_DDR, BIT(offset), BIT(offset));
> +	raw_spin_unlock_irqrestore(&wx->gpio_lock, flags);
> +
> +	return 0;
> +}
> +
> +static void txgbe_gpio_irq_ack(struct irq_data *d)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +	irq_hw_number_t hwirq = irqd_to_hwirq(d);
> +	struct wx *wx = gpiochip_get_data(gc);
> +	unsigned long flags;
> +
> +	raw_spin_lock_irqsave(&wx->gpio_lock, flags);
> +	wr32(wx, WX_GPIO_EOI, BIT(hwirq));
> +	raw_spin_unlock_irqrestore(&wx->gpio_lock, flags);
> +}
> +
> +static void txgbe_gpio_irq_mask(struct irq_data *d)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +	irq_hw_number_t hwirq = irqd_to_hwirq(d);
> +	struct wx *wx = gpiochip_get_data(gc);
> +	unsigned long flags;
> +
> +	gpiochip_disable_irq(gc, hwirq);
> +
> +	raw_spin_lock_irqsave(&wx->gpio_lock, flags);
> +	wr32m(wx, WX_GPIO_INTMASK, BIT(hwirq), BIT(hwirq));
> +	raw_spin_unlock_irqrestore(&wx->gpio_lock, flags);
> +}
> +
> +static void txgbe_gpio_irq_unmask(struct irq_data *d)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +	irq_hw_number_t hwirq = irqd_to_hwirq(d);
> +	struct wx *wx = gpiochip_get_data(gc);
> +	unsigned long flags;
> +
> +	gpiochip_enable_irq(gc, hwirq);
> +
> +	raw_spin_lock_irqsave(&wx->gpio_lock, flags);
> +	wr32m(wx, WX_GPIO_INTMASK, BIT(hwirq), 0);
> +	raw_spin_unlock_irqrestore(&wx->gpio_lock, flags);
> +}
> +
> +static void txgbe_toggle_trigger(struct gpio_chip *gc, unsigned int offset)
> +{
> +	struct wx *wx = gpiochip_get_data(gc);
> +	u32 pol, val;
> +
> +	pol = rd32(wx, WX_GPIO_POLARITY);
> +	val = rd32(wx, WX_GPIO_EXT);
> +
> +	if (val & BIT(offset))
> +		pol &= ~BIT(offset);
> +	else
> +		pol |= BIT(offset);
> +
> +	wr32(wx, WX_GPIO_POLARITY, pol);
> +}
> +
> +static int txgbe_gpio_set_type(struct irq_data *d, unsigned int type)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> +	irq_hw_number_t hwirq = irqd_to_hwirq(d);
> +	struct wx *wx = gpiochip_get_data(gc);
> +	u32 level, polarity, mask;
> +	unsigned long flags;
> +
> +	mask = BIT(hwirq);
> +
> +	if (type & IRQ_TYPE_LEVEL_MASK) {
> +		level = 0;
> +		irq_set_handler_locked(d, handle_level_irq);
> +	} else {
> +		level = mask;
> +		irq_set_handler_locked(d, handle_edge_irq);
> +	}
> +
> +	if (type == IRQ_TYPE_EDGE_RISING || type == IRQ_TYPE_LEVEL_HIGH)
> +		polarity = mask;
> +	else
> +		polarity = 0;
> +
> +	raw_spin_lock_irqsave(&wx->gpio_lock, flags);
> +
> +	wr32m(wx, WX_GPIO_INTEN, mask, mask);
> +	wr32m(wx, WX_GPIO_INTTYPE_LEVEL, mask, level);
> +	if (type == IRQ_TYPE_EDGE_BOTH)
> +		txgbe_toggle_trigger(gc, hwirq);
> +	else
> +		wr32m(wx, WX_GPIO_POLARITY, mask, polarity);
> +
> +	raw_spin_unlock_irqrestore(&wx->gpio_lock, flags);
> +
> +	return 0;
> +}
> +
> +static const struct irq_chip txgbe_gpio_irq_chip = {
> +	.name = "txgbe_gpio_irq",
> +	.irq_ack = txgbe_gpio_irq_ack,
> +	.irq_mask = txgbe_gpio_irq_mask,
> +	.irq_unmask = txgbe_gpio_irq_unmask,
> +	.irq_set_type = txgbe_gpio_set_type,
> +	.flags = IRQCHIP_IMMUTABLE,
> +	GPIOCHIP_IRQ_RESOURCE_HELPERS,
> +};
> +
> +static void txgbe_irq_handler(struct irq_desc *desc)
> +{
> +	struct irq_chip *chip = irq_desc_get_chip(desc);
> +	struct wx *wx = irq_desc_get_handler_data(desc);
> +	struct txgbe *txgbe = wx->priv;
> +	irq_hw_number_t hwirq;
> +	unsigned long gpioirq;
> +	struct gpio_chip *gc;
> +	unsigned long flags;
> +
> +	chained_irq_enter(chip, desc);
> +
> +	gpioirq = rd32(wx, WX_GPIO_INTSTATUS);
> +
> +	gc = txgbe->gpio;
> +	for_each_set_bit(hwirq, &gpioirq, gc->ngpio) {
> +		int gpio = irq_find_mapping(gc->irq.domain, hwirq);
> +		u32 irq_type = irq_get_trigger_type(gpio);
> +
> +		generic_handle_domain_irq(gc->irq.domain, hwirq);
> +
> +		if ((irq_type & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH) {
> +			raw_spin_lock_irqsave(&wx->gpio_lock, flags);
> +			txgbe_toggle_trigger(gc, hwirq);
> +			raw_spin_unlock_irqrestore(&wx->gpio_lock, flags);
> +		}
> +	}
> +
> +	chained_irq_exit(chip, desc);
> +
> +	/* unmask interrupt */
> +	wx_intr_enable(wx, TXGBE_INTR_MISC(wx));
> +}
> +
> +static int txgbe_gpio_init(struct txgbe *txgbe)
> +{
> +	struct gpio_irq_chip *girq;
> +	struct gpio_chip *gc;
> +	struct device *dev;
> +	struct wx *wx;
> +	int ret;
> +
> +	wx = txgbe->wx;
> +	dev = &wx->pdev->dev;
> +
> +	raw_spin_lock_init(&wx->gpio_lock);
> +
> +	gc = devm_kzalloc(dev, sizeof(*gc), GFP_KERNEL);
> +	if (!gc)
> +		return -ENOMEM;
> +
> +	gc->label = devm_kasprintf(dev, GFP_KERNEL, "txgbe_gpio-%x",
> +				   (wx->pdev->bus->number << 8) | wx->pdev->devfn);

Missing NULL check.

> +	gc->base = -1;
> +	gc->ngpio = 6;
> +	gc->owner = THIS_MODULE;
> +	gc->parent = dev;
> +	gc->fwnode = software_node_fwnode(txgbe->nodes.group[SWNODE_GPIO]);
> +	gc->get = txgbe_gpio_get;
> +	gc->get_direction = txgbe_gpio_get_direction;
> +	gc->direction_input = txgbe_gpio_direction_in;
> +	gc->direction_output = txgbe_gpio_direction_out;
> +
> +	girq = &gc->irq;
> +	gpio_irq_chip_set_chip(girq, &txgbe_gpio_irq_chip);
> +	girq->parent_handler = txgbe_irq_handler;
> +	girq->parent_handler_data = wx;
> +	girq->num_parents = 1;
> +	girq->parents = devm_kcalloc(dev, girq->num_parents,
> +				     sizeof(*girq->parents), GFP_KERNEL);
> +	if (!girq->parents)
> +		return -ENOMEM;
> +	girq->parents[0] = wx->msix_entries[wx->num_q_vectors].vector;
> +	girq->default_type = IRQ_TYPE_NONE;
> +	girq->handler = handle_bad_irq;
> +
> +	ret = devm_gpiochip_add_data(dev, gc, wx);
> +	if (ret)
> +		return ret;
> +
> +	txgbe->gpio = gc;
> +
> +	return 0;
> +}
> +
>  static int txgbe_clock_register(struct txgbe *txgbe)
>  {
>  	struct pci_dev *pdev = txgbe->wx->pdev;
> @@ -187,6 +429,12 @@ int txgbe_init_phy(struct txgbe *txgbe)
>  		return ret;
>  	}
>  
> +	ret = txgbe_gpio_init(txgbe);
> +	if (ret) {
> +		wx_err(txgbe->wx, "failed to init gpio\n");
> +		goto err_unregister_swnode;
> +	}
> +
>  	ret = txgbe_clock_register(txgbe);
>  	if (ret) {
>  		wx_err(txgbe->wx, "failed to register clock: %d\n", ret);
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> index fc91e0fc37a6..6c903e4517c7 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> @@ -55,6 +55,28 @@
>  #define TXGBE_TS_CTL                            0x10300
>  #define TXGBE_TS_CTL_EVAL_MD                    BIT(31)
>  
> +/* GPIO register bit */
> +#define TXGBE_GPIOBIT_0                         BIT(0) /* I:tx fault */
> +#define TXGBE_GPIOBIT_1                         BIT(1) /* O:tx disabled */
> +#define TXGBE_GPIOBIT_2                         BIT(2) /* I:sfp module absent */
> +#define TXGBE_GPIOBIT_3                         BIT(3) /* I:rx signal lost */
> +#define TXGBE_GPIOBIT_4                         BIT(4) /* O:rate select, 1G(0) 10G(1) */
> +#define TXGBE_GPIOBIT_5                         BIT(5) /* O:rate select, 1G(0) 10G(1) */
> +
> +/* Extended Interrupt Enable Set */
> +#define TXGBE_PX_MISC_ETH_LKDN                  BIT(8)
> +#define TXGBE_PX_MISC_DEV_RST                   BIT(10)
> +#define TXGBE_PX_MISC_ETH_EVENT                 BIT(17)
> +#define TXGBE_PX_MISC_ETH_LK                    BIT(18)
> +#define TXGBE_PX_MISC_ETH_AN                    BIT(19)
> +#define TXGBE_PX_MISC_INT_ERR                   BIT(20)
> +#define TXGBE_PX_MISC_GPIO                      BIT(26)
> +#define TXGBE_PX_MISC_IEN_MASK                            \
> +	(TXGBE_PX_MISC_ETH_LKDN | TXGBE_PX_MISC_DEV_RST | \
> +	 TXGBE_PX_MISC_ETH_EVENT | TXGBE_PX_MISC_ETH_LK | \
> +	 TXGBE_PX_MISC_ETH_AN | TXGBE_PX_MISC_INT_ERR |   \
> +	 TXGBE_PX_MISC_GPIO)
> +
>  /* I2C registers */
>  #define TXGBE_I2C_BASE                          0x14900
>  
> @@ -153,6 +175,7 @@ struct txgbe {
>  	struct platform_device *i2c_dev;
>  	struct clk_lookup *clock;
>  	struct clk *clk;
> +	struct gpio_chip *gpio;
>  };
>  
>  #endif /* _TXGBE_TYPE_H_ */
> -- 
> 2.27.0
> 

-- 
With Best Regards,
Andy Shevchenko



