Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F30698A8B
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 03:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjBPCcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 21:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBPCcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 21:32:14 -0500
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF4636472;
        Wed, 15 Feb 2023 18:32:13 -0800 (PST)
Received: by mail-oi1-f172.google.com with SMTP id bj22so416395oib.11;
        Wed, 15 Feb 2023 18:32:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KOuLr4scIF1NfqJ8T0M99xrYHbB7KQ22DgnSgEZbsMk=;
        b=c4PkKwkHgI//2uC5MFjnlmtuMa7Y2BImiCAfOfbklBahuvHPM72G7NpUMN80YI2gqV
         CayArmTfDAUadfY/x/ASQFrnjZWwt3sUhJOcUllJVTmpVrJ/k+EgXV0e0PN8mtS/jeXu
         uZAowfhOy3Dn7Gvu27YDt5+4glkS3gXzSulmDPIDQnYRY/ClJhrWaMQW/9Fve1+ai8cE
         QCs1Mw9n7kIwF89KIdjySd4GE6cvedl0j05yaMynt4HAqzTue3/Qsm9l8W+hhPGWMaCE
         VEDXseR3Ovi2n65+7roMXXjCPd43FGNJA45KTPOjY81KTDZP7z6CDGMJB2K7QmMhk0IB
         ou5A==
X-Gm-Message-State: AO0yUKULKz/xQw+1Sj5+uALtfWxDbq8YSWKK7LkAdSeYDUoXAXt41pHJ
        dwYjomT4hIMBECI8eE7ZOg==
X-Google-Smtp-Source: AK7set/YKv86MiKqaVAX4xz6xbPDlGpjyc03s+rvbI5f7CRlAlu6x8dJZTXBA89nFKc+/LzMvuW88A==
X-Received: by 2002:aca:2213:0:b0:35a:d192:9a53 with SMTP id b19-20020aca2213000000b0035ad1929a53mr1864308oic.41.1676514732936;
        Wed, 15 Feb 2023 18:32:12 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id f9-20020a05680814c900b0037d59e90a07sm48171oiw.55.2023.02.15.18.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 18:32:12 -0800 (PST)
Received: (nullmailer pid 1200075 invoked by uid 1000);
        Thu, 16 Feb 2023 02:32:11 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
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
In-Reply-To: <20230216013230.22978-13-ansuelsmth@gmail.com>
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
 <20230216013230.22978-13-ansuelsmth@gmail.com>
Message-Id: <167651373836.1183034.17900591036429665419.robh@kernel.org>
Subject: Re: [PATCH v8 12/13] dt-bindings: net: phy: Document support for
 leds node
Date:   Wed, 15 Feb 2023 20:32:11 -0600
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, 16 Feb 2023 02:32:29 +0100, Christian Marangi wrote:
> Document support for leds node in phy and add an example for it.
> Phy led will have to match led-phy pattern and should be treated as a
> generic led.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  .../devicetree/bindings/net/ethernet-phy.yaml | 22 +++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/ethernet-phy.example.dtb: ethernet-phy@0: leds:led-phy@0:linux,default-trigger: 'oneOf' conditional failed, one must be fixed:
	'netdev' is not one of ['backlight', 'default-on', 'heartbeat', 'disk-activity', 'ide-disk', 'timer', 'pattern']
	'netdev' does not match '^mmc[0-9]+$'
	'netdev' does not match '^cpu[0-9]*$'
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/ethernet-phy.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230216013230.22978-13-ansuelsmth@gmail.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

