Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9211E6F2B70
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 00:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjD3WtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 18:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjD3WtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 18:49:06 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B365FE41;
        Sun, 30 Apr 2023 15:49:04 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-50bb7f31887so2231373a12.0;
        Sun, 30 Apr 2023 15:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682894943; x=1685486943;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=waHLNBn2K2+XG9rSZmjV0wXnaj8BSb5dybTLd7wOVxo=;
        b=oay1A4kvfKVMwp/xkpeIQacSWRJKqindViOUnNFlhWmrznhEo0YIl4xeyaxi1uaupN
         ezxTG1SRO0JPYVw7GhKo/d7XUehXmB5Uy2L5p6PieXJOuOLj/N+vA6cBvE43a1A2F28W
         kBrNH3Vmka/BAPGrSK0vJQMLL2UNDwmT20qHr6mzMiVxmA0VWfzwMDKLK2B76aGUDUOs
         HwtZHE86JabwIHsXP7p9CZ9pb7OTi3FlGep6l4oLmtmPCoMQux3GKkaNI4+K5Rk5Zewm
         UBOU/EHPuaQChmDNz2etna4KCbaWL9nbGj5EcEke2UmIsXjhFH/vOtZioZtFSfGyelLQ
         r90w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682894943; x=1685486943;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=waHLNBn2K2+XG9rSZmjV0wXnaj8BSb5dybTLd7wOVxo=;
        b=S+siAzkHkyTje8PUix4p4pxoYiPzgpm4C2mwu7YZbOMuAUOOBsVErj/8clBqJFmlJ1
         dLqTijy0ULxaJcWuYjErcuCqujmsTJKsFWxeU7wiel9uoZC3t71AEc/I0YAE2QskPxhU
         CRMZYYgKIX+oYn6fQrADDGEq4AknZCUr9hABsHBnhV3sjhhZo6pi3d56xGDA2TLWjYyh
         tpEm6K4KVGIl/jeLW9lSHQoywheNi20UYwYViUmXfYrWEzrAUWtGMWInHs9hK99tS/dV
         hmnrvkTnTI3LKUDZ0F13KJiGKcx7jdeQ/r9MZcaFt97+inA1Iuraa6pWkgoEbPrSvuVE
         LPFA==
X-Gm-Message-State: AC+VfDxTlhcMV5qM2QSbEtrkdXCjIG4CUEMH5fY3FvndNt6rK19JEvxz
        QQKUZa57uC4rS82KIUxZfpI=
X-Google-Smtp-Source: ACHHUZ4JPts2q35oiFjIG/zeAhoVR53t49Rax/uny2RWsnAt+bs7OGQIJ9iK0KSerqrphZcP0q44PQ==
X-Received: by 2002:aa7:d7d7:0:b0:50b:c6c6:2fdd with SMTP id e23-20020aa7d7d7000000b0050bc6c62fddmr536311eds.38.1682894942923;
        Sun, 30 Apr 2023 15:49:02 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b9e8:a700:64e6:185:9f40:bcaa? (dynamic-2a01-0c23-b9e8-a700-64e6-0185-9f40-bcaa.c23.pool.telefonica.de. [2a01:c23:b9e8:a700:64e6:185:9f40:bcaa])
        by smtp.googlemail.com with ESMTPSA id s22-20020aa7cb16000000b00509e3053b66sm7844205edt.90.2023.04.30.15.49.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Apr 2023 15:49:02 -0700 (PDT)
Message-ID: <45015448-de41-df32-b4fe-9fce49689b24@gmail.com>
Date:   Mon, 1 May 2023 00:49:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [WITHDRAW PATCH v1 1/1] net: r8169: fix the pci setup so the
 Realtek RTL8111/8168/8411 ethernet speeds up
To:     Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     nic_swsd@realtek.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20230425114455.22706-1-mirsad.todorovac@alu.unizg.hr>
 <27163cae-abe6-452a-573f-48a2223468c0@alu.unizg.hr>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <27163cae-abe6-452a-573f-48a2223468c0@alu.unizg.hr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.04.2023 01:09, Mirsad Goran Todorovac wrote:
> On 25. 04. 2023. 13:44, Mirsad Goran Todorovac wrote:
>> It was noticed that Ookla Speedtest had shown only 250 Mbps download and
>> 310 Mbps upload where Windows 10 on the same box showed 440/310 Mbps, which
>> is the link capacity.
>>
>> This article: https://www.phoronix.com/news/Intel-i219-LM-Linux-60p-Fix
>> inspired to check our speeds. (Previously I used to think it was a network
>> congestion, or reduction on our ISP, but now each time Windows 10 downlink
>> speed is 440 compared to 250 Mbps in Linuxes Linux is performing at 60% of
>> the speed.)
>>
>> The latest 6.3 kernel shows 95% speed up with this patch as compared to the
>> same commit without it:
>>
>> ::::::::::::::
>> speedtest/6.3.0-00436-g173ea743bf7a-dirty-1
>> ::::::::::::::
>> [marvin@pc-mtodorov ~]$ speedtest -s 41437
>>
>>    Speedtest by Ookla
>>
>>       Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
>>          ISP: Croatian Academic and Research Network
>> Idle Latency:     1.53 ms   (jitter: 0.15ms, low: 1.30ms, high: 1.71ms)
>>     Download:   225.13 Mbps (data used: 199.3 MB)
>>                   1.65 ms   (jitter: 20.15ms, low: 0.81ms, high: 418.27ms)
>>       Upload:   350.00 Mbps (data used: 157.9 MB)
>>                   3.35 ms   (jitter: 19.46ms, low: 1.61ms, high: 474.55ms)
>>  Packet Loss:     0.0%
>>   Result URL: https://www.speedtest.net/result/c/a0084fd8-c275-4019-899a-a1590e49a34b
>> [marvin@pc-mtodorov ~]$ speedtest -s 41437
>>
>>    Speedtest by Ookla
>>
>>       Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
>>          ISP: Croatian Academic and Research Network
>> Idle Latency:     1.54 ms   (jitter: 0.28ms, low: 1.17ms, high: 1.64ms)
>>     Download:   222.88 Mbps (data used: 207.9 MB)
>>                  10.23 ms   (jitter: 31.76ms, low: 0.75ms, high: 353.79ms)
>>       Upload:   349.91 Mbps (data used: 157.7 MB)
>>                   3.27 ms   (jitter: 13.05ms, low: 1.67ms, high: 236.76ms)
>>  Packet Loss:     0.0%
>>   Result URL: https://www.speedtest.net/result/c/f4c663ba-830d-44c6-8033-ce3b3b818c42
>> [marvin@pc-mtodorov ~]$
>> ::::::::::::::
>> speedtest/6.3.0-r8169-00437-g323fe5352af6-dirty-2
>> ::::::::::::::
>> [marvin@pc-mtodorov ~]$ speedtest -s 41437
>>
>>    Speedtest by Ookla
>>
>>       Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
>>          ISP: Croatian Academic and Research Network
>> Idle Latency:     0.84 ms   (jitter: 0.05ms, low: 0.82ms, high: 0.93ms)
>>     Download:   432.37 Mbps (data used: 360.5 MB)
>>                 142.43 ms   (jitter: 76.45ms, low: 1.02ms, high: 1105.19ms)
>>       Upload:   346.29 Mbps (data used: 164.6 MB)
>>                   7.72 ms   (jitter: 29.80ms, low: 0.92ms, high: 283.48ms)
>>  Packet Loss:    12.8%
>>   Result URL: https://www.speedtest.net/result/c/e473359e-c37e-4f29-aa9f-4b008210cf7c
>> [marvin@pc-mtodorov ~]$ speedtest -s 41437
>>
>>    Speedtest by Ookla
>>
>>       Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
>>          ISP: Croatian Academic and Research Network
>> Idle Latency:     0.82 ms   (jitter: 0.16ms, low: 0.75ms, high: 1.05ms)
>>     Download:   440.97 Mbps (data used: 427.5 MB)
>>                  72.50 ms   (jitter: 52.89ms, low: 0.91ms, high: 865.08ms)
>>       Upload:   342.75 Mbps (data used: 166.6 MB)
>>                   3.26 ms   (jitter: 22.93ms, low: 1.07ms, high: 239.41ms)
>>  Packet Loss:    13.4%
>>   Result URL: https://www.speedtest.net/result/c/f393e149-38d4-4a34-acc4-5cf81ff13708
>>
>> 440 Mbps is the speed achieved in Windows 10, and Linux 6.3 with
>> the patch, while 225 Mbps without this patch is running at 51% of
>> the nominal speed with the same hardware and Linux kernel commit.
>>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Eric Dumazet <edumazet@google.com>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Paolo Abeni <pabeni@redhat.com>
>> Cc: nic_swsd@realtek.com
>> Cc: netdev@vger.kernel.org
>> Link: https://bugzilla.redhat.com/show_bug.cgi?id=1671958#c60
>> Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
>> Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
>> ---
>>  drivers/net/ethernet/realtek/r8169_main.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 45147a1016be..b8a04301d130 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -3239,6 +3239,7 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
>>  	r8168_mac_ocp_write(tp, 0xc094, 0x0000);
>>  	r8168_mac_ocp_write(tp, 0xc09e, 0x0000);
>>  
>> +	pci_disable_link_state(tp->pci_dev, PCIE_LINK_STATE_CLKPM);
>>  	rtl_hw_aspm_clkreq_enable(tp, true);
>>  }
>>  
> 
> After some additional research, I came to the obvious realisation, reading more
> thoroughly the discussion at the link - that the above patch did not work for
> all Realtek RTL819x cards back then.
> 
> My version, the RTL8168h/8111h indeed works 95% faster on the 6.3 Linux kernel,
> but I cannot speak for the people with the power management problems and
> battery life issues ... and the concerns explained here: https://github.com/KastB/r8169
> 
> [root@pc-mtodorov marvin]# dmesg | grep RTL
> [    7.304130] r8169 0000:01:00.0 eth0: RTL8168h/8111h, f4:93:9f:f0:a5:f5, XID 541, IRQ 123
> 
> Currently there seem to be  at least 43 revisions of the RTL816x cards and firmware,
> and I really cannot test on all of them.
> 
> I will test the other Heiner's experimental patch, but it seems to disable ASPM completely,
> while for my Lenovo desktop with RTL8168h/8111h disabling CLKPM alone.
> 
> However, further homework revealed that the kernel patch is unnecessary, as the same
> effect can be achieved in runtime by the sysfs parm introduced with THIS PATCH:
> https://patchwork.kernel.org/project/linux-pci/patch/b1c83f8a-9bf6-eac5-82d0-cf5b90128fbf@gmail.com/
> which was solved 3 1/2 years ago, but the default on my AlmaLinux 8.7 and Lenovo desktop
> box 10TX000VCR was the 53% of the link capacity and speed.
> 
> (I don't know if the card would operate with 220 Mbps on a Gigabit link, it was
> not tested.)
> 
> [marvin@pc-mtodorov ~]$ speedtest -s 41437
> 
>    Speedtest by Ookla
> 
>       Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
>          ISP: Croatian Academic and Research Network
> Idle Latency:     1.44 ms   (jitter: 0.23ms, low: 1.20ms, high: 1.65ms)
>     Download:   220.62 Mbps (data used: 214.2 MB)                                                   
>                  22.01 ms   (jitter: 36.04ms, low: 0.84ms, high: 817.47ms)
>       Upload:   346.86 Mbps (data used: 169.1 MB)                                                   
>                   3.32 ms   (jitter: 12.12ms, low: 0.87ms, high: 221.69ms)
>  Packet Loss:     0.6%
>   Result URL: https://www.speedtest.net/result/c/20c546e7-0b8f-4a2e-a669-a597bb5aee36
> [marvin@pc-mtodorov ~]$ sudo bash
> [sudo] password for marvin: 
> [root@pc-mtodorov marvin]# cat /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/link/clkpm
> 1
> [root@pc-mtodorov marvin]# echo 0 > /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/link/clkpm
> [root@pc-mtodorov marvin]# cat /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/link/clkpm
> 0
> [root@pc-mtodorov marvin]# speedtest -s 41437
> 
>    Speedtest by Ookla
> 
>       Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
>          ISP: Croatian Academic and Research Network
> Idle Latency:     0.85 ms   (jitter: 0.06ms, low: 0.78ms, high: 0.92ms)
>     Download:   431.13 Mbps (data used: 341.0 MB)                                                   
>                 157.40 ms   (jitter: 68.09ms, low: 0.88ms, high: 823.19ms)
>       Upload:   351.36 Mbps (data used: 158.3 MB)                                                   
>                   2.88 ms   (jitter: 6.24ms, low: 1.41ms, high: 209.74ms)
>  Packet Loss:    13.4%
>   Result URL: https://www.speedtest.net/result/c/ff695466-3ac7-405e-8cae-0a85c2c3d5cd
> [root@pc-mtodorov marvin]# 
> 
> The clkpm setting can be reversed back to 1, causing the RTL speed to drop again.
> 
> So, the patch is withdrawn as unnecessary, even when the majority of RTL8168h/8111h
> and possibly other Realtek Gigabit cards will by default run at sub-Gigabit speeds.
> 

RTL8168h doesn't need the CLKPM quirk in general. E.g. my test system runs fine w/o it
at 950Mbps. Seems that ASPM is broken on your system.
Alternatively you can test with latest linux-next, it disables ASPM during NAPI poll.

> Thank you for your time.
> 
> Best regards,
> Mirsad
> 
Heiner

