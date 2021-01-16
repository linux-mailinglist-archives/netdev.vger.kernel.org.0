Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD0B2F8B5E
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 06:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbhAPFCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 00:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbhAPFCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 00:02:35 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D1DC0613D3;
        Fri, 15 Jan 2021 21:01:55 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id m5so6408060pjv.5;
        Fri, 15 Jan 2021 21:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8yo9AzO/ZabABQi66kHrWNM+xtQus7FFVTP6b1wnq3Y=;
        b=YCGeZsB+JstSJy6Nt1JoVnhQdbUCphvl3Q9qTwRsAqqZz+FlQeqyVwmKTnvs8wO6kB
         IMGEfJASJhiy5WNLBKaND2zOiXdtRq/NyoV/gVPZUtNu4GzusTL274QOxP2j/WYNIFCk
         i0zwVkDuqvUZ41rKVSxxXx98m0LGs0+u9RLmtcrJ7mOCECU416Sd7qT0Vw0wxhQVcjN9
         9JAAXeYPiM+7jSSmndh3fPs8jp2fKZeIysDBVAta1CubpOLxW4WE2tNRd61pgNyDVo6D
         vnHr5dM2UQTChiHIYTaxS//GeZakx/8byK7V+UXlRpM7SJqgMawDEglySrUyWZ3HvJsg
         5sdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8yo9AzO/ZabABQi66kHrWNM+xtQus7FFVTP6b1wnq3Y=;
        b=tRfskkdSyQi2OhhULr4kucmUkWgLJyaK9gKfxmEhpr3UnMrJ/GXva+RzWRA4UCqgN0
         wkarn24a+e9RvNaoe60iPQdpuFHWkaxQGeOz4eS+qKfTgZTjRV4ZXbh5xRzO1rSPZS3o
         GDEW/+c2IT6C/6fqAIFNc713HfYzzEK3pJ07EXB9NfAx5N//sO6Y0mWPAm7jGVLDdDuT
         cP5Ckx5C4vKiDxjur5t0sfiKEFKLkymSlM6zyskqiAWMUopC02Jl0N7lFMdjgMQ+c3pk
         v+qoA3SmrF3RKeTH0xo4Cktp54qBcHQ8nnnUxqDKALpDV3HBjSJkzA1zswFjpoZh8OXj
         5d7Q==
X-Gm-Message-State: AOAM532JMic6eG7IERI3XuGFX6sLPK0esg4wV1IxoEAnqz+yHvthYOeN
        yLaIDtpqIXQIpEQHqOBUZgwwOjkaANA=
X-Google-Smtp-Source: ABdhPJzp+lxTQQb9D/f8gND7OXokVp/5JX/ectgnQ1K7WNV6FfDoSo0fl1mZdYVXfZUhgi4qalNdmA==
X-Received: by 2002:a17:902:d2d2:b029:de:7581:8ae1 with SMTP id n18-20020a170902d2d2b02900de75818ae1mr5477615plc.73.1610773314444;
        Fri, 15 Jan 2021 21:01:54 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i10sm9697002pgt.85.2021.01.15.21.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 21:01:53 -0800 (PST)
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: use
 mv88e6185_g1_vtu_getnext() for the 6250
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210116023937.6225-1-rasmus.villemoes@prevas.dk>
 <20210116023937.6225-3-rasmus.villemoes@prevas.dk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <04cc328a-5e5b-bccc-340b-db074055bf78@gmail.com>
Date:   Fri, 15 Jan 2021 21:01:51 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210116023937.6225-3-rasmus.villemoes@prevas.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/15/2021 6:39 PM, Rasmus Villemoes wrote:
> mv88e6250_g1_vtu_getnext is almost identical to
> mv88e6185_g1_vtu_getnext, except for the 6250 only having 64 databases
> instead of 256. We can reduce code duplication by simply masking off
> the extra two garbage bits when assembling the fid from VTU op [3:0]
> and [11:8].
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
