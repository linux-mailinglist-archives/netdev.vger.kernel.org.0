Return-Path: <netdev+bounces-10844-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64994730879
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:39:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE3442813E1
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E81E411C9F;
	Wed, 14 Jun 2023 19:39:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D819B111B3
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 19:39:02 +0000 (UTC)
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32FB2700;
	Wed, 14 Jun 2023 12:38:27 -0700 (PDT)
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3411ea250efso872145ab.3;
        Wed, 14 Jun 2023 12:38:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686771468; x=1689363468;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Js2ECPS3HFYIFQ8yai86PBdkogVWCesLn0GciStXnE0=;
        b=i65gd/bWQ6X9am8fSA57qKvVKLU2y9YvstO7PGJuoVLUIJEbCuGWYYjUC6ZIFXu2Uf
         AlevL69HVZ7ijw9ghjsfiMjWidHif4BKl7z0rQm7ndWIapSfJ6mlLojeI/2mbBEMONfq
         2NmZDLiMk9H4XoDatBriBWw8IcCr2jpydvfRV98grlujicWBcai+E8M654F7iBJFbbgO
         9mG+9cxjLJ4TeFlAYCWbFHABbVJEq7PaPGRGELnsHL5zF9vdxA+eLP94VimYNgCcZEHJ
         +R7F2vEoBIYEp/YLxIMj/UJe/fPfCc5hoi3/EuGV9xyCfSXWebLD2X3yv329H4RbrOkA
         JeTw==
X-Gm-Message-State: AC+VfDwVCyfjU/MQq29wnOakpxZQaYMZsVlxDP9sCvyRBT0+StX8Nq86
	YPU9E0+K2mf4Rd1cewwerQ==
X-Google-Smtp-Source: ACHHUZ5TdW09mEJtcgXSMfkSD1quISRJqJD2aWpt3TlMbRNewMZFdqBFcaVViCVaei7epmCPIU5QGQ==
X-Received: by 2002:a92:da89:0:b0:340:9b67:ff17 with SMTP id u9-20020a92da89000000b003409b67ff17mr3081405iln.13.1686771468622;
        Wed, 14 Jun 2023 12:37:48 -0700 (PDT)
Received: from robh_at_kernel.org ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id b8-20020a02c988000000b0041f5ff08660sm5168879jap.141.2023.06.14.12.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 12:37:47 -0700 (PDT)
Received: (nullmailer pid 2613672 invoked by uid 1000);
	Wed, 14 Jun 2023 19:37:44 -0000
Date: Wed, 14 Jun 2023 13:37:44 -0600
From: Rob Herring <robh@kernel.org>
To: Varshini Rajendran <varshini.rajendran@microchip.com>
Cc: tglx@linutronix.de, maz@kernel.org, krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org, nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com, claudiu.beznea@microchip.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, gregkh@linuxfoundation.org, linux@armlinux.org.uk, mturquette@baylibre.com, sboyd@kernel.org, sre@kernel.org, broonie@kernel.org, arnd@arndb.de, gregory.clement@bootlin.com, sudeep.holla@arm.com, balamanikandan.gunasundar@microchip.com, mihai.sain@microchip.com, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org, linux-clk@vger.kernel.org, linux-pm@vger.kernel.org, Hari.PrasathGE@microchip.com, cristian.birsan@microchip.com, durai.manickamkr@microchip.com, manikandan.m@microchip.com, dharma.b@microchip.com, nayabbasha.sayed@microchip.com, balakrishnan.s@microchip.com
Subject: Re: [PATCH 01/21] dt-bindings: microchip: atmel,at91rm9200-tcb: add
 sam9x60 compatible
Message-ID: <20230614193744.GA2611132-robh@kernel.org>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-2-varshini.rajendran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230603200243.243878-2-varshini.rajendran@microchip.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
	FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 01:32:23AM +0530, Varshini Rajendran wrote:
> Add sam9x60 compatible string support in the schema file
> 
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> ---
>  .../devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml  | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Rob Herring <robh@kernel.org>

