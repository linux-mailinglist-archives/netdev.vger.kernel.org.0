Return-Path: <netdev+bounces-8528-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8B0772476B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:17:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C46A280FE4
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 994BB2D254;
	Tue,  6 Jun 2023 15:17:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5E237B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:17:33 +0000 (UTC)
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D848F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:17:30 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-565c9109167so57638727b3.2
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 08:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1686064649; x=1688656649;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9loeQHKWzV93BGBF3GegCLyqkHQdu0tsL19+sq2TLXc=;
        b=yFVee+IOohFZYK/jCsXrJW+yi/aqG5uU27qtGKoLru8ptaWlmtJJzEzJ1lmyfNDnsw
         tUpKMhW4uBGhZGPWVRFJCHlS5ecAntkf+Vs4bF5qOlEF/IgAOUNSKcI8MPYDD1Pleq/1
         8cJ20N30l1C/9xkMS6vxCqggs60rmB40R0ZQQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686064649; x=1688656649;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9loeQHKWzV93BGBF3GegCLyqkHQdu0tsL19+sq2TLXc=;
        b=hWygsP+W70wOJtv3myWOjoSwhLie7srbMq1PE/3jM2sfKhDWruk5GPbyHlfXtIu6SU
         2qIV5Ob2nfq7G23njZGoKduYV3L83CiaaY8qV93FgnKVybjEKqbhqXQ6q31+ZIp/AHBU
         g60ejppxn5OJ5ZxdUU5towVeIs2oihhzdywd/zV53jliK6TrXEpAYBKq+FS9cMdTB/u7
         9OYgPpYCKksdGBw/CdY4mRCrrJmvyBvAEjSQAVEc5qtAQvcbU2qqFInNW9uNWzBKlEZW
         Ts0CqB1Yggk2JcPh4efFX0sFmKZku4Y6EoeFjxzjks7ytqCmcUoMDm70kxrTUCjUBTJo
         HvlA==
X-Gm-Message-State: AC+VfDwQZHemZUtBNcnhcHT0Ps5tCj2Lnq8iRXZMUJvprhIdSj48i6TL
	xI8t8qEs3inO9WnsAWHQVJVP+UCg7F2mn2k9Hsk5Og==
X-Google-Smtp-Source: ACHHUZ7ppZNNOpiAF+cDhuBVPmrJDUAnif8L1SKyPRnyOz8ZQMryud59a6Qu+ecKvnsx9ybbmtrE3A==
X-Received: by 2002:a0d:ea50:0:b0:569:74f4:364 with SMTP id t77-20020a0dea50000000b0056974f40364mr2338111ywe.0.1686064649588;
        Tue, 06 Jun 2023 08:17:29 -0700 (PDT)
Received: from [192.168.2.144] ([169.197.147.212])
        by smtp.gmail.com with ESMTPSA id s11-20020a81bf4b000000b00555df877a4csm4048986ywk.102.2023.06.06.08.17.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 08:17:29 -0700 (PDT)
Message-ID: <dfeec14e-738a-bd04-05b4-70a139867ea5@cloudflare.com>
Date: Tue, 6 Jun 2023 10:17:28 -0500
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] Add a sysctl to allow TCP window shrinking in order to
 honor memory limits
Content-Language: en-US
To: Jason Xing <kerneljasonxing@gmail.com>,
 Stephen Hemminger <stephen@networkplumber.org>,
 Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>
Cc: netdev@vger.kernel.org, kernel-team@cloudflare.com
References: <20230605203857.1672816-1-mfreemon@cloudflare.com>
 <20230605154229.6077983e@hermes.local> <20230605154430.65d94106@hermes.local>
 <CAL+tcoBSc51N_cx5AozpKVeN=7u81i_nYcvn6rOUPyVrsevwLA@mail.gmail.com>
From: Mike Freemon <mfreemon@cloudflare.com>
In-Reply-To: <CAL+tcoBSc51N_cx5AozpKVeN=7u81i_nYcvn6rOUPyVrsevwLA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 6/5/23 21:09, Jason Xing wrote:
> On Tue, Jun 6, 2023 at 6:44 AM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
>>
>> On Mon, 5 Jun 2023 15:42:29 -0700
>> Stephen Hemminger <stephen@networkplumber.org> wrote:
>>
>>>> sysctl: net.ipv4.tcp_shrink_window
>>>>
>>>> This sysctl changes how the TCP window is calculated.
>>>>
>>>> If sysctl tcp_shrink_window is zero (the default value), then the
>>>> window is never shrunk.
>>>>
>>>> If sysctl tcp_shrink_window is non-zero, then the memory limit
>>>> set by autotuning is honored.  This requires that the TCP window
>>>> be shrunk ("retracted") as described in RFC 1122.
>>>>
>>>> [1] https://www.rfc-editor.org/rfc/rfc7323#appendix-F
>>>> [2] https://www.rfc-editor.org/rfc/rfc7323#section-2.4
>>>> [3] https://www.rfc-editor.org/rfc/rfc1122#page-91
>>>> [4] https://www.rfc-editor.org/rfc/rfc793
>>>> [5] https://www.rfc-editor.org/rfc/rfc1323
>>>>
>>>> Signed-off-by: Mike Freemon <mfreemon@cloudflare.com>
>>>
>>> Does Linux TCP really need another tuning parameter?
>>> Will tests get run with both feature on and off?
>>> What default will distributions ship with?
>>>
>>> Sounds like unbounded receive window growth is always a bad
>>> idea and a latent bug.
>>
>> FYI - I worked in an environment where every bug fix had to have
>> a tuning parameter to turn it off. It was a bad idea, driven by
>> management problems with updating. The number of knobs lead
>> to confusion and geometric growth in possible code paths.
>>
> 
> I agree. More than this, shrinking window prohibited in those classic
> RFCs could cause unexpected/unwanted behaviour.

I discuss the RFCs in more detail in my blog post here:
https://blog.cloudflare.com/unbounded-memory-usage-by-tcp-for-receive-buffers-and-how-we-fixed-it/

