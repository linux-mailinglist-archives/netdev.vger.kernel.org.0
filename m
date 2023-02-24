Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FAD6A219D
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjBXShX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjBXShW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:37:22 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A2D6C53D
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:37:15 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id c18so378395qte.5
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=axRV9HlXTLzKj52XzqJCJiIYJbkvsLbq9GKq4mfj0VY=;
        b=FUOOqI+7JUS072z6Tzy9C4u6lNG0Oi8F8YsXtQ7wMBlif7hcibfdLMEbBO1Iphu9eY
         87Ul0Zjzcr4r0aj0cE0OjAu3VX/FdN7+acLWkzPJWgIj4/kXBZbRIxdilsMsr4Tkslbq
         ePz/Owm05bFkaXXBEfRTGXoopmRIyUgm6nZKcS4ndxP8r2u2LrDSmjN1idETpT1L8lKE
         /1AMD+Ji+5iSu90lE9GqjxVJcWNvHqiF6B+jjDYLHgzjFy5JFdtC2N0F4gVzYMScIueh
         qPsJs65l984iG+sekV03n8OKYiDsZgQWnePBSBy3SDhSkdDKJHf75Cr0fbG7nF85nJFM
         PvUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=axRV9HlXTLzKj52XzqJCJiIYJbkvsLbq9GKq4mfj0VY=;
        b=73HYD1euXCzocvsERztrBlKcI5JCk85mek/TwCpXwOCJYDaGYT6zJfASb30ltls2Qq
         c6WdOXky/4s69gOUwnzhHwkh/ZJrpAE3Q9oWjxJ+CE+t2OPSs5Hz1ocie7tYhaeBI3MW
         ywgvyJvhzZXMhw+C9zjWN1F+0+P2McXs+KkgA+u0asUQ63u6F5G7yYEiiQ9MWWd4HilF
         mCd3mT6//IMC3KHghwq6oGJ2bPztkNe1AgFY4kk2hc/n9RXh7czydmQTMR1oOmWD2xMJ
         7ZXGQqRlHjCnyScC4h95u7hv2L+srPPbe7Np6VopN8hT8Il0hsJLwkSjsDf9v8M9VlM6
         FxOg==
X-Gm-Message-State: AO0yUKVYOfYkArWBkOQLJ/Asg3ZrIdvOlfd/g9PECA9N+vR+gIYblXZ9
        GsLDaYVmXx5zEebNQ8A1hvU=
X-Google-Smtp-Source: AK7set/in1C3WlKEJ/WUGTCk0cHNWvWLfDjorbG8DTcXm3WiO9xaED8A5XL/36WFJ+I5PQgfppPugQ==
X-Received: by 2002:ac8:570a:0:b0:3bf:a88d:9c21 with SMTP id 10-20020ac8570a000000b003bfa88d9c21mr20650352qtw.50.1677263834585;
        Fri, 24 Feb 2023 10:37:14 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e9-20020a37ac09000000b0073b69922cfesm8474494qkm.85.2023.02.24.10.37.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 10:37:14 -0800 (PST)
Message-ID: <f608e698-04fe-f653-e407-9d1eb7569ccb@gmail.com>
Date:   Fri, 24 Feb 2023 10:37:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net 2/3] net: dsa: felix: fix internal MDIO controller
 resource length
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Colin Foster <colin.foster@in-advantage.com>,
        Lee Jones <lee@kernel.org>,
        Maksim Kiselev <bigunclemax@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
References: <20230224155235.512695-1-vladimir.oltean@nxp.com>
 <20230224155235.512695-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230224155235.512695-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/23 07:52, Vladimir Oltean wrote:
> The blamed commit did not properly convert the resource start/end format
> into the DEFINE_RES_MEM_NAMED() start/length format, resulting in a
> resource for vsc9959_imdio_res which is much longer than expected:
> 
> $ cat /proc/iomem
> 1f8000000-1f815ffff : pcie@1f0000000
>    1f8140000-1f815ffff : 0000:00:00.5
>      1f8148030-1f815006f : imdio
> 
> vs (correct)
> 
> $ cat /proc/iomem
> 1f8000000-1f815ffff : pcie@1f0000000
>    1f8140000-1f815ffff : 0000:00:00.5
>      1f8148030-1f814803f : imdio
> 
> Luckily it's not big enough to exceed the size of the parent resource
> (pci_resource_end(pdev, VSC9959_IMDIO_PCI_BAR)), and it doesn't overlap
> with anything else that the Linux driver uses currently, so the larger
> than expected size isn't a practical problem that I can see. Although it
> is clearly wrong in the /proc/iomem output.
> 
> Fixes: 044d447a801f ("net: dsa: felix: use DEFINE_RES_MEM_NAMED for resources")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

