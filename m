Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35FF42E89C
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 07:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhJOGAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 02:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbhJOGAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 02:00:43 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BD5C061760;
        Thu, 14 Oct 2021 22:58:37 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id t16so33495645eds.9;
        Thu, 14 Oct 2021 22:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p5xn5pzNkUwMt65ulpDvl82UfebPrZ4ckvdDqReUMOk=;
        b=SpAtvtToe+gzCfhaDEb9v0so8VOMg7Q+GvmwJfyn+JhqtyT9wHYEZjxd6ccJRGGBkB
         /mC7S/w+FQkjPn6o+D+PwfPUI17mJVQj+2J7eVybj4Gz4wu/CJLRdPFxr3Y8rdFqqJOX
         LQC3KQnEU+l7YisESuDbvepEswezswRxUW8zVMJx2K0FVxDiwBN/Ck6WhaTXvH1AZ3fN
         VtbkTHzugvVkMv8J7g/Al5dwqDOh2XRNkabKffkuDTxW6RQY5FMZiRrstIhyPvnQ5nL3
         VkG8rbAUDjCNLxMAQwXvrJ2XWYpBQh1C6Km1ragyVyY2CKjECbwvq+GfC3zzAbKrQ3Bu
         4xBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p5xn5pzNkUwMt65ulpDvl82UfebPrZ4ckvdDqReUMOk=;
        b=wqbTJDtUxTVXxpKlXsbc/kZSk2mpVNwp8DRqaOAVsJ37EAJbJMF93FrDdjrwspTgdO
         Yl2wbQY+WbAtE8i8SqCHJIRMgUK04k+Ye0atbvKNLxz5d1mzqa/lJj2RuaK32HT/NyXM
         JlHF/BCjHoYqdo9HXXlq5Z5Vmlo3J50pboGrQ6HDOBGi7SwFjNW5qjTOrl+a1G0MIdEq
         0oknbxeNYnbAV7Lln/lSq3K9wYHysfrk7ygED9IE8LVRpOrX9GZnsG1S6d8ZlRkgNbdt
         Db1COvG5dPz2t+QHlNx2vskk4Y/hYOlKBGqJx7j8tEeia1HOXHEUk9KOo/TsLvGAcmr8
         P57g==
X-Gm-Message-State: AOAM530zf+SMqENxCiIH24G99aLvuVTLWt8jfmieqfmxEKisXYTqu4KG
        3Hv/zejoUIUqNwFCCuFKGMTDjVw1byjovDkq
X-Google-Smtp-Source: ABdhPJyB+vQV6j9yifRtEwxirspvDj3fHc69zNWnsoDm3Pl0Yvh4UknHYt8bczGvzkchX9n0Na4RWw==
X-Received: by 2002:a05:6402:5249:: with SMTP id t9mr15138687edd.135.1634277516089;
        Thu, 14 Oct 2021 22:58:36 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3800:a29:9110:6b9c:9e9e? ([2a04:241e:501:3800:a29:9110:6b9c:9e9e])
        by smtp.gmail.com with ESMTPSA id lb20sm3415402ejc.40.2021.10.14.22.58.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 22:58:35 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] selftests: nettest: Add --{do,no}-bind-key-ifindex
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1634107317.git.cdleonard@gmail.com>
 <122a68cd7fd28e9a5580f16f650826437f7397a1.1634107317.git.cdleonard@gmail.com>
 <133b490a-29a2-aa40-37bf-aef582f2028f@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <c9c5ce5c-b81e-9dd9-c689-247691fe4249@gmail.com>
Date:   Fri, 15 Oct 2021 08:58:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <133b490a-29a2-aa40-37bf-aef582f2028f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/21 5:25 PM, David Ahern wrote:
> On 10/13/21 12:50 AM, Leonard Crestez wrote:
>> @@ -1856,10 +1870,14 @@ static void print_usage(char *prog)
>>   	"    -n num        number of times to send message\n"
>>   	"\n"
>>   	"    -M password   use MD5 sum protection\n"
>>   	"    -X password   MD5 password for client mode\n"
>>   	"    -m prefix/len prefix and length to use for MD5 key\n"
>> +	"    --no-bind-key-ifindex: Force TCP_MD5SIG_FLAG_IFINDEX off\n"
>> +	"    --do-bind-key-ifindex: Force TCP_MD5SIG_FLAG_IFINDEX on\n"
>> +	"        (default: only if -I is passed)\n"
> 
> a nit:
> just --bind-key-ifindex and --no-bind-key-ifindex
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>

That would be slightly confusing because it would be easy to assume that 
the default behavior is "--bind-key-ifindex".

Instead of using "--do-" as an intensifier I can use "--force-".

--
Regards,
Leonard
