Return-Path: <netdev+bounces-4820-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A80A70E900
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 00:18:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3ABEC2810C5
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 22:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EB48D513;
	Tue, 23 May 2023 22:18:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D09BA55
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 22:18:23 +0000 (UTC)
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEF1CA;
	Tue, 23 May 2023 15:18:19 -0700 (PDT)
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-6af81142b6dso123424a34.2;
        Tue, 23 May 2023 15:18:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684880299; x=1687472299;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0/95G6TtWDMqnJqi09q4BRdDKrrrr1cl8z6kSG/6bRA=;
        b=iyfRk4+jac99E2ssWFn52x2OBo4w2YytZkiwRSJ9EzfYkSsWyGi9+WX5b5WCq4P2Zo
         UG0CYbxEIx4QtFJVvXqI1/pltOsBOtahzGRdVcPlvMIq3CrzVoHuI0gUJErXK61pgqIt
         if8n6hHi3w7DwRGk8ZURnYT+P5m5qUqRT618Z+kxMxh8DPxxw1JVAPIFBEExfPxDUEwo
         yO7UKyNBv221wESeWJk8uN7CyloCu/UedFCqmiDJD8vTevIR2O15RFPKNBpdnGGYNere
         kM+60TdCH+EUMDEJ6uDsWh7ucxwVRW27fSEI/58C99gx63bss+aEtHQzpZTlDlOV3baZ
         oTYg==
X-Gm-Message-State: AC+VfDxWV/Mj8ccTREtkt5PXGVTrZInEooYmYBLV6o2OVQAYHPjfgdeS
	Qk8M/+AsrelfQzZhvqYWvw==
X-Google-Smtp-Source: ACHHUZ4QOOvthD3w2RdBiE5VTT3ti9m94NuJVi4/VOv1vNaUnI/8iObgUbyNTlHl5zM/LlxIgDjLdA==
X-Received: by 2002:a05:6830:1d66:b0:6a5:ea63:b9e6 with SMTP id l6-20020a0568301d6600b006a5ea63b9e6mr7643237oti.16.1684880298905;
        Tue, 23 May 2023 15:18:18 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id v26-20020a05683018da00b006a5db4474c8sm3909647ote.33.2023.05.23.15.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 15:18:18 -0700 (PDT)
Received: (nullmailer pid 2003240 invoked by uid 1000);
	Tue, 23 May 2023 22:18:17 -0000
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Rob Herring <robh@kernel.org>
To: Justin Chen <justin.chen@broadcom.com>
Cc: kuba@kernel.org, hkallweit1@gmail.com, davem@davemloft.net, sumit.semwal@linaro.org, netdev@vger.kernel.org, linux@armlinux.org.uk, bcm-kernel-feedback-list@broadcom.com, christian.koenig@amd.com, opendmb@gmail.com, robh+dt@kernel.org, conor@kernel.org, justinpopo6@gmail.com, richardcochran@gmail.com, Florian Fainelli <florian.fainelli@broadcom.com>, f.fainelli@gmail.com, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, krzysztof.kozlowski+dt@linaro.org, edumazet@google.com, andrew@lunn.ch, simon.horman@corigine.com, devicetree@vger.kernel.org, pabeni@redhat.com
In-Reply-To: <1684878827-40672-3-git-send-email-justin.chen@broadcom.com>
References: <1684878827-40672-1-git-send-email-justin.chen@broadcom.com>
 <1684878827-40672-3-git-send-email-justin.chen@broadcom.com>
Message-Id: <168488029701.2003121.3742030688630968396.robh@kernel.org>
Subject: Re: [PATCH net-next v4 2/6] dt-bindings: net: Brcm ASP 2.0
 Ethernet controller
Date: Tue, 23 May 2023 17:18:17 -0500
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
	FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
	RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On Tue, 23 May 2023 14:53:43 -0700, Justin Chen wrote:
> From: Florian Fainelli <florian.fainelli@broadcom.com>
> 
> Add a binding document for the Broadcom ASP 2.0 Ethernet
> controller.
> 
> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
> Signed-off-by: Justin Chen <justin.chen@broadcom.com>
> ---
> v3
> 	- Adjust compatible string example to reference SoC and HW ver
> 
> v3
>         - Minor formatting issues
>         - Change channel prop to brcm,channel for vendor specific format
>         - Removed redundant v2.0 from compat string
>         - Fix ranges field
> 
> v2
>         - Minor formatting issues
> 
>  .../devicetree/bindings/net/brcm,asp-v2.0.yaml     | 145 +++++++++++++++++++++
>  1 file changed, 145 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/brcm,asp-v2.0.example.dtb: ethernet@9c00000: compatible: ['brcm,bcm72165-asp', 'brcm,asp-v2.0'] is too long
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/1684878827-40672-3-git-send-email-justin.chen@broadcom.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.


