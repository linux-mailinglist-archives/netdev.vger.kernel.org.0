Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383385443A0
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 08:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237281AbiFIGPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 02:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbiFIGPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 02:15:10 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1355F11B6AA;
        Wed,  8 Jun 2022 23:15:09 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-e5e433d66dso29876521fac.5;
        Wed, 08 Jun 2022 23:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SmuCshAKgrlfjZbY8MGcPQUYLCKO1JKtOtdHvzL6L9s=;
        b=RUi0wR9N5ruqs8p04u9ewynC8LNCNe747t2xG6Xc+SLs+U4Q8bVs8WfS+B1rpsv+E0
         N1sqASDT+fdBt3lD+H3EhS7bKKpUl3EUCL4p+fnsnqXxwj/YbN/G1Sw7cpgd7LKgAc69
         2GTjlqZ821IDnPE4Dk8AJiD+l90eqjseHbGBXBsB9YaAdxukaqhxvp9AjHq1lVnNB1qL
         VKv41V3YOmildYghE7jORUEBAcPSZxw5bkyOEkq5jLlj+hvUjQI0D1CMDl7vhhHoImXu
         MfQfx8hukgQYxQQGIxX3arObQb9sPXaCOIDjIP8B+rPoyrYb6Tdi+Z+Li/a78aUuJgAX
         Exlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SmuCshAKgrlfjZbY8MGcPQUYLCKO1JKtOtdHvzL6L9s=;
        b=1KGm51bVEs6NpHSnvu8CyOtwnxMJ1/UjE92EucESEWn5aYevUmP1OlS6OMuCOkfATH
         d8tm6X8HfJrxQ2dTjCtrSqiQKL+v4eXfR0v8f/ArdkP7EECVJpMGC1SCFBLhTVrELXvB
         mE+am6L5u3TA5XMmKi5u7AnCVqfjGxoWURvhBZ8kO5sCZs4tAxG5k4Wdj9fhzWNyuQ+L
         g9gQhWEt7J3X85SDkPg9PPhh8LjKYsdCsWerzAE4c3uPzQqBKsF3keq1FDCQmnRf6qJn
         rbGT69LvHq+jXSrzf05CHSXQ9Kz3dH9TnBoFAfPegwNPamyxIPaklIh/ndDeGOxJEOqs
         w+Ew==
X-Gm-Message-State: AOAM533HWRDGMSJZuDiS8HrcFStekRkEwHHIf8/w8N/iM5h2CgXl2bh2
        tbq7EsdT6+BOqt2Ma+O0OjMw3HiTcIrfcJV93jc=
X-Google-Smtp-Source: ABdhPJwwQCMNBj+w5eZPapW8twI37LK47pxZ08Vz5gS8vlnOXDfFSJZRWG//yB72wptVLSQHZVQUaIJjQuKkFz723CA=
X-Received: by 2002:a05:6870:3105:b0:f2:9615:ff8e with SMTP id
 v5-20020a056870310500b000f29615ff8emr807155oaa.200.1654755308353; Wed, 08 Jun
 2022 23:15:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220608064004.1493239-1-james.hilliard1@gmail.com>
 <b05401b0-308e-03a2-af94-4ecc5322fd1f@iogearbox.net> <CADvTj4pUd2zH8M6BBQGVf9C3dpfhfFEN9ogwKXODj+sarzqPcg@mail.gmail.com>
 <3230febd-d346-8348-76e7-b9548f01cb87@iogearbox.net>
In-Reply-To: <3230febd-d346-8348-76e7-b9548f01cb87@iogearbox.net>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Thu, 9 Jun 2022 00:14:57 -0600
Message-ID: <CADvTj4rPKiBcfoL5q4QpL1z0Gd60K+LVuvgmi2W=TiExFT7AHg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] libbpf: replace typeof with __typeof__
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 8, 2022 at 9:22 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 6/8/22 3:04 PM, James Hilliard wrote:
> > On Wed, Jun 8, 2022 at 6:50 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >> On 6/8/22 8:40 AM, James Hilliard wrote:
> >>> It seems the gcc preprocessor breaks when typeof is used with
> >>> macros.
> >>>
> >>> Fixes errors like:
> >>> error: expected identifier or '(' before '#pragma'
> >>>     106 | SEC("cgroup/bind6")
> >>>         | ^~~
> >>>
> >>> error: expected '=', ',', ';', 'asm' or '__attribute__' before '#pragma'
> >>>     114 | char _license[] SEC("license") = "GPL";
> >>>         | ^~~
> >>>
> >>> Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> >>> ---
> >>> Changes v1 -> v2:
> >>>     - replace typeof with __typeof__ instead of changing pragma macros
> >>> ---
> >>>    tools/lib/bpf/bpf_core_read.h   | 16 ++++++++--------
> >>>    tools/lib/bpf/bpf_helpers.h     |  4 ++--
> >>>    tools/lib/bpf/bpf_tracing.h     | 24 ++++++++++++------------
> >>>    tools/lib/bpf/btf.h             |  4 ++--
> >>>    tools/lib/bpf/libbpf_internal.h |  6 +++---
> >>>    tools/lib/bpf/usdt.bpf.h        |  6 +++---
> >>>    tools/lib/bpf/xsk.h             | 12 ++++++------
> >>>    7 files changed, 36 insertions(+), 36 deletions(-)
> >>>
> >>> diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
> >>> index fd48b1ff59ca..d3a88721c9e7 100644
> >>> --- a/tools/lib/bpf/bpf_core_read.h
> >>> +++ b/tools/lib/bpf/bpf_core_read.h
> >>> @@ -111,7 +111,7 @@ enum bpf_enum_value_kind {
> >>>    })
> >>>
> >>>    #define ___bpf_field_ref1(field)    (field)
> >>> -#define ___bpf_field_ref2(type, field)       (((typeof(type) *)0)->field)
> >>> +#define ___bpf_field_ref2(type, field)       (((__typeof__(type) *)0)->field)
> >>>    #define ___bpf_field_ref(args...)                                       \
> >>>        ___bpf_apply(___bpf_field_ref, ___bpf_narg(args))(args)
> >>>
> >>
> >> Can't we just add the below?
> >>
> >> #ifndef typeof
> >> # define typeof __typeof__
> >> #endif

Ok, looks like this does appear to work, although just switching to __typeof__
may be preferable as it should work everywhere.

> >
> >  From what I can tell it's not actually missing, but rather is
> > preprocessed differently
> > as the errors seem to be macro related.
>
> Are you saying that the above suggestion wouldn't work? Do you have some more
> details? I'm mainly wondering if there's a way where we could prevent letting
> typeof() usage slip through in future given from kernel side people are used
> to it.

I think my build env was using stale headers, I think I figured out
what's going on,
the typeof issue is triggered by building with -std=c17, the macro
issue is unrelated
and limited to the SEC macro it would appear.

I suppose running builds with -std=c17 would prevent typeof() usage from
slipping through.

>
> > I did also find this change which seems related:
> > https://github.com/torvalds/linux/commit/8faf7fc597d59b142af41ddd4a2d59485f75f88a
> >
> >>
> >> Thanks,
> >> Daniel
>
