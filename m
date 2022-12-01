Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A221463FA9B
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 23:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbiLAWdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 17:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiLAWdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 17:33:14 -0500
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4643355AA0;
        Thu,  1 Dec 2022 14:33:12 -0800 (PST)
Received: by mail-oi1-f171.google.com with SMTP id n205so3616683oib.1;
        Thu, 01 Dec 2022 14:33:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3XoZ57KQ2t8KQq59VcUGCIObJJ9YFC3Bj9uQynJzeWk=;
        b=OrFp+q9RYDcxNJSGmPBiAFyIE/I37hOn9ENTizHxhEqliMSqisQgqFFkeplOSFdGSK
         9rP8jDc7SK9POFnQuTxI9u2lG64hMtarzWn8GtXvvWirdIx0ELqT13nmcC/aRc3MMw/q
         rfCX8vPlL6RTJ1Co0UMRRGq7+9Vjx3axobbxMDmsOnBj3E9lvod154OUlEMRBz181OS4
         zUKeCIgdaTQb4yBBPNXtjcTWVgdZvHcsNvmhWc0Ad2r7Zl5h55KOv99dOBdz4ya86fSg
         NDVMSjke09GrmvrpLYOU5EIf7GJ9Gw8WQX1SxzEwvMrX1Jzg4Cvi4MdCA0H3qZyAV8+P
         djjg==
X-Gm-Message-State: ANoB5plD/DtDpXdboNmjnI9lP83iTs1xbg+H7EmM2tmUGxq+ddH360bQ
        7Q9HnTSM0CeXpZS9AxeKKQ==
X-Google-Smtp-Source: AA0mqf5a/P+Jg0CbhGiTwnvrxazbAzgcxokOqED+K4ErW/L2Ks4hck7y2jw4TM8M9zRaXF1+WAevBA==
X-Received: by 2002:aca:1e05:0:b0:354:2c4e:bc6e with SMTP id m5-20020aca1e05000000b003542c4ebc6emr35484670oic.85.1669933991378;
        Thu, 01 Dec 2022 14:33:11 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id b19-20020a9d6b93000000b0066c34486aa7sm2593598otq.73.2022.12.01.14.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 14:33:10 -0800 (PST)
Received: (nullmailer pid 1565634 invoked by uid 1000);
        Thu, 01 Dec 2022 22:33:09 -0000
Date:   Thu, 1 Dec 2022 16:33:09 -0600
From:   Rob Herring <robh@kernel.org>
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
        =?UTF-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v3 net-next 04/10] dt-bindings: net: dsa: allow
 additional ethernet-port properties
Message-ID: <20221201223309.GA1555093-robh@kernel.org>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-5-colin.foster@in-advantage.com>
 <20221128232759.GB1513198-robh@kernel.org>
 <Y4Wy7iSeGEtpQkgI@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4Wy7iSeGEtpQkgI@euler>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 11:21:18PM -0800, Colin Foster wrote:
> On Mon, Nov 28, 2022 at 05:27:59PM -0600, Rob Herring wrote:
> > On Sun, Nov 27, 2022 at 02:47:28PM -0800, Colin Foster wrote:
> > > Explicitly allow additional properties for both the ethernet-port and
> > > ethernet-ports properties. This specifically will allow the qca8k.yaml
> > > binding to use shared properties.
> > > 
> > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > ---
> > > 
> > > v2 -> v3
> > >   * No change
> > > 
> > > v1 -> v2
> > >   * New patch
> > > 
> > > ---
> > >  Documentation/devicetree/bindings/net/dsa/dsa.yaml | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > > index bd1f0f7c14a8..87475c2ab092 100644
> > > --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > > +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > > @@ -38,6 +38,8 @@ patternProperties:
> > >        '#size-cells':
> > >          const: 0
> > >  
> > > +    additionalProperties: true
> > > +
> > 
> > Where then do we restrict adding properties to ethernet-ports nodes?
> > 
> > >      patternProperties:
> > >        "^(ethernet-)?port@[0-9]+$":
> > >          type: object
> > > @@ -45,7 +47,7 @@ patternProperties:
> > >  
> > >          $ref: dsa-port.yaml#
> > >  
> > > -        unevaluatedProperties: false
> > > +        unevaluatedProperties: true
> > 
> > Same question for ethernet-port nodes.
> 
> For ethernet-port nodes, the qca8k has unevaluatedProperties: false. But
> the fact that you're asking this question means I probably misunderstood
> something...

The above is the case where you aren't adding extra properties (IIRC), 
so 'unevaluatedProperties: false' should be correct.

'unevaluatedProperties: true' is never correct in bindings. If you ref a
schema that sets it to true, you can't override it.

So qca8k, should reference dsa-port.yaml, define its extra properties 
and set 'unevaluatedProperties: false'.

> For the ethernet-ports node, I'm curious if my other follow-up answers
> that question where I realized dsa.yaml should, under the base
> definition, have additionalPrpoerties: false. But again, my guess is
> that isn't the case.

That one looks correct.

Rob
