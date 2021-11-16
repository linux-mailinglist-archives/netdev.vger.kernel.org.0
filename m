Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5557C452761
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 03:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237757AbhKPCY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 21:24:26 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:49038 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377197AbhKPCVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 21:21:47 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637029130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YyjRSQlJ74IaEFm4kmTt0fq1x258ZL9HGGLRzvNBGkk=;
        b=EU3broKT0SP0yxsZxLJ8BJ+cyrk+AK/bGC3p8GwWMDjqFVd7S08JYh70L2gE/gFc6HTX8h
        bh85olDH0dGjtRXoJZFO4/0XX0p+JpSnO6Nui2l+VBXTPy/miOqjIBf8zgDJcnXIvlJMm0
        AVIHIjm8zhRmU6WHZwgvPwv4tWCZodN/O1ZsKwXne61SeZ4tm5FiWbhoud8NBu8+N7jQVk
        W1LKiRkDlZWHIJdy4zmZeYzg1kG+sT9L6780o6bHRZJap7dq0mK6XGTqr+zDggjDLfx4Zg
        Eksrge6IatecuVJjwVIasf7N3nM1XvELBvvjPrjsZKYTbAP55nsrH5vuvmu04A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637029130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YyjRSQlJ74IaEFm4kmTt0fq1x258ZL9HGGLRzvNBGkk=;
        b=xe0H9CMWzx3KKfDIZalAZCG7e8DGXz/aC5XZLQEKHozvgtVcyuIBjmEKukMdumddWYvaQp
        0Rsoj9p+oalzUBDA==
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Dmitrii Banshchikov <me@ubique.spb.ru>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf v2 0/2] Forbid bpf_ktime_get_coarse_ns and
 bpf_timer_* in tracing progs
In-Reply-To: <CAADnVQ+zo-DMC=yqqphEno9pxwhBQ3soQzKd=2yLPNoLyBcFHw@mail.gmail.com>
References: <20211113142227.566439-1-me@ubique.spb.ru>
 <CAADnVQ+zo-DMC=yqqphEno9pxwhBQ3soQzKd=2yLPNoLyBcFHw@mail.gmail.com>
Date:   Tue, 16 Nov 2021 03:18:49 +0100
Message-ID: <87lf1o6dx2.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei,

On Sun, Nov 14 2021 at 10:38, Alexei Starovoitov wrote:
> On Sat, Nov 13, 2021 at 6:22 AM Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
>> v1 -> v2:
>>  * Limit the helpers via func proto getters instead of allowed callback
>>  * Add note about helpers' restrictions to linux/bpf.h
>>  * Add Fixes tag
>>  * Remove extra \0 from btf_str_sec
>>  * Beside asm tests add prog tests
>>  * Trim CC
>>
>> 1. https://lore.kernel.org/all/00000000000013aebd05cff8e064@google.com/
>
> Applied. Thanks

applying crap faster than anyone involved can look at (hint: weekend)
and without actually looking at the nonsense propagated by this 'hot
fix' is what is going to cause long term maintaience trouble. Please
revert the offending and obvious bogus comments in those commits.

Thanks,

        tglx
