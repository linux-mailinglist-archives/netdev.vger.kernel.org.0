Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F07A647E94
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiLIHbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiLIHbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:31:22 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C75050D41
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 23:29:58 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id k22-20020a05600c1c9600b003d1ee3a6289so2764037wms.2
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 23:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I/NiR04BbzcUV//md2hUQO/dnN6Z7scyidQgiE5B2hg=;
        b=VJTtQyFx7jDB5CrXOwLXWeqcAcBabtG5fa63nVOt4TWI9j7o3YzB+csFGOP/omIVBg
         cYHSkr9dmk0R1su2IXweF0YNvv4WbGvLjIpNAHwEK6LSISOBPx7B1IRiLxl2zaMou9pC
         G1pCmcnwlMl6zRzZsmCLbSUldc3x0POKJ86BjYHZ9X/+z46ngn3Jqm1NCRiM3ahlIrGZ
         OsrovOfG9d7bA5qrlMCD7KqaTcYoyRAi0UDJl/faqN7JZe1ruoc5Cf2/xQZQ20SwSmL4
         ix8t8192Bdkcoy2/BFKQtbTjlsGUs/ckoiPZd+9uaoiqEViqbKJJOQD6A04mJw4TT4Fk
         88wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I/NiR04BbzcUV//md2hUQO/dnN6Z7scyidQgiE5B2hg=;
        b=FHF7H7kRYUOlF6QMLrBwI8h/EC7o6haDS0SDNMVY7qwZq49dr+W9SrV9cLCICQ7C2W
         62NwjkHaj7j6BuRcc18E/Jrru04isCaSlEmHD6sLD6ybMQuCJcJ2Z3VbBQnhsX2Pie6P
         KYGoDl1SpB3GLlW/vvVUmg+O/4nWLyKIZ/TTjDUqmDTlXSoCgAqv2ZCocOtx797ogZgx
         3jIOzD+hAkXHELsNkVvaZ/ZSk4yauouMtm06MM4XoDJLL3XjEBk7TKStS5XwVzYnEhPP
         pHlDdAbm/YKLKj9imOh3imFZz+n4qsvme2kVCGzDi0U2ZsOoIOhB6k6UIGfc+fZp6KXr
         s2xw==
X-Gm-Message-State: ANoB5pmOjCFF7wCeMowQ+r0cV2+9FMT2b5Q4gDsH0lGlHhkTzfZpF1m0
        IygdEASA4vLQSK91t17tDKLhiA==
X-Google-Smtp-Source: AA0mqf5AsMPOEKnvglKk0OZyqrNakZg2l5tDPP01HZkZVjdZ0uW8vq3vIO7MlMp178xdE3455TuCUg==
X-Received: by 2002:a05:600c:3549:b0:3c6:e61e:ae8c with SMTP id i9-20020a05600c354900b003c6e61eae8cmr4879963wmq.28.1670570995254;
        Thu, 08 Dec 2022 23:29:55 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id s18-20020a5d5112000000b0024207478de3sm620832wrt.93.2022.12.08.23.29.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 23:29:54 -0800 (PST)
Message-ID: <9246d282-2691-d1c4-c1cc-fe3f0461e330@blackwall.org>
Date:   Fri, 9 Dec 2022 09:29:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 02/14] bridge: mcast: Split (*, G) and (S, G)
 addition into different functions
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221208152839.1016350-1-idosch@nvidia.com>
 <20221208152839.1016350-3-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221208152839.1016350-3-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2022 17:28, Ido Schimmel wrote:
> When the bridge is using IGMP version 3 or MLD version 2, it handles the
> addition of (*, G) and (S, G) entries differently.
> 
> When a new (S, G) port group entry is added, all the (*, G) EXCLUDE
> ports need to be added to the port group of the new entry. Similarly,
> when a new (*, G) EXCLUDE port group entry is added, the port needs to
> be added to the port group of all the matching (S, G) entries.
> 
> Subsequent patches will create more differences between both entry
> types. Namely, filter mode and source list can only be specified for (*,
> G) entries.
> 
> Given the current and future differences between both entry types,
> handle the addition of each entry type in a different function, thereby
> avoiding the creation of one complex function.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_mdb.c | 145 +++++++++++++++++++++++++++++---------------
>  1 file changed, 96 insertions(+), 49 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


