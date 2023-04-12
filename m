Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75926E0EF5
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbjDMNim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjDMNiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:38:09 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1A6AF0E;
        Thu, 13 Apr 2023 06:35:37 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id o6-20020a05600c4fc600b003ef6e6754c5so6187642wmq.5;
        Thu, 13 Apr 2023 06:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681392925; x=1683984925;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8TjBZzOOiUgO+kPtxRd7fVCLfb724PvO409lq7nUTs0=;
        b=FVXnBRXb6Z6XxnsBV+IeLPfjsgEtX82YOBpUOZdObpHAP4HsohkezHyCZJxpgOHOqs
         Dh5XK/yLHqpR2Etxy2llHaDk+ECBj5vcr4OiyCpeQpBw4Xcr/v6g5MQfVxMW6B2KXsrN
         1JOzNg5YQGuQT8IJPwyBxKRJGsT2pTy8CXPYLd0NishC7i1X6PyBdYUcAdXXO/iaezOg
         AILWSLTWY6sB2awEkx2MAj71vUCpqpN1qMwQFyXSMaoZzkNENBZhulOincOb8snUHrsY
         pRc4zpV8kSUzVZrbb84dp7jObIGZEFoqNOUweYZ27i/rUQYr1OgOfwaUmowTKc86jJ9j
         Hocg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681392925; x=1683984925;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8TjBZzOOiUgO+kPtxRd7fVCLfb724PvO409lq7nUTs0=;
        b=R1F3J9p1skX1L8vWN/BcU7azO1pnpqyW3+yuWn7/E4S3rNI454jBFg4OsfOC2ne+Eu
         XmDb8zxdbsdtsabGpN6WnGiIvJDqZnJY8uVcTKF18N6cmpJvyNqaxY3u1H5MEw54cOUX
         m0GqART0/AHOPe0MnxmhDjEs9QL9/Iv7iQF/h5nMfanUCDEQHXd9eNCtM6B1C9hUUmTF
         RJ7z6qq465odWPZFa58GeTuz3kCcLKS3uB8Mk4Y9qgd6FJ36BPL1vPi1NOgpGaGTbwt/
         Fa6W890iSJeO9vRxf8yGJ+dyhWmGPPM8HtU3xm1C++jd2WyhKmWjc8H+Yl9evMCy/WiH
         B/NQ==
X-Gm-Message-State: AAQBX9cXKw5oy8PubAxcqnWBYTSFK9oBE2eywjZG47FbxJs9rpEMb9ub
        pff2h9SdrCq/zE/1YXcP1ys=
X-Google-Smtp-Source: AKy350YJ2r3wCl95kUb5MnB+RTinXg4FYMSNGuFQm03tfAqvfcmOAHrPbsmhYq/PWiUf5132l7aRRg==
X-Received: by 2002:a1c:6a0d:0:b0:3ed:377b:19cc with SMTP id f13-20020a1c6a0d000000b003ed377b19ccmr1849363wmc.0.1681392925135;
        Thu, 13 Apr 2023 06:35:25 -0700 (PDT)
Received: from Ansuel-xps. (host-87-7-13-196.retail.telecomitalia.it. [87.7.13.196])
        by smtp.gmail.com with ESMTPSA id h15-20020a05600c350f00b003ee9f396dcesm5585905wmq.30.2023.04.13.06.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 06:35:24 -0700 (PDT)
Message-ID: <6438051c.050a0220.d7db1.e1f7@mx.google.com>
X-Google-Original-Message-ID: <ZDcz55wimhKW+jN3@Ansuel-xps.>
Date:   Thu, 13 Apr 2023 00:42:47 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v6 12/16] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-13-ansuelsmth@gmail.com>
 <20230406141018.GA2956156-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406141018.GA2956156-robh@kernel.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 09:10:18AM -0500, Rob Herring wrote:
> On Mon, Mar 27, 2023 at 04:10:27PM +0200, Christian Marangi wrote:
> > Add LEDs definition example for qca8k Switch Family to describe how they
> > should be defined for a correct usage.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  .../devicetree/bindings/net/dsa/qca8k.yaml    | 24 +++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> > index 389892592aac..ad354864187a 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> > @@ -18,6 +18,8 @@ description:
> >    PHY it is connected to. In this config, an internal mdio-bus is registered and
> >    the MDIO master is used for communication. Mixed external and internal
> >    mdio-bus configurations are not supported by the hardware.
> > +  Each phy has at most 3 LEDs connected and can be declared
> > +  using the standard LEDs structure.
> >  
> >  properties:
> >    compatible:
> > @@ -117,6 +119,7 @@ unevaluatedProperties: false
> >  examples:
> >    - |
> >      #include <dt-bindings/gpio/gpio.h>
> > +    #include <dt-bindings/leds/common.h>
> >  
> >      mdio {
> >          #address-cells = <1>;
> > @@ -226,6 +229,27 @@ examples:
> >                      label = "lan1";
> >                      phy-mode = "internal";
> >                      phy-handle = <&internal_phy_port1>;
> > +
> > +                    leds {
> > +                        #address-cells = <1>;
> > +                        #size-cells = <0>;
> > +
> > +                        led@0 {
> > +                            reg = <0>;
> > +                            color = <LED_COLOR_ID_WHITE>;
> > +                            function = LED_FUNCTION_LAN;
> > +                            function-enumerator = <1>;
> > +                            default-state = "keep";
> > +                        };
> > +
> > +                        led@1 {
> > +                            reg = <1>;
> > +                            color = <LED_COLOR_ID_AMBER>;
> > +                            function = LED_FUNCTION_LAN;
> > +                            function-enumerator = <1>;
> 
> Isn't function-enumerator supposed to be unique within a given 
> 'function'?
>

In the following example the output would be:
- amber:lan-1
- white:lan-1

So in theory it's unique for the same color and function. Is it
acceptable? Seems sane that there may be multiple color for the same
function (and enum)

> > +                            default-state = "keep";
> > +                        };
> > +                    };
> >                  };
> >  
> >                  port@2 {
> > -- 
> > 2.39.2
> > 

-- 
	Ansuel
