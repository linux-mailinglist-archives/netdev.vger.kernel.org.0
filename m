Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392AC1FFD9E
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731510AbgFRWAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729146AbgFRWAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:00:03 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF1CC06174E;
        Thu, 18 Jun 2020 15:00:02 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id q8so7119330qkm.12;
        Thu, 18 Jun 2020 15:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5ZR6CFkdg+ULcmL1AuVmvyE6nh/C3rjVxkIJ1sgDqbQ=;
        b=BC5mxAFSilXrd3JCUQWquJqcr8kKpimZ9NIAe42gucS2lfu1N6vwgmiNkpktOxUz7j
         REr8/00DR9yjalCs4Ph6hfJdgbaG+cB2fkRahF1av/36md39J9z2GtKr29iu2x9JRVTm
         Sb1mSq58D7NmRVZUxCFex9kjQ+l0bc9hbfawdEg34aJPmHen9zYN1ZYIuiXLqD7LlmVG
         oefj49l70jpwjlD0v41T3E2dus+lbeOLnMUZACvX0h/rZ0j9D8U/pjUrW8eU8JPg3Xc+
         SuplnJSm9Mwf7hZFpUvMtCUpWrfbGKeoYuJHvZBzxRG6Du2ocLbJsRHmZIA7U6thM8cA
         Rk1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5ZR6CFkdg+ULcmL1AuVmvyE6nh/C3rjVxkIJ1sgDqbQ=;
        b=hJW53MRcZYyfs3+J95MLmJS7nEKsPMHCUUhZZUAiiPGvT3SyY5HgWNYriwAXhyWVa8
         agEtlzMibEOkaWAD/wRBGP2lNfwFqGhHEDv5+AtXOndgH5ORGPqLO9EWo3Mggyq/8j/C
         UkTRl1znidqSTCWMvTDFWfvvw8HUoupNvheLD4KvJUBklmqIKVM3e+BrzI2pjRbdLeu6
         9KPPtoxWoX7BqFMquRGPmTOgZIv40tu0tlD8v2wmx8G8PvDxzcD6HfIMy58rfSrVlHKT
         EUBc8hzKjNdFSZLP0Ct6xcHoTOoyltH74LR7afTjTHuhFrSG90yMGiauYJ7fwItjOp7R
         UOtw==
X-Gm-Message-State: AOAM530Pw1CF8hVdins49+d2Se34VctzxgUnm1x9wF544nr9EGvt13rw
        N8vrFhhB4+p+N8oiiJCvXvBFf0eR7X/nAD0T12w=
X-Google-Smtp-Source: ABdhPJzmXrg4YpkekEZQC+Pp+GUzrAhNmszq9ngGtgQ69nrnsyacxmAyBJIpIbawrrXb5HK84Dwgc9RZXQMxrYWeUmI=
X-Received: by 2002:a05:620a:12d2:: with SMTP id e18mr526485qkl.437.1592517601927;
 Thu, 18 Jun 2020 15:00:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200616050432.1902042-1-andriin@fb.com> <20200616050432.1902042-2-andriin@fb.com>
 <5eebbbef8f904_6d292ad5e7a285b883@john-XPS-13-9370.notmuch>
In-Reply-To: <5eebbbef8f904_6d292ad5e7a285b883@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 14:59:51 -0700
Message-ID: <CAEf4BzYNFddhDxLAkOC+q_ZWAet42aHybDiJT9odrzF8n5BBig@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] selftests/bpf: add variable-length data
 concatenation pattern test
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 12:09 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > Add selftest that validates variable-length data reading and concatentation
> > with one big shared data array. This is a common pattern in production use for
> > monitoring and tracing applications, that potentially can read a lot of data,
> > but usually reads much less. Such pattern allows to determine precisely what
> > amount of data needs to be sent over perfbuf/ringbuf and maximize efficiency.
> >
> > This is the first BPF selftest that at all looks at and tests
> > bpf_probe_read_str()-like helper's return value, closing a major gap in BPF
> > testing. It surfaced the problem with bpf_probe_read_kernel_str() returning
> > 0 on success, instead of amount of bytes successfully read.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
>
> [...]
>
> > +/* .data */
> > +int payload2_len1 = -1;
> > +int payload2_len2 = -1;
> > +int total2 = -1;
> > +char payload2[MAX_LEN + MAX_LEN] = { 1 };
> > +
> > +SEC("raw_tp/sys_enter")
> > +int handler64(void *regs)
> > +{
> > +     int pid = bpf_get_current_pid_tgid() >> 32;
> > +     void *payload = payload1;
> > +     u64 len;
> > +
> > +     /* ignore irrelevant invocations */
> > +     if (test_pid != pid || !capture)
> > +             return 0;
> > +
> > +     len = bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in1[0]);
> > +     if (len <= MAX_LEN) {
>
> Took me a bit grok this. You are relying on the fact that in errors,
> such as a page fault, will encode to a large u64 value and so you
> verifier is happy. But most of my programs actually want to distinguish
> between legitimate errors on the probe vs buffer overrun cases.

What buffer overrun? bpf_probe_read_str() family cannot return higher
value than MAX_LEN. If you want to detect truncated strings, then you
can attempt reading MAX_LEN + 1 and then check that the return result
is MAX_LEN exactly. But still, that would be something like:

u64 len;

len = bpf_probe_read_str(payload, MAX_LEN + 1, &buf);
if (len > MAX_LEN)
  return -1;
if (len == MAX_LEN) {
  /* truncated */
} else {
  /* full string */
}

>
> Can we make these tests do explicit check for errors. For example,
>
>   if (len < 0) goto abort;
>
> But this also breaks your types here. This is what I was trying to
> point out in the 1/2 patch thread. Wanted to make the point here as
> well in case it wasn't clear. Not sure I did the best job explaining.
>

I can write *a correct* C code in a lot of ways such that it will not
pass verifier verification, not sure what that will prove, though.

Have you tried using the pattern with two ifs with no-ALU32? Does it work?

Also you are cheating in your example (in patch #1 thread). You are
exiting on the first error and do not attempt to read any more data
after that. In practice, you want to get as much info as possible,
even if some of string reads fail (e.g., because argv might not be
paged in, but env is, or vice versa). So you'll end up doing this:

len = bpf_probe_read_str(...);
if (len >= 0 && len <= MAX_LEN) {
    payload += len;
}
...

... and of course it spectacularly fails in no-ALU32.

To be completely fair, this is a result of Clang optimization and
Yonghong is trying to deal with it as we speak. Switching int to long
for helpers doesn't help it either. But there are better code patterns
(unsigned len + single if check) that do work with both ALU32 and
no-ALU32.

And I just double-checked, this pattern keeps working for ALU32 with
both int and long types, so maybe there are unnecessary bit shifts,
but at least code is still verifiable.

So my point stands. int -> long helps in some cases and doesn't hurt
in others, so I argue that it's a good thing to do :)




> > +             payload += len;
> > +             payload1_len1 = len;
> > +     }
> > +
> > +     len = bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in2[0]);
> > +     if (len <= MAX_LEN) {
> > +             payload += len;
> > +             payload1_len2 = len;
> > +     }
> > +
> > +     total1 = payload - (void *)payload1;
> > +
> > +     return 0;
> > +}
