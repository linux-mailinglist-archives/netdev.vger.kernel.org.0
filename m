Return-Path: <netdev+bounces-11747-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42A137342A0
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 19:28:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1512D1C20A39
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 17:28:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4107C12D;
	Sat, 17 Jun 2023 17:28:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5141117
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 17:28:16 +0000 (UTC)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C85410C0;
	Sat, 17 Jun 2023 10:28:13 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-3110a5f2832so2176706f8f.1;
        Sat, 17 Jun 2023 10:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687022891; x=1689614891;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pRpy2AnhH2ZMjGAfpIPfEpDanD+6NbvOfkr4t+kxdoQ=;
        b=RgW2uOXY+mvivcHDQE7eECiEwIestzNrWj0lXiPxd1G+d5aWDF/DjJTUYHZRtum8vU
         dDmxurXIiyqU/FyXt8/64qjGhLDNmlNbQp0V3gy83CXJt0drurgmns5KrrGgJ0Xf4+J8
         v/sEWApg1v/vjZeGIYyXXpArMTxDIEYDcwnUZUUudDU186b5HYXabgvrdtt4AhjxnfoO
         YkTXaQHBjQj4RA0UBoxZ1GuAspYpfi9dwhFpvhFKZgFQ6s0x2n+Ftb0MI7gsb8+UtVdV
         L9roPqpMLj1UfiUik3WrJ5MMsOkElt/8brTNQZQZ/8BH2y3QUIORbXDwfi1g1iPahZTe
         VMIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687022891; x=1689614891;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pRpy2AnhH2ZMjGAfpIPfEpDanD+6NbvOfkr4t+kxdoQ=;
        b=U9DQf/STkCjq7Cl/EI4vr+C1VH7R1M90RcrTAcjz68FYjun0NXAzisereaSv2LoEnW
         zOZVGHGSauilsNrBIAZWovRAbcN64VlJB5UegqPbXoCXX7SolpgD/4AnZ/BsOvaqUR2A
         sS9vOZ59SdwnwVBSPzUY/c1Xfflxbb3BWDhuhkcKLlgvK31hAjZCoRU31f15VJcE0ZZ8
         PhDz8d7dNcimzuxVaU0YPcsdc6wyH2NZwr8RlPB4rP4wwyAlAPE1n3eIpR0Z9QPNur7W
         6mA1/jxZtt0QhkaA1ejljTPiDb4lIOYCiR0lsu6dQbiWh2zzdlRkjGuKcPyyW15GVrmh
         nTmg==
X-Gm-Message-State: AC+VfDwg9xaOM589ldptcAtDAxbIgrW+IQ1/Tijq4df0JaIHMIF4er3E
	/tLfHqDPSz+usnRliW4AnP8=
X-Google-Smtp-Source: ACHHUZ4XWsVdF0C2JhD0W5qfz10nT0gPbz9KjfgHWFIqC7kc3M+xVBXaKrKxjAC7ViSlnQ4JuP3ytg==
X-Received: by 2002:a5d:430d:0:b0:30f:d052:2edb with SMTP id h13-20020a5d430d000000b0030fd0522edbmr7884535wrq.35.1687022891209;
        Sat, 17 Jun 2023 10:28:11 -0700 (PDT)
Received: from Ansuel-xps. (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.gmail.com with ESMTPSA id r18-20020adfce92000000b0031128382ed0sm2999839wrn.83.2023.06.17.10.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jun 2023 10:28:10 -0700 (PDT)
Message-ID: <648ded2a.df0a0220.b78de.4603@mx.google.com>
X-Google-Original-Message-ID: <ZIzT3yBcHdmuGKi4@Ansuel-xps.>
Date: Fri, 16 Jun 2023 23:27:59 +0200
From: Christian Marangi <ansuelsmth@gmail.com>
To: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Sebastian Gottschall <s.gottschall@dd-wrt.com>,
	Steve deRosier <derosier@cal-sierra.com>,
	Stefan Lippers-Hollmann <s.l-h@gmx.de>
Subject: Re: [PATCH v14] ath10k: add LED and GPIO controlling support for
 various chipsets
References: <20230611080505.17393-1-ansuelsmth@gmail.com>
 <878rcjbaqs.fsf@kernel.org>
 <648cdebb.5d0a0220.be7f8.a096@mx.google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ISiK3ICplRRKwxPi"
Content-Disposition: inline
In-Reply-To: <648cdebb.5d0a0220.be7f8.a096@mx.google.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--ISiK3ICplRRKwxPi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 16, 2023 at 01:35:04PM +0200, Christian Marangi wrote:
> On Fri, Jun 16, 2023 at 08:03:23PM +0300, Kalle Valo wrote:
> > Christian Marangi <ansuelsmth@gmail.com> writes:
> > 
> > > From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
> > >
> > > Adds LED and GPIO Control support for 988x, 9887, 9888, 99x0, 9984
> > > based chipsets with on chipset connected led's using WMI Firmware API.
> > > The LED device will get available named as "ath10k-phyX" at sysfs and
> > > can be controlled with various triggers.
> > > Adds also debugfs interface for gpio control.
> > >
> > > Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
> > > Reviewed-by: Steve deRosier <derosier@cal-sierra.com>
> > > [kvalo: major reorg and cleanup]
> > > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> > > [ansuel: rebase and small cleanup]
> > > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > > Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
> > > ---
> > >
> > > Hi,
> > > this is a very old patch from 2018 that somehow was talked till 2020
> > > with Kavlo asked to rebase and resubmit and nobody did.
> > > So here we are in 2023 with me trying to finally have this upstream.
> > >
> > > A summarize of the situation.
> > > - The patch is from years in OpenWRT. Used by anything that has ath10k
> > >   card and a LED connected.
> > > - This patch is also used by the fw variant from Candela Tech with no
> > >   problem reported.
> > > - It was pointed out that this caused some problem with ipq4019 SoC
> > >   but the problem was actually caused by a different bug related to
> > >   interrupts.
> > >
> > > I honestly hope we can have this feature merged since it's really
> > > funny to have something that was so near merge and jet still not
> > > present and with devices not supporting this simple but useful
> > > feature.
> > 
> > Indeed, we should finally get this in. Thanks for working on it.
> > 
> > I did some minor changes to the patch, they are in my pending branch:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=686464864538158f22842dc49eddea6fa50e59c1
> > 
> > My comments below, please review my changes. No need to resend because
> > of these.
> >
> 
> Hi,
> very happy this is going further.
> 
> > > --- a/drivers/net/wireless/ath/ath10k/Kconfig
> > > +++ b/drivers/net/wireless/ath/ath10k/Kconfig
> > > @@ -67,6 +67,23 @@ config ATH10K_DEBUGFS
> > >  
> > >  	  If unsure, say Y to make it easier to debug problems.
> > >  
> > > +config ATH10K_LEDS
> > > +	bool "Atheros ath10k LED support"
> > > +	depends on ATH10K
> > > +	select MAC80211_LEDS
> > > +	select LEDS_CLASS
> > > +	select NEW_LEDS
> > > +	default y
> > > +	help
> > > +	  This option enables LEDs support for chipset LED pins.
> > > +	  Each pin is connected via GPIO and can be controlled using
> > > +	  WMI Firmware API.
> > > +
> > > +	  The LED device will get available named as "ath10k-phyX" at sysfs and
> > > +    	  can be controlled with various triggers.
> > > +
> > > +	  Say Y, if you have LED pins connected to the ath10k wireless card.
> > 
> > I'm not sure anymore if we should ask anything from the user, better to
> > enable automatically if LED support is enabled in the kernel. So I
> > simplified this to:
> > 
> > config ATH10K_LEDS
> > 	bool
> > 	depends on ATH10K
> > 	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
> > 	default y
> > 
> > This follows what mt76 does:
> > 
> > config MT76_LEDS
> > 	bool
> > 	depends on MT76_CORE
> > 	depends on LEDS_CLASS=y || MT76_CORE=LEDS_CLASS
> > 	default y
> > 
> 
> I remember there was the same discussion in a previous series. OK for me
> for making this by default, only concern is any buildbot error (if any)
> 
> Anyway OK for the change.
> 
> > > @@ -65,6 +66,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
> > >  		.dev_id = QCA988X_2_0_DEVICE_ID,
> > >  		.bus = ATH10K_BUS_PCI,
> > >  		.name = "qca988x hw2.0",
> > > +		.led_pin = 1,
> > >  		.patch_load_addr = QCA988X_HW_2_0_PATCH_LOAD_ADDR,
> > >  		.uart_pin = 7,
> > >  		.cc_wraparound_type = ATH10K_HW_CC_WRAP_SHIFTED_ALL,
> > 
> > I prefer following the field order from struct ath10k_hw_params
> > declaration and also setting fields explicitly to zero (even though
> > there are gaps still) so I changed that for every entry.
> > 
> 
> Thanks for the change, np for me.
> 
> > > +int ath10k_leds_register(struct ath10k *ar)
> > > +{
> > > +	int ret;
> > > +
> > > +	if (ar->hw_params.led_pin == 0)
> > > +		/* leds not supported */
> > > +		return 0;
> > > +
> > > +	snprintf(ar->leds.label, sizeof(ar->leds.label), "ath10k-%s",
> > > +		 wiphy_name(ar->hw->wiphy));
> > > +	ar->leds.wifi_led.active_low = 1;
> > > +	ar->leds.wifi_led.gpio = ar->hw_params.led_pin;
> > > +	ar->leds.wifi_led.name = ar->leds.label;
> > > +	ar->leds.wifi_led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
> > > +
> > > +	ar->leds.cdev.name = ar->leds.label;
> > > +	ar->leds.cdev.brightness_set_blocking = ath10k_leds_set_brightness_blocking;
> > > +
> > > +	/* FIXME: this assignment doesn't make sense as it's NULL, remove it? */
> > > +	ar->leds.cdev.default_trigger = ar->leds.wifi_led.default_trigger;
> > 
> > But what to do with this FIXME?
> >
> 
> It was pushed by you in v13.
> 
> I could be wrong but your idea was to prepare for future support of
> other patch that would set the default_trigger to the mac80211 tpt.
> 
> We might got both confused by default_trigger and default_state.
> default_trigger is actually never set and is NULL (actually it's 0)
> 
> We have other 2 patch that adds tpt rates for the mac80211 LED trigger
> and set this trigger as the default one but honestly I would chose a
> different implementation than hardcoding everything.
> 
> If it's ok for you, I would drop the comment and the default_trigger and
> I will send a follow-up patch to this adding DT support by using
> led_classdev_register_ext and defining init_data.
> (and this indirectly would permit better LED naming and defining of
> default-trigger in DT)
> 
> Also ideally I will also send a patch for default_state following
> standard LED implementation. (to set default_state in DT)
> 
> I would prefer this approach as the LED patch already took way too much
> time and I think it's better to merge this initial version and then
> improve it.

If you want to check out I attached the 2 patch (one dt-bindings and the
one for the code) that I will submit when this will be merged (the
change is with the assumption that the FIXME line is dropped)

Tested and works correctly with my use case of wifi card attached with
pcie. This implementation permits to declare the default trigger in DT
instead of hardcoding.

-- 
	Ansuel

--ISiK3ICplRRKwxPi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-dt-bindings-net-wireless-qcom-ath10k-Document-LED-no.patch"

From d1e1a93fbfcbe711659f7ed7480633bf4d382377 Mon Sep 17 00:00:00 2001
From: Christian Marangi <ansuelsmth@gmail.com>
Date: Fri, 16 Jun 2023 22:58:20 +0200
Subject: [PATCH 1/3] dt-bindings: net: wireless: qcom: ath10k: Document LED
 node support

Ath10k based wifi cards can support a LED connected via GPIO internally.
The LED is configured used WMI call. Document support for the LED node
controllable standard LED bindings.

While at it adds also an example for PCIe where LED is commonly
connected and used on routers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../bindings/net/wireless/qcom,ath10k.yaml    | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
index c85ed330426d..7528ece8eff7 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
@@ -157,6 +157,11 @@ properties:
   vdd-3.3-ch1-supply:
     description: Secondary Wi-Fi antenna supply
 
+  led:
+    $ref: /schemas/leds/common.yaml#
+
+    unevaluatedProperties: false
+
 required:
   - compatible
   - reg
@@ -258,6 +263,43 @@ allOf:
         - interrupts
 
 examples:
+  # PCIe
+  - |
+    #include <dt-bindings/leds/common.h>
+
+    pci@1b500000 {
+      reg = <0x1b500000 0x1000
+             0x1b502000 0x80
+             0x1b600000 0x100
+             0x0ff00000 0x100000>;
+      device_type = "pci";
+      #address-cells = <3>;
+      #size-cells = <2>;
+
+      ranges = <0x81000000 0x0 0x00000000 0x0fe00000 0x0 0x00010000   /* I/O */
+                0x82000000 0x0 0x08000000 0x08000000 0x0 0x07e00000>; /* MEM */
+
+      /* ... */
+
+      bridge@0,0 {
+        reg = <0x00000000 0 0 0 0>;
+        #address-cells = <3>;
+        #size-cells = <2>;
+        ranges;
+
+        wifi@1,0 {
+          compatible = "qcom,ath10k";
+          reg = <0x00010000 0 0 0 0>;
+
+          led {
+            default-state = "keep";
+            color = <LED_COLOR_ID_WHITE>;
+            function = LED_FUNCTION_WLAN;
+          };
+        };
+      };
+    };
+
   # SNoC
   - |
     #include <dt-bindings/clock/qcom,rpmcc.h>
-- 
2.40.1


--ISiK3ICplRRKwxPi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-wifi-ath10k-start-LED-with-the-previous-defined-cdev.patch"

From 1e867963acbc7dd744fb07949928bc493244ee81 Mon Sep 17 00:00:00 2001
From: Christian Marangi <ansuelsmth@gmail.com>
Date: Fri, 16 Jun 2023 23:22:28 +0200
Subject: [PATCH 2/3] wifi: ath10k: start LED with the previous defined cdev
 brightness

In preparation for DT support for LED, change ath10k_leds_start to init
the LED to the previous defined cdev brightness.

The LED is set to OFF by default since we can't understand the previous
state of the LED due to a limitation in the WMI calls exposed by the fw.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/wireless/ath/ath10k/leds.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/leds.c b/drivers/net/wireless/ath/ath10k/leds.c
index 6146d4d69013..b3b3025b4a38 100644
--- a/drivers/net/wireless/ath/ath10k/leds.c
+++ b/drivers/net/wireless/ath/ath10k/leds.c
@@ -48,7 +48,8 @@ int ath10k_leds_start(struct ath10k *ar)
 	 */
 	ath10k_wmi_gpio_config(ar, ar->hw_params.led_pin, 0,
 			       WMI_GPIO_PULL_NONE, WMI_GPIO_INTTYPE_DISABLE);
-	ath10k_wmi_gpio_output(ar, ar->hw_params.led_pin, 1);
+	ath10k_wmi_gpio_output(ar, ar->hw_params.led_pin,
+			       ar->leds.cdev.brightness ^ ar->leds.wifi_led.active_low);
 
 	return 0;
 }
@@ -69,6 +70,8 @@ int ath10k_leds_register(struct ath10k *ar)
 	ar->leds.wifi_led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
 
 	ar->leds.cdev.name = ar->leds.label;
+	/* By default LED is set OFF */
+	ar->leds.cdev.brightness = 0;
 	ar->leds.cdev.brightness_set_blocking = ath10k_leds_set_brightness_blocking;
 
 	ret = led_classdev_register(wiphy_dev(ar->hw->wiphy), &ar->leds.cdev);
-- 
2.40.1


--ISiK3ICplRRKwxPi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0003-wifi-ath10k-add-DT-support-for-LED-definition.patch"

From 9437101f4ab7e06118be83180be6c8f471c1f804 Mon Sep 17 00:00:00 2001
From: Christian Marangi <ansuelsmth@gmail.com>
Date: Fri, 16 Jun 2023 23:02:26 +0200
Subject: [PATCH 3/3] wifi: ath10k: add DT support for LED definition

If supported, the LED definition for the ath10k wifi card is all
hardcoded with static names, triggers and default-state.

Add DT support for the supported LED to permit custom names, define a
default state and a default trigger.

To identify these special LED, devname_mandatory is set to true and each
LED is prefixed with ath10k- and the wireless phy name.

The non-DT implementation is still supported and DT definition is not
mandatory.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/wireless/ath/ath10k/leds.c | 38 +++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/leds.c b/drivers/net/wireless/ath/ath10k/leds.c
index b3b3025b4a38..f2f31eb26b8e 100644
--- a/drivers/net/wireless/ath/ath10k/leds.c
+++ b/drivers/net/wireless/ath/ath10k/leds.c
@@ -54,8 +54,39 @@ int ath10k_leds_start(struct ath10k *ar)
 	return 0;
 }
 
+static int ath10k_leds_of_init(struct ath10k *ar, struct led_init_data *init_data)
+{
+	struct fwnode_handle *led = NULL;
+	enum led_default_state state;
+
+	led = device_get_named_child_node(ar->dev, "led");
+	if (!led)
+		return -ENOENT;
+
+	/* LED will be init on ath10k core start. */
+	state = led_init_default_state_get(led);
+	switch (state) {
+	case LEDS_DEFSTATE_ON:
+		ar->leds.cdev.brightness = 1;
+		break;
+	/* KEEP will start the LED to OFF by default */
+	case LEDS_DEFSTATE_KEEP:
+	default:
+		ar->leds.cdev.brightness = 0;
+	}
+
+	init_data->default_label = "wifi";
+	init_data->fwnode  = led;
+	init_data->devname_mandatory = true;
+	init_data->devicename = ar->leds.label;
+
+	return 0;
+}
+
 int ath10k_leds_register(struct ath10k *ar)
 {
+	struct led_init_data *init_data_ptr = NULL;
+	struct led_init_data init_data = { };
 	int ret;
 
 	if (ar->hw_params.led_pin == 0)
@@ -74,7 +105,12 @@ int ath10k_leds_register(struct ath10k *ar)
 	ar->leds.cdev.brightness = 0;
 	ar->leds.cdev.brightness_set_blocking = ath10k_leds_set_brightness_blocking;
 
-	ret = led_classdev_register(wiphy_dev(ar->hw->wiphy), &ar->leds.cdev);
+	/* Support DT defined led. init_data_ptr is NULL if DT is not supported. */
+	if (!ath10k_leds_of_init(ar, &init_data))
+		init_data_ptr = &init_data;
+
+	ret = led_classdev_register_ext(wiphy_dev(ar->hw->wiphy), &ar->leds.cdev,
+					init_data_ptr);
 	if (ret)
 		return ret;
 
-- 
2.40.1


--ISiK3ICplRRKwxPi--

