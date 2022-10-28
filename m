Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81535611116
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 14:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiJ1MUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 08:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiJ1MUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 08:20:13 -0400
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F850317CC;
        Fri, 28 Oct 2022 05:20:08 -0700 (PDT)
Received: by mail-oi1-f179.google.com with SMTP id o64so5909009oib.12;
        Fri, 28 Oct 2022 05:20:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4dmFRfHeOegE5+bpQefgHIJnNQwHhQbV7Ukrk2pAq+A=;
        b=JMfGkiBCyKiFTCuBHGxICUrQbfZYrTBbcV4ZAPIjhqPogXkofdEE+6c0gi8cHG3cY0
         Snl7EFX9REIb0dXcSkfXRLAhNem6FFZnF5KPdE8HJ6RUD1ZlngRt2iYok2ohaNXRJUco
         +zVs211Qvlu2q2cKd4c6oq6PWh2wJ2fxOgKHBFXdtNJefeZumE8JSMWXahyX1N9M0T8h
         EoMAiSLPbjFjhktqA0hBdYe5ZV4FTnwQU3O5Emh8FP4cFN45CNx6p11iXCTuAx3CWqId
         CZwAbT59F+itLQmwq5Nwv5f2BLG9OlX8BRwA8UMn+hlJCEz6b4qz5Xc1CgtUWuQRZaal
         As+g==
X-Gm-Message-State: ACrzQf0Mfz45GBkajlmbj4uDuTCTQLgpgcdKkX3WtdAcTnllq2EvbYAI
        BZNQzM9AWV/QadxBGGKNgw==
X-Google-Smtp-Source: AMsMyM6cKt0KcpbmIifbatyxqCPEd6Pz5r7yvNlhqxNm415ojTZlVQjyH5r0iSI57y48fTiJvgzy0w==
X-Received: by 2002:aca:f102:0:b0:359:a7d8:3748 with SMTP id p2-20020acaf102000000b00359a7d83748mr7469355oih.164.1666959608160;
        Fri, 28 Oct 2022 05:20:08 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id s19-20020a056870e6d300b0011f400edb17sm1983410oak.4.2022.10.28.05.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 05:20:07 -0700 (PDT)
Received: (nullmailer pid 1079535 invoked by uid 1000);
        Fri, 28 Oct 2022 12:20:05 -0000
From:   Rob Herring <robh@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Robert Marko <robert.marko@sartura.hr>,
        Michael Walle <michael@walle.cc>, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        linux-kernel@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Eric Dumazet <edumazet@google.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        netdev@vger.kernel.org
In-Reply-To: <20221028092337.822840-3-miquel.raynal@bootlin.com>
References: <20221028092337.822840-1-miquel.raynal@bootlin.com> <20221028092337.822840-3-miquel.raynal@bootlin.com>
Message-Id: <166695949292.1076993.16137208250373047416.robh@kernel.org>
Subject: Re: [PATCH 2/5] dt-bindings: nvmem: add YAML schema for the ONIE tlv layout
Date:   Fri, 28 Oct 2022 07:20:05 -0500
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Oct 2022 11:23:34 +0200, Miquel Raynal wrote:
> Add a schema for the ONIE tlv NVMEM layout that can be found on any ONIE
> compatible networking device.
> 
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  .../nvmem/layouts/onie,tlv-layout.yaml        | 96 +++++++++++++++++++
>  1 file changed, 96 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/nvmem/layouts/onie,tlv-layout.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Documentation/devicetree/bindings/nvmem/layouts/onie,tlv-layout.example.dtb:0:0: /example-0/onie: failed to match any schema with compatible: ['onie,tlv-layout', 'vendor,device']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

