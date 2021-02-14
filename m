Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10C731AEAF
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 02:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhBNBad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 20:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhBNBab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 20:30:31 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECEAC061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:29:51 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id k10so2986655otl.2
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hmS5AccHA1C2VewHv57zlOus+8dw4OIifePQ7hGN5kc=;
        b=fcANseIi1qyjZ+1B7emtFbV6IA9VmKtx5mvEcLcBWjgHdAembqSjQSBjBz8DO45DUU
         XZYCa5LaCx6JvQylQAXr+hRa5IOWiAfqZLLG8arxlgvooHhpEcP3PIeYgp7aqAQSq5Jg
         WyZfOu5iC08dCI903ba3NA2gdeIMKC8KGPFt/UXv1TW7ci8/GEGLZK8upOD8UHn80ytF
         7DNikbu1Zw+JKc/lCx4UEfdupLSnoJGRq54fxRo8VK74hzczziobTaeS+KJVZY9pXm4Y
         UKKAHVdYWmzwnulJj+54vST17CDVkiJXzvz11X2OGvNr1NlCt0ZFWrS5cQfZqKfdzaRn
         PkkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hmS5AccHA1C2VewHv57zlOus+8dw4OIifePQ7hGN5kc=;
        b=fNnPsp8/aC8ue5n/8AvQyx4OhF0d5vNTuZoR7jBsVQn0qodrmlJLuvm7xKpwBMFOvO
         IFAe+9aFnlgBqTGdB0LxttIQSGPObBy4nBGTxk1vT8rHyP2G9jupo6CYSZoVwOQK5mgw
         HCNaZp0wV8xV4/CtZE6BZMP3SjgJ5IFnXfDDPJ5belOz9SxRaTTOEjwrNGNpTk76YsKW
         JwIQTxhAhLSkau4VcahTiUI0R+mOwED8uGx34GABRNhloMEB7E5IoqmxIyozLhQyauob
         hN4DJF2jtMWJvEBSJcGB/IlwPCoVAeuiRuZ3J2k1anSz7CvWsSQ/KiBu4n01JGcLKvb5
         4OZw==
X-Gm-Message-State: AOAM532xAtxAN4XCaczhb4802XANgQ/pTBEDHLbEeW6T8C2MAHTEH7me
        HIGO5nwEfczzhnEKLjTudYcbvna1cis=
X-Google-Smtp-Source: ABdhPJzYS2EmpyUEBZFlXB0QYEKXpz+kt1AojP/XWsxdaz2XVDRn9zpjLL4Kp+vN+AN0zGvKbYE89w==
X-Received: by 2002:a9d:6393:: with SMTP id w19mr7195761otk.99.1613266190796;
        Sat, 13 Feb 2021 17:29:50 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:e93c:cbea:e191:f62a? ([2600:1700:dfe0:49f0:e93c:cbea:e191:f62a])
        by smtp.gmail.com with ESMTPSA id w196sm2787682oif.12.2021.02.13.17.29.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 17:29:50 -0800 (PST)
Subject: Re: [PATCH v2 net-next 09/12] net: dsa: tag_ocelot: create separate
 tagger for Seville
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        UNGLinuxDriver@microchip.com
References: <20210213223801.1334216-1-olteanv@gmail.com>
 <20210213223801.1334216-10-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b67989cc-7412-b0a4-35b5-f87640afe6ca@gmail.com>
Date:   Sat, 13 Feb 2021 17:29:45 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213223801.1334216-10-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/2021 14:37, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The ocelot tagger is a hot mess currently, it relies on memory
> initialized by the attached driver for basic frame transmission.
> This is against all that DSA tagging protocols stand for, which is that
> the transmission and reception of a DSA-tagged frame, the data path,
> should be independent from the switch control path, because the tag
> protocol is in principle hot-pluggable and reusable across switches
> (even if in practice it wasn't until very recently). But if another
> driver like dsa_loop wants to make use of tag_ocelot, it couldn't.
> 
> This was done to have common code between Felix and Ocelot, which have
> one bit difference in the frame header format. Quoting from commit
> 67c2404922c2 ("net: dsa: felix: create a template for the DSA tags on
> xmit"):
> 
>      Other alternatives have been analyzed, such as:
>      - Create a separate tag_seville.c: too much code duplication for just 1
>        bit field difference.
>      - Create a separate DSA_TAG_PROTO_SEVILLE under tag_ocelot.c, just like
>        tag_brcm.c, which would have a separate .xmit function. Again, too
>        much code duplication for just 1 bit field difference.
>      - Allocate the template from the init function of the tag_ocelot.c
>        module, instead of from the driver: couldn't figure out a method of
>        accessing the correct port template corresponding to the correct
>        tagger in the .xmit function.
> 
> The really interesting part is that Seville should have had its own
> tagging protocol defined - it is not compatible on the wire with Ocelot,
> even for that single bit. In principle, a packet generated by
> DSA_TAG_PROTO_OCELOT when booted on NXP LS1028A would look in a certain
> way, but when booted on NXP T1040 it would look differently. The reverse
> is also true: a packet generated by a Seville switch would be
> interpreted incorrectly by Wireshark if it was told it was generated by
> an Ocelot switch.
> 
> Actually things are a bit more nuanced. If we concentrate only on the
> DSA tag, what I said above is true, but Ocelot/Seville also support an
> optional DSA tag prefix, which can be short or long, and it is possible
> to distinguish the two taggers based on an integer constant put in that
> prefix. Nonetheless, creating a separate tagger is still justified,
> since the tag prefix is optional, and without it, there is again no way
> to distinguish.
> 
> Claiming backwards binary compatibility is a bit more tough, since I've
> already changed the format of tag_ocelot once, in commit 5124197ce58b
> ("net: dsa: tag_ocelot: use a short prefix on both ingress and egress").
> Therefore I am not very concerned with treating this as a bugfix and
> backporting it to stable kernels (which would be another mess due to the
> fact that there would be lots of conflicts with the other DSA_TAG_PROTO*
> definitions). It's just simpler to say that the string values of the
> taggers have ABI value starting with kernel 5.12, which will be when the
> changing of tag protocol via /sys/class/net/<dsa-master>/dsa/tagging
> goes live.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
