Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210814537D8
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 17:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbhKPQnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 11:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234059AbhKPQnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 11:43:47 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7222C061746
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 08:40:50 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id o4so18661623pfp.13
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 08:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cxePJecZE2WrH9xlN/wiiMl9PdujliUhViJjtEXdKvM=;
        b=CjI6nPGXTaxn1IUbfuqmnU7jsgsOyaLVHes0gJhzOZ46AANKKa37G0+jgykyF0dKym
         FEYdNOgTSaNFbIQRbyJ9CFdCElqQ95aRRv/8SaKbW177/x4fdhTdC2LLjhav7FtDSiCq
         kKVvlBvAXDabF+3odlIj64NYQo9cwxjEkO/w7ZWm0VRdkX61bcEeGNgjfJhBxW1FXZJW
         8mvJkjYcqPnx1pBOaJ/HTx05g6gdMc19q8Lm4yOYxsWJAGrVZA413mS5GS3swKmwYKUg
         AR6kpkZ9ySGoV2ZnJRU6RHBHdoNsJ4/WQPaVakiM9hslKLFtvs03ofnjXcXkwgE4JhPP
         Qxaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cxePJecZE2WrH9xlN/wiiMl9PdujliUhViJjtEXdKvM=;
        b=e6JggV0/GmZAS1U+J5HfJLkSyEU7Tkc1kDG0jhdTiCU/oa3J8objIlO64AsE61BsjB
         GW2w+3uU5Fcgo7/4Wje0JbVw73i4DAHLecLhnT+TbVAl4WC1H7mT5J7ahI8qC3/JNadB
         OXxVTj6H69abOu1gcQpJqyTdVj21aUFHbD2phJx/4uYFENM3bWLsfbOz5OaV9Rwm3UX2
         6LAOa7Lkmxu9DdTv+6SRnvCad5uAfC9qra46lMREKd7+8n8LIANitJbFLsbI8GmXyYKc
         /IA/Mcj7uQWXSqti4++Yd1GLedMpCGkrD7WR3UW1v+L0VTYMmiox7Wmkpcv4ohzLyd68
         k3oA==
X-Gm-Message-State: AOAM533k9U+3c91b2o3UV9gSGTRPKlcEs2pWSOkMBUTuZALHnRGFNEH4
        HWwFB8KXXCpfzuO5AiuV0WlPcA==
X-Google-Smtp-Source: ABdhPJx1VgKF3eHPsymFLYS3ut78yITSt0gbbo3PvB3yrcy/kif0ctGWaMIcQM8nAiTCtSHwoZFYjg==
X-Received: by 2002:a05:6a00:a8e:b0:480:ab08:1568 with SMTP id b14-20020a056a000a8e00b00480ab081568mr41832261pfl.28.1637080850233;
        Tue, 16 Nov 2021 08:40:50 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id h25sm14182861pgm.33.2021.11.16.08.40.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 08:40:50 -0800 (PST)
Message-ID: <a0baf2b6-70f9-3185-cd92-d83533c63ff0@linaro.org>
Date:   Tue, 16 Nov 2021 08:40:49 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] tipc: use consistent GFP flags
Content-Language: en-US
To:     patchwork-bot+netdevbpf@kernel.org,
        "David S. Miller" <davem@davemloft.net>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20211111205916.37899-2-tadeusz.struk@linaro.org>
 <163698120846.10163.14371622974741533436.git-patchwork-notify@kernel.org>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <163698120846.10163.14371622974741533436.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/21 05:00, patchwork-bot+netdevbpf@kernel.org wrote:
> This patch was applied to netdev/net.git (master)
> by David S. Miller<davem@davemloft.net>:
> 
> On Thu, 11 Nov 2021 12:59:16 -0800 you wrote:
>> Some functions, like tipc_crypto_start use inconsisten GFP flags
>> when allocating memory. The mentioned function use GFP_ATOMIC to
>> to alloc a crypto instance, and then calls alloc_ordered_workqueue()
>> which allocates memory with GFP_KERNEL. tipc_aead_init() function
>> even uses GFP_KERNEL and GFP_ATOMIC interchangeably.
>> No doc comment specifies what context a function is designed to
>> work in, but the flags should at least be consistent within a function.
>>
>> [...]
> Here is the summary with links:
>    - tipc: use consistent GFP flags
>      https://git.kernel.org/netdev/net/c/86c3a3e964d9
> 
> You are awesome, thank you!

Thanks, you are awesome too! ;)
Any feedback about the patch:
[PATCH v2] tipc: check for null after calling kmemdup

-- 
Thanks,
Tadeusz
