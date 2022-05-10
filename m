Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D3A5227CD
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 01:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236670AbiEJXtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 19:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbiEJXtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 19:49:09 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC5D7982A;
        Tue, 10 May 2022 16:49:06 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id m6so449651iob.4;
        Tue, 10 May 2022 16:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9pcB5jys6dNcZue2nxpSEaqmzI5+cJi/9C2vrddSdtA=;
        b=YN05Rdb6bf94IudrameYyHKfVdI7l3D3mdbXpF+GDB8xcSKSQK2Wtd2sSPKKcEgeRj
         1P1rc/oKs3SMYYjf5hC0+9dgtgcyXJ9JRcKGMxRxyG4enp3UgZ5gTrPoFMg1aM7Qk8ES
         HgCTdaI11+cHSY1EEoOXv/bFtRhP8CDwTVkhYtwp8UBpT8+lGrCGxrNq+Eh2CVtHloPn
         aH4gkw8LftVB+y1ZwZS6kxvH9X/V7dxc4YK9V4jBX0y80GhxvTiNHHck4e/Lhh42z2KP
         HQU0gD22zJAw9489JdCHdHwhkyV28LMIH1s+oZLMvtkozJZzD+fuXeliR2yBMTh/ohpH
         Zzmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9pcB5jys6dNcZue2nxpSEaqmzI5+cJi/9C2vrddSdtA=;
        b=ajyZWOstt0Eyv0wksO+j3gYaHrQXnRu15BC3Wq7/sQEOiI49n4phcBBmZDnNLMG2ba
         UyhXQoeLCSmVOzadw/b+TNw51BFzRXryt1FQwhFHdMB+Yrb2B8ascSecvYv4C5KX6XzE
         qFGOlSti55VF0q2YMMZzLW0sigHB/fBsDh8huExv4x5O6wIVymRqMd9hgcYYDQRgIL8C
         JdmrIMp3iZPl0UgpwoWCVjJdcXPoLzZAHMYkAKieW5yBedsh0Nc60V49ZB648vZfZ+dE
         uq7GlfoXCpR9NRQOG5NIMMMBTPtVCDi8H9Dj5VamDhaRoEu7j36Be3McrZIjGGsaJbWA
         n4iw==
X-Gm-Message-State: AOAM530CL2a31vqhtreRnRCRNG576StGXH9NlWEYwAEvNKcu/31pGpMQ
        86CYoQIJiAULaSiixLPsa2JOVELhJm/vB9YcWQA=
X-Google-Smtp-Source: ABdhPJwnOiHQnfoYzQ4Ulsm9ONZgM9YlTtOsQb2tM1auygLlB1Fk20jk2kfhBgZ+9xdYTn1XvyjX3CM3Gehh9KksPDc=
X-Received: by 2002:a05:6602:1683:b0:64f:ba36:d3cf with SMTP id
 s3-20020a056602168300b0064fba36d3cfmr9640442iow.144.1652226546288; Tue, 10
 May 2022 16:49:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220510074659.2557731-1-jolsa@kernel.org>
In-Reply-To: <20220510074659.2557731-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 May 2022 16:48:55 -0700
Message-ID: <CAEf4BzbK9zgetgE1yKkCANTZqizUrXgamJa2X0f0XmzQUdFrCQ@mail.gmail.com>
Subject: Re: [PATCHv2 0/3] perf tools: Fix prologue generation
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 12:47 AM Jiri Olsa <jolsa@kernel.org> wrote:
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
> v2 changes:
>   - use fallback section prog handler, so we don't need to
>     use section prefix [Andrii]
>   - realloc prog->insns array in bpf_program__set_insns [Andrii]
>   - squash patch 1 from previous version with
>     bpf_program__set_insns change [Daniel]
>   - patch 3 already merged [Arnaldo]
>   - added more comments
>
>   meanwhile.. perf/core and bpf-next diverged, so:
>     - libbpf bpf_program__set_insns change is based on bpf-next/master
>     - perf changes do not apply on bpf-next/master so they are based on
>       perf/core ... however they can be merged only after we release
>       libbpf 0.8.0 with bpf_program__set_insns change, so we don't break
>       the dynamic linking
>       I'm sending perf changes now just for review, I'll resend them
>       once libbpf 0.8.0 is released
>
> thanks,
> jirka
>
>
> [1] https://lore.kernel.org/bpf/CAEf4BzaiBO3_617kkXZdYJ8hS8YF--ZLgapNbgeeEJ-pY0H88g@mail.gmail.com/
> ---
> Jiri Olsa (1):
>       libbpf: Add bpf_program__set_insns function
>

The first patch looks good to me. The rest I can't really review and
test properly, so I'll leave it up to Arnaldo.

Arnaldo, how do we coordinate these patches? Should they go through
bpf-next (after you Ack them) or you want them in your tree?

I'd like to get the bpf_program__set_insns() patch into bpf-next so
that I can do libbpf v0.8 release, having it in a separate tree is
extremely inconvenient. Please let me know how you think we should
proceed?

>  tools/lib/bpf/libbpf.c   | 22 ++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h   | 18 ++++++++++++++++++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 41 insertions(+)
>
> Jiri Olsa (2):
>       perf tools: Register fallback libbpf section handler
>       perf tools: Rework prologue generation code
>
>  tools/perf/util/bpf-loader.c | 175 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 157 insertions(+), 18 deletions(-)
