Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6D351C0ED
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352492AbiEENii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbiEENih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:38:37 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F1B1AD99;
        Thu,  5 May 2022 06:34:57 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id l18so8765672ejc.7;
        Thu, 05 May 2022 06:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=UPQKk6k7iZjBvDBrSwiqjZZBhXacN0AVsfOq9/Z93RE=;
        b=P58lRPzo06h3imubgpZe523Pph7le52PJEYuSZv1mDJnO16H81MRvQJ9KuwDonmwBD
         6k1GU7Xesh2MZcdOES8S67Mt8O5z1RUY3xMZMv4gmvJ5hv5RcnAVkE09FNcEKYfhgHBn
         rtnuS6JjnDFOeObCU4rTGJ2M3jKcNegqxXAzgG/Ha9rdwBKCTl/Ce9w1Vq7qOhTfMdEQ
         144K73yQcNmW4de48pzWMWqZsM0qPMw/E9ylQm1XHD8HfBUsnxAMptpN7ycL58Pehpps
         08XeL4BUqSutr5bwYeXMaF184+KbNa+Um0wIY6T1UmYNgwpDeE9eDMc1Ptd2/EMQZuk5
         qo/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=UPQKk6k7iZjBvDBrSwiqjZZBhXacN0AVsfOq9/Z93RE=;
        b=DLdIc33rIPxsq+EU6NmPKgSnnvZlYjuRnRCeyxFyhOIZa/RP4/9QH0QEDZSjYrRooO
         aDup8kZuWOx5NBQELTs3pA8Y5hjVf1V1KbyZq5Y1op0g7EXPOCe8xgRM3QpiZpmN3HeF
         3r1PHoOGPUWy9svTm06bt15l5/eZEMAKReqDVIaq0eEJfHhhm4Y6+KAT5kU7Z3pYegDx
         oFC+zrm5FhhP+nFu/abJSAnq1AC0nx9arqOpt8zjnLiiPlFqcoeBXq+MtzW5YJJ0wllb
         gfqijl5rgHjmQhuLt9Wws99TTvhDhWa5PbzZ7xCGaAQpHEJYQfZni+fG5ZVh0JurwPvB
         yI3A==
X-Gm-Message-State: AOAM5319AtvbWFbYajiAdevF9++MC4NdyoTeZuNQIMkA9vwMZ4dt9bzv
        foTjcCNb16vO+lZGMJ1LWJP+7Flf23w=
X-Google-Smtp-Source: ABdhPJzPbgp1O6nSwALSCxsYipeQz7C8LafxJDsmZA0CjnA+ucU/sR54+B09i+/QQGyS79tGfcnk2A==
X-Received: by 2002:a17:906:a08b:b0:6b9:2e20:f139 with SMTP id q11-20020a170906a08b00b006b92e20f139mr27451391ejy.463.1651757695463;
        Thu, 05 May 2022 06:34:55 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id mm27-20020a170906cc5b00b006f3ef214e1csm758571ejb.130.2022.05.05.06.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 06:34:54 -0700 (PDT)
Message-ID: <6273d27e.1c69fb81.95534.43c8@mx.google.com>
X-Google-Original-Message-ID: <YnPSfWaN4LlOfwjD@Ansuel-xps.>
Date:   Thu, 5 May 2022 15:34:53 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v6 11/11] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
 <20220503151633.18760-12-ansuelsmth@gmail.com>
 <YnK0xHOkfXI+rgzs@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnK0xHOkfXI+rgzs@robh.at.kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 12:15:48PM -0500, Rob Herring wrote:
> On Tue, May 03, 2022 at 05:16:33PM +0200, Ansuel Smith wrote:
> > Add LEDs definition example for qca8k using the offload trigger as the
> > default trigger and add all the supported offload triggers by the
> > switch.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  .../devicetree/bindings/net/dsa/qca8k.yaml    | 20 +++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> > index f3c88371d76c..9b46ef645a2d 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> > @@ -65,6 +65,8 @@ properties:
> >                   internal mdio access is used.
> >                   With the legacy mapping the reg corresponding to the internal
> >                   mdio is the switch reg with an offset of -1.
> > +                 Each phy have at least 3 LEDs connected and can be declared
> 
> s/at least/up to/ ?
> 
> Or your example is wrong with only 2.
>

Up to. Internally the regs are there but 99% of the times OEM just
connect 2 of 3 LEDs. Will fix. 

> > +                 using the standard LEDs structure.
> >  
> >  patternProperties:
> >    "^(ethernet-)?ports$":
> > @@ -287,6 +289,24 @@ examples:
> >  
> >                  internal_phy_port1: ethernet-phy@0 {
> >                      reg = <0>;
> > +
> > +                    leds {
> > +                        led@0 {
> > +                            reg = <0>;
> > +                            color = <LED_COLOR_ID_WHITE>;
> > +                            function = LED_FUNCTION_LAN;
> > +                            function-enumerator = <1>;
> > +                            linux,default-trigger = "netdev";
> > +                        };
> > +
> > +                        led@1 {
> > +                            reg = <1>;
> > +                            color = <LED_COLOR_ID_AMBER>;
> > +                            function = LED_FUNCTION_LAN;
> > +                            function-enumerator = <1>;
> > +                            linux,default-trigger = "netdev";
> > +                        };
> > +                    };
> >                  };
> >  
> >                  internal_phy_port2: ethernet-phy@1 {
> > -- 
> > 2.34.1
> > 
> > 

-- 
	Ansuel
