Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C82A5430F7
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 15:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239869AbiFHNEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 09:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239855AbiFHNEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 09:04:44 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D18E2AD2;
        Wed,  8 Jun 2022 06:04:41 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id k11so27902398oia.12;
        Wed, 08 Jun 2022 06:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3rHTPlzTTQfxmaqda8ACM/7KIC1Smac8uYyX7l4l+xU=;
        b=BWNq9tVJvE5SQ5A0oHaE44zB54CMBk8DzwxfMJaaCpDzhzHLWiH6GiiSjMfOvA/wRl
         ig69MFaSAmFUTwknNon35qaaX0mWBb3uFimmshr5sKkX1bh8HKgu88K29Ic8mHMvAtIs
         ex3y/dyvw94mXfSTMNIlqp8WydeJ5pRqDUbvHu7sDc5VVBTVv0Xef9vavD0sYYB+t/C5
         NlqgmnBqgMZtocpB4HjQC5ZPm9Kml6pl2Pp37Jv+2DwJTqdIDQ6ypgJT6QSlasuw3tyV
         qdF1dLg59386CNgmfjPdD6yX4q6EM7GkAhqS9u59sba0/OFkl2wDL7iJ53WksoMjVHTK
         LYIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3rHTPlzTTQfxmaqda8ACM/7KIC1Smac8uYyX7l4l+xU=;
        b=oCB9G/tDIpTlIr5uDLd6chamHrT1JWNEGWNS3v5PNNAP1RRciPM0Y8U/GuWQ5gk1Mt
         Wnbu5okCPVYjLyrFBDaDbqwJnCLipXm6yTasyXYU7uLD1CsfYQmNINU+IkvMorzAVEVt
         23x35aniMcawTI57yOS5ndXlmRP6yuMGWR3GjySnAr3NLW47Gg6N/2l6FL8DObjKwFJH
         6RBMrnC/Sw2wXw3/8WD4C1+YtevSTj/OPjP7K8ULU/j4JJYD7WwGhtu0JWpL8+ub5Map
         mAXhCzPAundH4qPWiosVVk+azjxPsuJ6wY9cDWYzKo8qAnekpsYFApUTiFbykVke51vN
         /KiQ==
X-Gm-Message-State: AOAM532KU130DEsk/lsgVix+o5NT2+ooqFO353we8AgWGjCNPZ5qKDJy
        y0sbQK25hwm7H+gjPcu2qtXaZGpxXRJuql7C/MpZVDhiwtGCfg==
X-Google-Smtp-Source: ABdhPJyLOoO6552cDMezPdeJATWFKxqoHEZTjuCOXvmlkynwLYR52FC5uoZeZwoBzvm3PedGhFSfwsVsKhUYstaCgSI=
X-Received: by 2002:a05:6808:114f:b0:32b:1be0:2316 with SMTP id
 u15-20020a056808114f00b0032b1be02316mr2176100oiu.200.1654693479502; Wed, 08
 Jun 2022 06:04:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220608064004.1493239-1-james.hilliard1@gmail.com> <b05401b0-308e-03a2-af94-4ecc5322fd1f@iogearbox.net>
In-Reply-To: <b05401b0-308e-03a2-af94-4ecc5322fd1f@iogearbox.net>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Wed, 8 Jun 2022 07:04:28 -0600
Message-ID: <CADvTj4pUd2zH8M6BBQGVf9C3dpfhfFEN9ogwKXODj+sarzqPcg@mail.gmail.com>
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

On Wed, Jun 8, 2022 at 6:50 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Hi James,
>
> On 6/8/22 8:40 AM, James Hilliard wrote:
> > It seems the gcc preprocessor breaks when typeof is used with
> > macros.
> >
> > Fixes errors like:
> > error: expected identifier or '(' before '#pragma'
> >    106 | SEC("cgroup/bind6")
> >        | ^~~
> >
> > error: expected '=', ',', ';', 'asm' or '__attribute__' before '#pragma'
> >    114 | char _license[] SEC("license") = "GPL";
> >        | ^~~
> >
> > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> > ---
> > Changes v1 -> v2:
> >    - replace typeof with __typeof__ instead of changing pragma macros
> > ---
> >   tools/lib/bpf/bpf_core_read.h   | 16 ++++++++--------
> >   tools/lib/bpf/bpf_helpers.h     |  4 ++--
> >   tools/lib/bpf/bpf_tracing.h     | 24 ++++++++++++------------
> >   tools/lib/bpf/btf.h             |  4 ++--
> >   tools/lib/bpf/libbpf_internal.h |  6 +++---
> >   tools/lib/bpf/usdt.bpf.h        |  6 +++---
> >   tools/lib/bpf/xsk.h             | 12 ++++++------
> >   7 files changed, 36 insertions(+), 36 deletions(-)
> >
> > diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
> > index fd48b1ff59ca..d3a88721c9e7 100644
> > --- a/tools/lib/bpf/bpf_core_read.h
> > +++ b/tools/lib/bpf/bpf_core_read.h
> > @@ -111,7 +111,7 @@ enum bpf_enum_value_kind {
> >   })
> >
> >   #define ___bpf_field_ref1(field)    (field)
> > -#define ___bpf_field_ref2(type, field)       (((typeof(type) *)0)->field)
> > +#define ___bpf_field_ref2(type, field)       (((__typeof__(type) *)0)->field)
> >   #define ___bpf_field_ref(args...)                                       \
> >       ___bpf_apply(___bpf_field_ref, ___bpf_narg(args))(args)
> >
>
> Can't we just add the below?
>
> #ifndef typeof
> # define typeof __typeof__
> #endif

From what I can tell it's not actually missing, but rather is
preprocessed differently
as the errors seem to be macro related.

I did also find this change which seems related:
https://github.com/torvalds/linux/commit/8faf7fc597d59b142af41ddd4a2d59485f75f88a

>
> Thanks,
> Daniel
