Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 723E9144993
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 02:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgAVBv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 20:51:26 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37907 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgAVBv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 20:51:26 -0500
Received: by mail-lf1-f67.google.com with SMTP id r14so4014684lfm.5;
        Tue, 21 Jan 2020 17:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/BP69swCf4ZcXbweeoEkWBHDIjYB/DYjB50o9szDOlY=;
        b=Zxw61BS3N3Hs5XO3DzSsCRamgvynFsCSxQzyVo4+GfSxEAi/75kgE1PlfuGVg+QQlF
         bJN2XAMe17YG72Zor/Ok4QGJVSd2O1hxt5qczj2HguBAgyZktpCRZz5JcgfYQgk9zMJa
         iS1gEGE6aTLnJOiKkvqGh8yG/1VYSRfanFgHlo5P9rO58tO/fuZOqPLEZnA9ShZ74dij
         hIJqHxJvdfqWORbAIguvTybw1JKc/PzgE9UZ108rLsvvHjGzA9N3Mu1z3vXd12ZjCww0
         QfnCFpIUwNrBqnynJx+XCn59rz5JPbcJQLbNerujXoU8hdVP1dXBbclFFVYv1ZBSGnYZ
         kSYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/BP69swCf4ZcXbweeoEkWBHDIjYB/DYjB50o9szDOlY=;
        b=Pzc1kBlAoK98hVJnmIGTWDB+dHqBkAVIZUipk0sR8XVJa5K6Cez2sqK8utGv/PN5p8
         VJLR76eKRmQOWl7WGh7V9ym7lhonVdixgTtLu7k+SaR9hjhDrofucLyy7+A+SQ1fP80T
         awlljZMIkUVCVxIVFjM5DtB2v5yzAobRMLW1jQ1cENpK/8uD8/LM9eS7BpK2pkxUSSvD
         EAgizp6XmW7TC5JQ0I7ODtoOnwlHhlB/uFDWjJanwPP0AiD4MKBIpPoSRwgnqTtQZROW
         66V17EV2ZNMLamkYPycK1x/KODlFklelfoDx2kvCDOLfnXX/k9v8hdL56K9tldVVNpmY
         LTsA==
X-Gm-Message-State: APjAAAWcFMQ8U+pw1WmmU4rBaV4NV0iG3fBpaKbEPWttWpI1FzceCBg5
        ylobHUZ5Q3xceByWTHY901QqLLRFPATgI3or/HA=
X-Google-Smtp-Source: APXvYqy0OrY53oBBlYCpmVArkJ8UEQkNkpufCkz4we+ZvAKPkiNuTTmL1d2U6g/bY8rSR8ooB8vgSpi0p5DZzJOgJpU=
X-Received: by 2002:ac2:592e:: with SMTP id v14mr342330lfi.73.1579657883818;
 Tue, 21 Jan 2020 17:51:23 -0800 (PST)
MIME-Version: 1.0
References: <20200121120512.758929-1-jolsa@kernel.org> <20200121120512.758929-2-jolsa@kernel.org>
In-Reply-To: <20200121120512.758929-2-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 21 Jan 2020 17:51:12 -0800
Message-ID: <CAADnVQKeR1VFEaRGY7Zy=P7KF8=TKshEy2inhFfi9qis9osS3A@mail.gmail.com>
Subject: Re: [PATCH 1/6] bpf: Allow ctx access for pointers to scalar
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 4:05 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> When accessing the context we allow access to arguments with
> scalar type and pointer to struct. But we omit pointer to scalar
> type, which is the case for many functions and same case as
> when accessing scalar.
>
> Adding the check if the pointer is to scalar type and allow it.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/bpf/btf.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 832b5d7fd892..207ae554e0ce 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3668,7 +3668,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>                     const struct bpf_prog *prog,
>                     struct bpf_insn_access_aux *info)
>  {
> -       const struct btf_type *t = prog->aux->attach_func_proto;
> +       const struct btf_type *tp, *t = prog->aux->attach_func_proto;
>         struct bpf_prog *tgt_prog = prog->aux->linked_prog;
>         struct btf *btf = bpf_prog_get_target_btf(prog);
>         const char *tname = prog->aux->attach_func_name;
> @@ -3730,6 +3730,17 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>                  */
>                 return true;
>
> +       tp = btf_type_by_id(btf, t->type);
> +       /* skip modifiers */
> +       while (btf_type_is_modifier(tp))
> +               tp = btf_type_by_id(btf, tp->type);
> +
> +       if (btf_type_is_int(tp) || btf_type_is_enum(tp))
> +               /* This is a pointer scalar.
> +                * It is the same as scalar from the verifier safety pov.
> +                */
> +               return true;

The reason I didn't do it earlier is I was thinking to represent it
as PTR_TO_BTF_ID as well, so that corresponding u8..u64
access into this memory would still be possible.
I'm trying to analyze the situation that returning a scalar now
and converting to PTR_TO_BTF_ID in the future will keep progs
passing the verifier. Is it really the case?
Could you give a specific example that needs this support?
It will help me understand this backward compatibility concern.
What prog is doing with that 'u32 *' that is seen as scalar ?
It cannot dereference it. Use it as what?
