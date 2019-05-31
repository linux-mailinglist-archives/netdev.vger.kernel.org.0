Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E1A3125D
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfEaQ3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:29:12 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:46162 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfEaQ3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:29:12 -0400
Received: by mail-wr1-f52.google.com with SMTP id n4so1672254wrw.13;
        Fri, 31 May 2019 09:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I4s8nPexExTKcljgjsE+qNZvsq4StL0Ux0Ehmo1v2n0=;
        b=qwNUuQDmX8sP5DPGJPotxLpDDc1oWVnxjoEUuCaL1jp/TqD24i84iMdbVhKDCfnRI8
         Ff/Mu53NZeRuQhtuo4QZJtg0+YwCO6McKvruV3KkUIHYGTb1i7hAAIWOpUAGdX0EjbwK
         7IN4lw+UFiloh7Akb1JcCbN7ouSvDVT5rL8lFi1yyaNukM8CSgryjNej9ph2YJAZu2HJ
         QR39EGUHz0DhtgEZ7WqMbTs2Jq8JFdj/g3T/g8JML7E14UjJfMUrA8bhhG2OdMDrmr8x
         mTeYd/VESaqYuT0SQXUI/WJdtKOCkjlcl1pVuCAHlBtkNlqYtjkpdNi6qfiF0hHC3XSl
         aagw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I4s8nPexExTKcljgjsE+qNZvsq4StL0Ux0Ehmo1v2n0=;
        b=QoDH0j7+1XF+uWxltmjmdHwUtkX11XF1NrGukHABrstww+sRhIIpN17UMXlPMNoAWj
         zEZfvVXYfv6T9eCSYjiGKGUlGhepVXiXRVYsRhrwtt8bNIpu4K/Xg6mJR00mxhEq33VA
         efZkBmSvygwn8bfTj2GNB4YfzhyWjDTqhXvUbUmtoGWOcnfLFn1DHyCEHCZ3mEPW4/c6
         TEvvj8l+UJYpl12jJUGsEGmLpfR4bLCVcF5qpSnabxWYQe42c279bsHea0aJyNQ9iM4H
         9UwMv0WekCkdtgS1/Ns92EfnLXd/gcMiD7dh25WM1y2Bz3oxTBD5QQKtlfrXeXD8uxLa
         puyg==
X-Gm-Message-State: APjAAAW/oRrRTFQp2SVKBCHp9GQuVWaV+OHZdYx9jhOmlIyAOsbFbfsI
        knkRKi+P02ZWn7dsUgjauRLgz6VG
X-Google-Smtp-Source: APXvYqw0IXbPkUpcgRGDHFlrJSD7qHIjNP5IEHMHQ2cl/TUYrSJHp7Jpy2Jw0N/8yLRUZB6wlA3VqQ==
X-Received: by 2002:adf:ec8c:: with SMTP id z12mr7220358wrn.209.1559320148999;
        Fri, 31 May 2019 09:29:08 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:2026:7a0b:4d8d:d1ce? (p200300EA8BF3BD0020267A0B4D8DD1CE.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:2026:7a0b:4d8d:d1ce])
        by smtp.googlemail.com with ESMTPSA id c2sm3684994wrf.75.2019.05.31.09.29.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 09:29:08 -0700 (PDT)
Subject: Re: Decreasing time to get link up to below 3 s
To:     Andrew Lunn <andrew@lunn.ch>, Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <87cb341b-1c32-04be-9309-489354ef8065@molgen.mpg.de>
 <20190531141411.GA23821@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <f2b13ac8-e1ca-80c1-01b5-8f8c0da82323@gmail.com>
Date:   Fri, 31 May 2019 18:29:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190531141411.GA23821@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.05.2019 16:14, Andrew Lunn wrote:
> On Fri, May 31, 2019 at 03:19:20PM +0200, Paul Menzel wrote:
>> Dear Linux folks,
>>
>>
>> On several systems with different network devices and drivers (e1000e, r8169, tg3)
>> it looks like getting the link up takes over three seconds.
>>
>> ### e1000e ###
>>
>> [    1.999678] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
>> [    2.000374] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
>> [    2.001206] e1000e 0000:00:1f.6: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
>> [    2.412096] e1000e 0000:00:1f.6 0000:00:1f.6 (uninitialized): registered PHC clock
>> [    2.495295] e1000e 0000:00:1f.6 eth0: (PCI Express:2.5GT/s:Width x1) 64:00:6a:2c:10:c1
>> [    2.496204] e1000e 0000:00:1f.6 eth0: Intel(R) PRO/1000 Network Connection
>> [    2.497024] e1000e 0000:00:1f.6 eth0: MAC: 12, PHY: 12, PBA No: FFFFFF-0FF
>> [   15.614031] e1000e 0000:00:1f.6 net00: renamed from eth0
>> [   18.679325] e1000e: net00 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
> 
> Hi Paul
> 
> All the Intel drivers do there own PHY handling, so i cannot speak for them.
> 
>>
>> ### r8169 ###
>>
>> [   33.433103] r8169 0000:18:00.0: enabling device (0000 -> 0003)
>> [   33.453834] libphy: r8169: probed
>> [   33.456629] r8169 0000:18:00.0 eth0: RTL8168h/8111h, 30:9c:23:04:d6:98, XID 541, IRQ 52
>> [   33.456631] r8169 0000:18:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
>> [   33.607384] r8169 0000:18:00.0 enp24s0: renamed from eth0
>> [   34.134035] Generic Realtek PHY r8169-1800:00: attached PHY driver [Generic Realtek PHY] (mii_bus:phy_addr=r8169-1800:00, irq=IGNORE)
>> [   34.215244] r8169 0000:18:00.0 enp24s0: Link is Down
>> [   37.822536] r8169 0000:18:00.0 enp24s0: Link is Up - 1Gbps/Full - flow control rx/tx
> 
> This is using the generic PHY framework and drivers.
> 
> You can see here irq=IGNORE. This implies interrupts are not being
> used. So it will poll the PHY once per second. If you can get
> interrupts working, you can save 1/2 second on average.
> 
irq=IGNORE means the MAC interrupt is used (using phy_mac_interrupt).

> 
>> ### tg3 ###
>>
>> [    2.015604] tg3.c:v3.137 (May 11, 2014)
>> [    2.025613] tg3 0000:04:00.0 eth0: Tigon3 [partno(BCM95762) rev 5762100] (PCI Express) MAC address 54:bf:64:70:a5:f9
>> [    2.026955] tg3 0000:04:00.0 eth0: attached PHY is 5762C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
>> [    2.028252] tg3 0000:04:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[1]
>> [    2.029462] tg3 0000:04:00.0 eth0: dma_rwctrl[00000001] dma_mask[64-bit]
>> [    6.376904] tg3 0000:04:00.0 net00: renamed from eth0
>> [   10.240411] tg3 0000:04:00.0 net00: Link is up at 1000 Mbps, full duplex
>> [   10.240412] tg3 0000:04:00.0 net00: Flow control is on for TX and on for RX
>> [   10.240413] tg3 0000:04:00.0 net00: EEE is disabled
>>
> 
> Another MAC driver which does not use the generic framework.
> 
>> If the time cannot be decreased, are there alternative strategies to get a link
>> up as fast as possible? For fast boot systems, it’d be interesting if first
>> a slower speed could be negotiated and later it would be changed.
> 
The following presentation should help to understand which factors
contribute to the >3s for auto-negotiation.
http://www.ieee802.org/3/af/public/jan02/brown_1_0102.pdf

> You can use ethtool to set the modes it will offer for auto-neg. So
> you could offer 10/half and see if that comes up faster.
> 
> ethtool -s eth0 advertise 0x001
> 
> But you are still going to have to wait the longer time when you
> decide it is time to swap to the full bandwidth.
> 
>        Andrew
> 
Heiner
