Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043231BB58D
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 06:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgD1EzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 00:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgD1EzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 00:55:24 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51443C03C1A9;
        Mon, 27 Apr 2020 21:55:24 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id n143so20622885qkn.8;
        Mon, 27 Apr 2020 21:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4tCQO54SlLM1o9n1nq2fn809Y4EFPxFBGGfaoqn/rHc=;
        b=cNMnOd4bs5AwwmUH5mfRkuQi9yB7ER6EA69TA/amVZG1EBOw10w43QwDoltZzhly7l
         pPxXBp/vB4xnjT0sGrEj6PR8xJtvtVvP/aFXp5gMPlTeJeUmLlvsde9A42eOCkkN2bY/
         ixGSiXXbhliEB4f1PY3GGSuZuS7WJ2ZeKaI/WWmC+Z/d5yZ3rsbqfL7mrhhnFYzMnkeD
         +dmdZqWFB/6gdBTrZJ57g93at8JdVuWtwaBpe/bgbpAtphzYElSGLZPXh6/AY9TaY/f5
         g+hZ9hyPgkUcvI3dKqxc7huLU/sFvNDXMy3zdESLlOI/EGhYq1mZquuEtkAzkZ7eS/0M
         x31g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4tCQO54SlLM1o9n1nq2fn809Y4EFPxFBGGfaoqn/rHc=;
        b=BfsbiEdWxZr7NAIghGekLARGYR7B0sgkwQhUc9bB3JUyIBRiwsb/QKW1N/b1YJ0VZa
         hOiNJ5g30HV54UTNdTApB2XOCteDwu6sELsiXx6gq9GC0+Itf58iK/fOVQ4ssGM2vjug
         MDXtzQmfo5RG895HRNX2rpgs58uYPUYfO6WVWe2mjJPklwytKKv0hqwEiSP7abJ8mKWx
         mUSjLZvjeCf/YrWVSaO25lvYWz8JU5v+2EvrleipsuV7MQoPQhIVZS68vWVhMNXojeVf
         ErdtFBWYH8oYkENyXhrDEcCpi41ds+qLj2C2SezzYfrtzv0oDLXvtfq0Wh5S1OEO3pRs
         8PoA==
X-Gm-Message-State: AGi0PuZxscIEBanzg+98+XNGdS7mnyTWwvM0RHQ4droO7WPgk0xZSOf1
        tzAu5i1tli+/trKwS4AQUezcyQZDVFYT6uIc64c=
X-Google-Smtp-Source: APiQypJAAZqgSespFwh0SeEdRfHfS2Jqc0qu32IzYjkTfu7wpOXksiB08IU6jpSEhFGzIhUC7hg8KD8MRnCxwrBWGmE=
X-Received: by 2002:a37:6587:: with SMTP id z129mr26953366qkb.437.1588049723463;
 Mon, 27 Apr 2020 21:55:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200423195850.1259827-1-andriin@fb.com> <CAADnVQL4koqLqxxVgMSk42XYNTAzdauRa0PwEzHb0L+fXoE_rQ@mail.gmail.com>
In-Reply-To: <CAADnVQL4koqLqxxVgMSk42XYNTAzdauRa0PwEzHb0L+fXoE_rQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Apr 2020 21:55:12 -0700
Message-ID: <CAEf4BzaWuGnbduumDA1k=5Cm5nt0wfJtxb0yeyNZ+=PxFCP61Q@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next] bpf: make verifier log more relevant by default
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 9:58 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Apr 23, 2020 at 1:04 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > To make BPF verifier verbose log more releavant and easier to use to debug
> > verification failures, "pop" parts of log that were successfully verified.
> > This has effect of leaving only verifier logs that correspond to code branches
> > that lead to verification failure, which in practice should result in much
> > shorter and more relevant verifier log dumps. This behavior is made the
> > default behavior and can be overriden to do exhaustive logging by specifying
> > BPF_LOG_LEVEL2 log level.
> ...
> > On success, verbose log will only have a summary of number of processed
> > instructions, etc, but no branch tracing log. Having just a last succesful
> > branch tracing seemed weird and confusing. Having small and clean summary log
> > in success case seems quite logical and nice, though.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> I think the behavior described in the last paragraph could be
> surprising to some folks who expected to see the verifier log for
> successfully loaded progs.
> May be worth mentioning this in Documentation/networking/filter.txt ?
> That doc needs some cleanup too.

Sure, I'll do a follow-up patch to mention this.

>
> Applied. Thanks
