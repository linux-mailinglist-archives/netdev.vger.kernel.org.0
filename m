Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2EB6BEA97
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCQOBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbjCQOBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:01:41 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFDF77E1A;
        Fri, 17 Mar 2023 07:01:33 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id g18so3428603wmk.0;
        Fri, 17 Mar 2023 07:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679061692;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4g+7qXIgl8tKun1PkLdqKM5UX/0bPZp9PeHZGL6mcqI=;
        b=Snigh0B+H6j5JhCLGgbUUwp1JhKvu8IM20d9j5dQjT+KC5GT74tIxCNRVplimy7eWz
         jNdA53tmHVfKZsOnXYUYqg6uKi5xrx/DhdlDHvZqTmnOlBf4ZSWkps8LN/Bg3n6KItAy
         NpeZ37IcWO+QhgyIL5wNczMa05dWkRUvoeMD8u8ymSPN1q2zqO7L0b2aOa6haPJM9d4x
         bPZQsAXxvkFw/B7Qe2Cu0HjzqMRRiHnpkVgqw8zhhmaYV3S5ZvKBPbj//raqDHyOowBD
         LI6OsO3dxkEgQq0EbmZU6xqM2Usj6bNgyWjQdLB0QDP7RohufnSFi41i/OD0lQnaM2Fe
         KNGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679061692;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4g+7qXIgl8tKun1PkLdqKM5UX/0bPZp9PeHZGL6mcqI=;
        b=0pk/zjna86pG9IYM4erkaVQKJTODJfHkyvA3KLm/9W9moKG9PHkh+7NVsYI6C+RCAi
         yZmDH3Ayzc1/Qjc9BwhuYZFPYq8WAebfelfdub44YnrgLYBCbyyjc+03/wS4qAmdzwVQ
         MW/sGqiaQzH4tJfcirjBSkhT2FWrUhpnov1B1dehMKgn7SFnJSm+JrKnXDlriYTGIf7b
         tlUiwH/+kTpw0hSFN86TBf56kJa0av92djMov/dIGUzwLiv360TjGlPW0pw40k3/XVox
         QHiyJQkwpyY70Ok9Dspf2DwwSaSDaH6x7MEEvEFbgqYBAS2kaHI/ifiTkgyen6Aug+E1
         9vIA==
X-Gm-Message-State: AO0yUKV/odqnOkOtVsNf3ei0nEdMJZc/V4bNZ80gWW4HGRLFVVHdqURT
        BYqNcGaj3iO59okmE3r91as=
X-Google-Smtp-Source: AK7set8/6R97KAbtiwbH4u9Kk45VO85T33YCGOkTn0N5+jNA/ezDXHmspkCGlkKUPuLpm6cY/o1sTw==
X-Received: by 2002:a05:600c:4452:b0:3ed:2709:2edf with SMTP id v18-20020a05600c445200b003ed27092edfmr17344455wmn.13.1679061691799;
        Fri, 17 Mar 2023 07:01:31 -0700 (PDT)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id s11-20020a1cf20b000000b003db0bb81b6asm2392326wmc.1.2023.03.17.07.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 07:01:31 -0700 (PDT)
Message-ID: <641472bb.1c0a0220.b0870.f070@mx.google.com>
X-Google-Original-Message-ID: <ZBRyuLmxjx2Ay/cq@Ansuel-xps.>
Date:   Fri, 17 Mar 2023 15:01:28 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Michal Kubiak <michal.kubiak@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v4 02/14] net: dsa: qca8k: add LEDs basic support
References: <20230317023125.486-1-ansuelsmth@gmail.com>
 <20230317023125.486-3-ansuelsmth@gmail.com>
 <ZBRN563Zw9Z28aET@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBRN563Zw9Z28aET@localhost.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 12:24:23PM +0100, Michal Kubiak wrote:
> On Fri, Mar 17, 2023 at 03:31:13AM +0100, Christian Marangi wrote:
> > Add LEDs basic support for qca8k Switch Family by adding basic
> > brightness_set() support.
> > 
> > Since these LEDs refelect port status, the default label is set to
> > ":port". DT binding should describe the color, function and number of
> > the leds using standard LEDs api.
> > 
> > These LEDs supports only blocking variant of the brightness_set()
> > function since they can sleep during access of the switch leds to set
> > the brightness.
> > 
> > While at it add to the qca8k header file each mode defined by the Switch
> > Documentation for future use.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> 
> Hi Christian,
> 
> Please find my comments inline.
> 
> Thanks,
> Michal
> 
> > ---
> >  drivers/net/dsa/qca/Kconfig      |   8 ++
> >  drivers/net/dsa/qca/Makefile     |   3 +
> >  drivers/net/dsa/qca/qca8k-8xxx.c |   5 +
> >  drivers/net/dsa/qca/qca8k-leds.c | 192 +++++++++++++++++++++++++++++++
> >  drivers/net/dsa/qca/qca8k.h      |  59 ++++++++++
> >  drivers/net/dsa/qca/qca8k_leds.h |  16 +++
> >  6 files changed, 283 insertions(+)
> >  create mode 100644 drivers/net/dsa/qca/qca8k-leds.c
> >  create mode 100644 drivers/net/dsa/qca/qca8k_leds.h
> > 
> > diff --git a/drivers/net/dsa/qca/Kconfig b/drivers/net/dsa/qca/Kconfig
> > index ba339747362c..7a86d6d6a246 100644
> > --- a/drivers/net/dsa/qca/Kconfig
> > +++ b/drivers/net/dsa/qca/Kconfig
> > @@ -15,3 +15,11 @@ config NET_DSA_QCA8K
> >  	help
> >  	  This enables support for the Qualcomm Atheros QCA8K Ethernet
> >  	  switch chips.
> > +
> > +config NET_DSA_QCA8K_LEDS_SUPPORT
> > +	bool "Qualcomm Atheros QCA8K Ethernet switch family LEDs support"
> > +	depends on NET_DSA_QCA8K
> > +	depends on LEDS_CLASS
> > +	help
> > +	  This enabled support for LEDs present on the Qualcomm Atheros
> > +	  QCA8K Ethernet switch chips.
> > diff --git a/drivers/net/dsa/qca/Makefile b/drivers/net/dsa/qca/Makefile
> > index 701f1d199e93..ce66b1984e5f 100644
> > --- a/drivers/net/dsa/qca/Makefile
> > +++ b/drivers/net/dsa/qca/Makefile
> > @@ -2,3 +2,6 @@
> >  obj-$(CONFIG_NET_DSA_AR9331)	+= ar9331.o
> >  obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
> >  qca8k-y 			+= qca8k-common.o qca8k-8xxx.o
> > +ifdef CONFIG_NET_DSA_QCA8K_LEDS_SUPPORT
> > +qca8k-y				+= qca8k-leds.o
> > +endif
> > diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
> > index 8dfc5db84700..5decf6fe3832 100644
> > --- a/drivers/net/dsa/qca/qca8k-8xxx.c
> > +++ b/drivers/net/dsa/qca/qca8k-8xxx.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/dsa/tag_qca.h>
> >  
> >  #include "qca8k.h"
> > +#include "qca8k_leds.h"
> >  
> >  static void
> >  qca8k_split_addr(u32 regaddr, u16 *r1, u16 *r2, u16 *page)
> > @@ -1727,6 +1728,10 @@ qca8k_setup(struct dsa_switch *ds)
> >  	if (ret)
> >  		return ret;
> >  
> > +	ret = qca8k_setup_led_ctrl(priv);
> > +	if (ret)
> > +		return ret;
> > +
> >  	qca8k_setup_pcs(priv, &priv->pcs_port_0, 0);
> >  	qca8k_setup_pcs(priv, &priv->pcs_port_6, 6);
> >  
> > diff --git a/drivers/net/dsa/qca/qca8k-leds.c b/drivers/net/dsa/qca/qca8k-leds.c
> > new file mode 100644
> > index 000000000000..adbe7f6e2994
> > --- /dev/null
> > +++ b/drivers/net/dsa/qca/qca8k-leds.c
> > @@ -0,0 +1,192 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/regmap.h>
> > +#include <net/dsa.h>
> > +
> > +#include "qca8k.h"
> > +#include "qca8k_leds.h"
> > +
> > +static int
> > +qca8k_get_enable_led_reg(int port_num, int led_num, struct qca8k_led_pattern_en *reg_info)
> > +{
> > +	switch (port_num) {
> > +	case 0:
> > +		reg_info->reg = QCA8K_LED_CTRL_REG(led_num);
> > +		reg_info->shift = QCA8K_LED_PHY0123_CONTROL_RULE_SHIFT;
> > +		break;
> > +	case 1:
> > +	case 2:
> > +	case 3:
> > +		/* Port 123 are controlled on a different reg */
> > +		reg_info->reg = QCA8K_LED_CTRL_REG(3);
> > +		reg_info->shift = QCA8K_LED_PHY123_PATTERN_EN_SHIFT(port_num, led_num);
> > +		break;
> > +	case 4:
> > +		reg_info->reg = QCA8K_LED_CTRL_REG(led_num);
> > +		reg_info->shift = QCA8K_LED_PHY4_CONTROL_RULE_SHIFT;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int
> > +qca8k_led_brightness_set(struct qca8k_led *led,
> > +			 enum led_brightness brightness)
> > +{
> > +	struct qca8k_led_pattern_en reg_info;
> > +	struct qca8k_priv *priv = led->priv;
> > +	u32 mask, val = QCA8K_LED_ALWAYS_OFF;
> 
> Nitpick: RCT
> 
> > +
> > +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> > +
> > +	if (brightness)
> > +		val = QCA8K_LED_ALWAYS_ON;
> > +
> > +	if (led->port_num == 0 || led->port_num == 4) {
> > +		mask = QCA8K_LED_PATTERN_EN_MASK;
> > +		val <<= QCA8K_LED_PATTERN_EN_SHIFT;
> > +	} else {
> > +		mask = QCA8K_LED_PHY123_PATTERN_EN_MASK;
> > +	}
> > +
> > +	return regmap_update_bits(priv->regmap, reg_info.reg,
> > +				  mask << reg_info.shift,
> > +				  val << reg_info.shift);
> > +}
> > +
> > +static int
> > +qca8k_cled_brightness_set_blocking(struct led_classdev *ldev,
> > +				   enum led_brightness brightness)
> > +{
> > +	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
> > +
> > +	return qca8k_led_brightness_set(led, brightness);
> > +}
> > +
> > +static enum led_brightness
> > +qca8k_led_brightness_get(struct qca8k_led *led)
> > +{
> > +	struct qca8k_led_pattern_en reg_info;
> > +	struct qca8k_priv *priv = led->priv;
> > +	u32 val;
> > +	int ret;
> > +
> > +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> > +
> > +	ret = regmap_read(priv->regmap, reg_info.reg, &val);
> > +	if (ret)
> > +		return 0;
> > +
> > +	val >>= reg_info.shift;
> > +
> > +	if (led->port_num == 0 || led->port_num == 4) {
> > +		val &= QCA8K_LED_PATTERN_EN_MASK;
> > +		val >>= QCA8K_LED_PATTERN_EN_SHIFT;
> > +	} else {
> > +		val &= QCA8K_LED_PHY123_PATTERN_EN_MASK;
> > +	}
> > +
> > +	/* Assume brightness ON only when the LED is set to always ON */
> > +	return val == QCA8K_LED_ALWAYS_ON;
> > +}
> > +
> > +static int
> > +qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int port_num)
> > +{
> > +	struct fwnode_handle *led = NULL, *leds = NULL;
> > +	struct led_init_data init_data = { };
> > +	enum led_default_state state;
> > +	struct qca8k_led *port_led;
> > +	int led_num, port_index;
> > +	int ret;
> > +
> > +	leds = fwnode_get_named_child_node(port, "leds");
> > +	if (!leds) {
> > +		dev_dbg(priv->dev, "No Leds node specified in device tree for port %d!\n",
> > +			port_num);
> > +		return 0;
> > +	}
> > +
> > +	fwnode_for_each_child_node(leds, led) {
> > +		/* Reg represent the led number of the port.
> > +		 * Each port can have at least 3 leds attached
> > +		 * Commonly:
> > +		 * 1. is gigabit led
> > +		 * 2. is mbit led
> > +		 * 3. additional status led
> > +		 */
> > +		if (fwnode_property_read_u32(led, "reg", &led_num))
> > +			continue;
> > +
> > +		if (led_num >= QCA8K_LED_PORT_COUNT) {
> > +			dev_warn(priv->dev, "Invalid LED reg defined %d", port_num);
> > +			continue;
> > +		}
> 
> In the comment above you say "each port can have AT LEAST 3 leds".
> However, now it seems that if the port has more than 3 leds, all the
> remaining leds are not initialized.
> Is this intentional? If so, maybe it is worth describing in the comment
> that for ports with more than 3 leds, only the first 3 leds are
> initialized?
> 
> According to the code it looks like the port can have up to 3 leds.
>

Think I should rework the comments and make them more direct/simple.

qca8k switch have a max of 5 port.

each port CAN have a max of 3 leds connected.

It's really a limitation of pin on the switch chip and hw regs so the
situation can't happen.

> > +
> > +		port_index = 3 * port_num + led_num;
> 
> Can QCA8K_LED_PORT_COUNT be used instead of "3"? I guess it is the number
> of LEDs per port.
> 

This variable it's really to make it easier to reference the led in the
priv struct. If asked I can rework this to an array of array (one per
port and each port out of 3 possigle LED).

> > +
> > +		port_led = &priv->ports_led[port_index];
> 
> Also, the name of the "port_index" variable seems confusing to me. It is
> not an index of the port, but rather a unique index of the LED across
> all ports, right?
> 

As said above, they are unique index that comes from port and LED of the
port. Really something to represent the code easier internally.

> > +		port_led->port_num = port_num;
> > +		port_led->led_num = led_num;
> > +		port_led->priv = priv;
> > +
> > +		state = led_init_default_state_get(led);
> > +		switch (state) {
> > +		case LEDS_DEFSTATE_ON:
> > +			port_led->cdev.brightness = 1;
> > +			qca8k_led_brightness_set(port_led, 1);
> > +			break;
> > +		case LEDS_DEFSTATE_KEEP:
> > +			port_led->cdev.brightness =
> > +					qca8k_led_brightness_get(port_led);
> > +			break;
> > +		default:
> > +			port_led->cdev.brightness = 0;
> > +			qca8k_led_brightness_set(port_led, 0);
> > +		}
> > +
> > +		port_led->cdev.max_brightness = 1;
> > +		port_led->cdev.brightness_set_blocking = qca8k_cled_brightness_set_blocking;
> > +		init_data.default_label = ":port";
> > +		init_data.devicename = "qca8k";
> > +		init_data.fwnode = led;
> > +
> > +		ret = devm_led_classdev_register_ext(priv->dev, &port_led->cdev, &init_data);
> > +		if (ret)
> > +			dev_warn(priv->dev, "Failed to int led");
> 
> Typo: "init".
> How about adding an index of the LED that could not be initialized?
> 

Ok will add more info in the port and led that failed to init.

> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +int
> > +qca8k_setup_led_ctrl(struct qca8k_priv *priv)
> > +{
> > +	struct fwnode_handle *ports, *port;
> > +	int port_num;
> > +	int ret;
> > +
> > +	ports = device_get_named_child_node(priv->dev, "ports");
> > +	if (!ports) {
> > +		dev_info(priv->dev, "No ports node specified in device tree!\n");
> > +		return 0;
> > +	}
> > +
> > +	fwnode_for_each_child_node(ports, port) {
> > +		if (fwnode_property_read_u32(port, "reg", &port_num))
> > +			continue;
> > +
> > +		/* Each port can have at least 3 different leds attached.
> > +		 * Switch port starts from 0 to 6, but port 0 and 6 are CPU
> > +		 * port. The port index needs to be decreased by one to identify
> > +		 * the correct port for LED setup.
> > +		 */
> 
> Again, are there really "at least 3 different leds" per port?
> It's confusing a little bit, because  QCA8K_LED_PORT_COUNT == 3, so I
> would say it cannot have more than 3.
> 
> > +		ret = qca8k_parse_port_leds(priv, port, qca8k_port_to_phy(port_num));
> 
> As I checked, the function "qca8k_port_to_phy()" can return all 0xFFs
> for port_num == 0. Then, this value is implicitly casted to int (as the
> last parameter of "qca8k_parse_port_leds()"). Internally, in
> "qca8k_parse_port_leds()" this parameter can be used to do some
> computing - that looks dangerous.
> In summary, I think a special check for CPU port_num == 0 should be
> added.
> (I guess the LED configuration i only makes sense for non-CPU ports? It
> seems you want to configure up to 15 LEDs in total for 5 ports).
> 

IMHO for this, we can ignore handling this corner case. The hw doesn't
supports leds for port0 and port6 (the 2 CPU port) so the case won't
ever apply. But if asked I can add the case, not that it will cause any
problem in how the regs and shift are referenced in the code.

> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
> > index 4e48e4dd8b0f..3c3c072fa9c2 100644
> > --- a/drivers/net/dsa/qca/qca8k.h
> > +++ b/drivers/net/dsa/qca/qca8k.h
> > @@ -11,6 +11,7 @@
> >  #include <linux/delay.h>
> >  #include <linux/regmap.h>
> >  #include <linux/gpio.h>
> > +#include <linux/leds.h>
> >  #include <linux/dsa/tag_qca.h>
> >  
> >  #define QCA8K_ETHERNET_MDIO_PRIORITY			7
> > @@ -85,6 +86,50 @@
> >  #define   QCA8K_MDIO_MASTER_DATA(x)			FIELD_PREP(QCA8K_MDIO_MASTER_DATA_MASK, x)
> >  #define   QCA8K_MDIO_MASTER_MAX_PORTS			5
> >  #define   QCA8K_MDIO_MASTER_MAX_REG			32
> > +
> > +/* LED control register */
> > +#define QCA8K_LED_COUNT					15
> > +#define QCA8K_LED_PORT_COUNT				3
> > +#define QCA8K_LED_RULE_COUNT				6
> > +#define QCA8K_LED_RULE_MAX				11
> > +
> > +#define QCA8K_LED_PHY123_PATTERN_EN_SHIFT(_phy, _led)	((((_phy) - 1) * 6) + 8 + (2 * (_led)))
> > +#define QCA8K_LED_PHY123_PATTERN_EN_MASK		GENMASK(1, 0)
> > +
> > +#define QCA8K_LED_PHY0123_CONTROL_RULE_SHIFT		0
> > +#define QCA8K_LED_PHY4_CONTROL_RULE_SHIFT		16
> > +
> > +#define QCA8K_LED_CTRL_REG(_i)				(0x050 + (_i) * 4)
> > +#define QCA8K_LED_CTRL0_REG				0x50
> > +#define QCA8K_LED_CTRL1_REG				0x54
> > +#define QCA8K_LED_CTRL2_REG				0x58
> > +#define QCA8K_LED_CTRL3_REG				0x5C
> > +#define   QCA8K_LED_CTRL_SHIFT(_i)			(((_i) % 2) * 16)
> > +#define   QCA8K_LED_CTRL_MASK				GENMASK(15, 0)
> > +#define QCA8K_LED_RULE_MASK				GENMASK(13, 0)
> > +#define QCA8K_LED_BLINK_FREQ_MASK			GENMASK(1, 0)
> > +#define QCA8K_LED_BLINK_FREQ_SHITF			0
> > +#define   QCA8K_LED_BLINK_2HZ				0
> > +#define   QCA8K_LED_BLINK_4HZ				1
> > +#define   QCA8K_LED_BLINK_8HZ				2
> > +#define   QCA8K_LED_BLINK_AUTO				3
> > +#define QCA8K_LED_LINKUP_OVER_MASK			BIT(2)
> > +#define QCA8K_LED_TX_BLINK_MASK				BIT(4)
> > +#define QCA8K_LED_RX_BLINK_MASK				BIT(5)
> > +#define QCA8K_LED_COL_BLINK_MASK			BIT(7)
> > +#define QCA8K_LED_LINK_10M_EN_MASK			BIT(8)
> > +#define QCA8K_LED_LINK_100M_EN_MASK			BIT(9)
> > +#define QCA8K_LED_LINK_1000M_EN_MASK			BIT(10)
> > +#define QCA8K_LED_POWER_ON_LIGHT_MASK			BIT(11)
> > +#define QCA8K_LED_HALF_DUPLEX_MASK			BIT(12)
> > +#define QCA8K_LED_FULL_DUPLEX_MASK			BIT(13)
> > +#define QCA8K_LED_PATTERN_EN_MASK			GENMASK(15, 14)
> > +#define QCA8K_LED_PATTERN_EN_SHIFT			14
> > +#define   QCA8K_LED_ALWAYS_OFF				0
> > +#define   QCA8K_LED_ALWAYS_BLINK_4HZ			1
> > +#define   QCA8K_LED_ALWAYS_ON				2
> > +#define   QCA8K_LED_RULE_CONTROLLED			3
> > +
> >  #define QCA8K_GOL_MAC_ADDR0				0x60
> >  #define QCA8K_GOL_MAC_ADDR1				0x64
> >  #define QCA8K_MAX_FRAME_SIZE				0x78
> > @@ -383,6 +428,19 @@ struct qca8k_pcs {
> >  	int port;
> >  };
> >  
> > +struct qca8k_led_pattern_en {
> > +	u32 reg;
> > +	u8 shift;
> > +};
> > +
> > +struct qca8k_led {
> > +	u8 port_num;
> > +	u8 led_num;
> > +	u16 old_rule;
> > +	struct qca8k_priv *priv;
> > +	struct led_classdev cdev;
> > +};
> > +
> >  struct qca8k_priv {
> >  	u8 switch_id;
> >  	u8 switch_revision;
> > @@ -407,6 +465,7 @@ struct qca8k_priv {
> >  	struct qca8k_pcs pcs_port_0;
> >  	struct qca8k_pcs pcs_port_6;
> >  	const struct qca8k_match_data *info;
> > +	struct qca8k_led ports_led[QCA8K_LED_COUNT];
> >  };
> >  
> >  struct qca8k_mib_desc {
> > diff --git a/drivers/net/dsa/qca/qca8k_leds.h b/drivers/net/dsa/qca/qca8k_leds.h
> > new file mode 100644
> > index 000000000000..ab367f05b173
> > --- /dev/null
> > +++ b/drivers/net/dsa/qca/qca8k_leds.h
> > @@ -0,0 +1,16 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +
> > +#ifndef __QCA8K_LEDS_H
> > +#define __QCA8K_LEDS_H
> > +
> > +/* Leds Support function */
> > +#ifdef CONFIG_NET_DSA_QCA8K_LEDS_SUPPORT
> > +int qca8k_setup_led_ctrl(struct qca8k_priv *priv);
> > +#else
> > +static inline int qca8k_setup_led_ctrl(struct qca8k_priv *priv)
> > +{
> > +	return 0;
> > +}
> > +#endif
> > +
> > +#endif /* __QCA8K_LEDS_H */
> > -- 
> > 2.39.2
> > 

-- 
	Ansuel
