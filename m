Return-Path: <netdev+bounces-9309-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 229BD72866B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 19:33:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B3671C20F7F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 17:33:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C9061DCB8;
	Thu,  8 Jun 2023 17:33:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4174C10973
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 17:33:41 +0000 (UTC)
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FFD2680;
	Thu,  8 Jun 2023 10:33:39 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id af79cd13be357-75d4aa85303so72109685a.2;
        Thu, 08 Jun 2023 10:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686245618; x=1688837618;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=njD8Z1XJEtT1WtO6Djgn1Q7fgFqXltz/+REVpSD1qD8=;
        b=lRkMpgFPC2u7797Pf3roFs/1BtG8uZtSgo7sz15M3ByO8K7SuwCzdiE5a7Hc7yCL3u
         2UNYV8GQHvWnbaBsvhu2T3Vv/ku1hha2RaahACkHjLfdnt4yfUHkimxPiRPoOCNueebd
         44nOJWcuAHPL4797Fe9T/Kr28V58I1ZhU7QoQqyqAbFhRFQXgXHHXgMl4JGGfDfy3oFG
         oAxQfxJTDinEXlR4BB/jeu6MZZi+RxxBdByIfcPXmPAClfrCh55zCMP8FqJcAH40OmKh
         fEe9xnKyTDVa65H8a0db4xxbcLCs9fu5GqxQn7w75SwZ/05csTJlzh6Ib6aXRTd+dG+H
         pEBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686245618; x=1688837618;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=njD8Z1XJEtT1WtO6Djgn1Q7fgFqXltz/+REVpSD1qD8=;
        b=SCMUy1mLVJGcVx4kTb54GEiOcBRSPmrSWBc+g87GhnXLcWryf+kOjkTIUM7uEq/CYb
         Iv3DLs66YZm/Se7QbiJJqY5HzkUrxpqCC5a0KbA9hQ7rFNl4tVt1eU8q9x4/28R/CsRG
         u1Ey97ENS44P0t6/mYJo3NzerLEd4U2M6q18Xb2VclZ4q/o3Mn0qr/4RJqTbU7ApPPlc
         JnrLkiPurjMZR9pemtJycfL8jfyMvV0apjTK77ZNnBR03Y1uqS8FaxHVZqWjOlC+htwX
         61eL7LUaPZg/eEnOLEFXXgHbb8igzVsAXC4IDznt4ijfMaltEzdf6xhDIw584DVMA46C
         egPw==
X-Gm-Message-State: AC+VfDxZUtj7JWN5Foi2V0rpuhuKerNSO3lEqq3kWDqbn7INV76IKpDN
	RYGlXzyLVQ0alz45GuiBUrY=
X-Google-Smtp-Source: ACHHUZ4FCmuqh+9gH9adCuyM1fxwnB+ujF+q+ya0RBsdFKopV9cUbQ3X9vKFv3wB7WYJ2yHEeX2bDw==
X-Received: by 2002:a05:620a:6845:b0:75d:57fd:d401 with SMTP id ru5-20020a05620a684500b0075d57fdd401mr6350050qkn.55.1686245618066;
        Thu, 08 Jun 2023 10:33:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i7-20020a05620a144700b0075b27186d9asm465331qkl.106.2023.06.08.10.33.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 10:33:37 -0700 (PDT)
Message-ID: <f415f93e-bf6c-88be-161d-f6d5c88ca10b@gmail.com>
Date: Thu, 8 Jun 2023 10:33:30 -0700
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
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <5558742d-232b-4417-9bea-6369434f8983@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/7/23 18:30, Andrew Lunn wrote:
>> (gdb) print /x (int)&((struct phy_driver *)0)->led_brightness_set
>> $1 = 0x1f0
>>
>> so this would indeed look like an use-after-free here. If you tested with a
>> PHYLINK enabled driver you might have no seen due to
>> phylink_disconnect_phy() being called with RTNL held?
> 
> Yes, i've been testing with mvneta, which is phylink.

Humm, this is really puzzling because we have the below call trace as to 
where we call schedule_work() which is in led_set_brightness_nopm() 
however we have led_classdev_unregister() call flush_work() to ensure 
the workqueue completed. Is there something else in that call stack that 
prevents the system workqueue from running?

[  280.663384] ------------[ cut here ]------------
[  280.668038] WARNING: CPU: 3 PID: 1497 at drivers/leds/led-core.c:333 
led_set_brightness_nopm+0x68/0xf8
[  280.677378] Modules linked in: bdc udc_core
[  280.681585] CPU: 3 PID: 1497 Comm: reboot Not tainted 
6.4.0-rc5-next-20230607-g27d73db94b91 #94
[  280.690304] Hardware name: BCM972180HB_V20 (DT)
[  280.694845] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS 
BTYPE=--)
[  280.701824] pc : led_set_brightness_nopm+0x68/0xf8
[  280.706628] lr : led_set_brightness_nosleep+0x2c/0x38
[  280.711691] sp : ffffffc082ddb7b0
[  280.715012] x29: ffffffc082ddb7b0 x28: ffffff8007a55780 x27: 
0000000000000000
[  280.722168] x26: ffffff8002fdcc90 x25: 0000000000000001 x24: 
0000000000000000
[  280.729323] x23: ffffff8002e6b000 x22: ffffffc082ddb898 x21: 
ffffffc080c4b676
[  280.736480] x20: ffffff800792b990 x19: ffffff800792b898 x18: 
0000000000000000
[  280.743636] x17: 74656e2f74656e72 x16: 656874652e303030 x15: 
303066382f626472
[  280.750791] x14: ffffff8004a6ccd8 x13: 6e69622f7273752f x12: 
0000000000000000
[  280.757948] x11: ffffff8002d1c710 x10: ffffff8002e6b2a0 x9 : 
ffffffc0807ad6c0
[  280.765103] x8 : ffffffc080595964 x7 : ffffffc08059550c x6 : 
ffffff8002e6b2a0
[  280.772258] x5 : 0000000000000000 x4 : ffffff800792b8b0 x3 : 
ffffff800792b8b0
[  280.779414] x2 : ffffff800792b898 x1 : 0000000000000000 x0 : 
0000000000000040
[  280.786570] Call trace:
[  280.789021]  led_set_brightness_nopm+0x68/0xf8
[  280.793476]  led_set_brightness_nosleep+0x2c/0x38
[  280.798192]  led_set_brightness+0x9c/0xa0
[  280.802210]  led_classdev_unregister+0x78/0xd0
[  280.806665]  devm_led_classdev_release+0x18/0x20
[  280.811294]  release_nodes+0x70/0x84
[  280.814884]  devres_release_all+0xa0/0xd4
[  280.818905]  device_unbind_cleanup+0x1c/0x60
[  280.823189]  device_release_driver_internal+0xa8/0x128
[  280.828341]  device_release_driver+0x1c/0x24
[  280.832622]  bus_remove_device+0x108/0x12c
[  280.836731]  device_del+0x194/0x2ec
[  280.840230]  phy_device_remove+0x1c/0x3c
[  280.844167]  phy_mdio_device_remove+0x14/0x1c
[  280.848537]  mdiobus_unregister+0x6c/0xa0
[  280.852560]  unimac_mdio_remove+0x20/0x4c
[  280.856582]  platform_remove+0x50/0x68
[  280.860342]  device_remove+0x50/0x74
[  280.863929]  device_release_driver_internal+0x80/0x128
[  280.869079]  device_release_driver+0x1c/0x24
[  280.873360]  bus_remove_device+0x108/0x12c
[  280.877471]  device_del+0x194/0x2ec
[  280.880969]  platform_device_del+0x2c/0x90
[  280.885077]  platform_device_unregister+0x1c/0x30
[  280.889793]  bcmgenet_mii_exit+0x40/0x4c
[  280.893728]  bcmgenet_remove+0x2c/0x44
[  280.897489]  bcmgenet_shutdown+0x14/0x1c
[  280.901422]  platform_shutdown+0x28/0x34
[  280.905355]  device_shutdown+0x158/0x1d8
[  280.909290]  kernel_restart_prepare+0x3c/0x44
[  280.913661]  kernel_restart+0x1c/0x7c
[  280.917332]  __do_sys_reboot+0x170/0x1f4
[  280.921265]  __arm64_sys_reboot+0x24/0x2c
[  280.925286]  invoke_syscall+0x80/0x114
[  280.929047]  el0_svc_common.constprop.1+0xb8/0xe4
[  280.933762]  do_el0_svc+0x90/0x9c
[  280.937086]  el0_svc+0x1c/0x44
[  280.940154]  el0t_64_sync_handler+0x100/0x150
[  280.944524]  el0t_64_sync+0x14c/0x150
[  280.948198] ---[ end trace 0000000000000000 ]---
[  280.952885] Unable to handle kernel NULL pointer dereference at 
virtual address 00000000000001f0
[  280.961697] Mem abort info:
[  280.964502]   ESR = 0x0000000096000005
[  280.968264]   EC = 0x25: DABT (current EL), IL = 32 bits
[  280.973594]   SET = 0, FnV = 0
[  280.976661]   EA = 0, S1PTW = 0
[  280.979815]   FSC = 0x05: level 1 translation fault
[  280.984708] Data abort info:
[  280.987600]   ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
[  280.993101]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[  280.998170]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[  281.003500] user pgtable: 4k pages, 39-bit VAs, pgdp=0000000045cde000
[  281.009960] [00000000000001f0] pgd=0000000000000000, 
p4d=0000000000000000, pud=0000000000000000
[  281.018691] Internal error: Oops: 0000000096000005 [#1] SMP
[  281.024280] Modules linked in: bdc udc_core
[  281.028480] CPU: 3 PID: 817 Comm: kworker/3:2 Tainted: G        W 
      6.4.0-rc5-next-20230607-g27d73db94b91 #94
[  281.039024] Hardware name: BCM972180HB_V20 (DT)
[  281.043565] Workqueue: events set_brightness_delayed
[  281.048543] pstate: 40000005 (nZcv daif -PAN -UAO -TCO -DIT -SSBS 
BTYPE=--)
[  281.055520] pc : phy_led_set_brightness+0x3c/0x68
[  281.060238] lr : phy_led_set_brightness+0x30/0x68
[  281.064955] sp : ffffffc0845bbd20
[  281.068276] x29: ffffffc0845bbd20 x28: 0000000000000000 x27: 
0000000000000000
[  281.075432] x26: 0000000000000000 x25: 0000000000000000 x24: 
ffffff807dbcc40d
[  281.082587] x23: ffffff800792b960 x22: 0000000000000000 x21: 
ffffff800792b880
[  281.089743] x20: ffffff8002e6b520 x19: ffffff8002e6b000 x18: 
0000000000000000
[  281.096899] x17: 74656e2f74656e72 x16: 656874652e303030 x15: 
303066382f626472
[  281.104054] x14: ffffff8004a6ccd8 x13: 6e69622f7273752f x12: 
0000000000000000
[  281.111209] x11: ffffff8002d1c710 x10: 0000000000000870 x9 : 
ffffffc080663bd0
[  281.118364] x8 : ffffff80065f1a80 x7 : fefefefefefefeff x6 : 
000073746e657665
[  281.125519] x5 : ffffff80065f1a80 x4 : 0000000000000000 x3 : 
0000000000000000
[  281.132676] x2 : 0000000000000000 x1 : 0000000000000001 x0 : 
0000000000000000
[  281.139831] Call trace:
[  281.142283]  phy_led_set_brightness+0x3c/0x68
[  281.146652]  set_brightness_delayed_set_brightness+0x44/0x7c
[  281.152328]  set_brightness_delayed+0xc4/0x1a4
[  281.156783]  process_one_work+0x1c0/0x284
[  281.160806]  process_scheduled_works+0x44/0x48
[  281.165263]  worker_thread+0x1e8/0x264
[  281.169023]  kthread+0xcc/0xdc
[  281.172089]  ret_from_fork+0x10/0x20
[  281.175678] Code: 940edf9f f941a660 2a1603e2 3946c2a1 (f940f803)
[  281.181786] ---[ end trace 0000000000000000 ]---

-- 
Florian


