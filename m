Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E4A3EA0F5
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 10:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235191AbhHLIsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 04:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbhHLIsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 04:48:37 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475D4C061765;
        Thu, 12 Aug 2021 01:48:12 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id l34-20020a05600c1d22b02902573c214807so6501627wms.2;
        Thu, 12 Aug 2021 01:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XFHOGWal8sj9+/NYHXBYiZDttgCo8MQmZS41UjmAkWM=;
        b=TnjSaR4dryTzq1TobA28+orXVqNx8bWsy3a0BDE3S8ve2uQk0vvzGrrbjTMwiMYRSu
         oVjzvVawcmA5v/FzG6o/huElHZV975CDYv739sdz/9JH5w0uUHoUSi7yi8jRBbn1uNTT
         zvJsSwqBh8GTzIUL2tPTjPQqgUOXT3zMDi9/l9AAUyYP9dIqe26Np3bnJ8/i/5AHADWI
         jbawWkZMCmsbQsJ6wwucKu6p68bSRUQai3WBFGBt5h21VQCTzbU6pCZs6bWK68urVxlu
         y844gmcFrRUavm2O4zOoyiXRCizIHUYCHULo8yFjZXAWFWp0PVsiwkmnJvRMGMdF+zGo
         nG2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XFHOGWal8sj9+/NYHXBYiZDttgCo8MQmZS41UjmAkWM=;
        b=V1Ath9cMBrcXSNALHPEyYuWLn2i9XarB2k2NxDuQTIzndT2lQsGMF9tzqRUlVGW98c
         iu5bk1NBXaftAfyJRlDJWsLQBZUbq+s9+J65vD8YExiem5R3+yWB6QeGorPnBAgINNSK
         7kMJwB4wR3UM9q6OlhQk/y3Skmo/K9LvJlqQ6IrmuveK9WiantKAvYvawp1ZMEUuXgtS
         GGEtl+t48FOFncB82WFp8i/zndMoeb3PEW+Ow2QXwlKPIrj7klc4XGPWf9eUNyGM+k8N
         AnRot5coy1fGOlNYCWbHvEPJ4bSlEQSN2j9yfhM6gm8VZ9fEYPmbNxOZQrmnnHgBcH46
         nN0g==
X-Gm-Message-State: AOAM5306KXkyuMkN6PSgjTP2AARUu+JFfEyzcBgcY0gnvXd1297HbBxa
        96LgM7VYCdMOX8Xyr5dN1Zg=
X-Google-Smtp-Source: ABdhPJzLbsspJrb3pj55Dy1sQCs3nGpP1+jpQD1sc8n0LAnXOAo2LkmdkTVEl0CcnF8GI8etHTZAIw==
X-Received: by 2002:a05:600c:b51:: with SMTP id k17mr2779184wmr.149.1628758090954;
        Thu, 12 Aug 2021 01:48:10 -0700 (PDT)
Received: from [10.0.0.18] ([37.165.173.167])
        by smtp.gmail.com with ESMTPSA id p14sm8720305wmi.42.2021.08.12.01.48.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 01:48:10 -0700 (PDT)
Subject: Re: [PATCH net-next] stmmac: align RX buffers
To:     Marc Zyngier <maz@kernel.org>
Cc:     Thierry Reding <thierry.reding@gmail.com>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Drew Fustini <drew@beagleboard.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jon Hunter <jonathanh@nvidia.com>,
        Will Deacon <will@kernel.org>
References: <20210614022504.24458-1-mcroce@linux.microsoft.com>
 <871r71azjw.wl-maz@kernel.org> <YROmOQ+4Kqukgd6z@orome.fritz.box>
 <202417ef-f8ae-895d-4d07-1f9f3d89b4a4@gmail.com>
 <87o8a49idp.wl-maz@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fe5f99c8-5655-7fbb-a64e-b5f067c3273c@gmail.com>
Date:   Thu, 12 Aug 2021 10:48:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <87o8a49idp.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/11/21 4:16 PM, Marc Zyngier wrote:
> On Wed, 11 Aug 2021 13:53:59 +0100,
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>> Are you sure you do not need to adjust stmmac_set_bfsize(), 
>> stmmac_rx_buf1_len() and stmmac_rx_buf2_len() ?
>>
>> Presumably DEFAULT_BUFSIZE also want to be increased by NET_SKB_PAD
>>
>> Patch for stmmac_rx_buf1_len() :
>>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> index 7b8404a21544cf29668e8a14240c3971e6bce0c3..041a74e7efca3436bfe3e17f972dd156173957a9 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> @@ -4508,12 +4508,12 @@ static unsigned int stmmac_rx_buf1_len(struct stmmac_priv *priv,
>>  
>>         /* First descriptor, not last descriptor and not split header */
>>         if (status & rx_not_ls)
>> -               return priv->dma_buf_sz;
>> +               return priv->dma_buf_sz - NET_SKB_PAD - NET_IP_ALIGN;
>>  
>>         plen = stmmac_get_rx_frame_len(priv, p, coe);
>>  
>>         /* First descriptor and last descriptor and not split header */
>> -       return min_t(unsigned int, priv->dma_buf_sz, plen);
>> +       return min_t(unsigned int, priv->dma_buf_sz - NET_SKB_PAD - NET_IP_ALIGN, plen);
>>  }
>>  
>>  static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
> 
> Feels like a major deficiency of the original patch. Happy to test a
> more complete patch if/when you have one.

I wont have time in the immediate future.

Matteo, if you do not work on a fix, I suggest we revert
 a955318fe67ec0d962760b5ee58e74bffaf649b8 stmmac: align RX buffers

before a more polished version can be submitted.

