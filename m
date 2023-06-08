Return-Path: <netdev+bounces-9387-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E8F3728AD2
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 00:04:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E44BC1C21012
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 22:04:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C36C634D73;
	Thu,  8 Jun 2023 22:04:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26AE7464
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 22:04:03 +0000 (UTC)
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA921BE4;
	Thu,  8 Jun 2023 15:04:01 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id 6a1803df08f44-62606e67c0dso8888056d6.2;
        Thu, 08 Jun 2023 15:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686261840; x=1688853840;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7cN8yQlUy/H9XNpFRErcIiyirbTRbU41WjmrV5uPq/U=;
        b=ewBC+AuHOZK+dW8ZGFyxVzVktIDE7krKwPG/oyln0fO/yQDjI3urNlcgIyivET5wcm
         bTKUXbaMNdRynHSbyL1bQPbuOsATga5vsrEbiGmeTq3oaifCO/UkjkASm5oFYqcPJZqz
         9WBE25azRtvhZDdYC6TDxNPlRbIsd4I5C30+SthPIl5TbD0enZIXrMyVWrRp1DQmUtKP
         gnymQIAISH6QfCuE6TOZhXR0OcO1khuv1lM0AJzMOFe7Vit+JgVe51AmLbCskD/rSCVo
         j0hd2887GuYABHnZFJMM5ul7hgK7IDox7rZyxrovJ0ktMVyC+LbpPRqT0Olg323sX629
         zEeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686261840; x=1688853840;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7cN8yQlUy/H9XNpFRErcIiyirbTRbU41WjmrV5uPq/U=;
        b=WEeZ/Qmw0+0yGlBI4zQSwOUul/vvwEtA2sikm7yDb+CzBHyMw+k/iTRg8DghN+KoWK
         SS2MyXIlJMq4O9DuxXyeVKQSBMlIiN1d1+nAgFIQFQ5c+vc7vAV5aCbCJs+CTgKQvLem
         PMxovD98opdb0vgis0hv2MkpzUSm1TBql0lR/+pcbuHuh56x3n/nFF6EhGbuqpjIradu
         fR2j6A40t1XH9OGu3EOCMSicLBonJqynHhWzL/lDBSAUYidiKhPKZQnzYMvWz/jrYDwY
         j7MzRZVcoByEayMtiXg3Lz3C6YCI0WkwmuxM448f2gW9cy87ML20EW1G+amTyZP4LNbP
         VzHQ==
X-Gm-Message-State: AC+VfDyhCuwKn4gpvd7XmG9weeS2KVT1l6SNBe1v9bg1gg80AGLVIUkb
	O5CJS7A43UMZLqSTYAfOzLc=
X-Google-Smtp-Source: ACHHUZ4i5CJ9G1PcnjrQopnaSIvOykRVYrlJ5/WOLA9c38O5kIc547cewGnc0lqxL6pitvNbzbfvsw==
X-Received: by 2002:a05:6214:27eb:b0:625:aa49:ceae with SMTP id jt11-20020a05621427eb00b00625aa49ceaemr2721679qvb.55.1686261840490;
        Thu, 08 Jun 2023 15:04:00 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b3-20020a0cf043000000b0062014184907sm685601qvl.107.2023.06.08.15.03.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 15:03:59 -0700 (PDT)
Message-ID: <c4133154-3163-2f22-9d88-dfb17221111b@gmail.com>
Date: Thu, 8 Jun 2023 15:03:48 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: NPD in phy_led_set_brightness+0x3c
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 Heiner Kallweit <hkallweit1@gmail.com>,
 Christian Marangi <ansuelsmth@gmail.com>, Vladimir Oltean
 <olteanv@gmail.com>, Pavel Machek <pavel@ucw.cz>, Lee Jones
 <lee@kernel.org>, "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
References: <9e6da1b3-3749-90e9-6a6a-4775463f5942@gmail.com>
 <c8fb4ca8-f6ef-461c-975b-09a15a43e408@lunn.ch>
 <11182cf6-eb35-273e-da17-6ca901ac06d3@gmail.com>
 <5558742d-232b-4417-9bea-6369434f8983@lunn.ch>
 <f415f93e-bf6c-88be-161d-f6d5c88ca10b@gmail.com>
 <b0dd0247-90f6-4769-a1f3-3b3499561b88@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <b0dd0247-90f6-4769-a1f3-3b3499561b88@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/8/23 12:13, Andrew Lunn wrote:
> On Thu, Jun 08, 2023 at 10:33:30AM -0700, Florian Fainelli wrote:
>> On 6/7/23 18:30, Andrew Lunn wrote:
>>>> (gdb) print /x (int)&((struct phy_driver *)0)->led_brightness_set
>>>> $1 = 0x1f0
>>>>
>>>> so this would indeed look like an use-after-free here. If you tested with a
>>>> PHYLINK enabled driver you might have no seen due to
>>>> phylink_disconnect_phy() being called with RTNL held?
>>>
>>> Yes, i've been testing with mvneta, which is phylink.
>>
>> Humm, this is really puzzling because we have the below call trace as to
>> where we call schedule_work() which is in led_set_brightness_nopm() however
>> we have led_classdev_unregister() call flush_work() to ensure the workqueue
>> completed. Is there something else in that call stack that prevents the
>> system workqueue from running?
> 
> Has phy_remove() already been called? Last thing it does is:
> 
> phydev->drv = NULL;
> 
> This is one of the differences between my system and yours. With
> mvneta, the mdio bus driver is an independent device. You have a
> combined MAC and MDIO bus driver.

Yes, good point. I did change to the patch below, however that still 
triggers an delayed led_brightness_set call which now gets scheduled 
*after* we removed the MDIO bus controller and shutdown the MDIO bus clock:

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 2cad9cc3f6b8..f838c4f92524 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3053,7 +3053,7 @@ static int of_phy_led(struct phy_device *phydev,
         init_data.fwnode = of_fwnode_handle(led);
         init_data.devname_mandatory = true;

-       err = devm_led_classdev_register_ext(dev, cdev, &init_data);
+       err = led_classdev_register_ext(dev, cdev, &init_data);
         if (err)
                 return err;

@@ -3298,6 +3298,14 @@ static int phy_probe(struct device *dev)
         return err;
  }

+static void phy_remove_leds(struct phy_device *phydev)
+{
+       struct phy_led *phyled;
+
+       list_for_each_entry(phyled, &phydev->leds, list)
+               led_classdev_unregister(&phyled->led_cdev);
+}
+
  static int phy_remove(struct device *dev)
  {
         struct phy_device *phydev = to_phy_device(dev);
@@ -3315,6 +3323,8 @@ static int phy_remove(struct device *dev)
         /* Assert the reset signal */
         phy_device_reset(phydev, 1);

+       phy_remove_leds(phydev);
+
         phydev->drv = NULL;

         return 0;

-- 
Florian


