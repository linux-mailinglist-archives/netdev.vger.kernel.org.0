Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A366BA42A
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 01:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjCOAmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 20:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjCOAmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 20:42:22 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F703584B7;
        Tue, 14 Mar 2023 17:41:32 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id z21so3926673edb.4;
        Tue, 14 Mar 2023 17:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678840890;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TAHg8nOiCVs1NOq6PIn8wnFR70zLWbhkKjcTaNb4/gw=;
        b=DEmV3uPOCIAGA+cpNM3QdkjxGkfRlJiXObSOefvlbgLUpXS8JAz9LLQunMqHkr7dgF
         vzCKW8TjDC7EFGriRe+NREBAs05R8kIzxHGN61+dJo1384wduJL5EU4prfQjn+dT//Pc
         gX9VLW3OVJli05RklkYeKEQwGSHR4HgxaSIheVd1YhRPkjlYgYGZtjkN15bz+bOV8xvL
         cGeaJsKGJ7uZLxRIpx2oUZfNcowDEtbb7FBZxnFMvJ/0WHQ6AQfRBmSJsaL+kePUWAsp
         jdSOFlbPwTPq0TWJ/e7LLo9qLAuGapN2LNBE+r/nZexcAFONhLzhBFEYTUfqglAdGLhP
         lulg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678840890;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TAHg8nOiCVs1NOq6PIn8wnFR70zLWbhkKjcTaNb4/gw=;
        b=L5gpBe67WQ7v9el8uDl49/vB8jR0KPlbqSG2AQ7BJS2frsRBUs+3mR8FkksYJfEsq9
         ig2lvOToAlJyv0gSTNO5ys9/tFQlsgY7rjNBwhD/mpNdcDG94gd3MLl3D93p6Fxw9BYR
         K4fvhON3nTeGzv7h+DdJkImBoCzYqmL+4PPVeue/6TQ1JHxvILc/AT7XCPhiCAPl6kNX
         jKgMM2z4T1wkFIfgKj8Neb5BHTw07v+kusol/l/VprzL8Yc7GoSZnMi9KoPOaBB6yLqK
         BZfg7XuaHvV0Gd9mcnXfJ0tSuTsm3BX7EaMXmVx6mAfyTvw2bDnjRtYEHDAHMNEuaD3N
         F3Pg==
X-Gm-Message-State: AO0yUKU9GDQc65IGXS6MdZE0vlnlAppD+1ekB/veBomEgHLcS9uDYY1I
        3tW3R0pBs1RFvOz/upsTAtk=
X-Google-Smtp-Source: AK7set+itPFsQRTL1Jwz67ifwH80gLwC3lxE6jGFnW7lAlvL3vXYWpmVZrHApWL3E6dmGeya4WiNHQ==
X-Received: by 2002:a17:906:25c5:b0:8af:5403:992d with SMTP id n5-20020a17090625c500b008af5403992dmr3999478ejb.28.1678840889572;
        Tue, 14 Mar 2023 17:41:29 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id qt22-20020a170906ecf600b009240a577b38sm1799523ejb.14.2023.03.14.17.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 17:41:29 -0700 (PDT)
Date:   Wed, 15 Mar 2023 02:41:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Subject: Re: [net-next PATCH v3 04/14] net: phy: Add a binding for PHY LEDs
Message-ID: <20230315004126.uy5m5fdyfz3pyym4@skbuf>
References: <20230314101516.20427-1-ansuelsmth@gmail.com>
 <20230314101516.20427-1-ansuelsmth@gmail.com>
 <20230314101516.20427-5-ansuelsmth@gmail.com>
 <20230314101516.20427-5-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314101516.20427-5-ansuelsmth@gmail.com>
 <20230314101516.20427-5-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 11:15:06AM +0100, Christian Marangi wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> Define common binding parsing for all PHY drivers with LEDs using
> phylib. Parse the DT as part of the phy_probe and add LEDs to the
> linux LED class infrastructure. For the moment, provide a dummy
> brightness function, which will later be replaced with a call into the
> PHY driver.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  drivers/net/phy/phy_device.c | 89 ++++++++++++++++++++++++++++++++++++
>  include/linux/phy.h          | 16 +++++++
>  2 files changed, 105 insertions(+)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 9ba8f973f26f..8acade42615c 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -19,10 +19,12 @@
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/kernel.h>
> +#include <linux/list.h>
>  #include <linux/mdio.h>
>  #include <linux/mii.h>
>  #include <linux/mm.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
>  #include <linux/netdevice.h>
>  #include <linux/phy.h>
>  #include <linux/phy_led_triggers.h>
> @@ -658,6 +660,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
>  	device_initialize(&mdiodev->dev);
>  
>  	dev->state = PHY_DOWN;
> +	INIT_LIST_HEAD(&dev->led_list);
>  
>  	mutex_init(&dev->lock);
>  	INIT_DELAYED_WORK(&dev->state_queue, phy_state_machine);
> @@ -2964,6 +2967,85 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
>  	return phydrv->config_intr && phydrv->handle_interrupt;
>  }
>  
> +/* Dummy implementation until calls into PHY driver are added */
> +static int phy_led_set_brightness(struct led_classdev *led_cdev,
> +				  enum led_brightness value)
> +{
> +	return 0;
> +}
> +
> +static int of_phy_led(struct phy_device *phydev,
> +		      struct device_node *led)
> +{
> +	struct device *dev = &phydev->mdio.dev;
> +	struct led_init_data init_data = {};
> +	struct led_classdev *cdev;
> +	struct phy_led *phyled;
> +	int err;
> +
> +	phyled = devm_kzalloc(dev, sizeof(*phyled), GFP_KERNEL);
> +	if (!phyled)
> +		return -ENOMEM;
> +
> +	phyled->phydev = phydev;

hmm.. not used in this patch

> +	cdev = &phyled->led_cdev;
> +	INIT_LIST_HEAD(&phyled->led_list);

I believe list elements don't need INIT_LIST_HEAD(), only the head
(phydev->led_list) does?

> +
> +	err = of_property_read_u32(led, "reg", &phyled->index);
> +	if (err)
> +		return err;
> +
> +	cdev->brightness_set_blocking = phy_led_set_brightness;
> +	cdev->max_brightness = 1;
> +	init_data.devicename = dev_name(&phydev->mdio.dev);
> +	init_data.fwnode = of_fwnode_handle(led);
> +
> +	err = devm_led_classdev_register_ext(dev, cdev, &init_data);
> +	if (err)
> +		return err;
> +
> +	list_add(&phyled->led_list, &phydev->led_list);
> +
> +	return 0;
> +}
> +
> +static int of_phy_leds(struct phy_device *phydev)
> +{
> +	struct device_node *node = phydev->mdio.dev.of_node;
> +	struct device_node *leds, *led;
> +	int err;
> +
> +	if (!IS_ENABLED(CONFIG_OF_MDIO))
> +		return 0;
> +
> +	if (!node)
> +		return 0;
> +
> +	leds = of_get_child_by_name(node, "leds");
> +	if (!leds)
> +		return 0;
> +
> +	for_each_available_child_of_node(leds, led) {
> +		err = of_phy_led(phydev, led);
> +		if (err)
> +			return err;

Agree with you that devres allows you to write yolo error teardown
code.. but of_node_put() after of_get_child_by_name()?

> +	}
> +
> +	return 0;
> +}
> +
> +static void phy_leds_remove(struct phy_device *phydev)
> +{
> +	struct device *dev = &phydev->mdio.dev;
> +	struct led_classdev *cdev;
> +	struct phy_led *phyled;
> +
> +	list_for_each_entry(phyled, &phydev->led_list, led_list) {
> +		cdev = &phyled->led_cdev;
> +		devm_led_classdev_unregister(dev, cdev);

is this really needed? shouldn't devres unregister the led classdev
after phy_remove() ends, anyway?

> +	}
> +}
> +
>  /**
>   * fwnode_mdio_find_device - Given a fwnode, find the mdio_device
>   * @fwnode: pointer to the mdio_device's fwnode
> @@ -3142,6 +3224,11 @@ static int phy_probe(struct device *dev)
>  	/* Set the state to READY by default */
>  	phydev->state = PHY_READY;
>  
> +	/* Get the LEDs from the device tree, and instantiate standard
> +	 * LEDs for them.
> +	 */
> +	of_phy_leds(phydev);

It would probably be good to treat the error code here, to not create a
precedent where invalid bindings (no "reg" for example) were accepted?

> +
>  out:
>  	/* Assert the reset signal */
>  	if (err)
> @@ -3156,6 +3243,8 @@ static int phy_remove(struct device *dev)
>  {
>  	struct phy_device *phydev = to_phy_device(dev);
>  
> +	phy_leds_remove(phydev);
> +
>  	cancel_delayed_work_sync(&phydev->state_queue);
>  
>  	mutex_lock(&phydev->lock);
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index fbeba4fee8d4..1b1efe120f0f 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -14,6 +14,7 @@
>  #include <linux/compiler.h>
>  #include <linux/spinlock.h>
>  #include <linux/ethtool.h>
> +#include <linux/leds.h>
>  #include <linux/linkmode.h>
>  #include <linux/netlink.h>
>  #include <linux/mdio.h>
> @@ -595,6 +596,7 @@ struct macsec_ops;
>   * @phy_num_led_triggers: Number of triggers in @phy_led_triggers
>   * @led_link_trigger: LED trigger for link up/down
>   * @last_triggered: last LED trigger for link speed
> + * @led_list: list of PHY LED structures
>   * @master_slave_set: User requested master/slave configuration
>   * @master_slave_get: Current master/slave advertisement
>   * @master_slave_state: Current master/slave configuration
> @@ -690,6 +692,7 @@ struct phy_device {
>  
>  	struct phy_led_trigger *led_link_trigger;
>  #endif
> +	struct list_head led_list;
>  
>  	/*
>  	 * Interrupt number for this PHY
> @@ -825,6 +828,19 @@ struct phy_plca_status {
>  	bool pst;
>  };
>  
> +/* phy_led: An LED driven by the PHY
> + *
> + * phydev: Pointer to the PHY this LED belongs to
> + * led_cdev: Standard LED class structure
> + * index: Number of the LED

led_list not described in comments

Also, does this deliberately not use the kerneldoc style /**?

Also, small nitpick, feel free to ignore it. Since it's unlikely that a
phy_led would be chained onto more than one list, I guess its "led_list"
field could be simply named "list", leaving "led_list" only to struct phy_device?

> + */
> +struct phy_led {
> +	struct list_head led_list;
> +	struct phy_device *phydev;
> +	struct led_classdev led_cdev;
> +	u32 index;
> +};
> +
>  /**
>   * struct phy_driver - Driver structure for a particular PHY type
>   *
> -- 
> 2.39.2
> 

no "depends on LEDS_CLASS" in the Kconfig?
