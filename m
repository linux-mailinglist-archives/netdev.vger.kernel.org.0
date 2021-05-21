Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4257C38BAED
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 02:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbhEUApG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 20:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235175AbhEUApD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 20:45:03 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC1FC061574;
        Thu, 20 May 2021 17:43:40 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id z130so10176038wmg.2;
        Thu, 20 May 2021 17:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wzTHc9qf/9Gyj2F7Jjof+103i3haRjLIlfKVYMSi9f0=;
        b=m1+n9Zpe/GNJi20fwahH90vZPELe8PJfHMnZE5GY/JT0yAPJDy/Tb0arMFLQMBbBKC
         Fzqs16ct/00k/jVHEdr7lQP7NPDhYoo3J+Ry+wnrPpH4YYJJV06HxwJh/dP4HUTbKq/O
         DGOZBlz4Mf5KaU9/45r0l6u5aho9HWiswY9Dfp74hPkb24flcut6fmkqKNHaI6AJideK
         gzkjyZeeWaN/agSXXl7dnQjMj2peUDAmZGLJT7U40BTRYrmTKWfQYxpmGmeE9UATdxQN
         uqve+49l66WWJiirjBm8z0ra1rp+Vml1z6RTdWXxEHW0T7RyNjSALT98QtDSGyp9XHug
         fG5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wzTHc9qf/9Gyj2F7Jjof+103i3haRjLIlfKVYMSi9f0=;
        b=WsVY4NYQVdj8ZrynDZL+kzQ/TmhUuF0Kx9AsOFHUL5GznCMvOYfF+KCAT9CjVHFazy
         /RM96ClLMpSFVvUunE45d8fYCDP5946HI+RbOacYzYsGdiRs6nuaISK4kcWuUUsQZDO3
         h+MLv6Nsk1Ep3me6QdMu8OjR7zgenQJvMWH8b2HTUBSRpG1fgtePKl5j3lsAR9RLkKhv
         LwQnQ1OMuNytlxK1FSRdt04Ge0oAwptunEi2riZjDPUal2NMA1/Ewz2bpRF0wBNRdgP/
         eGR6Ut05VbSjW2PyvkHNLbwj7g8QO7teZt6wv3f9YwYzHOoohng9wx0JfYgKZUT7/9HA
         EPWw==
X-Gm-Message-State: AOAM533ZiLvpqny3Zcb3T3khyIeHLGtMVT0XdfqR8pbagG+XnM2XUSuT
        z/229uOyAX5yiscnHKcGRhk=
X-Google-Smtp-Source: ABdhPJyK0Kh76kLnAgOjLQY+kUei7T+tqBnuq8EFjDlzihkAPjP76LNvtOD0tWnU4jygDTYXU6QH9Q==
X-Received: by 2002:a05:600c:2dc8:: with SMTP id e8mr4477858wmh.72.1621557819043;
        Thu, 20 May 2021 17:43:39 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.182])
        by smtp.gmail.com with ESMTPSA id h14sm164161wrq.45.2021.05.20.17.43.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 17:43:38 -0700 (PDT)
Subject: Re: [PATCH 13/23] io_uring: implement bpf prog registration
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
 <c246d3736b9440532f3e82199a616e3f74d1b8ba.1621424513.git.asml.silence@gmail.com>
 <E5C654FA-1F38-43C4-940D-80563A3B2647@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <2ae0fcbf-fe4a-b2e6-5e7a-4f62c8e91d7e@gmail.com>
Date:   Fri, 21 May 2021 01:43:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <E5C654FA-1F38-43C4-940D-80563A3B2647@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/21/21 12:45 AM, Song Liu wrote:
>> On May 19, 2021, at 7:13 AM, Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> [de]register BPF programs through io_uring_register() with new
>> IORING_ATTACH_BPF and IORING_DETACH_BPF commands.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>> fs/io_uring.c                 | 81 +++++++++++++++++++++++++++++++++++
>> include/uapi/linux/io_uring.h |  2 +
>> 2 files changed, 83 insertions(+)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 882b16b5e5eb..b13cbcd5c47b 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -78,6 +78,7 @@
>> #include <linux/task_work.h>
>> #include <linux/pagemap.h>
>> #include <linux/io_uring.h>
>> +#include <linux/bpf.h>
>>
>> #define CREATE_TRACE_POINTS
>> #include <trace/events/io_uring.h>
>> @@ -103,6 +104,8 @@
>> #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
>> 				 IORING_REGISTER_LAST + IORING_OP_LAST)
>>
>> +#define IORING_MAX_BPF_PROGS	100
> 
> Is 100 a realistic number here? 

Arbitrary test value, will update

> 
>> +
>> #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
>> 				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
>> 				IOSQE_BUFFER_SELECT)
>> @@ -266,6 +269,10 @@ struct io_restriction {
>> 	bool registered;
>> };
>>
> 
> [...]
> 

-- 
Pavel Begunkov
