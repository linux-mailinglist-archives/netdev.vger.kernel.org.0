Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9092C699E56
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 21:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjBPUyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 15:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjBPUy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 15:54:29 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C64505D7;
        Thu, 16 Feb 2023 12:54:28 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id m10so3058499wrn.4;
        Thu, 16 Feb 2023 12:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=XxHXAnEzcfwmzL57yBeDEI2OXJgv4sM92NV8AEEiDjk=;
        b=IyXielZJHYrNZdwUKZ/VHSjiRRKC/fjAWKB6XxREQUlMeGCRBy5MFzAGkBPKtYuX4z
         msWn2erMVQDpu8k7efDx+nvXtSeWNs31J9hz/wEg2PaPxLq7OR55qY/q/YrNJOwefAZS
         dSYlPVT7UlhosbScdEHNsDbT/vgPIxzsYh3RHF9qb0wZEOoMwe4jEGldfVHfsXzlipXB
         pHKvx/izp8RyWFctgV4zplDi9ggX4ajBM3dpn2fUPYBbCJcl4kiOEAjtyS6blk1CWixb
         voq8WTudsJtj8Wpif+Z8gjXgdM7gnXwodJ57wPcwEt1MP5VtwLyMDcUwDV0VR7RVEoE5
         rxrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XxHXAnEzcfwmzL57yBeDEI2OXJgv4sM92NV8AEEiDjk=;
        b=F4pOc7lBRkKpfcBSQQfjt+lBPSTLGR/5RQW8DzBRiPwd4K0IxJKrbj/qeTpjLxJvbM
         /e8MsTZDANNOv4I8qNWEnlrH2UMwC8g6uLWXc7zh+jg/Y0e6T1la5gSd/hvivMJEt/Pr
         JIaofMGc9R1qGDIXVKgCZmAAbrAgkMktG69/41ncNbrC6PVc9Wnd2sEj8DLfjJboOVwN
         8HSyD9RRIx4y8LTuVspJd/Z3kBdsGKJk1JwcwxpxyFlNHOjui2rlIPyFXud+w0VjS0ew
         sGOuxSV4tNEx36z9Pk/YMjNjJM0Pxn25tDN5uYEb5FB2FxcVHozSX1bTY8rpHSJSPtKD
         FCrA==
X-Gm-Message-State: AO0yUKV4g/82pYyIPAD1LKd2BAc9tlgH06umCkYavKxDvD0E+qxj9QnR
        KxQM/8jLQudamiod7fHAgGzMMMjYIN8=
X-Google-Smtp-Source: AK7set/m5y8QLJ2rVEPQuLfvuJfCZb7LXLMd5x6BkDXzGrf7EnTAlb0ezjgXsvVzFHXmWfzhzcXAjA==
X-Received: by 2002:adf:f3cf:0:b0:2c5:8575:c37 with SMTP id g15-20020adff3cf000000b002c585750c37mr2323400wrp.66.1676580866381;
        Thu, 16 Feb 2023 12:54:26 -0800 (PST)
Received: from Ansuel-xps. (93-34-91-73.ip49.fastwebnet.it. [93.34.91.73])
        by smtp.gmail.com with ESMTPSA id w13-20020adfcd0d000000b002c54f39d34csm2368271wrm.111.2023.02.16.12.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 12:54:25 -0800 (PST)
Message-ID: <63ee9801.df0a0220.a106.72a3@mx.google.com>
X-Google-Original-Message-ID: <Y+3+0e1fVOF0m329@Ansuel-xps.>
Date:   Thu, 16 Feb 2023 11:00:49 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Lee Jones <lee@kernel.org>, linux-leds@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org, John Crispin <john@phrozen.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, Arun.Ramadoss@microchip.com
Subject: Re: [PATCH v8 12/13] dt-bindings: net: phy: Document support for
 leds node
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
 <20230216013230.22978-13-ansuelsmth@gmail.com>
 <167651373836.1183034.17900591036429665419.robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167651373836.1183034.17900591036429665419.robh@kernel.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 08:32:11PM -0600, Rob Herring wrote:
> 
> On Thu, 16 Feb 2023 02:32:29 +0100, Christian Marangi wrote:
> > Document support for leds node in phy and add an example for it.
> > Phy led will have to match led-phy pattern and should be treated as a
> > generic led.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  .../devicetree/bindings/net/ethernet-phy.yaml | 22 +++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> > 
> 
> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
> 
> yamllint warnings/errors:
> 
> dtschema/dtc warnings/errors:
> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/ethernet-phy.example.dtb: ethernet-phy@0: leds:led-phy@0:linux,default-trigger: 'oneOf' conditional failed, one must be fixed:
> 	'netdev' is not one of ['backlight', 'default-on', 'heartbeat', 'disk-activity', 'ide-disk', 'timer', 'pattern']
> 	'netdev' does not match '^mmc[0-9]+$'
> 	'netdev' does not match '^cpu[0-9]*$'
> 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> 

Hi, I could be wrong but this should be fixed by the previous patch that
adds netdev to the trigger list.

> doc reference errors (make refcheckdocs):
> 
> See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230216013230.22978-13-ansuelsmth@gmail.com
> 
> The base for the series is generally the latest rc1. A different dependency
> should be noted in *this* patch.
> 
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
> 
> pip3 install dtschema --upgrade
> 
> Please check and re-submit after running the above command yourself. Note
> that DT_SCHEMA_FILES can be set to your schema file to speed up checking
> your schema. However, it must be unset to test all examples with your schema.
> 

-- 
	Ansuel
