Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E374638C27
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 15:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiKYO2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 09:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiKYO2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 09:28:40 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09276EE2B
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 06:28:39 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id x5so7029799wrt.7
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 06:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lS8stYG6Frvb/BGcJu8YF7/dhbrkHyksUpy1OUW/W8o=;
        b=iLf+bm0YWyEWyekYREpUElP51zBlNPaWDVomF+ugXXNHI3HoMojdsP6OWb0Kxvp9Ql
         20w/dpa2zHvxucLayRJvwCeb2lun3jvwNqiyQMzC91Mq0xxEFkNg1ncxxZmJgGSrnoct
         X8OIjqy3UwAkHd7od/eH9KDYIM8FSEmDZLizmfC3p8KeDgALXR22qkMFcQ6y4PeKFynJ
         MiZp2L25QPylIW0RBjT5OXz6yiLQAUqnOriavIvmC4EolycVfTVv7TL3KRcsBDLqeK5n
         NIqpykWn2GPyycoRO+hr9tsclBO75uNdAyxfUH1ug6I7WIECa8CtQYGGXtfgvf/jOEJ1
         LIfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lS8stYG6Frvb/BGcJu8YF7/dhbrkHyksUpy1OUW/W8o=;
        b=pNi1Vo6soG4R54BekmiKwGVgoTureZ9NUvke4haeYvCjBT8eKjRi3ROUBqgVz09qCY
         aCGTCYv4J+YOV7iVRUo2oCbKc7ETgXO6RIK/ACuxk59A6eJc6ZFnq5Jk/6PNTtrf3lTE
         V9MiBCrLdgV/X6kIdCedSinLy6pv/4y77y49BJ1UoVq98C9eXh0e0kB9PK05KUSKpyQE
         WCsDmjOVqKVh+oEgaxqaw7QXLhCFD1t/OEVbOEfF2YcHs+VWlGnYNDWa8F1y5AYaKEww
         5DZKzHtnNlvtVBmpnhW8QEDsXKRftKcV7UkVp2K9x9bWwjkNpC0d6ajDc6Q0ZStVPevA
         5UlQ==
X-Gm-Message-State: ANoB5pnXWVILITSc09gpqykoUGhVNKAHpaWcQ0cmwXDCVOydUaNO95SW
        HhXTNOMuMp8tkm+qubSIL8GsOg==
X-Google-Smtp-Source: AA0mqf7/pzzluGnCKQmm11BgI3tTNO02+C6KE6GeTiLRxeEFih/UD+ZhHhtfmgjjuNIHGli1CuGCOw==
X-Received: by 2002:a5d:5187:0:b0:242:5ef:ce32 with SMTP id k7-20020a5d5187000000b0024205efce32mr2320626wrv.260.1669386517472;
        Fri, 25 Nov 2022 06:28:37 -0800 (PST)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id e5-20020a05600c4e4500b003b492753826sm5249548wmq.43.2022.11.25.06.28.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Nov 2022 06:28:36 -0800 (PST)
Message-ID: <2081d2ac-b2b5-9299-7239-dc4348ec0d0a@arista.com>
Date:   Fri, 25 Nov 2022 14:28:30 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v6 1/5] jump_label: Prevent key->enabled int overflow
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>
References: <20221123173859.473629-1-dima@arista.com>
 <20221123173859.473629-2-dima@arista.com>
 <Y4B17nBArWS1Iywo@hirez.programming.kicks-ass.net>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <Y4B17nBArWS1Iywo@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/25/22 07:59, Peter Zijlstra wrote:
> On Wed, Nov 23, 2022 at 05:38:55PM +0000, Dmitry Safonov wrote:
>> 1. With CONFIG_JUMP_LABEL=n static_key_slow_inc() doesn't have any
>>    protection against key->enabled refcounter overflow.
>> 2. With CONFIG_JUMP_LABEL=y static_key_slow_inc_cpuslocked()
>>    still may turn the refcounter negative as (v + 1) may overflow.
>>
>> key->enabled is indeed a ref-counter as it's documented in multiple
>> places: top comment in jump_label.h, Documentation/staging/static-keys.rst,
>> etc.
>>
>> As -1 is reserved for static key that's in process of being enabled,
>> functions would break with negative key->enabled refcount:
>> - for CONFIG_JUMP_LABEL=n negative return of static_key_count()
>>   breaks static_key_false(), static_key_true()
>> - the ref counter may become 0 from negative side by too many
>>   static_key_slow_inc() calls and lead to use-after-free issues.
>>
>> These flaws result in that some users have to introduce an additional
>> mutex and prevent the reference counter from overflowing themselves,
>> see bpf_enable_runtime_stats() checking the counter against INT_MAX / 2.
>>
>> Prevent the reference counter overflow by checking if (v + 1) > 0.
>> Change functions API to return whether the increment was successful.
>>
>> Signed-off-by: Dmitry Safonov <dima@arista.com>
>> Acked-by: Jakub Kicinski <kuba@kernel.org>
> 
> This looks good to me:
> 
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Thank you, Peter!

> What is the plan for merging this? I'm assuming it would want to go
> through the network tree, but as already noted earlier it depends on a
> patch I have in tip/locking/core.
> 
> Now I checked, tip/locking/core is *just* that one patch, so it might be
> possible to merge that branch and this series into the network tree and
> note that during the pull request to Linus.

I initially thought it has to go through tip trees because of the
dependence, but as you say it's just one patch.

I was also asked by Jakub on v4 to wait for Eric's Ack/Review, so once I
get a go from him, I will send all 6 patches for inclusion into -net
tree, if that will be in time before the merge window.

Thanks again for the review and ack,
          Dmitry
