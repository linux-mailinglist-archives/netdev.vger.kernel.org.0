Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DFB340FEC
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 22:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhCRVfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 17:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbhCRVfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 17:35:09 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6F4C06174A;
        Thu, 18 Mar 2021 14:35:09 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y5so4405649pfn.1;
        Thu, 18 Mar 2021 14:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dIPVYhV3hVZA8D2XxTSEoEFzInt6YKUX+tNCFq71mKQ=;
        b=igUjxlwbspMZEAnTSWHxw7ibDL33VTt9WyW+mGBKVWFQb8QUwAiu5xk8oi940WT/XU
         ZShpDvftOxi58Ii44TTxZ8F+rtHizXMasolvn+Gn57ypfXBn8LGZ2bekDgXVjDoTHJ/g
         KwdYB7iM/HT0VqH25gLTQFNHoNpSeG/zpEtpUBq41Km1Q+P1qvxcgEr8wYZtwLpT6Zmz
         WxIO0ij+a8pFoPQ8JguR38J4L16RH0R7U1gnA6OyMPf47z80L/2Sqn5bsFCweXCPh2kq
         nzc5aaIqtpKpcbS+YaGkuEkgcr2VqVrPU0PrO3VDyNfWo3zhSOOD4pOpJtqKIk7E4buw
         b1Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dIPVYhV3hVZA8D2XxTSEoEFzInt6YKUX+tNCFq71mKQ=;
        b=B/e+LkLl7iMUDStMzPoE6kRQcFBH7zIVFmvXt5WNQ5r2d9c1oqB78zvoLreQst9eeF
         bYoi8y9G8fqfK5Qr5pWnrJP9DyH3SGAS3LfSvsA0N1RmL++zJvGG7z8orcuybJ6k7W9E
         dXGc05pzPsG3a16xKy8+MPaBDSrHfEsl2CQO1fq6GjEknlZAGogk+uB3g0OjAWyJo5Ko
         pGszRmFy4fvn4SMmOsjo14+NZQiia3N1YaGJfObk5Jqc/FnQwCe38zHx7rYNly4HbnOd
         Dqdy5WMTYzD7zPWIMgogK8tfgxqI0Xav2jqzJmtOyTr1umim4vs3wmdzmQqybohv3EkG
         AZZw==
X-Gm-Message-State: AOAM5316YqREkDKvTVIo+JQqWUUzow/oBBFcpMzy+G1kbxIJCvAQ4GRo
        aITWqVN7knNhsE9qzdMi8NZ7zlfMvAg=
X-Google-Smtp-Source: ABdhPJy+cB6zINbigEOzcQm4LIPY/iS34AUuj3HcnNiIV2hblg9/Bv33mmG37DzoZM85MlZzOUz8EQ==
X-Received: by 2002:a63:1d4d:: with SMTP id d13mr8397879pgm.103.1616103308728;
        Thu, 18 Mar 2021 14:35:08 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gz12sm3262071pjb.33.2021.03.18.14.35.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 14:35:08 -0700 (PDT)
Subject: Re: [PATCH net-next v3 2/4] net: ipa: use upper_32_bits()
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210318185930.891260-1-elder@linaro.org>
 <20210318185930.891260-3-elder@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e211d822-ff08-7a83-a0b2-d0be36c30222@gmail.com>
Date:   Thu, 18 Mar 2021 14:35:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318185930.891260-3-elder@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 11:59 AM, Alex Elder wrote:
> Use upper_32_bits() to extract the high-order 32 bits of a DMA
> address.  This avoids doing a 32-position shift on a DMA address
> if it happens not to be 64 bits wide.  Use lower_32_bits() to
> extract the low-order 32 bits (because that's what it's for).
> 
> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Alex Elder <elder@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
