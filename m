Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470866447DD
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 16:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbiLFPUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 10:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235371AbiLFPUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 10:20:02 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E301005;
        Tue,  6 Dec 2022 07:18:57 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id l11so20758804edb.4;
        Tue, 06 Dec 2022 07:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zCg69PxcTEnZD9ypvvoVMTCVaXFiqLTaSNGD0+eCQPE=;
        b=cH5ll8ITXoCLPrvYcU1hy30FRvcJzbtDilmyuFA6iarvx9PvVME70Mb/e2dcCU0vFN
         Qvbb3fpzDmXNlb+7bjUPqHm1L4S9+5vNm1BzHSSDxZ6HSZ4HpolWlpFVQmpAOpsNqHkv
         JVLmoqPlYykuIrqq0oMO+mVtXn0yjv5+6p9NnRcgcVRjIbiuUhkLDt8TLejMjp59ZHzv
         jj8gwBOKBmYMABtQO4eiUUe2JSVHNCn6xHgtppUtp2ZzVQtB5zB/S5XOCQqRZZARrrq9
         7OGGHMkR1K3VU22icPM7ItTsUgnrueylfv6bK3/l12rldmt2qlWmU4dhyJQjIXg2DK+J
         QkqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zCg69PxcTEnZD9ypvvoVMTCVaXFiqLTaSNGD0+eCQPE=;
        b=SsJKDJSiWEaUHqGq3kSJFXRcs6IKT2xRIJ4oR3xk2+TjUqqsRJ00n+5R0IaSd+gUHd
         lem7gOksfSXi2HCd4C1ItnlBJ+1yNZRqAutof9MAa9lg0PddYxj11m5wdldOryGa6qpn
         0zARDhabUomZ1geXjOHgTOcqTk24meQM3dlCzXYeWz4fen+5kwLosPoqFnnc84xhmKTz
         cf7VCQ73JdOPDx2EjDA8Ml3jglluP0oH/4d5mD8wGXbQxKfuXDB6pf8iSScAhyfMCGsp
         FT7Mef/0dDMnoWkHScAnXUIrdL3diia9HEJDhGzbazTxTsHLvOWiXhzzCrFJAEAgFGCV
         7JoA==
X-Gm-Message-State: ANoB5pk0yZ2vKt4Id4em/pr7uLv45okPX/zpmhS5YJN2GVTee7/sgwzu
        rK2WRYbG9Z7WUyq5ut8wP5k=
X-Google-Smtp-Source: AA0mqf6hLPrOoTjF/q/L3ZonW9Mz8loX3zBymzOB2FMOlPKwkXVRfSgfD4cTMN8HkW/ASavaZ6Uqog==
X-Received: by 2002:a05:6402:5517:b0:461:c563:defa with SMTP id fi23-20020a056402551700b00461c563defamr76864192edb.72.1670339935459;
        Tue, 06 Dec 2022 07:18:55 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id v6-20020a170906180600b007c0c679ca2fsm5080046eje.26.2022.12.06.07.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 07:18:54 -0800 (PST)
Date:   Tue, 6 Dec 2022 17:18:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v4 net-next 3/9] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
Message-ID: <20221206151851.hnqqwf6zgaa2c7tb@skbuf>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
 <20221202204559.162619-4-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202204559.162619-4-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 12:45:53PM -0800, Colin Foster wrote:
> DSA switches can fall into one of two categories: switches where all ports
> follow standard '(ethernet-)?port' properties, and switches that have
> additional properties for the ports.
> 
> The scenario where DSA ports are all standardized can be handled by
> swtiches with a reference to the new 'dsa.yaml#/$defs/ethernet-ports'.
> 
> The scenario where DSA ports require additional properties can reference
> '$dsa.yaml#' directly. This will allow switches to reference these standard
> defitions of the DSA switch, but add additional properties under the port
> nodes.
> ---
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> index b9d48e357e77..b9e366e46aed 100644
> --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> @@ -19,9 +19,6 @@ description:
>  select: false
>  
>  properties:
> -  $nodename:
> -    pattern: "^(ethernet-)?switch(@.*)?$"
> -

Does this deletion belong to this patch or to "dt-bindings: net: add
generic ethernet-switch"?

>    dsa,member:
>      minItems: 2
>      maxItems: 2
> @@ -58,4 +55,26 @@ oneOf:
>  
>  additionalProperties: true
