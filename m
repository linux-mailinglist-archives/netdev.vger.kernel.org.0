Return-Path: <netdev+bounces-1702-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0013C6FEED3
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:30:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E76241C20F05
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B255E21CF0;
	Thu, 11 May 2023 09:30:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A654A1B8E2
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 09:30:19 +0000 (UTC)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51BA8A44
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 02:30:17 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-50bc394919cso12441874a12.2
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 02:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683797416; x=1686389416;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L1D3DyfgLO2qgpd2r/Ml+/RxBZh1GZB83GE0hqLy2tQ=;
        b=wlBZemLmgEoqTudarPWQuZoMWjupCJqW8eoiFqUKC2Gp4Kisx9Ypm/BWCaXiB425sb
         wL6FmizCb+Nd7fbe9eek478fDmJcuVtPFcdEwVMYB987GJkWGbSMVj/hHS2uCkg0tQrn
         9YI5HRkpAj6RFwa3rml75hjqocghOdYJLPCNazm5LwJ1BsFArBwhvSp6aGiJmGEtV4Om
         9/FGW40Mp5tcufk2U4PFIwL5Z6k80pflF3Or4zvPjiTdYDkxXYLnIP5nrzM1vZxBTBrz
         woHO0cWJ14RtUahhbItFWkPChjJIzLh8wRLBCJaaBgBWakKP63eA2STq9jEysM4/CCPr
         NSfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683797416; x=1686389416;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L1D3DyfgLO2qgpd2r/Ml+/RxBZh1GZB83GE0hqLy2tQ=;
        b=b0NyjW4Sa3fZcKLesc5u46b1zhI0IAXmhcTTeOJGizhMuf+1a9NJQh6XiVwU4m1U+X
         cJWQa8yOTUtdj2GRO90Q6J1Y4HjP118237SsaU48x6n9kyiUz/NOvyz75eXS5BFQ2g4e
         OlIACX5xDNHWEsZeXq3+qduL6tOQtVJERgStJjIbNuchop+CkhaLykfGM3I3q+CsU/N0
         G0zAFSt/DVGl9vos1iGdt8Ohx5CCFSAMHk5SM8zpNCvivSQHt73MTnMazbmI090FoCFV
         Kmmr7Ju3Ltvb4oA/XrmudgMPksoHchSk4ZmkO6uuSNmZ+1Qd1HwqUqYtdq8PjSEhhAbX
         yKlg==
X-Gm-Message-State: AC+VfDzlLroQ+a63MLW95S0TXn2CKSmL05NRmBX4I5E+WOPpVBTb01CK
	cQ/7e042Wkre3fW6hC/bFhwm2A==
X-Google-Smtp-Source: ACHHUZ6MCQhIY5WN8mggDOv6ysIWk93HQOiNqbiulZXCxvlq8N7YKfSeITx+13ES2XfyWpsighV8CQ==
X-Received: by 2002:a17:907:72d6:b0:94e:43ce:95f6 with SMTP id du22-20020a17090772d600b0094e43ce95f6mr20428602ejc.47.1683797416337;
        Thu, 11 May 2023 02:30:16 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:7e61:f14a:c3a4:809e? ([2a02:810d:15c0:828:7e61:f14a:c3a4:809e])
        by smtp.gmail.com with ESMTPSA id kn3-20020a1709079b0300b0096a27dbb5b2sm1835416ejc.209.2023.05.11.02.30.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 May 2023 02:30:15 -0700 (PDT)
Message-ID: <528a82c2-9520-f8c5-c5cc-1084d9083670@linaro.org>
Date: Thu, 11 May 2023 11:30:13 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5 1/2] dt-bindings: net: can: Add poll-interval for MCAN
Content-Language: en-US
To: Judith Mendez <jm@ti.com>, linux-can@vger.kernel.org,
 Chandrasekar Ramakrishnan <rcsekar@samsung.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>,
 Marc Kleine-Budde <mkl@pengutronix.de>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Schuyler Patton <spatton@ti.com>,
 devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, Oliver Hartkopp
 <socketcan@hartkopp.net>, linux-arm-kernel@lists.infradead.org
References: <20230510202952.27111-1-jm@ti.com>
 <20230510202952.27111-2-jm@ti.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230510202952.27111-2-jm@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 10/05/2023 22:29, Judith Mendez wrote:
> On AM62x SoC, MCANs on MCU domain do not have hardware interrupt
> routed to A53 Linux, instead they will use software interrupt by
> hrtimer.
> 
> To enable timer polling method, interrupts should be
> optional so remove interrupts property from required section and
> add an example for MCAN node with timer polling enabled.
> 
> Signed-off-by: Judith Mendez <jm@ti.com>
> ---

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof


