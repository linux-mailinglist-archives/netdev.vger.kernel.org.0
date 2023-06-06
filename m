Return-Path: <netdev+bounces-8573-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B6697249AC
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:00:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA29A280DC9
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1821B1ED39;
	Tue,  6 Jun 2023 17:00:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097F91ED33
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 17:00:18 +0000 (UTC)
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA0CE6B
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:00:14 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id 3f1490d57ef6-bad97da58adso8013974276.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 10:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1686070814; x=1688662814;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EAUpBuNTnTGrO5WVsKau3gBMMmAk0Rww8r/n1Kyyu0I=;
        b=wc6Mn3keAy+7G1PjM1d+pBBjHbNz5c65SDWg4Lvs7U1rhro6jc7H5bd3JoU8CTzgsB
         skrS7EumhtEGoNT+KVtzl+z/F+vVXwRjkmp63z/JV+G6CMmvILc+LGL7gBJlsQuVZ5gr
         b3rfXKOCIULvR+LcbmcE3ijJ20hhndBudYGL4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686070814; x=1688662814;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EAUpBuNTnTGrO5WVsKau3gBMMmAk0Rww8r/n1Kyyu0I=;
        b=ZJFpRqYw7ZOp4tKp9mwutMW9lI3jHjDanNhtJZa+h1WOXrRszb21I/iLpEglW5bRtB
         1DJmNs0+xC+2756yKGNE4tQe5ecMA1dC+QbR4izGMrHBM8BhWTye2TLEs/I9aPT1kFcm
         9Xn6VHn/T+eBsfOaVYp3WYxpsBtcaeorZkZGt3MZrVofqU5O0DWnd0ePKst2szbynXAg
         6y/apo8N5Z1yEYqw1cm+1HwLLz+hqDgn1Thzl2uTgOwJ+fZToTzzMaWJS6euETu9wac2
         07PPaGm7r1GlKVKbchQZr39hAQ9raE/1MWbMZGXmgVoJWWJK52//+0Iz/dOXOabH4RGI
         7jAw==
X-Gm-Message-State: AC+VfDzj6KvwSk7/Z23Fi9Lf0MHmQ8fUw9omgW7hZrPy2ZBOAWLYF06G
	cbSp5BJYhhS541iBc+mmkWQJug==
X-Google-Smtp-Source: ACHHUZ4w0SzbcYNn7pjNby9uGI49Si9UZ0qhcP6tTyt0xNm5ZODd3JWvaJe9H0WCcFFp+0vjINE5uw==
X-Received: by 2002:a0d:db93:0:b0:562:6c0:c4d3 with SMTP id d141-20020a0ddb93000000b0056206c0c4d3mr3491407ywe.13.1686070813687;
        Tue, 06 Jun 2023 10:00:13 -0700 (PDT)
Received: from [192.168.2.144] ([169.197.147.212])
        by smtp.gmail.com with ESMTPSA id d69-20020a814f48000000b00568bc0bbf8esm4170481ywb.71.2023.06.06.10.00.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 10:00:13 -0700 (PDT)
Message-ID: <261910e6-cc21-ac27-e275-12baf67ef5ea@cloudflare.com>
Date: Tue, 6 Jun 2023 12:00:11 -0500
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
To: Neal Cardwell <ncardwell@google.com>, Eric Dumazet <edumazet@google.com>
Cc: Jason Xing <kerneljasonxing@gmail.com>,
 Stephen Hemminger <stephen@networkplumber.org>, netdev@vger.kernel.org,
 kernel-team@cloudflare.com
References: <20230605203857.1672816-1-mfreemon@cloudflare.com>
 <20230605154229.6077983e@hermes.local> <20230605154430.65d94106@hermes.local>
 <CAL+tcoBSc51N_cx5AozpKVeN=7u81i_nYcvn6rOUPyVrsevwLA@mail.gmail.com>
 <dfeec14e-738a-bd04-05b4-70a139867ea5@cloudflare.com>
 <CANn89iJs92TW-FEw0rkp4=z1tbfEYjP9bin281d+SU5Cya2xxw@mail.gmail.com>
 <CADVnQy=nuKiVgCG2U+8e2S1Tr5iX1QnD=au39+EBPVXB7J0TQQ@mail.gmail.com>
From: Mike Freemon <mfreemon@cloudflare.com>
In-Reply-To: <CADVnQy=nuKiVgCG2U+8e2S1Tr5iX1QnD=au39+EBPVXB7J0TQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/6/23 10:35, Neal Cardwell wrote:
> On Tue, Jun 6, 2023 at 11:33 AM Eric Dumazet <edumazet@google.com> wrote:
>>
>> On Tue, Jun 6, 2023 at 5:17 PM Mike Freemon <mfreemon@cloudflare.com> wrote:
> ...
>>> I discuss the RFCs in more detail in my blog post here:
>>> https://blog.cloudflare.com/unbounded-memory-usage-by-tcp-for-receive-buffers-and-how-we-fixed-it/
>>
>> Mike, the usual process to push linux patches is to make them self contained.
>>
>> changelog should be enough, no need to read a lengthy blog post.
>>
>> Also, I did not receive a copy of the patch, which is unfortunate,
>> given I am the linux TCP maintainer.
>>
>> Next time you post it, make sure to CC me.
>>
>> Thanks.
> 
> Also, before the repost, can you please rebase  on to the latest
> net-next branch? The patch does not currently apply to the latest
> net-next tree. Thanks!

I just posted "v2", which applies successfully on net-next.

