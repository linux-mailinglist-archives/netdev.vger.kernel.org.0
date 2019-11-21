Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D3C1058BC
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 18:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfKURhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 12:37:52 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38052 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfKURhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 12:37:52 -0500
Received: by mail-ed1-f65.google.com with SMTP id s10so3526092edi.5
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 09:37:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JkE7z7iV02poTSqkwr3Ra29UoHUtjAgxnvQV0NuEhO0=;
        b=ehxh0MkucoC7+oje2n0b4C5kUbLqRty37+AGznnwxMaH9oUtove3+3T3vQFv6moH5h
         Fu8bORZmi1s+W0kRGL8pUalkTtc0qORj9E+S60QNbBNGdApX91M5LSpoiyr4KU1yDO5/
         3sriJo6VK/SEWotebIdV76cQ7cb9jzCc1/R5ty2GqsLlGs3vaXEnpZEfvxR3hVgf5wOh
         QYm3pj4j4PUYSO2/RkyaaXH7ZwJ4fAiOUKRoD6kytm6jHIxbfXz4JKhp+87YHe9jboBT
         U9xZo5ttdDiyeNCOy93QaNoUntpXXAUxmX0bTFav4vDXQBCImEsnpvHuN2KCdHG87yPv
         gWKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=JkE7z7iV02poTSqkwr3Ra29UoHUtjAgxnvQV0NuEhO0=;
        b=anblMQjgjE6PuMNuIzHe8uU06pm4/YHavxMLs3cUCecIDyHCnlkZ8zES53G5jJ7JJl
         6eT85YMrY0ihr8v15K+n+gQHFcu7CVfCLrK0OAIm4tsD6fIuqQhWcJ7zy55LHEYxp88S
         XXhOfeSrB4fDb2JmbIE9FnbBV99ZLAShEdHOhebqK+B6KOi6PGQJyi7CwIeVnBQAQIYE
         IeTSEf3UvR3YQLE1KzQWyGPy4sAtw7zaq0i1m9iezsv968m7ihHa0ACEDEUicXaEawzq
         OCmU3vpgpq6bUnw4tzVdMAlwEtISw3sCEsUe4wXX0dgSr5oeSEEuisUKWUpOQCPJDemn
         3xcw==
X-Gm-Message-State: APjAAAWSjn0xod7/jZJ5jh8H8x8Cw1UU6GXv8vFZ/PFFaK8zqTnqNpSK
        qbGI6WAncYUbObrzYF+RuGk2EvEx
X-Google-Smtp-Source: APXvYqzLK3sHlpLIx8y/9CtQeQy8SosgHx1BeZJDlaxgau0V/Fu5gFErIflUHpjIRsteL6HilvTrsQ==
X-Received: by 2002:a17:906:6696:: with SMTP id z22mr1071816ejo.308.1574357869350;
        Thu, 21 Nov 2019 09:37:49 -0800 (PST)
Received: from [10.67.50.53] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c41sm142365eda.87.2019.11.21.09.37.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Nov 2019 09:37:48 -0800 (PST)
Subject: Re: [RFC PATCH net-next] net: dsa: tag_8021q: Allow DSA tags and VLAN
 filtering simultaneously
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
References: <20191117211407.9473-1-olteanv@gmail.com>
 <78f47c04-0758-50f6-ad59-2893849e7dea@gmail.com>
 <CA+h21hpWXj9bFHg4sec2=8KEaXJ2sN4pvyftL4muBCEwrCzEDQ@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <50186dc9-88e1-12f4-f8c8-894e48a1eae9@gmail.com>
Date:   Thu, 21 Nov 2019 09:37:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hpWXj9bFHg4sec2=8KEaXJ2sN4pvyftL4muBCEwrCzEDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/19 2:29 AM, Vladimir Oltean wrote:
> On Mon, 18 Nov 2019 at 06:30, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>> On 11/17/2019 1:14 PM, Vladimir Oltean wrote:
>> [snip]
>>
>>> +best_effort_vlan_filtering
> 
> [snip]
> 
>>> +                     - Cannot terminate VLAN-tagged traffic on local device.
>>> +                       There is no way to deduce the source port from these.
>>> +                       One could still use the DSA master though.
>>
>> Could we use QinQ to possibly solve these problems and would that work
>> for your switch? I do not really mind being restricted to not being able
>> to change the default_pvid or have a reduced VLAN range, but being able
>> to test VLAN tags terminated on DSA slave network devices is a valuable
>> thing to do.
>> --
>> Florian
> 
> I took another look at the hardware manual and there exists a feature
> called the Retagging Table whose purpose I did not understand
> originally. It can do classification on frames with a given { ingress
> port mask, egress port mask, vlan id }, and clone them towards a given
> list of destination ports with a new VID. The table only has space for
> 32 entries though. I think I can use it to keep the CPU copied to all
> non-pvid VLANs received on the front-panel ports. The CPU will still
> see a pvid-tagged frame for each of those, but with the PCP from the
> original frame. The result is that VLAN filtering is still performed
> correctly (non-member VIDs of the front-panel ports are dropped), but
> the tag is consumed by DSA and sockets still see those frames as
> untagged. To me that's fine except for the fact that the CPU will now
> be spammed by offloaded flows even if the switch learns the
> destination to be a front-panel. Just wanted to hear your opinion
> before attempting to prototype this.

That seems like a good idea to me. Back to your RFC patch here, instead
of introducing a "best effort vlan filtering" configuration knob, how
about just restricting the possible VID range when vlan_filtering=1
through the port_vlan_prepare() callback to exclude the problematic
dsa_tag_8021q VID ranges used for port discrimination?
-- 
Florian
