Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7872D2D3385
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgLHUUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbgLHURu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 15:17:50 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66305C0613D6;
        Tue,  8 Dec 2020 12:17:15 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id w3so16382630otp.13;
        Tue, 08 Dec 2020 12:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RDpBBRXCwLTGCWL5RwRoMW+K4EoFZfULoP1L0KjbLbQ=;
        b=irYTzobUKoW2lTGMu/IWGq9PzYpzkIqG/jEAnrHZvn6pVpX2kuaedn1rquvYZ3zMW6
         94lYdQyny/ZYxLO2vEtHun0VkZ05N0V05vQkq7+/93gidt0MrRCblN0I6BaAIUZAZVuk
         Jt3U3xCq/QRqFv106yddgu2FhANtxChbXL1JX1LfSUOQCsbWCGu3TeCZ91Vy8o8IDKvL
         TWpodQEg6hOkt44m4LWIVdFgq9+ZaM5+FCtlCL0NLTJMTu3pOXMe8F39i1O3QUB8NliM
         QEvxY9NXUPIrOIVCmFcX/UYA30fz5gnmpMVz6gMwCIqefRr9VPzWFyI98zLzoTrpQQFQ
         Mm7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RDpBBRXCwLTGCWL5RwRoMW+K4EoFZfULoP1L0KjbLbQ=;
        b=IX7EdcfsInH8uFUe9ocoBSM+3ggi4qQzT492ztJmoN6TOc2rewKm3sq8OLwXitPOVS
         fAmNRodx8AvOCOp7S6Ndif2lVBKt34yWqlr9Vmq+XmBXFj4TuBFm3yKBlWvhwqxqx1QD
         moqGGu/qOtASOV3+TM1XpRkM5OFqbD+H+wgDD3j8dzq0JIV/SsXKavy9n3M1Nz6mR3Db
         FlRqkGn01ZGh21XVvhr0er72eezplPI7B8fkOB53DxUIhXrlFm07VBF6s6mx4sNGdQiF
         +AH/tRK9aFctwSw42oZBO6vogBdiEmDNrhu1KGT05XNTaV15qyP6gdSWfqeydq05JnYt
         4GYw==
X-Gm-Message-State: AOAM5328BMclyiCbQTvX7BSyWqFFOE9v7tOwvocWua1VqeUENYnwU15r
        dP4Kv84OBcWZ3qyS2gg2k+829e4BkVM=
X-Google-Smtp-Source: ABdhPJxTVQtJ6ItkrXTOaZOAp9aFVPMT53csV3Hgbgb4zzflb5HrNL1wyLpoX7m9Gyyvf6EphLsnHw==
X-Received: by 2002:a9d:2ae3:: with SMTP id e90mr18256256otb.105.1607457118066;
        Tue, 08 Dec 2020 11:51:58 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id m18sm1321249ooa.24.2020.12.08.11.51.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 11:51:57 -0800 (PST)
Subject: Re: [PATCH net-next] vrf: handle CONFIG_IPV6 not set for
 vrf_add_mac_header_if_unset()
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        kernel test robot <lkp@intel.com>
References: <20201208175210.8906-1-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <30116173-cc7f-f492-f290-faa24db28864@gmail.com>
Date:   Tue, 8 Dec 2020 12:51:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201208175210.8906-1-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/20 10:52 AM, Andrea Mayer wrote:
> The vrf_add_mac_header_if_unset() is defined within a conditional
> compilation block which depends on the CONFIG_IPV6 macro.
> However, the vrf_add_mac_header_if_unset() needs to be called also by IPv4
> related code and when the CONFIG_IPV6 is not set, this function is missing.
> As a consequence, the build process stops reporting the error:
> 
>  ERROR: implicit declaration of function 'vrf_add_mac_header_if_unset'
> 
> The problem is solved by *only* moving functions
> vrf_add_mac_header_if_unset() and vrf_prepare_mac_header() out of the
> conditional block.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 0489390882202 ("vrf: add mac header for tunneled packets when sniffer is attached")
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  drivers/net/vrf.c | 110 +++++++++++++++++++++++-----------------------
>  1 file changed, 55 insertions(+), 55 deletions(-)
> 


I should have caught that in my review.

Reviewed-by: David Ahern <dsahern@kernel.org>
