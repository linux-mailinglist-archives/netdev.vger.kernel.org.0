Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19E46B119F
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 20:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjCHTDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 14:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjCHTDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 14:03:13 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8A6CEF92;
        Wed,  8 Mar 2023 11:02:22 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id k37so10471201wms.0;
        Wed, 08 Mar 2023 11:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678302141;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=05QzLCa5h8/aBiXa5wFiBBm9rgGF1oYVgKluk4jSojQ=;
        b=jRN+w1BizFV7AwJHwQ1qGQ7AE8UH2M0msGXp50Cyr7labckXet1D1eQ7IiYUKN+e/h
         RF/oE1CWGx4Y9OjHJBc6fvXPK/E3NPjdZLI99Z548YUtMEHyxP69ZyJ19+LF7aMK0hXu
         3C2COWA1wyrd9tmF7SYmUekJhYam9V+tcgS5kp58R49RM/hqPVOjLpWP/N/l9FqEcGAY
         lLmGrBlvGp60bJ8H6uRIP0KrXIHliZqxQI86zJZ09vJQ5H7/I7dQkL9SQMFqf3FjN5R7
         L23P16SUPomcoLK+msyy5ViCIAk+SvIaFjKECqL+6pY+CpNahGYSdvca5SN+QdFFbtS0
         hhTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678302141;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=05QzLCa5h8/aBiXa5wFiBBm9rgGF1oYVgKluk4jSojQ=;
        b=aNYdOAR2xDObLzOGImD/b/eG5xgCHJEAb0VfKdnUK6r/77AWfku6TzRSn0azgt3Nrl
         wqD9I6AQOb85ySPOYj/f6yc3AKcY4dkQscQGbQFyu1zQ6jUv6higRMRMm6HyOyTlAlgk
         xGssfYEpQ9ubDwjWh7tdsMhOVbeNfJocu6POcvI050JxO9V53+oyrZbkFZweYMQnh3x9
         Q30+j+UiQuGEXavZRgkEpTFmMBa8eRm5tFBXyJqVqnDoSy87eaUSbmG36EGlfApZD43u
         2pV5uVm47qZoUYgQmhv0gqdlZf+9+rbpu2yVNyvoFqyWdEEL45O2JJ9nO03tmQ5y74s5
         unlw==
X-Gm-Message-State: AO0yUKXRVVoOQhLHaYYG0LB8zzMs9cEF8cM8wwUsGLUzCdCyFASCL0mr
        R7LZwnl9O5U7bv+IhXXp/zA=
X-Google-Smtp-Source: AK7set9hoVq9qbS24mVE0Dp6UKPSHIlBpzT3sWahFNF0J3P+44HP9t0tKqS27UMLF8wN68SNGI6VqQ==
X-Received: by 2002:a05:600c:4fc5:b0:3ea:f0d6:5d37 with SMTP id o5-20020a05600c4fc500b003eaf0d65d37mr16838323wmq.8.1678302140499;
        Wed, 08 Mar 2023 11:02:20 -0800 (PST)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id a14-20020a1cf00e000000b003e21f20b646sm278516wmb.21.2023.03.08.11.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 11:02:19 -0800 (PST)
Message-ID: <6408dbbb.1c0a0220.a28ce.1b32@mx.google.com>
X-Google-Original-Message-ID: <ZAjbuWRiHVEGVFX+@Ansuel-xps.>
Date:   Wed, 8 Mar 2023 20:02:17 +0100
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
Subject: Re: [net-next PATCH 09/11] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
 <20230307170046.28917-10-ansuelsmth@gmail.com>
 <ad43a809-b9fd-bd24-ee1a-9e509939023b@linaro.org>
 <df6264de-36c5-41f2-a2a0-08b61d692c75@lunn.ch>
 <5992cb0a-50a0-a19c-3ad1-03dd347a630b@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5992cb0a-50a0-a19c-3ad1-03dd347a630b@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 07:49:26PM +0100, Krzysztof Kozlowski wrote:
> On 08/03/2023 14:57, Andrew Lunn wrote:
> > On Wed, Mar 08, 2023 at 11:58:33AM +0100, Krzysztof Kozlowski wrote:
> >> On 07/03/2023 18:00, Christian Marangi wrote:
> >>> Add LEDs definition example for qca8k Switch Family to describe how they
> >>> should be defined for a correct usage.
> >>>
> >>> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> >>
> >> Where is the changelog? This was v8 already! What happened with all
> >> review, changes?
> > 
> > Did you read patch 0?
> > 
> > We have decided to start again, starting small and working up. This
> > patchset just adds plain, boring LEDs. No acceleration, on hardware
> > offload. Just on/off, and fixed blink.
> 
> Sure, but the patch is carried over. So what happened with all its
> feedback? Was there or was not? How can we know?
>

The history of the old series is a bit sad, not enough review, another
dev asking for a different implementation and me doing an hybrid to
reach a common point (and then disappear intro oblivion)...

Short story is that this current series have nothing related to the HW
offload feature and only in v7 it was asked to put the LED nodes in
ethernet-phy.yaml

I can put in the cover letter of v2 of this series the changelog of the
previous series but they would only be related to other part that are
not related to this.

Just to give you some context and explain why the changelog was dropped.

> > 
> > What do you think makes the patchset is not bisectable? We are happy
> > to address such issues, but i did not notice anything.
> 
> I didn't write anything like that here...
> 

-- 
	Ansuel
