Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B271D3BF5BF
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 08:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbhGHGsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 02:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbhGHGsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 02:48:23 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F3AC061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 23:45:41 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id u8so6044376wrq.8
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 23:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M9vTfHccfcctkpa6jvEVqLrU2GiiRbFjoHuZ919gPXA=;
        b=Hm1zRHNwrnmc8A9KiuKq1GuSeSegpdn/SWIfPuU1GNEpfBoJi27V1vwF4o2DTRmhtX
         FhL1yoCyS6OA6UsJug955/IeHeRscVRn8fl8gQuEPPPBh1hAVzVHy2Pq0Zoc2vJ+nRLU
         KwDBhjN6wYzH6EDF19INYAZWU8QCCRvArlJHWy27yH/egv485R5tZiAWImIn6dtV5GiD
         PI/r7qd07VRzia3cTHndYWvQ+V1J2UoEAVrXMCaBbJCGPDy39FJvjIpIElIGRuUc3GDF
         LPEgytoSpH55hgvu7HWO7G/rbkQ9TR7rKHmXd/CN2s9EMfgX/0ntwy9g7WddDjtV+TlG
         5bKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M9vTfHccfcctkpa6jvEVqLrU2GiiRbFjoHuZ919gPXA=;
        b=d1puT55Nc/sqQTHMlFhuXceLtrdAH3l+/otjPpdFR2HbpixF+tbgf2O6u5FbCKkK7W
         P1WLKfY5k0iM/l9Lhc6tvnMLFOl0GO79tMEpbUn/eOhdCru+/qq4jdQGeH4WMvDBBRXl
         mSl2IBQC07Eq/n4vwU5INerulM54M7OIpGKZFWWQbntSIFu138cvo9C3CorLPWjqlZ4J
         3VXllAHFDaHAgOUmsWhOQwBX7TqLc3jtA2LeoVjE4BgXP48FD752yWYxeBzRhWl8Enw6
         RUgwRVa2N3MYNP0xrPTzS0ywnFzizeyMLeTICXnNEycR1pmV4T8Q4LBO1ER0cB4ghGM9
         ekWg==
X-Gm-Message-State: AOAM533JAaDXjrOHKG26kcZ0gn6nsCn5zziLeHJxlabkVtC0WL+1ELT4
        mJrSWqfcsgWDTKlkAgPTxhc=
X-Google-Smtp-Source: ABdhPJxDBNNOOmuonpb9B9cNb/BStkwq29JsNb/D0CtFkaaPaqwBcbrBXfKbBzOzQzadmnfw71azuA==
X-Received: by 2002:adf:f5cb:: with SMTP id k11mr32975806wrp.131.1625726740047;
        Wed, 07 Jul 2021 23:45:40 -0700 (PDT)
Received: from [192.168.98.98] ([37.165.72.156])
        by smtp.gmail.com with ESMTPSA id b12sm1222721wrx.60.2021.07.07.23.45.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 23:45:39 -0700 (PDT)
Subject: Re: [PATCH net] skbuff: Fix build with SKB extensions disabled
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     Paul Blakey <paulb@nvidia.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        mika penttila <mika.penttila@nextfour.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
References: <20210708041051.17851-1-f.fainelli@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <63b4ff93-5164-356d-bca0-4b2e08aee19d@gmail.com>
Date:   Thu, 8 Jul 2021 08:45:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210708041051.17851-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/21 6:10 AM, Florian Fainelli wrote:
> We will fail to build with CONFIG_SKB_EXTENSIONS disabled after
> 8550ff8d8c75 ("skbuff: Release nfct refcount on napi stolen or re-used
> skbs") since there is an unconditionally use of skb_ext_find() without
> an appropriate stub. Simply build the code conditionally and properly
> guard against both COFNIG_SKB_EXTENSIONS as well as
> CONFIG_NET_TC_SKB_EXT being disabled.
> 
> Fixes: Fixes: 8550ff8d8c75 ("skbuff: Release nfct refcount on napi stolen or re-used skbs")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>

Thanks, I also hit the same bug.

Reviewed-by: Eric Dumazet <edumazet@google.com>

