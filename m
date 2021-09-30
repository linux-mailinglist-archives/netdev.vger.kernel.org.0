Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229D641D1E3
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 05:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347956AbhI3DhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 23:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347601AbhI3Dg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 23:36:58 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EBDC06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 20:35:16 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id a17-20020a4a6851000000b002b59bfbf669so1424608oof.9
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 20:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZDbYQ+DOwTUIi/pqb2yJp8EVgFdeIDyJbE/jl4X9EdA=;
        b=MauQd/BVO8nwZdJiQno23YuXlClsR4mLQWhJEIFwaveRSpMK7yMSHefpEIugfCPHWT
         LJ5wjO/z4rdztmZEYsqS8eA/fzN1/plDz9PSefozLoXA1pART8tDnnnLP176qdevE2W8
         Cp7EkzR7FmTYY2YX89Q+b2Hv7Tx90/iBJdSD08UCScu06zQm2SkdXz0PRDmwkBclPDkd
         TJwpBEjJQ88U+1D+DhV9+GiRPx7jWRTFGr/XgCXQ7B9sDl0EwAWqyw65lKIIhGYnRwVa
         WBy14Jv9a8ZdWZtzWKkfbObgIirrGr/DnPg3n7JLq5ooFvnsTOyUY4v/veba33UmiiTs
         ZamQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZDbYQ+DOwTUIi/pqb2yJp8EVgFdeIDyJbE/jl4X9EdA=;
        b=4BALGQS7JA5bk4aihhTUIWuXiiCG2J9rBin6JtfuiIVoazgnVFhsF8Cu06MFcuiKns
         gQUjdw6EEeZD4zuMreDJj1QwrnBmRI+Vg6tK5HXY6UZBb47V3UA8cO3vqpEnS75nAzCq
         1oHesFPQAtVNL4MO50er5BGS2eRB7/e/1MV13fL4FcPpDlt72YWvH+9iRoz31chZ92ch
         CcLBDOrS4YzNGAjPKXO47SpiavHYotrZq2/RwU+Z2Np/mLLey4L0LizlUDhmW/yE/Bnl
         wz0RRZRX1DFn1IWyp4Z8hGlkSF5nTllfL+zqHtDGJsBuQdE+amUvUsop225SH3vWPHAa
         VvPg==
X-Gm-Message-State: AOAM531kbAHOl6r3wwLriRu4exjWGsqA8i6iU2Vt64BZY3Vb2NVlMcmQ
        5TyoESTP+/ptMndhXX6KiSWuIDQn82f8PQ==
X-Google-Smtp-Source: ABdhPJzuB9SE9g7hqZSKCxLDnNvXw4vFs1mRlrW3V5JOJJR3m+KVEG+712tlSnTUgfUYO18vTBgL9A==
X-Received: by 2002:a4a:e7cd:: with SMTP id y13mr2865520oov.56.1632972916004;
        Wed, 29 Sep 2021 20:35:16 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id c10sm361344ooi.11.2021.09.29.20.35.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 20:35:15 -0700 (PDT)
Subject: Re: [RFC iproute2-next 04/11] ip: nexthop: parse resilient nexthop
 group attribute into structure
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, idosch@idosch.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20210929152848.1710552-1-razor@blackwall.org>
 <20210929152848.1710552-5-razor@blackwall.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1f242c54-baab-4a9a-ff4e-d0f569db8fd4@gmail.com>
Date:   Wed, 29 Sep 2021 21:35:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210929152848.1710552-5-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/21 9:28 AM, Nikolay Aleksandrov wrote:
> diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
> index be8541476fa6..9340d8941277 100644
> --- a/ip/ipnexthop.c
> +++ b/ip/ipnexthop.c
> @@ -272,6 +272,33 @@ static void print_nh_group_type(FILE *fp, const struct rtattr *grp_type_attr)
>  	print_string(PRINT_ANY, "type", "type %s ", nh_group_type_name(type));
>  }
>  
> +static void parse_nh_res_group_rta(const struct rtattr *res_grp_attr,
> +				   struct nha_res_grp *res_grp)
> +{
> +	struct rtattr *tb[NHA_RES_GROUP_MAX + 1];
> +	struct rtattr *rta;
> +
> +	parse_rtattr_nested(tb, NHA_RES_GROUP_MAX, res_grp_attr);
> +
> +	if (tb[NHA_RES_GROUP_BUCKETS])
> +		res_grp->buckets = rta_getattr_u16(tb[NHA_RES_GROUP_BUCKETS]);
> +
> +	if (tb[NHA_RES_GROUP_IDLE_TIMER]) {
> +		rta = tb[NHA_RES_GROUP_IDLE_TIMER];
> +		res_grp->idle_timer = rta_getattr_u32(rta);
> +	}
> +
> +	if (tb[NHA_RES_GROUP_UNBALANCED_TIMER]) {
> +		rta = tb[NHA_RES_GROUP_UNBALANCED_TIMER];
> +		res_grp->unbalanced_timer = rta_getattr_u32(rta);
> +	}
> +
> +	if (tb[NHA_RES_GROUP_UNBALANCED_TIME]) {
> +		rta = tb[NHA_RES_GROUP_UNBALANCED_TIME];
> +		res_grp->unbalanced_time = rta_getattr_u64(rta);
> +	}
> +}
> +
>  static void print_nh_res_group(FILE *fp, const struct rtattr *res_grp_attr)
>  {
>  	struct rtattr *tb[NHA_RES_GROUP_MAX + 1];

similarly here - have print_nh_res_group use the one parse function and
print based on the outcome.

