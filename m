Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848FB69795E
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 10:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbjBOJ6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 04:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234113AbjBOJ6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 04:58:23 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB0A2C663
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 01:58:22 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id jg8so46795728ejc.6
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 01:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zvp5TiTXmFozIUBvtJkHfp55Ffpf/VpEvd3WlMDbSqA=;
        b=BhmNhmiW93H9hyV7PN+u9F2Ykap25vKeDfwFNUTPfoJN/SrqbKsBxhNJGMaKtZ0/uC
         wd1A/2NKuKzofgZPZVKy1wSkTD1kpb0QHZY+eNlAk5RLn5l4SMorKOQCNQnYd7ZxnQOY
         vgpneIoxhry+3L6BThzWO0OIwUHiAvIfQYrNg3hKakxtDaRsxaZYfmoJETU2J11jWsmb
         bmy1vT1o798ptm59xEOUi7z3m1spRdAm/La8eD+/9d9950r5yNtM1bu3oSGjqMSDrJ6h
         1zVMio+CYchnf5x6W+WZ1XT5Q3f8y6MzbadVdVO8P/m6UGGFKgjQDQM0fSVsDQgRhqg0
         72Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zvp5TiTXmFozIUBvtJkHfp55Ffpf/VpEvd3WlMDbSqA=;
        b=SEECK8sGmKt8XD8EYaCYToM5ArEvmZ2ftEEl+szutzqKfvzUhdFLoKASROvNpaZdc1
         h13oQ/Y3VcdeosbxN8AlSE/ep+bq3zJsw3kSVxRXih5Y/YlhXguMB9yb8dCB0YwezR7B
         toHLeEPnn5Pzg+ucKt66lQOVqb/fQFgTYr2Wya4v9J0IaYP0pYRxaFg+DhJDEbRnQWEX
         lmtWnsG70CZdysDWe1o2MQDKcLUeAdTRP3dCkA5BuLA+dPtWQCUdTp4rug9LoPyvu711
         h5ydwpBlOXckS/j5G6UG0t2R73kh8ThIzEzRx6cnQdQjYaaDu9aFyngEqZxMvZayILXb
         OIWw==
X-Gm-Message-State: AO0yUKVs7SRNObAlUSzmHiDCOqIPuYkvHJuIpBRX25OmkxHHroeXhisA
        /cmRZDDz1RElqhkLi+pUG0kuG37SUqv6Uskun0kTu0yE
X-Google-Smtp-Source: AK7set/KqsGVMBctM8fOnPBnwDFPuGHu9mE/evGkl6u98h2/AEAJyTkyrcseZ9hyx33DnqULx/ac2A==
X-Received: by 2002:a17:907:78d3:b0:8b0:c7aa:3b53 with SMTP id kv19-20020a17090778d300b008b0c7aa3b53mr1334848ejc.70.1676455101381;
        Wed, 15 Feb 2023 01:58:21 -0800 (PST)
Received: from [10.44.2.5] ([81.246.10.41])
        by smtp.gmail.com with ESMTPSA id sd8-20020a170906ce2800b008b14720ac80sm493082ejb.100.2023.02.15.01.58.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 01:58:21 -0800 (PST)
Message-ID: <a7331a33-fc1f-f74b-4df6-df9483c81125@tessares.net>
Date:   Wed, 15 Feb 2023 10:58:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH bpf] selftests/bpf: enable mptcp before testing
Content-Language: en-GB
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Felix Maurer <fmaurer@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>
References: <20230210093205.1378597-1-liuhangbin@gmail.com>
 <6f0a72ee-ec30-8c97-0285-6c53db3d4477@tessares.net>
 <Y+m4KufriYKd39ot@Laptop-X1>
 <19a6a29d-85f3-b8d7-c9d9-3c97a625bd13@tessares.net>
 <Y+r78ZUqIsvaWjQG@Laptop-X1> <78481d57-4710-aa06-0ff7-fee075458aae@linux.dev>
 <Y+xU8i7BCwXJuqlw@Laptop-X1>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <Y+xU8i7BCwXJuqlw@Laptop-X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hangbin, Martin,

On 15/02/2023 04:43, Hangbin Liu wrote:
> On Tue, Feb 14, 2023 at 11:22:58AM -0800, Martin KaFai Lau wrote:
>> On 2/13/23 7:11 PM, Hangbin Liu wrote:
>>> On Mon, Feb 13, 2023 at 05:28:19PM +0100, Matthieu Baerts wrote:
>>>> But again, I'm not totally against that, I'm just saying that if these
>>>> tests are executed in dedicated netns, this modification is not needed
>>>> when using a vanilla kernel ;-)
>>>>
>>>> Except if I misunderstood and these tests are not executed in dedicated
>>>> netns?
>>>
>>> I tried on my test machine, it looks the test is executed in init netns.
>>
>> The new test is needed to run under its own netns whenever possible. The
>> existing mptcp test should be changed to run in its own netns also. Then
>> changing any pernet sysctl (eg. mptcp.enabled) is a less concern to other
>> tests. You can take a look at how other tests doing it (eg. decap_sanity.c).
> 
> Thanks for the reference. I will update the patch to make mptcp run in it's
> own netns.

Thank you both for your replies!

Yes, that would be good to have this test running in a dedicated NS.

Then mptcp.enabled can be forced using write_sysctl() or SYS("sysctl (...)".

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
