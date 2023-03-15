Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C6C6BAE1B
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 11:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjCOKtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 06:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjCOKtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 06:49:20 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD83A1CF6C
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 03:49:16 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso796923wmq.1
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 03:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112; t=1678877355;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QYG17Rtnr8gV5ite7dBtbf6hPodDL0JdcdTme5+CyEc=;
        b=MJqL2GnDVXWXFvpn7VMrPfcwsisiOF3OZo800KVL86dwZRBIwb/Kb3aien/UIgIZde
         PVpaZ0ywKqFkAaWMlqVdUCnr12gLOnAN32ZM5Uel6OawzxivpfzHS9BOj38sAkPTc/yw
         7jxyVPXIO5+jkILOhUqHPAWGdS658nf/Nl48Nb4Vkbw5beA9LpCrA30WZQr3a8xP/waO
         MrkK3Kf+eIvJd335SSg7huLJyjT3KOZSPp1S0eLcqe3KxamUrjpuEwEohzt8E6EvFPCv
         4eB6pPx6ukkt3+wr3u3Vi+4G16KHBcwTtzXtdzJYzbuxpQ2A4CFlLKAMWX0WiutFi1Id
         y8RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678877355;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QYG17Rtnr8gV5ite7dBtbf6hPodDL0JdcdTme5+CyEc=;
        b=Fa0ZNNrYz/QEg0uiqbd7rKzuMu6RdNC3PxrdjHHKpJjhVQbEsm2WH3kJ4E+eZvdKAE
         fJUHEyoKVO6VwwAv7TRsqEwFxbhmqQ7A4xwPALQRY8eddcR48T2RyoFAjGMU5eMELWdF
         Z1AYifCXEcNV3Vjs2/bhDQi0sXy338VSY4Li6FCa1az5TDAMqhKw/3CZhjgh7sDoLSyR
         ip9wnuv5Q4oJHCfeRf2AYJ1F1KrPxBcI7AqlpADSEyKipdQerVAWTMVXQbhrs47ohKjn
         C5bbJc5uZg54MamWKc7+zXNRVPSFEbfzy4QEu9bmVkcqfXfSVNt2L1M/G6e55YRDNQu0
         abug==
X-Gm-Message-State: AO0yUKUyEG0MUTkUVkRgs3kBazdR8pteeufo4NLXUfByQoT/leVafmi2
        3/bwM7LFg53YC91SrDAVC+gDug==
X-Google-Smtp-Source: AK7set8dmHieNmdKBE2rH1Q6AmnkOphaKK/4pB7QrHicckfg4LljS4YCfVZfgeiVycLrPh7CFK3z8Q==
X-Received: by 2002:a05:600c:1c96:b0:3eb:3300:1d13 with SMTP id k22-20020a05600c1c9600b003eb33001d13mr17265670wms.14.1678877355250;
        Wed, 15 Mar 2023 03:49:15 -0700 (PDT)
Received: from blmsp ([2001:4090:a247:8056:be7d:83e:a6a5:4659])
        by smtp.gmail.com with ESMTPSA id m16-20020a05600c3b1000b003dc4a47605fsm1516883wms.8.2023.03.15.03.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 03:49:14 -0700 (PDT)
Date:   Wed, 15 Mar 2023 11:49:14 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] dt-bindings: can: tcan4x5x: Add tcan4552 and
 tcan4553 variants
Message-ID: <20230315104914.qpwhnv6drjwau5jr@blmsp>
References: <20230314151201.2317134-1-msp@baylibre.com>
 <20230314151201.2317134-2-msp@baylibre.com>
 <680053bc-66fb-729f-ecdc-2f5fe511cecd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <680053bc-66fb-729f-ecdc-2f5fe511cecd@linaro.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

On Tue, Mar 14, 2023 at 09:01:10PM +0100, Krzysztof Kozlowski wrote:
> On 14/03/2023 16:11, Markus Schneider-Pargmann wrote:
> > These two new chips do not have state or wake pins.
> > 
> > Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> > ---
> >  .../devicetree/bindings/net/can/tcan4x5x.txt          | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
> > index e3501bfa22e9..38a2b5369b44 100644
> > --- a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
> > +++ b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
> > @@ -4,7 +4,10 @@ Texas Instruments TCAN4x5x CAN Controller
> >  This file provides device node information for the TCAN4x5x interface contains.
> >  
> >  Required properties:
> > -	- compatible: "ti,tcan4x5x"
> > +	- compatible:
> > +		"ti,tcan4x5x" or
> > +		"ti,tcan4552" or
> > +		"ti,tcan4553"
> 
> Awesome, they nicely fit into wildcard... Would be useful to deprecate
> the wildcard at some point and switch to proper compatibles in such
> case, because now they became confusing.
> 
> Anyway:
> 
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Thank you. Indeed the old generic name could be replaced, unfortunately
I don't have a list of devices that this generic wildcard matches.

Best,
Markus
