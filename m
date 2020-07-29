Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4D223195E
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 08:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgG2GQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 02:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbgG2GQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 02:16:39 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99437C061794;
        Tue, 28 Jul 2020 23:16:39 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id b79so21168899qkg.9;
        Tue, 28 Jul 2020 23:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iLtAssgWfIZzqgLiFD3qsZIMSHk6XKt/j5mm7LzbJ6Y=;
        b=MmXlKQmCgUHDk6M79TCRMNheCcB7vZjsht1k767ehX1N1KE7LUawliBgc1UJU+0rKM
         EWNXeahcrAY7yEDZolaA7Xqua2cSgJRP+ZoCPS7Qg6EX48m/dqkNu12qB6n6ImIjKckl
         cZDxA8ytiR+g96o88tgKXFqbHTt+znHzGrq6LqZWDorWhY+9OmYYQhHeLfK90zV5EWM8
         2Dng5L7HXo6VqsbKw1f1Nkq/ZxwXw3tdB0AovbDYyd3jK0/wgInKg3TvO4YMS2ye4xYT
         jN8Q1hEVa8z8Q9TcTTdMI7zRNAZqfZm3Qc1bAsRurqUE4UCLModuflEsu20xczAdHBvC
         XCbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iLtAssgWfIZzqgLiFD3qsZIMSHk6XKt/j5mm7LzbJ6Y=;
        b=jCkxq5QQk64aW8cD5piwjZPhG3FAZ4FqE8jSfeiNYshEdoEuk2YLNh8vPljkyBVsjt
         OzHNIf7kShn+o2f+1eH5yO+E1JlUx1tbOia835eyGzcX7K9XSYwBGOQY8KPrlVXSNHlE
         wQ36q5PaASA1tYbHMdV3B/G51ms3VvKtgyKl+w4+TzYK2ApefawWC/rdcI2w15PoXgKw
         wzBkwBMYwSsjeqHzl+RDY3Z9pCznuCe4eNh7JKaSdcMwwQg/ypaR+xIX6FjnUASIW4s6
         ZwoDOqMRsU9wTP0GCaYMeo3l5D4+XznaGRjvlJixWn2yU32W1qXaWNc2lCTAvwdtDUez
         pDbg==
X-Gm-Message-State: AOAM531lFRxUQjJQsxKkrGDHzIb+I7KNIo4jDbyFmnoM5ZCSnRmNyNq9
        baOZ+zHvn1Zn/5dYJbEvZcv3EFmTxHhpUelbsL8=
X-Google-Smtp-Source: ABdhPJysBKm7v9N4z+wTwwNU6y6+7AEeiul8ro2XUFe5Nu36RtO7Fq/BkE8n7bwc7FT5YWnRQoVS67z6XFapJS4JT2U=
X-Received: by 2002:a05:620a:4c:: with SMTP id t12mr6180376qkt.449.1596003398816;
 Tue, 28 Jul 2020 23:16:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200729045056.3363921-1-andriin@fb.com> <CAPhsuW5e5B8AShod0frVaDdDA_5f3xeyd6gr9sTqUSy4YM1pBA@mail.gmail.com>
In-Reply-To: <CAPhsuW5e5B8AShod0frVaDdDA_5f3xeyd6gr9sTqUSy4YM1pBA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Jul 2020 23:16:27 -0700
Message-ID: <CAEf4BzY=P0pL5wwBD=w=02ooueJcg4h8SoeZuC2pz86R3s1wnw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: don't destroy failed link
To:     Song Liu <song@kernel.org>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        YiFei Zhu <zhuyifei@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 10:47 PM Song Liu <song@kernel.org> wrote:
>
> On Tue, Jul 28, 2020 at 9:54 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Check that link is NULL or proper pointer before invoking bpf_link__destroy().
> > Not doing this causes crash in test_progs, when cg_storage_multi selftest
> > fails.
> >
> > Cc: YiFei Zhu <zhuyifei@google.com>
> > Fixes: 3573f384014f ("selftests/bpf: Test CGROUP_STORAGE behavior on shared egress + ingress")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> btw: maybe we can move the IS_ERR() check to bpf_link__destroy()?

Yeah, given how common this mistake seems to be, that wouldn't be a bad idea.

>
> > ---
> >  .../bpf/prog_tests/cg_storage_multi.c         | 42 ++++++++++++-------
> >  1 file changed, 28 insertions(+), 14 deletions(-)
> >

[...]
