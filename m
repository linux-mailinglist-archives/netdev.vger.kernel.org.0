Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7742531EB5
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 00:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiEWWnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 18:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiEWWnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 18:43:23 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164F9ABF48;
        Mon, 23 May 2022 15:43:22 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id 3so10798244ily.2;
        Mon, 23 May 2022 15:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4z/iwgVrp0ukuHP0yEWJrSr5H7DsDenyaC4SaaPjbgw=;
        b=PO8qB/TmPhfrifhrSpsXzaKD1Uncs+AiuBTMfZaMbASr/c0rQun3FOK97jQXz4cffX
         z8vzjGtq+EmTfbIMzcSZKPhllCUQFK0zr35zQIB7tA4pahXRGN0EVZX7qEKnltG2zzPK
         bjEWXmpiHdRyMwqmorBusWx5/MYbiV11tvShlfOp/ck+LP/LUju77awDz+m73Kg2hWrN
         0rrOOyEduQYVQ70lJdPaoWo3JHTQVK47Hz9LtskheDxWfBMsysdrn1Gp7ktGo8aZowNr
         ls+38XPbISiVXcd7JB6y7ZdnOOXYEiWAQZM0FHnnNiL+Jv9g2i0JbGtboAwNoXkPpSk9
         vb/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4z/iwgVrp0ukuHP0yEWJrSr5H7DsDenyaC4SaaPjbgw=;
        b=TKOMTvk/EfrghW5sHnRP2uuZwNukXAbj98jeaIifTrOE2CrbE2SQMVNh7yUgHpihaN
         oe+focAUl0mWsbzFmf/Rwz8mgrnR0wskTOeFMyiJLdmdRG41DYqH7KfSIYg9ZLmuU8a6
         5bPWkrmrcvVdXFGTqrJme8u0ltl+SWJ6m/0FGDPN/Ri3k/CfvPuGWKlnUVICe6BjVXDU
         Rco/FRB1j+dwgUTV9dt6xgkLbCHf9HmYsU/uQU7DrRIrI8kdzc2HToysRfsbvVUGtUIw
         ZIf5+N50qT8OHiLpSLfrz+09wrlVR4K1b4uG9kNCAXBWxd0qyF5LlLBawCKPoBdZriPy
         foXQ==
X-Gm-Message-State: AOAM530CvYOMqAvyRFgsTGcbfHeLFWN9ilyihJPIx7ktw0KESTTn2ODR
        H1Rg/hYn7MYsOyQJCse+VzMeqtPlncmAjNwxCbc=
X-Google-Smtp-Source: ABdhPJzJJVJD/PLQLgGbm7LIqKqw3cIejTXmDdnef3swmIMtAay3abe77le37tDVs+dST38MrDX9hIWp0TThoVKIvdw=
X-Received: by 2002:a05:6e02:1352:b0:2d1:6424:60b8 with SMTP id
 k18-20020a056e02135200b002d1642460b8mr11798302ilr.305.1653345801408; Mon, 23
 May 2022 15:43:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220510074659.2557731-1-jolsa@kernel.org> <CAEf4BzbK9zgetgE1yKkCANTZqizUrXgamJa2X0f0XmzQUdFrCQ@mail.gmail.com>
 <YntnRixbfQ1HCm9T@krava> <Ynv+7iaaAbyM38B6@kernel.org> <CAEf4BzaQsF31f3WuU32wDCzo6bw7eY8E9zF6Lo218jfw-VQmcA@mail.gmail.com>
 <YoTAhC+6j4JshqN8@krava> <YoYj6cb0aPNN/olH@krava> <CAEf4Bzaa60kZJbWT0xAqcDMyXBzbg98ShuizJAv7x+8_3X0ZBg@mail.gmail.com>
 <Yokk5XRxBd72fqoW@kernel.org> <Yos8hq3NmBwemoJw@krava>
In-Reply-To: <Yos8hq3NmBwemoJw@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 May 2022 15:43:10 -0700
Message-ID: <CAEf4BzYRJj8sXjYs2ioz6Qq7L2UshZDi4Kt0XLsLtwQSGCpAzg@mail.gmail.com>
Subject: Re: [PATCHv2 0/3] perf tools: Fix prologue generation
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 12:49 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Sat, May 21, 2022 at 02:44:05PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, May 20, 2022 at 02:46:49PM -0700, Andrii Nakryiko escreveu:
> > > On Thu, May 19, 2022 at 4:03 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> > > > On Wed, May 18, 2022 at 11:46:44AM +0200, Jiri Olsa wrote:
> > > > > On Tue, May 17, 2022 at 03:02:53PM -0700, Andrii Nakryiko wrote:
> > > > > > Jiri, libbpf v0.8 is out, can you please re-send your perf patches?
> >
> > > > > yep, just made new fedora package.. will resend the perf changes soon
> >
> > > > fedora package is on the way, but I'll need perf/core to merge
> > > > the bpf_program__set_insns change.. Arnaldo, any idea when this
> > > > could happen?
> >
> > > Can we land these patches through bpf-next to avoid such complicated
> > > cross-tree dependencies? As I started removing libbpf APIs I also
> > > noticed that perf is still using few other deprecated APIs:
> > >   - bpf_map__next;
> > >   - bpf_program__next;
> > >   - bpf_load_program;
> > >   - btf__get_from_id;
>
> these were added just to bypass the time window when they were not
> available in the package, so can be removed now (in the patch below)
>
> >
> > > It's trivial to fix up, but doing it across few trees will delay
> > > libbpf work as well.
> >
> > > So let's land this through bpf-next, if Arnaldo doesn't mind?
> >
> > Yeah, that should be ok, the only consideration is that I'm submitting
> > this today to Linus:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/commit/?h=tmp.perf/urgent&id=0ae065a5d265bc5ada13e350015458e0c5e5c351
> >
> > To address this:
> >
> > https://lore.kernel.org/linux-perf-users/f0add43b-3de5-20c5-22c4-70aff4af959f@scylladb.com/
>
> ok, we can do that via bpf-next, but of course there's a problem ;-)
>
> perf/core already has dependency commit [1]
>
> so either we wait for perf/core and bpf-next/master to sync or:
>
>   - perf/core reverts [1] and
>   - bpf-next/master takes [1] and the rest
>
> I have the changes ready if you guys are ok with that

So, if I understand correctly, with merge window open bpf-next/master
will get code from perf/core soon when we merge tip back in. So we can
wait for that to happen and not revert anything.

So please add the below patch to your series and resend once tip is
merged into bpf-next? Thanks!

>
> thanks,
> jirka
>
>
> [1] https://lore.kernel.org/bpf/20220422100025.1469207-4-jolsa@kernel.org/
>
> ---
> Subject: [PATCH bpf-next] perf tools: Remove the weak libbpf functions
>
> We added weak functions for some new libbpf functions because
> they were not packaged at that time [1].
>
> These functions are now available in package, so we can remove
> their weak perf variants.
>
> [1] https://lore.kernel.org/linux-perf-users/20211109140707.1689940-2-jolsa@kernel.org/
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/util/bpf-event.c | 51 -------------------------------------
>  1 file changed, 51 deletions(-)
>
> diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
> index 94624733af7e..025f331b3867 100644
> --- a/tools/perf/util/bpf-event.c
> +++ b/tools/perf/util/bpf-event.c
> @@ -22,57 +22,6 @@
>  #include "record.h"
>  #include "util/synthetic-events.h"
>
> -struct btf * __weak btf__load_from_kernel_by_id(__u32 id)
> -{
> -       struct btf *btf;
> -#pragma GCC diagnostic push
> -#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
> -       int err = btf__get_from_id(id, &btf);
> -#pragma GCC diagnostic pop
> -
> -       return err ? ERR_PTR(err) : btf;
> -}
> -
> -int __weak bpf_prog_load(enum bpf_prog_type prog_type,
> -                        const char *prog_name __maybe_unused,
> -                        const char *license,
> -                        const struct bpf_insn *insns, size_t insn_cnt,
> -                        const struct bpf_prog_load_opts *opts)
> -{
> -#pragma GCC diagnostic push
> -#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
> -       return bpf_load_program(prog_type, insns, insn_cnt, license,
> -                               opts->kern_version, opts->log_buf, opts->log_size);
> -#pragma GCC diagnostic pop
> -}
> -
> -struct bpf_program * __weak
> -bpf_object__next_program(const struct bpf_object *obj, struct bpf_program *prev)
> -{
> -#pragma GCC diagnostic push
> -#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
> -       return bpf_program__next(prev, obj);
> -#pragma GCC diagnostic pop
> -}
> -
> -struct bpf_map * __weak
> -bpf_object__next_map(const struct bpf_object *obj, const struct bpf_map *prev)
> -{
> -#pragma GCC diagnostic push
> -#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
> -       return bpf_map__next(prev, obj);
> -#pragma GCC diagnostic pop
> -}
> -
> -const void * __weak
> -btf__raw_data(const struct btf *btf_ro, __u32 *size)
> -{
> -#pragma GCC diagnostic push
> -#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
> -       return btf__get_raw_data(btf_ro, size);
> -#pragma GCC diagnostic pop
> -}
> -
>  static int snprintf_hex(char *buf, size_t size, unsigned char *data, size_t len)
>  {
>         int ret = 0;
> --
> 2.35.3
>
