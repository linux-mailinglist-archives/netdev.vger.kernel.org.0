Return-Path: <netdev+bounces-6576-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C87E1716FD7
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:39:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 688A31C20D8D
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C79F631F02;
	Tue, 30 May 2023 21:39:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE9A200BC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 21:39:02 +0000 (UTC)
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084B9E5;
	Tue, 30 May 2023 14:39:01 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-25669acf1b0so2799267a91.0;
        Tue, 30 May 2023 14:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685482740; x=1688074740;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7xr/xAflOQkbZrsxeuPZYwFlb7zpPHeI468vpcAX5x4=;
        b=MYVgAVYH93wkCcEIhlmmH6g9Zc1E+ErBlGiidFNufGnX8QzVxqqxkhwP10RqbGTd/R
         oGrRUb1hwDPn71/RBP8C7Eo/MsWjP4TG1XileHl3mrd+vB1/hu9FLHVZR5qVTDU6hzCW
         xKe1pCbFLtteKQVNXd7pU2XyPUII74j+bxRuV4h4z75fpv22qkKfEn8pyZZIvgjvFne7
         zccUzOmHaC5bKHV83afS/428Ah+3jw8xINqRvGJNXARHaYt82X6voYnZbq8W0A5hFJAp
         HaoOSUO/31aFfd97h0JGuWttuc2qlp91zRxTb/W3DHuV8NtY6bsmt+TDTSVKU8UdN9iG
         cqqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685482740; x=1688074740;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7xr/xAflOQkbZrsxeuPZYwFlb7zpPHeI468vpcAX5x4=;
        b=amhFLC8Da+Oi2GewmyqgrkaRe8jbbC6rBoSdS64+g9hxCEvmyVu7nEqAC4dPPKuHai
         JhkTYivNAC6C1qmvKPq0lFkFX2+pmwAW/UP9UC5Mcs/dYoq/oDvAmWg1asNGiVkTgT6J
         ce9a213qPpIGaqNNSewauKVUmrNCnW8lOmmaZaVaYVtp/Jtd8G6m7TmGubZGCZy8bB3i
         AK2/zzecPEIfa/Gk4y28z12Kk1pogHOci6+g9Ets6yQdhadlCCKbIMkUTTP0kOBsA6T/
         0PUrG7PbbB3tD1nhtpJCRWKEcfztpfH3ig/heT1ToLaDLgVU77CLT491M4psiG3bWzHi
         4esQ==
X-Gm-Message-State: AC+VfDwE3/R19oRY5pY9mPugR61p/vFrFZl819JTBptO3NSQSPfY1jME
	ED5NKCUj4DUe13iHrTsktq4=
X-Google-Smtp-Source: ACHHUZ6JxdbT6JZxzP1Y6HZ3X/1+TEvqU2ggY7//bFW3ktDJ7Prr7l2ae1cQO5Euxnmx4K4wibaukw==
X-Received: by 2002:a17:90b:1b49:b0:255:a1d9:4486 with SMTP id nv9-20020a17090b1b4900b00255a1d94486mr3967511pjb.1.1685482740343;
        Tue, 30 May 2023 14:39:00 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u5-20020a17090ae00500b0024dee5cbe29sm4750589pjy.27.2023.05.30.14.38.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 14:38:59 -0700 (PDT)
Message-ID: <dd68b82b-7bb7-3f4f-7243-e3a4b745cd97@gmail.com>
Date: Tue, 30 May 2023 14:38:47 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v8 2/3] net: dsa: mv88e6xxx: add support for MV88E6020
 switch
Content-Language: en-US
To: Lukasz Majewski <lukma@denx.de>, Andrew Lunn <andrew@lunn.ch>,
 Vladimir Oltean <olteanv@gmail.com>, Russell King <linux@armlinux.org.uk>
Cc: Eric Dumazet <edumazet@google.com>, "David S. Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Alexander Duyck
 <alexander.duyck@gmail.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
References: <20230530083916.2139667-1-lukma@denx.de>
 <20230530083916.2139667-3-lukma@denx.de>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230530083916.2139667-3-lukma@denx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/30/23 01:39, Lukasz Majewski wrote:
> From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> 
> A mv88e6250 family switch with 2 PHY and RMII ports and
> no PTP support.
> 
> Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> Signed-off-by: Lukasz Majewski <lukma@denx.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

> ---
[snip]

>   /* List of supported models */
>   enum mv88e6xxx_model {
> +	MV88E6020,
>   	MV88E6085,
>   	MV88E6095,
>   	MV88E6097,
> @@ -94,7 +95,7 @@ enum mv88e6xxx_family {
>   	MV88E6XXX_FAMILY_6097,	/* 6046 6085 6096 6097 */
>   	MV88E6XXX_FAMILY_6165,	/* 6123 6161 6165 */
>   	MV88E6XXX_FAMILY_6185,	/* 6108 6121 6122 6131 6152 6155 6182 6185 */
> -	MV88E6XXX_FAMILY_6250,	/* 6220 6250 */
> +	MV88E6XXX_FAMILY_6250,	/* 6220 6250 6020 */

über nit: only if you have to resubmit, numbers in ascending order.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian


