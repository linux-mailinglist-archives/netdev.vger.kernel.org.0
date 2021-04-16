Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47F9361F8E
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 14:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240467AbhDPMMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 08:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234681AbhDPMMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 08:12:37 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B219AC061756
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 05:12:12 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id a9so16603098ioc.8
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 05:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QRWAPmW5vvyXZA3k3epSuvNabZYcpW8oDtvws6ZLKbA=;
        b=UplxDcY1zQ2EymDQcSIbvMLZOmcYU+jYX9/g74rwXA5evWnhYH2I9jwlXZbhmKe7Uh
         BBL/g4ZhSoQxAKX6VGDn/XV7n1XMaw6imZ9hdGoNH7UWlZGIK5x8DpzwiAJwTdc1K+kl
         EZm6mITn17YLMUY775amwjKD5aBATgC6P+giA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QRWAPmW5vvyXZA3k3epSuvNabZYcpW8oDtvws6ZLKbA=;
        b=ewYa64l/18qKms+z3ZhACcQAqykIQ5NJYUeZbi3LmyHgy3rfnqxElCtYwsu8rCGjFg
         aU4h1AJKzzmnEeLR+I7OL9yG1iFwdS+U3NPQdqpw1iHaQa/lu8lkFSx4k2V1vnNU7Hib
         Y45eDx2mvMh8CzoCWT+eZiCEPQfxszl54Vq/rQaBp/twOvITJ/LUBYu6JmxbnGdt+HQf
         OLIk5qxMsVG4KXv2qUEC+7EM0yLD5xCqb0F0ZciUHI6g5XgE3KWzCR8EVKAA7LJ6Gwec
         d9nZFJ+3XTSmTon0ugvxwpT4fEzlJnNlmGxJN7VsBCTDuScndXWRcnPv1VYrwYIOacJz
         oIiw==
X-Gm-Message-State: AOAM5331ZTsq62edw89SUVPhNehSAL0uIxoubKxbz88hAeMPE8urz1+e
        wT493qGjINq7Zch/frevLMXJenVfedXZ5g==
X-Google-Smtp-Source: ABdhPJzonT2xqujZWT52oa9/fLNipZhY74sU/pHLYeFmZAfsUf5mQYtA00rRFIFW13DMjp/348GLWw==
X-Received: by 2002:a05:6638:1390:: with SMTP id w16mr3705553jad.83.1618575132189;
        Fri, 16 Apr 2021 05:12:12 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id s1sm308665iov.52.2021.04.16.05.12.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 05:12:11 -0700 (PDT)
Subject: Re: [PATCH] drivers: ipa: Fix missing IRQF_ONESHOT as only threaded
 handler
To:     zhuguangqing83@gmail.com, Alex Elder <elder@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210416034007.31222-1-zhuguangqing83@gmail.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <a200ba57-4c70-d2cc-10b8-710789c322dc@ieee.org>
Date:   Fri, 16 Apr 2021 07:12:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210416034007.31222-1-zhuguangqing83@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/21 10:40 PM, zhuguangqing83@gmail.com wrote:
> From: Guangqing Zhu <zhuguangqing83@gmail.com>

This is not required here.	-Alex

https://lore.kernel.org/netdev/d57e0a43-4d87-93cf-471c-c8185ea85ced@ieee.org/

> Coccinelle noticed:
> drivers/net/ipa/ipa_smp2p.c:186:7-27: ERROR: Threaded IRQ with no primary
> handler requested without IRQF_ONESHOT
> 
> Signed-off-by: Guangqing Zhu <zhuguangqing83@gmail.com>
> ---
>   drivers/net/ipa/ipa_smp2p.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
> index a5f7a79a1923..74e04427a711 100644
> --- a/drivers/net/ipa/ipa_smp2p.c
> +++ b/drivers/net/ipa/ipa_smp2p.c
> @@ -183,7 +183,8 @@ static int ipa_smp2p_irq_init(struct ipa_smp2p *smp2p, const char *name,
>   	}
>   	irq = ret;
>   
> -	ret = request_threaded_irq(irq, NULL, handler, 0, name, smp2p);
> +	ret = request_threaded_irq(irq, NULL, handler, IRQF_ONESHOT,
> +				   name, smp2p);
>   	if (ret) {
>   		dev_err(dev, "error %d requesting \"%s\" IRQ\n", ret, name);
>   		return ret;
> 

