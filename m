Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFD06B11AF
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 20:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjCHTFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 14:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjCHTEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 14:04:34 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7EC61892;
        Wed,  8 Mar 2023 11:03:58 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id v16so16435568wrn.0;
        Wed, 08 Mar 2023 11:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678302230;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=GyEWSQ+G2MWKOlELKWDgQ+RU89YhI2uCRrCVz5D3irU=;
        b=gPFP5RFz8fdqZUUyrGaqnfYAtrqd3NpQIq9pM1B5/5roMkDm+vAl1z7Jl/Li5gwSkS
         uWR9XsAkodbakTFbuNqdic8XU2LOjW2imL4qGQrTOB7aeklok8jTtgub3ecVvcTzgR+z
         SWSgB3TRSnn19P2F4T5SB8IGVRqDGfvAZ1vnP4Idz9QOupp1hyjkV+sobJJnPgJpSVvo
         dTu3qcTdlgFuPPwlsAEgEPywj9fY7QiPKfwYw7f3aVUElP2rkDflTq6mnmfNlG33CPOK
         EFxYI667fT5+6kI4JDUUJU0FTQRDVBkTbNoxFfvsGk6yYaHGBUDv7ediPHfY2j6CYuRi
         p0vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678302230;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GyEWSQ+G2MWKOlELKWDgQ+RU89YhI2uCRrCVz5D3irU=;
        b=UhFTlaNXffhaGdR1ioivsbBJk+7NXrasNYg1Q7ixk2smqokSFyWKQXJZgNROZ6a2mi
         ky3jrOQMNrWkmsKBbZfWqqlwxswAe2EAvApeJ3ik/ncm1v2ryMXaniCpw6H3kPuxniDJ
         AD+nmnHoFXsSgnqM3iOr+0d/EfZ0FBmbbAC2goP+EdTKy+gzjmwiQfaNOdholVTWKGAt
         kraQeDxKIpmA1WmIWSsNdtwL5zC7xubGqDA0bD8wZFughHRgUGWogh3Y3RBSJ34Tijz7
         Erqo5HMVR7t9n//rxKIUyjKb9l87ML6cWnXpTOqlYwweg4pfYVFK3+d2Goikrt79yddi
         CnSw==
X-Gm-Message-State: AO0yUKXyWWsqcP+xMeXIEP1s0O4dD+zN+MokLQJETI65HK1KvwiP9bGZ
        ZQ2dbbo3XhHJ3xELZK1cTJs=
X-Google-Smtp-Source: AK7set9zWhFR+fhSCmw/by0OxIhyJDhKvuE8Ndxn+7KOiJv5qWAkVRPqq00/gtyaC1fGqc6JucygyQ==
X-Received: by 2002:adf:fe47:0:b0:2c7:e26:97c2 with SMTP id m7-20020adffe47000000b002c70e2697c2mr12732792wrs.33.1678302230524;
        Wed, 08 Mar 2023 11:03:50 -0800 (PST)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id w2-20020a5d6802000000b002c7163660a9sm15880471wru.105.2023.03.08.11.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 11:03:50 -0800 (PST)
Message-ID: <6408dc16.5d0a0220.dc775.18e5@mx.google.com>
X-Google-Original-Message-ID: <ZAjcEpmB1qBHEpdH@Ansuel-xps.>
Date:   Wed, 8 Mar 2023 20:03:46 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH 10/11] dt-bindings: net: phy: Document support
 for LEDs node
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
 <20230307170046.28917-11-ansuelsmth@gmail.com>
 <7c6a70d1-fd64-66cc-688b-3e04634066bb@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c6a70d1-fd64-66cc-688b-3e04634066bb@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 07:56:57PM +0100, Krzysztof Kozlowski wrote:
> On 07/03/2023 18:00, Christian Marangi wrote:
> > Document support for LEDs node in phy and add an example for it.
> > PHY LED will have to match led pattern and should be treated as a
> > generic led.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  .../devicetree/bindings/net/ethernet-phy.yaml | 22 +++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > index 1327b81f15a2..0ec8ef6b0d8a 100644
> > --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > @@ -197,6 +197,13 @@ properties:
> >        PHY's that have configurable TX internal delays. If this property is
> >        present then the PHY applies the TX delay.
> >  
> > +  leds:
> > +    type: object
> 
> additionalProperties: false
> 
> although maybe this was already said in one of previous ten reviews...
>

Thanks for the review. (this is rather new from the old patch (appeared
only in v7 so sorry if I didn't see that in the old series. Will fix in
v2 of this!)

> > +
> > +    patternProperties:
> > +      '^led(@[a-f0-9]+)?$':
> > +        $ref: /schemas/leds/common.yaml#
> > +
> 

-- 
	Ansuel
