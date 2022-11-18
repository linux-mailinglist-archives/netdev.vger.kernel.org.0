Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A5762EC8C
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 04:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240660AbiKRD4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 22:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbiKRD4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 22:56:15 -0500
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F91F769DF;
        Thu, 17 Nov 2022 19:56:14 -0800 (PST)
Received: by mail-ot1-f53.google.com with SMTP id a13-20020a9d6e8d000000b00668d65fc44fso2372382otr.9;
        Thu, 17 Nov 2022 19:56:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UDtkEcqJzRTlxRyWyaNAn8GW0a2TWAtw/oLy5nd7MPY=;
        b=h9323HtHugQs0pRnsjLGIEuTVqzGjcyU7d+t9cqIRv8s5rqFk2XOWkd/67v2kt/B32
         zEU2anhupPj0SPgvC2SX4KkD8CoCne9aejAn8NX3dLhvrcPMjQh+ZN/xsMiRkpUTfS+C
         QKLrBW8081hBJ5cBvdamUnurGTdkx5Fym0QkU4oXPUSuC5Ec9CrPXRm49jRDUCcAJ58O
         MpGBi1h+5DhrGm+IIB0aZVDgMRc9V+DiRrutmQyQ4S0NVM7qWA+fZvUJkUP6j/rSR14I
         2I4+i4YvDLr94Rvp7HqaYibhAXaqvigzL7qcLJilMWt5HH0M7vyWQfw33u+DTLDJDgVU
         UJPg==
X-Gm-Message-State: ANoB5pmUbv6wKsBTxRYBgRwanOOqqQ6erevYeiAj4YRv3EZh6rzAf2Zk
        +p1UO895Z4hVIb16stdT+WQa2DJRaw==
X-Google-Smtp-Source: AA0mqf4K0OJhLHjSGO9nbwPqE6UHdxRHKO1nslXWP9nd6zrfrLKem9/vCQ31DFM8mojDprSrx8p/lg==
X-Received: by 2002:a05:6830:cd:b0:66c:75f9:29fa with SMTP id x13-20020a05683000cd00b0066c75f929famr3015262oto.221.1668743773464;
        Thu, 17 Nov 2022 19:56:13 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id j2-20020a4ad182000000b0049f3f5afcbasm1027043oor.13.2022.11.17.19.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 19:56:12 -0800 (PST)
Received: (nullmailer pid 397828 invoked by uid 1000);
        Fri, 18 Nov 2022 03:56:14 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
In-Reply-To: <20221118001548.635752-2-tharvey@gateworks.com>
References: <20221118001548.635752-1-tharvey@gateworks.com>
 <20221118001548.635752-2-tharvey@gateworks.com>
Message-Id: <166874355648.392544.11627332745396006042.robh@kernel.org>
Subject: Re: [PATCH 1/3] dt-bindings: net: phy: dp83867: add LED mode property
Date:   Thu, 17 Nov 2022 21:56:14 -0600
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, 17 Nov 2022 16:15:46 -0800, Tim Harvey wrote:
> Add description for new property ti,led-modes in binding file.
> 
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> ---
>  .../devicetree/bindings/net/ti,dp83867.yaml      |  6 ++++++
>  include/dt-bindings/net/ti-dp83867.h             | 16 ++++++++++++++++
>  2 files changed, 22 insertions(+)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
./Documentation/devicetree/bindings/net/ti,dp83867.yaml: Unable to find schema file matching $id: http://devicetree.org/schemas/net/schemas/types.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20221118001548.635752-2-tharvey@gateworks.com

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command.

