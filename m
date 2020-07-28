Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BB0230242
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 08:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgG1GDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 02:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgG1GDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 02:03:41 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032A0C061794;
        Mon, 27 Jul 2020 23:03:40 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id j10so1965070qvo.13;
        Mon, 27 Jul 2020 23:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VyTixMuApQUrPqM0mv6yOj0mSjNApbkD53XtwGXYy6Y=;
        b=AKGzFc0uYTO8QbYO3W5w7hwDzHrVNlkDlzyTRfVH0VLZ2QLZCPIiG51u5qaVmw5qhD
         j8I8MIIz33Jeg0YAVhE38RGbu6qGpdUX66O1h5/ZOzx0sjQxIm3jKN49gUcC8pX3JKmA
         inZhpTtQk+86ejo+PzouvOaMGcRLaqWzK9dX9JUohtjt51zItfpyVkE+KIIVtevhmEjm
         ZJ+GYEixaUdUoSX1MGHKUKG3TOxqMXhejAbmF9ZkIh2LRpVeyM0ZAafCC1ujAo3NOcWP
         m134Tx2J+zmO8mQyAVuOqcjU9p/O7YXqOMX03/Dn/+rsJn3S8QbGvl0dNvDA1Ef9r/li
         bQkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VyTixMuApQUrPqM0mv6yOj0mSjNApbkD53XtwGXYy6Y=;
        b=KfkcyUwy5LoeNvqon4WUzn0pfCXf+JhxMO8/6amnAZRKDBFi8fCFhZVLcJluiMxt3e
         3UI87qcgUgCOMRnzPkqe7IdblHOAw/IieEv77FwD11Jd8YaMaP2nu9++wd2JvfcOgOyO
         MUhsmYShzVx1NQwXe5ra0VqmiKSoJBF6cNExaAEbOtr1wkJxib5sT95W8dcFbyIa+uBD
         L5cTw9WoSd+pj+H7kvGVFG+u7J26xi8CQuV8J++A+cpriGnEtd5j62OTeVIrLrY15AC9
         dEp54fHYxQFTQZ+XTSwr7d/NVQWIDP40bwCSdE+gwjatJLPXVDH1GCLjydBKj4ymioVI
         tkhA==
X-Gm-Message-State: AOAM5324ZGwqMBe8OkvPz0T6mHX4/hBXK9nqn4ws9OBe+iGyfNpMxOOa
        tDKO4/MKq6/KcBQ65xZzpJzvJIoTtIb1ovabcNukJA==
X-Google-Smtp-Source: ABdhPJzpuvI/PnQt0muw26eujYdfWz25QglG9zSeJl+ePzDEoquT/Euuyx3vu62IDInhlpVP8a5odclUBsHzYJtLVU8=
X-Received: by 2002:a0c:bf4f:: with SMTP id b15mr24284471qvj.224.1595916220194;
 Mon, 27 Jul 2020 23:03:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-32-guro@fb.com>
In-Reply-To: <20200727184506.2279656-32-guro@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Jul 2020 23:03:29 -0700
Message-ID: <CAEf4BzYhTeehgbFKwOkrjEzXH5NkKF6BTvZyiS-PRTdXetKEUQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 31/35] bpf: runqslower: don't touch RLIMIT_MEMLOCK
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 12:24 PM Roman Gushchin <guro@fb.com> wrote:
>
> Since bpf is not using memlock rlimit for memory accounting,
> there are no more reasons to bump the limit.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>
> ---
>  tools/bpf/runqslower/runqslower.c | 16 ----------------
>  1 file changed, 16 deletions(-)
>

This can go, I suppose, we still have a runqslower variant in BCC with
this logic, to show an example on what/how to do this for kernels
without this patch set applied.

Acked-by: Andrii Nakryiko <andriin@fb.com>

> diff --git a/tools/bpf/runqslower/runqslower.c b/tools/bpf/runqslower/runqslower.c
> index d89715844952..a3380b53ce0c 100644
> --- a/tools/bpf/runqslower/runqslower.c
> +++ b/tools/bpf/runqslower/runqslower.c
> @@ -88,16 +88,6 @@ int libbpf_print_fn(enum libbpf_print_level level,
>         return vfprintf(stderr, format, args);
>  }
>
> -static int bump_memlock_rlimit(void)
> -{
> -       struct rlimit rlim_new = {
> -               .rlim_cur       = RLIM_INFINITY,
> -               .rlim_max       = RLIM_INFINITY,
> -       };
> -
> -       return setrlimit(RLIMIT_MEMLOCK, &rlim_new);
> -}
> -
>  void handle_event(void *ctx, int cpu, void *data, __u32 data_sz)
>  {
>         const struct event *e = data;
> @@ -134,12 +124,6 @@ int main(int argc, char **argv)
>
>         libbpf_set_print(libbpf_print_fn);
>
> -       err = bump_memlock_rlimit();
> -       if (err) {
> -               fprintf(stderr, "failed to increase rlimit: %d", err);
> -               return 1;
> -       }
> -
>         obj = runqslower_bpf__open();
>         if (!obj) {
>                 fprintf(stderr, "failed to open and/or load BPF object\n");
> --
> 2.26.2
>
