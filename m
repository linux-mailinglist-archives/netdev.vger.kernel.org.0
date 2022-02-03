Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571F74A7E7D
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 04:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349247AbiBCDzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 22:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241223AbiBCDzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 22:55:15 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26FCC061401
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 19:55:14 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id c188so1690289iof.6
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 19:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kpElj1Mdw0oh4VOibcqkv91VHBtqWkDjauPtimTS0Rg=;
        b=Fp4mOkuSuINUIyjeG6+cuPHyV+SWDh6YB8TL2afU0deIZ0eYq0sO1jILvqSmHDwi2S
         l+GO813uA5s1PtRK3DNhTW9EubHtT45fo7DDrqVpdHVqUsCdvV736FGHjlecv7J/jb10
         YVuoeUtya+WpfuhC7ZwKZlG2j4a2QTOZjSN64g1FjCAmeCENGuXeM1ywHT3yTl+m67t7
         BQTBPC9LdmuRWsG0XwwebLwI2uOdgdWRA/qDP8ztEaVhOX24z5o3g4XLad4yVzyJ9jTF
         HPWWtPb1v3H6YyZ1GVWxhzfBsmTfUnkTFadzs7HY8SeqU6tyLSpR7qqjIJNVdTJ+UqUA
         tPEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kpElj1Mdw0oh4VOibcqkv91VHBtqWkDjauPtimTS0Rg=;
        b=md+JHWHdeuO2wxJM2R3MmbZ1KcFavUeFJ+sSjI7XMToyXzcimEhjRaPT43XL+P2N3Y
         46UluIowqjfJ8Q9EzIuYKZ22cfBuwhsKWKNErILHwEZa+XmLqDOWmQBESpkIqtr7oDRJ
         n4YzUUR/7UsrIIs8lPOzQQjH1Dm2E6gqeRI9MADZTdormH4tDQVn7hw/pZRRA5LJpeCM
         4LdaODcmTV6kfJ1jGUJr2jrxN9K1ZgQP4VKnliU5OtaB+XmplldAey5seRpjvx5l/5Pc
         tqzHKAIUWjXYEXbh57pPPi9qNaSnj91j37juiQrhDQ65DpuJj/43Dpo1Oq1XknyN52yu
         zh+A==
X-Gm-Message-State: AOAM533YK3tzhhSjV4GeQBrRV/t8kSpy4DYTv7otNImxbaDG31hrnqRB
        KJJxgoXS6zDAWMsZ4YSnpk0R8gYrq2I=
X-Google-Smtp-Source: ABdhPJyIeOZ+W8RV8tP++ad99vChTZmGTwVd1wZ34GRxSDiruLOQp2fN45K4MZfxgWs9m3iBwVOEog==
X-Received: by 2002:a6b:d812:: with SMTP id y18mr18087839iob.161.1643860510889;
        Wed, 02 Feb 2022 19:55:10 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:8870:ce19:2c7:3513? ([2601:282:800:dc80:8870:ce19:2c7:3513])
        by smtp.googlemail.com with ESMTPSA id q9sm15014511iop.30.2022.02.02.19.55.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 19:55:10 -0800 (PST)
Message-ID: <f160d981-4672-a8d1-a797-eaad75706458@gmail.com>
Date:   Wed, 2 Feb 2022 20:55:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH iproute2] iplink: add gro_max_size attribute handling
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>
References: <20220201232715.1585390-1-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220201232715.1585390-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/22 4:27 PM, Eric Dumazet wrote:
> diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> index 4109d8bd2c43640bee40656c124ea6393d95a345..583c41a94a8ec964779c1e3a8305be80e43907e7 100644
> --- a/ip/ipaddress.c
> +++ b/ip/ipaddress.c
> @@ -904,6 +904,11 @@ static int print_linkinfo_brief(FILE *fp, const char *name,
>  						   ifi->ifi_type,
>  						   b1, sizeof(b1)));
>  		}
> +		if (tb[IFLA_GRO_MAX_SIZE])
> +			print_uint(PRINT_ANY,
> +				   "gro_max_size",
> +				   "gro_max_size %u ",
> +				   rta_getattr_u32(tb[IFLA_GRO_MAX_SIZE]));
>  	}
>  
>  	if (filter.family == AF_PACKET) {

gso_max_segs only shows in detail mode; this change prints it only for
brief mode.
