Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961192C7037
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 18:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731299AbgK1FVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 00:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730273AbgK1FTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 00:19:33 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB55C0613D1
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 21:19:31 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id w187so6231804pfd.5
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 21:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kV2asYCONeCFCbaJcS3QGxnPvkXnD9x281kTRQ/A3/g=;
        b=IaASuzuO7SN3y8DSgpipkLGUNQmxlx+tGy8+6FNl5jN8C1sywr9Sw+mYjRDrKVvYKC
         eAyo/aNrR+2K1NPVrKbLdxiHbSDkazw12FvVt/vKxtEPvhW2mD5YE4pguXzJ1uBt6Vch
         RbG8pgNtKH8+BjDxXZyGPoxiZ/bWzn9LeG1BNs/D1f4QTygcRDxBE1JxHEj+O+2kEWq1
         CJVKFY7twW7nuX2Xl6Lx7OB/z3LmxlfmQ3YoS5AaRVw2n5ZKNQpz1FR0PKR3vTldolvk
         0o83MoUNB25O/LtP6Qg7f5aIZzp3nm7hFW8865HFz0dHNfl7ZNkA9avF7AZtgMFO3hsB
         LfyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kV2asYCONeCFCbaJcS3QGxnPvkXnD9x281kTRQ/A3/g=;
        b=Y4m6RsxfG5LGEcEuCWegI6W2WbpgwALvJYM3nieAAjCVHZ6Z9uIbKktugVHQf1cV3R
         r+gKsl1ZpO8mIrA4LyuvnqafvxlGK7oGssqx899sklLKp814fxDokWIk37VPggtLw9wI
         pIQQYRKB+2Jg/r7/0tB74E3oTaSEjxqignIjgikUPxNFDhQrK8/k6DjQShBglm59Sm7Q
         CbI6v2oawb5fQoDgyiNGTFMvuA5aX8tplORHPKn+srXU17hGbsQ/hW3La/X6gfc/BTik
         a/Ql6cDoumcT0kcsbCAjPwqu2d+HSVZR6f/s9kJujHkoTVPYXDD6ys7yvkxxmpp+4kXM
         IvTw==
X-Gm-Message-State: AOAM533jxc1J5xH2ilYiXRWJIOVYDhv55xwNYBYniqo33JncBZ4Fpbon
        FJ9+wQ29EctzJLOEh7vXrHQLBn+yR7U=
X-Google-Smtp-Source: ABdhPJxf00ied/2fs+lUh1RvV0uKoRo443LMXiVzFU7pE4PGHGTqqBo0XvCYAoCZZ3xrxeERVXJbZw==
X-Received: by 2002:a17:90b:4a03:: with SMTP id kk3mr13852738pjb.97.1606540770655;
        Fri, 27 Nov 2020 21:19:30 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x24sm8910796pgh.17.2020.11.27.21.19.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2020 21:19:29 -0800 (PST)
Subject: Re: [PATCH net-next 2/4] net: dsa: Link aggregation support
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
References: <20201119144508.29468-1-tobias@waldekranz.com>
 <20201119144508.29468-3-tobias@waldekranz.com>
 <20201120003009.GW1804098@lunn.ch>
 <5e2d23da-7107-e45e-0ab3-72269d7b6b24@gmail.com>
 <20201120133050.GF1804098@lunn.ch> <87v9dr925a.fsf@waldekranz.com>
 <20201126225753.GP2075216@lunn.ch> <87r1of88dp.fsf@waldekranz.com>
 <20201127162818.GT2073444@lunn.ch> <87lfem8k2b.fsf@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6480e69b-beb2-d3cd-6bf9-75e3b81e5606@gmail.com>
Date:   Fri, 27 Nov 2020 21:19:22 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <87lfem8k2b.fsf@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/27/2020 3:19 PM, Tobias Waldekranz wrote:
>> The initial design of switchdev was transactions. First there was a
>> prepare call, where you validated the requested action is possible,
>> and allocate resources needed, but don't actually do it. This prepare
>> call is allowed to fail. Then there is a second call to actually do
>> it, and that call is not allowed to fail. This structure avoids most
>> of the complexity of the unwind, just free up some resources. If you
>> never had to allocate the resources in the first place, better still.
> 
> OK I think I finally see what you are saying. Sorry it took me this
> long. I do not mean to be difficult, I just want to understand.
> 
> How about this:
> 
> - Add a `lags_max` field to `struct dsa_switch` to let each driver
>   define the maximum number supported by the hardware. By default this
>   would be zero, which would mean that LAG offloading is not supported.
> 
> - In dsa_tree_setup we allocate a static array of the minimum supported
>   number across the entire tree.
> 
> - When joining a new LAG, we ensure that a slot is available in
>   NETDEV_PRECHANGEUPPER, avoiding the issue you are describing.
> 
> - In NETDEV_CHANGEUPPER, we actually mark it as busy and start using it.
> 

Sounds reasonable to me.
-- 
Florian
