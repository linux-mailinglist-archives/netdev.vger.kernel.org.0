Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177E531AEAB
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 02:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhBNBYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 20:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhBNBX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 20:23:59 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D126FC061756
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:23:18 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id c16so3002032otp.0
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rJ0gqLaRcemdUL5hbSjMewSKAw+PcBPtMOLL8HwEV6E=;
        b=bpI+Hpd3jT60AH+PMWTJLrmdhsSH6wbrtyXiillajSdRb9KcHSgu5L1ns0EkHU4KmN
         jBXRvUSrLKD6GEfPy5b4XIFirQwOxA4JEc172DZRm83iPD6mCfhilLVn/SWXUOdUaugH
         xzT7iMfI0rc57spbvOVzgx/tAqxSgIc0S6Dbgc9ZbWlOSeLsdcrSN1aGRcd0aZ1TqZ5x
         E05QuZIluy8HoVkfs1Bue3WqmRkGZ+U8yK1bPx6x4FkeMECbRCSXquj1/grflh1aLVup
         3ECX+fzMj3H91kOhQl8uePVUNDJjNnhwGKJS2shCm0xO72fa85m2A3A7kwWaJ/Xftk2t
         hikQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rJ0gqLaRcemdUL5hbSjMewSKAw+PcBPtMOLL8HwEV6E=;
        b=iSiiHekBQdG+eaWjgEhMkgaG73aqZvK09ipGuKdiEPBNGABxSbDQFIuMC0q+RD8tks
         YzKLhZjnMCeGrewO1ouhg2wiMhxs/z/YK2fzTOcSmqkwHnaK9TBjBGGZ+Fhul+9EPtuL
         8GqGkduJyAbrCPmjK+WAkP25pRNdwOgTrJGPyNJ22HM0AxgE1x55IebWKBgUgO4EcWoo
         AjjK+CFv27K1wZunYypdzDK2xzkXA+pQldel7rY9pKUzi255tuKqZ3KYNqRaQLzgfg6Z
         +EOjTZHiquOubLlSGVU1DgJBYHIfGEsgG5Den4Lj5/bjoofG0sUyueHbla9LrVNb+zat
         poJQ==
X-Gm-Message-State: AOAM530SpAHNKCvAk1VUe3tlFD3NOWppWYkVg1EHP5CiJI07zhTWKI3+
        QDnwo51A6DN7SzVq9hTGRQ4=
X-Google-Smtp-Source: ABdhPJwMBr4+Cm4cLDNDysfukgdtjMX+7IeUG/g3tFS6keZuWgOwxNPwbieHEFZq8baIW1zDoZR9QA==
X-Received: by 2002:a9d:5552:: with SMTP id h18mr6913113oti.304.1613265798264;
        Sat, 13 Feb 2021 17:23:18 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:e93c:cbea:e191:f62a? ([2600:1700:dfe0:49f0:e93c:cbea:e191:f62a])
        by smtp.gmail.com with ESMTPSA id z8sm1956061oib.36.2021.02.13.17.23.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 17:23:17 -0800 (PST)
Subject: Re: [PATCH v2 net-next 06/12] net: dsa: tag_ocelot: avoid accessing
 ds->priv in ocelot_rcv
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
 <20210213223801.1334216-7-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d644c427-11b2-961f-2152-8e98a4e83fb7@gmail.com>
Date:   Sat, 13 Feb 2021 17:23:14 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213223801.1334216-7-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/2021 14:37, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Taggers should be written to do something valid irrespective of the
> switch driver that they are attached to. This is even more true now,
> because since the introduction of the .change_tag_protocol method, a
> certain tagger is not necessarily strictly associated with a driver any
> longer, and I would like to be able to test all taggers with dsa_loop in
> the future.
> 
> In the case of ocelot, it needs to move the classified VLAN from the DSA
> tag into the skb if the port is VLAN-aware. We can allow it to do that
> by looking at the dp->vlan_filtering property, no need to invoke
> structures which are specific to ocelot.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
