Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FE6675DB3
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 20:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjATTLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 14:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjATTLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 14:11:44 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC918F7C9
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 11:11:37 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id bk16so5678943wrb.11
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 11:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4Q+aLB5M5/TtTEFhcMDlKLReVmNxD7MHhEY2/008DlU=;
        b=E7t1/+Gnjzurlpr/Yn6EkM1klgtAtjeaa9iuyyqal5uLsl85A71nsHcV5EA8YN/c4q
         ct0GFvERpjIf6/1GmvemEYA2IhVLf2RKXGH+Yjlse7avRmqkJD7QTI5CtfaPPsv89hFD
         vA9/8Q9vqMkQgmvhzWh4vc8uCppxObhEpllCqzrCMOl2z04M4K7K/fa09Ec97/lMaP24
         By/BW1aS2Meunp9N9i/Yctxn4l3KehCL1zD5DBQ8Maz0Hf65N2p1UX0h+q+1N8LdAikL
         i5HEU9sA9F2xfhaEObOuwpM7nCHcQo/OlFyWFs/9507UwOyn7Q9yV/aRkl4mGO5Kpb+u
         XuyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Q+aLB5M5/TtTEFhcMDlKLReVmNxD7MHhEY2/008DlU=;
        b=Egu+yBFJarfmqljqHsHwnomZLe9RH4eOr4Qk1Fncct59vPW23Pj6vEKyF8o07BPyJo
         gHfqwDSB6CDuIU+9XUaQmD0fwZE+OyM6UKRcK4OoTEiuAMeKtqutL74Yulhy0PmpuIru
         S+VkXVdiglkzBSU4gtVAOco0JdOtKF3EWZlni66bB0q9aPBqN/b0ix6//KU45Cg5i+/K
         VPh6JcEUTazAqFVFE22JTycGLuCivSnViw7hD3hPtORwutgF5QItJyRh1FFDml05Bi2N
         PwYA8GK6SwAiteoc6U2MMWx3dyQow22ilzi7V1/+bPnWtWgCTD00A5kZbkF4UaPgBtgb
         Tn3Q==
X-Gm-Message-State: AFqh2kqQhWMyrFqQZ9Q4mQZbZvFl81bfiFRlzuR4UjTwyZ5gJ5/VRMmw
        XFwq6ATkI7g1JIda7Np588zUlg==
X-Google-Smtp-Source: AMrXdXviftZrowwMMsIKfyvYN8fMTCkcpKAv8IP621sNth/hnoNpSvxsyCaL1+KiOgAfApfFgJXebA==
X-Received: by 2002:adf:eacd:0:b0:2bb:f4bf:e763 with SMTP id o13-20020adfeacd000000b002bbf4bfe763mr23954624wrn.51.1674241896145;
        Fri, 20 Jan 2023 11:11:36 -0800 (PST)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id g2-20020a5d4882000000b00286ad197346sm36404269wrq.70.2023.01.20.11.11.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 11:11:35 -0800 (PST)
Message-ID: <59125aa9-ad7c-93d7-1c48-63773fa5a82e@arista.com>
Date:   Fri, 20 Jan 2023 19:11:29 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 1/4] crypto: Introduce crypto_pool
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20230118214111.394416-1-dima@arista.com>
 <20230118214111.394416-2-dima@arista.com>
 <Y8kSkW4X4vQdFyOl@gondor.apana.org.au>
 <7c4138b4-e7dd-c9c5-11ac-68be90563cad@arista.com>
 <Y8pVojWNpvdYpH03@gondor.apana.org.au>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <Y8pVojWNpvdYpH03@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/20/23 08:49, Herbert Xu wrote:
> On Thu, Jan 19, 2023 at 06:03:40PM +0000, Dmitry Safonov wrote:
>>
>> - net/ipv4/ah4.c could benefit from it: currently it allocates
>> crypto_alloc_ahash() per every connection, allocating user-specified
>> hash algorithm with ahash = crypto_alloc_ahash(x->aalg->alg_name, 0, 0),
>> which are not shared between each other and it doesn't provide
>> pre-allocated temporary/scratch buffer to calculate hash, so it uses
>> GFP_ATOMIC in ah_alloc_tmp()
>> - net/ipv6/ah6.c is copy'n'paste of the above
>> - net/ipv4/esp4.c and net/ipv6/esp6.c are more-or-less also copy'n'paste
>> with crypto_alloc_aead() instead of crypto_alloc_ahash()
> 
> No they should definitely not switch over to the pool model.  In
> fact, these provide the correct model that you should follow.
> 
> The correct model is to allocate the tfm on the control/slow path,
> and allocate requests on the fast path (or reuse existing memory,
> e.g., from the skb).

Ok, I see. Do you think, it's worth having a pool of tfms?

If not, I can proceed with TCP-AO patches set and implement pool of
ahash tfms that will be used only for TCP-MD5 and TCP-AO, does that
sound good to you?

I see that ahash tfm allocation doesn't eat a lot of memory, rather
little more than 100 bytes, but even so, I don't see why not saving some
memory "for free", especially if one can have thousands of keys over
different sockets. Where there's not much complexity in sharing tfms &
scratch buffers?

Thanks,
          Dmitry
