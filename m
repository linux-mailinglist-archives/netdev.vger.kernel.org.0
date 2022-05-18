Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2AF52C02F
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 19:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240512AbiERQs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 12:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240455AbiERQsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 12:48:25 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D4984A2C
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 09:48:23 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d17so2361052plg.0
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 09:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=a/nioQD6LDBjjZNelJ71Lr4Cech0R4yZAq15sbuZJCc=;
        b=jeUGHyeLcHxjHkIIKYZBSEirqL6+qcT+SwaKdSDH0eEuWJX91z8H+/NwOyFm6Q/3sg
         L9XrfogqRU3oI6TnKgiJeHgrGw/oGUbpLfVj3kV+oLdnjWkaqqa+CybKP/FbOvy6F6IL
         rluB6UJhiQou1qwfVR+KdqqKcIz4w0sEumbGOiWOpSUME/YbUFIDrk//wtIR8X9N1Jm4
         NoDF8h/+RCgyROH58JFUlONkcnXtlIgRGqgWS0Jr9Wt4GrykPJjgvLd1ygMncVXda1mG
         rfViXBsfd8QYhpJJ3lk8Is4meGwXFAnxnTZ0OKw7eHzYV0K2t1q7aYsfC3i03hntXNgU
         GTGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=a/nioQD6LDBjjZNelJ71Lr4Cech0R4yZAq15sbuZJCc=;
        b=RemCjgxwur5MPCF1yIjX3oGbM687lHKVd54t6XEAjcGtBnCnjJPimzCrHxGD8VUPIl
         dK3Nd07q2/n4FARKs8VQLY6ssQJmNfcTz5zJaI3Qb+mrWoFO6j9QhdyFL8TaXfiBktHV
         eTaliwVShA1K7CLJ4tg211sc+B7J5j5+HhcJIxSHdVPjj7HwuA7AYndJISYjWwjDW1rz
         jEZ864YAsvZRw0kQFceadGBAVQQ5uw50BYgZs8LezVYL3faBH45nQ5jQoM+2C9g8UQ2J
         xgDI4OtjZ32KmlxAop+fX4NOEyav7ItJnYQCs19lrHgQs9ss2fVLgy2S1HAjsFT9+q5R
         +OTg==
X-Gm-Message-State: AOAM532tk7ZEwa8kbJNZ1hWkybMyEWAhXXBsL4YqJ421Ok1DyD+UUvqs
        Yg7pOOnI4Ud2hory288Y5s/PKA==
X-Google-Smtp-Source: ABdhPJzGXQOlhE+1fEGAQ/pp1W/iTllR26Rke7t+R8GImSuPPuWzP7SqD51y8AElUN1y20JLBSwO9A==
X-Received: by 2002:a17:902:d502:b0:161:bc5f:7b2d with SMTP id b2-20020a170902d50200b00161bc5f7b2dmr285451plg.140.1652892503221;
        Wed, 18 May 2022 09:48:23 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id r15-20020aa7988f000000b0050dc76281c4sm2226246pfl.158.2022.05.18.09.48.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 09:48:22 -0700 (PDT)
Message-ID: <317701e1-20a7-206f-92cd-cd36d436eee2@linaro.org>
Date:   Wed, 18 May 2022 09:48:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] cgroup: don't queue css_release_work if one already
 pending
Content-Language: en-US
To:     =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        Tejun Heo <tj@kernel.org>
Cc:     cgroups@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christian Brauner <brauner@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com
References: <20220412192459.227740-1-tadeusz.struk@linaro.org>
 <20220414164409.GA5404@blackbody.suse.cz> <YmHwOAdGY2Lwl+M3@slm.duckdns.org>
 <20220422100400.GA29552@blackbody.suse.cz>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <20220422100400.GA29552@blackbody.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/22 04:05, Michal Koutný wrote:
> On Thu, Apr 21, 2022 at 02:00:56PM -1000, Tejun Heo <tj@kernel.org> wrote:
>> If this is the case, we need to hold an extra reference to be put by the
>> css_killed_work_fn(), right?
> 
> I looked into it a bit more lately and found that there already is such
> a fuse in kill_css() [1].
> 
> At the same type syzbots stack trace demonstrates the fuse is
> ineffective
> 
>> css_release+0xae/0xc0 kernel/cgroup/cgroup.c:5146                    (**)
>> percpu_ref_put_many include/linux/percpu-refcount.h:322 [inline]
>> percpu_ref_put include/linux/percpu-refcount.h:338 [inline]
>> percpu_ref_call_confirm_rcu lib/percpu-refcount.c:162 [inline]        (*)
>> percpu_ref_switch_to_atomic_rcu+0x5a2/0x5b0 lib/percpu-refcount.c:199
>> rcu_do_batch+0x4f8/0xbc0 kernel/rcu/tree.c:2485
>> rcu_core+0x59b/0xe30 kernel/rcu/tree.c:2722
>> rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2735
>> __do_softirq+0x27e/0x596 kernel/softirq.c:305
> 
> (*) this calls css_killed_ref_fn confirm_switch
> (**) zero references after confirmed kill?
> 
> So, I was also looking at the possible race with css_free_rwork_fn()
> (from failed css_create()) but that would likely emit a warning from
> __percpu_ref_exit().
> 
> So, I still think there's something fishy (so far possible only via
> artificial ENOMEM injection) that needs an explanation...

I can't reliably reproduce this issue on neither mainline nor v5.10, where
syzbot originally found it. It still triggers for syzbot though.

-- 
Thanks,
Tadeusz
