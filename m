Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F59827EE67
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgI3QIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgI3QIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:08:36 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4B5C061755;
        Wed, 30 Sep 2020 09:08:36 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id o20so1469134pfp.11;
        Wed, 30 Sep 2020 09:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QtHsofp1RzK4fxNDQzPo/cXWDhewYXr80wZbuBCbL+o=;
        b=NqoSF+2fZ3MbVpfBguluEV37uFXNF/WvMbA7E+tO6UqV1EeccUV9/z8dy3N23ljPD+
         eZ7Q8fTp0a2KRpQSHG6uUYImkJpPk++KitIM+RxV/DCYgi0YYMVWfFOlUYpI5YTubFxR
         UeEGmrmfDx7+MhB71QGlX/pwSolRMEXHEluAmBolmhhAe1OSJrt8rRI8+1/8Mg2BbZFR
         JTC7uEADHql+lxoDDWb0cDc/pFVqaXQqf530P7H3bOEkW7aX8aBBxroV+nCSatgOFrW3
         AGmuz6W2tVEVOadRP9UtNmHCLzElZFYMxgCYKdMEDZ+P/E3NrHUlSJCQ24GFX9hwTUdG
         VYXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QtHsofp1RzK4fxNDQzPo/cXWDhewYXr80wZbuBCbL+o=;
        b=YiuzWgPw2hq55THe2UwD6ajX9Rwcn1a1nBBcU47YB+5J7zRKe5JHBylaL7Rh6yHpwz
         0rXekhA/yWHx8pgZRL0J7nFKZxPtsSfa0M2lCEwBkPOkn/+xZfQUwUl1WyfWCl0R3y/R
         yszDMzy24j+8LXa/iT4pW79JOvwMHvBnk6fuHLiKWbfZZyzZ+0VpsFpUmiDFCQv1q552
         UbZ5bI4Pw2NwGPZHvCqEIekEA1mPWL4T725Yqkf0QQB4wIChZJ7hhb04zgBUIGM9cS4m
         Fu9k0Z75JrdHsM4VWLsPn4Z89MkxDIofYyfLad4kskQl/PCVrgqpKYcNOMiQUK69Uj2e
         UkVQ==
X-Gm-Message-State: AOAM532KFRuFEyAIaIgfJhKy5BjrsFArmc3yrDtlgIZHbd6/t+b5UbIk
        vM1uJSDBvKQWbLt7WS1n/IE=
X-Google-Smtp-Source: ABdhPJwY4XbbU77KwolWSNxXTdsyl7chKxN8K/LGNXMC4P/67A2FYMFCi/s0iMVEjktTcohGrOJ4jQ==
X-Received: by 2002:a62:e40a:0:b029:138:8fd6:7fd5 with SMTP id r10-20020a62e40a0000b02901388fd67fd5mr3142099pfh.1.1601482115936;
        Wed, 30 Sep 2020 09:08:35 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id g9sm3206478pfo.144.2020.09.30.09.08.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 09:08:35 -0700 (PDT)
Subject: Re: [PATCH bpf-next v4 3/6] bpf: add redirect_neigh helper as
 redirect drop-in
To:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org
Cc:     john.fastabend@gmail.com, kafai@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, David Ahern <dsahern@kernel.org>
References: <cover.1601477936.git.daniel@iogearbox.net>
 <f207de81629e1724899b73b8112e0013be782d35.1601477936.git.daniel@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <34c873d1-5014-9fd4-8372-4980f6787904@gmail.com>
Date:   Wed, 30 Sep 2020 09:08:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <f207de81629e1724899b73b8112e0013be782d35.1601477936.git.daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/20 8:18 AM, Daniel Borkmann wrote:
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 6116a7f54c8f..1f17c6752deb 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3652,6 +3652,19 @@ union bpf_attr {
>   * 		associated socket instead of the current process.
>   * 	Return
>   * 		The id is returned or 0 in case the id could not be retrieved.
> + *
> + * long bpf_redirect_neigh(u32 ifindex, u64 flags)
> + * 	Description
> + * 		Redirect the packet to another net device of index *ifindex*
> + * 		and fill in L2 addresses from neighboring subsystem. This helper

It is worth mentioning in the documentation that this helper does a FIB
lookup based on the skb's networking header to get the address of the
next hop and then relies on the neighbor lookup for the L2 address of
the nexthop.

> + * 		is somewhat similar to **bpf_redirect**\ (), except that it
> + * 		fills in e.g. MAC addresses based on the L3 information from
> + * 		the packet. This helper is supported for IPv4 and IPv6 protocols.
> + * 		The *flags* argument is reserved and must be 0. The helper is
> + * 		currently only supported for tc BPF program types.
> + * 	Return
> + * 		The helper returns **TC_ACT_REDIRECT** on success or
> + * 		**TC_ACT_SHOT** on error.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\

Code change looks fine to me:

Reviewed-by: David Ahern <dsahern@gmail.com>
