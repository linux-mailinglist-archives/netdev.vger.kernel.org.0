Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F70572C29
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 06:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbiGMEGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 00:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiGMEGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 00:06:46 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA51DA0CF
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 21:06:45 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id dn9so17698389ejc.7
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 21:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LUWmWddMzDtySO2JFnge/iGzRW7Z2XYM2SnGEFSecJw=;
        b=xZedl+kW1g50VCIIQGNbp3XtfQ9rSb1dAK0Lb8BIAeW5FAk7oNAaRYYYJCU3HpBFkt
         swrYEWJDBFlV3AMCnUoAB3OS82jPb7FRSmuy7Pu4kKmhCH4ILCyVV9QDi92gL8oZDixm
         XUrR0o8HBsyMb+Rzal7H09KVL0ahxN3CUbXZZ3W+VTTVEqmo1AnbKPpzRr7WSZDvHxiB
         +QedpRpeqY5aCfAaLe2zo208uoDDknwJAz/A6iMvfB+qx+N6imvBbzXS4AvTfdcjY/Kj
         TDGtXP45i/5UqvSHCUReTnO2uLNdm0Aifg21iXONEYPXqT6r28Yw1/+m/dgUVL1WT7H9
         BP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LUWmWddMzDtySO2JFnge/iGzRW7Z2XYM2SnGEFSecJw=;
        b=D6NUsyaccRw992qJ/kGOWu/XlcpXR5eGHJQgNZNf/CK8IELpv7nZm9w8Uuonz+Bsa1
         DOz8fU2PjCCHJXPyKIURH1Vhnjfzd2gJm8XXIWb4YiRKn+18mJ/Yfz62LpPl2Wj8owj9
         dKvSMfg9FFF0Zxum/Xshb+twkrDr3H90VG0NAtenWxgTVsJ7GYz/RYDaK87nRMN2tmfU
         /vxkFy5t9qnU+p6L1L4OkBTG8wMsGAWGPkKYN6z7Q0+0bg8pTZUg5gc6WmRIxZDOrAFK
         bk/MOy/vQlwK8p/JmGk5peglk04O9sFaSiD605IIQbspHzKoIMGWtXOvc4vmcfVUmraG
         Z7OA==
X-Gm-Message-State: AJIora9gzlsdhDtVN9bNWFFzyp9z2UdaELHq4YVAPMZShoTrynSxkBWe
        /9F5RpGBJnroYZ48Fl+A6dN+ONyMwkQssqSfpqo=
X-Google-Smtp-Source: AGRyM1u8BUCAcx7Qy+VR55zOa4AJwvlgQ8CrVO4/kd1yxNpOfGVAHzKvaWSEInjikKQ0BB2AEAespQ==
X-Received: by 2002:a17:906:8a4a:b0:72b:5b23:3065 with SMTP id gx10-20020a1709068a4a00b0072b5b233065mr1378176ejc.557.1657685203351;
        Tue, 12 Jul 2022 21:06:43 -0700 (PDT)
Received: from [192.168.0.118] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id la13-20020a170907780d00b0072af56103casm4460623ejc.220.2022.07.12.21.06.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 21:06:42 -0700 (PDT)
Message-ID: <88f37f14-54a5-4f9a-ca76-94a8e54769f2@blackwall.org>
Date:   Wed, 13 Jul 2022 07:06:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RESEND PATCH net-next v4] bond: add mac filter option for
 balance-xor
Content-Language: en-US
To:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org
Cc:     Long Xin <lxin@redhat.com>, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <1755bbaad9c3792ce22b8fa4906bb6051968f29e.1657302266.git.jtoppins@redhat.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <1755bbaad9c3792ce22b8fa4906bb6051968f29e.1657302266.git.jtoppins@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/11/22 15:07, Jonathan Toppins wrote:
> Implement a MAC filter that prevents duplicate frame delivery when
> handling BUM traffic. This attempts to partially replicate OvS SLB
> Bonding[1] like functionality without requiring significant change
> in the Linux bridging code.
> 
> A typical network setup for this feature would be:
> 
>              .--------------------------------------------.
>              |         .--------------------.             |
>              |         |                    |             |
>         .-------------------.               |             |
>         |    | Bond 0  |    |               |             |
>         | .--'---. .---'--. |               |             |
>    .----|-| eth0 |-| eth1 |-|----.    .-----+----.   .----+------.
>    |    | '------' '------' |    |    | Switch 1 |   | Switch 2  |
>    |    '---,---------------'    |    |          +---+           |
>    |       /                     |    '----+-----'   '----+------'
>    |  .---'---.    .------.      |         |              |
>    |  |  br0  |----| VM 1 |      |      ~~~~~~~~~~~~~~~~~~~~~
>    |  '-------'    '------'      |     (                     )
>    |      |        .------.      |     ( Rest of Network     )
>    |      '--------| VM # |      |     (_____________________)
>    |               '------'      |
>    |  Host 1                     |
>    '-----------------------------'
> 
> Where 'VM1' and 'VM#' are hosts connected to a Linux bridge, br0, with
> bond0 and its associated links, eth0 & eth1, provide ingress/egress. One
> can assume bond0, br1, and hosts VM1 to VM# are all contained in a
> single box, as depicted. Interfaces eth0 and eth1 provide redundant
> connections to the data center with the requirement to use all bandwidth
> when the system is functioning normally. Switch 1 and Switch 2 are
> physical switches that do not implement any advanced L2 management
> features such as MLAG, Cisco's VPC, or LACP.
> 
> Combining this feature with vlan+srcmac hash policy allows a user to
> create an access network without the need to use expensive switches that
> support features like Cisco's VCP.
> 
> [1] https://docs.openvswitch.org/en/latest/topics/bonding/#slb-bonding
> 
> Co-developed-by: Long Xin <lxin@redhat.com>
> Signed-off-by: Long Xin <lxin@redhat.com>
> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
> ---
> 
> Notes:
>      v2:
>       * dropped needless abstraction functions and put code in module init
>       * renamed variable "rc" to "ret" to stay consistent with most of the
>         code
>       * fixed parameter setting management, when arp-monitor is turned on
>         this feature will be turned off similar to how miimon and arp-monitor
>         interact
>       * renamed bond_xor_recv to bond_mac_filter_recv for a little more
>         clarity
>       * it appears the implied default return code for any bonding recv probe
>         must be `RX_HANDLER_ANOTHER`. Changed the default return code of
>         bond_mac_filter_recv to use this return value to not break skb
>         processing when the skb dev is switched to the bond dev:
>           `skb->dev = bond->dev`
>      
>      v3: Nik's comments
>       * clarified documentation
>       * fixed inline and basic reverse Christmas tree formatting
>       * zero'ed entry in mac_create
>       * removed read_lock taking in bond_mac_filter_recv
>       * made has_expired() atomic and removed critical sections
>         surrounding calls to has_expired(), this also removed the
>         use-after-free that would have occurred:
>             spin_lock_irqsave(&entry->lock, flags);
>                 if (has_expired(bond, entry))
>                     mac_delete(bond, entry);
>             spin_unlock_irqrestore(&entry->lock, flags); <---
>       * moved init/destroy of mac_filter_tbl to bond_open/bond_close
>         this removed the complex option dependencies, the only behavioural
>         change the user will see is if the bond is up and mac_filter is
>         enabled if they try and set arp_interval they will receive -EBUSY
>       * in bond_changelink moved processing of mac_filter option just below
>         mode processing
>      
>      v4:
>       * rebase to latest net-next
>       * removed rcu_read_lock() call in bond_mac_insert()
>       * used specific spin_lock_{}() calls instead of the irqsave version
>       * Outstanding comments from Nik:
>         https://lore.kernel.org/netdev/4c9db6ac-aa24-2ca2-3e44-18cfb23ac1bc@blackwall.org/
>         - old version of the patch still under discussion
>           https://lore.kernel.org/netdev/d2696dab-2490-feb5-ccb2-96906fc652f0@redhat.com/
>           * response: it has been over a month now and no new comments have come in
>             so I am assuming there is nothing left to the discussion

Not really, I didn't have time to adjust my solution, but it's not hard
to solve the multicast ingress. More below.

>         - What if anyone decides at some point 5 seconds are not enough or too much?
>           * response: I think making that configurable at a later time should not
>             prevent the inclusion of the initial feature. >         - This bit is pointless, you still have races even though not 
critical
>           * response: if there are races please point them out simply making a
>             comment about an enum doesn't show the race.

You had race conditions about the flag, now that you always take the 
lock you no longer have them, but also the flag is useless.

>         - This is not scalable at all, you get the lock even to update the
>           expire on *every* packet, most users go for L3 or L3+L4 and will hit
>           this with different flows on different CPUs.
>           * response: we take the lock to update the value, so that receive
>             traffic is not dropped. Further any implementation, bpf or nft,
>             will also have to take locks to update MAC entries. If there is a
>             specific locking order that will be less bad, I would appreciate
>             that discussion. Concerning L3 or L3+L4 hashing this is not the
>             data I have, in fact the most utilized hash is layer2.
> 

Yes, there are more scalable alternatives that are already implemented
in nft and eBPF and you can get them for free if you go with some of the
options below.

To the point, tbh I'm amazed we're still discussing applying this change :)

anyway here are my suggestions:

a) if you insist on adding some new code then at least add only
what is missing, i.e. add a xor mode option to limit ingress mcast only
to the active slave, then use the nftables mac filtering solution that I
gave you and you'll have the best of both worlds, you'll be able to dump
the current macs, edit them if needed, control the filtering time and
have the full nft flexibility, also it will scale much better than this

b) write a 3-4 line bash script that allows mcast only through the 
active slave, and again use the nft solution I gave you for the rest

c) extend the eBPF program I wrote to do mcast filtering, again it'll 
scale much better

(tentative) d) figure out a way to solve the mcast ingress entirely with 
nft, I suspect it's possible but I don't have time to waste to prove it

I don't plan on reviewing the patch in this form because I don't think
it should be applied at all since all of this can be easily implemented
with the available tools, but I won't officially nack it either.
That would be the maintainers' decision.

Cheers,
  Nik
