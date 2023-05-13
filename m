Return-Path: <netdev+bounces-2355-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2546701681
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 13:51:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EC8C281B3A
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 11:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98DEC1C3D;
	Sat, 13 May 2023 11:51:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A44D186C
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 11:51:18 +0000 (UTC)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E0310D0
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 04:51:15 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-50bc1612940so19693941a12.2
        for <netdev@vger.kernel.org>; Sat, 13 May 2023 04:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683978674; x=1686570674;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5fXvNM1OOocy1c4XFoMHwhDURnFswe7IlygyhyjI324=;
        b=WiLE50IRzKyZ1nkD1ZUeB5nK+sPAwg4zi/s5nd5NmRpPqbgYgI46iWOFpZmaMUkB48
         egNGMh7jf6ZJ8fqBESaZ8ahKEDTfYjXo5giN/Uret9CZINcwndFoEu3PXLAyOHH/DINF
         xmh0TN1x0FVw+pfgmYpWnAsPsgdxIwbO1bc+rDLmpsHngWUsV0QpvP0aMqktCOuHsZ+Z
         biWTogXvPQm0/txhqrnVhc/n+cohuitx83L/sGhDr3WIiSzGTSS8FBxCmEKOnIJsjQfN
         XkkIZF6jNjkNf9VXhsmDqyTSbukcs+oxQqI9pSEzDAkE+zMS1BD3ErvmYY0YyIyCDf6S
         apAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683978674; x=1686570674;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5fXvNM1OOocy1c4XFoMHwhDURnFswe7IlygyhyjI324=;
        b=M+2ZobDFAb0Dt/B+thRWVyGqEEhrdJGpzj7Uenyh5fgbLl2M7+jtvwGQ0qmj28g0TN
         pnhUNAVEW3aR5HVTACmedClsSr8mjq8imwwYJrSnoc7sesuupbAWW5TpD1ojLpIkNMmL
         FZlpXM6L8g2NZcOSodHpw22iJZBVK8nJvsQO5z5PZV47VDmG4loUa8lPDmcQ9ADizeiE
         Ze9t0Aud1nVDplmcSxucH/0qZwqhLWAaSo51SRiazrdBacYx5dxbLXm1VVR7RbZku6Sq
         sQyrWp9HWmlMoqzPElfB/TsxByp/VfTpjJG1u60rqv2X0TtCgGlmD0XDWyxdGysE9AXp
         BWLg==
X-Gm-Message-State: AC+VfDwkBtePQNqaaf1gjGb7jjCawjTI0MielxyB9zmF317WBA/021ju
	zDksMXjMDhRFL1qx7cJNPgqYiw==
X-Google-Smtp-Source: ACHHUZ5Go78r5pIK8zVmwyH5Y/CpcDgbJebFBwMEwPIUCZD7ZcCeexhq23UboXp8TI3ng0+y5U9IyQ==
X-Received: by 2002:a17:907:1687:b0:958:cc8:bd55 with SMTP id hc7-20020a170907168700b009580cc8bd55mr27494260ejc.0.1683978674391;
        Sat, 13 May 2023 04:51:14 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:a3aa:fd4:f432:676b? ([2a02:810d:15c0:828:a3aa:fd4:f432:676b])
        by smtp.gmail.com with ESMTPSA id x4-20020a1709060a4400b0095ed3befbedsm6699963ejf.54.2023.05.13.04.51.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 May 2023 04:51:13 -0700 (PDT)
Message-ID: <06bba9db-25ff-a82b-803a-f9ae0519d293@linaro.org>
Date: Sat, 13 May 2023 13:51:12 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] nfx: llcp: fix possible use of uninitialized variable in
 nfc_llcp_send_connect()
Content-Language: en-US
To: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Samuel Ortiz <sameo@linux.intel.com>,
 Thierry Escande <thierry.escande@collabora.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20230513114938.179085-1-krzysztof.kozlowski@linaro.org>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230513114938.179085-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 13/05/2023 13:49, Krzysztof Kozlowski wrote:
> If sock->service_name is NULL, the local variable
> service_name_tlv_length will not be assigned by nfc_llcp_build_tlv(),
> later leading to using value frmo the stack.  Smatch warning:
> 
>   net/nfc/llcp_commands.c:442 nfc_llcp_send_connect() error: uninitialized symbol 'service_name_tlv_length'.

Eh, typo in subject prefix. V2 in shortly...


Best regards,
Krzysztof


