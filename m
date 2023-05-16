Return-Path: <netdev+bounces-3074-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED245705569
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:49:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A89E5281527
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF6ED11C85;
	Tue, 16 May 2023 17:49:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35D6107BA
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 17:49:42 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42E5D870;
	Tue, 16 May 2023 10:49:29 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f4249b7badso104154555e9.3;
        Tue, 16 May 2023 10:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684259368; x=1686851368;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wkvfa6m0vdZwcF4M9a5fBUmhIWptPRDqhsXwfDMKgPY=;
        b=gzz2a/q9UY62WXhzjc23Wfn5th+xSv4XWhC0nMZya5qItV5OtlD8R/rJB8TuUzv1j8
         13xMc7kBGYSDAr9VR5AUGPSePnrwCGeyCwIbqejeQ+E6ThYSsZCAr8OFovYaFolriRzg
         wBVpGBiJymc2ZGYYL9fBhK+dAsqAWbuyYbsgDi8CI6izliI5MGeGCRZHe/5eLV6q0JRC
         A/I1zemVQm1LR5XJruCHtchZGZEQ1zluUrD8zW2aLsvoWObS6PGLgVeFsJMau3aUn5Gz
         H/GEKgrzQX1fZW1hzq6sSoB3jmc8p+RZsDgdVXipmU8fNmuRWJ/Xqe8DUPaB5htc+K7E
         KLPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684259368; x=1686851368;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wkvfa6m0vdZwcF4M9a5fBUmhIWptPRDqhsXwfDMKgPY=;
        b=Y7MCvNwXrGoA4bPTcIZ/rkE6jXAqKFneJdZYQfnRUd4f+laLs91YmI44O3p654x3HG
         S8T0/gbR0d+42gbJPlfO0Z5KkUo8GABe0EiGpfI9ubFICgSYgK95X5eH9QNNBjJ9c+Bt
         OJrSwhX3MHI7aIudbCUMiKmXUoSudQKlwJRR0RjHilHmbkB2tpkEeflE1NNpGO+uQYaH
         TmHgKxd3xcrP0eCHFUWUeSFTZBx+djzgqrep8VS6Vw9l3jklGQoat9TdHHaOhpjDO8jx
         VcpnfQ9bCWu5ifI0U2aSOPcBRRQ8wHgceGAirSaTooJMZtf1bxcpUWomlxU+e6dgGHwS
         PNew==
X-Gm-Message-State: AC+VfDw+xAj1g4p72rjpBrYeKRENtXUCAMJD8Uphcts0XtmntZ7/mIJI
	eiMePCV5v0QuAy2sbU0XMIDjx6JuXtE=
X-Google-Smtp-Source: ACHHUZ4o5Q8uceN/RNtS9Ztb6gw5AQEQbMSuJHRag/x36srETjUb6QNW4Ul66pt/eK16iuC/BYApTQ==
X-Received: by 2002:a7b:cd0f:0:b0:3f4:23df:c681 with SMTP id f15-20020a7bcd0f000000b003f423dfc681mr21939723wmj.12.1684259367754;
        Tue, 16 May 2023 10:49:27 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.233.10])
        by smtp.gmail.com with ESMTPSA id c22-20020a05600c0ad600b003f50876905dsm3057620wmr.6.2023.05.16.10.49.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 10:49:27 -0700 (PDT)
Message-ID: <e9527d98-b39e-74cc-026d-7ea2d7692a33@gmail.com>
Date: Tue, 16 May 2023 18:46:35 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 2/2] net/tcp: optimise io_uring zc ubuf
 refcounting
Content-Language: en-US
To: David Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com
References: <cover.1684166247.git.asml.silence@gmail.com>
 <bdbbff06f20c100c00e59932ffecbd18ad699f57.1684166247.git.asml.silence@gmail.com>
 <99faed2d-8ea6-fc85-7f21-e15b24d041f1@kernel.org>
 <CANn89i+Bb7g9uDPVmomNDJivK7CZBYD1UXryxq2VEU77sajqEg@mail.gmail.com>
 <d7edb614-3758-1df6-91b8-a0cb601137a4@kernel.org>
 <ee609e87-0515-c1f8-8b27-78572c81b1b4@gmail.com>
 <1182a9ae-8396-97d1-6708-b811ddd9d976@kernel.org>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1182a9ae-8396-97d1-6708-b811ddd9d976@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/16/23 15:37, David Ahern wrote:
> On 5/16/23 6:59 AM, Pavel Begunkov wrote:
>>
>>
>>> The one in net_zcopy_put can be removed with the above change. It's
>>> other caller is net_zcopy_put_abort which has already checked uarg is
>>> set.
>>
>> Ah yes, do you want me to fold it in?
>>
> 
> no preference.

I'll leave it for another patch then. It might be interesting
to try remove null checks for all *_zcopy_* helpers, but it didn't
feel right last time I tried.

-- 
Pavel Begunkov

