Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E11F6AFA4B
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 00:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjCGX1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 18:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCGX1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 18:27:22 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCC1A76A8;
        Tue,  7 Mar 2023 15:27:20 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id g3so13741735wri.6;
        Tue, 07 Mar 2023 15:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678231639;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=K+UgCiSf5tvja4WISBu0Ta5QgChkgCAANPe7dzhw5bU=;
        b=kCz/N25pmJ5A1YBfpdlM80BJCQzCzFxI0ec1N42sO+yTjzBKAqeeB7rE4DYtnxUsH0
         zvxkZTIjnHn4xAr6fcAIZTGcjEg9iNtZBGWy1KXzFwbz4PjUrp3zqEIcmnvklKRh4/K+
         u4slt4gkAaZfZreX90uPnd+olGHNicQGHnovFqDAJqczafcCI76oPZfT+nfGHElCr2Vn
         VkNchbe1LdS1ZIwgTxVTYWQ49wFVlMM01VOtU6YY0loOKa6GIT/ycJo9mCzb80Ej2GHe
         gFdkvhW0d2w9WitjC3HtdU+UIyvriL0m6v3mDcEKzyA+imw7WFMi5+ZCvwGm0copO78o
         aWGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678231639;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K+UgCiSf5tvja4WISBu0Ta5QgChkgCAANPe7dzhw5bU=;
        b=u9MHdk9QSYMD+6X0SYRQ7LKby/tcCkSinLb6jce29XRqeVhLswkIypQ/Zmitm66jJl
         ZcWuqgPB8KTI79OJpITFTdcD9yWCBrGlYHtsZp/FRY99paIMYlDqwgcDS8lXzWebOJUx
         67oNdFnA0Vh/Q/lugrOZ6dyRvb5QHkxxDGodYd5LxtGZ4GDIVoiVz4YMEphOiRFK7yy0
         wSQtjrz9Rbx3kG8qK2q3zjB/uqIutvMtY99X6YfU7B2oc7WkgE247iRzUbHUsmz+5+lh
         D0EKjtDxtc/a4tKW0C1U2skbEbCnVD2rh8MLfBbfU0VRG9uJlREwQJwW6r9x21ZLUJGC
         9CDA==
X-Gm-Message-State: AO0yUKVqJPxhFw8zUzQZtQ9JtR1ivOEWTAFIvZYir/BiF3E0vn9wioN3
        Z0k0wncxtrLrbFeu/Rqh7R0=
X-Google-Smtp-Source: AK7set9aVNolSfZ5B7wY+yU2TBtltPuGvaaQxhNm58gbkUNfVSUWQzncSkD6DTmMoniaMFroX1++Pw==
X-Received: by 2002:adf:e9d0:0:b0:2c9:12dc:260 with SMTP id l16-20020adfe9d0000000b002c912dc0260mr9447826wrn.33.1678231639172;
        Tue, 07 Mar 2023 15:27:19 -0800 (PST)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id e5-20020a5d5945000000b002c3f9404c45sm13575585wri.7.2023.03.07.15.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 15:27:18 -0800 (PST)
Message-ID: <6407c856.5d0a0220.af5c8.50f9@mx.google.com>
X-Google-Original-Message-ID: <ZAd8geYgWGbGfmQo@Ansuel-xps.>
Date:   Tue, 7 Mar 2023 19:03:45 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
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
Subject: Re: [net-next PATCH 11/11] arm: mvebu: dt: Add PHY LED support for
 370-rd WAN port
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
 <20230307170046.28917-12-ansuelsmth@gmail.com>
 <70a38eb2-7ade-4474-8e1a-f18e99d45977@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70a38eb2-7ade-4474-8e1a-f18e99d45977@lunn.ch>
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 12:20:17AM +0100, Andrew Lunn wrote:
> On Tue, Mar 07, 2023 at 06:00:46PM +0100, Christian Marangi wrote:
> > From: Andrew Lunn <andrew@lunn.ch>
> > 
> > The WAN port of the 370-RD has a Marvell PHY, with one LED on
> > the front panel. List this LED in the device tree.
> > 
> > Set the LED default state to "keep" to not change any blink rule
> > set by default.
> 
> Hi Christian
> 
> What board are you using for testing? It would be good to patch its
> .dts file to enable its LEDs. We don't normally had new code without a
> user.
> 

ipq806x, my specific device is not present upstream but we have a rb3011
that currently use the qca8k dsa switch upstream.
If needed I can add support there by checking the leds supported...

Also looking at the dt I think I need to use "port - 1" after all since
it does use legacy way... Sad me...

-- 
	Ansuel
