Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98144041D7
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 01:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235905AbhIHXhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 19:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhIHXhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 19:37:11 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474D8C061575;
        Wed,  8 Sep 2021 16:36:03 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso73144pjq.4;
        Wed, 08 Sep 2021 16:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=l2Gws221qWRp8GCtH3z2XvKK7KCKX8k0E4WtkqiUUvY=;
        b=GQ0n88KuQUumpL0kdESA5BvuwQZQYtaU0FFxv0gjFTY/MZZCjibwekKqa8+cYHeae3
         pk6jH+7tfeiP8HQVFDwoTLX6HZmPPvG2jffefq6QtiEFbq4X/Jghh6CAs6t/nRgBnrll
         IUXRASWqV+DT4WzNsAO1XNbq9ssW0Tg3IBILGMpdIf4i3BtpCWdxtWk1qnt1GDNgy1Ka
         kuAuijIib/AqI4QE1aHh0rmf5wq2PiNjvlGRfCnfDBjfdKDRkqahRSNfg3jND1DKJMis
         VYmYSGwRPdtZgC/wjM/Vxh6epAAtwHx72M2MD+5GyGVA/eQCP8mWmdfocrB1z4iETrh3
         e7Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=l2Gws221qWRp8GCtH3z2XvKK7KCKX8k0E4WtkqiUUvY=;
        b=8PWiAi7oDXx3IIekm9J3aeO7alLIVZejKKXSY7sadFxtoFiIWSMqvO3B+Qn8ccTGg5
         ePDYWmJhXMJF6tNLiTrvYjtp8zzocnsgzHM1sAJTdI/tzcETvKJc6GQHjOhJ4r7zr/Fe
         KHtJi5fjCCb9Kp8t873WSH9QjrgLrL7spaRMZQ9+QFoWRM/wIogaN9UG3/2to14jUio1
         3Bn3DnbmGvkclXZUI6fEtVZeKVo+Vtm8DS2E7FEESzMK7qqLiXPA2AbgK8co+iaNBpyR
         7p0eV2joDItqz8lBYQipDb2HW4gOVeoLj2zoQD8nlArW81YKuNA1VigBocSCruIV1+Fi
         S8UA==
X-Gm-Message-State: AOAM530nZB9EBt78WFemSeq1I+InDhZftonGzO9ObuZFALUZvGrpuxUU
        Xkn391B9aSkCqke1/s/1Edc=
X-Google-Smtp-Source: ABdhPJzwH2OO72zGiMsrctXktiHD437JjHl1GPJ8ULCSf3k2VV29xo2YXuyLfNtRG/GZ6I36WVes8g==
X-Received: by 2002:a17:902:bcc6:b0:138:d3ca:c356 with SMTP id o6-20020a170902bcc600b00138d3cac356mr179988pls.6.1631144162577;
        Wed, 08 Sep 2021 16:36:02 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id v66sm10112pfc.91.2021.09.08.16.36.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 16:36:02 -0700 (PDT)
Message-ID: <0ce35724-336d-572e-4ba3-e5a014d035fc@gmail.com>
Date:   Wed, 8 Sep 2021 16:36:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: Circular dependency between DSA switch driver and tagging
 protocol driver
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210908220834.d7gmtnwrorhharna@skbuf>
 <e0567cfe-d8b6-ed92-02c6-e45dd108d7d7@gmail.com>
 <20210908221958.cjwuag6oz2fmnd2n@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210908221958.cjwuag6oz2fmnd2n@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/8/2021 3:19 PM, Vladimir Oltean wrote:
> On Wed, Sep 08, 2021 at 03:14:51PM -0700, Florian Fainelli wrote:
>> On 9/8/2021 3:08 PM, Vladimir Oltean wrote:
>>> Hi,
>>>
>>> Since commits 566b18c8b752 ("net: dsa: sja1105: implement TX
>>> timestamping for SJA1110") and 994d2cbb08ca ("net: dsa: tag_sja1105: be
>>> dsa_loop-safe"), net/dsa/tag_sja1105.ko has gained a build and insmod
>>> time dependency on drivers/net/dsa/sja1105.ko, due to several symbols
>>> exported by the latter and used by the former.
>>>
>>> So first one needs to insmod sja1105.ko, then insmod tag_sja1105.ko.
>>>
>>> But dsa_port_parse_cpu returns -EPROBE_DEFER when dsa_tag_protocol_get
>>> returns -ENOPROTOOPT. It means, there is no DSA_TAG_PROTO_SJA1105 in the
>>> list of tagging protocols known by DSA, try again later. There is a
>>> runtime dependency for DSA to have the tagging protocol loaded. Combined
>>> with the symbol dependency, this is a de facto circular dependency.
>>>
>>> So when we first insmod sja1105.ko, nothing happens, probing is deferred.
>>>
>>> Then when we insmod tag_sja1105.ko, we expect the DSA probing to kick
>>> off where it left from, and probe the switch too.
>>>
>>> However this does not happen because the deferred probing list in the
>>> device core is reconsidered for a new attempt only if a driver is bound
>>> to a new device. But DSA tagging protocols are drivers with no struct
>>> device.
>>>
>>> One can of course manually kick the driver after the two insmods:
>>>
>>> echo spi0.1 > /sys/bus/spi/drivers/sja1105/bind
>>>
>>> and this works, but automatic module loading based on modaliases will be
>>> broken if both tag_sja1105.ko and sja1105.ko are modules, and sja1105 is
>>> the last device to get a driver bound to it.
>>>
>>> Where is the problem?
>>
>> I'd say with 994d2cbb08ca, since the tagger now requires visibility into
>> sja1105_switch_ops which is not great, to say the least. You could solve
>> this by:
>>
>> - splitting up the sja1150 between a library that contains
>> sja1105_switch_ops and does not contain the driver registration code
>>
>> - finding a different way to do a dsa_switch_ops pointer comparison, by
>> e.g.: maintaining a boolean in dsa_port that tracks whether a particular
>> driver is backing that port
> 
> What about 566b18c8b752 ("net: dsa: sja1105: implement TX timestamping for SJA1110")?
> It is essentially the same problem from a symbol usage perspective, plus
> the fact that an skb queue belonging to the driver is accessed.

I believe we will have to accept that another indirect function call 
must be made in order to avoid creating a direct symbol dependency with 
sja1110_rcv_meta() would that be acceptable performance wise?
-- 
Florian
