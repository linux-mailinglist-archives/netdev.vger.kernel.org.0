Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6602C643749
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbiLEVtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbiLEVsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:48:43 -0500
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B64303F4;
        Mon,  5 Dec 2022 13:45:08 -0800 (PST)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-144bd860fdbso1940392fac.0;
        Mon, 05 Dec 2022 13:45:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=piMiYVIEAWjpwWEYeB3QqgTClGJiFdhEXrf3/eSPGA4=;
        b=bLaq9fS8oiAICYRCwMrqq7Wu/HE5TFhofNvDtsuYUlbidvOoECSl1yqsfB0Yne3RJK
         k8k/aJDCmHcsGsHPYCtlUwA0NXw7cpjUNCOchuDwNWbdD5KRJpqE6sdZzBIRYDSglr5T
         iHMPzYxtlB5ojeWHLgp2lNik7pEiQOuVQZ/Cwjg73NROCR4EQERHLhwd6qdgHXPZhpLP
         3tc30NMulM0PGpkiy/WeAE5TZJYJtqvSVOi8J9CLRB9A9ScFwX4waAtKCxxpKYgHnHgg
         NHhqvFNhNTEhNsu62+GZjSte0+o6fUYvkp4iEdZSZH8DvcH3CJbPugsX2Tm1PODrqOu0
         cwPw==
X-Gm-Message-State: ANoB5pmYuB0E2KsRjkYprVyIdOd4brhfL8DaD403KxTJTCTStRDaW4Z0
        zchLDpY+VHOfxAOiCYA4BQ==
X-Google-Smtp-Source: AA0mqf62Tge1ck28BV8HHD8EJJ/Mjm9frnjUggG1Gaq67IgoI2NtpvZpffP3xbQIkBbH7v8UJ0rxMQ==
X-Received: by 2002:a05:6870:6123:b0:144:445b:9506 with SMTP id s35-20020a056870612300b00144445b9506mr8629349oae.70.1670276708192;
        Mon, 05 Dec 2022 13:45:08 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id k2-20020a056870148200b00132741e966asm9680213oab.51.2022.12.05.13.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 13:45:07 -0800 (PST)
Received: (nullmailer pid 2679125 invoked by uid 1000);
        Mon, 05 Dec 2022 21:45:06 -0000
Date:   Mon, 5 Dec 2022 15:45:06 -0600
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        =?UTF-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        linux-mediatek@lists.infradead.org,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v4 net-next 8/9] dt-bindings: net: add generic
 ethernet-switch-port binding
Message-ID: <167027670592.2679068.10166179243095082377.robh@kernel.org>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
 <20221202204559.162619-9-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202204559.162619-9-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 02 Dec 2022 12:45:58 -0800, Colin Foster wrote:
> The dsa-port.yaml binding had several references that can be common to all
> ethernet ports, not just dsa-specific ones. Break out the generic bindings
> to ethernet-switch-port.yaml they can be used by non-dsa drivers.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> 
> v3 -> v4
>   * Add Florian Reviewed tag
> 
> v2 -> v3
>   * Change dsa-port title from "DSA Switch port Device Tree Bindings"
>     to "Generic DSA Switch port"
>   * Add reference to ethernet-switch-port.yaml# in dsa-port.yaml
>   * Change title of ethernet-switch-port.yaml from "Ethernet Switch
>     port Device Tree Bindings" to "Generic Ethernet Switch port"
>   * Remove most properties from ethernet-switch-port.yaml. They're
>     all in ethernet-controller, and are all allowed.
>   * ethernet-switch.yaml now only references ethernet-switch-port.yaml#
>     under the port node.
> 
> v1 -> v2
>   * Remove accidental addition of
>     "$ref: /schemas/net/ethernet-switch-port.yaml" which should be kept
>     out of dsa-port so that it doesn't get referenced multiple times
>     through both ethernet-switch and dsa-port.
> 
> ---
>  .../devicetree/bindings/net/dsa/dsa-port.yaml | 24 ++----------------
>  .../bindings/net/ethernet-switch-port.yaml    | 25 +++++++++++++++++++
>  .../bindings/net/ethernet-switch.yaml         |  6 +----
>  MAINTAINERS                                   |  1 +
>  4 files changed, 29 insertions(+), 27 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
