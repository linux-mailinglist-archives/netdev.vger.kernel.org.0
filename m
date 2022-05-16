Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81951528BE9
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 19:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344228AbiEPRZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 13:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344220AbiEPRY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 13:24:58 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CA8CFD
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 10:24:56 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id g12so3939523edq.4
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 10:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=wFONT99UdzWTBbOdCZ0nawhCHhHpK3WAgPkBP94KotI=;
        b=IwSnI/YVlQxrtYNLkv/wR62j3Ej+dENgskb1j8ri/eOyRZnQstY1P9AgwpCfuN7q+K
         CHXbafHWNmykj1q5W2HH4VufJ5H1wLfJ5dcq0OxZqg58Rc1MEMmhAmmHW2ejwy1UZ1Ch
         bOTQFg1AhgkZktYPjbiko+6cP3j19AabPC6cA7MXK31qfhvJmcUIm/6HCTkyl1hfecbP
         MK8s7DyzzVw9Nps5/kbOiWqOGXdP1T3aiRZyOemlnR2rWtucdFUWK7/ugmBg4gko61ya
         /iirmkMTVFjxn+blKro2/mz/3Y7fgG3OT2kaDzksGYgCsuzfNmzVZYGGrfCmahmn8cJq
         ugBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=wFONT99UdzWTBbOdCZ0nawhCHhHpK3WAgPkBP94KotI=;
        b=LUnKZwSCoYvmQaPDAk8moZKO5AJv/0SR8XMRMf+Jn5Zlv5olU9XEv/GR3si/YsmqDw
         3AnYQfXbPLgWaURRYasEUmkp8UmTHSjMfeC+tNSn+ALomXLL9cL2n3tW8E4weJinHsBq
         ALANtaP8VbPE7ekuCC9TLKtRBJ82nsY0ZZfiLQNDKFdvNevx0iGJSvh8IH0bsaYJfuCK
         YyI7w4ZqcDE7A7F/NRrMf/6sDrE9K41g40sEIG1Ev7frbCYnmVZg8bwzmfBXzu2uQDbt
         ViYjtnzsk7tFLdPx1d+uMOyXwDZ6dl6boWozVu1xVjxvvdFX031I79KCYy6u5ziim5l7
         /i0w==
X-Gm-Message-State: AOAM532IP10LqA022rLnjgRZ6DNjHTQwUaFdhORsyWNrJQU3ENLyl2VO
        4CrKSHMY+vjQgsn8tXpwDd/tVQ==
X-Google-Smtp-Source: ABdhPJyaV5u0KOpQYca3Ip3EStQJlIRjcJKv+ReXjH7yx4sa1BvQ45OmvZvQ1rB64CGftbHMKWpxpA==
X-Received: by 2002:a05:6402:430f:b0:427:d034:295b with SMTP id m15-20020a056402430f00b00427d034295bmr14339299edc.126.1652721895342;
        Mon, 16 May 2022 10:24:55 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id cx4-20020a05640222a400b0042ac2b71078sm98950edb.55.2022.05.16.10.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 10:24:54 -0700 (PDT)
Message-ID: <95419cc0-9ef7-9956-3fe3-b4304a45be33@blackwall.org>
Date:   Mon, 16 May 2022 20:24:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v3] bond: add mac filter option for balance-xor
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org
Cc:     toke@redhat.com, Long Xin <lxin@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <b32eb6656d5a54c0cde6277e9fc5c249c63489ca.1652463336.git.jtoppins@redhat.com>
 <4c9db6ac-aa24-2ca2-3e44-18cfb23ac1bc@blackwall.org>
 <da6bbb3b-344c-f032-fe03-5e8c8ac3c388@blackwall.org>
 <6431569f-fb09-096e-7a89-284a71aa5c0f@redhat.com>
 <53357187-aedf-20dd-a331-bc501aa0484e@blackwall.org>
In-Reply-To: <53357187-aedf-20dd-a331-bc501aa0484e@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/05/2022 20:22, Nikolay Aleksandrov wrote:
> On 16/05/2022 17:06, Jonathan Toppins wrote:
>> On 5/15/22 02:32, Nikolay Aleksandrov wrote:
>>> On 15/05/2022 00:41, Nikolay Aleksandrov wrote:
>>>> On 13/05/2022 20:43, Jonathan Toppins wrote:
>>>>> Implement a MAC filter that prevents duplicate frame delivery when
>>>>> handling BUM traffic. This attempts to partially replicate OvS SLB
>>>>> Bonding[1] like functionality without requiring significant change
>>>>> in the Linux bridging code.
>>>>>
>>>>> A typical network setup for this feature would be:
>>>>>
>>>>>              .--------------------------------------------.
>>>>>              |         .--------------------.             |
>>>>>              |         |                    |             |
>>>>>         .-------------------.               |             |
>>>>>         |    | Bond 0  |    |               |             |
>>>>>         | .--'---. .---'--. |               |             |
>>>>>    .----|-| eth0 |-| eth1 |-|----.    .-----+----.   .----+------.
>>>>>    |    | '------' '------' |    |    | Switch 1 |   | Switch 2  |
>>>>>    |    '---,---------------'    |    |          +---+           |
>>>>>    |       /                     |    '----+-----'   '----+------'
>>>>>    |  .---'---.    .------.      |         |              |
>>>>>    |  |  br0  |----| VM 1 |      |      ~~~~~~~~~~~~~~~~~~~~~
>>>>>    |  '-------'    '------'      |     (                     )
>>>>>    |      |        .------.      |     ( Rest of Network     )
>>>>>    |      '--------| VM # |      |     (_____________________)
>>>>>    |               '------'      |
>>>>>    |  Host 1                     |
>>>>>    '-----------------------------'
>>>>>
>>>>> Where 'VM1' and 'VM#' are hosts connected to a Linux bridge, br0, with
>>>>> bond0 and its associated links, eth0 & eth1, provide ingress/egress. One
>>>>> can assume bond0, br1, and hosts VM1 to VM# are all contained in a
>>>>> single box, as depicted. Interfaces eth0 and eth1 provide redundant
>>>>> connections to the data center with the requirement to use all bandwidth
>>>>> when the system is functioning normally. Switch 1 and Switch 2 are
>>>>> physical switches that do not implement any advanced L2 management
>>>>> features such as MLAG, Cisco's VPC, or LACP.
>>>>>
>>>>> Combining this feature with vlan+srcmac hash policy allows a user to
>>>>> create an access network without the need to use expensive switches that
>>>>> support features like Cisco's VCP.
>>>>>
>>>>> [1] https://docs.openvswitch.org/en/latest/topics/bonding/#slb-bonding
>>>>>
>>>>> Co-developed-by: Long Xin <lxin@redhat.com>
>>>>> Signed-off-by: Long Xin <lxin@redhat.com>
>>>>> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>>>>> ---
>>>>>
>>>>> Notes:
>>>>>      v2:
>>>>>       * dropped needless abstraction functions and put code in module init
>>>>>       * renamed variable "rc" to "ret" to stay consistent with most of the
>>>>>         code
>>>>>       * fixed parameter setting management, when arp-monitor is turned on
>>>>>         this feature will be turned off similar to how miimon and arp-monitor
>>>>>         interact
>>>>>       * renamed bond_xor_recv to bond_mac_filter_recv for a little more
>>>>>         clarity
>>>>>       * it appears the implied default return code for any bonding recv probe
>>>>>         must be `RX_HANDLER_ANOTHER`. Changed the default return code of
>>>>>         bond_mac_filter_recv to use this return value to not break skb
>>>>>         processing when the skb dev is switched to the bond dev:
>>>>>           `skb->dev = bond->dev`
>>>>>           v3: Nik's comments
>>>>>       * clarified documentation
>>>>>       * fixed inline and basic reverse Christmas tree formatting
>>>>>       * zero'ed entry in mac_create
>>>>>       * removed read_lock taking in bond_mac_filter_recv
>>>>>       * made has_expired() atomic and removed critical sections
>>>>>         surrounding calls to has_expired(), this also removed the
>>>>>         use-after-free that would have occurred:
>>>>>             spin_lock_irqsave(&entry->lock, flags);
>>>>>                 if (has_expired(bond, entry))
>>>>>                     mac_delete(bond, entry);
>>>>>             spin_unlock_irqrestore(&entry->lock, flags); <---
>>>>>       * moved init/destroy of mac_filter_tbl to bond_open/bond_close
>>>>>         this removed the complex option dependencies, the only behavioural
>>>>>         change the user will see is if the bond is up and mac_filter is
>>>>>         enabled if they try and set arp_interval they will receive -EBUSY
>>>>>       * in bond_changelink moved processing of mac_filter option just below
>>>>>         mode processing
>>>>>
>>>>>   Documentation/networking/bonding.rst  |  20 +++
>>>>>   drivers/net/bonding/Makefile          |   2 +-
>>>>>   drivers/net/bonding/bond_mac_filter.c | 201 ++++++++++++++++++++++++++
>>>>>   drivers/net/bonding/bond_mac_filter.h |  37 +++++
>>>>>   drivers/net/bonding/bond_main.c       |  30 ++++
>>>>>   drivers/net/bonding/bond_netlink.c    |  13 ++
>>>>>   drivers/net/bonding/bond_options.c    |  81 +++++++++--
>>>>>   drivers/net/bonding/bonding_priv.h    |   1 +
>>>>>   include/net/bond_options.h            |   1 +
>>>>>   include/net/bonding.h                 |   3 +
>>>>>   include/uapi/linux/if_link.h          |   1 +
>>>>>   11 files changed, 373 insertions(+), 17 deletions(-)
>>>>>   create mode 100644 drivers/net/bonding/bond_mac_filter.c
>>>>>   create mode 100644 drivers/net/bonding/bond_mac_filter.h
>>>>>
>>>>
>>> [snip]
>>>
>>> The same problem solved using a few nftables rules (in case you don't want to load eBPF):
>>> $ nft 'add table netdev nt'
>>> $ nft 'add chain netdev nt bond0EgressFilter { type filter hook egress device bond0 priority 0; }'
>>> $ nft 'add chain netdev nt bond0IngressFilter { type filter hook ingress device bond0 priority 0; }'
>>> $ nft 'add set netdev nt macset { type ether_addr; flags timeout; }'
>>> $ nft 'add rule netdev nt bond0EgressFilter set update ether saddr timeout 5s @macset'
>>> $ nft 'add rule netdev nt bond0IngressFilter ether saddr @macset counter drop'
>>>
>>
>> I get the following when trying to apply this on a fedora 35 install.
>>
>> root@fedora ~]# ip link add bond0 type bond mode balance-xor xmit_hash_policy vlan+srcmac
>> [root@fedora ~]# nft 'add table netdev nt'
>> [root@fedora ~]# nft 'add chain netdev nt bond0EgressFilter { type filter hook egress device bond0 priority 0; }'
>> Error: unknown chain hook
>> add chain netdev nt bond0EgressFilter { type filter hook egress device bond0 priority 0; }
>>                                                          ^^^^^^
>> [root@fedora ~]# uname -a
>> Linux fedora 5.17.5-200.fc35.x86_64 #1 SMP PREEMPT Thu Apr 28 15:41:41 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
>>
> 
> Well, take it up with the Fedora nftables package maintainer. :) 
> 
> Your nftables version is old (I'd guess <1.0.1):
>  commit 510c4fad7e78
>  Author: Lukas Wunner <lukas@wunner.de>
>  Date:   Wed Mar 11 13:20:06 2020 +0100
> 
>      src: Support netdev egress hook
> 
> $ git tag --contains 510c4fad7e78f
> v1.0.1
> v1.0.2
> 
> I just tested it[1] on Linux 5.16.18-200.fc35.x86_64 #1 SMP PREEMPT Mon Mar 28 14:10:07 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
> 
> Cheers,
>  Nik
> 
> [1] You can clearly see the dynamically learned mac on egress (52:54:00:23:5f:13) and traffic
>     with that source is now blocked on ingress.
> 
> $ nft -a list table netdev nt
> 	set macset { # handle 10
> 		type ether_addr
> 		size 65535
> 		flags timeout
> 		elements = { 52:54:00:23:5f:13 timeout 5s expires 4s192ms }
> 	}
> 
> 	chain bond0EgressFilter { # handle 8
> 		type filter hook egress device "bond0" priority filter; policy accept;
> 		update @macset { ether saddr timeout 5s } # handle 11
> 	}
> 
> 	chain bond0IngressFilter { # handle 9
> 		type filter hook ingress device "bond0" priority filter; policy accept;
> 	}
> 

Oops, pasted an old list before adding the ingress rule:
	chain bond0IngressFilter { # handle 9
		type filter hook ingress device "bond0" priority filter; policy accept;
		ether saddr @macset counter packets 120 bytes 7680 drop # handle 15
	}

