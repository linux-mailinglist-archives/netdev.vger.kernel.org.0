Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C8F6B2875
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 16:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbjCIPM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 10:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbjCIPMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 10:12:03 -0500
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63A6F1873;
        Thu,  9 Mar 2023 07:08:45 -0800 (PST)
Received: by mail-pl1-f169.google.com with SMTP id u5so2279309plq.7;
        Thu, 09 Mar 2023 07:08:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678374516;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fb2e+/LBhqy1qArJcc0LH6ryiWZIF1fF20/FD4HTb9E=;
        b=Nzw+qYsoiLpcjx/iCN15I/JPFId5CEOwePPK//EI15ArTM21j4sdR0Cr4gYyis9I+S
         mAlWK2Gtiz7HRAaAWQRo4xKViUzf7XPH/oNbdgqR6FosSkI4oq0Ku+T/lUOI+wOYkcaW
         w8MkbuzdfkFtFmftxmquiUl+BUCApZDZ1eXvaRxJz8ob7EdgEEXDqM/erB6kjzG7MxeZ
         a1+91cGY+EwJfAN5oJsJUMuEPZnkd5tFxg+KXFA42iCNi92X4MVqfJWd3wUIqfZvUH+6
         YSYRdZK1uS8A6xtC4PLTF6v9Cq+816LT2AnKOvnMSN3xsbAXQF84ddmRz5GXHQauTssP
         AN9g==
X-Gm-Message-State: AO0yUKXgU+aiaPPkmlp6Va4xe/o8f/fly617EHgSsrpuZpwe8CrYRDnp
        pL57rQNwxV53O8YGylsoj/La+Sz+Fan62ezn
X-Google-Smtp-Source: AK7set9HIFqs2pqzNJARvvLaNtMgezBNiDy+vAdodjLCQk1oU8pDbz1QWsU6Humo4NY5SmTPXBpv+w==
X-Received: by 2002:a17:902:bb8c:b0:19b:c498:fd01 with SMTP id m12-20020a170902bb8c00b0019bc498fd01mr17089443pls.11.1678374516260;
        Thu, 09 Mar 2023 07:08:36 -0800 (PST)
Received: from [192.168.219.102] ([14.4.134.166])
        by smtp.gmail.com with ESMTPSA id x8-20020a1709027c0800b0019ce95b1319sm11675234pll.264.2023.03.09.07.08.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 07:08:35 -0800 (PST)
Message-ID: <e75d2a42-4154-e469-bbd7-9409471ab724@ooseel.net>
Date:   Fri, 10 Mar 2023 00:08:29 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next] net: stmmac: call stmmac_finalize_xdp_rx() on a
 condition
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
References: <20230308162619.329372-1-lsahn@ooseel.net>
 <ZAnh0TGtDkVUl/1m@corigine.com>
From:   Leesoo Ahn <lsahn@ooseel.net>
In-Reply-To: <ZAnh0TGtDkVUl/1m@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23. 3. 9. 22:40, Simon Horman wrote:
> On Thu, Mar 09, 2023 at 01:26:18AM +0900, Leesoo Ahn wrote:
>> The current codebase calls the function no matter net device has XDP
>> programs or not. So the finalize function is being called everytime when RX
>> bottom-half in progress. It needs a few machine instructions for nothing
>> in the case that XDP programs are not attached at all.
>>
>> Lets it call the function on a condition that if xdp_status variable has
>> not zero value. That means XDP programs are attached to the net device
>> and it should be finalized based on the variable.
>>
>> The following instructions show that it's better than calling the function
>> unconditionally.
>>
>>    0.31 │6b8:   ldr     w0, [sp, #196]
>>         │    ┌──cbz     w0, 6cc
>>         │    │  mov     x1, x0
>>         │    │  mov     x0, x27
>>         │    │→ bl     stmmac_finalize_xdp_rx
>>         │6cc:└─→ldr    x1, [sp, #176]
>>
>> with 'if (xdp_status)' statement, jump to '6cc' label if xdp_status has
>> zero value.
>>
>> Signed-off-by: Leesoo Ahn <lsahn@ooseel.net>
> Hi Leesoo,
>
> I am curious to know if you considered going a step further and using
> a static key.
>
> Link: https://www.kernel.org/doc/html/latest/staging/static-keys.html

Thank you for the review.

The function must be called for only XDP_TX or XDP_REDIRECT cases.
So using a static key doesn't look good and the commit message is not 
clear for 'why' as well.
I think that's why you suggested for using 'static key' by the latter 
reason.

I will edit the message and post v2 soon.

Best regards,
Leesoo
