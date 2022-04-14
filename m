Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54E1501B7E
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 21:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243117AbiDNTCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 15:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240201AbiDNTCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 15:02:13 -0400
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A17335DD1;
        Thu, 14 Apr 2022 11:59:47 -0700 (PDT)
Received: by mail-ot1-f53.google.com with SMTP id w23-20020a056830111700b00603c6d1ce73so38341otq.9;
        Thu, 14 Apr 2022 11:59:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=pHUh2xfElfPjM6pU2gjEs6VjREPddKoYEwJGkBqvcYE=;
        b=DO9xEE1dpXZLuubX7Tbh9FEKQbcdE61dH8UxxFLS+u1pOemX52edHM1SYV6xHWSn5o
         Y07ZeNcZKwxV+ml2FHWAkoZgSp6qFOxsG9J6upWqGlpHaZVlBt9eTXzNG6Rdqr5qcO8J
         UH0mfEWrk1+485wUsdsseiYBrCyMQAR3FXOkTRgYGfjzaJxwBKG9CzMyfvA2FTf5J5EU
         4xXX33zGqoYSy1UxHICri3wJ9ORsRqkekqGC0A1DGmaKbQcEMToZEBxSw3lmS7PQv7KY
         9i3YxLzMfX2TqS1tuhQT9HFX6K2zxQx4qe9Fi3LKG2eIf1ri7UMsU1ef92loDayWbC/9
         fCvA==
X-Gm-Message-State: AOAM530FtZzIjnznOfoqusi6kwVt+LNDfLfYVsXG8YtbRX7ktX/f/Qe9
        XxcvLoTEGdPhKxEZNI0hSA==
X-Google-Smtp-Source: ABdhPJwxFAMtv8DAm3ujwrIJQGNBj431vuTsaLB8T0RGyUluEn6mJTkhlDsvH5C1eCLdJS3pLptDFQ==
X-Received: by 2002:a05:6830:245e:b0:601:8b3:65e2 with SMTP id x30-20020a056830245e00b0060108b365e2mr1424662otr.255.1649962786597;
        Thu, 14 Apr 2022 11:59:46 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id r8-20020a05683001c800b005cdadc2a837sm308728ota.70.2022.04.14.11.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 11:59:46 -0700 (PDT)
Received: (nullmailer pid 2441851 invoked by uid 1000);
        Thu, 14 Apr 2022 18:59:45 -0000
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?b?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org,
        Herve Codina <herve.codina@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-renesas-soc@vger.kernel.org,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Paolo Abeni <pabeni@redhat.com>,
        =?utf-8?q?Miqu=C3=A8l_Raynal?= <miquel.raynal@bootlin.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>
In-Reply-To: <20220414122250.158113-4-clement.leger@bootlin.com>
References: <20220414122250.158113-1-clement.leger@bootlin.com> <20220414122250.158113-4-clement.leger@bootlin.com>
Subject: Re: [PATCH net-next 03/12] dt-bindings: net: pcs: add bindings for Renesas RZ/N1 MII converter
Date:   Thu, 14 Apr 2022 13:59:45 -0500
Message-Id: <1649962785.207360.2441850.nullmailer@robh.at.kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Apr 2022 14:22:41 +0200, Clément Léger wrote:
> This MII converter can be found on the RZ/N1 processor family. The MII
> converter ports are declared as subnodes which are then referenced by
> users of the PCS driver such as the switch.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  .../bindings/net/pcs/renesas,rzn1-miic.yaml   | 95 +++++++++++++++++++
>  include/dt-bindings/net/pcs-rzn1-miic.h       | 19 ++++
>  2 files changed, 114 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml
>  create mode 100644 include/dt-bindings/net/pcs-rzn1-miic.h
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml:18:7: [warning] wrong indentation: expected 4 but found 6 (indentation)
./Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml:95:7: [error] no new line character at the end of file (new-line-at-end-of-file)

dtschema/dtc warnings/errors:

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

