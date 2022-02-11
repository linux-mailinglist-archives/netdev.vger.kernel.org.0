Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017A84B2C5F
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 19:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352436AbiBKSD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 13:03:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiBKSD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 13:03:27 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160BAD43;
        Fri, 11 Feb 2022 10:03:25 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id p9so1662662ejd.6;
        Fri, 11 Feb 2022 10:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=F6fAVDO9B8ahdSzfn8aHTj4BGi1ci4XUboIokgZ/nMA=;
        b=hbqSDI3gUWNuS/W4nv/Tb13580VVb10wXGYuRQmdXrZ5rdIo/Q95X47AlRaTHD2X6v
         8GSMZ73xZcYbRF3yh3l/gj+kOPceKSjKJ0mYlXBgIIClyRjU3u4cfHlpuVaN5lio5WUv
         v1BXPH9y97ywqUhYKG1/wFqkB/W6Df4xXNgGTXDrhQ8fLr3CcqF7mTX3WMKYjohOZNqp
         +0eKXRRHChoZQ+YtyTJ2ONsuuI8VYFVMV0dEhqpSUYxqyjWURjfEYs8h+rEtCeAIGAP+
         XQBRx0TvgR+tuONmKHeNS9pdDM/sD7ucFnR5wDCJ0ohwtEQF8N1BbMXrgQ4C/zc01j3W
         5xNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=F6fAVDO9B8ahdSzfn8aHTj4BGi1ci4XUboIokgZ/nMA=;
        b=yNUBmXQLRHKJyQIy5izQZTTOPUjuEHGC2IunZVABcpzykAQoULos0xKAaKktvOrVOF
         ecRVIYcLuoX11eE5/Ah4OiKK1w0AEcv1rDlssPCtnK2ToaF1casiOwAuzrXMMEYdMstg
         JPdwtA0Xxx9/+VWhfpnvQoolPS6c7ZQ0qS7D5tWq/GsNjord2l2nhC3tv94JfLX+MEOI
         ob7K/6azTfV23wF3EAKswKJf2Y8Hn57ovEdu9oqFQiqUJUu5sVYbyXOuBQvbDXOjWHNw
         s6ESwex7FEhcZ4TLTyms2SIzKQiswH1KEdQmzrc6tkiMC3CiFdzkY+m/8nOSBEaRLS5S
         d5/Q==
X-Gm-Message-State: AOAM533LYPifSNLbI/MvTmLszR/+tImmw9XWRsUkz4NTFkRXjgGTsYoj
        Y5+1/6jpVTPymd/E4C6Akja6W32qras=
X-Google-Smtp-Source: ABdhPJwgEj4WuJsptavQGf/RqecndL8qdJTqhKVRDrGA06O5btUleBhwWd9HchLpyE5OUnhUmviftA==
X-Received: by 2002:a17:906:72de:: with SMTP id m30mr205509ejl.163.1644602603475;
        Fri, 11 Feb 2022 10:03:23 -0800 (PST)
Received: from ?IPV6:2003:ea:8f4d:2b00:e4fc:b19a:b6f3:47f? (p200300ea8f4d2b00e4fcb19ab6f3047f.dip0.t-ipconnect.de. [2003:ea:8f4d:2b00:e4fc:b19a:b6f3:47f])
        by smtp.googlemail.com with ESMTPSA id k22sm6782652ejr.211.2022.02.11.10.03.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 10:03:22 -0800 (PST)
Message-ID: <1e89db6c-f992-e748-0b97-461e23f3c25f@gmail.com>
Date:   Fri, 11 Feb 2022 19:03:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Content-Language: en-US
To:     Corentin Labbe <clabbe.montjoie@gmail.com>, swsd@realtek.com,
        davem@davemloft.net, kuba@kernel.org, thierry.reding@gmail.com,
        jonathanh@nvidia.com
Cc:     linux-tegra@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <YgY7LW8WLtTCZUu0@Red>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: NETDEV WATCHDOG: enp1s0 (r8169): transmit queue 0 timed out
In-Reply-To: <YgY7LW8WLtTCZUu0@Red>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.02.2022 11:32, Corentin Labbe wrote:
> Hello
> 
> On my tegra124-jetson-tk1, I always got:
> [ 1311.064826] ------------[ cut here ]------------
> [ 1311.064880] WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:477 dev_watchdog+0x2fc/0x300
> [ 1311.064976] NETDEV WATCHDOG: enp1s0 (r8169): transmit queue 0 timed out
> [ 1311.065011] Modules linked in:
> [ 1311.065074] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.16.7-dirty #7
> [ 1311.065116] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
> [ 1311.065177] [<c01103e4>] (unwind_backtrace) from [<c010ade0>] (show_stack+0x10/0x14)
> [ 1311.065253] [<c010ade0>] (show_stack) from [<c0bbe884>] (dump_stack_lvl+0x40/0x4c)
> [ 1311.065322] [<c0bbe884>] (dump_stack_lvl) from [<c0122d6c>] (__warn+0xd0/0x12c)
> [ 1311.065379] [<c0122d6c>] (__warn) from [<c0bb8c48>] (warn_slowpath_fmt+0x90/0xb4)
> [ 1311.065434] [<c0bb8c48>] (warn_slowpath_fmt) from [<c0a0f0f0>] (dev_watchdog+0x2fc/0x300)
> [ 1311.065493] [<c0a0f0f0>] (dev_watchdog) from [<c01a8ab0>] (call_timer_fn+0x34/0x1a8)
> [ 1311.065554] [<c01a8ab0>] (call_timer_fn) from [<c01a8e50>] (__run_timers.part.0+0x22c/0x328)
> [ 1311.065599] [<c01a8e50>] (__run_timers.part.0) from [<c01a8f84>] (run_timer_softirq+0x38/0x68)
> [ 1311.065648] [<c01a8f84>] (run_timer_softirq) from [<c0101394>] (__do_softirq+0x124/0x3cc)
> [ 1311.065732] [<c0101394>] (__do_softirq) from [<c0129ff4>] (irq_exit+0xa4/0xd4)
> [ 1311.065818] [<c0129ff4>] (irq_exit) from [<c0100b90>] (__irq_svc+0x50/0x80)
> [ 1311.065860] Exception stack(0xc1101ed8 to 0xc1101f20)
> [ 1311.065884] 1ec0:                                                       00000000 00000001
> [ 1311.065913] 1ee0: c110a800 00000060 00000001 eed889f8 c121eaa0 418a949d 00000001 00000131
> [ 1311.065940] 1f00: 00000001 00000131 00000000 c1101f28 c08bbe20 c08bbee8 60000113 ffffffff
> [ 1311.065962] [<c0100b90>] (__irq_svc) from [<c08bbee8>] (cpuidle_enter_state+0x270/0x480)
> [ 1311.066031] [<c08bbee8>] (cpuidle_enter_state) from [<c08bc15c>] (cpuidle_enter+0x50/0x54)
> [ 1311.066078] [<c08bc15c>] (cpuidle_enter) from [<c015a658>] (do_idle+0x1e0/0x298)
> [ 1311.066133] [<c015a658>] (do_idle) from [<c015a9e0>] (cpu_startup_entry+0x18/0x1c)
> [ 1311.066174] [<c015a9e0>] (cpu_startup_entry) from [<c1000fc8>] (start_kernel+0x678/0x6bc)
> [ 1311.066242] ---[ end trace 3df1a997f30c7eb8 ]---
> [ 1311.083269] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> [ 2671.118597] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> [27521.391461] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> [47441.629280] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> [49046.691475] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> [53081.713430] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> [55101.737951] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> [59351.771382] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> [60491.797371] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> [61351.805499] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> [69631.911327] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> [71246.958267] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> [86522.110241] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> [88507.174307] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> [104612.315286] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> [132797.695339] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> 
> This happen since at least 5.10.
> Any idea on how to debug this ?
> 
For whatever reason the chip locked up what results in the tx timeout and the following
rtl_rxtx_empty_cond == 0 message. However the chip soft reset in the timeout handler
seems to help.

Typically these timeouts are hard to debug because there's no public datasheets
and errata information.

Few questions:
- Is this a mainline or a downstream kernel?
- Full dmesg log would help (e.g. to identify exact chip version).
- Does the issue correlate with specific activity or specific types of traffic?
- Is the interface operating in promiscuous mode (e.g. part of a bridge)?

At first you could try to disable all hw offloading / ASPM / EEE.

There's also a small chance that the issue is linked to a specific link partner.
So you could test whether issue persists with another switch in between.
Or with a different link partner.

Ar you aware of any earlier kernel version where the issue did not happen?
Then you could bisect.

> Regards

