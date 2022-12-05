Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26670643745
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbiLEVsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233994AbiLEVsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:48:11 -0500
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349832FFCA;
        Mon,  5 Dec 2022 13:44:43 -0800 (PST)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-14455716674so8933813fac.7;
        Mon, 05 Dec 2022 13:44:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r4t1aZekiFnI1K6g/oFt0H7FLSbbOm+1ZjgnBturRNQ=;
        b=EUZntiQayfzKINq7RaMamt0Iug9h01JHj5TKMNd9XMhIltjpBLwixO8gDgRpshyAIw
         UnUM1jGyXB7F/tkL0VaxTRDC3bD5v2IINkYmvxddm16aVhENbvsN3XDj+y3gTZUAVLso
         bW5OPtspVaPeEvvn1X1jVYJ8Sa1eEm/EEK7+Z4hUyTCk7QbItNeezU9hun8ehJR4CLZ6
         0A7zbT44gkBk/Wxdq4j6hP3reYSTdxjM71EFKFlWFEtr2GAttc60kqowvnPk/EcaURsz
         qB54a2zynJcR2R5FJCWKscMPGMSNF0Bl2wQxCnJPS+lDvS8hzqOrqtP6dH7vj5ptqafr
         K4mQ==
X-Gm-Message-State: ANoB5pl6BQ2qCOFM1R244BTgKQRRTae5F+nuxCuDpfVp7YAwK/nQoIDA
        +bDylMHao35ApxPyCIllBw==
X-Google-Smtp-Source: AA0mqf7W8Ga6qUQgGB4ZXmtR85+VAgIAzQlmXWo60AdPDc73ugwWFKyUZu8X8gYUJRh0D2tDMNtPOg==
X-Received: by 2002:a05:6870:440d:b0:144:c280:838a with SMTP id u13-20020a056870440d00b00144c280838amr512625oah.195.1670276681299;
        Mon, 05 Dec 2022 13:44:41 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id w32-20020a056870b3a000b0012b298699dbsm9749207oap.1.2022.12.05.13.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 13:44:40 -0800 (PST)
Received: (nullmailer pid 2678417 invoked by uid 1000);
        Mon, 05 Dec 2022 21:44:39 -0000
Date:   Mon, 5 Dec 2022 15:44:39 -0600
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     =?UTF-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek Vasut <marex@denx.de>, Jakub Kicinski <kuba@kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        John Crispin <john@phrozen.org>, linux-kernel@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v4 net-next 6/9] dt-bindings: net: dsa: mediatek,mt7530:
 remove unnecessary dsa-port reference
Message-ID: <167027667922.2678357.1832683707932570480.robh@kernel.org>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
 <20221202204559.162619-7-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221202204559.162619-7-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 02 Dec 2022 12:45:56 -0800, Colin Foster wrote:
> dsa.yaml contains a reference to dsa-port.yaml, so a duplicate reference to
> the binding isn't necessary. Remove this unnecessary reference.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> 
> v3 -> v4
>   * Add Florian Reviewed tag
> 
> v2 -> v3
>   * Keep "unevaluatedProperties: false" under the switch ports node.
> 
> v1 -> v2
>   * Add Reviewed-by
> 
> ---
>  Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml | 1 -
>  1 file changed, 1 deletion(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
