Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A92921F8A7
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 19:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgGNR6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 13:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgGNR6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 13:58:31 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559E5C061755;
        Tue, 14 Jul 2020 10:58:31 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id w27so13474680qtb.7;
        Tue, 14 Jul 2020 10:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VuloyCeWpLKC7/IJ8lg+OQA+degQY2LL8KuudGaKn2Y=;
        b=g3ttcAMQu4oa5NjPnUih+1Jjkthdatih4lPUPBvS/XtkHr4bJMOfl8ZqMDHiUbyGBP
         dpwA+Hb3y6nI7azU4gS4KIiJJvFCSOJFIenX1eRF9cYoxI8XoXV/HEo8D+ycYbNi1lXE
         LG6KSIhWe3GR1QwKQnhaaUXxZspzJO/8sMytPUn4WGqMKuLgUXuHFFr7WyFCCtYtdYPo
         92sm5NJU+UKgSzbb5jQ7ey57CMX8m+ARX6oCqTWtvI/b/PIRZ7Te4wVbOGvh2BJITcW6
         NkxV3C6wURinS4mkwJ0wWQVFphjHpek502l2aY3gBqhYVCKPyWM263U57KxNa/5HlyY7
         6mQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VuloyCeWpLKC7/IJ8lg+OQA+degQY2LL8KuudGaKn2Y=;
        b=VgKdVZKkknzLYTSGh8J7hxKL7pobP7KqZa2LOsxCT/TWAFzaMZbBzC57HdGRcWLcMz
         I9ZPmcSnvwjrPlwLL2l3OJPaPoHPIOHhqXUI24fANJ/VNUjFKKEMiNSR15wJsXEaK6gO
         ozNC523gj/oa6g8qsDhq/8G5peuP/6fbSurG/67otBgwLF94FjdvL+uGJ+cVjGZ5EU39
         rCgmPAltuN9rkCuhCGaeKqR2+Z0JSHJLre/afZ/mQdZzZEE9iWpQ2MPps9ikZ/lmAYua
         XxDb4W8bF/ZloJms1Avul3gRVpNY4PhqjMZGNdlGoKQdypyafNuAjrtNIsHQGxScMuob
         VWEQ==
X-Gm-Message-State: AOAM5300RC0NYbE7LhSHzFnDZdYEBQaA0lnOsEpoPNjq/we9BJIx4F/x
        N0Yg7ZSFYTXsa7NByurjusfaotof
X-Google-Smtp-Source: ABdhPJw8e6A6hcQcCsFlZ/G7KYoUjsg50jBLwkeI8JeRsI5Qvax0xbsw4oHxKUTgn6AYYMMvqgruqA==
X-Received: by 2002:aed:2787:: with SMTP id a7mr6045594qtd.101.1594749510323;
        Tue, 14 Jul 2020 10:58:30 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:3884:8f6d:6353:cafd? ([2601:282:803:7700:3884:8f6d:6353:cafd])
        by smtp.googlemail.com with ESMTPSA id v134sm23609627qkb.60.2020.07.14.10.58.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 10:58:29 -0700 (PDT)
Subject: Re: [PATCH] selftests: fib_nexthop_multiprefix: fix cleanup() netns
 deletion
To:     Paolo Pisati <paolo.pisati@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200714154055.68167-1-paolo.pisati@canonical.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4437df59-b9e3-e52d-8e43-e4dd3eab3c21@gmail.com>
Date:   Tue, 14 Jul 2020 11:58:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200714154055.68167-1-paolo.pisati@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/14/20 9:40 AM, Paolo Pisati wrote:
> During setup():
> ...
>         for ns in h0 r1 h1 h2 h3
>         do
>                 create_ns ${ns}
>         done
> ...
> 
> while in cleanup():
> ...
>         for n in h1 r1 h2 h3 h4
>         do
>                 ip netns del ${n} 2>/dev/null
>         done
> ...
> 
> and after removing the stderr redirection in cleanup():
> 
> $ sudo ./fib_nexthop_multiprefix.sh
> ...
> TEST: IPv4: host 0 to host 3, mtu 1400                              [ OK ]
> TEST: IPv6: host 0 to host 3, mtu 1400                              [ OK ]
> Cannot remove namespace file "/run/netns/h4": No such file or directory
> $ echo $?
> 1
> 
> and a non-zero return code, make kselftests fail (even if the test
> itself is fine):
> 
> ...
> not ok 34 selftests: net: fib_nexthop_multiprefix.sh # exit=1
> ...
> 
> Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
> ---
>  tools/testing/selftests/net/fib_nexthop_multiprefix.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/fib_nexthop_multiprefix.sh b/tools/testing/selftests/net/fib_nexthop_multiprefix.sh
> index 9dc35a16e415..51df5e305855 100755
> --- a/tools/testing/selftests/net/fib_nexthop_multiprefix.sh
> +++ b/tools/testing/selftests/net/fib_nexthop_multiprefix.sh
> @@ -144,7 +144,7 @@ setup()
>  
>  cleanup()
>  {
> -	for n in h1 r1 h2 h3 h4
> +	for n in h0 r1 h1 h2 h3
>  	do
>  		ip netns del ${n} 2>/dev/null
>  	done
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
