Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98D23F68AE
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 20:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236273AbhHXSD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 14:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238513AbhHXSDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 14:03:51 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D9AC03548E;
        Tue, 24 Aug 2021 10:57:24 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id ot2-20020a17090b3b4200b0019127f8ed87so2382040pjb.1;
        Tue, 24 Aug 2021 10:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+WKwwUMH4xWWD/7HDfYwAhZrTyGRfS9CqtomdlXy7No=;
        b=L8Bw6jYE0IpdyZuxzoCse1zdVPdpug/6hno/nJmwmFL9vjLuPHuu3AXbPEny79pgK2
         Qz5XImXs9VIEOMwz4MqBnT3JR6knjWWyltsQSbznXOXyJ99A6lJ0MTgzI8PuPn9tnEKi
         iLO6U1JRzEJU3wsUb9WT+Ej3X5cq1O/uGi7vvZUCTO5OWolQT43k0pCUNMLBcvy4KHE6
         XJmiyB5sfqqbMPw6ASA5H8idwzfIHnSF1k7mO2xno6+TjMAProq1/30J+W8UzXQ4k+vv
         vB4J4saqnZCmcGLoa76HPc9frwjJvhG57vXmfGYnlm/4tuDHdyYB+TMT5poQbXHGhMQE
         +pSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+WKwwUMH4xWWD/7HDfYwAhZrTyGRfS9CqtomdlXy7No=;
        b=SdUDbFrF4xqLO4LBrd15eVGgIil8ehjQ4jdP9EyG5YGJWc5zhTahONElcn0EYlbbOu
         82j0rUVr9M9brP4yN07j6KKkd8G32sIzHsZOuSbRHAApUjJmWJhqc51elaMfhX0n3nmr
         raw0ynYvvwOkDNNi6Awp3pUB4xsDBMMNITL4emuG0gGxtpDBHxMStDlbqDAQSTbUa2Ud
         jF2FxzvafiC/nM4A3eybQkRZDxOjtlU31EH3HLohhGlGI1vEOtn0q2wiMq3jT78MGWxZ
         sf7OC3agkIOd3LJuTY4NyoP8dYXInCW0qckIxQz41e3eNiKDH/OnJGe1nWpzmwO5FOUD
         5fcA==
X-Gm-Message-State: AOAM531CQaxdSy4NjJr6ErY3qPCE3HAdp0t93l3HBRa83g7tnO/Rb6kV
        y6GpG+LVez0+FlCf+sqTDBCKsqSm7uQ4TwfEW28=
X-Google-Smtp-Source: ABdhPJwrs+oXB8zn+sBUmd43Dx+cV11fcxSjeQqmZ0MiRSpLpZfGEzDKvTVBzbAMCZzyl8zeZoVeqM5znLmOc7mQIzs=
X-Received: by 2002:a17:90a:ee86:: with SMTP id i6mr5723981pjz.1.1629827843897;
 Tue, 24 Aug 2021 10:57:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210821025837.1614098-1-davemarchevsky@fb.com>
 <20210821025837.1614098-3-davemarchevsky@fb.com> <CAEf4BzYEOzfmwi8n8K_W_6Pc+gC081ncmRCAq8Fz0vr=y7eMcg@mail.gmail.com>
In-Reply-To: <CAEf4BzYEOzfmwi8n8K_W_6Pc+gC081ncmRCAq8Fz0vr=y7eMcg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 24 Aug 2021 10:57:13 -0700
Message-ID: <CAADnVQLUWHO0EhLhMVATc9-z11H7ROF6DCmJ=sW+-iP1baeWWg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/5] bpf: add bpf_trace_vprintk helper
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Dave Marchevsky <davemarchevsky@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Florent Revest <revest@chromium.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 9:50 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Aug 20, 2021 at 7:59 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
> >
> > This helper is meant to be "bpf_trace_printk, but with proper vararg
>
> We have bpf_snprintf() and bpf_seq_printf() names for other BPF
> helpers using the same approach. How about we call this one simply
> `bpf_printf`? It will be in line with other naming, it is logical BPF
> equivalent of user-space printf (which outputs to stderr, which in BPF
> land is /sys/kernel/debug/tracing/trace_pipe). And it will be logical
> to have a nice and short BPF_PRINTF() convenience macro provided by
> libbpf.
>
> > support". Follow bpf_snprintf's example and take a u64 pseudo-vararg
> > array. Write to dmesg using the same mechanism as bpf_trace_printk.
>
> Are you sure about the dmesg part?... bpf_trace_printk is outputting
> into /sys/kernel/debug/tracing/trace_pipe.

Actually I like bpf_trace_vprintk() name, since it makes it obvious that
it's a flavor of bpf_trace_printk() and its quirks that users learned
to deal with.
I would reserve bpf_printf() for the future. We might have standalone
bpf programs in the future (without user space component) and a better
equivalent
of stdin/stdout. clang -target bpf hello_world.c -o a.out; ./a.out
should print to a terminal. Such future hello world in bpf would be
using bpf_printf()
or bpf_dprintf().
