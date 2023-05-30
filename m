Return-Path: <netdev+bounces-6516-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B804C716BE4
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:05:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7272C281288
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A098F2A9EA;
	Tue, 30 May 2023 18:05:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931401EA76
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 18:05:43 +0000 (UTC)
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57620B2
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:05:38 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 6a1803df08f44-6260a07bf3cso21671396d6.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685469937; x=1688061937;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=siTWa6wKjpNK3TYryVQb2msnrf7DMm9LAu+uyfysJEI=;
        b=MfbNZRzJ8Du38XmSCSw+0M9ZIxvrlP6Ixlt1x0eePSkN4JqSNjsixfN7IA16KZiL3P
         UxOxyAQnlDdfykyHak/LhdMdzhOnsFEtMpy8cZci1/KjLJJApm5k/gqPCqnRbYeGvXNy
         hS1QVFoFYlE1M4yhda5UcG6Vxjbsd86wjh1vIReurOWMndFynxR0hi0Nhdc0GgzMlmZm
         1j9wbfhktg5F39oZqBbluDcMPY8nuA/XQgmN1SOpDzzymc6vbHNz9dRyVWLfIb5rEL1H
         5x18/Q9MO9rHGlJlqYivwAKJIywTykJOsewmNq2noCmoqwEmRF685cPH6TSANTb3qGE3
         53EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685469937; x=1688061937;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=siTWa6wKjpNK3TYryVQb2msnrf7DMm9LAu+uyfysJEI=;
        b=Xsg1zhO4m3n4VVQHfc6MUjBvtLS/Pc/hxAzuJFe8c35TP7fOzVlsJXztAxP1YMZHp6
         8h3n5POETUJBO373eYOo5vXEc6GP2rG/K5zuAJtq2uIfceI/nIfmIkikbRLl4eQzW3Zw
         6CKV/Aga8fWD9Hm8AqRgNY07tJZSmTVMyEXJObDblHrytl1Vt6bVOUIcdnO/1rurpqgL
         10lnY50yiLNpQwuuiofYVADuf43dGx57UW+/Ae/JH8EZNGb2vUnre9YTyEIx0aBvOkS3
         Tj3yFWcvbOr54VlC9VCUyHiihEYDvzjfUct7/ByyvdyjXPj8lB4KmK3IsdbWzjZiNmmD
         OLMQ==
X-Gm-Message-State: AC+VfDwjzN9RJ+z7PIkek3OlppEithrDzvlQIoEw1By18GMsGM0sxHgt
	gAPHJZWDr7Ar+mXVdAfsfFY=
X-Google-Smtp-Source: ACHHUZ7nb4mvK87qIdaSCB4LTIcnlTLq4Siw70IHcD/Kl8R9fmB9PZQO1Dgmj5z+mlJcWYaY7YWyrA==
X-Received: by 2002:a05:6214:212e:b0:626:1be5:176e with SMTP id r14-20020a056214212e00b006261be5176emr3498903qvc.41.1685469937440;
        Tue, 30 May 2023 11:05:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j29-20020ac84c9d000000b003f38aabb88asm4870735qtv.20.2023.05.30.11.05.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 11:05:36 -0700 (PDT)
Message-ID: <311ad9e4-fd8f-f8d5-75fd-6af570835c68@gmail.com>
Date: Tue, 30 May 2023 11:05:29 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC/RFTv3 16/24] net: dsa: b53: Swap to using phydev->eee_active
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Oleksij Rempel <linux@rempel-privat.de>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <20230331005518.2134652-17-andrew@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230331005518.2134652-17-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 3/30/23 17:55, Andrew Lunn wrote:
> Rather than calling phy_init_eee() retrieve the same information from
> within the phydev structure.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian


