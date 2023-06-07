Return-Path: <netdev+bounces-9059-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99625726E8A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:51:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B0BB1C20940
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C513235B30;
	Wed,  7 Jun 2023 20:51:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33FF37349
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:51:16 +0000 (UTC)
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13FEC2688;
	Wed,  7 Jun 2023 13:50:53 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-256422ad25dso3421449a91.0;
        Wed, 07 Jun 2023 13:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686171050; x=1688763050;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fXVU8kdElG9ba3HfmmV5rZybO5KZbw5s6cBshU+718Y=;
        b=r+MBTp8Aj3SnG11lcMIJAQ3F3C7fhuQPjftaiAhj9s3X+rRTSb7A2ZKk5kmBTNPrfI
         E8rrNODig+FK1m8QvBcQhARHyXpuW9mdPRavqY5LkPWix0WUTqBHtt/FOdcIygcIK0K0
         VCA3IYVAkAyDuuQ00tMP9R2U8JNb9J9iVIdhq6QcYQaNJUbahuzPgWoOoH7+3p3oSUJ/
         9MmXJ0C5+E6JLPL7ACL1HXCCvDydSiBepf3A+dg2U2VLMiTCisfE/fMp2Me+CtnFh349
         k/qjRnsc5ZYFmnr3kXrp28Cc3f6JK4f32LXulp2Qes5znoJnsiA/mr9vVmKU3in8KEDt
         DO2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686171050; x=1688763050;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fXVU8kdElG9ba3HfmmV5rZybO5KZbw5s6cBshU+718Y=;
        b=BznmzMqcwI2bBVCbYuZeyiOd4AfsIIPSDLWmsOaYbslGUVN7s9yXxBcb20HgLxhxv1
         bbqwRS8+7wBDdsHGWJNeS2KWwvVMGt4NiMEIzuAh+cOYKBhRp3tFwPdraEDgcrQelf86
         TPbVOdRGc6QRWXge1NuFiJEo8QxItINXMK5RC2nKBGf3wfsS66dDURhgKlhxS8iqoyOz
         KbhyZ2BUI9FETDPvVEbhpfisZ9EWqOcERQ6f1e6lzvjtGdIc3pN9ZoigocKP89bHmeFA
         xm/0xdMlNKb8U4s2nHl98B8StJrSSAMrxJhV2XI7vEYvUx898t2NsGwIBTAn1cVzKp+c
         mcjw==
X-Gm-Message-State: AC+VfDy4DB9HGEtuahjLBLQGgahoac5gdk0b6q+EIpOadadJT1iejYI9
	GnL8VJOlfRAQnoPdL7j2oPAOaDXovr85Ug==
X-Google-Smtp-Source: ACHHUZ48VtYAKRfkyqDrliKbLKmfzS+65UFl4NLrbm3bD11zFntpznV8VEaHpRzlUs9PPfqsdj9PLg==
X-Received: by 2002:a17:90a:8913:b0:253:8a50:1bcb with SMTP id u19-20020a17090a891300b002538a501bcbmr2693082pjn.25.1686171049648;
        Wed, 07 Jun 2023 13:50:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ge13-20020a17090b0e0d00b00259bcb44113sm1762260pjb.32.2023.06.07.13.50.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 13:50:48 -0700 (PDT)
Message-ID: <9e6da1b3-3749-90e9-6a6a-4775463f5942@gmail.com>
Date: Wed, 7 Jun 2023 13:50:42 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
 Christian Marangi <ansuelsmth@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>, Pavel Machek <pavel@ucw.cz>,
 Lee Jones <lee@kernel.org>,
 "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: NPD in phy_led_set_brightness+0x3c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi all,

While adding support for configuring the LEDs with Broadcom PHYs, I 
stumbled upon the NPD below which happens while issuing a reboot. The 
driver being used is GENET which calls phy_disconnect() in its 
shutdown/remove path. This is also reproducible by unbinding the MDIO 
bus controller driver, e.g.:

# echo unimac-mdio.0 > unbind

The relevant section of the DT for this platform is the following:

                                         leds {
                                                 leds@2 {
                                                         default-state = 
"keep";
                                                         color = <0x4>;
                                                         reg = <0x2>;
                                                 };
                                                 leds@1 {
                                                         default-state = 
"keep";
                                                         color = <0x2>;
                                                         reg = <0x1>;
                                                 };
                                         };


There is no trigger being configured for either LED therefore it is not 
clear to me why the workqueue is being kicked in the first place?

# cat /sys/class/leds/
mmc0::/                  unimac-mdio-0:19:amber:/
mmc1::/                  unimac-mdio-0:19:green:/
# cat /sys/class/leds/unimac-mdio-0\:19\:
unimac-mdio-0:19:amber:/ unimac-mdio-0:19:green:/
# cat /sys/class/leds/unimac-mdio-0\:19\:green\:/trigger
[none] rfkill-any rfkill-none kbd-scrolllock kbd-numlock kbd-capslock 
kbd-kanalock kbd-shiftlock kbd-altgrlock kbd-ctrllock kbd-altlock 
kbd-shiftllock kbd-shiftrlock kbd-ctrlllock kbd-ctrlrlock mmc1 mmc0
# cat /sys/class/leds/unimac-mdio-0\:19\:amber\:/trigger
[none] rfkill-any rfkill-none kbd-scrolllock kbd-numlock kbd-capslock 
kbd-kanalock kbd-shiftlock kbd-altgrlock kbd-ctrllock kbd-altlock 
kbd-shiftllock kbd-shiftrlock kbd-ctrlllock kbd-ctrlrlock mmc1 mmc0
# reboot -f
[   55.476856] bcmgenet 8f00000.ethernet eth0: Link is Down
[   55.553834] Unable to handle kernel NULL pointer dereference at 
virtual address 00000000000001f0
[   55.562674] Mem abort info:
[   55.565482]   ESR = 0x0000000096000005
[   55.569245]   EC = 0x25: DABT (current EL), IL = 32 bits
[   55.574575]   SET = 0, FnV = 0
[   55.577641]   EA = 0, S1PTW = 0
[   55.580797]   FSC = 0x05: level 1 translation fault
[   55.585690] Data abort info:
[   55.588582]   ISV = 0, ISS = 0x00000005
[   55.592432]   CM = 0, WnR = 0
[   55.595410] user pgtable: 4k pages, 39-bit VAs, pgdp=000000004815d000
[   55.601870] [00000000000001f0] pgd=0000000000000000, 
p4d=0000000000000000, pud=0000000000000000
[   55.610601] Internal error: Oops: 0000000096000005 [#1] SMP
[   55.616190] Modules linked in: bdc udc_core
[   55.620394] CPU: 2 PID: 46 Comm: kworker/2:1 Not tainted 
6.4.0-rc1-g665543a0726c #76
[   55.628156] Hardware name: BCM972180HB_V20 (DT)
[   55.632697] Workqueue: events set_brightness_delayed
[   55.637691] pstate: 40000005 (nZcv daif -PAN -UAO -TCO -DIT -SSBS 
BTYPE=--)
[   55.644669] pc : phy_led_set_brightness+0x3c/0x68
[   55.649389] lr : phy_led_set_brightness+0x30/0x68
[   55.654105] sp : ffffffc00acabd10
[   55.657425] x29: ffffffc00acabd10 x28: 0000000000000000 x27: 
0000000000000000
[   55.664581] x26: 0000000000000000 x25: ffffff807dbb340d x24: 
0000000000000000
[   55.671736] x23: ffffff807dbb3400 x22: 0000000000000000 x21: 
ffffff8002e59c80
[   55.678891] x20: ffffff8003d1f520 x19: ffffff8003d1f000 x18: 
0000000000000000
[   55.686046] x17: 74656e2f74656e72 x16: 656874652e303030 x15: 
303066382f626472
[   55.693202] x14: ffffff8003022de0 x13: 6e69622f7273752f x12: 
0000000000000000
[   55.700357] x11: ffffff8002d1d510 x10: 0000000000000870 x9 : 
ffffffc008660a7c
[   55.707512] x8 : ffffff8002e77374 x7 : fefefefefefefeff x6 : 
000073746e657665
[   55.714667] x5 : ffffff8002e77374 x4 : 0000000000000000 x3 : 
0000000000000000
[   55.721822] x2 : 0000000000000000 x1 : 0000000000000001 x0 : 
0000000000000000
[   55.728978] Call trace:
[   55.731431]  phy_led_set_brightness+0x3c/0x68
[   55.735800]  set_brightness_delayed_set_brightness+0x44/0x7c
[   55.741476]  set_brightness_delayed+0xc4/0x1a4
[   55.745932]  process_one_work+0x1a4/0x254
[   55.749958]  process_scheduled_works+0x44/0x48
[   55.754415]  worker_thread+0x1e8/0x264
[   55.758176]  kthread+0xcc/0xdc
[   55.761242]  ret_from_fork+0x10/0x20
[   55.764833] Code: 940ed4c5 f941a660 2a1603e2 394622a1 (f940f803)
[   55.770941] ---[ end trace 0000000000000000 ]---
-- 
Florian

