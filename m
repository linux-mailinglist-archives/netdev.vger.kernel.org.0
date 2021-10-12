Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5117742AF1A
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 23:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbhJLVnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 17:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbhJLVnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 17:43:32 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0812EC061570
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 14:41:29 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 133so366002pgb.1
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 14:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FUulbn7VBMpZv8atD4dSN5eclp/RzVv//ObsobL5GfM=;
        b=maprH8KUhPbXqrENWKsGthltiZetRbTF8nBV8BRoQu9fNbH3DW/OhDn9l9vJXUFM5F
         lDNV63zXs42XwTgPgXeN5H5d/VjC4eKAFAyAA4snSgbZarly6Te2srG76cltl/qaBI/E
         xwd7lJ4OJZ3CyTTtlCPxcw9kBGLSasdOcQDwmris4q+BJJSkwv8rgy94KEqazzjg9Tat
         S0E9BAGb6CixW4ix0V87fItIFxw1ncoujNQeWPa4f8zI7ZVJ+dMB//gGNb4M9+hjF8mr
         wix+8JBGyK5oCtbnKE6xq9SMafMnNMoSEc5RmBmkRqUBENcjmEC/o9PSFQWXA72skvyj
         Am0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FUulbn7VBMpZv8atD4dSN5eclp/RzVv//ObsobL5GfM=;
        b=WxzKMqv2R2U7ebdj40TLCHN6LzURlWE4kYFQzYfHviPC9RFCoFOZSCo72PHaUsLGCJ
         q0l4KLTXybvft5BT04mf5wEatc6d9VMGGlq/+R9+e1vWiabdv9YCXQsA+dAdVQYVtFV5
         +KqNEbjPdYB/cgIHLicPOL5U+fYKq69dtJ+jhA0LREUZ4IF/uej6r5Fokp0QvccQjEnQ
         QiXAueRVQpvSyM/IgusWduRNcvX8BXof9himvRf7KcWlJavdN2/cHxT0JWnugEQSXdFr
         kQpyMhcBaye2NuNvUt6ljYyKFsl9FqLLxnAtMwtBtwKkUPAsVOaGBnq+RrOqQBor8FFi
         i0ow==
X-Gm-Message-State: AOAM532NCvlo18cMQi5rP7VvVXaTeO9LKekGcyETJrSJIp/z3fyE+Ite
        R93GVOndheWkPsmfsXOa9IA=
X-Google-Smtp-Source: ABdhPJye9OTeNHL3LC8ZV0PGUfzQEpGkeb4pGRib59ffx5K7DR2FqXntgRe2CcAC0ALS30KRBzNHmQ==
X-Received: by 2002:a05:6a00:855:b0:44d:4d1e:9080 with SMTP id q21-20020a056a00085500b0044d4d1e9080mr2548091pfk.66.1634074889454;
        Tue, 12 Oct 2021 14:41:29 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o11sm3551296pjp.0.2021.10.12.14.41.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 14:41:28 -0700 (PDT)
Subject: Re: [PATCH v2 net 03/10] net: mscc: ocelot: warn when a PTP IRQ is
 raised for an unknown skb
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
References: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
 <20211012114044.2526146-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6b950120-a9b3-3a93-3fa7-dc7932c26ca3@gmail.com>
Date:   Tue, 12 Oct 2021 14:41:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211012114044.2526146-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 4:40 AM, Vladimir Oltean wrote:
> When skb_match is NULL, it means we received a PTP IRQ for a timestamp
> ID that the kernel has no idea about, since there is no skb in the
> timestamping queue with that timestamp ID.
> 
> This is a grave error and not something to just "continue" over.
> So print a big warning in case this happens.
> 
> Also, move the check above ocelot_get_hwtimestamp(), there is no point
> in reading the full 64-bit current PTP time if we're not going to do
> anything with it anyway for this skb.
> 
> Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
