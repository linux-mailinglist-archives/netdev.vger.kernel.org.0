Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18CAA2A5F9
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 20:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfEYSGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 14:06:16 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37297 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfEYSGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 14:06:15 -0400
Received: by mail-lf1-f65.google.com with SMTP id m15so8718115lfh.4
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 11:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UpssaejKLgAR5FZ4MvcU4Y0wLRJvYLyVGbnTjVAJ82Q=;
        b=fkWbj6Ax0qEo/K1rSVq+XBdRuN99xsnw7Pn0cIBobwKGighL8cPck9SuV/JM0iwUsF
         0EfmmsSveKal2ituo1t6GuISwYAjeBZxdRjrANpBH17DZ4V+P3NsK010py5A04scHHx6
         GXVr17YxYyvHKnWZxGkmnl6MFQC2h+JoOBDwv/+k/oLnxazl7dgLS8kuslYqUnBV5dxO
         RDWK6ifvRBdXkso7je5pQK8EtZtKCTO5J7KBOCkIr0RyjwpkA2HcuCLM6HCHIRiafaNs
         R0yqfHiEr3BCaBuX+oJMgbWIpEtJasWC6VJAa7PPcTkr3vxJ82TIxTp3w/PCFpO5PwKl
         uSuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=UpssaejKLgAR5FZ4MvcU4Y0wLRJvYLyVGbnTjVAJ82Q=;
        b=D5Jj5cWCTbnM68j2hvVe2ATwuXJInmVhModph8jIS3KXJ8rQfBxYKon3sszM5vDtDk
         tPvbw+KTyX12UiWE7xynE/Q3xQA6NmlXE/5+Sh84XE2YrkB9NmiwL5Ff5YXVGtdxc21m
         cub+SazytNKZWHHJpmYwlxiOq/IMrerry82zYWP/NBhMaj1FobN5eIJgqdmVnYh9qbnM
         ErNqK27CEllqvWKQhacsareljdBelYhjJanQUqzCP+REzJwzEDiKZYsbxZ/jW9ONLf1y
         c+jLqwc65zU7enHqZ9C1SCddpjVFHm/sBSUQ1hBiozs69bHeV+QMU6jXnKNJiSTE5a3o
         W0Og==
X-Gm-Message-State: APjAAAVHT6zAG0fJjNXICnAAyelUZME89Gwyju6/gMzQL/iHCNH+xXKl
        /hFIA4MM0tZazqANpby9pi+Rfw==
X-Google-Smtp-Source: APXvYqzih2DZe1izORAtIdj7WYkc2bG7ppfGf/wzMAJ3IzvFELSe6tgbabw8BBdnoueIHYy7XjicTQ==
X-Received: by 2002:a19:6b04:: with SMTP id d4mr26195217lfa.57.1558807572319;
        Sat, 25 May 2019 11:06:12 -0700 (PDT)
Received: from wasted.cogentembedded.com ([31.173.80.189])
        by smtp.gmail.com with ESMTPSA id p5sm1207490ljg.55.2019.05.25.11.06.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 11:06:11 -0700 (PDT)
Subject: Re: [PATCH] net: sh_eth: fix mdio access in sh_eth_close() for some
 SoCs
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
References: <1557898601-26231-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <0ab08e61-833d-1d9e-ef71-311964854d46@cogentembedded.com>
 <OSBPR01MB317471EFA8854C8B694E5E12D8060@OSBPR01MB3174.jpnprd01.prod.outlook.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <45e98185-f2db-5e7f-3c6a-a33a7432f677@cogentembedded.com>
Date:   Sat, 25 May 2019 21:06:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <OSBPR01MB317471EFA8854C8B694E5E12D8060@OSBPR01MB3174.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 05/20/2019 10:42 AM, Yoshihiro Shimoda wrote:

> Thank you for the reply! And, I'm sorry for the delayed response because I had days off in last week.

   And sorry for my delayed reply as well!

>>    It's not "some SoCs", it's only R-Car gen2 and RZ/G1 SoCs.
> 
> Do you prefer the subject "net: sh_eth: fix mdio access in sh_eth_close() for R-Car gen2 and RZ/G1 SoCs"
> instead of "... some SoCs"?

   Yes, it's just about a single SoC family as the driver knows them, really: R-Car gen2;
RZ/G1 uses the same SoC data.

>>> The sh_eth_close() resets the MAC and then calls phy_stop()
>>> so that mdio read access result is incorrect without any error
>>> according to kernel trace like below:
>>>
>>> ifconfig-216   [003] .n..   109.133124: mdio_access: ee700000.ethernet-ffffffff read  phy:0x01 reg:0x00 val:0xffff
>>
>>    Not sure how RMII mode affects the MDIO transfers...
> 
> I should have described what happen on the previous code.
> According to the hardware manual, the RMII mode should be set to 1 before
> operation the Ethernet MAC. The MDIO transferring is one of the Ethernet MAC operation.
> So, I assumed this RMII mode affects the MDIO transfers.
> 
> By the way, I also should have described what happen on the previous code.
> If I input the following command on non-NFS rootfs environment (e.g. USB memory rootfs),
> sometimes, a lot of FCD interruption happened and then the following "rcu "error happened.
> ---
> # ifconfig eth0 down# ifconfig eth0 up
> [  794.545823] Micrel KSZ8041RNLI ee700000.ethernet-ffffffff:01: attached PHY driver [Micrel KSZ8041RNLI] (mii_bus:phy_addr=ee700000.ethernet-ffffffff:01, irq=157)
> # ifconfig eth0 up# ifconfig eth0 down
> # ifconfig eth0 down# ifconfig eth0 up
> [  797.662138] Micrel KSZ8041RNLI ee700000.ethernet-ffffffff:01: attached PHY driver [Micrel KSZ8041RNLI] (mii_bus:phy_addr=ee700000.ethernet-ffffffff:01, irq=157)
> [  797.689158] sh-eth ee700000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
> [  797.702631] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> # [  818.759628] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
> [  818.770827] rcu:     0-....: (2 GPs behind) idle=d12/0/0x3 softirq=388/388 fqs=1051
> [  818.783635] rcu:     (detected by 1, t=2104 jiffies, g=377, q=18)
> [  818.794848] Sending NMI from CPU 1 to CPUs 0:
> [  818.804733] NMI backtrace for cpu 0
> [  818.804736] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.1.0-00002-g192664e-dirty #27
> [  818.804738] Hardware name: Generic R-Car Gen2 (Flattened Device Tree)
> [  818.804740] PC is at __do_softirq+0x7c/0x344
> [  818.804742] LR is at irq_exit+0x6c/0xcc
> [  818.804744] pc : [<c01021e4>]    lr : [<c0126aa0>]    psr: 60030113
> [  818.804746] sp : c0d01eb8  ip : 00200102  fp : c0d03080
> [  818.804748] r10: 00000001  r9 : 0000000a  r8 : c0ca2940
> [  818.804750] r7 : 00000004  r6 : c0ca2934  r5 : 00000000  r4 : ffffe000
> [  818.804752] r3 : c0ca2940  r2 : 2aaa8000  r1 : 00000000  r0 : 2aaa8000
> [  818.804754] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> [  818.804756] Control: 10c5387d  Table: 6a5f006a  DAC: 00000051
> [  818.804758] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.1.0-00002-g192664e-dirty #27
> [  818.804760] Hardware name: Generic R-Car Gen2 (Flattened Device Tree)
> [  818.804762] [<c011049c>] (unwind_backtrace) from [<c010bc0c>] (show_stack+0x18/0x1c)
> [  818.804764] [<c010bc0c>] (show_stack) from [<c07f7458>] (dump_stack+0x7c/0x9c)
> [  818.804766] [<c07f7458>] (dump_stack) from [<c07fd358>] (nmi_cpu_backtrace+0x98/0xb8)
> [  818.804768] [<c07fd358>] (nmi_cpu_backtrace) from [<c010e6bc>] (handle_IPI+0x2bc/0x33c)
> [  818.804770] [<c010e6bc>] (handle_IPI) from [<c03fa084>] (gic_handle_irq+0x8c/0x98)
> [  818.804773] [<c03fa084>] (gic_handle_irq) from [<c0101a8c>] (__irq_svc+0x6c/0x90)
> [  818.804774] Exception stack(0xc0d01e68 to 0xc0d01eb0)
> [  818.804777] 1e60:                   2aaa8000 00000000 2aaa8000 c0ca2940 ffffe000 00000000
> [  818.804779] 1e80: c0ca2934 00000004 c0ca2940 0000000a 00000001 c0d03080 00200102 c0d01eb8
> [  818.804781] 1ea0: c0126aa0 c01021e4 60030113 ffffffff
> [  818.804783] [<c0101a8c>] (__irq_svc) from [<c01021e4>] (__do_softirq+0x7c/0x344)
> [  818.804785] [<c01021e4>] (__do_softirq) from [<c0126aa0>] (irq_exit+0x6c/0xcc)
> [  818.804787] [<c0126aa0>] (irq_exit) from [<c016c344>] (__handle_domain_irq+0x88/0xbc)
> [  818.804789] [<c016c344>] (__handle_domain_irq) from [<c03fa058>] (gic_handle_irq+0x60/0x98)
> [  818.804791] [<c03fa058>] (gic_handle_irq) from [<c0101a8c>] (__irq_svc+0x6c/0x90)
> [  818.804793] Exception stack(0xc0d01f38 to 0xc0d01f80)
> [  818.804795] 1f20:                                                       00000000 0008bbb8
> [  818.804798] 1f40: eb74b520 c011aee0 00000001 ffffe000 c0d08c30 c0d8e5be c0d08c74 c0d980c0
> [  818.804800] 1f60: 00000001 c0c5ea40 00000000 c0d01f88 c01084ec c014c85c 60030013 ffffffff
> [  818.804802] [<c0101a8c>] (__irq_svc) from [<c014c85c>] (do_idle+0xf0/0x13c)
> [  818.804804] [<c014c85c>] (do_idle) from [<c014cb10>] (cpu_startup_entry+0x20/0x24)
> [  818.804806] [<c014cb10>] (cpu_startup_entry) from [<c0c00fac>] (start_kernel+0x3e0/0x488)

    This *usually* means a register is accessed while the clock is off...

> Note:
>  - After I input the second ifconfig eth0 up, I cannot input any command.
>  - If I disconnect an ethernet cable, I can input command again.

   Hm...

> ---
> 
>>> To fix the issue, this patch adds a condition and set the RMII mode
>>> regiseter in sh_eth_dev_exit() for some SoCs.

   Register.

>>> Note that when I have tried to move the sh_eth_dev_exit() calling
>>> after phy_stop() on sh_eth_close(), but it gets worse.
>>
>>    Ah, I was going to suggest changing the call order... what happens then?
> 
> Sometimes, the following error happened and then I cannot recover the system
> even if I disconnected an ethernet cable. Do you prefer this way, instead of
> adding RMII mode setting on sh_eth_dev_exit()?
> ---
> # ifconfig eth0 up;
> [   64.896021] Micrel KSZ8041RNLI ee700000.ethernet-ffffffff:01: attached PHY driver [Micrel KSZ8041RNLI] (mii_bus:phy_addr=ee700000.ethernet-ffffffff:01, irq=157)
> # [   66.868241] sh-eth ee700000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
> [   66.881777] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> # ifconfig eth0 down
> [   71.164900] sh-eth ee700000.ethernet eth0: Link is Down
> [   92.169767] rcu: INFO: rcu_sched self-detected stall on CPU
> [   92.180654] rcu: 	0-....: (2100 ticks this GP) idle=9d6/1/0x40000004 softirq=513/513 fqs=1050 
> [   92.194720] rcu: 	 (t=2102 jiffies g=-367 q=46)
> [   92.204723] NMI backtrace for cpu 0
> [   92.213705] CPU: 0 PID: 228 Comm: ifconfig Not tainted 5.1.0-00002-g192664e-dirty #28
> [   92.227149] Hardware name: Generic R-Car Gen2 (Flattened Device Tree)
> [   92.239258] [<c011049c>] (unwind_backtrace) from [<c010bc0c>] (show_stack+0x18/0x1c)
> [   92.252683] [<c010bc0c>] (show_stack) from [<c07f7458>] (dump_stack+0x7c/0x9c)
> [   92.265548] [<c07f7458>] (dump_stack) from [<c07fd360>] (nmi_cpu_backtrace+0xa0/0xb8)
> [   92.279039] [<c07fd360>] (nmi_cpu_backtrace) from [<c07fd3fc>] (nmi_trigger_cpumask_backtrace+0x84/0x114)
> [   92.294384] [<c07fd3fc>] (nmi_trigger_cpumask_backtrace) from [<c01827e4>] (rcu_dump_cpu_stacks+0xb4/0xd0)
> [   92.309893] [<c01827e4>] (rcu_dump_cpu_stacks) from [<c0180cc8>] (rcu_sched_clock_irq+0x2cc/0x6f0)
> [   92.324744] [<c0180cc8>] (rcu_sched_clock_irq) from [<c0189170>] (update_process_times+0x38/0x64)
> [   92.339528] [<c0189170>] (update_process_times) from [<c019a5d0>] (tick_nohz_handler+0xd4/0x128)
> [   92.354261] [<c019a5d0>] (tick_nohz_handler) from [<c06573a4>] (arch_timer_handler_virt+0x30/0x38)
> [   92.369207] [<c06573a4>] (arch_timer_handler_virt) from [<c0171548>] (handle_percpu_devid_irq+0xf0/0x224)
> [   92.384817] [<c0171548>] (handle_percpu_devid_irq) from [<c016c2ac>] (generic_handle_irq+0x20/0x30)
> [   92.399910] [<c016c2ac>] (generic_handle_irq) from [<c016c364>] (__handle_domain_irq+0xa8/0xbc)
> [   92.414678] [<c016c364>] (__handle_domain_irq) from [<c03fa058>] (gic_handle_irq+0x60/0x98)
> [   92.429128] [<c03fa058>] (gic_handle_irq) from [<c0101a8c>] (__irq_svc+0x6c/0x90)
> [   92.442748] Exception stack(0xea1f9b50 to 0xea1f9b98)
> [   92.453924] 9b40:                                     2aaa8000 00000000 2aaa8000 c0ca2940
> [   92.468345] 9b60: ffffe000 00000000 c0ca2934 00000002 c0ca2940 0000000a 00000000 c0d03080
> [   92.482764] 9b80: 00404100 ea1f9ba0 c0126aa0 c01021e4 60030113 ffffffff
> [   92.495519] [<c0101a8c>] (__irq_svc) from [<c01021e4>] (__do_softirq+0x7c/0x344)
> [   92.508973] [<c01021e4>] (__do_softirq) from [<c0126aa0>] (irq_exit+0x6c/0xcc)
> [   92.522215] [<c0126aa0>] (irq_exit) from [<c016c344>] (__handle_domain_irq+0x88/0xbc)
> [   92.536092] [<c016c344>] (__handle_domain_irq) from [<c03fa058>] (gic_handle_irq+0x60/0x98)
> [   92.550513] [<c03fa058>] (gic_handle_irq) from [<c0101a8c>] (__irq_svc+0x6c/0x90)
> [   92.564095] Exception stack(0xea1f9c20 to 0xea1f9c68)
> [   92.575129] 9c20: f0911320 00000001 00000000 f0911320 00000003 eabb7844 00000001 00000000
> [   92.589271] 9c40: 00000000 00003800 00000000 ea1f9e50 ea1f9d24 ea1f9c70 c0555d80 c055c590
> [   92.603319] 9c60: 60030013 ffffffff
> [   92.612529] [<c0101a8c>] (__irq_svc) from [<c055c590>] (sh_mdio_ctrl+0x3c/0x58)
> [   92.625531] [<c055c590>] (sh_mdio_ctrl) from [<c0555d80>] (mdiobb_send_num+0x28/0x34)
> [   92.638971] [<c0555d80>] (mdiobb_send_num) from [<c0555f10>] (mdiobb_write+0x70/0x94)
> [   92.652337] [<c0555f10>] (mdiobb_write) from [<c05555a4>] (__mdiobus_write+0x64/0x10c)
> [   92.665688] [<c05555a4>] (__mdiobus_write) from [<c05526e8>] (__phy_modify_changed+0x58/0x6c)
> [   92.679587] [<c05526e8>] (__phy_modify_changed) from [<c0552760>] (__phy_modify+0x10/0x18)
> [   92.693127] [<c0552760>] (__phy_modify) from [<c05527a4>] (phy_modify+0x3c/0x54)
> [   92.705749] [<c05527a4>] (phy_modify) from [<c0553b14>] (phy_suspend+0xb0/0xd0)
> [   92.718274] [<c0553b14>] (phy_suspend) from [<c0551118>] (phy_state_machine+0x1a4/0x1a8)
> [   92.731589] [<c0551118>] (phy_state_machine) from [<c05511a8>] (phy_stop+0x8c/0xb8)
> [   92.744411] [<c05511a8>] (phy_stop) from [<c055e2d4>] (sh_eth_close+0x58/0xa0)
> [   92.756668] [<c055e2d4>] (sh_eth_close) from [<c06ce740>] (__dev_close_many+0xc0/0xdc)
> [   92.769620] [<c06ce740>] (__dev_close_many) from [<c06d4f9c>] (__dev_change_flags+0xdc/0x1b0)
> [   92.783186] [<c06d4f9c>] (__dev_change_flags) from [<c06d5090>] (dev_change_flags+0x20/0x50)
> [   92.796660] [<c06d5090>] (dev_change_flags) from [<c074d740>] (devinet_ioctl+0x2d8/0x5dc)
> [   92.809892] [<c074d740>] (devinet_ioctl) from [<c074f8f8>] (inet_ioctl+0x260/0x324)
> [   92.822560] [<c074f8f8>] (inet_ioctl) from [<c06b2ea4>] (sock_ioctl+0x148/0x424)
> [   92.834968] [<c06b2ea4>] (sock_ioctl) from [<c0252e00>] (vfs_ioctl+0x28/0x3c)
> [   92.847110] [<c0252e00>] (vfs_ioctl) from [<c0253614>] (do_vfs_ioctl+0x98/0x844)
> [   92.859518] [<c0253614>] (do_vfs_ioctl) from [<c0253e00>] (ksys_ioctl+0x40/0x5c)
> [   92.871875] [<c0253e00>] (ksys_ioctl) from [<c0101000>] (ret_fast_syscall+0x0/0x54)
> [   92.884498] Exception stack(0xea1f9fa8 to 0xea1f9ff0)
> [   92.894477] 9fa0:                   000ab853 bec4fc90 00000003 00008914 bec4fc90 000ab853
> [   92.907648] 9fc0: 000ab853 bec4fc90 bec4ff52 00000036 bec4fe48 000000b8 00096710 00000000
> [   92.920805] 9fe0: 000ca1e4 bec4fc2c 0001aa8c b6e72f3c
> ---

   Again, usually means register access while the module clock is off...

>>> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
>>> ---
>>>  drivers/net/ethernet/renesas/sh_eth.c | 4 ++++
>>>  1 file changed, 4 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
>>> index e33af37..106ae90 100644
>>> --- a/drivers/net/ethernet/renesas/sh_eth.c
>>> +++ b/drivers/net/ethernet/renesas/sh_eth.c
>>> @@ -1596,6 +1596,10 @@ static void sh_eth_dev_exit(struct net_device *ndev)
>>>
>>>  	/* Set MAC address again */
>>>  	update_mac_address(ndev);
>>> +
>>> +	/* Set the mode again if required */
>>
>>    Should be "RMII mode", n ot just "Mode". We prolly need more detailed explanation...
> 
> I got it.

   Your fix seems legit now, just misplaced a bit...

> Best regards,
> Yoshihiro Shimoda
> 
>>> +	if (mdp->cd->rmiimode)
>>> +		sh_eth_write(ndev, 0x1, RMIIMODE);

    According to the gen2 manual, this register should be written right after the soft reset
via EDMR.

>>>  }
>>>
>>>  static void sh_eth_rx_csum(struct sk_buff *skb)

MBR, Sergei
