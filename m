Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547A060D534
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 22:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiJYUFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 16:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbiJYUFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 16:05:08 -0400
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7133F1E725;
        Tue, 25 Oct 2022 13:05:06 -0700 (PDT)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-13bef14ea06so3359743fac.3;
        Tue, 25 Oct 2022 13:05:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eCcoXzqCOTLs/OXhRR73dWp6fEmoY2vqrJfVEZfm4bk=;
        b=JPdyLs0Ez8tEhDJoEG3HnBWZQYfhLSmnk1iQMhutWdtTF/xyM12x1pAWiVHVQHrrM/
         7DAohWN6Bx4i3TO0Z+Sisw5auKSa9erlgMoZO7Uf1qj9BD96GVbTV9fYRI8O/D2l13SE
         FkM8M60R8NJV0NuEQHJA1rv6AJBsqQ6PRfqi9jv3xQoQiPBEVtPtU8Hslv+xIyfpQl/S
         6ktNDIKy08+jxtkpiM9sfpgfSWf6RjDD1PeOr7U6H/gledzbcZ0xdL2/ogLUNS0U6w10
         PrsNwKmVW4uDlpQPLAZxY07+xEmWC5YPWlbxKVY9DNc8OxD2Cj1G9gDbcWqOiTAKjmGK
         ZvoQ==
X-Gm-Message-State: ACrzQf1AwNMv74tK6BOdfj1Ymo0YydfwNqKi5QAeKiwZrRTrbfMWFY7r
        Yo28D2dLDJueoZ1J6Mm1Mw==
X-Google-Smtp-Source: AMsMyM6mcgNjxW6i/qnU+iYP+pBcCoyzMgXv5PdueWJlslCfweAIm0U9+f++poSxkgEwaRpzT1rZlQ==
X-Received: by 2002:a05:6870:d107:b0:137:11e5:6a95 with SMTP id e7-20020a056870d10700b0013711e56a95mr15898oac.146.1666728305645;
        Tue, 25 Oct 2022 13:05:05 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id y16-20020a056871011000b0010e73e252b8sm2095073oab.6.2022.10.25.13.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 13:05:05 -0700 (PDT)
Received: (nullmailer pid 3155080 invoked by uid 1000);
        Tue, 25 Oct 2022 20:05:02 -0000
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Lee Jones <lee@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Landen Chao <Landen.Chao@mediatek.com>,
        John Crispin <john@phrozen.org>,
        DENG Qingfang <dqfext@gmail.com>,
        linux-mediatek@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        =?utf-8?b?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20221025050355.3979380-8-colin.foster@in-advantage.com>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com> <20221025050355.3979380-8-colin.foster@in-advantage.com>
Message-Id: <166672723302.3138577.18331816371776997839.robh@kernel.org>
Subject: Re: [PATCH v1 net-next 7/7] dt-bindings: net: mscc,vsc7514-switch: utilize generic ethernet-switch.yaml
Date:   Tue, 25 Oct 2022 15:05:02 -0500
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Oct 2022 22:03:55 -0700, Colin Foster wrote:
> Several bindings for ethernet switches are available for non-dsa switches
> by way of ethernet-switch.yaml. Remove these duplicate entries and utilize
> the common bindings for the VSC7514.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  .../bindings/net/mscc,vsc7514-switch.yaml     | 36 +------------------
>  1 file changed, 1 insertion(+), 35 deletions(-)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
./Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml: Unable to find schema file matching $id: http://devicetree.org/schemas/net/ethernet-switch.yaml
Documentation/devicetree/bindings/net/mscc,vsc7514-switch.example.dtb:0:0: /example-0/switch@1010000: failed to match any schema with compatible: ['mscc,vsc7514-switch']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

