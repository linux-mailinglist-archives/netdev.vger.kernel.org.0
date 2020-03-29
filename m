Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89E3A196D88
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 14:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbgC2Mte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 08:49:34 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44203 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728200AbgC2Mte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 08:49:34 -0400
Received: by mail-lf1-f67.google.com with SMTP id j188so11600441lfj.11
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 05:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hep468mUU9yjlk0lo8Ll5NEANamiPkdiFkjeWP+RKOo=;
        b=CyeDmqtM4uJuQfEsdFN2pxNtv24FmO35iNKb9pPGIpeJC8n4rN8U7q15dMWHoZMDO+
         ywVrdsftEj1zMNJWgoLCkqXyE92t8IRXh/LjHnCsqB8IGlbwr6PA6d1wushJAYORhEZf
         lm5u0E1xYZc85rd7FFTC3pBUaFsYqoWIPEZY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hep468mUU9yjlk0lo8Ll5NEANamiPkdiFkjeWP+RKOo=;
        b=q46YDGnTpxkw9BUr7UpWGVRJ7NfOZ6Tq7nC8g8+N1XyGWpqdSpFTXqqyTtMErfbvob
         n9v8+l8iZ3Py68Gdexm1xP9IQHTG/qI40Xg+v88Fe2O6JN8radf8nfRIJRmD+BlMtfQI
         SZUjfL+ZQar+XpUlNlvAJj4mhv3AcVlFfyHtW2s/fbJK8PxSiGxoKIuPYl5OYzC7/dH8
         GAq08CsK/M/2weWC2gl/xis3SqbVU/Nc6Za3ODVFlbEopSZs7t1Df2uF+ifN9sLxl0If
         1boumCpQvgxtZUCpLmMjwdUD5KNpvFy+s51++eX6vydDqU+MP6lr1/zWWnUzRhNXlmwC
         UAIA==
X-Gm-Message-State: AGi0PuZMbMviUv5uMfvVMnmZNXWVbS7Fv7wD7s6ZS112qRm1S0LT5D0X
        GEbkxxQN19b7Ou+FCft/jAHqnw==
X-Google-Smtp-Source: APiQypIChhd1CI++6HYRSgbFJY8jDrKq1kWctdVyV8E9PxZB8J/CiDMMxUXQ3elJ+KxJ7RGBcFPefw==
X-Received: by 2002:ac2:48b3:: with SMTP id u19mr5166575lfg.84.1585486170611;
        Sun, 29 Mar 2020 05:49:30 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id n23sm5416058lji.59.2020.03.29.05.49.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2020 05:49:29 -0700 (PDT)
Subject: Re: [PATCH net-next 6/6] net: dsa: sja1105: add broadcast and
 per-traffic class policers
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Li Yang <leoyang.li@nxp.com>
References: <20200329005202.17926-1-olteanv@gmail.com>
 <20200329005202.17926-7-olteanv@gmail.com>
 <20200329095712.GA2188467@splinter>
 <CA+h21hoybhxhR3KgfRkAaKyPPJPesbGLWDaDp5O_2yTz05y5jQ@mail.gmail.com>
 <CA+h21hoBp6=Zyc3mX3BVguVs0f8Un6-A3pk9YaZKPgs0efTi3g@mail.gmail.com>
 <cd6f4e55-ff5b-5f64-8211-61b4d87b1f0f@cumulusnetworks.com>
Message-ID: <469feba1-6e3a-712b-e080-681f3addf74c@cumulusnetworks.com>
Date:   Sun, 29 Mar 2020 15:49:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <cd6f4e55-ff5b-5f64-8211-61b4d87b1f0f@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/03/2020 15:02, Nikolay Aleksandrov wrote:
> On 29/03/2020 14:46, Vladimir Oltean wrote:
>> On Sun, 29 Mar 2020 at 14:37, Vladimir Oltean <olteanv@gmail.com> wrote:
>>>
>>> On Sun, 29 Mar 2020 at 12:57, Ido Schimmel <idosch@idosch.org> wrote:
>>>>
>>>> + Nik, Roopa
>>>>
>>>> On Sun, Mar 29, 2020 at 02:52:02AM +0200, Vladimir Oltean wrote:
>>>>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> [snip]
>>>> In the past I was thinking about ways to implement this in Linux. The
>>>> only place in the pipeline where packets are actually classified to
>>>> broadcast / unknown unicast / multicast is at bridge ingress. Therefore,
>>>
>>> Actually I think only 'unknown unicast' is tricky here, and indeed the
>>> bridge driver is the only place in the software datapath that would
>>> know that.
> 
> Yep, unknown unicast is hard to pass outside of the bridge, especially at ingress
> where the bridge hasn't been hit yet. One possible solution is to expose a function
> from the bridge which can make such a decision at the cost of 1 more fdb hash lookup,
> but if the packet is going to hit the bridge anyway that cost won't be that high
> since it will have to do the same. We already have some internal bridge functionality
> exposed for netfilter, tc and some drivers so it would be in line with that.
> I haven't looked into how feasible the above is, so I'm open to other ideas (the
> bridge_slave functions for example, we've discussed such extensions before in other
> contexts). But I think this can be much simpler if we just expose the unknown unicast
> information, the mcast/bcast can be decided by the classifier already or with very
> little change. I think such exposed function can be useful to netfilter as well.
> 

Of course along with the unknown unicast, we should include unknown multicast.

>>> I know very little about frame classification in the Linux network
>>> stack, but would it be possible to introduce a match key in tc-flower
>>> for whether packets have a known destination or not?
>>>
>>>> my thinking was to implement these storm control policers as a
>>>> "bridge_slave" operation. It can then be offloaded to capable drivers
>>>> via the switchdev framework.
>>>>
>>>
>>> I think it would be a bit odd to duplicate tc functionality in the
>>> bridge sysfs. I don't have a better suggestion though.
>>>
>>
>> Not to mention that for hardware like this, to have the same level of
>> flexibility via a switchdev control would mean to duplicate quite a
>> lot of tc functionality. On this 5-port switch I can put a shared
>> broadcast policer on 2 ports (via the ingress_block functionality),
>> and individual policers on the other 3, and the bandwidth budgeting is
>> separate. I can only assume that there are more switches out there
>> that allow this.
>>>>>> I think that if we have this implemented in the Linux bridge, then your
>>>> patch can be used to support the policing of broadcast packets while
>>>> returning an error if user tries to police unknown unicast or multicast
>>>> packets.
>>>
>>> So even if the Linux bridge gains these knobs for flood policers,
>>> still have the dst_mac ff:ff:ff:ff:ff:ff as a valid way to configure
>>> one of those knobs?
>>>
>>>> Or maybe the hardware you are working with supports these types
>>>> as well?
>>>
>>> Nope, on this hardware it's just broadcast, I just checked that. Which
>>> simplifies things quite a bit.
>>>
>>>>
>>>> WDYT?
>>>>
>>>
>>> I don't know.
>>>
>>> Thanks,
>>> -Vladimir
>>
>> -Vladimir
>>
> 

