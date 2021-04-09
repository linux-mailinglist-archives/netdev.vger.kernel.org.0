Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D7D359BD6
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 12:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbhDIKVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 06:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbhDIKS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 06:18:59 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0B6C061763
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 03:18:06 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id v6so6546877ejo.6
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 03:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citymesh-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=AW1PpfcK7MwvMsDjoYmu8WfsrnQvu6Qs1xn0wuK0qwM=;
        b=wt6sFNaiRA0wNiGvf7TZOB9KYeduhgvYfqBadVynt8UXV72DyRbztFyme7BnCSUAgp
         HKx4ISrNLgm46F9sV/BNJOknVt+tinWPDdhQ3n1LHit4dsdvPvc5BKiif7xl8m2/ZHZJ
         UfEYStGLeOxlOBhHzpKr3WrJCVhVMYe0p01CIlSdemIWBDs8JSu4lPo91WEGRFLD4MZR
         yLv7fdUlS9qmEg/B/oij76Dl37AsPTg4M+s+e4uJqZKBN8lSpu58O2tOr7NpUOeHY2wg
         xDUzqkadqEsB8moG0YuYDHxZR5lEtb2j6FTUYLbgSxwwm5j3iDMfDwxh5C9zJA8SbeQK
         owGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=AW1PpfcK7MwvMsDjoYmu8WfsrnQvu6Qs1xn0wuK0qwM=;
        b=ceWVFTv2NLkBrfmyb+8jzzYZmfKLqsqh0dicV6FwhPT8CM1pAA+nEhm+QwHoGQwkwD
         TGUYnQ0+dporQ2298hkymoZik1nad9UixXCuCEcXRzElVCeaYtTMUMSPOi2fT8RGIWXr
         ajGlmrXYGmMSIUJPvfl1XSrzzAtjkwFc0BN15GzOHbymI0aGF4vH7oaQCQdHbteMSeTV
         3PKY/lOlO8e62O7ERz64Wcv1OU/ErrDdH59W5IvFlQatIN97Hd2yJqW+o5gl7lgQGyGs
         KHm+MCd1rNmuTtb7ICgmVNKaHosZnoqbxfNhrMy+7mzgvCVWm5LUalOkxZqH38sDt4nf
         4b1Q==
X-Gm-Message-State: AOAM530bqyYRimOeBG34jRdXHH7SYto7SiiwD+0o+aU5rdtzRQ65xdwn
        8MryXWnch9+HkF3VsmKaxucTHA==
X-Google-Smtp-Source: ABdhPJwVFYtqchj8BJAJ+q5ocY2t3TvldNkA7qyqxxwrOzddos79dpbdMN3OsF0mhwX2+ueddo709w==
X-Received: by 2002:a17:906:1986:: with SMTP id g6mr15300113ejd.533.1617963484873;
        Fri, 09 Apr 2021 03:18:04 -0700 (PDT)
Received: from [10.202.0.7] ([31.31.140.89])
        by smtp.gmail.com with ESMTPSA id qk3sm1007985ejb.22.2021.04.09.03.18.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 03:18:04 -0700 (PDT)
To:     linux-can@vger.kernel.org
Cc:     wg@grandegger.com, mkl@pengutronix.de, netdev@vger.kernel.org,
        qiangqing.zhang@nxp.com, gregkh@linuxfoundation.org
From:   Koen Vandeputte <koen.vandeputte@citymesh.com>
Subject: flexcan introduced a DIV/0 in kernel
Message-ID: <5bdfcccb-0b02-e46b-eefe-7df215cc9d02@citymesh.com>
Date:   Fri, 9 Apr 2021 12:18:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

I just updated kernel 4.14 within OpenWRT from 4.14.224 to 4.14.229
Booting it shows the splat below on each run. [1]


It seems there are 2 patches regarding flexcan which were introduced in 
4.14.226

--> ce59ffca5c49 ("can: flexcan: enable RX FIFO after FRZ/HALT valid")
--> bb7c9039a396 ("can: flexcan: assert FRZ bit in flexcan_chip_freeze()")

Reverting these fixes the splat.

Hope this helps,

Koen



[1]

[   10.062140] flexcan 2090000.flexcan: 2090000.flexcan supply xceiver 
not found, using dummy regulator
[   10.071631] Division by zero in kernel.
[   10.075511] CPU: 0 PID: 1061 Comm: kmodloader Not tainted 4.14.229 #0
[   10.081981] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[   10.088529] Backtrace:
[   10.091040] [<8010ba30>] (dump_backtrace) from [<8010bdd4>] 
(show_stack+0x18/0x1c)
[   10.098631]  r7:9f5edc10 r6:60000013 r5:00000000 r4:80932c88
[   10.104336] [<8010bdbc>] (show_stack) from [<8063f8e0>] 
(dump_stack+0x9c/0xb0)
[   10.111591] [<8063f844>] (dump_stack) from [<8010bb90>] 
(__div0+0x1c/0x20)
[   10.118491]  r7:9f5edc10 r6:a0f0c000 r5:9ea3fd40 r4:9ea3f800
[   10.124199] [<8010bb74>] (__div0) from [<8063de94>] (Ldiv0+0x8/0x10)
[   10.130611] [<7f32b334>] (flexcan_mailbox_read [flexcan]) from 
[<7f32c480>] (flexcan_probe+0x360/0x468 [flexcan])
[   10.140902]  r7:9f5edc10 r6:a0f0c000 r5:9ea3fd40 r4:9ea3f800
[   10.146608] [<7f32c120>] (flexcan_probe [flexcan]) from [<8040f384>] 
(platform_drv_probe+0x60/0xb4)
[   10.155698]  r10:80903c08 r9:00000000 r8:0000000d r7:fffffdfb 
r6:7f32e014 r5:fffffffe
[   10.163562]  r4:9f5edc10
[   10.166117] [<8040f324>] (platform_drv_probe) from [<8040db78>] 
(driver_probe_device+0x154/0x2ec)
[   10.175012]  r7:7f32e014 r6:00000000 r5:9f5edc10 r4:80964928
[   10.180720] [<8040da24>] (driver_probe_device) from [<8040dd98>] 
(__driver_attach+0x88/0xac)
[   10.189195]  r9:7f32e080 r8:014000c0 r7:00000000 r6:9f5edc44 
r5:7f32e014 r4:9f5edc10
[   10.196985] [<8040dd10>] (__driver_attach) from [<8040bfc0>] 
(bus_for_each_dev+0x54/0xa8)
[   10.205199]  r7:00000000 r6:8040dd10 r5:7f32e014 r4:00000000
[   10.210891] [<8040bf6c>] (bus_for_each_dev) from [<8040d4ac>] 
(driver_attach+0x24/0x28)
[   10.218912]  r6:9e41e880 r5:8091b340 r4:7f32e014
[   10.223559] [<8040d488>] (driver_attach) from [<8040d0a0>] 
(bus_add_driver+0xf4/0x204)
[   10.231529] [<8040cfac>] (bus_add_driver) from [<8040e4e8>] 
(driver_register+0xb0/0xec)
[   10.239574]  r7:7f331000 r6:00000000 r5:ffffe000 r4:7f32e014
[   10.245266] [<8040e438>] (driver_register) from [<8040f2d4>] 
(__platform_driver_register+0x48/0x50)
[   10.254332]  r5:ffffe000 r4:80903c08
[   10.257953] [<8040f28c>] (__platform_driver_register) from 
[<7f331020>] (init_module+0x20/0x1000 [flexcan])
[   10.267729] [<7f331000>] (init_module [flexcan]) from [<80101a1c>] 
(do_one_initcall+0xc4/0x188)
[   10.276490] [<80101958>] (do_one_initcall) from [<80192458>] 
(do_init_module+0x68/0x204)
[   10.284615]  r9:7f32e080 r8:014000c0 r7:00000000 r6:9e48b640 
r5:9e4af000 r4:7f32e080
[   10.292389] [<801923f0>] (do_init_module) from [<801944b4>] 
(load_module+0x1e1c/0x220c)
[   10.300441]  r7:00000000 r6:9e4af1a8 r5:9e4af000 r4:9e8f3f30
[   10.306158] [<80192698>] (load_module) from [<80194a00>] 
(SyS_init_module+0x15c/0x17c)
[   10.314110]  r10:00000051 r9:000128ce r8:ffffe000 r7:001e545c 
r6:00000000 r5:a0f0945c
[   10.321957]  r4:0000345c
[   10.324541] [<801948a4>] (SyS_init_module) from [<801079e0>] 
(ret_fast_syscall+0x0/0x54)
[   10.332663]  r10:00000080 r9:9e8f2000 r8:80107be4 r7:00000080 
r6:00000003 r5:00000000
[   10.340511]  r4:00000000
[   10.344089] flexcan 2090000.flexcan: device registered 
(reg_base=a0f0c000, irq=33)


