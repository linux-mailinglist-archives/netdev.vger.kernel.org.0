Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBE619FEE7
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 22:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgDFUQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 16:16:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35992 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgDFUQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 16:16:15 -0400
Received: by mail-wr1-f65.google.com with SMTP id k1so1099716wrm.3;
        Mon, 06 Apr 2020 13:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4/JVG1Rluunatq6GnbK5n3QH0bGpghdVbJTjmqP/xOM=;
        b=ZTxU3Wo5Nh26xOIxm0T9d7l6Xku2PnfzQjBPvFylBiLgC2LfKIH+pu7uSNKqEU3lEU
         9ti5r4wMW/yiRzmXg/AkrCerRlkUSA2b7XxZaoglk564CQpBqvOt1plMsM+ClpLBPnkg
         Ui5AREYmR6rMyk1UlANGnlCmhJp8oSw2cXuoko0MNbVVkN3+kUhHDXdd219tZ7WWQg/+
         cvXOkZxTD7KV0K83JvG/avuLUWL6CffSC5g7tkV2OAVPk09idO/FfuiPKqjoSWBs0/Mo
         ffMG9H9TSS3NmS7J6qyQQi+N+RNBJ+1IUXJxPnk7ApBycHTeYz3e/nLYYTwtq8SShCbB
         cVVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4/JVG1Rluunatq6GnbK5n3QH0bGpghdVbJTjmqP/xOM=;
        b=gVS9cv23gCrz+pj5wERB2omM4zuoH4vHKCDkU/B6IPOr+zknt8S1hcDL4q9p2B5x5V
         KYIuq9ozusvcO8eovaZqrBVUHlVRheAIekeejviu+rKIpicHRoevbl0OF4cpL0ux8iA0
         q0B0649ae4psApu+lNHSxKlpvzVom9QRHdQHASyBqzwwSgvPgcD1XqOkgQKTP8ioKZg3
         KOpJWyEv3v+ZUWsyuuiFfoAuFiqf1tGlP9Jp/eOBhiXPxYSHmfp6nHBXMKpJ1+0YUTC+
         XwbosOtCV8680brWNhtFg1sVn6haxYvwF12uGrMoWuI9vsOVzfZGU8paVjVbfFf34c19
         kiPQ==
X-Gm-Message-State: AGi0PuatK2EL2j8i2i20ySLkf8QUt9DS3pkRWm3KaIkCySmk7PPfQDSJ
        M0lm40TLrMBcNvu4kJbMcxk=
X-Google-Smtp-Source: APiQypI70IQ3KjOEYbMUvycXVf9PIJ9y3cS26gajoukYnya2h/yRGNsViD5pTLGvRb1msfpDDwt2oA==
X-Received: by 2002:a5d:6441:: with SMTP id d1mr1064873wrw.301.1586204172262;
        Mon, 06 Apr 2020 13:16:12 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id s7sm3171366wrt.2.2020.04.06.13.16.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 13:16:11 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: add GRO support via gro_cells
To:     Alexander Lobakin <bloodyreaper@yandex.ru>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
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
References: <97a880e4-de7d-1f94-d35b-2635fbd8237e@gmail.com>
 <20200406191113.5983-1-bloodyreaper@yandex.ru>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <c362ec65-ec84-52bb-a06e-d2ffad8bf52d@gmail.com>
Date:   Mon, 6 Apr 2020 13:16:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200406191113.5983-1-bloodyreaper@yandex.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/6/2020 12:11 PM, Alexander Lobakin wrote:
> 06.04.2020, 20:57, "Florian Fainelli" <f.fainelli@gmail.com>:
>> On 4/6/2020 10:34 AM, Alexander Lobakin wrote:
>>>  06.04.2020, 18:21, "Alexander Lobakin" <bloodyreaper@yandex.ru>:
>>>>  06.04.2020, 17:48, "Andrew Lunn" <andrew@lunn.ch>:
>>>>>   On Mon, Apr 06, 2020 at 01:59:10PM +0300, Alexander Lobakin wrote:
>>>>>>    gro_cells lib is used by different encapsulating netdevices, such as
>>>>>>    geneve, macsec, vxlan etc. to speed up decapsulated traffic processing.
>>>>>>    CPU tag is a sort of "encapsulation", and we can use the same mechs to
>>>>>>    greatly improve overall DSA performance.
>>>>>>    skbs are passed to the GRO layer after removing CPU tags, so we don't
>>>>>>    need any new packet offload types as it was firstly proposed by me in
>>>>>>    the first GRO-over-DSA variant [1].
>>>>>>
>>>>>>    The size of struct gro_cells is sizeof(void *), so hot struct
>>>>>>    dsa_slave_priv becomes only 4/8 bytes bigger, and all critical fields
>>>>>>    remain in one 32-byte cacheline.
>>>>>>    The other positive side effect is that drivers for network devices
>>>>>>    that can be shipped as CPU ports of DSA-driven switches can now use
>>>>>>    napi_gro_frags() to pass skbs to kernel. Packets built that way are
>>>>>>    completely non-linear and are likely being dropped without GRO.
>>>>>>
>>>>>>    This was tested on to-be-mainlined-soon Ethernet driver that uses
>>>>>>    napi_gro_frags(), and the overall performance was on par with the
>>>>>>    variant from [1], sometimes even better due to minimal overhead.
>>>>>>    net.core.gro_normal_batch tuning may help to push it to the limit
>>>>>>    on particular setups and platforms.
>>>>>>
>>>>>>    [1] https://lore.kernel.org/netdev/20191230143028.27313-1-alobakin@dlink.ru/
>>>>>
>>>>>   Hi Alexander
>>>>
>>>>  Hi Andrew!
>>>>
>>>>>   net-next is closed at the moment. So you should of posted this with an
>>>>>   RFC prefix.
>>>>
>>>>  I saw that it's closed, but didn't knew about "RFC" tags for that period,
>>>>  sorry.
>>>>
>>>>>   The implementation looks nice and simple. But it would be nice to have
>>>>>   some performance figures.
>>>>
>>>>  I'll do, sure. I think I'll collect the stats with various main receiving
>>>>  functions in Ethernet driver (napi_gro_frags(), napi_gro_receive(),
>>>>  netif_receive_skb(), netif_receive_skb_list()), and with and without this
>>>>  patch to make them as complete as possible.
>>>
>>>  OK, so here we go.
>>>
>>>  My device is 1.2 GHz 4-core MIPS32 R2. Ethernet controller representing
>>>  the CPU port is capable of S/G, fraglists S/G, TSO4/6 and GSO UDP L4.
>>>  Tests are performed through simple IPoE VLAN NAT forwarding setup
>>>  (port0 <-> port1.218) with iperf3 in TCP mode.
>>>  net.core.gro_normal_batch is always set to 16 as that value seems to be
>>>  the most effective for that particular hardware and drivers.
>>>
>>>  Packet counters on eth0 are the real numbers of ongoing frames. Counters
>>>  on portX are pure-software and are updated inside networking stack.
>>>
>>>  ---------------------------------------------------------------------
>>>
>>>  netif_receive_skb() in Eth driver, no patch:
>>>
>>>  [ ID] Interval Transfer Bitrate Retr
>>>  [ 5] 0.00-120.01 sec 9.00 GBytes 644 Mbits/sec 413 sender
>>>  [ 5] 0.00-120.00 sec 8.99 GBytes 644 Mbits/sec receiver
>>>
>>>  eth0
>>>  RX packets:7097731 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:7097702 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  port0
>>>  RX packets:426050 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:6671829 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  port1
>>>  RX packets:6671681 errors:0 dropped:0 overruns:0 carrier:0
>>>  TX packets:425862 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  port1.218
>>>  RX packets:6671677 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:425851 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  ---------------------------------------------------------------------
>>>
>>>  netif_receive_skb_list() in Eth driver, no patch:
>>>
>>>  [ ID] Interval Transfer Bitrate Retr
>>>  [ 5] 0.00-120.01 sec 9.48 GBytes 679 Mbits/sec 129 sender
>>>  [ 5] 0.00-120.00 sec 9.48 GBytes 679 Mbits/sec receiver
>>>
>>>  eth0
>>>  RX packets:7448098 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:7448073 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  port0
>>>  RX packets:416115 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:7032121 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  port1
>>>  RX packets:7031983 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:415941 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  port1.218
>>>  RX packets:7031978 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:415930 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  ---------------------------------------------------------------------
>>>
>>>  napi_gro_receive() in Eth driver, no patch:
>>>
>>>  [ ID] Interval Transfer Bitrate Retr
>>>  [ 5] 0.00-120.01 sec 10.0 GBytes 718 Mbits/sec 107 sender
>>>  [ 5] 0.00-120.00 sec 10.0 GBytes 718 Mbits/sec receiver
>>>
>>>  eth0
>>>  RX packets:7868281 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:7868267 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  port0
>>>  RX packets:429082 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:7439343 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  port1
>>>  RX packets:7439199 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:428913 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  port1.218
>>>  RX packets:7439195 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:428902 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  =====================================================================
>>>
>>>  netif_receive_skb() in Eth driver + patch:
>>>
>>>  [ ID] Interval Transfer Bitrate Retr
>>>  [ 5] 0.00-120.01 sec 12.2 GBytes 870 Mbits/sec 2267 sender
>>>  [ 5] 0.00-120.00 sec 12.2 GBytes 870 Mbits/sec receiver
>>>
>>>  eth0
>>>  RX packets:9474792 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:9474777 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  port0
>>>  RX packets:455200 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:353288 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  port1
>>>  RX packets:9019592 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:455035 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  port1.218
>>>  RX packets:353144 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:455024 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  ---------------------------------------------------------------------
>>>
>>>  netif_receive_skb_list() in Eth driver + patch:
>>>
>>>  [ ID] Interval Transfer Bitrate Retr
>>>  [ 5] 0.00-120.01 sec 11.6 GBytes 827 Mbits/sec 2224 sender
>>>  [ 5] 0.00-120.00 sec 11.5 GBytes 827 Mbits/sec receiver
>>>
>>>  eth0
>>>  RX packets:8981651 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:898187 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  port0
>>>  RX packets:436159 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:335665 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  port1
>>>  RX packets:8545492 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:436071 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  port1.218
>>>  RX packets:335593 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:436065 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  -----------------------------------------------------------
>>>
>>>  napi_gro_receive() in Eth driver + patch:
>>>
>>>  [ ID] Interval Transfer Bitrate Retr
>>>  [ 5] 0.00-120.01 sec 11.8 GBytes 855 Mbits/sec 122 sender
>>>  [ 5] 0.00-120.00 sec 11.8 GBytes 855 Mbits/sec receiver
>>>
>>>  eth0
>>>  RX packets:9292214 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:9292190 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  port0
>>>  RX packets:438516 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:347236 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  port1
>>>  RX packets:8853698 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:438331 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  port1.218
>>>  RX packets:347082 errors:0 dropped:0 overruns:0 frame:0
>>>  TX packets:438320 errors:0 dropped:0 overruns:0 carrier:0
>>>
>>>  -----------------------------------------------------------
>>>
>>>  The main goal is achieved: we have about 100-200 Mbps of performance
>>>  boost while in-stack skbs are greatly reduced from ~8-9 millions to
>>>  ~350000 (compare port0 TX and port1 RX without patch and with it).
>>
>> And the number of TCP retries is also lower, which likely means that we
>> are making better use of the flow control built into the hardware/driver
>> here?
>>
>> BTW do you know why you have so many retries though? It sounds like your
>> flow control is missing a few edge cases, or that you have an incorrect
>> configuration of your TX admission queue.
> 
> Well, I have the same question TBH. All these ~1.5 years that I'm
> working on these switches I have pretty chaotic number of TCP
> retransmissions each time I change something in the code. They are
> less likely to happen when the average CPU load is lower, but ~100
> is the best result I ever got.
> Seems like I should stop trying to push software throughput to
> the max for a while and pay more attention to this and to hardware
> configuration instead and check if I miss something :) 

I have had to debug such a problem on some of our systems recently and
it came down to being a couple of things for those systems:

- as a receiver, we could create fast re-transmissions on the sender
side because of packet loss which was because the switch is able to push
packets faster than the DSA master being able to write them to DRAM. One
way to work around this is to clock the Ethernet MAC higher, at the cost
of power consumption.

- as a sender, we could have fast re-transmissions when we were
ourselves a "fast" CPU (1.7GHz or higher for Gigabit throughput), that
part is still being root caused, but I think it comes down to flow
control being incorrectly set-up in hardware, which means you could lose
packets between your ndo_start_xmit() and not having the software TXQ
assert XON/XOFF properly

So in both cases, packet loss is responsible for those fast
re-transmissions, but they are barely observable (case #1 was, since the
switch port counter did not match the Ethernet MAC MIB counters) since
you have a black hole effect.
-- 
Florian
