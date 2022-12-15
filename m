Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C007B64DF5B
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 18:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiLORJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 12:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiLORJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 12:09:10 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14F7419B2;
        Thu, 15 Dec 2022 09:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=v5d0bQGPRoYnLsq5BgFVSq7oqPOujJNfyKS9Udb3ZkY=; b=ZQ+dKL4q1ZP+44k8iuDugTNdWz
        F8XRtShc6OTIfEvFvh5kGrXM7WzzImJH4d3C6l7kGbS9Rlb+7fpX9c2DSUokpNmJBv58K4nJa+Tt/
        yHHmYUELmoqCgTl+5x5uarPJsBY7bm2GfAOgZQ4BHXkodn+ooDFuV4h/AO3Q+owmTI0FKzqIte4HP
        +pIBZnUoHWMY19Qt9XjRbndb83j2A4bfU3ZToADTIgWfPOcovx3VGeCPqmFpY3B2KL5HxZ42L1ijZ
        yPcTMfAIuF/qTwL29r2f1jTW8tLvG7aycqwHorqlOvaAjKU/gsvpOIzRBX6lUreky5Mdl+v5j/iU0
        yzVvCBdQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35726)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p5rhm-0003R8-SN; Thu, 15 Dec 2022 17:07:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p5rhj-0008Vc-U9; Thu, 15 Dec 2022 17:07:31 +0000
Date:   Thu, 15 Dec 2022 17:07:31 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH v7 06/11] leds: trigger: netdev: add hardware control
 support
Message-ID: <Y5tUU5zA/lkYJza+@shell.armlinux.org.uk>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-7-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214235438.30271-7-ansuelsmth@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 12:54:33AM +0100, Christian Marangi wrote:
> Add hardware control support for the Netdev trigger.
> The trigger on config change will check if the requested trigger can set
> to blink mode using LED hardware mode and if every blink mode is supported,
> the trigger will enable hardware mode with the requested configuration.
> If there is at least one trigger that is not supported and can't run in
> hardware mode, then software mode will be used instead.
> A validation is done on every value change and on fail the old value is
> restored and -EINVAL is returned.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  drivers/leds/trigger/ledtrig-netdev.c | 155 +++++++++++++++++++++++++-
>  1 file changed, 149 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
> index dd63cadb896e..ed019cb5867c 100644
> --- a/drivers/leds/trigger/ledtrig-netdev.c
> +++ b/drivers/leds/trigger/ledtrig-netdev.c
> @@ -37,6 +37,7 @@
>   */
>  
>  struct led_netdev_data {
> +	enum led_blink_modes blink_mode;
>  	spinlock_t lock;
>  
>  	struct delayed_work work;
> @@ -53,11 +54,105 @@ struct led_netdev_data {
>  	bool carrier_link_up;
>  };
>  
> +struct netdev_led_attr_detail {
> +	char *name;
> +	bool hardware_only;
> +	enum led_trigger_netdev_modes bit;
> +};
> +
> +static struct netdev_led_attr_detail attr_details[] = {
> +	{ .name = "link", .bit = TRIGGER_NETDEV_LINK},
> +	{ .name = "tx", .bit = TRIGGER_NETDEV_TX},
> +	{ .name = "rx", .bit = TRIGGER_NETDEV_RX},
> +};
> +
> +static bool validate_baseline_state(struct led_netdev_data *trigger_data)
> +{
> +	struct led_classdev *led_cdev = trigger_data->led_cdev;
> +	struct netdev_led_attr_detail *detail;
> +	u32 hw_blink_mode_supported = 0;
> +	bool force_sw = false;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(attr_details); i++) {
> +		detail = &attr_details[i];
> +
> +		/* Mode not active, skip */
> +		if (!test_bit(detail->bit, &trigger_data->mode))
> +			continue;
> +
> +		/* Hardware only mode enabled on software controlled led */
> +		if (led_cdev->blink_mode == SOFTWARE_CONTROLLED &&
> +		    detail->hardware_only)
> +			return false;
> +
> +		/* Check if the mode supports hardware mode */
> +		if (led_cdev->blink_mode != SOFTWARE_CONTROLLED) {
> +			/* With a net dev set, force software mode.
> +			 * With modes are handled by hardware, led will blink
> +			 * based on his own events and will ignore any event
> +			 * from the provided dev.
> +			 */
> +			if (trigger_data->net_dev) {
> +				force_sw = true;
> +				continue;
> +			}
> +
> +			/* With empty dev, check if the mode is supported */
> +			if (led_trigger_blink_mode_is_supported(led_cdev, detail->bit))
> +				hw_blink_mode_supported |= BIT(detail->bit);
> +		}
> +	}
> +
> +	/* We can't run modes handled by both software and hardware.
> +	 * Check if we run hardware modes and check if all the modes
> +	 * can be handled by hardware.
> +	 */
> +	if (hw_blink_mode_supported && hw_blink_mode_supported != trigger_data->mode)
> +		return false;
> +
> +	/* Modes are valid. Decide now the running mode to later
> +	 * set the baseline.
> +	 * Software mode is enforced with net_dev set. With an empty
> +	 * one hardware mode is selected by default (if supported).
> +	 */
> +	if (force_sw || led_cdev->blink_mode == SOFTWARE_CONTROLLED)
> +		trigger_data->blink_mode = SOFTWARE_CONTROLLED;
> +	else
> +		trigger_data->blink_mode = HARDWARE_CONTROLLED;
> +
> +	return true;
> +}
> +
>  static void set_baseline_state(struct led_netdev_data *trigger_data)
>  {
> +	int i;
>  	int current_brightness;
> +	struct netdev_led_attr_detail *detail;
>  	struct led_classdev *led_cdev = trigger_data->led_cdev;
>  
> +	/* Modes already validated. Directly apply hw trigger modes */
> +	if (trigger_data->blink_mode == HARDWARE_CONTROLLED) {
> +		/* We are refreshing the blink modes. Reset them */
> +		led_cdev->hw_control_configure(led_cdev, BIT(TRIGGER_NETDEV_LINK),
> +					       BLINK_MODE_ZERO);
> +
> +		for (i = 0; i < ARRAY_SIZE(attr_details); i++) {
> +			detail = &attr_details[i];
> +
> +			if (!test_bit(detail->bit, &trigger_data->mode))
> +				continue;
> +
> +			led_cdev->hw_control_configure(led_cdev, BIT(detail->bit),
> +						       BLINK_MODE_ENABLE);
> +		}
> +
> +		led_cdev->hw_control_start(led_cdev);
> +
> +		return;
> +	}
> +
> +	/* Handle trigger modes by software */
>  	current_brightness = led_cdev->brightness;
>  	if (current_brightness)
>  		led_cdev->blink_brightness = current_brightness;
> @@ -100,10 +195,15 @@ static ssize_t device_name_store(struct device *dev,
>  				 size_t size)
>  {
>  	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
> +	struct net_device *old_net = trigger_data->net_dev;
> +	char old_device_name[IFNAMSIZ];
>  
>  	if (size >= IFNAMSIZ)
>  		return -EINVAL;
>  
> +	/* Backup old device name */
> +	memcpy(old_device_name, trigger_data->device_name, IFNAMSIZ);
> +
>  	cancel_delayed_work_sync(&trigger_data->work);
>  
>  	spin_lock_bh(&trigger_data->lock);
> @@ -122,6 +222,19 @@ static ssize_t device_name_store(struct device *dev,
>  		trigger_data->net_dev =
>  		    dev_get_by_name(&init_net, trigger_data->device_name);
>  
> +	if (!validate_baseline_state(trigger_data)) {
> +		/* Restore old net_dev and device_name */
> +		if (trigger_data->net_dev)
> +			dev_put(trigger_data->net_dev);
> +
> +		dev_hold(old_net);
> +		trigger_data->net_dev = old_net;
> +		memcpy(trigger_data->device_name, old_device_name, IFNAMSIZ);
> +
> +		spin_unlock_bh(&trigger_data->lock);
> +		return -EINVAL;

I'm not sure this is the best way... putting the net_dev but holding a
reference, to leter regain the reference via dev_hold() just feels
wrong. Also, I wonder what happens if two threads try to change the
netdev together - will the read of the old device name be potentially
corrupted (since we're not holding the trigger's lock?)

Maybe instead:

+	struct net_device *old_net;
...
-	if (trigger_data->net_dev) {
-		dev_put(trigger_data->net_dev);
-		trigger_data->net_dev = NULL;
-	}
+	old_net = trigger_data->net_dev;
+	trigger_data->net_dev = NULL;
+	memcpy(old_device_name, trigger_data->device_name, IFNAMSIZ);
...
	... extract out the setup of trigger_data->device_name
...
+	if (!validate_baseline_state(trigger_data)) {
+		if (trigger_data->net_dev)
+			dev_put(trigger_data->net_dev);
+
+		/* Restore device settings */
+		trigger_data->net_dev = old_dev;
+		memcpy(trigger_data->device_name, old_device_name, IFNAMSIZ);
+		spin_unlock_bh(&trigger_data->lock);
+		return -EINVAL;
+	} else {
+		dev_put(old_net);
+	}

would be safer all round?

One thought on this approach though - if one has a PHY that supports
"activity" but not independent "rx" and "tx" activity indications
and it doesn't support software control, how would one enable activity
mode? There isn't a way to simultaneously enable both at the same
time... However, I need to check whether there are any PHYs that fall
into this category.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
