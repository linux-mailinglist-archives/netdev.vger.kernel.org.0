Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F284C64F8A3
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 11:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiLQKLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 05:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiLQKLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 05:11:07 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F306379;
        Sat, 17 Dec 2022 02:10:52 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id vv4so11527998ejc.2;
        Sat, 17 Dec 2022 02:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t9kD0mk+HTUIIP7PywOqpGQbdcZFiymXSlDYDMdTpIc=;
        b=c3HYgKmBiWcDJk2kpw8VvXv8D3cPR5xtxIU8OP/+AkVlk19mG0U8BWtIyflUw+nemv
         4xqxa6uqHNCbwd4Tb1N0qkCg8P9htqEMamK3E23SP8+KvBJCLPoWm12xmDz0xp+r4qlR
         aCs7sI2Mvd6bvokVd4vjLqZBHX0oSRDdGpwW//oEDjZkhNW7GFyjS1grxBj0sTi1SkG6
         GEF/348e7hWz+dh7qm3IYPLtkJCqEQ5nCb0BoWsY8VR29FaI7fi7ARbpcJmnzbDqgArc
         nb6tWwCXT5/Vz4soh89pxnh6pTp1cstQkvKVNvzhfi//dtId5KpHVN4Vz8SthDUcwDyz
         6Ikw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t9kD0mk+HTUIIP7PywOqpGQbdcZFiymXSlDYDMdTpIc=;
        b=m3J1ZO/MSUrtZ/gJdulnyVnxcNebG0cS2GP7VREwWDhXNIUk9OcXtysIzdLtdtOH7o
         lRFuyh8PEwtNgHvGtw/NaEFSTfAHAy1aeXSO7h8TNa8CPMQ9HkK3RYOCDzr92XWS/Rdp
         nbM9BBwmnw0eb4U6PfURBYRRD/RXJ0ieH6C+hQ3tKxFpiKLrVpC5rBAFCwSejJK5Y7/R
         xq+8NU49gyuVgMHZo0fz40oRsBrmCeb7Xm9GTvmlmHc2qq2pUBa3JksgytTpM0nMXqIB
         NPm9I1QCQzdrPNdpkc3ph3AtaS9dVAGmGJbIWNOcRkHqODpNQ7FvkjDydlFcWodMc/qY
         7AZw==
X-Gm-Message-State: AFqh2kqCh6r1Vg7E6emetI2a2IDCarXvT2RS85+JzbrjITqOQ7P2SY1v
        uo8viYLxbM4UNZ8nSYraDgY=
X-Google-Smtp-Source: AMrXdXvsJUB04PwFkPu+T/zaDIbPOP5JUeT0nhrTtNSEmgeK/mG2K7yQYCeyYcWqe87pwmcMImmEjQ==
X-Received: by 2002:a17:906:cb9a:b0:7d3:8159:f361 with SMTP id mf26-20020a170906cb9a00b007d38159f361mr7241076ejb.36.1671271851087;
        Sat, 17 Dec 2022 02:10:51 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id i9-20020a170906090900b007b9269a0423sm1848184ejd.172.2022.12.17.02.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 02:10:50 -0800 (PST)
Date:   Sat, 17 Dec 2022 11:10:47 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v7 net-next 0/5] add PLCA RS support and onsemi NCN26000
Message-ID: <Y52Vp+xMSUS2CgJe@gvm01>
References: <cover.1671234284.git.piergiorgio.beruto@gmail.com>
 <20221216204538.75ee3846@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216204538.75ee3846@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 16, 2022 at 08:45:38PM -0800, Jakub Kicinski wrote:
> On Sat, 17 Dec 2022 01:48:09 +0100 Piergiorgio Beruto wrote:
> > This patchset adds support for getting/setting the Physical Layer 
> > Collision Avoidace (PLCA) Reconciliation Sublayer (RS) configuration and
> > status on Ethernet PHYs that supports it.
> 
> # Form letter - net-next is closed
> 
> We have already submitted the networking pull request to Linus
> for v6.2 and therefore net-next is closed for new drivers, features,
> code refactoring and optimizations. We are currently accepting
> bug fixes only.
> 
> Please repost when net-next reopens after Jan 2nd.
> 
> RFC patches sent for review only are obviously welcome at any time.
Hello Jakub, sorry for asking dumb questions, but what exactly "RFC"
means? I understand you cannot accept new submissions at this time, but
does this means the patchset I just submitted can still be reviewd so
they are ready for integration on Jan 2nd?

Thanks,
Piergiorgio
