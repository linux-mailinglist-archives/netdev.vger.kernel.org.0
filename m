Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B052E6C8812
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjCXWGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjCXWGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:06:47 -0400
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995DB15899;
        Fri, 24 Mar 2023 15:06:45 -0700 (PDT)
Received: by mail-oo1-f50.google.com with SMTP id r8-20020a4aa8c8000000b0053b6fd7bc8dso505060oom.4;
        Fri, 24 Mar 2023 15:06:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679695605;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jgu6wWXcTcsTo5LN3ZtXGI94HoYL88NOlxBVx6Lr4x8=;
        b=1E4xwdKkwfC2YyR1icsOVHRCKe5c/avX8rVSHLzyL7mgAWN14BIqb4uSmRP9kyq0Gs
         FJbAcUzVVIsSH4klaglss1ytTpj/xS6Qw7Db229CHrcvWvrEt0nqtn5rdC+8+GAkKh+g
         4vQQY5cPrMXniIfksB3voz7iTq7LawIhtul1ehvNf8utL8RSlQtYpIP5jeOAF9MQ6kHC
         68pkTwXr8pSZOuCUvvJmdE+nU9xrXHoSlNMsC3ZOGuhlTL670H+gNHE+8L5dLmgfwnwA
         cT0A8gmiFxiS3zPwmmrONjgcWCk1h/Yvc9sip7P/JmHPeD6GQ0KF19cfFfMhYvzWbXGU
         DGRA==
X-Gm-Message-State: AO0yUKXqcSdVSo39y77Egt7WQapAFDeVcmx8yrEzLxlekF96vW3Q/qN0
        2T84FCOOvQN7gzkAsVKUjg==
X-Google-Smtp-Source: AK7set+LkRQlXG/4pv+KExNl9Uhk5BFBvi0zBaNEWGI9yXsm8GdhJTfphf7IDD/+RKhTTiMVChNQFA==
X-Received: by 2002:a4a:3356:0:b0:525:c83:2f94 with SMTP id q83-20020a4a3356000000b005250c832f94mr2358873ooq.4.1679695604841;
        Fri, 24 Mar 2023 15:06:44 -0700 (PDT)
Received: from robh_at_kernel.org ([2605:ef80:80f9:92f0:b372:78c0:69c1:66d6])
        by smtp.gmail.com with ESMTPSA id y45-20020a4a9830000000b0053bb063121asm768308ooi.9.2023.03.24.15.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 15:06:44 -0700 (PDT)
Received: (nullmailer pid 64249 invoked by uid 1000);
        Fri, 24 Mar 2023 22:06:41 -0000
Date:   Fri, 24 Mar 2023 17:06:41 -0500
From:   Rob Herring <robh@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
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
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v5 10/15] dt-bindings: net: ethernet-controller:
 Document support for LEDs node
Message-ID: <20230324220641.GA54972-robh@kernel.org>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-11-ansuelsmth@gmail.com>
 <20230321211953.GA1544549-robh@kernel.org>
 <641a35b8.1c0a0220.25419.2b4d@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <641a35b8.1c0a0220.25419.2b4d@mx.google.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 11:54:46PM +0100, Christian Marangi wrote:
> On Tue, Mar 21, 2023 at 04:19:53PM -0500, Rob Herring wrote:
> > On Sun, Mar 19, 2023 at 08:18:09PM +0100, Christian Marangi wrote:
> > > Document support for LEDs node in ethernet-controller.
> > > Ethernet Controller may support different LEDs that can be configured
> > > for different operation like blinking on traffic event or port link.
> > > 
> > > Also add some Documentation to describe the difference of these nodes
> > > compared to PHY LEDs, since ethernet-controller LEDs are controllable
> > > by the ethernet controller regs and the possible intergated PHY doesn't
> > > have control on them.
> > > 
> > > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > > ---
> > >  .../bindings/net/ethernet-controller.yaml     | 21 +++++++++++++++++++
> > >  1 file changed, 21 insertions(+)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> > > index 00be387984ac..a93673592314 100644
> > > --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> > > +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> > > @@ -222,6 +222,27 @@ properties:
> > >          required:
> > >            - speed
> > >  
> > > +  leds:
> > > +    type: object
> > > +    description:
> > > +      Describes the LEDs associated by Ethernet Controller.
> > > +      These LEDs are not integrated in the PHY and PHY doesn't have any
> > > +      control on them. Ethernet Controller regs are used to control
> > > +      these defined LEDs.
> > > +
> > > +    properties:
> > > +      '#address-cells':
> > > +        const: 1
> > > +
> > > +      '#size-cells':
> > > +        const: 0
> > > +
> > > +    patternProperties:
> > > +      '^led(@[a-f0-9]+)?$':
> > > +        $ref: /schemas/leds/common.yaml#
> > 
> > Are specific ethernet controllers allowed to add their own properties in 
> > led nodes? If so, this doesn't work. As-is, this allows any other 
> > properties. You need 'unevaluatedProperties: false' here to prevent 
> > that. But then no one can add properties. If you want to support that, 
> > then you need this to be a separate schema that devices can optionally 
> > include if they don't extend the properties, and then devices that 
> > extend the binding would essentially have the above with:
> > 
> > $ref: /schemas/leds/common.yaml#
> > unevaluatedProperties: false
> > properties:
> >   a-custom-device-prop: ...
> > 
> > 
> > If you wanted to define both common ethernet LED properties and 
> > device specific properties, then you'd need to replace leds/common.yaml 
> > above  with the ethernet one.
> > 
> > This is all the same reasons the DSA/switch stuff and graph bindings are 
> > structured the way they are.
> > 
> 
> Hi Rob, thanks for the review/questions.
> 
> The idea of all of this is to keep leds node as standard as possible.
> It was asked to add unevaluatedProperties: False but I didn't understood
> it was needed also for the led nodes.
> 
> leds/common.yaml have additionalProperties set to true but I guess that
> is not OK for the final schema and we need something more specific.

Yes, every node needs a schema with all possible properties and then 
'unevaluatedProperties: false' to not allow any other properties.

> Looking at the common.yaml schema reg binding is missing so an
> additional schema is needed.
> 
> Reg is needed for ethernet LEDs and PHY but I think we should also permit
> to skip that if the device actually have just one LED. (if this wouldn't
> complicate the implementation. Maybe some hints from Andrew about this
> decision?)
> 
> If we decide that reg is a must, if I understood it correctly we should
> create something like leds-ethernet.yaml that would reference common and
> add reg binding? Is it correct? This schema should be laded in leds
> directory and not in the net/ethernet.

You need 'reg' in properties, but whether it is required or not just 
depends on putting it in 'required'. I don't have a strong opinion on 
that, but generally it's only use 'reg' when there's more than 1.

Rob
