Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CFA460B84
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 01:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240223AbhK2AY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 19:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240307AbhK2AW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 19:22:57 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4954BC061748
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 16:19:41 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id bj13so31306970oib.4
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 16:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=B7qUZ7NHgHex/kes6MX183v8kdoosBpty2Kbq2fICmI=;
        b=k1RMHIQU/yJT5BISaOF1DtlynSuTn33BzJIybY+ssZqPSynBqkAKWe4pqs9Fj4YS86
         0dIMuXoISv5vfU5e4Cx7296T3Zf1GFF0VEXFlS/rA6ZABSV7cNClTkcOSgzXwUx49AaH
         tCiEZw/p2wbhQhpQJaKSBeBwHzZy9DlV/4t9G+ae3EPC4oYLC+Nlc2IL/z0YZKM6Bf/m
         gGFXW8qZUp/vL4+FPOkzWNTpLuKpiJA4z8OWrbm7asfQXDvBcPI4b4uibVyzlKgwVURi
         U+aNFnQwIAtYHLO5depzwouhvaVv73tThsmgmIotpWdPh5BU8anLbzaW5MQ/nIGfn7LH
         UEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=B7qUZ7NHgHex/kes6MX183v8kdoosBpty2Kbq2fICmI=;
        b=zcDR6sRwWiztAPRIN0ZyetFh9vG7OQ4VCTgcpoDPTuF7MJKavFNgy7FvAXKI8y0Rb3
         LXfZnCJdYyF/GjP+mQWXRcAl3V0C8lEA+SIr8AMOtQo+AqTzoGUn4O7Yrv9ShMFAGfhJ
         WHAguVPwvN6sbFah/lAyI3a0k0UYz4JedFGGuS0gAHaHK8seiKlW+CWde8h3UAQnUXji
         mZ8vCQw+DMqxQ/tyLy5HzCB3b9bmORQAlmPsBXPikL0hr46k8YbmpzrRliO9PUaFqw+Q
         13ZcsCTQXczCxaCUhWsa+HPeBGoUWbhSohBFe6Rez+WrmTVWQUA9CpoOxe6RpiCZRT4U
         1/pQ==
X-Gm-Message-State: AOAM530o6e6uT6TxOCSYk1OihwnDF/ZZCQMZPCMdFE9ImUvTKBoMMJuW
        SI76J59OaIxa+SVLQm3vUJ33zuQs6Xg=
X-Google-Smtp-Source: ABdhPJzVWaCL/mkk85/5o1ieYf8EROYXOF1Fxib5wbVfCuNhtKGbGbFa8LcVogVw9pSxhvpnXlp0NQ==
X-Received: by 2002:a05:6808:1485:: with SMTP id e5mr38600486oiw.156.1638145180636;
        Sun, 28 Nov 2021 16:19:40 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id y28sm2613355oix.57.2021.11.28.16.19.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Nov 2021 16:19:40 -0800 (PST)
Message-ID: <e3d13710-2780-5dff-3cbf-fa0fd7cb5d32@gmail.com>
Date:   Sun, 28 Nov 2021 17:19:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH net-next] rtnetlink: add RTNH_REJECT_MASK
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211126134311.920808-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211126134311.920808-2-alexander.mikhalitsyn@virtuozzo.com>
 <YaOLt2M1hBnoVFKd@shredder>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <YaOLt2M1hBnoVFKd@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/21 7:01 AM, Ido Schimmel wrote:
> On Fri, Nov 26, 2021 at 04:43:11PM +0300, Alexander Mikhalitsyn wrote:
>> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
>> index 5888492a5257..9c065e2fdef9 100644
>> --- a/include/uapi/linux/rtnetlink.h
>> +++ b/include/uapi/linux/rtnetlink.h
>> @@ -417,6 +417,9 @@ struct rtnexthop {
>>  #define RTNH_COMPARE_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN | \
>>  				 RTNH_F_OFFLOAD | RTNH_F_TRAP)
>>  
>> +/* these flags can't be set by the userspace */
>> +#define RTNH_REJECT_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN)
>> +
>>  /* Macros to handle hexthops */
>>  
>>  #define RTNH_ALIGNTO	4
>> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
>> index 4c0c33e4710d..805f5e05b56d 100644
>> --- a/net/ipv4/fib_semantics.c
>> +++ b/net/ipv4/fib_semantics.c
>> @@ -685,7 +685,7 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
>>  			return -EINVAL;
>>  		}
>>  
>> -		if (rtnh->rtnh_flags & (RTNH_F_DEAD | RTNH_F_LINKDOWN)) {
>> +		if (rtnh->rtnh_flags & RTNH_REJECT_MASK) {
>>  			NL_SET_ERR_MSG(extack,
>>  				       "Invalid flags for nexthop - can not contain DEAD or LINKDOWN");
>>  			return -EINVAL;
>> @@ -1363,7 +1363,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
>>  		goto err_inval;
>>  	}
>>  
>> -	if (cfg->fc_flags & (RTNH_F_DEAD | RTNH_F_LINKDOWN)) {
>> +	if (cfg->fc_flags & RTNH_REJECT_MASK) {
>>  		NL_SET_ERR_MSG(extack,
>>  			       "Invalid rtm_flags - can not contain DEAD or LINKDOWN");
> 
> Instead of a deny list as in the legacy nexthop code, the new nexthop
> code has an allow list (from rtm_to_nh_config()):
> 
> ```
> 	if (nhm->nh_flags & ~NEXTHOP_VALID_USER_FLAGS) {
> 		NL_SET_ERR_MSG(extack, "Invalid nexthop flags in ancillary header");
> 		goto out;
> 	}
> ```
> 
> Where:
> 
> ```
> #define NEXTHOP_VALID_USER_FLAGS RTNH_F_ONLINK
> ```
> 
> So while the legacy nexthop code allows setting flags such as
> RTNH_F_OFFLOAD, the new nexthop code denies them. I don't have a use
> case for setting these flags from user space so I don't care if we allow
> or deny them, but I believe the legacy and new nexthop code should be
> consistent.
> 
> WDYT? Should we allow these flags in the new nexthop code as well or
> keep denying them?
> 
>>  		goto err_inval;

I like the positive naming - RTNH_VALID_USER_FLAGS.

nexthop API should allow the OFFLOAD flag to be consistent; separate
change though.

