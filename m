Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B803B50D8
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 04:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhF0DAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 23:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhF0DAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 23:00:30 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259E7C061574
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 19:58:06 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id i4so6855517plt.12
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 19:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5HxtteAQUPSatsJ6KWiDbf5DKN39pchrQdYKh8fNAWw=;
        b=tYKcbMAhbyULyFoZhvtRmr1Y5/sToiL133PLfQX9olXQyiaADfdji/SYboXKl5v9jq
         SlyIyOdDTrJDhd7je/ZO06Wlr6L5+GRa9l3x8Baov5KecYPgyWv6gaOe/nvM+FfXAB8M
         6DnTTyakLc6ZSKXqGsPADEgYqOeqnIyRHozFKFyOGHoExgm9s56i3iyhf/XHMtubVEMN
         e0L0AjnOmDidRltLdMZcr1qootdlb2Xr1KKC3mEBD3EpT7A7AtplEHkEwpy6GofE3Qt1
         aqTt7rVVsXSxff4+MgD/1zR+uDWJ4mEgjYeHtyEKSjQdPRB3oWYeJh9xHY9RCygCD26z
         JjtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5HxtteAQUPSatsJ6KWiDbf5DKN39pchrQdYKh8fNAWw=;
        b=ZrwwIhJlhU/nzCcnRhzvGzRjn/EFeGUT0RuDsLF521S9LwdFtJLRPQ3t8eNdGsXXWW
         oqoJovOnWqTM/LNAgg1RE37KIzmq5I6J7pd8YJ7Ay72qE49w5+NEQF18tjOJjPZczyox
         9V6kJAk/uhZq69xGG/pVk8deiwW7wqBDxGPIy5M4Wx2ioqO4zR0qpvsfEiPlKuI50/Wx
         XXjjSEMcNVmBzPvDL0pI2FksF36qlCWGEkqJM0j/MOHl3qQx323KAMbKAKP3sqb34nS5
         JYBil6HZXBPxHXP7sRIbexrsvefhw52fgTsYbkpVaskaPrZtvfOBgb8DS6lWRKwP550B
         KOrA==
X-Gm-Message-State: AOAM533r/YxuRlvo6gac0s5e7utBZih6DjUFpOM785K0ra9jFjxgGGHf
        WYzegzVXEOJXHwGM6iB8+H0=
X-Google-Smtp-Source: ABdhPJwOBpMcIWS8nievbKdMf0IBde6q7cEHpEP/fKQ6BAM5jsp0ulwN3hVD9WuCcZ6FiYQQYS5Y0w==
X-Received: by 2002:a17:902:d489:b029:120:b1f5:7867 with SMTP id c9-20020a170902d489b0290120b1f57867mr16247229plg.75.1624762685120;
        Sat, 26 Jun 2021 19:58:05 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id d19sm1853284pgk.15.2021.06.26.19.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Jun 2021 19:58:04 -0700 (PDT)
Subject: Re: [PATCH net-next 3/7] net: switchdev: add a context void pointer
 to struct switchdev_notifier_info
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210625185321.626325-1-olteanv@gmail.com>
 <20210625185321.626325-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <30f7a2a2-5ac9-3c91-67e4-b4f624262ec9@gmail.com>
Date:   Sat, 26 Jun 2021 19:58:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625185321.626325-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/2021 11:53 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In the case where the driver asks for a replay of a certain type of
> event (port object or attribute) for a bridge port that is a LAG, it may
> do so because this port has just joined the LAG.
> 
> But there might already be other switchdev ports in that LAG, and it is
> preferable that those preexisting switchdev ports do not act upon the
> replayed event.
> 
> The solution is to add a context to switchdev events, which is NULL most
> of the time (when the bridge layer initiates the call) but which can be
> set to a value controlled by the switchdev driver when a replay is
> requested. The driver can then check the context to figure out if all
> ports within the LAG should act upon the switchdev event, or just the
> ones that match the context.
> 
> We have to modify all switchdev_handle_* helper functions as well as the
> prototypes in the drivers that use these helpers too, because these
> helpers hide the underlying struct switchdev_notifier_info from us and
> there is no way to retrieve the context otherwise.
> 
> The context structure will be populated and used in later patches.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
