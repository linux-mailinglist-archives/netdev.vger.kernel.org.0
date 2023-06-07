Return-Path: <netdev+bounces-8991-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 502737267B7
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:46:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABE5B1C20D5A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 378D338CBA;
	Wed,  7 Jun 2023 17:46:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C29A1772E
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:46:44 +0000 (UTC)
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E131FF3
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:46:39 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-977e7d6945aso589041866b.2
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 10:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686159997; x=1688751997;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IS4yO5/WmR+TVZNJffAGCPAsefusOsebYnq87EbR9d8=;
        b=PzyTuOtkeykTZ0E9oHoGoDsQ/p2Qa0UFZSSLm8W8vbcUh8U9lSgtO8y+UiTDleWhVd
         IC4emAy2C+or6ZDf5bIl5qXYFSSDMX9ag9oEClJbOap2JZLS3NHFtSjkYm6/zkBQc+uG
         pZJTUpiaMI7amxHQftTnaXbyaBCM4S1hIukTXP7XbEzajd6DNlcfQDVgRnP3P38tkKGg
         gzkbrDweJUUFvbTvnJvqlUfafu1M/feCxMzQLnLgbVf1s6jg8WgSo6ZRpmvYg+OByjt8
         7HekrhEqYX35nwdDI1p7WI1qKvWyRKHZ8NKQF3bpxA6SVImIm0MAJ8Ja4jK2YhuMOZ+M
         tsEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686159997; x=1688751997;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IS4yO5/WmR+TVZNJffAGCPAsefusOsebYnq87EbR9d8=;
        b=EoR4OGzbmVCncUKzUSuFbdjFdednW7ZiqRv0xijfYh683LL2LlUFNnQq6UI2lhfcYG
         0YnsMSlI7NaC+ILW5D7s0VjQThufbIr42m0CBR2YGFiJR6CvLmi7/PMZQHoshvkdR4Tn
         McP+IHsjl7H5iT7HFYNLFuT+zsQwO/4f2yRnuIuQiR5W5W9mibrMFj+aZpasocAYXZZA
         cw5UC/f3SLslGAjyyRPEdX3DJdx4i3v/CwlsQalNoi63bJEZ34e/MDV2UobjkmB9zetr
         YGfXS4nKOhkxW5YsUXUoAYLb3TT7dsWOYAKWw7PqfTcOr02Zlo7EQN4aWViEThCyAUrb
         a4tg==
X-Gm-Message-State: AC+VfDxmIpt3VbeETtL+vW0qBh/N6feF5rOj5q1uJcdiiraj35z9mJ20
	6VCft4Hgxvqm2SU+tXzOC5lcdKkieir/tjuXI9c=
X-Google-Smtp-Source: ACHHUZ6vACvk/Fp/owXZGI5nFgVQVKJgETLwe7WJ0NqCxrx8BOmb1qgAg2jht151GmXiO55T0EdEeg==
X-Received: by 2002:a17:907:1622:b0:968:2b4a:aba3 with SMTP id hb34-20020a170907162200b009682b4aaba3mr6198186ejc.5.1686159997582;
        Wed, 07 Jun 2023 10:46:37 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id v1-20020a1709060b4100b0096f6647b5e8sm7141037ejg.64.2023.06.07.10.46.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 10:46:37 -0700 (PDT)
Message-ID: <84508d22-2dcd-c49f-2424-37a717a49e1b@linaro.org>
Date: Wed, 7 Jun 2023 19:46:35 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH RFC net 2/2] nfc: nxp-nci: Fix i2c read on ThinkPad
 hardware
Content-Language: en-US
To: Marco Giorgi <giorgi.marco.96@disroot.org>, netdev@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, davem@davemloft.net, michael@walle.cc,
 kuba@kernel.org, linux-kernel@vger.kernel.org
References: <20230607170009.9458-1-giorgi.marco.96@disroot.org>
 <20230607170009.9458-3-giorgi.marco.96@disroot.org>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230607170009.9458-3-giorgi.marco.96@disroot.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 07/06/2023 19:00, Marco Giorgi wrote:
> Read IRQ GPIO value and exit from IRQ if the device is not ready.

Why? What problem are you solving?

Why IRQ GPIO - whatever it is - means device is not ready for I2C transfer?

> 
> Signed-off-by: Marco Giorgi <giorgi.marco.96@disroot.org>
> ---
>  drivers/nfc/nxp-nci/i2c.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)

Best regards,
Krzysztof


