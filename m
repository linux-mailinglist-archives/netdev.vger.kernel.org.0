Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EB8401639
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 08:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239199AbhIFGNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 02:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234899AbhIFGNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 02:13:04 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBA9C061575
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 23:12:00 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id s12so9542686ljg.0
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 23:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PwV0OyeUEbSPt5xp0qemabyLev8qkG1Kf7Zvb3WwMIs=;
        b=hUjnzcHDjyuH92oLnMlTH9tyfg7ffXY7fp3nnbHnNENJOh99H/pua2g22OcaQTFwGH
         BxocnqT2NlisPuVdzNzpO8XLeLwnL4szlCaMVO/xJBEBv93d/VcrSAp2/Sge06ZNWQ+n
         3E4yt3qtSTh/AVeHhCVvNamBM1Oay7o9IVLo9TaBJyMvAcwOjeinOaZ/uF64jvlIX9fE
         GjqmmDNjM/bMOBpetHlzXPpgFusl6tdJ/SZKHF/IY46hZtgi0O4wr+7p4hxf2pJpdHnn
         2Qn2mLWBKMJvnZoNYIrj0j8fHz4ebRSEvLE8QoCxNxOw7C4ShBfoOi/2H4qYG+PueviA
         Zs9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PwV0OyeUEbSPt5xp0qemabyLev8qkG1Kf7Zvb3WwMIs=;
        b=eV8eNbJ0Uc/0td04w8tizHPYkzauIsdZD4SToofM/zIGMZI/SmNEhh4bHgurKiEggl
         A1TjcgmrJhS73jeLbkGKMR8rb/ehuPLfIium4d0iqNHhblK9jBOxFWTAVmH5ZTA4/Tzm
         kGRL+O2wzeoSSDbM8ABihOvsfjy+gZlHVGBzeXduvd4h4OVcqYpTmqrI9gFofySGh5X8
         tS7+Oi++VcCYqzqIcplGKAPivm45d04lWN/QcF6mU6LgE8i2D//BA7bLy+8Wgc4Gmsh4
         C2W75BgS0Y5mcwfLrzhf1phDV9Y7Iym7w2e0YMD9XvSxgQn4Bh/+BbqR/euL/OEzVZD0
         E86Q==
X-Gm-Message-State: AOAM530Fquoz0zn+qvL1wOh/sC4i/gqhCWEdfUEvznx6LPuxk5zxiFDy
        JVt3Oe1GXOJsDme8RJymwHU=
X-Google-Smtp-Source: ABdhPJw/JQos5GqdaaR2ifqzkhiYNP3K7wMOMYZlWWjkGL3eP306G15bQEiNybc8tRG7ZU16lo5CRA==
X-Received: by 2002:a2e:6c05:: with SMTP id h5mr9695525ljc.42.1630908718414;
        Sun, 05 Sep 2021 23:11:58 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id t2sm936460ljk.125.2021.09.05.23.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Sep 2021 23:11:58 -0700 (PDT)
Subject: Re: [PATCH] net: dsa: b53: Fix IMP port setup on BCM5301x
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210905172328.26281-1-zajec5@gmail.com>
 <05523f76-6846-449e-bc66-5f4d15946ad5@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <10e43c4f-8c96-32e7-6721-b17b7c12bc9a@gmail.com>
Date:   Mon, 6 Sep 2021 08:11:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <05523f76-6846-449e-bc66-5f4d15946ad5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.09.2021 23:16, Florian Fainelli wrote:
> On 9/5/2021 10:23 AM, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> Broadcom's b53 switches have one IMP (Inband Management Port) that needs
>> to be programmed using its own designed register. IMP port may be
>> different than CPU port - especially on devices with multiple CPU ports.
> 
> There are two choices: port 5 or port 8,

Yes. Depending on model I assign 5 or 8 in the b53_chip_data. What did
I miss?


>> For that reason it's required to explicitly note IMP port index and
>> check for it when choosing a register to use.
>>
>> This commit fixes BCM5301x support. Those switches use CPU port 5 while
>> their IMP port is 8. Before this patch b53 was trying to program port 5
>> with B53_PORT_OVERRIDE_CTRL instead of B53_GMII_PORT_OVERRIDE_CTRL(5).
>>
>> It may be possible to also replace "cpu_port" usages with
>> dsa_is_cpu_port() but that is out of the scope of thix BCM5301x fix.
> 
> Actually this would have been well within the scope of this patch.

I guess it's a matter of taste, I prefer to remove "cpu_port" usage
piece by piece. I think it makes it easier to catch mistakes during
review and regression finding easier.

For example I'm not exactly sure how to get rid of "cpu_port" in the:

if (port != dev->cpu_port) {
	b53_force_port_config(dev, dev->cpu_port, 2000,
			      DUPLEX_FULL, true, true);
	b53_force_link(dev, dev->cpu_port, 1);
}


>> Fixes: 967dd82ffc52 ("net: dsa: b53: Add support for Broadcom RoboSwitch")
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> 
> I really don't like the duplication of the "imp_port" and "cpu_port" members, first because this caused us problems before, and second because for all switch entries except the BCM5301X, cpu_port == imp_port, so this a duplication, and a waste of storage space to encode information.

Well, this isn't exactly a duplication as values differ for BCM5301X.

I guess you prefer to handle BCM5301X with extra conditions in code
while I thought it to be cleaner to store that chip data in a struct.

Let's discuss code changes and see how it could be handled differently.


> In fact, there is no such thing as CPU port technically you chose either IMP0 or IMP1. IMP0 is port 8 and IMP1 is port 5.
> 
>> ---
>>   drivers/net/dsa/b53/b53_common.c | 28 +++++++++++++++++++++++++---
>>   drivers/net/dsa/b53/b53_priv.h   |  1 +
>>   2 files changed, 26 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
>> index 5646eb8afe38..604f54112665 100644
>> --- a/drivers/net/dsa/b53/b53_common.c
>> +++ b/drivers/net/dsa/b53/b53_common.c
>> @@ -1144,7 +1144,7 @@ static void b53_force_link(struct b53_device *dev, int port, int link)
>>       u8 reg, val, off;
>>       /* Override the port settings */
>> -    if (port == dev->cpu_port) {
>> +    if (port == dev->imp_port) {
> 
> This should be port == 8

What about devices that have IMP port 5? I think that change would break
b53_force_link() for them.


>>           off = B53_PORT_OVERRIDE_CTRL;
>>           val = PORT_OVERRIDE_EN;
>>       } else {
>> @@ -1168,7 +1168,7 @@ static void b53_force_port_config(struct b53_device *dev, int port,
>>       u8 reg, val, off;
>>       /* Override the port settings */
>> -    if (port == dev->cpu_port) {
>> +    if (port == dev->imp_port) {
> 
> Likewise

Same question.


>>           off = B53_PORT_OVERRIDE_CTRL;
>>           val = PORT_OVERRIDE_EN;
>>       } else {
>> @@ -1236,7 +1236,7 @@ static void b53_adjust_link(struct dsa_switch *ds, int port,
>>       b53_force_link(dev, port, phydev->link);
>>       if (is531x5(dev) && phy_interface_is_rgmii(phydev)) {
>> -        if (port == 8)
>> +        if (port == dev->imp_port)
> 
> That use of port 8 was correct.

I tried to avoid some magic.


>>               off = B53_RGMII_CTRL_IMP;
>>           else
>>               off = B53_RGMII_CTRL_P(port);
>> @@ -2280,6 +2280,7 @@ struct b53_chip_data {
>>       const char *dev_name;
>>       u16 vlans;
>>       u16 enabled_ports;
>> +    u8 imp_port;
>>       u8 cpu_port;
>>       u8 vta_regs[3];
>>       u8 arl_bins;
>> @@ -2304,6 +2305,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
>>           .enabled_ports = 0x1f,
>>           .arl_bins = 2,
>>           .arl_buckets = 1024,
>> +        .imp_port = 5,
> 
> Could have used B53_CPU_PORT_25 here.

I didn't use B53_CPU_PORT* defines as they don't apply anymore. That _25
suffix made sense when support for first devices with CPU/IMP port 5 was
added. They were actually BCM*25 chipsets.

I think we should probably have something like B53_IMP0 and B53_IMP1.
What do you think about proposed names?


>>           .cpu_port = B53_CPU_PORT_25,
>>           .duplex_reg = B53_DUPLEX_STAT_FE,
>>       },
>> @@ -2314,6 +2316,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
>>           .enabled_ports = 0x1f,
>>           .arl_bins = 2,
>>           .arl_buckets = 1024,
>> +        .imp_port = 5,
>>           .cpu_port = B53_CPU_PORT_25,
> 
> and here.
> 
>>           .duplex_reg = B53_DUPLEX_STAT_FE,
>>       },
>> @@ -2324,6 +2327,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
>>           .enabled_ports = 0x1f,
>>           .arl_bins = 4,
>>           .arl_buckets = 1024,
>> +        .imp_port = 8,
>>           .cpu_port = B53_CPU_PORT,
> 
> and B53_CPU_PORT here and for each entry below.
> 
> I will put this patch into my local test rack and see what breaks, and we can address this more cleanly with net-next. Another case where if we had more time to do a proper review we could come up with a small fix, and not create additional technical debt to fix in the next release cycle. Hope's spring is eternal, oh and I just came back from France, so I guess I am full of complaints, too :)

You should have visit Disneyland! ;)
