Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 171BE96C82
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730821AbfHTWn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:43:26 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43133 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730638AbfHTWn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:43:26 -0400
Received: by mail-pg1-f193.google.com with SMTP id k3so117821pgb.10
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 15:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TX1LWBxz+hsit2YpPaBGUQ86UK0fsGRMKWPSOH0rwCs=;
        b=T92LGQ3aBu5pxlQeowQQrxqERnu7h8y3qNCya+ZDH7CwhZuLzsZefPc60r+zrOlRVP
         cFO7ve4eCrM0LZAn4srXNOogNPsMYt1zSSk44OqANKm436n+nA467kISmv3AEkakcOPi
         3dw3cTM7HykpuG6cUK3IBrPAjldmNuTqOgZpJyVBfFVVRn7Iz3ZdP20jZcvnR6Ll+bR8
         /YlK6jHZtEvlDFu9r1nMr17aT+1DJv9KZVF4b8srnk4zby9DeHIkwJEQIUY8/oYDpO1i
         wO3aae9+XJgWD7TiLIy0kCT+oodSEdHwkdFD44LEZblT7A/ykfi4Cgup/4N+UADx0IHl
         WhVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=TX1LWBxz+hsit2YpPaBGUQ86UK0fsGRMKWPSOH0rwCs=;
        b=HAfzN8pxAvcs5g/eZ0D3Zbkl9Tk7BxvNtZlLpi4wtkgVPEnY72e7sWofK37pCIi5FD
         aFAIE655pJe8pTW1tO6oi6/ygRzXwniKaR3lRbXLr16vRwZrpfHGt3w2/PTNmTYK0riE
         j/Ql4xJyL2Hm3VJYFncTCXGGHBMZmQVRfk0tyy3bNQCvNxNJCWXwY2SCXVMriqcklDFL
         5NrTHIXOlKpY/XC6Nl05tGNoRxlFMIYG51XzD1l1fwxxL1tYSZjWP+zpAdDpMfzojSgl
         rbzq9WA+wED/Z7golPI1iJX0xRfZJ9JTQw/EmURBvZZ/qTgKiD4nOaL+Rlxyg+rlyUXX
         MpgQ==
X-Gm-Message-State: APjAAAUDIx5dJUOWmd+e4h0+Xx+sHdam47KhLLO04/C0QGLiCaRnH1zj
        TsbPqbIUHmeaKIu6wGFFlbMjEPAU
X-Google-Smtp-Source: APXvYqzyhZ13LAIVSVESDsA412N6RB/bWOg+07L8m6v8NT4qeOWZ3O44QVqXi+DETBzT14FbQxmFOw==
X-Received: by 2002:a63:de4f:: with SMTP id y15mr27547947pgi.239.1566341004849;
        Tue, 20 Aug 2019 15:43:24 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id v8sm20218979pgs.82.2019.08.20.15.43.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 15:43:24 -0700 (PDT)
Subject: Re: [PATCH net-next 4/6] net: dsa: Don't program the VLAN as pvid on
 the upstream port
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
References: <20190820000002.9776-1-olteanv@gmail.com>
 <20190820000002.9776-5-olteanv@gmail.com>
 <19610afd-298a-e434-00ea-48eb5b143c1b@gmail.com>
 <CA+h21hpCP2KpTnCuki1M6tkQ1Qv-ex5MfKHbwQXsqotoh3ndKw@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <39e6fc4a-5aba-03e4-d7a9-09d2f2a27f7e@gmail.com>
Date:   Tue, 20 Aug 2019 15:43:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hpCP2KpTnCuki1M6tkQ1Qv-ex5MfKHbwQXsqotoh3ndKw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/19 5:09 AM, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Tue, 20 Aug 2019 at 06:15, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>>
>>
>> On 8/19/2019 5:00 PM, Vladimir Oltean wrote:
>>> Commit b2f81d304cee ("net: dsa: add CPU and DSA ports as VLAN members")
>>> programs the VLAN from the bridge into the specified port as well as the
>>> upstream port, with the same set of flags.
>>>
>>> Consider the typical case of installing pvid 1 on user port 1, pvid 2 on
>>> user port 2, etc. The upstream port would end up having a pvid equal to
>>> the last user port whose pvid was programmed from the bridge. Less than
>>> useful.
>>>
>>> So just don't change the pvid of the upstream port and let it be
>>> whatever the driver set it internally to be.
>>
>> This patch should allow removing the !dsa_is_cpu_port() checks from
>> b53_common.c:b53_vlan_add, about time :)
>>
>> It seems to me that the fundamental issue here is that because we do not
>> have a user visible network device that 1:1 maps with the CPU (or DSA)
>> ports for that matter (and for valid reasons, they would represent two
>> ends of the same pipe), we do not have a good way to control the CPU
>> port VLAN attributes.
>>
>> There was a prior attempt at allowing using the bridge master device to
>> program the CPU port's VLAN attributes, see [1], but I did not follow up
>> with that until [2] and then life caught me. If you can/want, that would
>> be great (not asking for TPS reports).
>>
>> [1]:
>> https://lists.linuxfoundation.org/pipermail/bridge/2016-November/010112.html
>> [2]:
>> https://lore.kernel.org/lkml/20180624153339.13572-1-f.fainelli@gmail.com/T/
>>
> 
> So what was the conclusion of that discussion? Should you or should
> you not add the check for vlan->flags & BRIDGE_VLAN_INFO_BRENTRY?

I was not able to test that change, and got distracted for months
(years?) doing "other stuff" that is not DSA related.

> I don't exactly handle the meaning of 'master' and 'self' options from
> a user perspective.
> Right now (no patches applied) I get the following behavior in DSA
> (swp2 is already member of br0):
> 
> $ echo 1 | sudo tee /sys/class/net/br0/bridge/vlan_filtering
> $ sudo bridge vlan add vid 100 dev swp2
> $ sudo bridge vlan add vid 101 dev swp2 self
> RTNETLINK answers: Operation not supported
> $ sudo bridge vlan add vid 102 dev swp2 master
> $ sudo bridge vlan add vid 103 dev br0
> RTNETLINK answers: Operation not supported
> $ sudo bridge vlan add vid 104 dev br0 self
> $ sudo bridge vlan add vid 105 dev br0 master
> RTNETLINK answers: Operation not supported
> 
> $ bridge vlan
> port    vlan ids
> eth0     1 PVID Egress Untagged
> 
> swp5     1 PVID Egress Untagged
> 
> swp2     1 PVID Egress Untagged
>          100
>          102
> 
> swp3     1 PVID Egress Untagged
> 
> swp4     1 PVID Egress Untagged
> 
> br0      1 PVID Egress Untagged
>          104
> 
> Who returns EOPNOTSUPP for VID 101 and why?
> Why is VID 102 not installed in br0? This part I don't understand from
> your patchset. Does it mean that the CPU port (br0) will have to be
> explicitly configured from now on, even if I run the commands on swp2
> with 'master'?

This does not really answer your questions, but maybe let's agree on the
user visible behavior. My expectations would be the following should be
happening with this patch applied:

- when the VLAN is created for the first and is configured on either the
bridge master device (br0) or an user port (swp2), it gets programmed
into the switch for the CPU port and respectively CPU port and swp2 port

- when you change the bridge master device VLAN attributes, or
add/delete a new one, the programming targets only the CPU port with the
proper operation

That way, there would be no change in how the initial VLAN programming
is done, in that the CPU port still gets programmed, but later on, if
you want e.g.: your CPU port not to be tagged, but untagged into a
particular VLAN.

My upcoming weeks don't look great in terms of resuming active or semi
active DSA work, but working with the DSA mock-up driver might be an
option to avoid spending too much time testing on real HW.
-- 
Florian
