Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220471E1AB6
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 07:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgEZFaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 01:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgEZFaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 01:30:10 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5339DC061A0E;
        Mon, 25 May 2020 22:30:10 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id c185so5322946qke.7;
        Mon, 25 May 2020 22:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m5KD4TdD0ILO59F8+Ngg2G7yCxN2FnLmCaPVN/3wcvc=;
        b=oD0tCL6jFYQxeco5LC050cvnvy7dTfZ+2Mzy9Uw8Q1yH90aeiF98c3ehFRg3nDNGIU
         Ox7Yvv3hL5BpWrxZRjIV/uAxDvhQiI5HEhLsYmhK5HZlJoyEjAkWMOPtjveJyghbf1X2
         tB345+RKFYdmr3CciaEECrOHhm+QlCSzF9VbnP5Loovq8rd7f0cHgVOqXYk2IgUtTgym
         KOjT/aQdK0/fcthCv2WRzp30FBip9+L1VVcQPFVvZR1vhLpg9NnucmShse6WRbT7rr9H
         1t18QYsFsdsq2dz97snVgXfrLuywp3AH2vM9d1eLxQ/fvSPrkMKz4ZDPfsh+Pcz1CrdZ
         SfIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m5KD4TdD0ILO59F8+Ngg2G7yCxN2FnLmCaPVN/3wcvc=;
        b=HBpCZn3z6KYDmYAfj5Wq9pN1M6rvasoRd7S8LfzOTWf3fxnt1upvltBb44UQJiNzyz
         CCYeoBGaJYGupm3jKoyx0NHnUnzbF9voWmafvdd1AlFtZVEL5p3zCYyUeAd7+tLMmxGY
         4fc2VSBVcMPAnN6K/RSAnZzUIYh9D25BjeMg7O/5eayiBNbG5Z3sLV5u3WAkYUp2X9P1
         abKiL8ABASXTPH9B9TgEeLHrhnZyKCZ4bLBZgSuAhpUPpjLQ/Y2NiZS+Ve0gDanA+BnD
         DQCkF9Xia8nqGGv0JaJez00Qca4YbMmJTGo+90l50+DiJ69UU8B6mMKQ3iTfLVJduq0h
         aXaQ==
X-Gm-Message-State: AOAM532Kh+mzFe5CJmEQ09qg6QaJ85XYAAdb9b0q47mOI9H4Ao8qut1C
        toH+l+eWTt8dfjlEQTs3XhOjOGdXqEA2FOPUJrE=
X-Google-Smtp-Source: ABdhPJxY+FJt1Nh2U/egoJkZt2Z31lv5hYQhmHMuolTcDstkUNoTDIYi/9C6Ru4pucB2tLUZk7xBbknupPg3pdbqINc=
X-Received: by 2002:a37:a89:: with SMTP id 131mr12315990qkk.92.1590471009492;
 Mon, 25 May 2020 22:30:09 -0700 (PDT)
MIME-Version: 1.0
References: <159042332675.79900.6845937535091126683.stgit@ebuild>
In-Reply-To: <159042332675.79900.6845937535091126683.stgit@ebuild>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 May 2020 22:29:58 -0700
Message-ID: <CAEf4BzZqDz=0nKpxjfkowkXkGiH67eSJCZQxRywFcVT+2UeZ+w@mail.gmail.com>
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
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 2:01 PM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> This new API, perf_buffer__consume, can be used as follows:

I wonder, was it inspired by yet-to-be committed
ring_buffer__consume() or it's just a coincidence?

> - When you have a perf ring where wakeup_events is higher than 1,
>   and you have remaining data in the rings you would like to pull
>   out on exit (or maybe based on a timeout).
> - For low latency cases where you burn a CPU that constantly polls
>   the queues.
>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
>  tools/lib/bpf/libbpf.c   |   23 +++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h   |    1 +
>  tools/lib/bpf/libbpf.map |    1 +
>  3 files changed, 25 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index fa04cbe547ed..cbef3dac7507 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -8456,6 +8456,29 @@ int perf_buffer__poll(struct perf_buffer *pb, int timeout_ms)
>         return cnt < 0 ? -errno : cnt;
>  }
>
> +int perf_buffer__consume(struct perf_buffer *pb)
> +{
> +       int i;
> +
> +       if (!pb)
> +               return -EINVAL;

we don't check this in perf_buffer__poll, IMO, checking this in every
"method" is an overkill.

> +
> +       if (!pb->cpu_bufs)
> +               return 0;

no need to check. It's either non-NULL for valid perf_buffer, or
calloc could return NULL if pb->cpu_cnt is zero (not sure it's
possible, but still), but then loop below will never access
pb->cpu_bufs[i].

> +
> +       for (i = 0; i < pb->cpu_cnt && pb->cpu_bufs[i]; i++) {

I think pb->cpu_bufs[i] check is wrong, it will stop iteration
prematurely if cpu_bufs are sparsely populated. So move check inside
and continue loop if NULL.

> +               int err;

nit: declare it together with "i" above, similar to how
perf_buffer__poll does it

> +               struct perf_cpu_buf *cpu_buf = pb->cpu_bufs[i];
> +
> +               err = perf_buffer__process_records(pb, cpu_buf);
> +               if (err) {
> +                       pr_warn("error while processing records: %d\n", err);
> +                       return err;
> +               }
> +       }
> +       return 0;
> +}
> +
>  struct bpf_prog_info_array_desc {
>         int     array_offset;   /* e.g. offset of jited_prog_insns */
>         int     count_offset;   /* e.g. offset of jited_prog_len */
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 8ea69558f0a8..1e2e399a5f2c 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -533,6 +533,7 @@ perf_buffer__new_raw(int map_fd, size_t page_cnt,
>
>  LIBBPF_API void perf_buffer__free(struct perf_buffer *pb);
>  LIBBPF_API int perf_buffer__poll(struct perf_buffer *pb, int timeout_ms);
> +LIBBPF_API int perf_buffer__consume(struct perf_buffer *pb);
>
>  typedef enum bpf_perf_event_ret
>         (*bpf_perf_event_print_t)(struct perf_event_header *hdr,
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 0133d469d30b..381a7342ecfc 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -262,4 +262,5 @@ LIBBPF_0.0.9 {
>                 bpf_link_get_fd_by_id;
>                 bpf_link_get_next_id;
>                 bpf_program__attach_iter;
> +               perf_buffer__consume;
>  } LIBBPF_0.0.8;
>
