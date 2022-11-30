Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A40163E1A9
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 21:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiK3UOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 15:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiK3UOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 15:14:21 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5369457E;
        Wed, 30 Nov 2022 12:11:28 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id jl24so304412plb.8;
        Wed, 30 Nov 2022 12:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8ws56OmnbODsSag8ifeH+mKjjjBdZv6y7WQ6kCsX4bY=;
        b=dScuvAJJ0o4Ciy/CCDZmemhr9OhcMjBs1RogvmT/oIyPC9KoHFhcsnD6OViMUT3pj1
         m6Cdp8f0DYbhc+SMcl3zN9OwGEdsPPSLzD/SUDFZoc+TdUlSN70LI4MC+j1XKnKcCz2O
         ubVnUCdIHUhNu+dkjvBTxJiVpRgiVHvxZYzgkGEAfm7Uvloy5uXAEBhdLHeO2t6Jt/9w
         MYnlqDYenr9fpSr6JR86y7k3+fGuIDBJ/PO8bV3Ma42Ln7LLdXVXofTqIO36WCOygzFZ
         jJk3ScsGT8EN0OwpnpUlcISDZtmrWFGPpos289IOvN6Xa4bnQnWKLzDJM72JeNupd6tr
         kkzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8ws56OmnbODsSag8ifeH+mKjjjBdZv6y7WQ6kCsX4bY=;
        b=hsvmtozhDHdiWsJQPW5SBB4vvQIDDdTAfNHBAVqDO5JApejEl2aCtK/JksO5gvPAp6
         j9UqbVUIgqrII8P3BkKxd5gmohojub53xvL7BS1UsFWQpNjiaJdXIUxMj6loOdX0a9DC
         0HyGd13bMYNkiHJWT3HVmIryFoKB8lAozGZfgWdJvC59Qk8+CdV2OYH3z+wScZjLPM1F
         e5RtwhuWpDOf/tRw87bcnR7c63d6etVLGwfCpnWmk3KdD/o/UcS8vjJt3j/MGJLP32vM
         C6HOhvSFopaZiYhO6caQJ5XO92F7LH5UEc/Zg3HfIjpySf2UEsGAIEPPxppo09ss7mbk
         77LQ==
X-Gm-Message-State: ANoB5pmxQL63J1g8Ho/4cgnA8FSWni8Tr+UqgVWllSsO/o1N/gI4/1Bi
        tz5NcFFdyYSeUXdapvi9eCU=
X-Google-Smtp-Source: AA0mqf4aoJxrffqEDGlugp0KzDPS2+B1GhRh7qDm2TRsD7t+QG3BBEe5SsMmIZmGZyhi8bGpUDYPcw==
X-Received: by 2002:a17:90a:df0e:b0:20b:22fb:2ef with SMTP id gp14-20020a17090adf0e00b0020b22fb02efmr73260481pjb.158.1669839088041;
        Wed, 30 Nov 2022 12:11:28 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o2-20020a17090a744200b0020d67a726easm3495877pjk.10.2022.11.30.12.11.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 12:11:27 -0800 (PST)
Message-ID: <66894fc0-78d3-0334-5227-a961dc4aa205@gmail.com>
Date:   Wed, 30 Nov 2022 12:11:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [v3][net-next][PATCH 1/1] net: phy: Add link between phy dev and
 mac dev
Content-Language: en-US
To:     Xiaolei Wang <xiaolei.wang@windriver.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221130021216.1052230-1-xiaolei.wang@windriver.com>
 <20221130021216.1052230-2-xiaolei.wang@windriver.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221130021216.1052230-2-xiaolei.wang@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/22 18:12, Xiaolei Wang wrote:
> If the external phy used by current mac interface is
> managed by another mac interface, it means that this
> network port cannot work independently, especially
> when the system suspends and resumes, the following
> trace may appear, so we should create a device link
> between phy dev and mac dev.
> 
>    WARNING: CPU: 0 PID: 24 at drivers/net/phy/phy.c:983 phy_error+0x20/0x68
>    Modules linked in:
>    CPU: 0 PID: 24 Comm: kworker/0:2 Not tainted 6.1.0-rc3-00011-g5aaef24b5c6d-dirty #34
>    Hardware name: Freescale i.MX6 SoloX (Device Tree)
>    Workqueue: events_power_efficient phy_state_machine
>    unwind_backtrace from show_stack+0x10/0x14
>    show_stack from dump_stack_lvl+0x68/0x90
>    dump_stack_lvl from __warn+0xb4/0x24c
>    __warn from warn_slowpath_fmt+0x5c/0xd8
>    warn_slowpath_fmt from phy_error+0x20/0x68
>    phy_error from phy_state_machine+0x22c/0x23c
>    phy_state_machine from process_one_work+0x288/0x744
>    process_one_work from worker_thread+0x3c/0x500
>    worker_thread from kthread+0xf0/0x114
>    kthread from ret_from_fork+0x14/0x28
>    Exception stack(0xf0951fb0 to 0xf0951ff8)
> 
> Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

