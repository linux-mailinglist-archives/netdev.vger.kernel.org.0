Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB46D521603
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 14:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241799AbiEJM6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242118AbiEJMzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:55:48 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F755888C1
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 05:51:31 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id gh6so32803224ejb.0
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 05:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=fYmUQRxRCHNbxQg08eFWftvI/Kd6VTybnUX9jhgvtuE=;
        b=l/EtftEtvIIIGt7MXHozSBNu5ya0rj22byUbYv1TKDjRMVHJbkLk1CKYLvKNHccuIH
         ioDLJXY4iTJl5QPxdiK1qfZz08PBVwG7p70FthVNk6y1i/MKAWq9tn5ieMUJ8ZDKg/2j
         Jjhjs2g/ZGOpn8Wu8klUQV8tW+k9pYKGs5kmCHaoXtrqwHj1gQ9nz+y+jpkkWjd2cVQa
         SVsu4o/4aUsCwzozgHs9nZ4aG2z9ELiDvE2v9eJUGNOwDmjygn9DlriVorwCeXKJi0+q
         oy/zJDAE/HPG0pEgC5QKsuMqwiXMJZBJzvfmZthZIF2CznVEPc2kpEjgdfQhynGJEluH
         onQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fYmUQRxRCHNbxQg08eFWftvI/Kd6VTybnUX9jhgvtuE=;
        b=w2Wb9Bafej4eM3pojdLPUd72PEtU2ZUcpMGVf8uO41asY/WKwrfR4twcGE9EHGJh/B
         VwGM7Y82lZ5H+NQ+ZMpohpnMsnmtjsTMb8PjOGtJswnGtahAlkXky3BbKf2pLBWwIbhI
         SUDKlYBkn62HIPawkQlOnr1QXcky6pjXbwve7dnB2gJbw0H3Y4yrFuR6JDwIUAf9zvpQ
         mTDGgVMYaBX6QqivU9NHTSfCfOjuxRpPwrdZPn+s6QkcalPzRccCMByz3kD4/u99Kkjb
         GaXMRp1th2y2kwJ7s9N/0jSJlGrbgEn+d1xhMk7uYZuVCyWMUHj6wMcP6eDCqCjdZ+po
         R6Cg==
X-Gm-Message-State: AOAM532m6U4rnTAk6jSWsNezBCZtKFvJJHT19VaBr4PGYAq07x5TvQ7r
        GEwWARucscCQrShMbBbnPik=
X-Google-Smtp-Source: ABdhPJz4npN37CC0Q2OfiaRvDqvmTvlwImkgiD570ZjS4uzPXl6ny2Tt7IKxkc8u4oZwwD3P5SXxgg==
X-Received: by 2002:a17:906:804b:b0:6f3:8d78:ffa8 with SMTP id x11-20020a170906804b00b006f38d78ffa8mr19693286ejw.588.1652187090367;
        Tue, 10 May 2022 05:51:30 -0700 (PDT)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id p15-20020a170907910f00b006fc308e76absm598643ejq.2.2022.05.10.05.51.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 05:51:29 -0700 (PDT)
Message-ID: <46a4a91b-e068-4b87-f707-f79486b23f67@gmail.com>
Date:   Tue, 10 May 2022 14:51:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: Optimizing kernel compilation / alignments for network
 performance
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Felix Fietkau <nbd@nbd.name>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
 <20220427125658.3127816-1-alexandr.lobakin@intel.com>
 <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
 <CAK8P3a2tA8vkB-G-sQdvoiB8Pj08LRn_Vhf7qT-YdBJQwaGhaA@mail.gmail.com>
 <eec5e665-0c89-a914-006f-4fce3f296699@gmail.com> <YnP1nOqXI4EO1DLU@lunn.ch>
 <510bd08b-3d46-2fc8-3974-9d99fd53430e@gmail.com>
 <CAK8P3a0Rouw8jHHqGhKtMu-ks--bqpVYj_+u4-Pt9VoFOK7nMw@mail.gmail.com>
 <306e9713-5c37-8c6a-488b-bc07f8b8b274@gmail.com>
 <CAK8P3a1nR2VHYJsTy6aCz9qeZD0M2PYNyYgVwUj=_TOJvwCLwg@mail.gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <CAK8P3a1nR2VHYJsTy6aCz9qeZD0M2PYNyYgVwUj=_TOJvwCLwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6.05.2022 11:44, Arnd Bergmann wrote:
> On Fri, May 6, 2022 at 10:55 AM Rafał Miłecki <zajec5@gmail.com> wrote:
>> On 6.05.2022 10:45, Arnd Bergmann wrote:
>>> On Fri, May 6, 2022 at 9:44 AM Rafał Miłecki <zajec5@gmail.com> wrote:
>>>> With
>>>> echo 1 > /sys/class/net/eth0/queues/rx-0/rps_cpus
>>>> my NAT speeds were jumping between 2 speeds:
>>>> 284 Mbps / 408 Mbps
>>>
>>> Can you try using 'numactl -C' to pin the iperf processes to
>>> a particular CPU core? This may be related to the locality of
>>> the user process relative to where the interrupts end up.
>>
>> I run iperf on x86 machines connected to router's WAN and LAN ports.
>> It's meant to emulate end user just downloading from / uploading to
>> Internet some data.
>>
>> Router's only task is doing masquarade NAT here.
> 
> Ah, makes sense. Can you observe the CPU usage to be on
> a particular core in the slow vs fast case then?

With echo 0 > /sys/class/net/eth0/queues/rx-0/rps_cpus
NAT speed was verying between:
a) 311 Mb/s (CPUs load: 100% + 0%)
b) 408 Mb/s (CPUs load: 100% + 62%)

With echo 1 > /sys/class/net/eth0/queues/rx-0/rps_cpus
NAT speed was verying between:
a) 290 Mb/s (CPUs load: 100% + 0%)
b) 410 Mb/s (CPUs load: 100% + 63%)

With echo 2 > /sys/class/net/eth0/queues/rx-0/rps_cpus
NAT speed was stable:
a) 372 Mb/s (CPUs load: 100% + 26%)
b) 375 Mb/s (CPUs load: 82% + 100%)

With echo 3 > /sys/class/net/eth0/queues/rx-0/rps_cpus
NAT speed was verying between:
a) 293 Mb/s (CPUs load: 100% + 0%)
b) 332 Mb/s (CPUs load: 100% + 17%)
c) 374 Mb/s (CPUs load: 81% + 100%)
d) 442 Mb/s (CPUs load: 100% + 75%)



After some extra debugging I found a reason for varying CPU usage &
varying NAT speeds.

My router has a single swtich so I use two VLANs:
eth0.1 - LAN
eth0.2 - WAN
(VLAN traffic is routed to correct ports by switch). On top of that I
have "br-lan" bridge interface briding eth0.1 and wireless interfaces.

For all that time I had /sys/class/net/br-lan/queues/rx-0/rps_cpus set
to 3. So bridge traffic was randomly handled by CPU 0 or CPU 1.

So if I assign specific CPU core to each of two interfaces, e.g.:
echo 1 > /sys/class/net/eth0/queues/rx-0/rps_cpus
echo 2 > /sys/class/net/br-lan/queues/rx-0/rps_cpus
things get stable.

With above I get stable 419 Mb/s (CPUs load: 100% + 64%) on every iperf
session.
