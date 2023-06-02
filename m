Return-Path: <netdev+bounces-7546-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADBFC720989
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 21:11:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C302281A4D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94A911DDF1;
	Fri,  2 Jun 2023 19:11:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876DC19E45
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 19:11:13 +0000 (UTC)
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F92133;
	Fri,  2 Jun 2023 12:11:11 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-75b0df81142so275313585a.2;
        Fri, 02 Jun 2023 12:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685733070; x=1688325070;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/c+JmdRjZKJt3f/jf4aQQG5jIKIzfXv3IkRk6BRsBRw=;
        b=shpwf31GrX+DRB/nGXbzkDffrVUebrAcz/grvP0YcKsMQMNsORI878epuMFQsuCgcK
         0POr1bnjxqILJGLbyObKyDdQkztwP/yJhkZmZDUCu6dSsqgtllG4+JaJmm6sjv9IPNIN
         JQb/6O3TkdhV5OqcYie4bYnbL5YJNCfW1glZ1mxKbuGfFhZZpT3Iak7u3ydWyvxHSmIU
         inptzN1UMPKIHph18fueBAdNPuLaJBYgU1enV/hZGmmak+K/JnlyDk8nTh2E4GrKPVRt
         nTVa0nabxXzqoXKTpNkHIjZoXy/9zw4ALzzkTkFYiSyUaeZXCZRNSGSC1ezBEXlP2LuB
         qyLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685733070; x=1688325070;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/c+JmdRjZKJt3f/jf4aQQG5jIKIzfXv3IkRk6BRsBRw=;
        b=WKBGK5kOyTAiht4V5oHgeInSyfoX2MTQxRNV+hBuMpGx55iyFyifUGzBXKMjd/hmx4
         7yLJrZmCDrMd1nqr0eDKYLBJGIMupUo7CgJyp+w44ajdFBKDTErhNgQoa+kFq4jFYSV3
         WPwwXethf1F86U2Co/Mfo983rCEyM8iGPmSAvs19V+hG4SRHINNS15+o4SxGahzC0ipU
         9mKOTPSlKLoYyxlhvkl10k6ZBDhI43aD6sYoPuEa8PllNaB8NOKci459MuGfHT57ShDp
         +iXuuLJHehqkZX847yL2XJr/e425NXleanL6GtW9tjO+ENp41kheZMOM8cBD3AETbC1S
         9ruw==
X-Gm-Message-State: AC+VfDzLNAlIBbhly3qksq7D+Izcl+uKVWJt7p4utrR7YiwcOpO+SF5O
	MnUQdm2NzqkMANRQah8G+Rg=
X-Google-Smtp-Source: ACHHUZ5fN2FHtbXoLD5R2oPpDXu3MR+F+o69SkjKLL8dzKzMkVkbBuQ1j9ShMgzswRy3VKEGAnDgUA==
X-Received: by 2002:a05:620a:6412:b0:75b:23a0:deb3 with SMTP id pz18-20020a05620a641200b0075b23a0deb3mr13899930qkn.49.1685733070619;
        Fri, 02 Jun 2023 12:11:10 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o24-20020a05620a15d800b00751517fd46esm971836qkm.26.2023.06.02.12.11.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 12:11:09 -0700 (PDT)
Message-ID: <efa17e71-93e8-bd77-433b-bf3f1df5f49d@gmail.com>
Date: Fri, 2 Jun 2023 12:10:57 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 1/3] net: phy: realtek: Add optional external PHY clock
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
 <20230602182659.307876-2-detlev.casanova@collabora.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230602182659.307876-2-detlev.casanova@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/2/23 11:26, Detlev Casanova wrote:
> In some cases, the PHY can use an external clock source instead of a
> crystal.
> 
> Add an optional clock in the phy node to make sure that the clock source
> is enabled, if specified, before probing.
> 
> Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian


