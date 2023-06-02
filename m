Return-Path: <netdev+bounces-7547-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA03D72098C
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 21:11:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FB911C21215
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C53BE1DDF5;
	Fri,  2 Jun 2023 19:11:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2791DDF0
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 19:11:35 +0000 (UTC)
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBDA1BE;
	Fri,  2 Jun 2023 12:11:32 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id af79cd13be357-75b01271ad4so231746885a.1;
        Fri, 02 Jun 2023 12:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685733091; x=1688325091;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=opFi1JTQYsq9CCCUgt1EEOObmcMhgBVZV9dRUuWuSGw=;
        b=pIxmdQ9XfmOIJbx8yTczNiD0X4sZxgFu6m69eJeQcAmnOTkyt13Ysou4KnDPwWGX+T
         Z96wFpf/1GVU9lau6s1oWmMzsU1+EA+ev3oelwbYB6NCTd6oCZ7L6WvEA4THlQNO5oH2
         6eln1MDKzfP1KUyDqB/Me61IBYPvdTcipm1mIFA1/zcC6eMyOBnfCgwhhsynmOEUjPPB
         J8ak6QzjrT8n+2qgwkhN2gJAkY2/A3xqRAfDHKREYrS5XYzZWxvdFPGrhG8r/L+7pv9/
         Fwl+t5BNiO7Jq4vXmaQBRLF7IW1cZIFaS52KHotah1KIgcXTSgtW0OpMm/WXgiwWT0GK
         062A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685733091; x=1688325091;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=opFi1JTQYsq9CCCUgt1EEOObmcMhgBVZV9dRUuWuSGw=;
        b=lxyswwKpNflAiICsr2HmG/xsVZoODxNPz7/ZhUs0eKT0bmukNg7V+VcNghar4Goxnu
         ZuVEHFrYt4JiTfZ1RocIIjOqlHmhj05Kcv9MI8o7N4j0DtvZKLKUA3PJulSfp+AOLhjq
         7D1DgloV9zwU+ZJBi60G2i22spuLlOBgMgOKQq87lJXzxbXcTpBZZULQ1yFzagWGA8N9
         Zt/UqCK8tav9eIoV7jP7XpIP8sxA9so9Bw/RGsgauV+3XqsLEte+zHVj28kHzxFS1Bt3
         uAQusB8sH/S99mPW4gcYRwkbWlypMYvjmr9rzMgjZl3Qoa8TBuGMR17Vj6oh5NLP9m/4
         m1Qw==
X-Gm-Message-State: AC+VfDxU8NkDkgeeuR6yejP43WOWdr+JX8pPiRawWrg29QWySUHW9QoP
	nWG2j1Yzy5UyjHNx8mC9ufQ=
X-Google-Smtp-Source: ACHHUZ6YnUoaCGLE6lsrpxVhurfAkr9IE0o/Fi5tnPsc12SxFMiaxgHFvtsALAFo4/50VjKKYKOnPg==
X-Received: by 2002:a05:620a:4003:b0:75b:23a1:8347 with SMTP id h3-20020a05620a400300b0075b23a18347mr17217065qko.66.1685733091668;
        Fri, 02 Jun 2023 12:11:31 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t7-20020a05620a004700b0075b327a2988sm936705qkt.133.2023.06.02.12.11.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 12:11:30 -0700 (PDT)
Message-ID: <3597b0be-2dc9-5dbd-a773-6dd5704ef4a9@gmail.com>
Date: Fri, 2 Jun 2023 12:11:17 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 3/3] net: phy: realtek: Disable clock on suspend
Content-Language: en-US
To: Detlev Casanova <detlev.casanova@collabora.com>,
 linux-kernel@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <linux@armlinux.org.uk>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, netdev@vger.kernel.org,
 devicetree@vger.kernel.org
References: <20230602182659.307876-1-detlev.casanova@collabora.com>
 <20230602182659.307876-4-detlev.casanova@collabora.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230602182659.307876-4-detlev.casanova@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/2/23 11:26, Detlev Casanova wrote:
> For PHYs that call rtl821x_probe() where an external clock can be
> configured, make sure that the clock is disabled
> when ->suspend() is called and enabled on resume.
> 
> The PHY_ALWAYS_CALL_SUSPEND is added to ensure that the suspend function
> is actually always called.
> 
> Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian


