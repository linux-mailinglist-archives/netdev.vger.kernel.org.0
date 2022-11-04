Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15DB0618DDE
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 03:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbiKDCDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 22:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKDCDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 22:03:32 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7311AD99;
        Thu,  3 Nov 2022 19:03:30 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id a67so5645481edf.12;
        Thu, 03 Nov 2022 19:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pLPCK9Uug0ilNvdlZMrezqOyWNOcVsx4Hwp/j3a6Hv8=;
        b=d2bJwyvfrsIRK8UlUGWQma+1B3Kqzs/Pgf0maBdb7MUrdSpA/XA+zBwCy2Tmixq+Jj
         sJoey6ghXpHD82G+7zMwqJE6UoDtmf5Vij92L8JW9LPnb5naseayxkezoZPCBMAE1xKB
         j8hYf+mQU0fbLjkI0VO2kpXt3BpqsafJD/HA5+g6s4+l/Wikp85pz2GOaMqq46TlqGkw
         FFs229BaXrojCKCQZh8WmVvtXRvVACwenHwRkF0P/yWYO0rKSSwgta9Cu0LHQq9k2hlZ
         uanIG1zJd3oPUrnrIExAGfz4C2ahCDSubpY32SahIZbn7Ea8byCZ14WTo97AKoUg+CYY
         RfMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pLPCK9Uug0ilNvdlZMrezqOyWNOcVsx4Hwp/j3a6Hv8=;
        b=uu0JLRvbZK7ytJcBXYJB6Xx9pdeg1kiSx1OUOFTMR7VxHyrDoASkwzjbaNdWyMoGHZ
         3Q38W9fImmOHHHyM427VLvGNNBsfCUa2Pg/rnlo95U1fvPrl/ED9gMGMk6E9RoJ8SO56
         Fv9wete7+bFyes1WGfYBsKB+GVS5KOlKudkqJr1qyGv0P9wt+8AEzcfL6lz5Ec8OemOX
         layRsYycL3LD7cQHMERP0DkGg8kjYc1/X7fW/x7d48A8+X3kE889PWUpYLNrZMrK7O7w
         gRlshcTEMyETcQGh49jlzBtBtu1snHLQczYl82U2YYxvSrvPcGQXzIW1AU9rkAqlnpXq
         9XdQ==
X-Gm-Message-State: ACrzQf2ESFyvF1GRIvaoGbuDdHI7EPIZJuYXfnhNtaf+z0kFWihXok5h
        HizJ2c1xwchjBYnlbXi/4/4=
X-Google-Smtp-Source: AMsMyM7Pw02m8msJ4P0TLH9cYFfz2LrxPUMowLkmarpEinPrYpjgd5BkNcWz7exI440Q++aZZGQ5Yw==
X-Received: by 2002:a05:6402:5cb:b0:452:e416:2bc4 with SMTP id n11-20020a05640205cb00b00452e4162bc4mr32584677edx.114.1667527409188;
        Thu, 03 Nov 2022 19:03:29 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id u5-20020a17090626c500b00781dbdb292asm1151270ejc.155.2022.11.03.19.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 19:03:28 -0700 (PDT)
Date:   Fri, 4 Nov 2022 04:03:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
Message-ID: <20221104020326.4l63prl7vxgi3od7@skbuf>
References: <20221102185232.131168-1-krzysztof.kozlowski@linaro.org>
 <20221103233319.m2wq5o2w3ccvw5cu@skbuf>
 <698c3a72-f694-01ac-80ba-13bd40bb6534@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <698c3a72-f694-01ac-80ba-13bd40bb6534@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 09:44:36PM -0400, Krzysztof Kozlowski wrote:
> > Don't these belong to spi-peripheral-props.yaml?
> 
> No, they are device specific, not controller specific. Every device
> requiring them must explicitly include them.
> 
> See:
> https://lore.kernel.org/all/20220816124321.67817-1-krzysztof.kozlowski@linaro.org/
> 
> Best regards,
> Krzysztof
> 

I think you really mean to link to:
https://lore.kernel.org/all/20220718220012.GA3625497-robh@kernel.org/

oh and btw, doesn't that mean that the patch is missing
Fixes: 233363aba72a ("spi/panel: dt-bindings: drop CPHA and CPOL from common properties")
?

but I'm not sure I understand the reasoning? I mean, from the
perspective of the common schema, isn't it valid to put "spi-cpha" on a
SPI peripheral OF node even if the hardware doesn't support it, in the
same way that it's valid to put spi-max-frequency = 1 GHz even if the
hardware doesn't support it? Or maybe I'm missing the point of
spi-peripheral-props.yaml entirely? Since when is stacked-memories/
parallel-memories something that should be accepted by all schemas of
all SPI peripherals (for example here, an Ethernet switch)?
I think that spi-cpha/spi-cpol belongs to spi-peripheral-props.yaml just
as much as the others do.

The distinction "device specific, not controller specific" is arbitrary
to me. These are settings that the controller has to make in order to
talk to that specific peripheral. Same as many others in that file.
