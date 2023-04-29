Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D366F271C
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 01:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjD2XJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 19:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjD2XJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 19:09:13 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9CE10FC;
        Sat, 29 Apr 2023 16:09:10 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id EF0A460161;
        Sun, 30 Apr 2023 01:09:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682809747; bh=EW71Uu3FCd8kGpUKI/5g/oAGTU9KZ+/7Mkj0LnbpVdw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qvEuXnlEFQxjihtnPCwNrmfboVPkaRmZjz7+MGyJM1h67tcxbVzDnHkIdKztK4pm3
         bAaHpp7qXR5IZv4+Lsr8ECc/SnuhnKoCjIXOkItCzNnnJQXW9+Qff4IA+LyrzMPxRF
         HbR2DpehOdg0cm9HLayZ24f+CbFpP6iCNQVAjM523CHMnm/LHjLHT/jklO8lZmuiVP
         WA+TFl0ZS/mgP9WUaIHWSJ/5PumLwr12DkWVTIsanGLKg8t9dHrkTqCTFtrnjQqeUP
         SZsto8y6RctEOpAEbfIpH9zmlQusOVHGkeSGWyEJn/HLDBaZSWhhqe7knIgL8lhmwR
         LrYXgociRWMwA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RwNLizVczE6Y; Sun, 30 Apr 2023 01:09:04 +0200 (CEST)
Received: from [192.168.1.4] (unknown [77.237.113.62])
        by domac.alu.hr (Postfix) with ESMTPSA id 6D4436015E;
        Sun, 30 Apr 2023 01:09:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682809744; bh=EW71Uu3FCd8kGpUKI/5g/oAGTU9KZ+/7Mkj0LnbpVdw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=y6MPRBx9AzMCmKs/zP0C0gNIb+cdvfm82zuc8H17FHGkRoOnpDJ17DH+pj33ClsQF
         5c1D8Ae5rJ8IeeJHYFDZhSGg7sDazGHbN5hi4ZvsTKwzZJuQglH6pETrrSlcjXtyf/
         ZaDcIweLhvg5NBBqBFBg281055Fye1QogKMEVSv5DC2qWNAxx7KSwWzVMxm2DzSGnl
         lNxsB7dDiAkkcCDJpRxb4VhLWN/x54BsYwbgwe1AsngeYMZTjg2aLTlPJpt/JZgO1i
         LZlbNnabRvBOSLHYTR5vN7ltvXcS+pzZHviKcfS5o53JOG01B2F7xzxReaHaf8vRMU
         99kTqTlCvvT8g==
Message-ID: <27163cae-abe6-452a-573f-48a2223468c0@alu.unizg.hr>
Date:   Sun, 30 Apr 2023 01:09:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [WITHDRAW PATCH v1 1/1] net: r8169: fix the pci setup so the
 Realtek RTL8111/8168/8411 ethernet speeds up
To:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     nic_swsd@realtek.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20230425114455.22706-1-mirsad.todorovac@alu.unizg.hr>
Content-Language: en-US, hr
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <20230425114455.22706-1-mirsad.todorovac@alu.unizg.hr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25. 04. 2023. 13:44, Mirsad Goran Todorovac wrote:
> It was noticed that Ookla Speedtest had shown only 250 Mbps download and
> 310 Mbps upload where Windows 10 on the same box showed 440/310 Mbps, which
> is the link capacity.
> 
> This article: https://www.phoronix.com/news/Intel-i219-LM-Linux-60p-Fix
> inspired to check our speeds. (Previously I used to think it was a network
> congestion, or reduction on our ISP, but now each time Windows 10 downlink
> speed is 440 compared to 250 Mbps in Linuxes Linux is performing at 60% of
> the speed.)
> 
> The latest 6.3 kernel shows 95% speed up with this patch as compared to the
> same commit without it:
> 
> ::::::::::::::
> speedtest/6.3.0-00436-g173ea743bf7a-dirty-1
> ::::::::::::::
> [marvin@pc-mtodorov ~]$ speedtest -s 41437
> 
>    Speedtest by Ookla
> 
>       Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
>          ISP: Croatian Academic and Research Network
> Idle Latency:     1.53 ms   (jitter: 0.15ms, low: 1.30ms, high: 1.71ms)
>     Download:   225.13 Mbps (data used: 199.3 MB)
>                   1.65 ms   (jitter: 20.15ms, low: 0.81ms, high: 418.27ms)
>       Upload:   350.00 Mbps (data used: 157.9 MB)
>                   3.35 ms   (jitter: 19.46ms, low: 1.61ms, high: 474.55ms)
>  Packet Loss:     0.0%
>   Result URL: https://www.speedtest.net/result/c/a0084fd8-c275-4019-899a-a1590e49a34b
> [marvin@pc-mtodorov ~]$ speedtest -s 41437
> 
>    Speedtest by Ookla
> 
>       Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
>          ISP: Croatian Academic and Research Network
> Idle Latency:     1.54 ms   (jitter: 0.28ms, low: 1.17ms, high: 1.64ms)
>     Download:   222.88 Mbps (data used: 207.9 MB)
>                  10.23 ms   (jitter: 31.76ms, low: 0.75ms, high: 353.79ms)
>       Upload:   349.91 Mbps (data used: 157.7 MB)
>                   3.27 ms   (jitter: 13.05ms, low: 1.67ms, high: 236.76ms)
>  Packet Loss:     0.0%
>   Result URL: https://www.speedtest.net/result/c/f4c663ba-830d-44c6-8033-ce3b3b818c42
> [marvin@pc-mtodorov ~]$
> ::::::::::::::
> speedtest/6.3.0-r8169-00437-g323fe5352af6-dirty-2
> ::::::::::::::
> [marvin@pc-mtodorov ~]$ speedtest -s 41437
> 
>    Speedtest by Ookla
> 
>       Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
>          ISP: Croatian Academic and Research Network
> Idle Latency:     0.84 ms   (jitter: 0.05ms, low: 0.82ms, high: 0.93ms)
>     Download:   432.37 Mbps (data used: 360.5 MB)
>                 142.43 ms   (jitter: 76.45ms, low: 1.02ms, high: 1105.19ms)
>       Upload:   346.29 Mbps (data used: 164.6 MB)
>                   7.72 ms   (jitter: 29.80ms, low: 0.92ms, high: 283.48ms)
>  Packet Loss:    12.8%
>   Result URL: https://www.speedtest.net/result/c/e473359e-c37e-4f29-aa9f-4b008210cf7c
> [marvin@pc-mtodorov ~]$ speedtest -s 41437
> 
>    Speedtest by Ookla
> 
>       Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
>          ISP: Croatian Academic and Research Network
> Idle Latency:     0.82 ms   (jitter: 0.16ms, low: 0.75ms, high: 1.05ms)
>     Download:   440.97 Mbps (data used: 427.5 MB)
>                  72.50 ms   (jitter: 52.89ms, low: 0.91ms, high: 865.08ms)
>       Upload:   342.75 Mbps (data used: 166.6 MB)
>                   3.26 ms   (jitter: 22.93ms, low: 1.07ms, high: 239.41ms)
>  Packet Loss:    13.4%
>   Result URL: https://www.speedtest.net/result/c/f393e149-38d4-4a34-acc4-5cf81ff13708
> 
> 440 Mbps is the speed achieved in Windows 10, and Linux 6.3 with
> the patch, while 225 Mbps without this patch is running at 51% of
> the nominal speed with the same hardware and Linux kernel commit.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: nic_swsd@realtek.com
> Cc: netdev@vger.kernel.org
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=1671958#c60
> Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 45147a1016be..b8a04301d130 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -3239,6 +3239,7 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
>  	r8168_mac_ocp_write(tp, 0xc094, 0x0000);
>  	r8168_mac_ocp_write(tp, 0xc09e, 0x0000);
>  
> +	pci_disable_link_state(tp->pci_dev, PCIE_LINK_STATE_CLKPM);
>  	rtl_hw_aspm_clkreq_enable(tp, true);
>  }
>  

After some additional research, I came to the obvious realisation, reading more
thoroughly the discussion at the link - that the above patch did not work for
all Realtek RTL819x cards back then.

My version, the RTL8168h/8111h indeed works 95% faster on the 6.3 Linux kernel,
but I cannot speak for the people with the power management problems and
battery life issues ... and the concerns explained here: https://github.com/KastB/r8169

[root@pc-mtodorov marvin]# dmesg | grep RTL
[    7.304130] r8169 0000:01:00.0 eth0: RTL8168h/8111h, f4:93:9f:f0:a5:f5, XID 541, IRQ 123

Currently there seem to be  at least 43 revisions of the RTL816x cards and firmware,
and I really cannot test on all of them.

I will test the other Heiner's experimental patch, but it seems to disable ASPM completely,
while for my Lenovo desktop with RTL8168h/8111h disabling CLKPM alone.

However, further homework revealed that the kernel patch is unnecessary, as the same
effect can be achieved in runtime by the sysfs parm introduced with THIS PATCH:
https://patchwork.kernel.org/project/linux-pci/patch/b1c83f8a-9bf6-eac5-82d0-cf5b90128fbf@gmail.com/
which was solved 3 1/2 years ago, but the default on my AlmaLinux 8.7 and Lenovo desktop
box 10TX000VCR was the 53% of the link capacity and speed.

(I don't know if the card would operate with 220 Mbps on a Gigabit link, it was
not tested.)

[marvin@pc-mtodorov ~]$ speedtest -s 41437

   Speedtest by Ookla

      Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
         ISP: Croatian Academic and Research Network
Idle Latency:     1.44 ms   (jitter: 0.23ms, low: 1.20ms, high: 1.65ms)
    Download:   220.62 Mbps (data used: 214.2 MB)                                                   
                 22.01 ms   (jitter: 36.04ms, low: 0.84ms, high: 817.47ms)
      Upload:   346.86 Mbps (data used: 169.1 MB)                                                   
                  3.32 ms   (jitter: 12.12ms, low: 0.87ms, high: 221.69ms)
 Packet Loss:     0.6%
  Result URL: https://www.speedtest.net/result/c/20c546e7-0b8f-4a2e-a669-a597bb5aee36
[marvin@pc-mtodorov ~]$ sudo bash
[sudo] password for marvin: 
[root@pc-mtodorov marvin]# cat /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/link/clkpm
1
[root@pc-mtodorov marvin]# echo 0 > /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/link/clkpm
[root@pc-mtodorov marvin]# cat /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/link/clkpm
0
[root@pc-mtodorov marvin]# speedtest -s 41437

   Speedtest by Ookla

      Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
         ISP: Croatian Academic and Research Network
Idle Latency:     0.85 ms   (jitter: 0.06ms, low: 0.78ms, high: 0.92ms)
    Download:   431.13 Mbps (data used: 341.0 MB)                                                   
                157.40 ms   (jitter: 68.09ms, low: 0.88ms, high: 823.19ms)
      Upload:   351.36 Mbps (data used: 158.3 MB)                                                   
                  2.88 ms   (jitter: 6.24ms, low: 1.41ms, high: 209.74ms)
 Packet Loss:    13.4%
  Result URL: https://www.speedtest.net/result/c/ff695466-3ac7-405e-8cae-0a85c2c3d5cd
[root@pc-mtodorov marvin]# 

The clkpm setting can be reversed back to 1, causing the RTL speed to drop again.

So, the patch is withdrawn as unnecessary, even when the majority of RTL8168h/8111h
and possibly other Realtek Gigabit cards will by default run at sub-Gigabit speeds.

Thank you for your time.

Best regards,
Mirsad

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu
 
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union

"I see something approaching fast ... Will it be friends with me?"

