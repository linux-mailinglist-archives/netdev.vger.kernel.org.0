Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A6769B626
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 00:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjBQXF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 18:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjBQXF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 18:05:56 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4A753EF3;
        Fri, 17 Feb 2023 15:05:49 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id f19so2083120wml.3;
        Fri, 17 Feb 2023 15:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=iVfVFdTeB2G3+/DvdyG5XCOtX+6GFkOVr0x9Cn2QTxo=;
        b=Ig7F6MDvxzH2xO4k4V5CyCuAP+VEIWRZnElFSl3gDmgkZXzDs0a9yfd/jXD80CuCnf
         s14ylBa5jeejT3JSppnZW2zljtI51xTkCg2gRZHP/dd+7hvdnc4L2cmTVRaX+sfiE2Wf
         FamRFPY6zNQY0FxFeO5m/XgHn33HEBfeJI6q3nRoEtTEMAYgltFmzoWX3bOfx5He/BSV
         q9HSbWlcajc1cZGzMSZLxlBUIg01c4uQHTMnwQuR6qNkAqOfI22Vu7D7ii0KK+BSn7c4
         6x3pSoxDBCfVBCZnhL9+9WRSnKKCOSJTRh46EGuiuhId11P/ypX2v+wrrYTzXPpLpRY1
         r7RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iVfVFdTeB2G3+/DvdyG5XCOtX+6GFkOVr0x9Cn2QTxo=;
        b=41LfT0BNsOfpkXHF8gIBTdC16yh9oKN/EKnZagi7CLTzA45AlYu0Moe8d1TSQsP4ow
         GIfroUEtpmpE1SQszGO2NakvZZsMSuJseF21wZKfFyrglGk4lHMDeGUlmrMFoVRe2e6+
         X8OUN72p8JDFLOeu+8kHmC9HEtYU1ZYDhhyJCbsgXHEhOQRKParrlIvz8lW2iXT7Itqq
         /F0jAqm5pl7rOBwW3h0HmwqxGjsI15vswm5HJb/WuVyeSbAADzyA4P6epDBObvJffkpD
         xe2GzTENppz9+EkHQtk3qGOhbBjpOOrprcwcLk1a74YiQCU9iLMxPo7G9yF9cuvUOH5G
         r7WQ==
X-Gm-Message-State: AO0yUKXcxy5rtF6/PU+as7tdgpVk71AmC65ECkA3u1BpFZhWYe+t0Ahk
        w/WQwGpPZ+QnSDdi8YZU04O4b5qGo/M=
X-Google-Smtp-Source: AK7set8BQ4qFWRGud1mnA7eMLLnciVgGPOUjg93Es34dRLtOBPjQ/tZzPiJ1IoxUodF9lEeqKDJTlA==
X-Received: by 2002:a05:600c:a29e:b0:3d2:3be4:2d9a with SMTP id hu30-20020a05600ca29e00b003d23be42d9amr1466478wmb.20.1676675146706;
        Fri, 17 Feb 2023 15:05:46 -0800 (PST)
Received: from Ansuel-xps. (93-34-91-73.ip49.fastwebnet.it. [93.34.91.73])
        by smtp.gmail.com with ESMTPSA id d8-20020adfe2c8000000b002c3ea5ebc73sm5325065wrj.101.2023.02.17.15.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 15:05:46 -0800 (PST)
Message-ID: <63f0084a.df0a0220.6220b.fb5a@mx.google.com>
X-Google-Original-Message-ID: <Y+8Xj50FwrXOsBKi@Ansuel-xps.>
Date:   Fri, 17 Feb 2023 06:58:39 +0100
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
        Jonathan Corbet <corbet@lwn.net>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH v8 11/13] dt-bindings: leds: Document netdev trigger
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
 <20230216013230.22978-12-ansuelsmth@gmail.com>
 <20230217230346.GA2217008-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217230346.GA2217008-robh@kernel.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 05:03:46PM -0600, Rob Herring wrote:
> On Thu, Feb 16, 2023 at 02:32:28AM +0100, Christian Marangi wrote:
> > Document the netdev trigger that makes the LED blink or turn on based on
> > switch/phy events or an attached network interface.
> 
> NAK. What is netdev?

But netdev is a trigger, nothing new. Actually it was never documented.
Is the linux,default-trigger getting deprecated? 

> 
> Don't add new linux,default-trigger entries either. We have better ways 
> to define trigger sources, namely 'trigger-sources'.
> 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  Documentation/devicetree/bindings/leds/common.yaml | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/leds/common.yaml b/Documentation/devicetree/bindings/leds/common.yaml
> > index d34bb58c0037..6e016415a4d8 100644
> > --- a/Documentation/devicetree/bindings/leds/common.yaml
> > +++ b/Documentation/devicetree/bindings/leds/common.yaml
> > @@ -98,6 +98,8 @@ properties:
> >              # LED alters the brightness for the specified duration with one software
> >              # timer (requires "led-pattern" property)
> >            - pattern
> > +            # LED blink and turns on based on netdev events
> > +          - netdev
> >        - pattern: "^cpu[0-9]*$"
> >        - pattern: "^hci[0-9]+-power$"
> >          # LED is triggered by Bluetooth activity
> > -- 
> > 2.38.1
> > 

-- 
	Ansuel
