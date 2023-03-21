Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C666C3DE6
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 23:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjCUWyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 18:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjCUWyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 18:54:52 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C3458C0D;
        Tue, 21 Mar 2023 15:54:50 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id v4-20020a05600c470400b003ee4f06428fso833563wmo.4;
        Tue, 21 Mar 2023 15:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679439289;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=3HAdzANA7GRiZJA2epDIo4XVuYsjDwv30y8YzH+0KtI=;
        b=fbbcthgEVJKZpX19gE41dOEOZKGjPLVKXpR8AbRUpLUoU/Ydsut9Zy+qXTSDba3O7R
         ogPPDSLCqyZUYOCPKk+OmrlyeNjPcYeRklvTVVvPSX4M4womGAubm5V5mwT7IZoQ2pYm
         p+BAeasDHYp9yX9PFSrJ4iPGbZQKqGidrJDZxda7g0Kr45XoKI78QWNEhzNuZUmzPrXn
         py/5T0NSmJHosHOMuugdEJDY5+Q7OoAnUoYeRiTLjqwcyyxHhmDZxe1e4ZTR0BLZy5iI
         imPJNvtU0FUZ2P0ObJH3NNJOlecs4VQ86l16+H3iPEJUHgrV0EDMCXMnY4UrntCAgPTH
         sIzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679439289;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3HAdzANA7GRiZJA2epDIo4XVuYsjDwv30y8YzH+0KtI=;
        b=swU/voEmZwTXqHCREjwXzhSdfJoIa2X2AJ+sxRtHfPYG+QZhYnDF7HQ7IhP9TxssqU
         IqlM9IuwEJd2Q1ilc5G0bJg8FJ32jIdB9QtPu+6ik4s4zdSeF+RPzvvW4toZ/ZngfQml
         bPnIscmNVdoOa/3NPlnqTRTkaYI+7I9SGlTMKzI92c4EJA3RPp8gLy//gXkW3xcHokgY
         IQk8rdQsOl+g7v5NPA2U20E/q8+byjgpuxAMchrYmq3+gUzGaJSE29/BQ23M59YmJ5Ud
         JV0jD4SzI3qb5cxY//k/FsImLA0qvIXIL8CbmNckCKOKou6ipYdN+cA9B+VRtWiTycGp
         FrQw==
X-Gm-Message-State: AO0yUKVPFQAFjsNexcnK6k7FLwk5qnj8/QjDZ9Kkt4qXIitNM3fPv6YC
        5zJhv2dls01BJwc6w3iqvh+yxEnUP1CVyw==
X-Google-Smtp-Source: AK7set/E8pBAGWWNISHq/PCSZ5cZ24Z1eoHpQqNIofp1fioL8wjvPDeViM3lQCpr0N0Vic6sWSO9tA==
X-Received: by 2002:a7b:ce8a:0:b0:3df:de28:f819 with SMTP id q10-20020a7bce8a000000b003dfde28f819mr3832933wmj.15.1679439288934;
        Tue, 21 Mar 2023 15:54:48 -0700 (PDT)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id h20-20020a1ccc14000000b003dc522dd25esm14755161wmb.30.2023.03.21.15.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 15:54:48 -0700 (PDT)
Message-ID: <641a35b8.1c0a0220.25419.2b4d@mx.google.com>
X-Google-Original-Message-ID: <ZBo1tqarEyoA0sV0@Ansuel-xps.>
Date:   Tue, 21 Mar 2023 23:54:46 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Rob Herring <robh@kernel.org>
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
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-11-ansuelsmth@gmail.com>
 <20230321211953.GA1544549-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321211953.GA1544549-robh@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 04:19:53PM -0500, Rob Herring wrote:
> On Sun, Mar 19, 2023 at 08:18:09PM +0100, Christian Marangi wrote:
> > Document support for LEDs node in ethernet-controller.
> > Ethernet Controller may support different LEDs that can be configured
> > for different operation like blinking on traffic event or port link.
> > 
> > Also add some Documentation to describe the difference of these nodes
> > compared to PHY LEDs, since ethernet-controller LEDs are controllable
> > by the ethernet controller regs and the possible intergated PHY doesn't
> > have control on them.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  .../bindings/net/ethernet-controller.yaml     | 21 +++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> > index 00be387984ac..a93673592314 100644
> > --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> > +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> > @@ -222,6 +222,27 @@ properties:
> >          required:
> >            - speed
> >  
> > +  leds:
> > +    type: object
> > +    description:
> > +      Describes the LEDs associated by Ethernet Controller.
> > +      These LEDs are not integrated in the PHY and PHY doesn't have any
> > +      control on them. Ethernet Controller regs are used to control
> > +      these defined LEDs.
> > +
> > +    properties:
> > +      '#address-cells':
> > +        const: 1
> > +
> > +      '#size-cells':
> > +        const: 0
> > +
> > +    patternProperties:
> > +      '^led(@[a-f0-9]+)?$':
> > +        $ref: /schemas/leds/common.yaml#
> 
> Are specific ethernet controllers allowed to add their own properties in 
> led nodes? If so, this doesn't work. As-is, this allows any other 
> properties. You need 'unevaluatedProperties: false' here to prevent 
> that. But then no one can add properties. If you want to support that, 
> then you need this to be a separate schema that devices can optionally 
> include if they don't extend the properties, and then devices that 
> extend the binding would essentially have the above with:
> 
> $ref: /schemas/leds/common.yaml#
> unevaluatedProperties: false
> properties:
>   a-custom-device-prop: ...
> 
> 
> If you wanted to define both common ethernet LED properties and 
> device specific properties, then you'd need to replace leds/common.yaml 
> above  with the ethernet one.
> 
> This is all the same reasons the DSA/switch stuff and graph bindings are 
> structured the way they are.
> 

Hi Rob, thanks for the review/questions.

The idea of all of this is to keep leds node as standard as possible.
It was asked to add unevaluatedProperties: False but I didn't understood
it was needed also for the led nodes.

leds/common.yaml have additionalProperties set to true but I guess that
is not OK for the final schema and we need something more specific.

Looking at the common.yaml schema reg binding is missing so an
additional schema is needed.

Reg is needed for ethernet LEDs and PHY but I think we should also permit
to skip that if the device actually have just one LED. (if this wouldn't
complicate the implementation. Maybe some hints from Andrew about this
decision?)

If we decide that reg is a must, if I understood it correctly we should
create something like leds-ethernet.yaml that would reference common and
add reg binding? Is it correct? This schema should be laded in leds
directory and not in the net/ethernet.

Also with setting reg mandatory I will have to fix the regex to require
@ in the node name.


Also also if we decide for a more specific schema, I guess I can
reference that directly in ethernet-phy.yaml and ethernet-controller.yaml
with something like:

leds:
  $ref: /schemas/leds/leds-ethernet.yaml#

Again thanks for the review and hope you can give some
hint/clarification if I got everything right.

-- 
	Ansuel
