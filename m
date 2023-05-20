Return-Path: <netdev+bounces-4049-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6708870A4B4
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 04:55:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E16C1C20C38
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 02:55:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89FDE636;
	Sat, 20 May 2023 02:55:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1AB632
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 02:55:42 +0000 (UTC)
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E44C4;
	Fri, 19 May 2023 19:55:41 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-64d3fdcadb8so637677b3a.3;
        Fri, 19 May 2023 19:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684551340; x=1687143340;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7UVqaQqLR/UkdZlZvRsPJdOv/ISiCDxFgylWPJKMsXI=;
        b=MCQP4FcRSqGDGjQnnbWySH6GLZC6lOPu7+9B5hp92rV2wP8XMbfxMCsFSL5a5o13fm
         FRL7dGjBtuMy9yI8mzF1YoQpzg8DNVOVPT7vQrB0rwsDjGS+v4mVzIYabpfzTfUQMXO1
         2U+TSFzyo027nZ61n7CClCjYWu+Kc8DCoFK2YQjX7BbVdPMlscnvEGs5hK0SKsg8xpYO
         AhTrvf2WJLZUVbAULRRE6TaHnGJ9Ts6id515E1EobD+0xbZY+BO4R1NC6u/objSTih0z
         cySwyxqb6ZWStw0VOsRSz20wmzFUfcuD2CsYnjRvcNXwz+tn7hEOwM5RCOuQ5qEZcbwW
         or3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684551340; x=1687143340;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7UVqaQqLR/UkdZlZvRsPJdOv/ISiCDxFgylWPJKMsXI=;
        b=U+DxZrZp1Wn0+UeCRva9LrcZML/EMDpIqlt0dR5KRMlxSMCXKGqnbRRHMewiJ1Weku
         pPB6seAUW1K43zlEOXxbGvb8mpjsSaCq8S2nuvDXKxzOSWvNFk4pfefg2tMmtaKEZ3nr
         gTM/+D33uNi4Oy8Vwjv3+wTEE0HSVaAh8GLjcK0/2fiMq21vqCUUSdDMlYx28dGsmDpe
         FFugkFT8XuWcPXhRxhvMemto6d7JylfVyqFoaMlz0kPDxWMX1h07hb2g8x/aVNAQuSdi
         A65R7JnO4GncGPrNx7usgb2w5FMgdqmWDgPwHrEVevBN8QfU5aoCE2sCqw2k6JDBM1vV
         +8TQ==
X-Gm-Message-State: AC+VfDyidMd427/Q7Ho5H53bddI8JHAbVeKPUBvUGMY0rh/1goS5v5UY
	fr3vyf+Y3jqfVJSRyFAWDBo=
X-Google-Smtp-Source: ACHHUZ4AqlA9wHjU4NR1SJ30NTmli0iOTtEtjNYbq29GtBPA4MY44Fx02PQd/G1aazVk2FEu8y1CJw==
X-Received: by 2002:a05:6a00:23cc:b0:63f:ffd:5360 with SMTP id g12-20020a056a0023cc00b0063f0ffd5360mr6296815pfc.21.1684551340519;
        Fri, 19 May 2023 19:55:40 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 19-20020aa79213000000b00639eae8816asm324036pfo.130.2023.05.19.19.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 19:55:39 -0700 (PDT)
Message-ID: <13c2676d-46d5-861b-81a9-927f7de816a4@gmail.com>
Date: Fri, 19 May 2023 19:55:38 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net-next v2 5/7] net: dsa: mv88e6xxx: fix 88E6393X family
 internal phys layout
Content-Language: en-US
To: alexis.lothore@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
 Vladimir Oltean <olteanv@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Richard Cochran <richardcochran@gmail.com>, Rob Herring
 <robh+dt@kernel.org>, Krzysztof Kozlowski
 <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>,
 Russell King <linux@armlinux.org.uk>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
 paul.arola@telus.com, scott.roberts@telus.com, =?UTF-8?Q?Marek_Beh=c3=ban?=
 <kabel@kernel.org>
References: <20230519141303.245235-1-alexis.lothore@bootlin.com>
 <20230519141303.245235-6-alexis.lothore@bootlin.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230519141303.245235-6-alexis.lothore@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/19/2023 7:13 AM, alexis.lothore@bootlin.com wrote:
> From: Alexis Lothoré <alexis.lothore@bootlin.com>
> 
> 88E6393X/88E6193X/88E6191X swicthes have in fact 8 internal PHYs, but those
> are not present starting at port 0: supported ports go from 1 to 8
> 
> Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

