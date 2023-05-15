Return-Path: <netdev+bounces-2605-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 895BF702AE2
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:50:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9934F1C20ADC
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 10:50:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A06B98833;
	Mon, 15 May 2023 10:50:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DDB1C13
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 10:50:41 +0000 (UTC)
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4616719D;
	Mon, 15 May 2023 03:50:40 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-50bd37ca954so110342324a12.0;
        Mon, 15 May 2023 03:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684147839; x=1686739839;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IMCzIVm9y/JKNQhpsWB9r4rKlI3sBz/z6wAlGkN3Ne0=;
        b=RS6h0h02HUcIiEEQ0GFOjPEJicRaKxzlbw52O+2VdwDXJ4Gh0mmLvAgo3sq15bhdx4
         s6LYlx10O5QgO3lNX48vY7yWB9Q/DEzGeVW7WDaqeeDIrqT7WXcJ21+L4LreC3OLH1/Y
         IsjlDTtEflyjlctRVi5JUQ4T7riy1Be02iZTZxPMZTuWn+NZNgtD2Csr4tak7xd89zTy
         rabmglhzzzx6eoUQXaGZi8Fx3Xvn8OlpebnIRjlPjA4eaxhvH6TkP/DPCaBijJY5/QSl
         fB/MAwN0tyZvSJrHeQDzlKpYlsLVPG1BhKWOnmIYKQFIDLmCDSIAjo5UhAwsAOrreCrx
         MmOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684147839; x=1686739839;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IMCzIVm9y/JKNQhpsWB9r4rKlI3sBz/z6wAlGkN3Ne0=;
        b=HQQAaqSPAcbHfMl+R/WUMWxhYUZub6XclQZAgrNQ8b9nrxKwlscyThDnjp27I4ph3A
         scS85zyJ/8Rch6RGwOpuM/LJ0/7q8TP8AbIcusI0fqO5YTc79umzqSHh3QXDB2x1hz8s
         jCIB69eUtmEqCwn8385hOLWyp4NnSMDClk5cILV53Mqi46QZH76PEOiild5r46gGkNfT
         C5kfyEaP1ziK62Mssmcin/ZfYRS+00AqR3YSa2pc9qTYuwd5Sug7Hgvm9vNVmm4PsC0c
         8hh7F2k0mD4diPnaqXqFOiByEfGmVfrShMaAOKe7PFs73uDoWs17SJh0Uv56RfQG/mpP
         ohug==
X-Gm-Message-State: AC+VfDxuP+Q+VgkDLjdNKrEPqyASbJ0Tyz7U0J72fRxWFJuCLrO0oyj/
	RQmPkKS8XPazGrf9Ujz99gw=
X-Google-Smtp-Source: ACHHUZ5saif27A0luYsYDlrYLn1n4LcTl9TYfi1XWRvzk/7eIaru1As1wTaRkOu84/t2QIvrtZzRMw==
X-Received: by 2002:a17:907:26c6:b0:94a:4739:bed9 with SMTP id bp6-20020a17090726c600b0094a4739bed9mr29469780ejc.13.1684147838481;
        Mon, 15 May 2023 03:50:38 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id hf27-20020a1709072c5b00b0096557203071sm9321613ejc.217.2023.05.15.03.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 03:50:38 -0700 (PDT)
Date: Mon, 15 May 2023 13:50:35 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH v5] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
Message-ID: <20230515105035.kzmygf2ru2jhusek@skbuf>
References: <20230515074525.53592-1-krzysztof.kozlowski@linaro.org>
 <20230515074525.53592-1-krzysztof.kozlowski@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515074525.53592-1-krzysztof.kozlowski@linaro.org>
 <20230515074525.53592-1-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 09:45:25AM +0200, Krzysztof Kozlowski wrote:
> Some boards use SJA1105 Ethernet Switch with SPI CPHA, while ones with
> SJA1110 use SPI CPOL, so document this to fix dtbs_check warnings:
> 
>   arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dtb: ethernet-switch@0: Unevaluated properties are not allowed ('spi-cpol' was unexpected)
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> 
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

