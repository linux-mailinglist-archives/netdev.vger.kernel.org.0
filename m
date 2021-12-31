Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF8548248D
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 16:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhLaPaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 10:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhLaPaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 10:30:07 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62538C061574
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 07:30:07 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id b186-20020a1c1bc3000000b00345734afe78so14896512wmb.0
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 07:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HC2BoYftq/KNwo/WTXE/PIQKc6hCKt2oiMbKCuq7sww=;
        b=R9oGLO6l43ForKpmYU7OsxFBsYVQjBAjrsi52ru25zSfyL40T7K9S5UAryinIdT1f6
         CWA/TJwoU4nR2b1H6yFS8k1iJ/oZ8M+sKgzNXSYcy5GLuUAQS6njMn7Ix1HHM74V1PvN
         LhWO5jHyvtQBWIKTC0qvNxER0ip7zVLu0yWQWStYAUODc+XXLh7JioHQqVCumn+JUutI
         TG8hC72RiV9yNDbG6UckpVF8zFbNgfbbLAeTk2U6g1zHSNr9mMIw7DxtYYgLd9B970bq
         D5qVkwlnlYgkpbo4LLsrtWT8+KQO6hSbgARXfKjQq9YO4OROZa6iph2dAXituWN3Zbze
         d12w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=HC2BoYftq/KNwo/WTXE/PIQKc6hCKt2oiMbKCuq7sww=;
        b=BxNyrLbTL+99t+IjjziLbhAkUO3fnLjfN1Oyrbi9F4CzrzDSgCIQVRvhKXtRHHjQ4P
         l+tVIpPtwryVmxKfbtVuvsJjw7fuPGro54oaqd3rUZkhBoRv9PjZ4fhoigJyp5ssT5mZ
         19itgF4iU42olqdSC5Nq5UUsZ+I6zci7SEDmXfVHBMwCX2eJnhsvC72o9MG1Su8W2OqK
         UcCAO41LJH7CrYrf7JKihHb75Xyi8PALZ9ZAw4olusbY84ANBXAJwLpDAPTjjg+20OXx
         n9XSx0z51xA5NUIqhjK64bKkWY5nSdEBhETWOTLc0iO3vAmv+iD89WhgZxB9G1QO5nfH
         ZC1Q==
X-Gm-Message-State: AOAM533OHQCvc5SuB91a5ra29UBrdaNLnPiGQgudmbWrX2I0AmBB1fLd
        hhnzynLBgtJ4UPvJjzFwmooMK3CUlL6awQ==
X-Google-Smtp-Source: ABdhPJyH0A6YXn7ogLgVVxBaSDfChyRT6KhoizVQa9IRkNcJKfQTCJJ8Yby51l4u2Y+rAKrCah+UKA==
X-Received: by 2002:a1c:a783:: with SMTP id q125mr30097202wme.132.1640964604789;
        Fri, 31 Dec 2021 07:30:04 -0800 (PST)
Received: from ?IPv6:2a01:e0a:b41:c160:5dbe:5ed1:d547:31e6? ([2a01:e0a:b41:c160:5dbe:5ed1:d547:31e6])
        by smtp.gmail.com with ESMTPSA id g6sm27799735wri.67.2021.12.31.07.30.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Dec 2021 07:30:04 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net 3/5] ipv6: Check attribute length for RTA_GATEWAY in
 multipath route
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     idosch@idosch.org
References: <20211231003635.91219-1-dsahern@kernel.org>
 <20211231003635.91219-4-dsahern@kernel.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <468b1a92-7613-e89e-d89d-48c0aa48e71c@6wind.com>
Date:   Fri, 31 Dec 2021 16:30:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211231003635.91219-4-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 31/12/2021 à 01:36, David Ahern a écrit :
> Commit referenced in the Fixes tag used nla_memcpy for RTA_GATEWAY as
> does the current nla_get_in6_addr. nla_memcpy protects against accessing
> memory greater than what is in the attribute, but there is no check
> requiring the attribute to have an IPv6 address. Add it.
> 
> Fixes: 51ebd3181572 ("ipv6: add support of equal cost multipath (ECMP)")
> Signed-off-by: David Ahern <dsahern@kernel.org>
> Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  net/ipv6/route.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
[snip]
> @@ -5264,7 +5277,13 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
>  
>  			nla = nla_find(attrs, attrlen, RTA_GATEWAY);
>  			if (nla) {
> -				r_cfg.fc_gateway = nla_get_in6_addr(nla);
> +				int ret;
> +
> +				ret = fib6_gw_from_attr(&r_cfg.fc_gateway, nla,
> +							extack);
> +				if (ret)
> +					return ret;
A 'goto cleanup;' is needed is case of error.
