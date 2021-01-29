Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE1230842B
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhA2DQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:16:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhA2DQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 22:16:49 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD56C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:16:09 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id n42so7357632ota.12
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d909BYw7Dm9XANKTjg9rbeqYlNmMcyiIdr3qLBJXr1I=;
        b=jcay49WaTtPZ6EWbQEhz+9c5Ixb+4im/Ru4Yn9ARRSjQpQrsAvIJ6WLo1FnGVFc8zZ
         7WGqyxq14cfSygKNmKfnPbdDOWe1K53I1pdGdP2ozhQ8i1GPYLqF1Twl95zjDKOb7EEq
         7Y+pIiEKSNE6HlOj8XChZFjo2CCM8Vo/qbVQPS0lZQWxh5HDyNRZoMMDuMJxQquXDz2L
         GURPwHNg665Ysza6AhHBQNWOgUVkMs86+zilJ3N4VL6paMqI1ydDu8FbMami9sI/L1CU
         lHnNK0M9A9Dlhy6HzhluiFuA4xDHRyidDM8/2EiBeK6ftGgCBhCsxw5CeG+1UFNbEKrv
         Slzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d909BYw7Dm9XANKTjg9rbeqYlNmMcyiIdr3qLBJXr1I=;
        b=Hr8q3rs2tySwRQNimWGel0/JCZxEgIA6s97esIi9b09kIWfx55052uv+6zhCWlC4Sm
         xX9dConnU9nfNCSPAiNujwoSxbptSX2gl9TfMo+5g+xWERHXCnjsK5dynHFoRppD6qFv
         +jmn7UtvYmSotIV9zjbzO61eP6vZxB86pkqBeV+oBCFmdsq0C9tVA7TwSh8XTpSC5OwT
         DWuJrAdlc6F359x7GNDUpXqYKcX6bK98WP/PATVLgPShmjlfqU0sttTXzKK87NCtE8Kw
         6bOgW6mPnMkr+jSQeDnODHqgFMOpL6a7eQ1dimSM8n9qNcwxDexU22RsHbs7HRlv1nxF
         +gsA==
X-Gm-Message-State: AOAM531hM1UDtC5oHSS0V0iN5EysMBhSBoVhZodBYKWPfyFgWaCYjHiT
        fOQL/fbDvR86d17wyB0/9eHd2IMFNiE=
X-Google-Smtp-Source: ABdhPJxoy3aSW2CpHhk34TWvzXmsKBjjUCsImmhNkXoBjy9W7FgasGi2tpSLbToutH5bHH1aieG2Zg==
X-Received: by 2002:a9d:58c9:: with SMTP id s9mr1737744oth.332.1611890168855;
        Thu, 28 Jan 2021 19:16:08 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id i24sm1817252oor.1.2021.01.28.19.16.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 19:16:08 -0800 (PST)
Subject: Re: [PATCH net-next 07/12] nexthop: Extract dump filtering parameters
 into a single structure
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1611836479.git.petrm@nvidia.com>
 <5f9dd4b7c8dc9efa6ef6c9e761aa4f34f2be2e73.1611836479.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <63b098d5-6232-590c-ca90-e9e07368fef7@gmail.com>
Date:   Thu, 28 Jan 2021 20:16:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <5f9dd4b7c8dc9efa6ef6c9e761aa4f34f2be2e73.1611836479.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/21 5:49 AM, Petr Machata wrote:
> Requests to dump nexthops have many attributes in common with those that
> requests to dump buckets of resilient NH groups will have. In order to make
> reuse of this code simpler, convert the code to use a single structure with
> filtering configuration instead of passing around the parameters one by
> one.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 44 ++++++++++++++++++++++++--------------------
>  1 file changed, 24 insertions(+), 20 deletions(-)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 7149b12c4703..ad48e5d71bf9 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -1971,16 +1971,23 @@ static int rtm_get_nexthop(struct sk_buff *in_skb, struct nlmsghdr *nlh,
>  	goto out;
>  }
>  
> -static bool nh_dump_filtered(struct nexthop *nh, int dev_idx, int master_idx,
> -			     bool group_filter, u8 family)
> +struct nh_dump_filter {
> +	int dev_idx;
> +	int master_idx;
> +	bool group_filter;
> +	bool fdb_filter;
> +};
> +

I should have made that a struct from the beginning.

Reviewed-by: David Ahern <dsahern@kernel.org>
