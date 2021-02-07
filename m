Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA73312661
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 18:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhBGRZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 12:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBGRZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 12:25:11 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25ACDC06174A;
        Sun,  7 Feb 2021 09:24:31 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id f1so60929oou.0;
        Sun, 07 Feb 2021 09:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4FrHVEoL2SrgwPK2nga5GVuXp913oHGtE/bnQAcFKfs=;
        b=WGd8pAETtBVCozNf0y1Mbt1QHLm8jwsumSW3/pdDxxeRftyEMDUgZLVm5K/uXWGf/3
         omG8Btb6uLNE/CB3SrDwI271AJFS8EwLs8gIVUy7DtrP1dyDcFeh1Sv7UtoNqwgPoLoI
         3731VQyTv5e1khUp5Xk0YzDRbyfdR+ue+wYkiIv9Ug87t3JHSYk+SU0hulm6+hWbKDSm
         IYzBr/FKjn8G9uzItnYMu0rbrBMDrLa5RBrNnogUmAMX57L0uASW/TSyfe1DI/L3AXru
         iHZpM2tgRROZV3ZN9SEO/sxwgAZFdvqsA9IviSoxpPsi+dJq1PcE3GNU0z1PZx//pnat
         62Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4FrHVEoL2SrgwPK2nga5GVuXp913oHGtE/bnQAcFKfs=;
        b=QWBM/sCGdFIIGd/6gFE577srQQ3tCnOxY+aDeBrz3RiFxMSRKLQtN7TLbx9qy6siov
         +vs0K8jNgFZsffWsFkNVMbpfZN0vi3gJ40Z42eeeKfU3q0MfW4hXRKjBRznc/xNVe2Us
         Oxx6O1DYRLxMgl1QyJA6EVBaov/CPaDShZHABrTnGWx3FVJBm6sY6OUfN69TnneM8qNZ
         +jBs0vlC7ovfzEBpo77u9LL/5xAuFvW5SbUgKVORREW1dcplR2/wImMISQX4jivl8tfD
         4fLH4Si+hUNjvH2AWCUZKMz+UNRPr+NCOuonPqaEA8xWebyZGPZcQ2nJpJit+P9dIwOc
         zWGw==
X-Gm-Message-State: AOAM5316XVyLKkW6IZNLAYpT7Y//Q9o1PRKoySZq8tQtyG2UnxKGvV4X
        4BZen7B3x9GBI79K6H0q5qKd6FDIykQ=
X-Google-Smtp-Source: ABdhPJzne3Xv+PXucH9shUbYVWI65712N+9eD9T+NZDBbDkVoHhzrFWcYkclALY9P70zkpJXIglAFA==
X-Received: by 2002:a4a:e383:: with SMTP id l3mr2237423oov.66.1612718670270;
        Sun, 07 Feb 2021 09:24:30 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id x7sm3138899oot.15.2021.02.07.09.24.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Feb 2021 09:24:29 -0800 (PST)
Subject: Re: [PATCH net-next v2] seg6: fool-proof the processing of SRv6
 behavior attributes
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20210206170934.5982-1-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5c51d022-a374-500c-04ca-941a4f439fab@gmail.com>
Date:   Sun, 7 Feb 2021 10:24:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210206170934.5982-1-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/6/21 10:09 AM, Andrea Mayer wrote:
> The set of required attributes for a given SRv6 behavior is identified
> using a bitmap stored in an unsigned long, since the initial design of SRv6
> networking in Linux. Recently the same approach has been used for
> identifying the optional attributes.
> 
> However, the number of attributes supported by SRv6 behaviors depends on
> the size of the unsigned long type which changes with the architecture.
> Indeed, on a 64-bit architecture, an SRv6 behavior can support up to 64
> attributes while on a 32-bit architecture it can support at most 32
> attributes.
> 
> To fool-proof the processing of SRv6 behaviors we verify, at compile time,
> that the set of all supported SRv6 attributes can be encoded into a bitmap
> stored in an unsigned long. Otherwise, kernel build fails forcing
> developers to reconsider adding a new attribute or extend the total
> number of supported attributes by the SRv6 behaviors.
> 
> Moreover, we replace all patterns (1 << i) with the macro SEG6_F_ATTR(i) in
> order to address potential overflow issues caused by 32-bit signed
> arithmetic.
> 
> Thanks to Colin Ian King for catching the overflow problem, providing a
> solution and inspiring this patch.
> Thanks to Jakub Kicinski for his useful suggestions during the design of
> this patch.
> 
> v2:
>  - remove the SEG6_LOCAL_MAX_SUPP which is not strictly needed: it can
>    be derived from the unsigned long type. Thanks to David Ahern for
>    pointing it out.
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  net/ipv6/seg6_local.c | 67 +++++++++++++++++++++++++------------------
>  1 file changed, 39 insertions(+), 28 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>



