Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47035430FF0
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 07:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhJRFv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 01:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhJRFvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 01:51:55 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780F1C06161C
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 22:49:45 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id s1so8621421plg.12
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 22:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=6rwEtZ1Zb/VZuvZ9Ty4TZLVT6960nXlgqfxXCvxX4Tk=;
        b=Pev3csxQaQTkrwhTCrr7tYQsB65VVPyU53VeCEXBl0QUr/YENzAWjt3xqz4VuY7hwz
         yLa5TvtM1tLiYClOkPBC3ELc2XGTXt7AflP97/8ttptFUDiI52sM/FF/awdNQA1FA7/F
         BWqS1WMhK1ew3r5UdO+VsiceVhcuAaYZWOPbBb8cM/1BgU3erpmyw1edocXIYfTOlcwg
         p0fPPF5+gkrV4KRVAwGk02w0r0/KKrOb8dEfQ6EoibNxohOCH/md9i97Ht7qRvV/r4K2
         EV0GH/3THuUyCANq56o4frDJ/xNg5NSUUG9sVGG8FVnXlwXJ2onL3bW+csMD6W2OcliN
         UQDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6rwEtZ1Zb/VZuvZ9Ty4TZLVT6960nXlgqfxXCvxX4Tk=;
        b=ltC/a/oW3UAKhlvUrgI0nbt+LCIPlkm9zBheimBJJa8iSk+5zWuHOBwGkwA0jt3nbt
         TQQ6LOyOJSK/klaWe/JDi0ZjTSWQPKrpnxjzR5odjeBKEt35RKxt6ntZTB5cl/FzzpfL
         rGbqaKPYxb6m+swoNYJfZpvkRssYZ0qampdUhlivI0DbEinDU2iAte+ESHBnIxWwReHU
         XVzuNq4o9NBwZavsZ7vYuUjjPYMGkFRQMQ7y1D8oOJpjokoJ70M5102xAUSVGMjPUy0g
         PN8tzZfFLtnjDo23+274c/BqhE9dI7snuHSzvcI6DZ0UcTHLpil0Bayb3M/gAE4gSWSK
         0ovQ==
X-Gm-Message-State: AOAM530jXy3RrHZvPRYhDWoL3ybkDJKeBUnTw3G3wPZ1ADFsivdUAkQs
        gtVt4aPbHUsphJlErluGAykBLQ==
X-Google-Smtp-Source: ABdhPJxhYreOWM4oXTRILVvFSjCgPe7TD6r5u4iYr/UTp36Dw6uFV5EzNle1SeXfKd7jOG9AS/zrEA==
X-Received: by 2002:a17:90b:4a8d:: with SMTP id lp13mr31527573pjb.32.1634536185061;
        Sun, 17 Oct 2021 22:49:45 -0700 (PDT)
Received: from [10.254.36.135] ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id n202sm11706527pfd.160.2021.10.17.22.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Oct 2021 22:49:44 -0700 (PDT)
Message-ID: <6d7246b6-195e-ee08-06b1-2d1ec722e7b2@bytedance.com>
Date:   Mon, 18 Oct 2021 13:49:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [External] Re: [PATCH] bpf: use count for prealloc hashtab too
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <20211015090353.31248-1-zhouchengming@bytedance.com>
 <CAADnVQ+A5LdWQTXFugNTceGcz_biV-uEJma4oT5UJKeHQBHQPw@mail.gmail.com>
From:   Chengming Zhou <zhouchengming@bytedance.com>
In-Reply-To: <CAADnVQ+A5LdWQTXFugNTceGcz_biV-uEJma4oT5UJKeHQBHQPw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2021/10/16 上午3:58, Alexei Starovoitov 写道:
> On Fri, Oct 15, 2021 at 11:04 AM Chengming Zhou
> <zhouchengming@bytedance.com> wrote:
>>
>> We only use count for kmalloc hashtab not for prealloc hashtab, because
>> __pcpu_freelist_pop() return NULL when no more elem in pcpu freelist.
>>
>> But the problem is that __pcpu_freelist_pop() will traverse all CPUs and
>> spin_lock for all CPUs to find there is no more elem at last.
>>
>> We encountered bad case on big system with 96 CPUs that alloc_htab_elem()
>> would last for 1ms. This patch use count for prealloc hashtab too,
>> avoid traverse and spin_lock for all CPUs in this case.
>>
>> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> 
> It's not clear from the commit log what you're solving.
> The atomic inc/dec in critical path of prealloc maps hurts performance.
> That's why it's not used.
> 
Thanks for the explanation, what I'm solving is when hash table hasn't free
elements, we don't need to call __pcpu_freelist_pop() to traverse and
spin_lock all CPUs. The ftrace output of this bad case is below:

 50)               |  htab_map_update_elem() {
 50)   0.329 us    |    _raw_spin_lock_irqsave();
 50)   0.063 us    |    lookup_elem_raw();
 50)               |    alloc_htab_elem() {
 50)               |      pcpu_freelist_pop() {
 50)   0.209 us    |        _raw_spin_lock();
 50)   0.264 us    |        _raw_spin_lock();
 50)   0.231 us    |        _raw_spin_lock();
 50)   0.168 us    |        _raw_spin_lock();
 50)   0.168 us    |        _raw_spin_lock();
 50)   0.300 us    |        _raw_spin_lock();
 50)   0.263 us    |        _raw_spin_lock();
 50)   0.304 us    |        _raw_spin_lock();
 50)   0.168 us    |        _raw_spin_lock();
 50)   0.177 us    |        _raw_spin_lock();
 50)   0.235 us    |        _raw_spin_lock();
 50)   0.162 us    |        _raw_spin_lock();
 50)   0.186 us    |        _raw_spin_lock();
 50)   0.185 us    |        _raw_spin_lock();
 50)   0.315 us    |        _raw_spin_lock();
 50)   0.172 us    |        _raw_spin_lock();
 50)   0.180 us    |        _raw_spin_lock();
 50)   0.173 us    |        _raw_spin_lock();
 50)   0.176 us    |        _raw_spin_lock();
 50)   0.261 us    |        _raw_spin_lock();
 50)   0.364 us    |        _raw_spin_lock();
 50)   0.180 us    |        _raw_spin_lock();
 50)   0.284 us    |        _raw_spin_lock();
 50)   0.226 us    |        _raw_spin_lock();
 50)   0.210 us    |        _raw_spin_lock();
 50)   0.237 us    |        _raw_spin_lock();
 50)   0.333 us    |        _raw_spin_lock();
 50)   0.295 us    |        _raw_spin_lock();
 50)   0.278 us    |        _raw_spin_lock();
 50)   0.260 us    |        _raw_spin_lock();
 50)   0.224 us    |        _raw_spin_lock();
 50)   0.447 us    |        _raw_spin_lock();
 50)   0.221 us    |        _raw_spin_lock();
 50)   0.320 us    |        _raw_spin_lock();
 50)   0.203 us    |        _raw_spin_lock();
 50)   0.213 us    |        _raw_spin_lock();
 50)   0.242 us    |        _raw_spin_lock();
 50)   0.230 us    |        _raw_spin_lock();
 50)   0.216 us    |        _raw_spin_lock();
 50)   0.525 us    |        _raw_spin_lock();
 50)   0.257 us    |        _raw_spin_lock();
 50)   0.235 us    |        _raw_spin_lock();
 50)   0.269 us    |        _raw_spin_lock();
 50)   0.368 us    |        _raw_spin_lock();
 50)   0.249 us    |        _raw_spin_lock();
 50)   0.217 us    |        _raw_spin_lock();
 50)   0.174 us    |        _raw_spin_lock();
 50)   0.173 us    |        _raw_spin_lock();
 50)   0.161 us    |        _raw_spin_lock();
 50)   0.282 us    |        _raw_spin_lock();
 50)   0.264 us    |        _raw_spin_lock();
 50)   0.160 us    |        _raw_spin_lock();
 50)   0.692 us    |        _raw_spin_lock();
 50)   0.185 us    |        _raw_spin_lock();
 50)   0.157 us    |        _raw_spin_lock();
 50)   0.168 us    |        _raw_spin_lock();
 50)   0.205 us    |        _raw_spin_lock();
 50)   0.189 us    |        _raw_spin_lock();
 50)   0.276 us    |        _raw_spin_lock();
 50)   0.171 us    |        _raw_spin_lock();
 50)   0.390 us    |        _raw_spin_lock();
 50)   0.164 us    |        _raw_spin_lock();
 50)   0.170 us    |        _raw_spin_lock();
 50)   0.188 us    |        _raw_spin_lock();
 50)   0.284 us    |        _raw_spin_lock();
 50)   0.191 us    |        _raw_spin_lock();
 50)   0.412 us    |        _raw_spin_lock();
 50)   0.285 us    |        _raw_spin_lock();
 50)   0.296 us    |        _raw_spin_lock();
 50)   0.315 us    |        _raw_spin_lock();
 50)   0.239 us    |        _raw_spin_lock();
 50)   0.225 us    |        _raw_spin_lock();
 50)   0.258 us    |        _raw_spin_lock();
 50)   0.228 us    |        _raw_spin_lock();
 50)   0.240 us    |        _raw_spin_lock();
 50)   0.297 us    |        _raw_spin_lock();
 50)   0.216 us    |        _raw_spin_lock();
 50)   0.213 us    |        _raw_spin_lock();
 50)   0.225 us    |        _raw_spin_lock();
 50)   0.223 us    |        _raw_spin_lock();
 50)   0.287 us    |        _raw_spin_lock();
 50)   0.258 us    |        _raw_spin_lock();
 50)   0.295 us    |        _raw_spin_lock();
 50)   0.262 us    |        _raw_spin_lock();
 50)   0.325 us    |        _raw_spin_lock();
 50)   0.203 us    |        _raw_spin_lock();
 50)   0.325 us    |        _raw_spin_lock();
 50)   0.255 us    |        _raw_spin_lock();
 50)   0.325 us    |        _raw_spin_lock();
 50)   0.216 us    |        _raw_spin_lock();
 50)   0.232 us    |        _raw_spin_lock();
 50)   0.804 us    |        _raw_spin_lock();
 50)   0.262 us    |        _raw_spin_lock();
 50)   0.242 us    |        _raw_spin_lock();
 50)   0.271 us    |        _raw_spin_lock();
 50)   0.175 us    |        _raw_spin_lock();
 50) + 61.026 us   |      }
 50) + 61.575 us   |    }
 50)   0.051 us    |    _raw_spin_unlock_irqrestore();
 50) + 64.863 us   |  }
