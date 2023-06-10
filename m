Return-Path: <netdev+bounces-9807-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A12E72AACA
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 12:08:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE50A281A41
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 10:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2945C2E6;
	Sat, 10 Jun 2023 10:08:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F171FD5
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 10:08:12 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9FA30D7
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 03:08:10 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-97467e06511so429567666b.2
        for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 03:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686391689; x=1688983689;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=okNTexbJspMD75o0Bt05ood0hjP1VlvByboe/ITALf8=;
        b=DJv5mP99L/SzxxAQSGWfie5GCfd1KVHvFBMuvAEv00yE6oJxJL1pvwB4sE2rm87fd3
         VM3kb56crD/vECilvFoZIpDX8YNLw1DELfGr2rsRcbg9SidXsLXjpbFgLjiyiLO+SQkH
         0wsreMiVie2UY5s16bJd/16Ol5MbOfPFdowBdx/NDcv1i6aEIuz8yjfVfKWFrx5SGp+w
         6AlID6lIzTZD2dSiFmCQMUKZxq6iLjMl811SNU02N+0ydw0RavWE+IZV5DugsyLhBh9z
         Zg5oPChd8oBLur4GWWgIWaxFJrTbF5jWpHsB5gf0dSD9s7cr1GppH5FBYE9sfbBTy6NH
         X6Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686391689; x=1688983689;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=okNTexbJspMD75o0Bt05ood0hjP1VlvByboe/ITALf8=;
        b=YRWtPbLhwibjCHTLH0c+f0c91/ybh3hNMDhq8OcSse6r7CgP4Rl90Xnj/6aJDP7Uix
         XYYpykgj8SaQLed2iCtZI34P36uMk5HRd9+7CorgiOAYEe8ycIApycyBWXo8cDgAd7NL
         2Z0AOXtN+f498/yiaxRc4BRG+gfMfft5cJlPz01cWFGPZ4sgayvmlCMUoScvJY2fTafr
         +RQP7jvel/AniKqgSpUgxe/jN8O1aRftnyuzcb41Dfzj5j+lSgAWg2pmgJa9GUF0XwJj
         SiYMHWeLgoHpS2iL4Atz7gWT2Jg7SvzcLmZ1ZV2DkUIysJMPV2WU9EEIZFGvRyRpHWAt
         mfWQ==
X-Gm-Message-State: AC+VfDy0p8HVu6/dTLRaM9TMoNLLQNJdErFnT99vvx5CGMA7YjDx6xeO
	WzZohqUoTkEBRg7weSTWZMqOcg==
X-Google-Smtp-Source: ACHHUZ6MUH57Wor8BcWWus8X/Om5E3kLGbRK/mu3r/HMCnMkHLINXnNpgW5O6IEyCi7f/jZ4FBzDvQ==
X-Received: by 2002:a17:907:7f0d:b0:974:9aa9:be3 with SMTP id qf13-20020a1709077f0d00b009749aa90be3mr4785690ejc.28.1686391689283;
        Sat, 10 Jun 2023 03:08:09 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id lr12-20020a170906fb8c00b00959b3c30f2csm2363099ejb.222.2023.06.10.03.08.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Jun 2023 03:08:08 -0700 (PDT)
Message-ID: <f41a1506-a3cd-0571-25a6-07a7c0af51e8@linaro.org>
Date: Sat, 10 Jun 2023 12:08:06 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH net-next v2] nfc: nxp-nci: store __be16 value in __be16
 variable
Content-Language: en-US
To: Simon Horman <horms@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>
Cc: Luca Ceresoli <luca.ceresoli@bootlin.com>,
 Michael Walle <michael@walle.cc>,
 =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
 Sridhar Samudrala <sridhar.samudrala@intel.com>,
 Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>,
 netdev@vger.kernel.org
References: <20230608-nxp-nci-be16-v2-1-cd9fa22a41fd@kernel.org>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230608-nxp-nci-be16-v2-1-cd9fa22a41fd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 09/06/2023 15:31, Simon Horman wrote:
> Use a __be16 variable to store the big endian value of header in
> nxp_nci_i2c_fw_read().
> 
> Flagged by Sparse as:
> 
>  .../i2c.c:113:22: warning: cast to restricted __be16
> 
> No functional changes intended.
> Compile tested only.
> 
> Signed-off-by: Simon Horman <horms@kernel.org>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof


