Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBFA2B2C07
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 09:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgKNIB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 03:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgKNIB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 03:01:58 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBDCC0613D2
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 00:01:58 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id q3so13462447edr.12
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 00:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/fqG7c8M3pBdJnkPgVTe7wcFahJJ+uSB2RsTpRZEnLs=;
        b=dSzJvr3+fQAI4NT1Xr9rD6kEQgLMdvSeMpOimThvCfAeMFNlkjhhR5vIumbSSh4sH4
         8pDNgiWLKGF2XVLuQ85dtv5kg/RF+3IMLTqgsKNIudE7qhqx0E/hl8C2Kzq1a7DWWv56
         ELCG9ZtUjFrlH9U/7AhDlH1QP7djLp7pL3ur/cw/kV/aUuhoom+eTKVQZ9Hj4y+OdqP6
         0vTBbFGPxhhwMEfPsuD2VNuIECrJ8ihloBGWNzr5GlFFIV3KdvVhWnwDoI3rESqp/8Ny
         psoVinFGq8Hytl3uMJsMPRUAw1OVfGFu6q5z6NF2Y2srYnvhfJAIYDFbxpv6izcn2EgJ
         Cbig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/fqG7c8M3pBdJnkPgVTe7wcFahJJ+uSB2RsTpRZEnLs=;
        b=O5jDaC66cVJymVmy8MX42IiZrE5myt0dUHEoclioGvX+onkMM6TPdpxcxrL8wJxRw8
         WAOD1HEZkfBKfWYYXyzxaaZ1K+OwfShYm0OtKBsmvLu3EY7ICbGl5AwQu1L2g7jrfqG3
         ca9IWdqC185WDrfkjWlYwHiobc0rfIhwlk2/b+ymHKBkGs5JDHTQ+ZDzgpV5N9tmfLbd
         YWgowt96vhAoV9O+0ebqqVEvbmV+z6TBCqSoYWjk5PRF3vhGkGVOJZu8EjPuzK7U5a0s
         3t047pV+4uNSMkVbce/NAQr9ViS/jO7DhsFZjSt17ss23jJ0eI+l/XQawDRRNNG3xiUV
         3PBw==
X-Gm-Message-State: AOAM531+G8uytO/It2GFj0kRDFiUutHGPdoANSZVUbHPThgQKCo3DSi9
        izRxyLPunUGXdq5lK9JBoOgmWrX5tKFPKeqF
X-Google-Smtp-Source: ABdhPJx/d6nrUq1YXjq87J3UuKPgmYDeIcWSxawnxMko26410wivJfg4UwLLWhjZcKSlNseXvHGhbQ==
X-Received: by 2002:aa7:d591:: with SMTP id r17mr6738881edq.274.1605340916276;
        Sat, 14 Nov 2020 00:01:56 -0800 (PST)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:2233:3093:edf2:af28])
        by smtp.gmail.com with ESMTPSA id j9sm5791221ejf.105.2020.11.14.00.01.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2020 00:01:55 -0800 (PST)
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-next@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201114011110.21906-1-rdunlap@infradead.org>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH net-next] net: linux/skbuff.h: combine NET + KCOV handling
Message-ID: <52502fe4-8f41-0630-5b9c-be2e07b6932c@tessares.net>
Date:   Sat, 14 Nov 2020 09:01:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20201114011110.21906-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy,

On 14/11/2020 02:11, Randy Dunlap wrote:
> The previous Kconfig patch led to some other build errors as
> reported by the 0day bot and my own overnight build testing.

Thank you for looking at that!

I had the same issue and I was going to propose a similar fix with one 
small difference, please see below.

> --- linux-next-20201113.orig/include/linux/skbuff.h
> +++ linux-next-20201113/include/linux/skbuff.h
> @@ -4608,7 +4608,7 @@ static inline void skb_reset_redirect(st
>   #endif
>   }
>   
> -#ifdef CONFIG_KCOV
> +#if IS_ENABLED(CONFIG_KCOV) && IS_ENABLED(CONFIG_NET)
>   static inline void skb_set_kcov_handle(struct sk_buff *skb,
Should we have here CONFIG_SKB_EXTENSIONS instead of CONFIG_NET?

It is valid to use NET thanks to your commit 85ce50d337d1 ("net: kcov: 
don't select SKB_EXTENSIONS when there is no NET") that links 
SKB_EXTENSIONS with NET for KCOV but it looks strange to me to use a 
"non direct" dependence :)
I mean: here below, skb_ext_add() and skb_ext_find() are called but they 
are defined only if SKB_EXTENSIONS is enabled, not only NET.

But as I said, this patch fixes the issue. It's fine for me if we prefer 
to use CONFIG_NET.

> @@ -4636,7 +4636,7 @@ static inline u64 skb_get_kcov_handle(st
>   static inline void skb_set_kcov_handle(struct sk_buff *skb,
>   				       const u64 kcov_handle) { }
>   static inline u64 skb_get_kcov_handle(struct sk_buff *skb) { return 0; }
> -#endif /* CONFIG_KCOV */
> +#endif /* CONFIG_KCOV &&  CONFIG_NET */

(Small detail if you post a v2: there is an extra space between "&&" and 
"CONFIG_NET")

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
