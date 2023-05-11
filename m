Return-Path: <netdev+bounces-1912-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4E696FF813
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 19:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D28111C20FD1
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3ABA6AD9;
	Thu, 11 May 2023 17:06:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C975D206A2
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 17:06:54 +0000 (UTC)
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912656A4B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:06:52 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-50bc570b4a3so16092979a12.1
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683824811; x=1686416811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ayyCxGH0foji5L7wUxPjLMBEgCkH5OqBptH4GPUcYDk=;
        b=yQ5Tj7C1ussm/VcwYYhA4Rs12QyIk3aRNikd5NJbYP25dBwJSb4EYVtQhvG8pWTpBH
         T4xirmZIQF6GvaHKEl3CnI6q6yxNmmyJArTKL536EiBHClq2oE9DdnPzvaffsw88f9oQ
         apVjOK+XLIqdMlsPQ8AdpHxkyZxSaQC/q0SOczMoE8nzExFNLJ332OEuk36w9nU25Fis
         oh0U8+Izz6csTiIism28LBA5UWnvkp18HoOaJxdNL8kEEwUAGENOJfeL5tJh4/YhsP50
         d5HhjkKL4Sys9jLGxfFXLt3eWF2KgIXzWpKN5Ix/Hw9lC0yvnEOfcW4a0SMfn/YEA+90
         zksA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683824811; x=1686416811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ayyCxGH0foji5L7wUxPjLMBEgCkH5OqBptH4GPUcYDk=;
        b=d3AfG9x8JRYGyWNCMHVG9TI8cZve/npmIrvsT9LOr3+y78s55k5KjAL/0necL65hdL
         /yxI+MBFoVttotlA00qHSMx6mHol2yGHgvZ2vBQoA9GQpla+DVITNsxJSx0sJXyYaLSO
         oLAFhi8dLovmR8ZuUR9u1/RuD+moc2she8UBVTzLdlcVhJy4yRAeqmUz1rv31iizURWa
         cKgds5fnYCMTABeTIghECoQknoL9fGBaHA9agGvmkSX3Rkn4JBKMRhUx3BLCJd/Zq0KR
         y8SqRIy3umg//frBWwhuQXiLP6FjXp5unY42jAFkDtYdSaG5lwTW3Pb4feiC7i3uf0lc
         lI6w==
X-Gm-Message-State: AC+VfDwBawhmMt25nME3rpVbdb999wzjEiOpbMgOkPY084vKEVZa5FRk
	8DfugkOQYJ72XvdAPcrWKyrABX5j8wzITQ7dpGVGJQ==
X-Google-Smtp-Source: ACHHUZ4kcUwO/YhdtrTa+xFa/aeEXoGMeFo5bs2na974KrFHqO2vD2Z8Q1dUjxA1QOC5UsUxODF7gw==
X-Received: by 2002:a17:906:6a1b:b0:968:2b4a:aba3 with SMTP id qw27-20020a1709066a1b00b009682b4aaba3mr14233722ejc.5.1683824810998;
        Thu, 11 May 2023 10:06:50 -0700 (PDT)
Received: from krzk-bin ([2a02:810d:15c0:828:d7cd:1be6:f89d:7218])
        by smtp.gmail.com with ESMTPSA id jl21-20020a17090775d500b00965b5540ad7sm4331348ejc.17.2023.05.11.10.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 10:06:50 -0700 (PDT)
Date: Thu, 11 May 2023 19:06:47 +0200
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Eric Dumazet <edumazet@google.com>,
	SkyLake Huang <SkyLake.Huang@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-arm-kernel@lists.infradead.org,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	linux-mediatek@lists.infradead.org,
	Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>, devicetree@vger.kernel.org,
	Rob Herring <robh+dt@kernel.org>, Qingfang Deng <dqfext@gmail.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v4 1/2] dt-bindings: arm: mediatek: add
 mediatek,boottrap binding
Message-ID: <20230511170647.g6c3ezlyqqislzaf@krzk-bin>
References: <cover.1683813687.git.daniel@makrotopia.org>
 <f2d447d8b836cf9584762465a784185e8fcf651f.1683813687.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f2d447d8b836cf9584762465a784185e8fcf651f.1683813687.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 11 May 2023 16:10:20 +0200, Daniel Golle wrote:
> The boottrap is used to read implementation details from the SoC, such
> as the polarity of LED pins. Add bindings for it as we are going to use
> it for the LEDs connected to MediaTek built-in 1GE PHYs.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  .../arm/mediatek/mediatek,boottrap.yaml       | 37 +++++++++++++++++++
>  1 file changed, 37 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,boottrap.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/arm/mediatek/mediatek,boottrap.example.dtb: boottrap@1001f6f0: $nodename:0: 'boottrap' was expected
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/arm/mediatek/mediatek,boottrap.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/arm/mediatek/mediatek,boottrap.example.dtb: boottrap@1001f6f0: reg: [[0, 268564208], [0, 32]] is too long
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/arm/mediatek/mediatek,boottrap.yaml


See https://patchwork.ozlabs.org/patch/1780124

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

