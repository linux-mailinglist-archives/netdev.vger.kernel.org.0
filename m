Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0306E527609
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 08:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbiEOGcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 02:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235777AbiEOGcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 02:32:06 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B090D18E29
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 23:32:04 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id l18so23134253ejc.7
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 23:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=3s5G9vwAfxox8I9MM/M1HHjTNOSGksKMdwJnUSaYtoA=;
        b=jw3zSHSyxvJO6xeeVwSw0P8RZKXy69I1TiDw/O+Tl9PxmJtsNWBk0KZywDmdh1NLFZ
         WnkOx++BJS3Z9XdqPZ7fFBb9Wcie+osk2x4Bh9KvO/+X4g94qicgUBoc7HC/SmAItqj+
         MBqmQnzBGGfb/W/1GIZkQzPaBrHLu8Sp+avcbQAbx2Nj0a7s9zpCOmSPg7SgQvWufjOY
         sUv0fbg5vEh9g8jDGYwl0wupf73hL+0g6aKRu3U6xe+lQwedp7ytaAvXqYRWn+Sx7lXo
         LXsSMX6P2RjWGTRJJqXdLyimZjphhcWjTQLO06zxArAG+gMAJeU+aJVHN7jdj51tZ7Od
         cVlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=3s5G9vwAfxox8I9MM/M1HHjTNOSGksKMdwJnUSaYtoA=;
        b=UF/LFxPI655OaL2mT2FUAPtAJ8tccqF+r1SDRs+NaW0GuWUFEbatRjp2gWjLVPSW4o
         HZq+kYdM6Bont30yGmlPRYTu57SK6pQvQQODqDA437ZuErehVfs0LgAhNirdtKU7/0Ch
         L5DOdMe3qEat3SnlKbSGWF0Ttmobfupvda7RumxLfQeQvZRUHHQl3ppIZnSgfFieyAy5
         9KX81WDQZdc081zztR3Rq5LKV0wByvZPxwzMEq1LVpmx+DV7+T3+6WzhXRLkyD+94uMG
         CmsP77r+o8hybHBu2QiOmE54jZiRme55cMN1tLdIxHpZYL8ZF0fGJJsOzgDAl7uTgDLJ
         zRZA==
X-Gm-Message-State: AOAM533lpILI2tetIdJ7yNVKYKDI0h8oFiXqLft850++wdKM6RaSwBGg
        aYR+NEpezPD0YTK/1eufCvppl3r9R0h2p7Vs3ds=
X-Google-Smtp-Source: ABdhPJwZ362nqiWS42bIdp2vXxSCHKxhvdtpPYfED6F7mdb+X8dhQwV+Djzp4Df4VWa6I+L7Kk05Cw==
X-Received: by 2002:a17:906:d552:b0:6f5:942e:bc5f with SMTP id cr18-20020a170906d55200b006f5942ebc5fmr10402254ejc.110.1652596323064;
        Sat, 14 May 2022 23:32:03 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id w26-20020aa7d29a000000b0042aae307407sm89136edq.21.2022.05.14.23.32.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 May 2022 23:32:02 -0700 (PDT)
Message-ID: <da6bbb3b-344c-f032-fe03-5e8c8ac3c388@blackwall.org>
Date:   Sun, 15 May 2022 09:32:01 +0300
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
In-Reply-To: <4c9db6ac-aa24-2ca2-3e44-18cfb23ac1bc@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/05/2022 00:41, Nikolay Aleksandrov wrote:
> On 13/05/2022 20:43, Jonathan Toppins wrote:
>> Implement a MAC filter that prevents duplicate frame delivery when
>> handling BUM traffic. This attempts to partially replicate OvS SLB
>> Bonding[1] like functionality without requiring significant change
>> in the Linux bridging code.
>>
>> A typical network setup for this feature would be:
>>
>>             .--------------------------------------------.
>>             |         .--------------------.             |
>>             |         |                    |             |
>>        .-------------------.               |             |
>>        |    | Bond 0  |    |               |             |
>>        | .--'---. .---'--. |               |             |
>>   .----|-| eth0 |-| eth1 |-|----.    .-----+----.   .----+------.
>>   |    | '------' '------' |    |    | Switch 1 |   | Switch 2  |
>>   |    '---,---------------'    |    |          +---+           |
>>   |       /                     |    '----+-----'   '----+------'
>>   |  .---'---.    .------.      |         |              |
>>   |  |  br0  |----| VM 1 |      |      ~~~~~~~~~~~~~~~~~~~~~
>>   |  '-------'    '------'      |     (                     )
>>   |      |        .------.      |     ( Rest of Network     )
>>   |      '--------| VM # |      |     (_____________________)
>>   |               '------'      |
>>   |  Host 1                     |
>>   '-----------------------------'
>>
>> Where 'VM1' and 'VM#' are hosts connected to a Linux bridge, br0, with
>> bond0 and its associated links, eth0 & eth1, provide ingress/egress. One
>> can assume bond0, br1, and hosts VM1 to VM# are all contained in a
>> single box, as depicted. Interfaces eth0 and eth1 provide redundant
>> connections to the data center with the requirement to use all bandwidth
>> when the system is functioning normally. Switch 1 and Switch 2 are
>> physical switches that do not implement any advanced L2 management
>> features such as MLAG, Cisco's VPC, or LACP.
>>
>> Combining this feature with vlan+srcmac hash policy allows a user to
>> create an access network without the need to use expensive switches that
>> support features like Cisco's VCP.
>>
>> [1] https://docs.openvswitch.org/en/latest/topics/bonding/#slb-bonding
>>
>> Co-developed-by: Long Xin <lxin@redhat.com>
>> Signed-off-by: Long Xin <lxin@redhat.com>
>> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>> ---
>>
>> Notes:
>>     v2:
>>      * dropped needless abstraction functions and put code in module init
>>      * renamed variable "rc" to "ret" to stay consistent with most of the
>>        code
>>      * fixed parameter setting management, when arp-monitor is turned on
>>        this feature will be turned off similar to how miimon and arp-monitor
>>        interact
>>      * renamed bond_xor_recv to bond_mac_filter_recv for a little more
>>        clarity
>>      * it appears the implied default return code for any bonding recv probe
>>        must be `RX_HANDLER_ANOTHER`. Changed the default return code of
>>        bond_mac_filter_recv to use this return value to not break skb
>>        processing when the skb dev is switched to the bond dev:
>>          `skb->dev = bond->dev`
>>     
>>     v3: Nik's comments
>>      * clarified documentation
>>      * fixed inline and basic reverse Christmas tree formatting
>>      * zero'ed entry in mac_create
>>      * removed read_lock taking in bond_mac_filter_recv
>>      * made has_expired() atomic and removed critical sections
>>        surrounding calls to has_expired(), this also removed the
>>        use-after-free that would have occurred:
>>            spin_lock_irqsave(&entry->lock, flags);
>>                if (has_expired(bond, entry))
>>                    mac_delete(bond, entry);
>>            spin_unlock_irqrestore(&entry->lock, flags); <---
>>      * moved init/destroy of mac_filter_tbl to bond_open/bond_close
>>        this removed the complex option dependencies, the only behavioural
>>        change the user will see is if the bond is up and mac_filter is
>>        enabled if they try and set arp_interval they will receive -EBUSY
>>      * in bond_changelink moved processing of mac_filter option just below
>>        mode processing
>>
>>  Documentation/networking/bonding.rst  |  20 +++
>>  drivers/net/bonding/Makefile          |   2 +-
>>  drivers/net/bonding/bond_mac_filter.c | 201 ++++++++++++++++++++++++++
>>  drivers/net/bonding/bond_mac_filter.h |  37 +++++
>>  drivers/net/bonding/bond_main.c       |  30 ++++
>>  drivers/net/bonding/bond_netlink.c    |  13 ++
>>  drivers/net/bonding/bond_options.c    |  81 +++++++++--
>>  drivers/net/bonding/bonding_priv.h    |   1 +
>>  include/net/bond_options.h            |   1 +
>>  include/net/bonding.h                 |   3 +
>>  include/uapi/linux/if_link.h          |   1 +
>>  11 files changed, 373 insertions(+), 17 deletions(-)
>>  create mode 100644 drivers/net/bonding/bond_mac_filter.c
>>  create mode 100644 drivers/net/bonding/bond_mac_filter.h
>>
> 
[snip]

The same problem solved using a few nftables rules (in case you don't want to load eBPF):
$ nft 'add table netdev nt'
$ nft 'add chain netdev nt bond0EgressFilter { type filter hook egress device bond0 priority 0; }'
$ nft 'add chain netdev nt bond0IngressFilter { type filter hook ingress device bond0 priority 0; }'
$ nft 'add set netdev nt macset { type ether_addr; flags timeout; }'
$ nft 'add rule netdev nt bond0EgressFilter set update ether saddr timeout 5s @macset'
$ nft 'add rule netdev nt bond0IngressFilter ether saddr @macset counter drop'

Cheers,
 Nik
