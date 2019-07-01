Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 942F85C5DD
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 01:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfGAXKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 19:10:05 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40543 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfGAXKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 19:10:05 -0400
Received: by mail-qk1-f194.google.com with SMTP id c70so12462899qkg.7;
        Mon, 01 Jul 2019 16:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ozc2epaEhBjK10QA2aMYneBn32OLQ9GI44tV4a+7BYg=;
        b=op6ieNUYwffV1Qpn6RIioFB5AnIRRFnT1vQj0A6j366MG6auwBGY+nprkPISAkOAt0
         TekLBpskT489NjhjP7+nKl4tc4/c6Vru4mNjOt8U2Q9sptQLuBp9H9hNeWynh2Mf9yqo
         N+djaiCcngeg+U5hmLmesjfsJlD7W3XxzF9SuN9BRQYzFr7KpJke85ny5+nI10gcosoQ
         kBKCs0Zc6jODjVWwIMesYAkkHLgq98m7noJoBUeBGXSy33F++5BMv/mQg3P2UlvbI4VM
         zixJfDDHFQAFiFtLj4BSsDGNZ9iJyUuHSp/DfnctQ2Dzti2d7qB0bPLoDxyjwvpN1Zn5
         35aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ozc2epaEhBjK10QA2aMYneBn32OLQ9GI44tV4a+7BYg=;
        b=BW6wGaS7Vl7ayIi+bNcxKAB190aRBmvrerJq2y8/LqxYnhHjHhstbSAxg8TKcI2pa7
         cveXuF2z0h28O3kAvCpYU+N+79fm+C2OhFrfbETh35IPFEZybPI9jL6II+6h+6fwcUqE
         ppFOqe+HAJTBFwb4AnYyTZxEC4NQM2o1U2W2Y9a/F8UUBGGLflAprWjkIOBOi2DY+JNt
         tK+HzgV/j5bPEzfGE7SfgSKejDuTIPR+tZ7G0hvPLjoBWUAPjegBhnozXsTQS5rMI7cL
         jaa8KzEb7BnJGmeiontIvhr8Jc8Zt4EyxHG9LHoLca0gTvVo9kHwFf9MpvuDkn0eK4K0
         lkpg==
X-Gm-Message-State: APjAAAX0/7mCZWTUY4MA2SahtW4LFfKdViw0UsWSNjQIi/4vCVw3rEm/
        zdDtmWSJft9s/1EeOVfqh1sOsDSwTD8Flzux4mq8JrVTUmE=
X-Google-Smtp-Source: APXvYqzTu3rpmBY072pUIUwOl9O9XIKqBTycW4t68Fpg4E0mjR+u8vp9xjhwyW90j59UtOJ1oC8Cq/GMJH660GKn5nI=
X-Received: by 2002:a05:620a:16a6:: with SMTP id s6mr22668381qkj.39.1562022603582;
 Mon, 01 Jul 2019 16:10:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190629034906.1209916-1-andriin@fb.com> <20190629034906.1209916-7-andriin@fb.com>
 <e6be6907-4587-6106-9868-e76fbf38a3f5@fb.com> <CAEf4BzYRpgE5VPwuv2zkXZ2N9BQVPASvYbtsZDM10C1kwdX3eg@mail.gmail.com>
 <cf314380-a96e-eae6-6fb5-b136c50cec71@fb.com>
In-Reply-To: <cf314380-a96e-eae6-6fb5-b136c50cec71@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Jul 2019 16:09:52 -0700
Message-ID: <CAEf4BzaMRq3TG-WGvHhOQ1_LyE44dNabNtSbmaE9+99HQ4yiUg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 6/9] libbpf: add raw tracepoint attach API
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "sdf@fomichev.me" <sdf@fomichev.me>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 4:04 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/1/19 3:26 PM, Andrii Nakryiko wrote:
> > On Mon, Jul 1, 2019 at 10:13 AM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 6/28/19 8:49 PM, Andrii Nakryiko wrote:
> >>> Add a wrapper utilizing bpf_link "infrastructure" to allow attaching BPF
> >>> programs to raw tracepoints.
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>> Acked-by: Song Liu <songliubraving@fb.com>
> >>> ---
> >>>    tools/lib/bpf/libbpf.c   | 37 +++++++++++++++++++++++++++++++++++++
> >>>    tools/lib/bpf/libbpf.h   |  3 +++
> >>>    tools/lib/bpf/libbpf.map |  1 +
> >>>    3 files changed, 41 insertions(+)
> >>>
> >>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >>> index 8ad4f915df38..f8c7a7ecb35e 100644
> >>> --- a/tools/lib/bpf/libbpf.c
> >>> +++ b/tools/lib/bpf/libbpf.c
> >>> @@ -4263,6 +4263,43 @@ struct bpf_link *bpf_program__attach_tracepoint(struct bpf_program *prog,
> >>>        return link;
> >>>    }
> >>>
> >>> +static int bpf_link__destroy_fd(struct bpf_link *link)
> >>> +{
> >>> +     struct bpf_link_fd *l = (void *)link;
> >>> +
> >>> +     return close(l->fd);
> >>> +}
> >>> +
> >>> +struct bpf_link *bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
> >>> +                                                 const char *tp_name)
> >>> +{
> >>> +     char errmsg[STRERR_BUFSIZE];
> >>> +     struct bpf_link_fd *link;
> >>> +     int prog_fd, pfd;
> >>> +
> >>> +     prog_fd = bpf_program__fd(prog);
> >>> +     if (prog_fd < 0) {
> >>> +             pr_warning("program '%s': can't attach before loaded\n",
> >>> +                        bpf_program__title(prog, false));
> >>> +             return ERR_PTR(-EINVAL);
> >>> +     }
> >>> +
> >>> +     link = malloc(sizeof(*link));
> >>> +     link->link.destroy = &bpf_link__destroy_fd;
> >>
> >> You can move the "link = malloc(...)" etc. after
> >> bpf_raw_tracepoint_open(). That way, you do not need to free(link)
> >> in the error case.
> >
> > It's either `free(link)` here, or `close(pfd)` if malloc fails after
> > we attached program. Either way extra clean up is needed. I went with
> > the first one.
>
> Okay with me.
> BTW, do you want to check whether malloc() may failure and link may be NULL?

Oh, you have a fresh eye! ;) fixed.

>
> >>
> >>> +
> >>> +     pfd = bpf_raw_tracepoint_open(tp_name, prog_fd);
> >>> +     if (pfd < 0) {
> >>> +             pfd = -errno;
> >>> +             free(link);
> >>> +             pr_warning("program '%s': failed to attach to raw tracepoint '%s': %s\n",
> >>> +                        bpf_program__title(prog, false), tp_name,
> >>> +                        libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
> >>> +             return ERR_PTR(pfd);
> >>> +     }
> >>> +     link->fd = pfd;
> >>> +     return (struct bpf_link *)link;
> >>> +}
> >>> +
> >>>    enum bpf_perf_event_ret
> >>>    bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
> >>>                           void **copy_mem, size_t *copy_size,
> >>> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> >>> index 60611f4b4e1d..f55933784f95 100644
> >>> --- a/tools/lib/bpf/libbpf.h
> >>> +++ b/tools/lib/bpf/libbpf.h
> >>> @@ -182,6 +182,9 @@ LIBBPF_API struct bpf_link *
> >>>    bpf_program__attach_tracepoint(struct bpf_program *prog,
> >>>                               const char *tp_category,
> >>>                               const char *tp_name);
> >>> +LIBBPF_API struct bpf_link *
> >>> +bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
> >>> +                                const char *tp_name);
> >>>
> >>>    struct bpf_insn;
> >>>
> >>> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> >>> index 3c618b75ef65..e6b7d4edbc93 100644
> >>> --- a/tools/lib/bpf/libbpf.map
> >>> +++ b/tools/lib/bpf/libbpf.map
> >>> @@ -171,6 +171,7 @@ LIBBPF_0.0.4 {
> >>>                bpf_object__load_xattr;
> >>>                bpf_program__attach_kprobe;
> >>>                bpf_program__attach_perf_event;
> >>> +             bpf_program__attach_raw_tracepoint;
> >>>                bpf_program__attach_tracepoint;
> >>>                bpf_program__attach_uprobe;
> >>>                btf_dump__dump_type;
> >>>
