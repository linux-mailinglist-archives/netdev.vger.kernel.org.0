Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5174F8AE4
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbiDGW5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 18:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbiDGW5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 18:57:50 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AD91AD3BC
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 15:55:48 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t13so6226255pgn.8
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 15:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=11P2s2W7As2hBXSSpv0mvQiqL5Y4iuEW61/FMvO6Kv4=;
        b=BFougMcSf1B7D6IJEUQx5/IuxZg9tGzb3sc9F9+JRJf5ErnVuXLAuHq+Hc99l/q61c
         3i3Cw4L5+J/GGiFWasL9neRkg6zxW0VheCt5josU5m/T6jcR4VME8Osb+w/5UzLc5LIm
         XWsu7UZGXn3fvf9bgB0ZreRNVja9G22lwhv/GxlemQWteXq8WN81k2I+cd5bA+3j5V0R
         rB4fE9xT8PzVRHNS9lK7+aPoQS2eVyoobRhuKhhEwfTXQlEtvAafr81Zd9bVo4Iibyma
         1e1DKbINhivWle1BXTwbaRQkfUnMYTeOYiLiBjkv3LWRuIyXY3SU89EiGUuhZr54DhjU
         VgVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=11P2s2W7As2hBXSSpv0mvQiqL5Y4iuEW61/FMvO6Kv4=;
        b=L74XBAzUrbJKPOwAZ/TjM0WBcdVbEKtMZUikzpOf1ewK+DvNOmxc7DHxcwDjPU3vBD
         enNpH3bSEmQVgy1JCsJPV4H3R8Rde4a9Xi/0HxEhy+fMPKTYXcbaSpuR6NSjMBoY3Xfh
         IFg1FxyAdGjdM2v1lnatOGSQeYeqlk835nBW1N+hg0n9W3lRvo1KEaLyPHkvD013Pk5w
         4MdxLD5rUKXOWZCdYroVRsevb4RukrcZWsNJ7jSAvLf9l5tmhYsq9xnyzN2vqxduTS/p
         BDnvGK9OEA2Y13bHTVq2+xaLnQe1n2F/IR3fiyGuJRdzi+Gslp/yGJZC4yzwhI5ZcsO3
         5FEw==
X-Gm-Message-State: AOAM532WdwV0t0wCUiMS01X51QT8WigdFifJNMcKqgWStaiW08HvpwuG
        o4VTm9boM6KnPL30iFB/OPY=
X-Google-Smtp-Source: ABdhPJwxlF3yb0RPG6uM/ybp4wu++T+fhWLL+/xC89BL/Rb6eShN7oRFBqJmMiNcnQJ12VEH3QnXgw==
X-Received: by 2002:a63:fe45:0:b0:39c:e41e:b7d4 with SMTP id x5-20020a63fe45000000b0039ce41eb7d4mr2447309pgj.226.1649372148343;
        Thu, 07 Apr 2022 15:55:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a85-20020a621a58000000b0050569a135besm3079161pfa.201.2022.04.07.15.55.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 15:55:47 -0700 (PDT)
Message-ID: <f60b3515-d1a5-a5a8-9a3f-4cb82cd0a586@gmail.com>
Date:   Thu, 7 Apr 2022 15:55:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH RFC net-next] net: dsa: b53: convert to phylink_pcs
Content-Language: en-US
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
References: <E1nc7F6-004lEo-Be@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <E1nc7F6-004lEo-Be@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/6/22 08:06, Russell King (Oracle) wrote:
> Convert B53 to use phylink_pcs for the serdes rather than hooking it
> into the MAC-layer callbacks.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> Hi Florian,
> 
> Please can you test this patch? Thanks.

Did not spend much time debugging this as I had to do something else but 
here is what I got:

[    1.909223] b53-srab-switch 18036000.ethernet-switch: SerDes lane 0, 
model: 1, rev B0 (OUI: 0x0143bff0)
[    1.918956] 8<--- cut here ---
[    1.922119] Unable to handle kernel NULL pointer dereference at 
virtual address 0000012c
[    1.930473] [0000012c] *pgd=00000000
[    1.934177] Internal error: Oops: 805 [#1] SMP ARM
[    1.939124] Modules linked in:
[    1.942277] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.18.0-rc1 #8
[    1.948744] Hardware name: Broadcom Northstar Plus SoC
[    1.954041] PC is at b53_serdes_init+0x1d8/0x1e0
[    1.958815] LR is at _printk_rb_static_descs+0x0/0x6000
[    1.964218] pc : [<c0851e08>]    lr : [<c1b425d8>]    psr: 60000013
[    1.970678] sp : e0821d08  ip : 00005ff4  fp : e0821d3c
[    1.976064] r10: c102d3cc  r9 : c0d6a628  r8 : 00000143
[    1.981448] r7 : 0000012c  r6 : 00004281  r5 : 00000000  r4 : c4636b40
[    1.988177] r3 : c0d6b4ac  r2 : 00000000  r1 : 0000003c  r0 : 00000000
[    1.994906] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM 
Segment none
[    2.002273] Control: 10c5387d  Table: 6000404a  DAC: 00000051
[    2.008195] Register r0 information: NULL pointer
[    2.013050] Register r1 information: non-paged memory
[    2.018265] Register r2 information: NULL pointer
[    2.023112] Register r3 information: non-slab/vmalloc memory
[    2.028955] Register r4 information: slab kmalloc-256 start c4636b00 
pointer offset 64 size 256
[    2.037941] Register r5 information: NULL pointer
[    2.042789] Register r6 information: non-paged memory
[    2.048004] Register r7 information: non-paged memory
[    2.053218] Register r8 information: non-paged memory
[    2.058424] Register r9 information: non-slab/vmalloc memory
[    2.064266] Register r10 information: non-slab/vmalloc memory
[    2.070198] Register r11 information: 2-page vmalloc region starting 
at 0xe0820000 allocated at kernel_clone+0xa4/0x3d8
[    2.081335] Register r12 information: non-paged memory
[    2.086639] Process swapper/0 (pid: 1, stack limit = 0x(ptrval))
[    2.092840] Stack: (0xe0821d08 to 0xe0822000)
[    2.097340] 1d00:                   00000042 00000000 0143bff0 
c05d689c e0821d3c c4636b40
[    2.105782] 1d20: c4636a40 00000005 c4636b40 c4636a40 e0821d74 
e0821d40 c0851128 c0851c3c
[    2.114222] 1d40: c0f9a998 c21abc10 c0761620 00000000 c21abc10 
c1bec070 c1c3b528 00000000
[    2.122662] 1d60: c1157854 c1c4f000 e0821d94 e0821d78 c0747708 
c0850ed8 00000000 c21abc10
[    2.131103] 1d80: c1bec070 c1c3b528 e0821dbc e0821d98 c07446ec 
c07476a8 c07551f0 c0753e00
[    2.139542] 1da0: c21abc10 c1bec070 c1c3b528 c21abc10 e0821dec 
e0821dc0 c0744a38 c0744594
[    2.147982] 1dc0: c21abc10 c1bec070 c1c83288 c1c8328c c1bec070 
c21abc10 00000000 c1157854
[    2.156423] 1de0: e0821e14 e0821df0 c0744be0 c0744994 c21abc10 
c21abc54 c1bec070 c1bd7910
[    2.164863] 1e00: 00000000 c1157854 e0821e34 e0821e18 c074545c 
c0744ba8 00000000 c1bec070
[    2.173303] 1e20: c0745364 c1bd7910 e0821e64 e0821e38 c07421d4 
c0745370 00000000 c2128c58
[    2.181744] 1e40: c216d134 32ea7446 e0821e74 c1bec070 c45f2700 
00000000 e0821e74 e0821e68
[    2.190185] 1e60: c074400c c074215c e0821e9c e0821e78 c07438e8 
c0743fec c102d3e0 c0652620
[    2.198624] 1e80: c1bec070 00000000 00000007 c2180000 e0821eb4 
e0821ea0 c07460b0 c0743774
[    2.207065] 1ea0: c1c2bb40 c112d33c e0821ec4 e0821eb8 c074736c 
c0746024 e0821ed4 e0821ec8
[    2.215506] 1ec0: c112d360 c074734c e0821f4c e0821ed8 c0102300 
c112d348 c0fa28d8 c0fa28b8
[    2.223946] 1ee0: c0fa2904 c0fbaf00 00000000 c0fa2894 00000006 
00000006 c1c36440 c11005cc
[    2.232386] 1f00: c1046b18 00000000 0000011c 00000000 c1101554 
c20d9fd2 c20d9fdd 32ea7446
[    2.240826] 1f20: c018bd80 32ea7446 c20d9f80 c1190248 c20d9f80 
00000007 c1157834 0000011c
[    2.249267] 1f40: e0821f94 e0821f50 c110161c c01022b4 00000006 
00000006 00000000 c11005cc
[    2.257707] 1f60: c10eda18 c11005cc 00000000 c1b04d00 c0c9bf20 
00000000 00000000 00000000
[    2.266147] 1f80: 00000000 00000000 e0821fac e0821f98 c0c9bf48 
c1101454 00000000 c0c9bf20
[    2.274588] 1fa0: 00000000 e0821fb0 c0100148 c0c9bf2c 00000000 
00000000 00000000 00000000
[    2.283027] 1fc0: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[    2.291467] 1fe0: 00000000 00000000 00000000 00000000 00000013 
00000000 00000000 00000000
[    2.299905] Backtrace:
[    2.302423]  b53_serdes_init from b53_srab_probe+0x25c/0x2b0
[    2.308269]  r8:c4636a40 r7:c4636b40 r6:00000005 r5:c4636a40 r4:c4636b40
[    2.315181]  b53_srab_probe from platform_probe+0x6c/0xcc
[    2.320759]  r10:c1c4f000 r9:c1157854 r8:00000000 r7:c1c3b528 
r6:c1bec070 r5:c21abc10
[    2.328837]  r4:00000000
[    2.331445]  platform_probe from really_probe+0x164/0x400
[    2.337029]  r7:c1c3b528 r6:c1bec070 r5:c21abc10 r4:00000000
[    2.342868]  really_probe from __driver_probe_device+0xb0/0x214
[    2.348982]  r7:c21abc10 r6:c1c3b528 r5:c1bec070 r4:c21abc10
[    2.354821]  __driver_probe_device from driver_probe_device+0x44/0xd4
[    2.361473]  r9:c1157854 r8:00000000 r7:c21abc10 r6:c1bec070 
r5:c1c8328c r4:c1c83288
[    2.369462]  driver_probe_device from __driver_attach+0xf8/0x1dc
[    2.375666]  r9:c1157854 r8:00000000 r7:c1bd7910 r6:c1bec070 
r5:c21abc54 r4:c21abc10
[    2.383654]  __driver_attach from bus_for_each_dev+0x84/0xd0
[    2.389498]  r7:c1bd7910 r6:c0745364 r5:c1bec070 r4:00000000
[    2.395329]  bus_for_each_dev from driver_attach+0x2c/0x30
[    2.400993]  r6:00000000 r5:c45f2700 r4:c1bec070
[    2.405749]  driver_attach from bus_add_driver+0x180/0x21c
[    2.411412]  bus_add_driver from driver_register+0x98/0x128
[    2.417167]  r7:c2180000 r6:00000007 r5:00000000 r4:c1bec070
[    2.423007]  driver_register from __platform_driver_register+0x2c/0x34
[    2.429746]  r5:c112d33c r4:c1c2bb40
[    2.433427]  __platform_driver_register from 
b53_srab_driver_init+0x24/0x28
[    2.440622]  b53_srab_driver_init from do_one_initcall+0x58/0x210
[    2.446920]  do_one_initcall from kernel_init_freeable+0x1d4/0x230
[    2.453313]  r8:0000011c r7:c1157834 r6:00000007 r5:c20d9f80 r4:c1190248
[    2.460227]  kernel_init_freeable from kernel_init+0x28/0x140
[    2.466170]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 
r6:00000000 r5:c0c9bf20
[    2.474249]  r4:c1b04d00
[    2.476857]  kernel_init from ret_from_fork+0x14/0x2c
[    2.482070] Exception stack(0xe0821fb0 to 0xe0821ff8)
[    2.487279] 1fa0:                                     00000000 
00000000 00000000 00000000
[    2.495720] 1fc0: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[    2.504160] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    2.510986]  r5:c0c9bf20 r4:00000000
[    2.514671] Code: e30b34ac e34c30d6 e0070791 e3a00000 (e7823007)
[    2.520987] ---[ end trace 0000000000000000 ]---



-- 
Florian
