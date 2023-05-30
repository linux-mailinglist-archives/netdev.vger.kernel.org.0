Return-Path: <netdev+bounces-6366-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E7B8715F4D
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:28:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A3C4281172
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5951319923;
	Tue, 30 May 2023 12:28:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E451174DF
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:28:44 +0000 (UTC)
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405D7116
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:28:15 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-5148f299105so6529063a12.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685449693; x=1688041693;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DgW0b21c5MMnUODN29h76/cz88VjrUmb7STioFdZp4U=;
        b=YnfI/vFbdJphzRlbmJvEZKq/zoeu8NORH/Zo7cZPbZZPatQHdyLI3924dzOEH1kcu9
         PSDCfIPjYs9kIebVi89c+Gei7gWq6YfuYbgUCZJmO8OFuP3HhkAbSdWJ01CedPYLoQbn
         lI5wXyp+BYIlv/uzfN2Cmej0fYnSQDw+pePq6C8Y5FytkUhcrdRfulxdJ8PzE0XJCU2A
         nf8Yu9bfCx2ebVnEbrGZPM1jqItIxSRB2EbnSoWjA7+O6RqBCs9zxQ4MlIePF5NyvoO2
         kQfXrHcgCfDtFNmTIMWWHOV09OgfDUHytSWli6N43KQAOmgcZItfc1lkHl/Nk8hvSZIu
         EV3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685449694; x=1688041694;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DgW0b21c5MMnUODN29h76/cz88VjrUmb7STioFdZp4U=;
        b=ZEcHmH5HAAj9uPCTdcAhz2ENJSF0vtldeThdcxOyJc2LfGYRSU3gpxYNHshe5xTaue
         0IkUk/Rmn0DhngBQpN/+/v6vcu2BdytEt8RuCKM64YLUXIH7HYF6AnPk6MS5EbUKreIm
         Yr5q9B2G0hTQjsxs527+mId7Ss83WDjl6L6GxquPRfXzxeFsyu5T76A/qoxe1twnr/Vl
         L8FF57WCW+keePgsBkmg5Tg76kUkIJFKIH00myHt6B2jOIdJ5bpdjJC0lbDjFFb5YlEA
         1LbkVgGe+Dt0NKX1UIhHnLf2ZhoHzk0Qa8LHbdvClTreROjBaGEOYaN3i+jCkOlgjjk/
         eKGw==
X-Gm-Message-State: AC+VfDxXZrTHtNwik5oNMKv45XehC/wMhBA/5L7V8GIJUCu9eFraHrk+
	iFrWwVc5D8+K5vI2ChOSg8V5dA==
X-Google-Smtp-Source: ACHHUZ4hR9hcIAXw4L5o2HGVRGn0EpHKF6Gh3qDgF8K4m45x0Sa7f++M71nH65Ud6nT3agRhePn28A==
X-Received: by 2002:a05:6402:2038:b0:514:9e47:4319 with SMTP id ay24-20020a056402203800b005149e474319mr2254551edb.5.1685449693759;
        Tue, 30 May 2023 05:28:13 -0700 (PDT)
Received: from krzk-bin ([178.197.199.204])
        by smtp.gmail.com with ESMTPSA id n7-20020aa7c787000000b0050bc6c04a66sm4362518eds.40.2023.05.30.05.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 05:28:13 -0700 (PDT)
Date: Tue, 30 May 2023 14:27:48 +0200
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: pabeni@redhat.com, robh+dt@kernel.org, geert+renesas@glider.be,
	conor+dt@kernel.org, magnus.damm@gmail.com, netdev@vger.kernel.org,
	kuba@kernel.org, davem@davemloft.net, s.shtylyov@omp.ru,
	edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
	linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] dt-bindings: net: r8a779f0-ether-switch:
 Add ACLK
Message-ID: <20230530122748.y2oiv6qb7yxnh6kx@krzk-bin>
References: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com>
 <20230529080840.1156458-2-yoshihiro.shimoda.uh@renesas.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230529080840.1156458-2-yoshihiro.shimoda.uh@renesas.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 29 May 2023 17:08:36 +0900, Yoshihiro Shimoda wrote:
> Add ACLK of GWCA which needs to calculate registers' values for
> rate limiter feature.
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  .../bindings/net/renesas,r8a779f0-ether-switch.yaml    | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1786990


ethernet@e6880000: clocks: [[12, 1, 1505]] is too short
	arch/arm64/boot/dts/renesas/r8a779f0-spider.dtb

