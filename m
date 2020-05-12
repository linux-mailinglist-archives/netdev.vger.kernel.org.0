Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A26A1CE971
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 02:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgELADs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725836AbgELADr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:03:47 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6328CC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:03:47 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s8so13149297wrt.9
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I2FrCAz922jG34V6yiFM4t/ZxUaY1QrvQktqINJp3Vg=;
        b=VceTA3vtt/ca0YijCmKKWRyUjmRHJKhofYJricDRV7g2mnCKBSalfnVGo1ndmODfwA
         dXwtL9YZk3pr753AhA5MRhUxdnpPzOCkFgVaatjjgTWdB6brulhcW0SvOHRv6+TtBg2v
         62nHqrrhDKfIuQ7iH56Cb8B9YvhkfYMc4UhDOm+Qu2drrH+hSmHavnFYct6WVRQtp/VY
         SXLaBopkIbqdVExFnrNdWJlI5XLZUoXHVi8wD1iid7C9izBcfOoUoiYlnbwxwnketD3Q
         5+6gMsXwW2f22LW34afXlP1mVcG9FDWCLoCXVvIr9LRUcMkk0qO6AD+gUacomZeh42Am
         AadA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I2FrCAz922jG34V6yiFM4t/ZxUaY1QrvQktqINJp3Vg=;
        b=V/foLNPzNuykSz1MnPJ9mUI2DZ3DcfP3k//anwvfYMOUBGBInhp4hZFPSaQjjt0TyI
         PwanbWZ7Kbvz3Bg6AT+z6eRvic7+X+4qxEKrwtbh2UL8+VdcP0F+fZa4HQST2UX6VNUu
         /LiukPGKxDU7/2G96amo1cPccKZc5EZzNtMUTVfyrqV4f7Elu6Duju3NVKwayEgcn0hj
         vky8sFfOiLdghKosB5KJCm6eaKfIEs6vmOa0nuifs2PWjTUf2B479JfMFnj5unAvw5NF
         fO+broo9pZxRxeiFKt7o6Kz0HS0BcHZf7IzH5XlJNtZPYVv4InnLKcCf0gs8gsLjBGlp
         v+sg==
X-Gm-Message-State: AGi0PuaibUHhSfhC31HJ8D1yRetQrWwVznM/ljrcQVs4Agewa7kxEoAY
        ha1c9d+WF+/ToSGCyH8BM+mJlslm
X-Google-Smtp-Source: APiQypLlcq+clWAo83NMoVvXt0hEkj8WeCPLTiTEdb4x4b+jDAqFECztY7hwCQ0wGYfSfH4RWfj0fw==
X-Received: by 2002:adf:a4c5:: with SMTP id h5mr21387778wrb.408.1589241825833;
        Mon, 11 May 2020 17:03:45 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u127sm29165842wme.8.2020.05.11.17.03.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 17:03:45 -0700 (PDT)
Subject: Re: [PATCH net-next 0/4] DSA: promisc on master, generic flow
 dissector code
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <20200511202046.20515-1-olteanv@gmail.com>
 <525db137-0748-7ae1-ed7f-ee2c74820436@gmail.com>
 <CA+h21hqbiMfm+h994eV=7vRghapJm7HzybauQcggLhfs7At+fg@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5d60fb20-f0df-7c02-e8d4-1963ffaf79d5@gmail.com>
Date:   Mon, 11 May 2020 17:03:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hqbiMfm+h994eV=7vRghapJm7HzybauQcggLhfs7At+fg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 4:52 PM, Vladimir Oltean wrote:
> On Tue, 12 May 2020 at 02:28, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>>
>>
>> On 5/11/2020 1:20 PM, Vladimir Oltean wrote:
>>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>>
>>> The initial purpose of this series was to implement the .flow_dissect
>>> method for sja1105 and for ocelot/felix. But on Felix this posed a
>>> problem, as the DSA headers were of different lengths on RX and on TX.
>>> A better solution than to just increase the smaller one was to also try
>>> to shrink the larger one, but in turn that required the DSA master to be
>>> put in promiscuous mode (which sja1105 also needed, for other reasons).
>>>
>>> Finally, we can add the missing .flow_dissect methods to ocelot and
>>> sja1105 (as well as generalize the formula to other taggers as well).
>>
>> On a separate note, do you have any systems for which it would be
>> desirable that the DSA standalone port implemented receive filtering? On
>> BCM7278 devices, the Ethernet MAC connected to the switch is always in
>> promiscuous mode, and so we rely on the switch not to flood the CPU port
>> unnecessarily with MC traffic (if nothing else), this is currently
>> implemented in our downstream kernel, but has not made it upstream yet,
>> previous attempt was here:
>>
>> https://www.spinics.net/lists/netdev/msg544361.html
>>
>> I would like to revisit that at some point.
>> --
>> Florian
> 
> Yes, CPU filtering of traffic (not just multicast) is one of the
> problems we're facing. I'll take a look at your patches and maybe I'll
> pick them up.

The part that modifies DSA to program the known MC addresses should
still be largely applicable, there were essentially two problems that I
was facing, which could be tackled separately.

1) flooding of unknown MC traffic on DSA standalone ports is not very
intuitive if you come from NICs that did filtering before. We should
leverage a DSA switch driver's ability to support port_egress_floods and
support port_mdb_add and combine them to avoid flooding the CPU port.

2) Programming of known multicast addresses for VLAN devices on top of
DSA standalone ports while the switch implements global VLAN filtering.
In that case when we get to the DSA slave device's ndo_set_rx_mode() we
have lost all information about which VID the MAC address is coming from
so we cannot insert the MAC address with the correct VID to support
proper filtering. TI's cpsw driver implements a super complicated scheme
to solve that problem and this was worked on by Ivan in a more generic
and usable form: https://lwn.net/Articles/780783/
-- 
Florian
