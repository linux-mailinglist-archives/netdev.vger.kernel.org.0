Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDBD31E2938
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388928AbgEZRkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388061AbgEZRkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 13:40:35 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5064C03E96D;
        Tue, 26 May 2020 10:40:35 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id l3so9842542qvo.7;
        Tue, 26 May 2020 10:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Qb+yBWRLKYxH7UqNrksjpc0mUvlYqjaZssX2PBNYDD8=;
        b=rS2CV3OKs95vc6mBre1VvOg0yINpVuR2K+Vr3/o8BSW/WAw0vZizsBtzA2KX0wtyD4
         qxNBeo+eNcZHZLev0sVZBhD06B4UhKFlhEaGFCfdnq6lsrAcRlfdhA1yO+7oStfJYTfF
         5cvVpYG/Xi4KpXfoeT5Is9/O0cpDrRPIJ69k+dkMioQddm++XGIvWGjo1AJPVgRHmxvJ
         009ECegQ5chyPuSSGdLGr+p1JWYe4BnOwk0X6XiLabLgR3l2jUmspX8d/hmE2wctqGX1
         t2WthMdSz8alKXdoWU8vPW76qdY+ueJRxJubPIW4mAQsTGvw1ClYV04fScF+LeUmstiB
         k2hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Qb+yBWRLKYxH7UqNrksjpc0mUvlYqjaZssX2PBNYDD8=;
        b=EjmqJY0oklrBDhkuYLgUai6b6Kcw+w6v3+tAZcTB/2NvCSZC9svYEpFIErNgUf7HB3
         JjHL10PqoA1e2A4I95h8NpW2AkOrydqEOIDt5+Orz7tUiRv0hb4EU2UPzdlUlh3ZsIWG
         fA8/nILiSwTn60bMb5+VdmjDqDAnlM2MKt5Xh52KQRhpFekr8X/VROEf50ApXUdZXIjJ
         mqCnumSLXmj2EtQatI3cP2Zc1u5GCv0t6PCvTjiGGTZfu6WQU+xhKuQJYNBM/HngkuES
         TRXDPqJcqhtgYk4d3MeC0laBOv9GxxP7NmeLpR0kGYatX9xAsU9VlERQDX782X11hUNL
         u/iw==
X-Gm-Message-State: AOAM530PbHAMXpdNuBdVetnAHqFnN1q4ktMNrFKsYzmvIxnj6ZDZ2JJt
        0qWWfRv9aHS+YfWFxTs8dq3FqbZp0KzZLJcUkpIAS2CE6eB3sQ==
X-Google-Smtp-Source: ABdhPJx66BcJwXQyt+0F15+M/l3RHSkuq2b2r6veZfnixsWv0/r7en8Tvgl9PIHhSKw//ZskGURLSQyIHBM9NSs6BW8=
X-Received: by 2002:a0c:b92f:: with SMTP id u47mr7719557qvf.247.1590514834628;
 Tue, 26 May 2020 10:40:34 -0700 (PDT)
MIME-Version: 1.0
References: <159042332675.79900.6845937535091126683.stgit@ebuild>
 <CAEf4BzZqDz=0nKpxjfkowkXkGiH67eSJCZQxRywFcVT+2UeZ+w@mail.gmail.com> <51FAF2C0-F843-45EF-8CE7-69FD0334AD84@redhat.com>
In-Reply-To: <51FAF2C0-F843-45EF-8CE7-69FD0334AD84@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 26 May 2020 10:40:23 -0700
Message-ID: <CAEf4Bza9f9_YWHjcXQS4dkvRt4kwxFOv8YQdkUCQYpOcvU-GVA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: add API to consume the perf ring buffer content
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 1:07 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
>
>
> On 26 May 2020, at 7:29, Andrii Nakryiko wrote:
>
> > On Mon, May 25, 2020 at 2:01 PM Eelco Chaudron <echaudro@redhat.com>
> > wrote:
> >>
> >> This new API, perf_buffer__consume, can be used as follows:
> >
> > I wonder, was it inspired by yet-to-be committed
> > ring_buffer__consume() or it's just a coincidence?
>
> Just coincidence, I was needing a function to flush the remaining ring
> entries, as I was using a larger wakeup_events value.
> Initially, I called the function ring_buffer_flush(), but once I noticed
> your patch I renamed it :)

Nice, thanks, I love consistent naming :)

>
> >> - When you have a perf ring where wakeup_events is higher than 1,
> >>   and you have remaining data in the rings you would like to pull
> >>   out on exit (or maybe based on a timeout).
> >> - For low latency cases where you burn a CPU that constantly polls
> >>   the queues.
> >>
> >> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> >> ---
> >>  tools/lib/bpf/libbpf.c   |   23 +++++++++++++++++++++++
> >>  tools/lib/bpf/libbpf.h   |    1 +
> >>  tools/lib/bpf/libbpf.map |    1 +
> >>  3 files changed, 25 insertions(+)
> >>
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index fa04cbe547ed..cbef3dac7507 100644
> >> --- a/tools/lib/bpf/libbpf.c
> >> +++ b/tools/lib/bpf/libbpf.c
> >> @@ -8456,6 +8456,29 @@ int perf_buffer__poll(struct perf_buffer *pb,
> >> int timeout_ms)
> >>         return cnt < 0 ? -errno : cnt;
> >>  }
> >>
> >> +int perf_buffer__consume(struct perf_buffer *pb)
> >> +{
> >> +       int i;
> >> +
> >> +       if (!pb)
> >> +               return -EINVAL;
> >
> > we don't check this in perf_buffer__poll, IMO, checking this in every
> > "method" is an overkill.
>
> Ack, will fix in v2
>
> >> +
> >> +       if (!pb->cpu_bufs)
> >> +               return 0;
> >
> > no need to check. It's either non-NULL for valid perf_buffer, or
> > calloc could return NULL if pb->cpu_cnt is zero (not sure it's
> > possible, but still), but then loop below will never access
> > pb->cpu_bufs[i].
>
> Agreed, was just adding some safety checks, but in the constantly poll
> mode this is a lot of overhead. Will remover in v2.
>
> >> +
> >> +       for (i =3D 0; i < pb->cpu_cnt && pb->cpu_bufs[i]; i++) {
> >
> > I think pb->cpu_bufs[i] check is wrong, it will stop iteration
> > prematurely if cpu_bufs are sparsely populated. So move check inside
> > and continue loop if NULL.
>
> Mimicked the behavior from other functions, however just to be safe I
> split it up.

You mean perf_buffer__poll() or perf_buffer__free() loop? In the
perf_buffer__poll() case, first N events will always correspond to
non-NULL buffers. It's very different from what you are doing here.
But I think perf_buffer__free() actually is buggy similarly to how I
pointed out in this case. We need to fix that.

>
> >> +               int err;
> >
> > nit: declare it together with "i" above, similar to how
> > perf_buffer__poll does it
>
> Put it down here as it=E2=80=99s only used in the context of the for loop=
, but
> will move it up in the v2.
>
> >> +               struct perf_cpu_buf *cpu_buf =3D pb->cpu_bufs[i];
> >> +
> >> +               err =3D perf_buffer__process_records(pb, cpu_buf);
> >> +               if (err) {
> >> +                       pr_warn("error while processing records:
> >> %d\n", err);
> >> +                       return err;
> >> +               }
> >> +       }
> >> +       return 0;
> >> +}
> >> +
> >>  struct bpf_prog_info_array_desc {
> >>         int     array_offset;   /* e.g. offset of jited_prog_insns */
> >>         int     count_offset;   /* e.g. offset of jited_prog_len */
> >> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> >> index 8ea69558f0a8..1e2e399a5f2c 100644
> >> --- a/tools/lib/bpf/libbpf.h
> >> +++ b/tools/lib/bpf/libbpf.h
> >> @@ -533,6 +533,7 @@ perf_buffer__new_raw(int map_fd, size_t page_cnt,
> >>
> >>  LIBBPF_API void perf_buffer__free(struct perf_buffer *pb);
> >>  LIBBPF_API int perf_buffer__poll(struct perf_buffer *pb, int
> >> timeout_ms);
> >> +LIBBPF_API int perf_buffer__consume(struct perf_buffer *pb);
> >>
> >>  typedef enum bpf_perf_event_ret
> >>         (*bpf_perf_event_print_t)(struct perf_event_header *hdr,
> >> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> >> index 0133d469d30b..381a7342ecfc 100644
> >> --- a/tools/lib/bpf/libbpf.map
> >> +++ b/tools/lib/bpf/libbpf.map
> >> @@ -262,4 +262,5 @@ LIBBPF_0.0.9 {
> >>                 bpf_link_get_fd_by_id;
> >>                 bpf_link_get_next_id;
> >>                 bpf_program__attach_iter;
> >> +               perf_buffer__consume;
> >>  } LIBBPF_0.0.8;
> >>
>
> Thanks for the review, will send out a v2 soon.
>
