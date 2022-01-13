Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A563D48DFBD
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 22:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbiAMVhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 16:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbiAMVho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 16:37:44 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A233CC061574
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 13:37:44 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso20100377pjm.4
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 13:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cdeeEeJROazJ1NehNh5ySymRJMY99xmbOoINtfIPQbI=;
        b=lO3hc3t5XChQiutdOvrOhrW1gEZd4crDGgHn2r+dDAuHfcUPU+AnmaLcCsqNdjDEao
         qRnxFAY9+lNw7i0zJ2MtqjzvadZWnDBWKZ3aQBzEcTAAmg9tAgabV3u6nJge6MKbVXhR
         M+DN1CTAJbpYqIhHYTxMYUU2D8SjPbyUEBFqgPUkW5kyPRVuIuiQrTq+u/6hWWqOmCw8
         GvYUelP/cRL2dBFXMJaN4VTWRb8/K+3nuxbXxQ0MpCnMuP6/ifqhugQ14KG/YzLRIoxg
         STjU4yYHNnidbNFn43NO3iz50hMRRXO7MpTn3RJY/O99T+oxZg+P9AzUZl85hAcHu3Vv
         FM9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cdeeEeJROazJ1NehNh5ySymRJMY99xmbOoINtfIPQbI=;
        b=FMA594W6AO5gCtKlNmNJtopfCnIhApWItkHtki7PVspbILhBtT3TE4WKq4pl4KD4rr
         WB3fLecEPckjxCNbYdH6UAY4jT/vJL6z/+wdw6qDKaZQv+5TesDO8PaF9yVGSQi2511C
         3fDJnbF5vPlYQKSbxRNGUyeV0r6SLIbwcAcQlgFDssn4Ia+dt0jnI2NucJaejUYvioFY
         y9w5YXr8wTExcIJ7w5bErbtsxOsIXMHRMOpLkaNwsDx6vPdSESvW8gvGGCYmqs+WWQtM
         RkGj68sHYznA1GdcSYAJcx59MsbNDA3eGJmUKIKDO3nDtXLXyVoCgJKGfIoAMVp7xVv4
         KrpQ==
X-Gm-Message-State: AOAM532iFclwlnHiMlrIsCoE8x1U82Pi6F7aCkIxyOyasTWHSZKpYh1v
        2P2KvXGiMzjryzqkoofjqNQ=
X-Google-Smtp-Source: ABdhPJxesbKuB4I5UV/HR554abUmND0WSmvtXxQavUQAniNvdgAHL9dYYvFxZi1OY5EVxg2GhiPmcw==
X-Received: by 2002:a17:902:e84b:b0:14a:2b59:7780 with SMTP id t11-20020a170902e84b00b0014a2b597780mr6443650plg.43.1642109864101;
        Thu, 13 Jan 2022 13:37:44 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:c1d3:c1c0:b78e:9e36? ([2600:8802:b00:4a48:c1d3:c1c0:b78e:9e36])
        by smtp.gmail.com with ESMTPSA id z12sm3563313pfe.110.2022.01.13.13.37.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jan 2022 13:37:43 -0800 (PST)
Message-ID: <184f55fb-c73b-989b-973e-e9562f511116@gmail.com>
Date:   Thu, 13 Jan 2022 13:37:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] bcmgenet: add WOL IRQ check
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com
References: <2b49e965-850c-9f71-cd54-6ca9b7571cc3@omp.ru>
 <YeCS6Ld93zCK6aWh@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YeCS6Ld93zCK6aWh@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/2022 1:00 PM, Andrew Lunn wrote:
> On Thu, Jan 13, 2022 at 10:46:07PM +0300, Sergey Shtylyov wrote:
>> The driver neglects to check the result of platform_get_irq_optional()'s
>> call and blithely passes the negative error codes to devm_request_irq()
>> (which takes *unsigned* IRQ #), causing it to fail with -EINVAL.
>> Stop calling devm_request_irq() with the invalid IRQ #s.
>>
>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
>>
>> ---
>> This patch is against DaveM's 'net.git' repo.
> 
> Since this is for net, it needs a Fixes: tag.
> 
> Fixes: 8562056f267d ("net: bcmgenet: request Wake-on-LAN interrupt")

I don't have strong objections whether we want to consider this a bug 
fix or not, but since the code only acts upon devm_request_irq() 
returning 0 meaning success, this seems more like an improvement rather 
than fixing an actual issue.
-- 
Florian
