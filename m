Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02483687F0
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 22:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239482AbhDVUal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 16:30:41 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:45859 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239298AbhDVUaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 16:30:39 -0400
Received: by mail-pg1-f179.google.com with SMTP id d10so33648888pgf.12;
        Thu, 22 Apr 2021 13:30:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ErwniLcaGVO/kxmEwl8gGV0QjSUQKJ/t9ZJlSqCEkEo=;
        b=UHgXJpPoOZl081FZ+7kXYg7dS6ENxhs/XxcdbvKZCeDIyYkcYigb8pTmVeDOynj2dU
         yAqCRdte7xpQJkrcwylxj+YmeQ7bN/6xVlrBMUYEIVvQUGDtq77EDoRnpGC5g0O/94Lq
         /z9zQfTWs9jeBCu6WkSWswffr6lBeCI+hr66LumWxgIQjjXwxhAYWK3zs0BS1vdI7GGg
         iAsAkEA4MX+v67TFaGljp+vebE9hu/GIJpOqn+1z2ltMsCKIbmxHZHTDhJLjeSE/Q/L4
         Hv+q2g19vtZGhhrTfq2h0Eoh6DIzLf46TumoHK/mIi/GqhoCwu/FeC5buUcuLRE/N5LU
         aPew==
X-Gm-Message-State: AOAM531AAsbQr95dMFhLh+N+Ltd2fZeZQNcWNxzNvMzhi/z+mNP/a8fC
        E6wY4WUMsX09fplieFsVjPRbAXnXkLw6MA==
X-Google-Smtp-Source: ABdhPJxNNltJlaq4UgjTTlU6u2x4QZW/U/kixD1KrCTqqMjziRQo0Aws14ZZK/60vBVE/YGzE7v9Mg==
X-Received: by 2002:a63:e00f:: with SMTP id e15mr407170pgh.317.1619123403370;
        Thu, 22 Apr 2021 13:30:03 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id k21sm2751759pfi.28.2021.04.22.13.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 13:30:02 -0700 (PDT)
Subject: Re: [PATCH 1/2] workqueue: Have 'alloc_workqueue()' like macros
 accept a format specifier
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Marion et Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tj@kernel.org, jiangshanlai@gmail.com, saeedm@nvidia.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <cover.1618780558.git.christophe.jaillet@wanadoo.fr>
 <ae88f6c2c613d17bc1a56692cfa4f960dbc723d2.1618780558.git.christophe.jaillet@wanadoo.fr>
 <042f5fff-5faf-f3c5-0819-b8c8d766ede6@acm.org>
 <1032428026.331.1618814178946.JavaMail.www@wwinf2229>
 <40c21bfe-e304-230d-b319-b98063347b8b@acm.org>
 <20210422122419.GF2047089@ziepe.ca>
 <782e329a-7c3f-a0da-5d2f-89871b0c4b9b@acm.org> <YIG5tLBIAledZetf@unreal>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <53b2ef14-1b8a-43b1-ef53-e314e2649ea0@acm.org>
Date:   Thu, 22 Apr 2021 13:30:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YIG5tLBIAledZetf@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/21 11:00 AM, Leon Romanovsky wrote:
> On Thu, Apr 22, 2021 at 10:12:33AM -0700, Bart Van Assche wrote:
>> On 4/22/21 5:24 AM, Jason Gunthorpe wrote:
>>> On Mon, Apr 19, 2021 at 01:02:34PM -0700, Bart Van Assche wrote:
>>>> On 4/18/21 11:36 PM, Marion et Christophe JAILLET wrote:
>>>>> The list in To: is the one given by get_maintainer.pl. Usualy, I only
>>>>> put the ML in Cc: I've run the script on the 2 patches of the serie
>>>>> and merged the 2 lists. Everyone is in the To: of the cover letter
>>>>> and of the 2 patches.
>>>>>
>>>>> If Théo is "Tejun Heo" (  (maintainer:WORKQUEUE) ), he is already in
>>>>> the To: line.
>>>> Linus wants to see a "Cc: ${maintainer}" tag in patches that he receives
>>>> from a maintainer and that modify another subsystem than the subsystem
>>>> maintained by that maintainer.
>>>
>>> Really? Do you remember a lore link for this?
>>
>> Last time I saw Linus mentioning this was a few months ago.
>> Unfortunately I cannot find that message anymore.
>>
>>> Generally I've been junking the CC lines (vs Andrew at the other
>>> extreme that often has 10's of CC lines)
>>
>> Most entries in the MAINTAINERS file have one to three email addresses
>> so I'm surprised to read that Cc-ing maintainer(s) could result in tens
>> of Cc lines?
> 
> git log mm/
> 
> commit 2b8305260fb37fc20e13f71e13073304d0a031c8
> Author: Alexander Potapenko <glider@google.com>
> Date:   Thu Feb 25 17:19:21 2021 -0800
> 
>      kfence, kasan: make KFENCE compatible with KASAN
> 
>      Make KFENCE compatible with KASAN. Currently this helps test KFENCE
>      itself, where KASAN can catch potential corruptions to KFENCE state, or
>      other corruptions that may be a result of freepointer corruptions in the
>      main allocators.
> 
>      [akpm@linux-foundation.org: merge fixup]
>      [andreyknvl@google.com: untag addresses for KFENCE]
>        Link: https://lkml.kernel.org/r/9dc196006921b191d25d10f6e611316db7da2efc.1611946152.git.andreyknvl@google.com
> 
>      Link: https://lkml.kernel.org/r/20201103175841.3495947-7-elver@google.com
>      Signed-off-by: Marco Elver <elver@google.com>
>      Signed-off-by: Alexander Potapenko <glider@google.com>
>      Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
>      Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
>      Reviewed-by: Jann Horn <jannh@google.com>
>      Co-developed-by: Marco Elver <elver@google.com>
>      Cc: Andrey Konovalov <andreyknvl@google.com>
>      Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
>      Cc: Andy Lutomirski <luto@kernel.org>
>      Cc: Borislav Petkov <bp@alien8.de>
>      Cc: Catalin Marinas <catalin.marinas@arm.com>
>      Cc: Christopher Lameter <cl@linux.com>
>      Cc: Dave Hansen <dave.hansen@linux.intel.com>
>      Cc: David Rientjes <rientjes@google.com>
>      Cc: Eric Dumazet <edumazet@google.com>
>      Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>      Cc: Hillf Danton <hdanton@sina.com>
>      Cc: "H. Peter Anvin" <hpa@zytor.com>
>      Cc: Ingo Molnar <mingo@redhat.com>
>      Cc: Joern Engel <joern@purestorage.com>
>      Cc: Jonathan Corbet <corbet@lwn.net>
>      Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>      Cc: Kees Cook <keescook@chromium.org>
>      Cc: Mark Rutland <mark.rutland@arm.com>
>      Cc: Paul E. McKenney <paulmck@kernel.org>
>      Cc: Pekka Enberg <penberg@kernel.org>
>      Cc: Peter Zijlstra <peterz@infradead.org>
>      Cc: SeongJae Park <sjpark@amazon.de>
>      Cc: Thomas Gleixner <tglx@linutronix.de>
>      Cc: Vlastimil Babka <vbabka@suse.cz>
>      Cc: Will Deacon <will@kernel.org>
>      Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>      Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

But where does that Cc-list come from? If I extract that patch and run 
the get_maintainer.pl script, the following output appears:

$ git format-patch -1 2b8305260fb37fc20e13f71e13073304d0a031c8
0001-kfence-kasan-make-KFENCE-compatible-with-KASAN.patch
$ scripts/get_maintainer.pl 
0001-kfence-kasan-make-KFENCE-compatible-with-KASAN.patch
Alexander Potapenko <glider@google.com> (maintainer:KFENCE)
Marco Elver <elver@google.com> (maintainer:KFENCE)
Dmitry Vyukov <dvyukov@google.com> (reviewer:KFENCE)
Andrey Ryabinin <ryabinin.a.a@gmail.com> (maintainer:KASAN)
Andrey Konovalov <andreyknvl@gmail.com> (reviewer:KASAN)
Andrew Morton <akpm@linux-foundation.org> (maintainer:MEMORY MANAGEMENT)
kasan-dev@googlegroups.com (open list:KFENCE)
linux-kernel@vger.kernel.org (open list)
linux-mm@kvack.org (open list:MEMORY MANAGEMENT)

Additionally, please note that in my email I was referring to the 
MAINTAINERS file. I do not use the get_maintainers.pl script but instead 
select the Cc-list manually based on what I find in the MAINTAINERS file.

Thanks,

Bart.
