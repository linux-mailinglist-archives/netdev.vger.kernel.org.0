Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6CA300AE2
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbhAVSLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729920AbhAVSBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 13:01:37 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BC0C061356
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 10:00:11 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id x18so3722594pln.6
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 10:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KMDRJXbe1nfFKjRKNHA8P+eY7UbY8CDHxZaXaZDh8nw=;
        b=TduAjDN09Le2NgfgE9Qe87oLbzNwxJPLkpq8huD3k1Edu0o6OE7Z8JGEg4VtvdyVnW
         H9f+tVKnIFxInBskOdr9gx9idAatuT7oZfFE+P1mSMu3WriXTBd8BCegUcozjbJqMoB3
         HkdZ3LuLaSdA14Pjpc1x48SqFULbF+bUh6UUeVYrWZ9UJ0bxW/bD8vffHPAyDe/dJgBe
         t4zYNA0kz6Ixx8O9uRNjvBoyi0Cw18G+IdI9pGktPsXGYMqCaVxDPCPHuabWyUGWeWYT
         ynFqdDJUDIRzHdNJ1Gjj26/9MWWu6T8SgM4YiOgicPwg4ctmij8BqOctYBg+72HHIqkm
         UiNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KMDRJXbe1nfFKjRKNHA8P+eY7UbY8CDHxZaXaZDh8nw=;
        b=R13q/kxr6hBi/N8Trczgf0OZBOmX117mKjkuPPsMuPNktbjxgTI8OowJvSMbNzgonI
         pfhIsCZ0zmmlKAFQkgb5tqu7Ecm7ThbwyUNLo9NSpwyaG5YI7lymZA4rKhwfkWek5Kee
         P0CtPIYJkHf8av7hF0PeS4IWBhck3aZyzf2e+lcy+GJmq7QcS3gH5haE86b62BH4oX3a
         Qc1GPcTaX/QYQjs96cM+T3NnzU7oAySZ8jXsOAl/DYvFjn4qzVHVRoyYZfaoGqfRjCVc
         dJuBUbevn9+NbXOLJIK6zV6w5AQc2dCMXpuomyk9y3Mhs0iff2/LcNdd9epwcW5OGf5r
         u1og==
X-Gm-Message-State: AOAM533Mi15izozmEKuFzMAREzVFR5xNfxW4/8bnut2kPtJL0Xxx7+SX
        au2gbXf7HQDcDCHgxC7cHNjUm5OpiN0=
X-Google-Smtp-Source: ABdhPJxlSRgK1p7c6doAsYU22wmg8ZiX2A6rVo37gJXCuZAzn76qfO23eeS35a4Bn9T7Uv7Cy+4cYA==
X-Received: by 2002:a17:902:ee11:b029:df:e6ac:c01 with SMTP id z17-20020a170902ee11b02900dfe6ac0c01mr313606plb.65.1611338410487;
        Fri, 22 Jan 2021 10:00:10 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s21sm10053243pjz.13.2021.01.22.10.00.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 10:00:09 -0800 (PST)
Subject: Re: [RFC PATCH net-next 2/3] net: hsr: add DSA offloading support
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Nishanth Menon <nm@ti.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
References: <20210122155948.5573-1-george.mccollister@gmail.com>
 <20210122155948.5573-3-george.mccollister@gmail.com>
 <27b8f3f2-a295-6960-2df5-3ee5e457fea3@gmail.com>
Message-ID: <1c8833b8-12db-fd5d-0db2-532b9197a0a5@gmail.com>
Date:   Fri, 22 Jan 2021 10:00:07 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <27b8f3f2-a295-6960-2df5-3ee5e457fea3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2021 9:56 AM, Florian Fainelli wrote:
> 
> 
> On 1/22/2021 7:59 AM, George McCollister wrote:
>> Add support for offloading of HSR/PRP (IEC 62439-3) tag insertion
>> tag removal, duplicate generation and forwarding on DSA switches.
>>
>> Use a new netdev_priv_flag IFF_HSR to indicate that a device is an HSR
>> device so DSA can tell them apart from other devices in
>> dsa_slave_changeupper.
>>
>> Add DSA_NOTIFIER_HSR_JOIN and DSA_NOTIFIER_HSR_LEAVE which trigger calls
>> to .port_hsr_join and .port_hsr_leave in the DSA driver for the switch.
>>
>> The DSA switch driver should then set netdev feature flags for the
>> HSR/PRP operation that it offloads.
>>     NETIF_F_HW_HSR_TAG_INS
>>     NETIF_F_HW_HSR_TAG_RM
>>     NETIF_F_HW_HSR_FWD
>>     NETIF_F_HW_HSR_DUP
>>
>> For HSR, insertion involves the switch adding a 6 byte HSR header after
>> the 14 byte Ethernet header. For PRP it adds a 6 byte trailer.
>>
>> Tag removal involves automatically stripping the HSR/PRP header/trailer
>> in the switch. This is possible when the switch also preforms auto
>> deduplication using the HSR/PRP header/trailer (making it no longer
>> required).
>>
>> Forwarding involves automatically forwarding between redundant ports in
>> an HSR. This is crucial because delay is accumulated as a frame passes
>> through each node in the ring.
>>
>> Duplication involves the switch automatically sending a single frame
>> from the CPU port to both redundant ports. This is required because the
>> inserted HSR/PRP header/trailer must contain the same sequence number
>> on the frames sent out both redundant ports.
>>
>> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> 
> This is just a high level overview for now, but I would split this into two:
> 
> - a patch that adds HSR offload to the existing HSR stack and introduces
> the new netdev_features_t bits to support HSR offload, more on that below
> 
> - a patch that does the plumbing between HSR and within the DSA framework
> 
>> ---
>>  Documentation/networking/netdev-features.rst | 20 ++++++++++++++++
>>  include/linux/if_hsr.h                       | 22 ++++++++++++++++++
>>  include/linux/netdev_features.h              |  9 ++++++++
>>  include/linux/netdevice.h                    | 13 +++++++++++
>>  include/net/dsa.h                            | 13 +++++++++++
>>  net/dsa/dsa_priv.h                           | 11 +++++++++
>>  net/dsa/port.c                               | 34 ++++++++++++++++++++++++++++
>>  net/dsa/slave.c                              | 13 +++++++++++
>>  net/dsa/switch.c                             | 24 ++++++++++++++++++++
>>  net/ethtool/common.c                         |  4 ++++
>>  net/hsr/hsr_device.c                         | 12 +++-------
>>  net/hsr/hsr_forward.c                        | 27 +++++++++++++++++++---
>>  net/hsr/hsr_forward.h                        |  1 +
>>  net/hsr/hsr_main.c                           | 14 ++++++++++++
>>  net/hsr/hsr_main.h                           |  8 +------
>>  net/hsr/hsr_slave.c                          | 13 +++++++----
>>  16 files changed, 215 insertions(+), 23 deletions(-)
>>  create mode 100644 include/linux/if_hsr.h
>>
>> diff --git a/Documentation/networking/netdev-features.rst b/Documentation/networking/netdev-features.rst
>> index a2d7d7160e39..4eab45405031 100644
>> --- a/Documentation/networking/netdev-features.rst
>> +++ b/Documentation/networking/netdev-features.rst
>> @@ -182,3 +182,23 @@ stricter than Hardware LRO.  A packet stream merged by Hardware GRO must
>>  be re-segmentable by GSO or TSO back to the exact original packet stream.
>>  Hardware GRO is dependent on RXCSUM since every packet successfully merged
>>  by hardware must also have the checksum verified by hardware.
>> +
>> +* hsr-tag-ins-offload
>> +
>> +This should be set for devices which insert an HSR (highspeed ring) tag
>> +automatically when in HSR mode.
>> +
>> +* hsr-tag-rm-offload
>> +
>> +This should be set for devices which remove HSR (highspeed ring) tags
>> +automatically when in HSR mode.
>> +
>> +* hsr-fwd-offload
>> +
>> +This should be set for devices which forward HSR (highspeed ring) frames from
>> +one port to another in hardware.
>> +
>> +* hsr-dup-offload
>> +
>> +This should be set for devices which duplicate outgoing HSR (highspeed ring)
>> +frames in hardware.
> 
> Do you think we can start with a hsr-hw-offload feature and create new
> bits to described how challenged a device may be with HSR offload? Is it
>  reasonable assumption that functional hardware should be able to
> offload all of these functions or none of them?
> 
> It may be a good idea to know what the platform that Murali is working
> on or has worked on is capable of doing, too.

Murali's email address is bouncing, adding Grygorii, Kishon and
Nishanth, they may know.
-- 
Florian
