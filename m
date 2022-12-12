Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D75C64A547
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 17:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbiLLQvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 11:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiLLQvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 11:51:51 -0500
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E71FCFA;
        Mon, 12 Dec 2022 08:51:50 -0800 (PST)
Received: by mail-oo1-f46.google.com with SMTP id f7-20020a4a8907000000b004a0cb08d0afso1879988ooi.8;
        Mon, 12 Dec 2022 08:51:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fw+FQfUWqgrmWhnQ5tTZXz7tACC4Nbw/x4d/Z5/ycXo=;
        b=Vm1rEgU3ayyJODFbZftmIYCPLyed6KvRgHwtAjDiQcKkG7EG1CdSI0K0dRUPLXxdb1
         hkkEuHXGpaovMynAspbzPhe/cC5xQtIkuNe99BxzOpZ7FJKryzhUMxc8O29T8XcfbAPJ
         ZCQs5eJCLQ5QSGgby6yF8sLxz8Ns16TAVX4dnsLa01A9aY4NDPBCVfh8JbLpIKSNGRnH
         FhwkFWmM4NMQD6E61gatBrABtZMRkbrtyOBzz5E1gwynrN9NwX6orYgmfzmj01aumNZm
         gos0j4VOppvviHNiKtpZBZHlTO3jw9+NnKeGYe/PpuFcmwGxnI9PZ43xC0w7gedyiBlX
         RfjA==
X-Gm-Message-State: ANoB5pl0Vq8mUcgb2DRSYZB1XYvvb2oCf2vaEOHUZqgNaOiV+gMR79Pb
        RGq4ZRwWPKuJBrkTgPS4tQ==
X-Google-Smtp-Source: AA0mqf4JgmraL4eWltO8kdHW3aLBVUk88Cn46DWf2vGImxEn0iFSbPu2gptYZfF9EjxIEOzPe2O0Xg==
X-Received: by 2002:a4a:e247:0:b0:49f:dba7:5e65 with SMTP id c7-20020a4ae247000000b0049fdba75e65mr6556517oot.3.1670863909584;
        Mon, 12 Dec 2022 08:51:49 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id s21-20020a4ac815000000b004a0aac2d28fsm97397ooq.35.2022.12.12.08.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 08:51:49 -0800 (PST)
Received: (nullmailer pid 1116541 invoked by uid 1000);
        Mon, 12 Dec 2022 16:51:47 -0000
Date:   Mon, 12 Dec 2022 10:51:47 -0600
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        linux-renesas-soc@vger.kernel.org,
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
Subject: Re: [PATCH v5 net-next 04/10] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
Message-ID: <20221212165147.GA1092706-robh@kernel.org>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-5-colin.foster@in-advantage.com>
 <1df417b5-a924-33d4-a302-eb526f7124b4@arinc9.com>
 <Y5TJw+zcEDf2ItZ5@euler>
 <c1e40b58-4459-2929-64f3-3e20f36f6947@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c1e40b58-4459-2929-64f3-3e20f36f6947@arinc9.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 12:28:06PM +0300, Arınç ÜNAL wrote:
> On 10.12.2022 21:02, Colin Foster wrote:
> > Hi Arınç,
> > On Sat, Dec 10, 2022 at 07:24:42PM +0300, Arınç ÜNAL wrote:
> > > On 10.12.2022 06:30, Colin Foster wrote:
> > > > DSA a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > > > +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > > > @@ -58,4 +58,26 @@ oneOf:
> > > >    additionalProperties: true
> > > > +$defs:
> > > > +  ethernet-ports:
> > > > +    description: A DSA switch without any extra port properties
> > > > +    $ref: '#/'
> > > > +
> > > > +    patternProperties:
> > > > +      "^(ethernet-)?ports$":
> > > > +        type: object
> > > > +        additionalProperties: false
> > > > +
> > > > +        properties:
> > > > +          '#address-cells':
> > > > +            const: 1
> > > > +          '#size-cells':
> > > > +            const: 0
> > > > +
> > > > +        patternProperties:
> > > > +          "^(ethernet-)?port@[0-9]+$":
> > > > +            description: Ethernet switch ports
> > > > +            $ref: dsa-port.yaml#
> > > > +            unevaluatedProperties: false
> > > 
> > > I've got moderate experience in json-schema but shouldn't you put 'type:
> > > object' here like you did for "^(ethernet-)?ports$"?
> > 
> > I can't say for sure, but adding "type: object" here and removing it
> > from mediatek,mt7530.yaml still causes the same issue I mention below.
> > 
> > Rob's initial suggestion for this patch set (which was basically the
> > entire implementation... many thanks again Rob) can be found here:
> > https://lore.kernel.org/netdev/20221104200212.GA2315642-robh@kernel.org/
> > 
> >  From what I can tell, the omission of "type: object" here was
> > intentional. At the very least, it doesn't seem to have any effect on
> > warnings.
> > 
> > > 
> > > > +
> > > >    ...
> > > > diff --git a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
> > > > index 73b774eadd0b..748ef9983ce2 100644
> > > > --- a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
> > > > +++ b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
> > > > @@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
> > > >    title: Hirschmann Hellcreek TSN Switch Device Tree Bindings
> > > >    allOf:
> > > > -  - $ref: dsa.yaml#
> > > > +  - $ref: dsa.yaml#/$defs/ethernet-ports
> > > >    maintainers:
> > > >      - Andrew Lunn <andrew@lunn.ch>
> > > > diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > > > index f2e9ff3f580b..20312f5d1944 100644
> > > > --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > > > +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > > > @@ -157,9 +157,6 @@ patternProperties:
> > > >        patternProperties:
> > > >          "^(ethernet-)?port@[0-9]+$":
> > > >            type: object
> > > 
> > > This line was being removed on the previous version. Must be related to
> > > above.
> > 
> > Without the 'object' type here, I get the following warning:
> > 
> > Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml: patternProperties:^(ethernet-)?ports$:patternProperties:^(ethernet-)?port@[0-9]+$: 'anyOf' conditional failed, one must be fixed:
> >          'type' is a required property
> >          '$ref' is a required property
> >          hint: node schemas must have a type or $ref
> >          from schema $id: http://devicetree.org/meta-schemas/core.yaml#
> > ./Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml: Error in referenced schema matching $id: http://devicetree.org/schemas/net/dsa/mediatek,mt7530.yaml
> >    SCHEMA  Documentation/devicetree/bindings/processed-schema.json
> > /home/colin/src/work/linux_vsc/linux-imx/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml: ignoring, error in schema: patternProperties: ^(ethernet-)?ports$: patternProperties: ^(ethernet-)?port@[0-9]+$

Is the above warning not clear? We require either 'type' or a $ref to 
define nodes as json-schema objects.


> > I'm testing this now and I'm noticing something is going on with the
> > "ref: dsa-port.yaml"
> > 
> > 
> > Everything seems to work fine (in that I don't see any warnings) when I
> > have this diff:
> > 
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > index 20312f5d1944..db0122020f98 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yam
> > @@ -156,8 +156,7 @@ patternProperties:
> > 
> >       patternProperties:
> >         "^(ethernet-)?port@[0-9]+$":
> > -        type: object
> > -
> > +        $ref: dsa-port.yaml#
> >           properties:
> >             reg:
> >               description:
> > @@ -165,7 +164,6 @@ patternProperties:
> >                 for user ports.
> > 
> >           allOf:
> > -          - $ref: dsa-port.yaml#
> >             - if:
> >                 required: [ ethernet ]
> >               then:
> > 
> > 
> > 
> > This one has me [still] scratching my head...
> 
> Right there with you. In addition to this, having or deleting type object
> on/from "^(ethernet-)?ports$" and "^(ethernet-)?port@[0-9]+$" on dsa.yaml
> doesn't cause any warnings (checked with make dt_binding_check
> DT_SCHEMA_FILES=net/dsa) which makes me question why it's there in the first
> place.


That check probably doesn't consider an ref being under an 'allOf'. 
Perhaps what is missing in understanding is every schema at the 
top-level has an implicit 'type: object'. But nothing is ever implicit 
in json-schema which will silently ignore keywords which don't make 
sense for an instance type. Instead of a bunch of boilerplate, the 
processed schema has 'type' added in lots of cases such as this one.

Rob
