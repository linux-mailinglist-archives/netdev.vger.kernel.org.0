Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133C838B998
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 00:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhETWrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 18:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhETWrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 18:47:36 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3293EC061574;
        Thu, 20 May 2021 15:46:12 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id n17-20020a7bc5d10000b0290169edfadac9so6329783wmk.1;
        Thu, 20 May 2021 15:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jZ8b9uIzmHw1BsqRLjKNK/1NTGzSa2HXvmJMPRWZ25A=;
        b=uC5DotBV8MAOeL0un17S4ig29m7QXgYG5Z+bkw7kGbjlA3QMOm1cZ/6YYkZyjP7AYN
         qI8MDReQCNVIh9Wmft87Z9T3rXHCfmTp3iQ1qafoJ24ztBaDtMnXeNp7MwlvVGUKS2pZ
         e0t1xW753pJXBHRRnIK3ySltrYh0VyaCUZ1B/iG8Qo9Q+Mlf8OR9g4HR6q/IVNygKrZl
         yUY6ekMVLwk3bYN4SkOndcm4puSJ843GaGyTeDEavU/wRtqJ6yzeiT/GK0Cdo47E6mZy
         5U1LcaLr1bfAx7q+hNEh9SwpS9H5/y3K+LLYRxeKMv+LUe2myoc6TicaxhRIlPUH6uX9
         la+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jZ8b9uIzmHw1BsqRLjKNK/1NTGzSa2HXvmJMPRWZ25A=;
        b=sf/5WQZ6p0C2K+u0Dnfot0I2anWKyld11LO2/zG2QI9ffY/ei6xfpqaYQqAbQ9pugO
         0LKKZ1dD+qpDh2Oz1oPHVoy8pt8UONtYJWIhx4vngtNuiDQBP+VjFL4dJ4wDvFDqbrwH
         MRjHMTBMPPhpcUTjpFQEIkJOb1NUtNcaFjej0Cos2HuF3xOCqugSV4NyZfD3hCIMvUmJ
         HYsOtArkTeLERBtOu0mMOn9mfMfwYJrFS/376anTQ2HWUm4j1FO6u2+pUEV84PVAKgDr
         9dmILiLmGmldnzvJ7h06dYigwn6pnwjZLezO6Y2EPz6TbzW/sETppb5y2OoYdRHbVHmo
         6l3w==
X-Gm-Message-State: AOAM531bYcPDn8BqyrnzVWFCdxzBbnN9LD+0EL1zW7deCmz0E96vsxjn
        P2p+c7abhNze46w0AbTueV4=
X-Google-Smtp-Source: ABdhPJw0/lT6f/EBAdYYoa8vrlKdb6jvOZaV6h5LdRq0rrHMJlS+gwHDt67F7quhHDTuL23c5TP6Vw==
X-Received: by 2002:a7b:cb45:: with SMTP id v5mr5866848wmj.48.1621550770788;
        Thu, 20 May 2021 15:46:10 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.182])
        by smtp.gmail.com with ESMTPSA id t5sm4784634wmi.32.2021.05.20.15.46.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 15:46:10 -0700 (PDT)
To:     Song Liu <songliubraving@fb.com>
Cc:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
References: <cover.1621424513.git.asml.silence@gmail.com>
 <485abb65cf032f4ddf13dcc0bd60e5475638efc2.1621424513.git.asml.silence@gmail.com>
 <0339DB35-27AC-4A50-B807-968C72ABB698@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 01/23] io_uring: shuffle rarely used ctx fields
Message-ID: <45a6f8f9-7abf-f513-e872-c346a682e373@gmail.com>
Date:   Thu, 20 May 2021 23:46:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <0339DB35-27AC-4A50-B807-968C72ABB698@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/20/21 10:46 PM, Song Liu wrote:
>> On May 19, 2021, at 7:13 AM, Pavel Begunkov <asml.silence@gmail.com> wrote:
>> There is a bunch of scattered around ctx fields that are almost never
>> used, e.g. only on ring exit, plunge them to the end, better locality,
>> better aesthetically.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>> fs/io_uring.c | 36 +++++++++++++++++-------------------
>> 1 file changed, 17 insertions(+), 19 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 9ac5e278a91e..7e3410ce100a 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -367,9 +367,6 @@ struct io_ring_ctx {
>> 		unsigned		cached_cq_overflow;
>> 		unsigned long		sq_check_overflow;
>>
>> -		/* hashed buffered write serialization */
>> -		struct io_wq_hash	*hash_map;
>> -
>> 		struct list_head	defer_list;
>> 		struct list_head	timeout_list;
>> 		struct list_head	cq_overflow_list;
>> @@ -386,9 +383,6 @@ struct io_ring_ctx {
>>
>> 	struct io_rings	*rings;
>>
>> -	/* Only used for accounting purposes */
>> -	struct mm_struct	*mm_account;
>> -
>> 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
>> 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
>>
>> @@ -409,14 +403,6 @@ struct io_ring_ctx {
>> 	unsigned		nr_user_bufs;
>> 	struct io_mapped_ubuf	**user_bufs;
>>
>> -	struct user_struct	*user;
>> -
>> -	struct completion	ref_comp;
>> -
>> -#if defined(CONFIG_UNIX)
>> -	struct socket		*ring_sock;
>> -#endif
>> -
>> 	struct xarray		io_buffers;
>>
>> 	struct xarray		personalities;
>> @@ -460,12 +446,24 @@ struct io_ring_ctx {
>>
>> 	struct io_restriction		restrictions;
>>
>> -	/* exit task_work */
>> -	struct callback_head		*exit_task_work;
>> -
>> 	/* Keep this last, we don't need it for the fast path */
>> -	struct work_struct		exit_work;
>> -	struct list_head		tctx_list;
>> +	struct {
> 
> Why do we need an anonymous struct here? For cache line alignment?
> Do we need ____cacheline_aligned_in_smp?

Rather as a visual hint considering that most of the field historically
are in structs (____cacheline_aligned_in_smp). Also preparing to
potentially splitting it out of the ctx struct as it grows big. 

First 2-3 patches are not strictly related to bpf and will go separately
earlier, just the set was based on.

>> +		#if defined(CONFIG_UNIX)
>> +			struct socket		*ring_sock;
>> +		#endif
>> +		/* hashed buffered write serialization */
>> +		struct io_wq_hash		*hash_map;
>> +
>> +		/* Only used for accounting purposes */
>> +		struct user_struct		*user;
>> +		struct mm_struct		*mm_account;
>> +
>> +		/* ctx exit and cancelation */
>> +		struct callback_head		*exit_task_work;
>> +		struct work_struct		exit_work;
>> +		struct list_head		tctx_list;
>> +		struct completion		ref_comp;
>> +	};
>> };
>>
>> struct io_uring_task {

-- 
Pavel Begunkov
