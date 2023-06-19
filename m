Return-Path: <netdev+bounces-12021-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A72A735B1D
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 17:26:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D21462810BA
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 15:26:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB53712B87;
	Mon, 19 Jun 2023 15:26:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF96A10797
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 15:26:35 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CF0F9
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:26:34 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-668704a5b5bso1690484b3a.0
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687188394; x=1689780394;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=umNJkulJ4/Ep+efvSya/8T2+RRKh1k4wAsCfzBSDFIg=;
        b=eRfp/OiO+EMdjNNi000xWmb82R9D7b4qRCc3RPjyjqjx3IcB7emWe/mtKj/siY8HGN
         huG3jAyrbTQcGmSPHanbKFMfPekFC75J7Eye6uEJJ6bEICAxxeHr7ESqMkFihBFz1RkE
         OPhswyhiDIj6pu1jYM7Z5EY1bbIW6Hm8wlsQk2dScZBvbssT7QLlQxPJx7KcUGVS+2Pb
         DsxcCjpU+CqEGDZzWbYonxa8BXIwn97w+kjbBkCFg5cxbu5sarSvBbs/3dYezWF444gh
         9ceakwHCbGWDDd7v8JtRerTN8ASRdEyyktahNGFa5zXf7uR/fdlUb4wFCktJfMKgn2cb
         d8DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687188394; x=1689780394;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=umNJkulJ4/Ep+efvSya/8T2+RRKh1k4wAsCfzBSDFIg=;
        b=LzmZLaWeNsXwNYLAJR0pzpDC21YrA6kr8VxhXK3NX2Q95duBpa/xM7QXbXUmCKVfrV
         izUrwhYx3ucOkRxYwpczZ8MwuhQ3mJDmEV3tr3YxkLa6j67b4wYDGl0OASeuhQodERxu
         WFNRFUKmCvuPMmDzOkbtO8McLr4x0lpear5epG6B61KZADyltLzllcfDwr9GnOSe7RHY
         7pF7oAO1yYNNCU76T+9hryrsYrLtZvGbB7atIdSxnA8YFLgiR9izV7+/yFGTPKJmsUPm
         1LYNggcFHILol0ugQWerP9+BHAQHlqCc0yS8eNtAODWQcY9HqDY+54gjZuOxQL6p8sQl
         64tQ==
X-Gm-Message-State: AC+VfDzRe8V01uhvz+Dvo/JORhx13FLehk2FOjyUug5h/egnBdeGPEnT
	PVaZ/Ez7z1HaTy5ziBdW9iaZp41ehRqhq8eK
X-Google-Smtp-Source: ACHHUZ50POj0cYycJKlyVoPz2v/sk3pGtVtMF/yrCerri3zNhkEsPVg2+RrgxP6RqvYgeYZ9ue0Xkw==
X-Received: by 2002:a05:6a00:cc2:b0:656:c7b2:876f with SMTP id b2-20020a056a000cc200b00656c7b2876fmr15203145pfv.14.1687188394094;
        Mon, 19 Jun 2023 08:26:34 -0700 (PDT)
Received: from [10.178.67.29] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id t22-20020aa79396000000b0066684d8115bsm7613310pfe.178.2023.06.19.08.26.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 08:26:33 -0700 (PDT)
Message-ID: <2634caa6-298f-5773-197c-f84ced66d782@gmail.com>
Date: Mon, 19 Jun 2023 16:26:27 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v4 net-next 2/9] net: add helpers for EEE configuration
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Cc: Russell King <rmk+kernel@armlinux.org.uk>,
 Heiner Kallweit <hkallweit1@gmail.com>,
 Oleksij Rempel <linux@rempel-privat.de>
References: <20230618184119.4017149-1-andrew@lunn.ch>
 <20230618184119.4017149-3-andrew@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230618184119.4017149-3-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/18/2023 7:41 PM, Andrew Lunn wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Add helpers that phylib and phylink can use to manage EEE configuration
> and determine whether the MAC should be permitted to use LPI based on
> that configuration.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

