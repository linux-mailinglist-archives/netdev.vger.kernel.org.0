Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01D71D1ACE
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389505AbgEMQQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389486AbgEMQQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:16:17 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F83C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 09:16:15 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m7so30378plt.5
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 09:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LyPLNuD+8lJumUGsOnWEfikDadYO19lOXX3x0WOZ0d4=;
        b=fefxZYtV5OkHGeHQGJ47X7wvBnWZ4RYtX4TIXnibdt19UmuL9dYhO6/O3PiQCd5J+x
         0UCAK8uGrJbGhKy0Zblf6soJda/W6Kji7L/lsSB+IJpFSmEfGj1ILO7YNtIoYrufceDD
         b2RzeqaDZu5Vd4oe2qeAGhSH9V8nMSFbD7q8J0VZjmIKBTyaRvBKqLEjzP+GcrvZygS0
         DtL6PfyYMNevqrqNglU26lpgFcwmw6T8eQwBcBUpCOXvgh6K7J+eJwxGvYgPHxYGBuX9
         dOVSZNxl8vAHJMLcgXjXbuwBLzJuHU0AVFdSzoFUkICWrZbyrSUiQOG/2f+su21PqmqX
         Rz/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LyPLNuD+8lJumUGsOnWEfikDadYO19lOXX3x0WOZ0d4=;
        b=egsChprI1JOni9p+7/Lc0gvrzuTjnDDf8nx2/D66OjXra3AE35t6fjdVyjv7ufreFB
         V4fswcr8bNAYJ++2va68xzWAUyTr1IotbrwvAJwOy3KtpxqNbUFZwNgB95GdZLzURmhT
         Up5MfiKCwj8QBapb6mS0mC1jplovHEcBajRdcAv3P0utuFW5fSxxIpdc8laMrAKsHUTo
         ZXdEoHjhPwFuPyrXd2cPRuRMXyxh8XFgXTBRRL4abHuGERuLGj+p725AO4JtEK4UuwMY
         bdynm7bfMkR1GIJRHw9OPVDV/R4Q8VV5rl60yBGFNCB6iynl0J51dgmE3qdLj0gi19Y7
         QjMw==
X-Gm-Message-State: AGi0PubhHrKXl261j/US3X5TmyDrFEl6MJdBeGSJ5XryXxBDAbmoXOiS
        /Rh8tDix1Yugg1ipUocznQA=
X-Google-Smtp-Source: APiQypIoeZTSjODFO8Pz4MSVYEUUWgQwLVJESz5Himctavu2NKkLHzmCAaa9W2Wu/c3IsKJw7lICNw==
X-Received: by 2002:a17:90a:26a2:: with SMTP id m31mr34878067pje.128.1589386575038;
        Wed, 13 May 2020 09:16:15 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x12sm11825pfq.209.2020.05.13.09.16.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 09:16:14 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: mt7530: set CPU port to fallback mode
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Tom James <tj17@me.com>,
        Stijn Segers <foss@volatilesystems.org>,
        riddlariddla@hotmail.com, Szabolcs Hubai <szab.hu@gmail.com>,
        Paul Fertser <fercerpav@gmail.com>
References: <20200513153717.15599-1-dqfext@gmail.com>
 <5d77da58-694a-7f9c-53fb-9d107e271d40@gmail.com>
 <CALW65jbN-qvEgz01Shff59S77ArZtNVK7kq74XdyDjuvVSA-_g@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2e3a12eb-64d7-94c1-f7a0-dc3910459aa4@gmail.com>
Date:   Wed, 13 May 2020 09:16:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CALW65jbN-qvEgz01Shff59S77ArZtNVK7kq74XdyDjuvVSA-_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/2020 8:56 AM, DENG Qingfang wrote:
> Hi Florian
> 
> On Wed, May 13, 2020 at 11:46 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>>
>>
>> On 5/13/2020 8:37 AM, DENG Qingfang wrote:
>>> Currently, setting a bridge's self PVID to other value and deleting
>>> the default VID 1 renders untagged ports of that VLAN unable to talk to
>>> the CPU port:
>>>
>>>       bridge vlan add dev br0 vid 2 pvid untagged self
>>>       bridge vlan del dev br0 vid 1 self
>>>       bridge vlan add dev sw0p0 vid 2 pvid untagged
>>>       bridge vlan del dev sw0p0 vid 1
>>>       # br0 cannot send untagged frames out of sw0p0 anymore
>>>
>>> That is because the CPU port is set to security mode and its PVID is
>>> still 1, and untagged frames are dropped due to VLAN member violation.
>>>
>>> Set the CPU port to fallback mode so untagged frames can pass through.
>>
>> How about if the bridge has vlan_filtering=1? The use case you present
>> seems to be valid to me, that is, you may create a VLAN just for the
>> user ports and not have the CPU port be part of it at all.
> 
> I forgot to mention that this is ONLY for vlan_filtering=1
> `bridge vlan` simply won't do anything if VLAN filtering is disabled.

It depends now as of this patch:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=54a0ed0df49609f4e3f098f8943e38e389dc2e15

and sorry I misunderstood your use case, you are changing the default
VLAN for the CPU port through the bridge's master device and you still
want it to be in the same VLAN membership as sw0p0, so yes that looks
correct.
-- 
Florian
