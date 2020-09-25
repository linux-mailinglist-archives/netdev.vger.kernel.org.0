Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F623278F7F
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 19:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgIYRVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 13:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgIYRVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 13:21:33 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E168C0613CE;
        Fri, 25 Sep 2020 10:21:33 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id s19so2528177ybc.5;
        Fri, 25 Sep 2020 10:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CTJj4j0YVLc5xtMx/0e8C1hkN3+Ymyx4q428pDM27CI=;
        b=WgG9ezLsMqcr0Z28zVliYWTfiVZkrlhtKwpTcEtHHtE69NVCp+IEabANOfP8Sn6o6L
         NToIzJM+qGFIPBW24xVZNAFEfiLFz0oft17FiW/dYznPNzRkl2rgRZzsHOMAaAci1t4A
         aeh9CDEe5g7wQ0vIITcKxl6eR9TnFYMCgoiTn4dyTEbj5FzGe6UQk4Tbc3EJDzRk2ap2
         e5s8pkdECoXKOmQJnVzVgP0IKQaLrPtgzzdyq86TajDFrxhjnuNeB+5lb6gKQ9+BMBae
         F4q9ObSzpITUwhz5M5lpsvSYbQ3UB1Rk2xsri2EwMswG6q+TqlKr1CMgbJIbtgNexI4t
         zjdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CTJj4j0YVLc5xtMx/0e8C1hkN3+Ymyx4q428pDM27CI=;
        b=kIyRQIC1S8y/SwVyeXJyDMT6j6YqHUdYb1h5/FRoiFZOGtZ2muUN6uczAiDw6lFSSO
         tIC+45G1k8BCowtPsGm+aDBuzok4Zb5Edheqb5SEhJuIVVUQrO0GzbJ4X29O754wauF7
         JjJcJjpoC8sHkgo+ZvMAUYXOwRx4O/77aYI8i7qKgaxoi3t6PNOrf/6QGyprhtqFp/ed
         GlGoFkgmJDIF2SQN6AwWXbEse38a2K2+zJRzUdYahdrvrg1O7i4yW+pUPL6NqInLQO38
         ILPs1s4f4pVi97Dai7EVLoP9aogkNtViudiHybH0FYHPfWSHR5V1m1Y8aUWFb59MgWjE
         clYg==
X-Gm-Message-State: AOAM530/pJRiLC+p/LFuZvoYEO34YdeMfdIWFeyjFr3Scr33IVU9LJs+
        su911AOPoeq//DO+h58MptiuhTV1aqEXllqbAL0=
X-Google-Smtp-Source: ABdhPJw37ZyJp9X+wPwW/zdBpGEhcWWxyirdYOBFnxCJiv+y5slkuct3Mq0vJ0TBP+teZMU05Fgwpwigrhym+I2bYKo=
X-Received: by 2002:a25:8541:: with SMTP id f1mr339346ybn.230.1601054492723;
 Fri, 25 Sep 2020 10:21:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200924230209.2561658-1-songliubraving@fb.com> <20200924230209.2561658-2-songliubraving@fb.com>
In-Reply-To: <20200924230209.2561658-2-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 25 Sep 2020 10:21:21 -0700
Message-ID: <CAEf4BzYLwCqMPzYhWfpww-LQULr=ODFCWNfS7vGdOP43goLhrw@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 1/3] bpf: enable BPF_PROG_TEST_RUN for raw_tracepoint
To:     Song Liu <songliubraving@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 4:03 PM Song Liu <songliubraving@fb.com> wrote:
>
> Add .test_run for raw_tracepoint. Also, introduce a new feature that runs
> the target program on a specific CPU. This is achieved by a new flag in
> bpf_attr.test, BPF_F_TEST_RUN_ON_CPU. When this flag is set, the program
> is triggered on cpu with id bpf_attr.test.cpu. This feature is needed for
> BPF programs that handle perf_event and other percpu resources, as the
> program can access these resource locally.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h            |  3 ++
>  include/uapi/linux/bpf.h       |  7 +++
>  kernel/bpf/syscall.c           |  2 +-
>  kernel/trace/bpf_trace.c       |  1 +
>  net/bpf/test_run.c             | 91 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  7 +++
>  6 files changed, 110 insertions(+), 1 deletion(-)

[...]
