Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323E25387B4
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 21:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbiE3TVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 15:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiE3TVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 15:21:33 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2364690CF2
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 12:21:31 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id er5so14739634edb.12
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 12:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=FDK0AWhHQV6WbeVI5zbrjO/3+9xCZ4WyC/jUsElElmw=;
        b=Bu5fq6iHFT4qX6Mrdm0y7A9KhzPwjW2WHuLi2WnkT1G6+KyJCSEYzAx63iE422dVEM
         GCmTvja3Iwb1/GfrK2kXBgHHE6+t2wcWNuh5ERJv0FDLIbJxftfUVXnf8tIwNdQFy3xg
         GDOMnc8oLeJQjosf/z/yRtZlY25ZJ6yyJX+0Tyv56kwtVpHZ3/yMXEdBsjrFd/E4rfkm
         5aQvIHY5p2hKekfyMcKV4PrbdhXLYm9X0uG6Ly+2Il6ILFbvvUkuYDmETRS/r35XuPwU
         IfYEg0sBh7UkJ6nhn9+yPn8ITntMbj7rYAY6OlJd33G0s627HdTYUXtdmhlOzZdyQxUv
         JLnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=FDK0AWhHQV6WbeVI5zbrjO/3+9xCZ4WyC/jUsElElmw=;
        b=KgDHNFgkWOHiBJykkWfDrolj9T/0sCAIbJAOm0fDjNoybQvnjL2lxMljIUqsrvkt1R
         aVIx2Qj35Pgps3KyiL6AzcpVj5zibjWA0/FDL4nd5TuEy6bg0jJDdyH+4vIjq2N1osyL
         az4V7NEhkzIZd++Rw48T2IpovBV9MQpt53bIsj5AoJtMgzXs9umUIotb9z/ncSMfdVuw
         9MH4K/Tf+mBKknC06Ll/HwPa2HsvzP21WjR+0HVx7zrGDrggoygQpD55wedT1xgI1Mpm
         L0Q0QbCj497c/lQIACU2bDmXac2E2lXmuKSxD4yJ1HH8YhYibD55UtGcvW2iXPr1WfUV
         b6Mg==
X-Gm-Message-State: AOAM53249b0qhsLayPiwKDCgHxM8LSnNUwdiOmqtZGFLm/8puqqzUNat
        2yxJWkWpjgyl1BUfa9Mfva4=
X-Google-Smtp-Source: ABdhPJxS0D8SL+3VDSilg8MqSN8Wy/adAoXu+cylixSGmYuC2AynJZ4E9ewVn4CopIt755gH6dUPPA==
X-Received: by 2002:a05:6402:5298:b0:42a:cb63:5d10 with SMTP id en24-20020a056402529800b0042acb635d10mr60869706edb.415.1653938489467;
        Mon, 30 May 2022 12:21:29 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b80f:c600:9d2f:ea32:d27c:872e? (dynamic-2a01-0c23-b80f-c600-9d2f-ea32-d27c-872e.c23.pool.telefonica.de. [2a01:c23:b80f:c600:9d2f:ea32:d27c:872e])
        by smtp.googlemail.com with ESMTPSA id s24-20020a508d18000000b0042dd60352d1sm1511949eds.35.2022.05.30.12.21.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 12:21:29 -0700 (PDT)
Message-ID: <81e63fc9-ac8c-cb35-4572-c808ddab997d@gmail.com>
Date:   Mon, 30 May 2022 21:21:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        nic_swsd@realtek.com
References: <5a04080f-a2eb-6597-091e-6b31c4df1661@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: r8169: Ethernet speed regressions with RTL8168gu in ThinkPad E480
In-Reply-To: <5a04080f-a2eb-6597-091e-6b31c4df1661@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.05.2022 16:10, Rafał Miłecki wrote:
> I've ThinkPad E480 with i3-8130U CPU and 10ec:8168 detected as:
> [    8.458515] r8169 0000:03:00.0 eth0: RTL8168gu/8111gu, 8c:16:45:5d:f2:c2, XID 509, IRQ 136
> [    8.458521] r8169 0000:03:00.0 eth0: jumbo features [frames: 9194 bytes, tx checksumming: ko]
> [   12.272352] Generic FE-GE Realtek PHY r8169-0-300:00: attached PHY driver (mii_bus:phy_addr=r8169-0-300:00, irq=MAC)
> 
> It's connected to WAN port of BCM4708 based home router running OpenWrt
> with kernel 5.4.113. I run "iperf -s" on this E480 for network testing.
> 
> ***************
> 
> After upgrading kernel from 4.12 to 5.18 I noticed Ethernet speed
> regression. I bisected it down to two commits:
> 
> 
> commit 6b839b6cf9eada30b086effb51e5d6076bafc761
> Author: Heiner Kallweit <hkallweit1@gmail.com>
> Date:   Thu Oct 18 19:56:01 2018 +0200
> 
>     r8169: fix NAPI handling under high load
> 
> (introduced in 4.19 and dropped speed by 20 Mb/s = 5%)
> 
> 
> commit 288ac524cf70a8e7ed851a61ed2a9744039dae8d
> Author: Heiner Kallweit <hkallweit1@gmail.com>
> Date:   Sat Mar 30 17:13:24 2019 +0100
> 
>     r8169: disable default rx interrupt coalescing on RTL8168
> 
> (introduced in 5.1 and dropped speed by 60 Mb/s = 15%)
> 
> ***************
> 
> Is that possible to fix / rework r8169 to provide original higher
> Ethernet speed out of the box?
> 
With RTL8168g and RTL8168h I get >900Mbps in both directions.
Both referenced changes are needed. What you could try:

Enable TSO:
ethtool -K eth0 sg on tso on

As replacement for hw irq coalescing:
echo 20000 > /sys/class/net/eth0/gro_flush_timeout
echo 1 > /sys/class/net/eth0/napi_defer_hard_irqs

Or use ethtool to (re-)enable hw irq coalescing.

> Honestly I'd expect this i3-8130U to handle 1 Gb/s traffic or more and
> my guess is that the real bottleneck is my home router here (slow
> BCM4708 SoC CPU). Still it seems like r8169 can be a bottleneck on top
> of bottleneck.
> 
> ***************
> 
> v5.18
> 334 Mbits/sec
> 
> v5.10
> 336 Mbits/sec
> 
> v5.1 + git revert 288ac524cf70a8e7ed851a61ed2a9744039dae8d
> 397 Mbits/sec (back to medium speed)
> 
> v5.1
> 335 Mbits/sec (-60 Mb/s)
> 
> v5.0
> 395 Mbits/sec
> 
> ***************
> 
> v4.19 + git revert 6b839b6cf9eada30b086effb51e5d6076bafc761
> 414 Mbits/sec (back to high speed)
> 
> v4.19
> 395 Mbits/sec (-20 Mb/s)
> 
> v4.18
> 415 Mbits/sec
> 
> v4.12
> 415 Mbits/sec

