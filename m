Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91EAA3409C4
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbhCRQMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbhCRQLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 12:11:47 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132D1C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 09:11:47 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id o2so1536928plg.1
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 09:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sx0XWWatGnkLolH6xxWBu/+TweAEYfeRMOlRrfThew4=;
        b=hW/t6IPpV1GbpyDVpVzIUhccO+1OhsJoHZAoFKREiUhFwnPATXSzEzl/NJDHhp8Z/m
         dDfTOU10ZTgSHENaUj6NenrIwjHDiwvusRGKBNYlSghQIk3WhEBDqQOs5u0QRyZu35Yk
         Ah7qFOnYna582E4wj1c7miWhmJyWFt5Kz7KzPbz5HsD4GspXpwbTjQVC4noxCuuyUtLL
         +fhEas8Z6TGhrCbizmelXzF5Dxgw6Ilf2fpHGKye9jSButJmipaX9rA4CuTobyH3imHw
         N7iFtiQ0VR1Rb7vqPWKVgSBd1tT/jr3RW2aIjmS6Lmd1dfHppT5nTURJiwT8CQ/zy0gG
         DJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sx0XWWatGnkLolH6xxWBu/+TweAEYfeRMOlRrfThew4=;
        b=gqI9Yqa3PKsellbdX7DV17HaGxgscJDZ+bbMmslwVjsVjn8s+Zs5M1DdQn72bOjOF3
         OeI38758rSpwUlyqeO88JruvvZYK2uMr6530ywCu2ADLnsRjGarzPIJQDOoWSoQBRl3V
         B+e8jrkjijfG1gH5jNppKyqI8nft8kdkEffAd+KA8VkU48IQsbbr9cuwbz/MXlVZwWxP
         fLdgpYI0HayfwKwCNMdx4iWK+X3SRWjzm3OyLZ+00L/9K+oKHkP32OEn2+gv2pl/jUv9
         gEL1/fF8yqrNGh/k3Mkzs2Wr2s/ESiUgMI9LxUlQVqMOzE3lWpU9X8f7HG4d6nn+mnLQ
         wLHA==
X-Gm-Message-State: AOAM532gtPA8YG3tlRp68OqAe+INF5zb8Cn4trsys6dv9bu3rF4uv9CK
        VvUPEHrcYK9zQ3Ml9aMPGpNjHKPDuCQ=
X-Google-Smtp-Source: ABdhPJzUwWstmRxaKLzZjaLln7RUXAvUksjvOAyb7FEhXp3Eidt1J9ItZhRo1TEwj37RjlEobD8qlw==
X-Received: by 2002:a17:90b:fce:: with SMTP id gd14mr4978687pjb.64.1616083906294;
        Thu, 18 Mar 2021 09:11:46 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id mr5sm3061861pjb.53.2021.03.18.09.11.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 09:11:45 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 7/8] net: dsa: mv88e6xxx: Offload bridge
 learning flag
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
References: <20210318141550.646383-1-tobias@waldekranz.com>
 <20210318141550.646383-8-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d969554c-314f-a063-de89-480d47dddf32@gmail.com>
Date:   Thu, 18 Mar 2021 09:11:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318141550.646383-8-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 7:15 AM, Tobias Waldekranz wrote:
> Allow a user to control automatic learning per port.
> 
> Many chips have an explicit "LearningDisable"-bit that can be used for
> this, but we opt for setting/clearing the PAV instead, as it works on
> all devices at least as far back as 6083.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
