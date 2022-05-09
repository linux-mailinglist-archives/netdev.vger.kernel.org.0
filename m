Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A2251FCD8
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbiEIMdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbiEIMdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:33:42 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B47277356
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 05:29:48 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id r1-20020a1c2b01000000b00394398c5d51so8172355wmr.2
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 05:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qya9DKm3po5ZY7TUUF2J1LfI82l4MgWggnh2mZNErbI=;
        b=zA6FS0iOawK2nTlHnnZbUNA8bXwx9CyZBKKQ0y2ZKU1II8Z0h4dOWkxeWtpL5jBQ9N
         chcE4kZHHUdChSNUH485ygXgrE6BXWIzleVVOhhKc6kDT2EWhBMoo+tBsHnopA18nvJL
         QJd1d5Nsf/Pa24dHs9HUw/o4T0Ey/oYPe+XA+08yhiUv9hI2qWJzyKhbyt7maPICLcRu
         mMiojEYn0ZMiw7F/pbayUIEYHGb7cVua0PEFxsVgz1wU9lQFOhxGQdOzCdiejJ96PSQM
         YJtABhFn8txkJzyTHmJCI7SQKFXsdomDr7T6pAoAmxev8phSrttCsph4XTOhgQJK6mgu
         prDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qya9DKm3po5ZY7TUUF2J1LfI82l4MgWggnh2mZNErbI=;
        b=JVoS4s/Ez3zUzCqIOHY3IkUOHqbF5OinJT14XMhTVhhgOwTTtPtjEmakrefs6yGYZE
         bXHEK+PkOuoT2eIrICr+Py4S5fb/+XLjMfRqi5S4HGehK5IfdSyxOXap/XIv5aFbnXVv
         Tk7QQvFVa7ygiuLgy8c4Pf/ibJg9msb5Fg4BEGyLDre54Qa6T5HgQ6shP7hsVwNQ2JTk
         AwZVWd+Q9cjxrX84xQ+8TS/kdBBLndYLUPVamdg3bWcd+Ol7kv82h5/KvICP0eEwKS4R
         QvqS9pSD9wS/JlhbdKRs5zsZDVEUedeESW9f6XAsR1+HF6SAAkms11zr3gXfjVFwWtM1
         kIBg==
X-Gm-Message-State: AOAM530P04oYJNQpi15E3PAsyoBKjS84prE6VZWpRIINrZzx2QCNWho3
        FUk5bG2L++yXbpfl1Q5pTia+pU5TKNIyQD2/NDLopw==
X-Google-Smtp-Source: ABdhPJx11e62RVRvPHpJCKOVp3aqg1i5OItE5t3hie8Nt5B32mk3MdOESjOhQ5ib+j5SG5hxWI/yRA==
X-Received: by 2002:a05:600c:4f53:b0:394:6a35:79ac with SMTP id m19-20020a05600c4f5300b003946a3579acmr20725791wmq.36.1652099386422;
        Mon, 09 May 2022 05:29:46 -0700 (PDT)
Received: from josua-work.lan (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id l5-20020a5d5605000000b0020c5253d8d3sm10795672wrv.31.2022.05.09.05.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 05:29:45 -0700 (PDT)
From:   Josua Mayer <josua@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     Josua Mayer <josua@solid-run.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH RFC] net: sfp: support assigning status LEDs to SFP connectors
Date:   Mon,  9 May 2022 15:29:38 +0300
Message-Id: <20220509122938.14651-1-josua@solid-run.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Maintainers,

I am working on a new device based on the LX2160A platform, that exposes
16 sfp connectors, each with its own led controlled by gpios intended
to show link status.
This patch intends to illustrate in code what we want to achieve,
so that I can better ask you all:
How can this work with the generic led framework, and how was it meant to work?

The paragraphs below are a discussion of paths I have explored without success.
Please let me know if you have any opinions and ideas.

Describing in device-tree that an led node belongs to a particular network
device (dpmac) however seems impossible. Instead the standard appears to work
through triggers, where in device-tree one only annotates that the led should
show a trigger "netdev" or "phy". Both of these make no sense when multiple
network interfaces exist - raising the first question:
How can device-tree indicate that an individual led should show the events of
a particular network interface?

We have found that there is a way in sysfs to echo the name of the network
device to the api of the led driver, and it will start showing link status.
However this has to be done at runtime by the user.
But network interface names are unstable. They depend on probe order and
can be changed at will. Further they can be moved to different namespaces,
which will allow e.g. two instances of "eth0" to coexist.
On the Layerscape platform in particular these devices are created dynamically
by the networkign coprocessor, which supports complex functions such as
creating one network interface that spans multiple ports.
It seems to me that the netdev trigger therefore can not properly reflect
the relation between an LED (which is hard-wired to an sfp cage), and the
link state reported by e.g. a phy inside an sfp module.

There exists also a phy trigger for leds.
When invoking the phy_attach or phy_connect functions from the generic phy
framework to connect an instance of net_device with an instance of phy_device,
a trigger providing the link and speed events is registered.
You may notice that again leds are tied to existence of a particular logical
network interface, which may or may not exist, and may span multiple
physical interfaces in case of layerscape.
This is a dead end though, simply because the dpaa2 driver does not even use
objects of phy_device, so this registering of triggers never happens.

In addition the dpmac nodes in device-tree don't really have a phy modeled.
One end are the serdes which are managed by the networking coprocessor.
The other end has removable sfp modules, which may or may not contain a phy.

The serdes are modeled as phy in device-tree though, perhaps the dpaa2 driver
could be extended to instantiate phy_device objects for the serdes?
However I feel like this would especially not solve when mutliple physical
ports are used as one logical interface.

It seems to me that there should be a way to explicitly link gpio-driven LEDs to
either specific phy nodes, or specific sfp connectors - and have them receive
link events from the respective phy, fully independent even from whether there
is a logical network interface.

If you got here, thank you very much for reading!
Ay comments?

sincerely
Josua Mayer

Signed-off-by: Josua Mayer <josua@solid-run.com>
---
 .../devicetree/bindings/net/sff,sfp.txt       |  4 +++
 drivers/net/phy/sfp.c                         | 36 +++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/sff,sfp.txt b/Documentation/devicetree/bindings/net/sff,sfp.txt
index 832139919f20..d46df1300d28 100644
--- a/Documentation/devicetree/bindings/net/sff,sfp.txt
+++ b/Documentation/devicetree/bindings/net/sff,sfp.txt
@@ -37,6 +37,10 @@ Optional Properties:
   Specifies the maximum power consumption allowable by a module in the
   slot, in milli-Watts.  Presently, modules can be up to 1W, 1.5W or 2W.
 
+- link-status-led:
+    description: An LED node for showing link status.
+    $ref: /schemas/types.yaml#/definitions/phandle
+
 Example #1: Direct serdes to SFP connection
 
 sfp_eth3: sfp-eth3 {
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 2fff62695455..0f18e77b8b68 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -7,6 +7,7 @@
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
+#include <linux/leds.h>
 #include <linux/mdio/mdio-i2c.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
@@ -258,6 +259,7 @@ struct sfp {
 	char *hwmon_name;
 #endif
 
+	struct led_classdev *link_status_led;
 };
 
 static bool sff_module_supported(const struct sfp_eeprom_id *id)
@@ -1490,6 +1492,8 @@ static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
 
 static void sfp_sm_link_up(struct sfp *sfp)
 {
+	if (sfp->link_status_led)
+		led_set_brightness(sfp->link_status_led, sfp->link_status_led->max_brightness);
 	sfp_link_up(sfp->sfp_bus);
 	sfp_sm_next(sfp, SFP_S_LINK_UP, 0);
 }
@@ -1497,6 +1501,8 @@ static void sfp_sm_link_up(struct sfp *sfp)
 static void sfp_sm_link_down(struct sfp *sfp)
 {
 	sfp_link_down(sfp->sfp_bus);
+	if (sfp->link_status_led)
+		led_set_brightness(sfp->link_status_led, LED_OFF);
 }
 
 static void sfp_sm_link_check_los(struct sfp *sfp)
@@ -2425,6 +2429,23 @@ static int sfp_probe(struct platform_device *pdev)
 
 		i2c = of_find_i2c_adapter_by_node(np);
 		of_node_put(np);
+
+		np = of_parse_phandle(node, "link-status-led", 0);
+		sfp->link_status_led = of_led_get_hack(np);
+		of_node_put(np);
+
+		if (IS_ERR(sfp->link_status_led)) {
+			switch (PTR_ERR(sfp->link_status_led)) {
+			case -ENODEV:
+				sfp->link_status_led = NULL;
+				break;
+			default:
+				dev_err(sfp->dev, "failed to get link-statusled from 'link-status-led' property: %pe\n", sfp->link_status_led);
+				fallthrough;
+			case -EPROBE_DEFER:
+				return PTR_ERR(sfp->link_status_led);
+			};
+		}
 	} else if (has_acpi_companion(&pdev->dev)) {
 		struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
 		struct fwnode_handle *fw = acpi_fwnode_handle(adev);
@@ -2453,6 +2476,14 @@ static int sfp_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	if (sfp->link_status_led) {
+		/* remove from sysfs to avoid userspce control */
+		led_sysfs_disable(sfp->link_status_led);
+
+		/* turn off initially */
+		led_set_brightness(sfp->link_status_led, LED_OFF);
+	}
+
 	for (i = 0; i < GPIO_MAX; i++)
 		if (sff->gpios & BIT(i)) {
 			sfp->gpio[i] = devm_gpiod_get_optional(sfp->dev,
@@ -2545,6 +2576,11 @@ static int sfp_remove(struct platform_device *pdev)
 {
 	struct sfp *sfp = platform_get_drvdata(pdev);
 
+	if (sfp->link_status_led) {
+		/* re-enable sysfs interface */
+		led_sysfs_enable(sfp->link_status_led);
+	}
+
 	sfp_unregister_socket(sfp->sfp_bus);
 
 	rtnl_lock();
-- 
2.35.3

