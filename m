Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C69632E3E
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiKUU43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiKUU41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:56:27 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46D3CB9EA
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:56:26 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id x5so17590992wrt.7
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=10ZFDYKk9wd8fhHDK1Vm52v8Semrqv5fRbpaid+M4YA=;
        b=R8JSwsmRVbWCIMp9M5gvqtgEgMpviBk8m4IsOB7SXT+eTmlQKusM9LqMirWTs500Tp
         QEpgbQgat9JmCU00yIc22n5Pu3f0KH3p+X9HkCQwfCzGNHwwdXfpQp2Sjkj3c6TlS1jj
         vjLuiYV+iFcuwdIMmUK8oIrTa+nyCh/OQa5uSOr2U5FBYkFk5QlRpQyhvINJF0lB7n28
         dKPGiCkpzhNuL5b+HL+3ktCTAvYM5+S9hzAF2+4URS5tYkqCBEaWia4/QDT5z26u21rW
         IVn8yZ1xc2RMM4jbiFTc0DTBUYmlZrih70b4cK8ThWXObm+pztrSWv0gQVTeDKwQ0beT
         aPdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=10ZFDYKk9wd8fhHDK1Vm52v8Semrqv5fRbpaid+M4YA=;
        b=LA7eXBM5Wwz1igfWJsxNpwnQhdfK24MaWLVjcW64oAmnArJK24kJO6UGaNR6nFYgOS
         HmKkt27uiNKY8RpNrpyMquHO3VPwdQaUazrq2+ajPM2BGO9GqWPAsWnarKfqPvPHJ4sZ
         xbkq9rBboOlv7yDxcjkxyj1JcknuAg8Kk00cCy+AQOaNiCeLsSSGB19xgyPTkkFpeFvs
         +nibL4rhLq1lP6Tn/wAloE7rAukKYOHpIum+vDhRpPu0sOtw+TXDNzJ3iM51GT5GiI3p
         RCLC8rwmp5wF6bq1nOWbxo2sy+hqcn7y12dRPKV+nVpKYIP6hypYMI2LFtShC/2AiINt
         pHJQ==
X-Gm-Message-State: ANoB5pkcNNJdxkKoFh/BPPQ6sShkaRwHItF+ugOHbUOpZ4w0Jwfd9NTS
        L+zaxyAFIBQXoFU8n1gqoL0qgg==
X-Google-Smtp-Source: AA0mqf4RtlTjv2eCjVrSOUe5JmgekERpj1i3MVvlxgNrkMOtVQRW3ItFmEW8x/Zbvd91kyHnlQ1O0g==
X-Received: by 2002:a5d:5685:0:b0:235:f0a6:fafd with SMTP id f5-20020a5d5685000000b00235f0a6fafdmr12435195wrv.75.1669064185170;
        Mon, 21 Nov 2022 12:56:25 -0800 (PST)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id f16-20020a5d50d0000000b00235da296623sm12109359wrt.31.2022.11.21.12.56.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 12:56:24 -0800 (PST)
Message-ID: <5c899a02-cec1-07c9-1c1a-8747773ece0c@arista.com>
Date:   Mon, 21 Nov 2022 20:56:18 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v4 3/5] net/tcp: Disable TCP-MD5 static key on
 tcp_md5sig_info destruction
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
References: <20221115211905.1685426-1-dima@arista.com>
 <20221115211905.1685426-4-dima@arista.com>
 <20221118191809.0174f4da@kernel.org>
 <31efe48a-4c68-f17c-64ee-88d45f56c438@arista.com>
 <20221121124135.4015cc66@kernel.org>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <20221121124135.4015cc66@kernel.org>
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

On 11/21/22 20:41, Jakub Kicinski wrote:
> On Mon, 21 Nov 2022 20:31:38 +0000 Dmitry Safonov wrote:
>>> Maybe it wouldn't be 
>>> the worst move to provide a sk_rcu_dereference() or rcu_dereference_sk()
>>> or some such wrapper.
>>>
>>> More importantly tho - was the merging part for this patches discussed?
>>> They don't apply to net-next.  
>>
>> They apply over linux-next as there's a change [1] in
>> linux-tip/locking/core on which the patches set based.
>>
>> Could the way forward be through linux-tip tree, or that might create
>> net conflicts?
> 
> Dunno from memory, too much happens in these files :S
> 
> Could you cherry-pick [1] onto net-next and see if 
> 
>   git am --no-3way patches/*
> 
> goes thru cleanly? If so no objections for the patches to go via tip,
> we're close enough to the merge window.

That did go cleanly for me on today's net-next/main.

>> I'll send v5 with the trivial change to rcu_dereference_protected()
>> mentioned above.

Thanks,
          Dmitry
