Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CF3301790
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 19:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbhAWSSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 13:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbhAWSST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 13:18:19 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D939CC06174A
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 10:17:38 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id w8so10052427oie.2
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 10:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JxepKNc+qZt58YnukK5AXApIw47iSB77jc1cvHZA5ek=;
        b=IriupALlT/n3JPeGVCApH9wQqcH8HOPmuagsaesJ1mM2eE8r9ZT3qTihF1d8xTOOgc
         HOqdnqahBqVLdP+atJL3hwSaTXiMfEWFYZQ5W5pPIP2fDqDVB7+PtbxgFZHtXpkDxBHB
         C4eFWU8A+3TtW8zelbsI7S20fLwDi7g3iXGUFyfS33ed42FZVS7YHPd8gTvRKmXhYAPH
         eqZPYBQ48su3U8gYzucpKCzNpniqyC7QB6TBV4c3rZD+hyimsT9dAGYl+GEmdYxLApww
         aXAt3/P17NuADO3uMdm7HrsdNRchPYx+n1RBZVLAm32WlaCrxRnrGXT9xCY6Bo75bVHu
         QzEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JxepKNc+qZt58YnukK5AXApIw47iSB77jc1cvHZA5ek=;
        b=MYydSHNLTffS4dxQlqD5UFXiHBQRnwdq/t1l1o4+kdQLpd3jEVvvmRLjbqpHb1oQFQ
         xo2apuJlSTPHwphijB/3IefQManCDtX1gmZxBq/h6Nq8JpT9uP+77GCYh+q4pkfwmyFQ
         p3BMsfCWthqhvnrTmObccQEQJ2NN/5qT0Bkiwe2zqzx9mI38sjDAv2ZsXWPws84MEHZ/
         I50HNROsT9lFvp30RTGpYxxPvlJmEif9wHU4W2UP8ZpjZ/FKuV+vFA/uLc1JJrV/fIYu
         8x/Ypo0Tis7rNok3lNl2F/bE6M10t+N8I+byk+6Bp6dmSwx95IeyYC9q8nHZQmRl0m3O
         T4ZA==
X-Gm-Message-State: AOAM533HlVMzVtl2rDxHel4migsAzOe8gYAkPKE1ZEK7BuzzmeObKOtQ
        cmxEUFcyoSG897eR1fuiNduwFg1mJoE=
X-Google-Smtp-Source: ABdhPJynFDKnuK0Xr8WtRXgglF76YtU2tTrEI/xfJ5AAGjoeY6802UGE6xntZy0ZxedPztyQ/9ePAA==
X-Received: by 2002:aca:d6c4:: with SMTP id n187mr6909923oig.28.1611425858002;
        Sat, 23 Jan 2021 10:17:38 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id v138sm2434186oia.32.2021.01.23.10.17.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Jan 2021 10:17:37 -0800 (PST)
Subject: Re: [PATCH iproute2-next v2] tc: flower: add tc conntrack inv
 ct_state support
To:     wenxu@ucloud.cn, marcelo.leitner@gmail.com
Cc:     netdev@vger.kernel.org
References: <1611111132-25552-1-git-send-email-wenxu@ucloud.cn>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <602327f6-8bff-8d65-8e6c-82dc9b13898b@gmail.com>
Date:   Sat, 23 Jan 2021 11:17:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1611111132-25552-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/21 7:52 PM, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Matches on conntrack inv ct_state.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v2: change the description
> 
>  include/uapi/linux/pkt_cls.h | 1 +
>  man/man8/tc-flower.8         | 2 ++
>  tc/f_flower.c                | 1 +
>  3 files changed, 4 insertions(+)
> 
> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> index 449a639..e8f2aed 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -563,6 +563,7 @@ enum {
>  	TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED = 1 << 1, /* Part of an existing connection. */
>  	TCA_FLOWER_KEY_CT_FLAGS_RELATED = 1 << 2, /* Related to an established connection. */
>  	TCA_FLOWER_KEY_CT_FLAGS_TRACKED = 1 << 3, /* Conntrack has occurred. */
> +	TCA_FLOWER_KEY_CT_FLAGS_INVALID = 1 << 4, /* Conntrack is invalid. */
>  };
>  
>  enum {
> diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
> index eb9eb5f..f90117b 100644
> --- a/man/man8/tc-flower.8
> +++ b/man/man8/tc-flower.8
> @@ -312,6 +312,8 @@ new - New connection.
>  .TP
>  est - Established connection.
>  .TP
> +inv - The state is invalid. The packet couldn't be associated to a connection.
> +.TP
>  Example: +trk+est
>  .RE
>  .TP
> diff --git a/tc/f_flower.c b/tc/f_flower.c
> index 9d59d71..7d2df9d 100644
> --- a/tc/f_flower.c
> +++ b/tc/f_flower.c
> @@ -340,6 +340,7 @@ static struct flower_ct_states {
>  	{ "trk", TCA_FLOWER_KEY_CT_FLAGS_TRACKED },
>  	{ "new", TCA_FLOWER_KEY_CT_FLAGS_NEW },
>  	{ "est", TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED },
> +	{ "inv", TCA_FLOWER_KEY_CT_FLAGS_INVALID},
>  };
>  
>  static int flower_parse_ct_state(char *str, struct nlmsghdr *n)
> 

Fixed the space and applied to iproute2-next.
