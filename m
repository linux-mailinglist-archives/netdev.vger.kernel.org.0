Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6A26BEABC
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjCQOJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjCQOJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:09:16 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73839AF68D;
        Fri, 17 Mar 2023 07:09:14 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id v16so4575337wrn.0;
        Fri, 17 Mar 2023 07:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679062153;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4cUCHnqI0AfBz7a3GUqT80VORgI3VfkloynuB2ZGZu0=;
        b=EN1Ss5BBviaWKyN2iiPCA1G5rxgzBrkndGVa31XHU6NkfbITRgv0arw/VjyDahrvGS
         s236GuMvfBLK+DaP0g01LgyUbrtAULb8C6ddbBwwdzbM70Ei98BQh7abhu3rVCzW0TpB
         YiG0/X2b0hROkMyc8C5e8eMP/2wDpm8bEGVMKlOI2y/BAz4VRQldd5onU8KhXKD9aZal
         7PMWnT6rTjJsSjIIM9+OKf6HVa8RrDkP/SVRyTiIv3IDiSSgcA08e+z9FRQesdEoswzu
         mgLEtNPdhNEzkw4vpbk4BJUOVqa+GnjrGNyu47owdc1ucgu3QN+D/eMeAIy4Opj347eF
         UjKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679062153;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4cUCHnqI0AfBz7a3GUqT80VORgI3VfkloynuB2ZGZu0=;
        b=lyqeyeyng45a3RRRl6yHZN+uOVq+VCmBTyRo9zogl3qLoyq/u/pE4p9IDaqWLb1IrJ
         q4ta1g0kg8ez8LhlWy7CgE6qeHj8Sr7cOsSMHv+lCjCFUwNEedAkdD9tm6mwzxQ25o/v
         y16g+iWeXcMTl9//vm2mTM3c97oar0+Dr+/LKQsd0z5j4AkH/1pqVk2YJt7mAsc6Uq4p
         GoB+H60kXx+ZlZkVMQqftVnAMWAmqdAG2fgs47LFXzaQdQ4oZGZlci7zDhe3iUxPl4FY
         ZQWf1kSTc5bcukHRiTQhbzTPSyIgUOpQshHRHZIdwPHW23IL1NeY6Dfa+F5Y0edJ157t
         TGVw==
X-Gm-Message-State: AO0yUKW8cHj0Z9Nyd9XbdxJUyxp+VMPhyGfF9UWg5mlYhIjs2V9b+23w
        7pZJAZar9KAlMm8SUHCnh2k=
X-Google-Smtp-Source: AK7set8ZSvwh8C861MbmcI8zrheicg6wTcJWJ3VwxxFhvYzCdZUnVxz3BSHRZNrwiFZ2hxPOhXIojw==
X-Received: by 2002:adf:fb0d:0:b0:2ce:a758:d6fb with SMTP id c13-20020adffb0d000000b002cea758d6fbmr2601899wrr.1.1679062152605;
        Fri, 17 Mar 2023 07:09:12 -0700 (PDT)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id h6-20020adfe986000000b002d09cba6beasm2064775wrm.72.2023.03.17.07.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 07:09:12 -0700 (PDT)
Message-ID: <64147488.df0a0220.5d091.cce2@mx.google.com>
X-Google-Original-Message-ID: <ZBR0hQ/AH2M8A9t9@Ansuel-xps.>
Date:   Fri, 17 Mar 2023 15:09:09 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org, pavel@ucw.cz,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v4 10/14] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
References: <20230317023125.486-1-ansuelsmth@gmail.com>
 <20230317023125.486-11-ansuelsmth@gmail.com>
 <20230317091410.58787646@dellmb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230317091410.58787646@dellmb>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 09:14:10AM +0100, Marek Behún wrote:
> Hello Christian, also Rob Herring, Andrew Lunn and Pavel Machek,
> 
> On Fri, 17 Mar 2023 03:31:21 +0100
> Christian Marangi <ansuelsmth@gmail.com> wrote:
> 
> > Add LEDs definition example for qca8k Switch Family to describe how they
> > should be defined for a correct usage.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  .../devicetree/bindings/net/dsa/qca8k.yaml    | 24 +++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> > index 389892592aac..2e9c14af0223 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> > @@ -18,6 +18,8 @@ description:
> >    PHY it is connected to. In this config, an internal mdio-bus is registered and
> >    the MDIO master is used for communication. Mixed external and internal
> >    mdio-bus configurations are not supported by the hardware.
> > +  Each phy has at least 3 LEDs connected and can be declared
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
> > +                            default-state = "keep";
> > +                        };
> > +                    };
> >                  };
> 
> I have nothing against this, but I would like to point out the
> existence of the trigger-sources DT property, and I would like to
> discuss how this property should be used by the LED subsystem to choose
> default behaviour of a LED.
> 
> Consider that we want to specify in device-tree that a PHY LED (or any
> other LED) should blink on network activity of the network device
> connected to this PHY (let's say the attached network device is eth0).
> (Why would we want to specify this in devicetree? Because currently the
>  drivers either keep the behaviour from boot or change it to something
>  specific that is not configurable.)
> 
> We could specify in DT something like:
>   eth0: ethernet-controller {
>     ...
>   }
> 
>   ethernet-phy {
>     leds {
>       led@0 {
>         reg = <0>;
>         color = <LED_COLOR_ID_GREEN>;
>         trigger-sources = <&eth0>;
>         function = LED_FUNCTION_ ?????? ;
>       }
>     }
>   }
> 
> The above example specifies that the LED has a trigger source (eth0),
> but we still need to specify the trigger itself (for example that
> the LED should blink on activity, or the different kinds of link). In my
> opinion, this should be specified by the function property, but this
> property is currently used in other way: it is filled in with something
> like "wan" or "lan" or "wlan", an information which, IMO,
> should instead come from the devicename part of the LED, not the
> function part.
> 
> Recall that the LED names are of the form
>   devicename:color:function
> where the devicename part is supposed to be something like mmc0 or
> sda1. With LEDs that are associated with network devices I think the
> corresponding name should be the name of the network device (like eth0),
> but there is the problem of network namespaces and also that network
> devices can be renamed :(.
> 
> So one option how to specify the behaviour of the LED to blink on
> activity would be to set
>   function = LED_FUNCTION_ACTIVITY;
> but this would conflict with how currently some devicetrees use "lan",
> "wlan" or "wan" as the function (which is IMO incorrect, as I said
> above).
> 
> Another option would be to ignore the function and instead use
> additional argument in the trigger-source property, something like
>   trigger-sources = <&eth0 TRIGGER_SOURCE_ACTIVITY>;
> 
> I would like to start a discussion on this and hear about your opinions,
> because I think that the trigger-sources and function properties were
> proposed in good faith, but currently the implementation and usage is a
> mess.
> 

I think we should continue and make this discussion when we start
implementing the hw contro for these LEDs to configure them in DT.

Currently we are implementing very basic support so everything will be
in sw.

Anyway just to give some ideas. Yes it sound a good idea to use the
trigger-sources binding. My idea would be that trigger needs to have
specific support for them. 
If this in mind netdev can be configured in DT and setup hw control to
offload blink with the required interface passed.

The current implementation still didn't include a way to configure the
blink in DT as the series are already a bit big... (currently we have 3:
- This series that already grow from 10 patch to 14
- A cleanup series for netdev trigger that is already 7 patch
- hw control that is another big boy with 12 patch
)

So our idea was to first implement the minor things and then polish and
improve it. (to make it easier to review)

But agree with you that it would be a nice idea to have a correct and
good implementation for trigger-sources.

-- 
	Ansuel
