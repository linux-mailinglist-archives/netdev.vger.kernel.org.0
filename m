Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4C5675F69
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 22:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjATVJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 16:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjATVJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 16:09:35 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D8C86ED7
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 13:09:33 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id m15so4985638wms.4
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 13:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yt93AC2lV5z6eO0+pa0P2jx8Zmh7hVp2yh0joxcOeD8=;
        b=HzhTLYAYTOunii1T4GJ4HnwSeaqQj/awn8HkNCUIO4N/eQC6/GbgbaBPOBI/3YvhjY
         uzcb1XSDnqxf5qP7/luTrkXfuLzFFi+a8/SVNmas7BiMK8N0qo4/a/TV5wjgJUn1BmyC
         NU7WXOw+lTZMFLSzw2CwIMsqRHCCXGQsQlAKnExR6glqyQFj3LdlsVe0c4K7qheSj5lQ
         649r0PitE9NUT7Ax1oGJMNJBlEwy1WpkFl8euwtscdiJnvyO1IBPwyziJo9Vep7TGP2a
         KgDXbYbFGsnj2Fy25BsE3DM5OWVfjhBD7JOqgw8N8eVJegYq7q8OdS1S0CivDSVQ2Ris
         JXig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yt93AC2lV5z6eO0+pa0P2jx8Zmh7hVp2yh0joxcOeD8=;
        b=FFZoLVJaSiYuZ7bVMNUVJhekdjShUu2cfTGhg8xR1P3i21JL7R1oXd8MaS2xKjUspF
         W3Rg+/cL7zGOepAuGvhaRCEttIWpR1X+sb0jKj2n6zNXqc+yDGRY9oVvbueR+Yao4FpI
         gFF1wzolD4VYz7T4GCg04Qkb4Pt4sZMUtTNO5r/ft7JfGTTkGMtU4yxFJ2DibBHA31R5
         SGLpxe+JHo/a21MH8jBlwXaZ+3bnC6oFjg8vSgwsapDKLSdcEUJZJr0U1hXbqn+Pnjwj
         kSJsjNC6Ucof5dQCIW8COSMC3rG2S+sNwkl2MR3iixL/y+2XeYbKcyheiun+cwuGMBzK
         4HnA==
X-Gm-Message-State: AFqh2kqigUQ2WcruHdN6HXA7wYqE7NMmvFKsyCuHNeRCbaamr9uBRyCy
        iT3q+NZ8PcC1yJad7rfD9kxVw8YdEjU=
X-Google-Smtp-Source: AMrXdXtC4Tl224e0p1t9H4DADL9QbHGxBlk0ZMUikNhh2GUkqhGlJbiNZKGKF2uAfS/8FYJPlabtGw==
X-Received: by 2002:a05:600c:2056:b0:3db:ce8:6662 with SMTP id p22-20020a05600c205600b003db0ce86662mr13435475wmg.31.1674248971962;
        Fri, 20 Jan 2023 13:09:31 -0800 (PST)
Received: from ?IPV6:2a01:c23:bc41:e300:9132:97ef:2317:4564? (dynamic-2a01-0c23-bc41-e300-9132-97ef-2317-4564.c23.pool.telefonica.de. [2a01:c23:bc41:e300:9132:97ef:2317:4564])
        by smtp.googlemail.com with ESMTPSA id h11-20020a05600c314b00b003db0f4e12c8sm3688029wmo.34.2023.01.20.13.09.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 13:09:31 -0800 (PST)
Message-ID: <37b1001d-688c-fa35-0d8a-cbbbae5e6fa8@gmail.com>
Date:   Fri, 20 Jan 2023 22:09:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
To:     vmxevilstar@gmail.com, nic_swsd@realtek.com, netdev@vger.kernel.org
References: <46a87c152b967d42ba4af33b2d11791781e9df7f.camel@gmail.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: issue with ethernet gigabit ethernet card both on stable and rc
 kernels
In-Reply-To: <46a87c152b967d42ba4af33b2d11791781e9df7f.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.01.2023 13:58, vmxevilstar@gmail.com wrote:
> Dear Mantainers,
> 
> I am having an issue with my ethernet card.
> It works when the system boots but after around a couple of hours it
> disconnects.
> I tried different ways to get it working without having to reboot but
> nothing else seemed to work.
> Even rebooting doesn't solve the problem since again, after a couple of
> hours, it stops working again.
> I have googled around and found that some people had this same problem
> on older kernels but no solution seemed to apply to this rc nor latest
> stable kernel versions.
> I am probably missing something here.
> The issue happened also with recent stable 6.1.7 and rc kernel
> versions.
> I am actually testing the latest 6.2-rc4 version.
> 
> Following are some data I think might be useful but if you feel I
> neglected to give enough informations and you need more please just ask
> me.
> 
> Here some informations about my system :
> uname -a
> Linux ghost 6.2.0-rc4 #2 SMP PREEMPT_DYNAMIC Tue Jan 17 13:35:46 CET
> 2023 x86_64 GNU/Linux
> 
> gcc --version
> gcc (Debian 12.2.0-14) 12.2.0
> Copyright (C) 2022 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is
> NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
> PURPOSE.
> 
> 
> /usr/src# lspci|grep -i net
> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8125
> 2.5GbE Controller (rev 05)
> 
> description: Ethernet interface
> product: RTL8125 2.5GbE Controller
> vendor: Realtek Semiconductor Co., Ltd.
> physical id: 0
> bus info: pci@0000:02:00.0
> logical name: enp2s0
> version: ff
> serial: b0:25:aa:49:a5:3a
> size: 1Gbit/s
> capacity: 1Gbit/s
> width: 32 bits
> clock: 66MHz
> capabilities: bus_master vga_palette cap_list ethernet physical tp mii
> 10bt 10bt-fd 100bt 100bt-fd 1000bt-fd autonegotiation
> configuration: autonegotiation=on broadcast=yes driver=r8169
> driverversion=6.2.0-rc4 duplex=full firmware=rtl8125b-2_0.0.2 07/13/20
> latency=255 link=yes maxlatency=255 mingnt=255 multicast=yes
> port=twisted pair speed=1Gbit/s
> 
> 
> 
> lsmod|grep r8169
> r8169                 110592  0
> mdio_devres            16384  1 r8169
> libphy                200704  3 r8169,mdio_devres,realtek
> 
> the firmware version I am using is linux-firmware-20221214.tar.gz
> 
> 
> Here you can find what happens (dmesg -wT)
> [Fri Jan 20 11:04:32 2023] userif-3: sent link up event.
> 
> [Fri Jan 20 13:19:41 2023] r8169 0000:02:00.0 enp2s0: rtl_chipcmd_cond
> == 1 (loop: 100, delay: 100).
> [Fri Jan 20 13:19:41 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
> == 1 (loop: 100, delay: 10).
> [Fri Jan 20 13:19:41 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
> == 1 (loop: 100, delay: 10).
> [Fri Jan 20 13:19:41 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
> == 1 (loop: 100, delay: 10).
> [Fri Jan 20 13:19:41 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
> == 1 (loop: 100, delay: 10).
> [Fri Jan 20 13:19:41 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
> == 1 (loop: 100, delay: 10).
> [Fri Jan 20 13:19:41 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
> == 1 (loop: 100, delay: 10).
> [Fri Jan 20 13:19:41 2023] r8169 0000:02:00.0 enp2s0:
> rtl_mac_ocp_e00e_cond == 1 (loop: 10, delay: 1000).
> [Fri Jan 20 13:20:17 2023] r8169 0000:02:00.0 enp2s0: rtl_chipcmd_cond
> == 1 (loop: 100, delay: 100).
> [Fri Jan 20 13:20:17 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
> == 1 (loop: 100, delay: 10).
> [Fri Jan 20 13:20:17 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
> == 1 (loop: 100, delay: 10).
> [Fri Jan 20 13:20:17 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
> == 1 (loop: 100, delay: 10).
> [Fri Jan 20 13:20:17 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
> == 1 (loop: 100, delay: 10).
> [Fri Jan 20 13:20:17 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
> == 1 (loop: 100, delay: 10).
> [Fri Jan 20 13:20:17 2023] r8169 0000:02:00.0 enp2s0: rtl_ephyar_cond
> == 1 (loop: 100, delay: 10).
> [Fri Jan 20 13:20:18 2023] r8169 0000:02:00.0 enp2s0:
> rtl_mac_ocp_e00e_cond == 1 (loop: 10, delay: 1000).
> 

Thanks for the report. rtl_chipcmd_cond is used only during chip reset,
so I guess there's a tx timeout trace in the log before your snippet.

Typical reason is a system ASPM incompatibility. You can try to disable
ASPM in the BIOS, or use the sysfs attributes under
/sys/class/net/<if>/device/link to disable ASPM states. L1.2 is disabled
per default, therefore next one to try is L1.1.


> I would love to provide a patch of any kind but I am afraid I don't
> have enough programming skills.
> 
> Thanks in advance for your time.

