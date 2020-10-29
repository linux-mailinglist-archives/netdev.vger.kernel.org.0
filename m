Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36FB29E2DF
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391251AbgJ2CmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgJ2Clj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 22:41:39 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C90C0613CF;
        Wed, 28 Oct 2020 19:41:39 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b3so1131656pfo.2;
        Wed, 28 Oct 2020 19:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Dt/2gHftNzc28N9VawEzlwLrUVwY2PPyd9if+CfsT9w=;
        b=JXqgxHtA5JgMPKkgf3aLIGDJQq4N+lKZDHSwq1uURXPG4BZgAyfbHJ6e+OQwrmRETv
         8yTihThAGtQUCiMu0Z8cmbIkpDJbd7fzbXH6BaqsJky0gVWSqa/Jq5qDGj8LfMe9wWIS
         75hS98iqaqHAwTdGnGHeS5lIb8p3u/gsJEJiLguJNz+Xs9rv8/pdRqLrQ3cFtpQMSm1n
         F04xumvDFUX0cVqOFVKPdLfhyi0LHKd5yR9uX3cu5snfvycnm/jc5iG5n0OSTRJPF+S4
         ZzcA7a1odNG5bX97Ox8KtX60cEGcVpmKs29w+ZNcIdqC8P737KRtlgI1DD/nbL1AcR3s
         dm9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dt/2gHftNzc28N9VawEzlwLrUVwY2PPyd9if+CfsT9w=;
        b=UXI6z9MT9H5tfLlnCOHE+TskcKPLM+35nnxhcxFviHpsTJarhykQbKJAgmvii2ZHwq
         YJTU7zi+yBjKo3PymJLKohpvdTxt9HljFnSpVLcomg6Mpf4E1k6D0i0pLtcXzuz245Wa
         lqvgsY1hpeW6WZOTTJnAwLgu4cyWsyEwCwiCowwgGB3Fcv2zVMS4ADcjaRe+yVg30II/
         SjdjLzBJL4N8xDLFfoS3rfECyLhc5ZiW7UeCBliG/RgAsh4k5Y9mllEB9DxohbXxQwCn
         RxteDkBTm970DWdo4Rg8VZdeKJqGZkH3A12+SbPVbzbrb+NC7XVe2JONA2DEzpnhIidc
         ys5w==
X-Gm-Message-State: AOAM5329eEuzhm4PpzsE2GoaJM+4V3CI8B7TfrCqmhy0lBTpjNdibb4k
        L56wzllFsiwcIF4wrvX4hFjqfQ9Cb/A=
X-Google-Smtp-Source: ABdhPJyOX6JF0FYAmdvj3uFOiDKbQeRijsgX4mZl3dN+nb0e/1ScQcZGk07MJ8K9BGRWSxvVB+Ty+g==
X-Received: by 2002:aa7:9d03:0:b029:164:2981:2331 with SMTP id k3-20020aa79d030000b029016429812331mr2053619pfp.0.1603939298909;
        Wed, 28 Oct 2020 19:41:38 -0700 (PDT)
Received: from [10.230.28.251] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gm14sm755949pjb.2.2020.10.28.19.41.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 19:41:38 -0700 (PDT)
Subject: Re: [PATCH net-next 5/5] net: mscc: ocelot: support L2 multicast
 entries
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201029022738.722794-1-vladimir.oltean@nxp.com>
 <20201029022738.722794-6-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <16a2c3df-5d83-bb08-13a7-921fbd7c051e@gmail.com>
Date:   Wed, 28 Oct 2020 19:41:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201029022738.722794-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/28/2020 7:27 PM, Vladimir Oltean wrote:
> There is one main difference in mscc_ocelot between IP multicast and L2
> multicast. With IP multicast, destination ports are encoded into the
> upper bytes of the multicast MAC address. Example: to deliver the
> address 01:00:5E:11:22:33 to ports 3, 8, and 9, one would need to
> program the address of 00:03:08:11:22:33 into hardware. Whereas for L2
> multicast, the MAC table entry points to a Port Group ID (PGID), and
> that PGID contains the port mask that the packet will be forwarded to.
> As to why it is this way, no clue. My guess is that not all port
> combinations can be supported simultaneously with the limited number of
> PGIDs, and this was somehow an issue for IP multicast but not for L2
> multicast. Anyway.
> 
> Prior to this change, the raw L2 multicast code was bogus, due to the
> fact that there wasn't really any way to test it using the bridge code.
> There were 2 issues:
> - A multicast PGID was allocated for each MDB entry, but it wasn't in
>   fact programmed to hardware. It was dummy.
> - In fact we don't want to reserve a multicast PGID for every single MDB
>   entry. That would be odd because we can only have ~60 PGIDs, but
>   thousands of MDB entries. So instead, we want to reserve a multicast
>   PGID for every single port combination for multicast traffic. And
>   since we can have 2 (or more) MDB entries delivered to the same port
>   group (and therefore PGID), we need to reference-count the PGIDs.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

I believe you have the same gfp_t comment applicable here as in patch #4.
-- 
Florian
