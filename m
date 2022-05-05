Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7766551C1D8
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 16:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380339AbiEEOGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 10:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380320AbiEEOGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 10:06:21 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1264B5838B;
        Thu,  5 May 2022 07:02:42 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id bv19so8940107ejb.6;
        Thu, 05 May 2022 07:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Q9neuIG6NME92B0FTzFk6RBoNBkN6kIQjOv1wlxUZcU=;
        b=XIIk6Ky7qtfn8kZ/UQxBkUibIgQ47XkLw3jhb74lL4r+BcqtYPw3WOBfHbeNqIEIBf
         s6IqSw0ArC0/JQs86L/9KZN/GBBCHaIjS0o0vp79Pp/Xzj6m1WWRjlc15KM58Sn42Kub
         sEYbu21flVZvQcqwv201GAWI+nbswCy45nSKmKnc95jpoZbmMIxjY+CXNsHHBgrIlQLd
         c/ckr5COEpUhkD1kXWhgB8csewg2A8syj3ZKZkxf125j9zuQ5IndrpJWOtG3gBsn4OJ+
         lfGBNNHIfwijVGk0SAJXQs+sqf0SV8f9QBTQ+SY9XUqQ+MVVSZk26mYtg+zVWrZjmvzP
         JcHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Q9neuIG6NME92B0FTzFk6RBoNBkN6kIQjOv1wlxUZcU=;
        b=oTSbgYD8EUS4yIa9lUZ/nWpozcE15VZvgdA7YgGkZzUvF/CdOoflWNzXGAPoTREYmO
         Axm+Ey65P6J7zAi734pA4+Kv5TDxP+m7FRAgW/EdX1WuFoeV/UzEWSv2pW9JlACYjPEk
         Pn1wRntZFha46GwN2nOtFlPPFM5Y5SMBI3SAQyirhetAl/GF5fNNO6Z+wNjrPICHLiYv
         mGmVxQn4n5RsIulyUIbzJmCxbNC4ZTF1RH38tyc1eDoVmPaLdQAenboav88nuGOkhnt0
         42VUBWuhm2eYeC5TTiU9uIA60Mt1aCR8470zf5v2VvT3pboWaLqrqEOK3M9XX0FRSO0l
         e8jg==
X-Gm-Message-State: AOAM531MaxgdvKODGjWUAboaZ1hl/cN77HKYM6JFakuYJogJS2zRLeCa
        GtI7oUnRaKI6fJ/E+pXcbuY=
X-Google-Smtp-Source: ABdhPJyX7xzlri/QMUL6XIi2P62Xw0xu4IOyk6r8bZQael56Hh4wyTvmQfVBbU4Raq3O/J5FlDmR6w==
X-Received: by 2002:a17:906:9749:b0:6f5:6cd:5bd9 with SMTP id o9-20020a170906974900b006f506cd5bd9mr1522345ejy.523.1651759360471;
        Thu, 05 May 2022 07:02:40 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id h23-20020a1709070b1700b006f3ef214e3fsm769447ejl.165.2022.05.05.07.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 07:02:40 -0700 (PDT)
Message-ID: <6273d900.1c69fb81.fbc61.4680@mx.google.com>
X-Google-Original-Message-ID: <YnPY/m19uOhuIydH@Ansuel-xps.>
Date:   Thu, 5 May 2022 16:02:38 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        John Crispin <john@phrozen.org>, linux-doc@vger.kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH RESEND 0/5] dt-bindings: support Ethernet devices as LED
 triggers
References: <20220505135512.3486-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220505135512.3486-1-zajec5@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 03:55:07PM +0200, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Some LEDs are designed to represent a state of another device. That may
> be USB port, Ethernet interface, CPU, hard drive and more.
> 
> We already have support for LEDs that are designed to indicate USB port
> (e.g. light on when USB device gets connected). There is DT binding for
> that and Linux implementation in USB trigger.
> 
> This patchset adds support for describing LEDs that should react to
> Ethernet interface status. That is commonly used in routers. They often
> have LED to display state and activity of selected physical port. It's
> also common to have multiple LEDs, each reacting to a specific link
> speed.
>

I notice this is specific to ethernet speed... I wonder if we should
expand this also to other thing like duplex state or even rx/tx.

> Patch 5/5 is proof of concept and is not meant to be applied yet.
> 
> Rafał Miłecki (5):
>   dt-bindings: net: add bitfield defines for Ethernet speeds
>   dt-bindings: net: allow Ethernet devices as LED triggers
>   dt-bindings: leds: add Ethernet triggered LEDs to example
>   ARM: dts: BCM5301X: Add triggers for Luxul XWR-1200 network LEDs
>   leds: trigger: netdev: support DT "trigger-sources" property
> 
>  .../devicetree/bindings/leds/common.yaml      | 21 +++++++++++++++
>  .../bindings/net/ethernet-controller.yaml     |  3 +++
>  arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts | 22 +++++++++++----
>  drivers/leds/trigger/ledtrig-netdev.c         | 26 ++++++++++++++++++
>  include/dt-bindings/net/eth.h                 | 27 +++++++++++++++++++
>  5 files changed, 94 insertions(+), 5 deletions(-)
>  create mode 100644 include/dt-bindings/net/eth.h
> 
> -- 
> 2.34.1
> 

-- 
	Ansuel
