Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5AD19FC22
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 19:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgDFR5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 13:57:23 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42541 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgDFR5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 13:57:22 -0400
Received: by mail-pl1-f195.google.com with SMTP id e1so100342plt.9;
        Mon, 06 Apr 2020 10:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bxQube0OQQHHs3SJlM/RaFX62Q68hQJGKbCMyA10mJE=;
        b=AD/JRFWQTy5ltK2XHADztW95BXTNo76PlkKB6sqLnMKQJ9av2FxCUayJnMEEqb2Ggv
         3xjtWx3s8XmCd1+aoRG8WUgxHzhvI4aUTHceXypq2LHY1mgjPUZCGQNNuBe5zt7cbuWU
         WKlAk+5B4xyEbrL/d2sZKkc4du7J4v7Wk2xZj8TSZMTTJdBuL0YCz79KemJxtQE+xDQ9
         crSaAOWUHF2JoVI8OKGFIMYkZeS8NgBTPj7u4539HDAMGelKRFi8ce38yRL/kM/YvOkV
         JjQGtTB8fLqgWG66Crm8kEEa2PY4jl8Ck2HR6d2vjmZ4sl7ihuy4fRcJXXuVgLDDY25+
         Mzlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=bxQube0OQQHHs3SJlM/RaFX62Q68hQJGKbCMyA10mJE=;
        b=BVJ/xAQlF7l6QuyyjX81aVCHy2PMtc+Ofbmaq0ipNRR//xHRMRpNraBE497fcgtxkK
         uSZg7ltQa/6L+7LnRwHjXj4MZ7UYnDNUfnEkUy0nYHvJEaf0xEEEgdGMAYNhZYaNmEP1
         HhjangEUChbkN1ylczE50oTf8edURNBwba5LrjnaN737b7J0P2cWm6gnuBYUmmEApUFS
         jYdnqPfUUBiOYJQBSgenevguWAxBeNwd8v6oydxsjxUQ4ZJK1TQTAFuknqYxdqu+yYej
         26bhdanb1zGuOLHMBnnwVNdIT4mkH/WGs2w4X6sOU0WoVe3GBdyUi6zdBXm8Ly58jHHX
         NKZA==
X-Gm-Message-State: AGi0PuZi6EfKGhSWsYzhHwx26/K7qP/CGIUkwZZYUwCNSKLhynQ1OrBG
        huL50fW5b0zFumRMQNAg67g=
X-Google-Smtp-Source: APiQypLEQvFFZacSZTTIgYGwPdSNRYgAVZw63hTKK9aFpjH5qQ+7la9WET25yaJ0YH3+VHYfpKCgGg==
X-Received: by 2002:a17:90a:fe0f:: with SMTP id ck15mr406960pjb.192.1586195838430;
        Mon, 06 Apr 2020 10:57:18 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id z30sm12075584pfq.84.2020.04.06.10.57.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 10:57:17 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: add GRO support via gro_cells
To:     Alexander Lobakin <bloodyreaper@yandex.ru>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Russell King <linux@armlinux.org.uk>,
        Microchip Linux Driver Support <unglinuxdriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mao Wenan <maowenan@huawei.com>
References: <20200406105910.32339-1-79537434260@yandex.com>
 <20200406144758.GC301483@lunn.ch>
 <20241586185765@iva8-5e86d95f65ab.qloud-c.yandex.net>
 <45511586194390@myt1-2a4fe5d26a82.qloud-c.yandex.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <97a880e4-de7d-1f94-d35b-2635fbd8237e@gmail.com>
Date:   Mon, 6 Apr 2020 10:57:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <45511586194390@myt1-2a4fe5d26a82.qloud-c.yandex.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/6/2020 10:34 AM, Alexander Lobakin wrote:
> 06.04.2020, 18:21, "Alexander Lobakin" <bloodyreaper@yandex.ru>:
>> 06.04.2020, 17:48, "Andrew Lunn" <andrew@lunn.ch>:
>>>  On Mon, Apr 06, 2020 at 01:59:10PM +0300, Alexander Lobakin wrote:
>>>>   gro_cells lib is used by different encapsulating netdevices, such as
>>>>   geneve, macsec, vxlan etc. to speed up decapsulated traffic processing.
>>>>   CPU tag is a sort of "encapsulation", and we can use the same mechs to
>>>>   greatly improve overall DSA performance.
>>>>   skbs are passed to the GRO layer after removing CPU tags, so we don't
>>>>   need any new packet offload types as it was firstly proposed by me in
>>>>   the first GRO-over-DSA variant [1].
>>>>
>>>>   The size of struct gro_cells is sizeof(void *), so hot struct
>>>>   dsa_slave_priv becomes only 4/8 bytes bigger, and all critical fields
>>>>   remain in one 32-byte cacheline.
>>>>   The other positive side effect is that drivers for network devices
>>>>   that can be shipped as CPU ports of DSA-driven switches can now use
>>>>   napi_gro_frags() to pass skbs to kernel. Packets built that way are
>>>>   completely non-linear and are likely being dropped without GRO.
>>>>
>>>>   This was tested on to-be-mainlined-soon Ethernet driver that uses
>>>>   napi_gro_frags(), and the overall performance was on par with the
>>>>   variant from [1], sometimes even better due to minimal overhead.
>>>>   net.core.gro_normal_batch tuning may help to push it to the limit
>>>>   on particular setups and platforms.
>>>>
>>>>   [1] https://lore.kernel.org/netdev/20191230143028.27313-1-alobakin@dlink.ru/
>>>
>>>  Hi Alexander
>>
>> Hi Andrew!
>>
>>>  net-next is closed at the moment. So you should of posted this with an
>>>  RFC prefix.
>>
>> I saw that it's closed, but didn't knew about "RFC" tags for that period,
>> sorry.
>>
>>>  The implementation looks nice and simple. But it would be nice to have
>>>  some performance figures.
>>
>> I'll do, sure. I think I'll collect the stats with various main receiving
>> functions in Ethernet driver (napi_gro_frags(), napi_gro_receive(),
>> netif_receive_skb(), netif_receive_skb_list()), and with and without this
>> patch to make them as complete as possible.
> 
> OK, so here we go.
> 
> My device is 1.2 GHz 4-core MIPS32 R2. Ethernet controller representing
> the CPU port is capable of S/G, fraglists S/G, TSO4/6 and GSO UDP L4.
> Tests are performed through simple IPoE VLAN NAT forwarding setup
> (port0 <-> port1.218) with iperf3 in TCP mode.
> net.core.gro_normal_batch is always set to 16 as that value seems to be
> the most effective for that particular hardware and drivers.
> 
> Packet counters on eth0 are the real numbers of ongoing frames. Counters
> on portX are pure-software and are updated inside networking stack.
> 
> ---------------------------------------------------------------------
> 
> netif_receive_skb() in Eth driver, no patch:
> 
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-120.01 sec  9.00 GBytes   644 Mbits/sec  413  sender
> [  5]   0.00-120.00 sec  8.99 GBytes   644 Mbits/sec       receiver
> 
> eth0
> RX packets:7097731 errors:0 dropped:0 overruns:0 frame:0
> TX packets:7097702 errors:0 dropped:0 overruns:0 carrier:0
> 
> port0
> RX packets:426050 errors:0 dropped:0 overruns:0 frame:0
> TX packets:6671829 errors:0 dropped:0 overruns:0 carrier:0
> 
> port1
> RX packets:6671681 errors:0 dropped:0 overruns:0 carrier:0
> TX packets:425862 errors:0 dropped:0 overruns:0 carrier:0
> 
> port1.218
> RX packets:6671677 errors:0 dropped:0 overruns:0 frame:0
> TX packets:425851 errors:0 dropped:0 overruns:0 carrier:0
> 
> ---------------------------------------------------------------------
> 
> netif_receive_skb_list() in Eth driver, no patch:
> 
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-120.01 sec  9.48 GBytes   679 Mbits/sec  129  sender
> [  5]   0.00-120.00 sec  9.48 GBytes   679 Mbits/sec       receiver
> 
> eth0
> RX packets:7448098 errors:0 dropped:0 overruns:0 frame:0
> TX packets:7448073 errors:0 dropped:0 overruns:0 carrier:0
> 
> port0
> RX packets:416115 errors:0 dropped:0 overruns:0 frame:0
> TX packets:7032121 errors:0 dropped:0 overruns:0 carrier:0
> 
> port1
> RX packets:7031983 errors:0 dropped:0 overruns:0 frame:0
> TX packets:415941 errors:0 dropped:0 overruns:0 carrier:0
> 
> port1.218
> RX packets:7031978 errors:0 dropped:0 overruns:0 frame:0
> TX packets:415930 errors:0 dropped:0 overruns:0 carrier:0
> 
> ---------------------------------------------------------------------
> 
> napi_gro_receive() in Eth driver, no patch:
> 
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-120.01 sec  10.0 GBytes   718 Mbits/sec  107  sender
> [  5]   0.00-120.00 sec  10.0 GBytes   718 Mbits/sec       receiver
> 
> eth0
> RX packets:7868281 errors:0 dropped:0 overruns:0 frame:0
> TX packets:7868267 errors:0 dropped:0 overruns:0 carrier:0
> 
> port0
> RX packets:429082 errors:0 dropped:0 overruns:0 frame:0
> TX packets:7439343 errors:0 dropped:0 overruns:0 carrier:0
> 
> port1
> RX packets:7439199 errors:0 dropped:0 overruns:0 frame:0
> TX packets:428913 errors:0 dropped:0 overruns:0 carrier:0
> 
> port1.218
> RX packets:7439195 errors:0 dropped:0 overruns:0 frame:0
> TX packets:428902 errors:0 dropped:0 overruns:0 carrier:0
> 
> =====================================================================
> 
> netif_receive_skb() in Eth driver + patch:
> 
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-120.01 sec  12.2 GBytes   870 Mbits/sec  2267 sender
> [  5]   0.00-120.00 sec  12.2 GBytes   870 Mbits/sec       receiver
> 
> eth0
> RX packets:9474792 errors:0 dropped:0 overruns:0 frame:0
> TX packets:9474777 errors:0 dropped:0 overruns:0 carrier:0
> 
> port0
> RX packets:455200 errors:0 dropped:0 overruns:0 frame:0
> TX packets:353288 errors:0 dropped:0 overruns:0 carrier:0
> 
> port1
> RX packets:9019592 errors:0 dropped:0 overruns:0 frame:0
> TX packets:455035 errors:0 dropped:0 overruns:0 carrier:0
> 
> port1.218
> RX packets:353144 errors:0 dropped:0 overruns:0 frame:0
> TX packets:455024 errors:0 dropped:0 overruns:0 carrier:0
> 
> ---------------------------------------------------------------------
> 
> netif_receive_skb_list() in Eth driver + patch:
> 
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-120.01 sec  11.6 GBytes   827 Mbits/sec  2224 sender
> [  5]   0.00-120.00 sec  11.5 GBytes   827 Mbits/sec       receiver
> 
> eth0
> RX packets:8981651 errors:0 dropped:0 overruns:0 frame:0
> TX packets:898187 errors:0 dropped:0 overruns:0 carrier:0
> 
> port0
> RX packets:436159 errors:0 dropped:0 overruns:0 frame:0
> TX packets:335665 errors:0 dropped:0 overruns:0 carrier:0
> 
> port1
> RX packets:8545492 errors:0 dropped:0 overruns:0 frame:0
> TX packets:436071 errors:0 dropped:0 overruns:0 carrier:0
> 
> port1.218
> RX packets:335593 errors:0 dropped:0 overruns:0 frame:0
> TX packets:436065 errors:0 dropped:0 overruns:0 carrier:0
> 
> -----------------------------------------------------------
> 
> napi_gro_receive() in Eth driver + patch:
> 
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-120.01 sec  11.8 GBytes   855 Mbits/sec  122  sender
> [  5]   0.00-120.00 sec  11.8 GBytes   855 Mbits/sec       receiver
> 
> eth0
> RX packets:9292214 errors:0 dropped:0 overruns:0 frame:0
> TX packets:9292190 errors:0 dropped:0 overruns:0 carrier:0
> 
> port0
> RX packets:438516 errors:0 dropped:0 overruns:0 frame:0
> TX packets:347236 errors:0 dropped:0 overruns:0 carrier:0
> 
> port1
> RX packets:8853698 errors:0 dropped:0 overruns:0 frame:0
> TX packets:438331 errors:0 dropped:0 overruns:0 carrier:0
> 
> port1.218
> RX packets:347082 errors:0 dropped:0 overruns:0 frame:0
> TX packets:438320 errors:0 dropped:0 overruns:0 carrier:0
> 
> -----------------------------------------------------------
> 
> The main goal is achieved: we have about 100-200 Mbps of performance
> boost while in-stack skbs are greatly reduced from ~8-9 millions to
> ~350000 (compare port0 TX and port1 RX without patch and with it).

And the number of TCP retries is also lower, which likely means that we
are making better use of the flow control built into the hardware/driver
here?

BTW do you know why you have so many retries though? It sounds like your
flow control is missing a few edge cases, or that you have an incorrect
configuration of your TX admission queue.

> 
> The main bottleneck in gro_cells setup is that GRO layer starts to
> work only after skb are being processed by DSA stack, so they are
> going frame-by-frame until that moment (RX counter on port1).
> 
> If one day we change the way of handling incoming packets (not
> through fake packet_type), we could avoid that by unblocking GRO
> processing in between Eth driver and DSA core.
> With my custom packet_offload for ETH_P_XDSA that works only for
> my CPU tag format I have about ~910-920 Mbps on the same platform.
> This way doesn't fit mainline code of course, so I'm working on
> alternative Rx paths for DSA, e.g. through net_device::rx_handler()
> etc.
> 
> Until then, gro_cells really improve things a lot while the actual
> patch is tiny.
> 
-- 
Florian
