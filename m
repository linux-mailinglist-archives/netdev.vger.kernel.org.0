Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6C45455B0
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 22:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344914AbiFIUcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 16:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235367AbiFIUcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 16:32:07 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F402D2315E;
        Thu,  9 Jun 2022 13:32:05 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id l18so20128745lje.13;
        Thu, 09 Jun 2022 13:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cBK6/mXz5yDC7klt1oq1cf3xvjwR6jBvhdS+cTpC2Kc=;
        b=CiGCRkuu73W3M46UnvqsubR3XsaquRcx+ygNWQGVmPGSXGMJnWH9oai48a4suWLLU5
         Pq36AelyxvjQHlrb455eOX5/tFaxlZrat58v1EGJgbBwcymaJBnGIP3tNIyIiOiOvvsQ
         GNfgA25u2NkDcsoc2ecPhN8Wtz6w6kI/qFqqd9DHXkXqSX/a9P8Wh5hjdrsT1/eaXmHr
         xS0q+LuGnBy+SYmuJKmcQUeduUUajQdpjb75xjQ0K+LJq1ppIpsYdQZF/OcijyghJevM
         XDViHckOlQqAIx2Y+MORfOu2USE5Y3+SZ8wUby3hjoXalZ0ToTeMsliD/xURqBr+smu+
         oSBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cBK6/mXz5yDC7klt1oq1cf3xvjwR6jBvhdS+cTpC2Kc=;
        b=1Y2qSxGEJfvkPLAZfbA5FXSJL42FqVYuPc5svJuKmi8ZuqGKm7h/PEpWHgq+xpXYX4
         tMoYuKuAE3Eb+G0+zdd7JTnkM9hV+4qsqGqru8wpEertxYT/6CjaBFZgnycrFpAbhgwZ
         zNfKpIsbau29dQx8zg8rrW3EbGpQ3QuE9WlSsgKQCO7C+psNVNYSRPY2QuYFGimFUbvN
         jc1mp91YhZi8h1keYMBfU2E6SMPdxOjVhcV37KEhfINE4nc02ySlwGxLCQ3OgwYT3et1
         yfk7DVZ2E+7Z7WHdcEr7c8AIr6u3hecD/jYQLe5NDvzip2iJ/jiE9aMBCWDAeBMyVGFp
         3jpA==
X-Gm-Message-State: AOAM533CqPdeUxpniyr1d3XujfOt7Szrh+Kszx+WbTk9DaMr2ICy73Fl
        iBEADqNF8hk+NKX0JsW2NDb+ezHKsy0NBPDIumc=
X-Google-Smtp-Source: ABdhPJxou4cMHEUqYdwxbHH6tZ0jconZwUVRjvAMuutMRmYAI1AQ2jy33QjIuBiX17OJCemD6QJo1dLyoLOgEoTD+Qo=
X-Received: by 2002:a2e:3a16:0:b0:255:7811:2827 with SMTP id
 h22-20020a2e3a16000000b0025578112827mr20036524lja.130.1654806724358; Thu, 09
 Jun 2022 13:32:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220603204509.15044-1-jolsa@kernel.org>
In-Reply-To: <20220603204509.15044-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Jun 2022 13:31:52 -0700
Message-ID: <CAEf4BzbT4Z=B2hZxTQf1MrCp6TGiMgP+_t7p8G5A+RdVyNP+8w@mail.gmail.com>
Subject: Re: [PATCHv4 bpf-next 0/2] perf tools: Fix prologue generation
To:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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

On Fri, Jun 3, 2022 at 1:45 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> hi,
> sending change we discussed some time ago [1] to get rid of
> some deprecated functions we use in perf prologue code.
>
> Despite the gloomy discussion I think the final code does
> not look that bad ;-)
>
> This patchset removes following libbpf functions from perf:
>   bpf_program__set_prep
>   bpf_program__nth_fd
>   struct bpf_prog_prep_result
>
> v4 changes:
>   - fix typo [Andrii]
>
> v3 changes:
>   - removed R0/R1 zero init in libbpf_prog_prepare_load_fn,
>     because it's not needed [Andrii]
>   - rebased/post on top of bpf-next/master which now has
>     all the needed perf/core changes
>
> v2 changes:
>   - use fallback section prog handler, so we don't need to
>     use section prefix [Andrii]
>   - realloc prog->insns array in bpf_program__set_insns [Andrii]
>   - squash patch 1 from previous version with
>     bpf_program__set_insns change [Daniel]
>   - patch 3 already merged [Arnaldo]
>   - added more comments
>
> thanks,
> jirka
>

Arnaldo, can I get an ack from you for this patch set? Thank you!

>
> [1] https://lore.kernel.org/bpf/CAEf4BzaiBO3_617kkXZdYJ8hS8YF--ZLgapNbgeeEJ-pY0H88g@mail.gmail.com/
> ---
> Jiri Olsa (2):
>       perf tools: Register fallback libbpf section handler
>       perf tools: Rework prologue generation code
>
>  tools/perf/util/bpf-loader.c | 173 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 155 insertions(+), 18 deletions(-)
