Return-Path: <netdev+bounces-4179-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61F8D70B856
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 11:03:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E46FE1C20A04
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BAE079EA;
	Mon, 22 May 2023 09:02:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA7663CB
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 09:02:56 +0000 (UTC)
Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24A4FF
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 02:02:54 -0700 (PDT)
X-QQ-mid:Yeas47t1684746045t472t60201
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [122.235.247.1])
X-QQ-SSF:00400000000000F0FNF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 9655095480155216521
To: "'Andrew Lunn'" <andrew@lunn.ch>,
	"'Michael Walle'" <michael@walle.cc>
Cc: "'Andy Shevchenko'" <andy.shevchenko@gmail.com>,
	<netdev@vger.kernel.org>,
	<jarkko.nikula@linux.intel.com>,
	<andriy.shevchenko@linux.intel.com>,
	<mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>,
	<Jose.Abreu@synopsys.com>,
	<hkallweit1@gmail.com>,
	<linux@armlinux.org.uk>,
	<linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>,
	<mengyuanlou@net-swift.com>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com> <20230515063200.301026-7-jiawenwu@trustnetic.com> <ZGH-fRzbGd_eCASk@surfacebook> <00cd01d9879f$8e444950$aaccdbf0$@trustnetic.com> <CAHp75VdthEZL6GvT5Q=f7rbcDfA5XX=7-VLfVz1kZmBFem_eCA@mail.gmail.com> <016701d9886a$f9b415a0$ed1c40e0$@trustnetic.com> <90ef7fb8-feac-4288-98e9-6e67cd38cdf1@lunn.ch> <025b01d9897e$d8894660$899bd320$@trustnetic.com> <1e1615b3-566c-490c-8b1a-78f5521ca0b0@lunn.ch> <028601d989f9$230ee120$692ca360$@trustnetic.com> <f0b571ab-544b-49c3-948f-d592f931673b@lunn.ch>
In-Reply-To: <f0b571ab-544b-49c3-948f-d592f931673b@lunn.ch>
Subject: RE: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
Date: Mon, 22 May 2023 17:00:44 +0800
Message-ID: <005a01d98c8b$e48d2b60$ada78220$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHvj8QD3pC+6Aq9H9h6P1+q5LrHRgMH5FTyAkITzAABJU2Y7wJ7xjhgAYjDQqsBr+FHUgDJ87o1AYTHtNcC/cxtnwIXsv+Orp2toMA=
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Friday, May 19, 2023 9:13 PM, Andrew Lunn wrote:
> > I have one MSI-X interrupt for all general MAC interrupt (see TXGBE_PX_MISC_IEN_MASK).
> > It has 32 bits to indicate various interrupts, GPIOs are the one of them. When GPIO
> > interrupt is determined, GPIO_INT_STATUS register should be read to determine
> > which GPIO line has changed state.
> 
> So you have another interrupt controller above the GPIO interrupt
> controller. regmap-gpio is pushing you towards describing this
> interrupt controller as a Linux interrupt controller.
> 
> When you look at drivers handling interrupts, most leaf interrupt
> controllers are not described as Linux interrupt controllers. The
> driver interrupt handler reads the interrupt status register and
> internally dispatches to the needed handler. This works well when
> everything is internal to one driver.
> 
> However, here, you have two drivers involved, your MAC driver and a
> GPIO driver instantiated by the MAC driver. So i think you are going
> to need to described the MAC interrupt controller as a Linux interrupt
> controller.
> 
> Take a look at the mv88e6xxx driver, which does this. It has two
> interrupt controller embedded within it, and they are chained.

Now I add two interrupt controllers, the first one for the MAC interrupt,
and the second one for regmap-gpio. In the second adding flow,

	irq = irq_find_mapping(txgbe->misc.domain, TXGBE_PX_MISC_GPIO_OFFSET);
	err = regmap_add_irq_chip_fwnode(fwnode, regmap, irq, 0, 0,
					 chip, &chip_data);

and then,

	config.irq_domain = regmap_irq_get_domain(chip_data);
	gpio_regmap = gpio_regmap_register(&config);

"txgbe->misc.domain" is the MAC interrupt domain. I think this flow should
be correct, but still failed to get gpio_irq from gpio_desc with err -517.

And I still have doubts about what I said earlier:
https://lore.kernel.org/netdev/20230515063200.301026-1-jiawenwu@trustnetic.com/T/#me1be68e1a1e44426ecc0dd8edf0f6b224e50630d

There really is nothing wrong with gpiochip_to_irq()??

> > > If you are getting errors when removing the driver it means you are
> > > missing some level of undoing what us done in probe. Are you sure
> > > regmap_del_irq_chip() is being called on unload?
> >
> > I used devm_* all when I registered them.
> 
> Look at the ordering. Is regmap_del_irq_chip() being called too late?
> I've had problems like this with the mv88e6xxx driver and its
> interrupt controllers. I ended up not using devm_ so i had full
> control over the order things got undone. In that case, the external
> devices was PHYs, with the PHY interrupt being inside the Ethernet
> switch, which i exposed using a Linux interrupt controller.

I use no devm_ functions to add regmap irq chip, register gpio regmap,
and call their del/unregister functions at the position corresponding to
release. irq_domain_remove() call trace still exist.

[  104.553182] Call Trace:
[  104.553184]  <TASK>
[  104.553185]  irq_domain_remove+0x2b/0xe0
[  104.553190]  regmap_del_irq_chip.part.0+0x8a/0x160
[  104.553196]  txgbe_remove_phy+0x57/0x80 [txgbe]
[  104.553201]  txgbe_remove+0x2a/0x90 [txgbe]
[  104.553205]  pci_device_remove+0x36/0xa0
[  104.553208]  device_release_driver_internal+0xaa/0x140
[  104.553213]  driver_detach+0x44/0x90
[  104.553215]  bus_remove_driver+0x69/0xf0
[  104.553217]  pci_unregister_driver+0x29/0xb0
[  104.553220]  __x64_sys_delete_module+0x145/0x240
[  104.553223]  ? exit_to_user_mode_prepare+0x3c/0x1a0
[  104.553226]  do_syscall_64+0x3b/0x90
[  104.553230]  entry_SYSCALL_64_after_hwframe+0x72/0xdc



