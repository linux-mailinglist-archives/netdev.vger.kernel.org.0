Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7E1364FC5
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 03:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbhDTBSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 21:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhDTBSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 21:18:01 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD9AC06174A;
        Mon, 19 Apr 2021 18:17:31 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id d27so2091620lfv.9;
        Mon, 19 Apr 2021 18:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dYqKMayRh0vGGelD+u2Gkr2Nob5BdKTNQL/D5RzCRmg=;
        b=HEhdbKDMsPd9dYNah6AJn/O4q7F4L1mpGp8KEeXGMhndI2XBHLdFDp8HnNWgvwYnPU
         DkUVWntHWSXzJBF2gxtcvHbhgVPDkgfC/8SSIO6oYiVwyDE0/cBwUN/Lj3lOJVn2ih7y
         Yp0rNXdVU2Vne7HhddjXPseXf9Br8/AStRuNlJ0beipzj6E25JTWI8TiDqdD+5Wy1aOR
         s8JaGeBnri+TD4clYzQk3D9//2r3EnmGPDGZ9/XO4gQ4wOR1qrtGS6tr8L4WkQ73gisI
         3K3jzjuUSPeQD1f1JgebzrUEAeADjYWCYGbcZYSD4v84W71YHur4oXlAYD15B+Z6XqV7
         S8Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dYqKMayRh0vGGelD+u2Gkr2Nob5BdKTNQL/D5RzCRmg=;
        b=ED4Qlk2k2LsOaVAZc/pQLccL8DtL1K/dUe/uIWifJpdSgg10+02ZfRF8HvAH3cRV06
         F00CMrXdJsUmpRp7/n1xlRoG7qlpVBNZImxaMi8guEeddbK31GiOS7pKEW4zsAWXAMoA
         +2UZFjGvPF21XwRYz5lyNPzDY/Ag0DTD5qaDrnFkTz3ILlhqZ9QHCXqe13wRnOwzJiy9
         VlsQgs2MqoQZMa3hCps1XTcLud1dL/LAXqDV7iozdHyvoT/LqcjSP+WVPs4lVDsUR07I
         AjMWf2QKE/+wfHE1KQfnM5n4yJfndewjP0kNQ9K8fVwYCG0H1AINTpLDzjn/hdHGCdwc
         VCLw==
X-Gm-Message-State: AOAM530ehkwdPGP8dKNLbTwh9Wc2P+k7T0PYZCcXDIqFTDn8kc0G3tlt
        OxsslC9x/RFz/trSYl4NoDSUJsBSKfurrEVhZOsddiYwmNE=
X-Google-Smtp-Source: ABdhPJyT+tc8WSqWG895WcD0gDs7uunDS5xLuv0AkwYvIjT2MuEXzLbWquIX9NI2GmS//iYFYsAmpNmQFfGJkhDahMg=
X-Received: by 2002:a05:6512:2026:: with SMTP id s6mr14423863lfs.214.1618881449777;
 Mon, 19 Apr 2021 18:17:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210415174619.51229-1-pctammela@mojatatu.com> <20210415174619.51229-3-pctammela@mojatatu.com>
In-Reply-To: <20210415174619.51229-3-pctammela@mojatatu.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 19 Apr 2021 18:17:18 -0700
Message-ID: <CAADnVQ+XtLj2vUmfazYu8-k3+bd0bJFJUTZWGRBALV1xy-vqFg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] bpf: selftests: remove percpu macros from bpf_util.h
To:     Pedro Tammela <pctammela@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>,
        David Verbeiren <david.verbeiren@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 10:47 AM Pedro Tammela <pctammela@gmail.com> wrote:
>
> Andrii suggested to remove this abstraction layer and have the percpu
> handling more explicit[1].
>
> This patch also updates the tests that relied on the macros.
>
> [1] https://lore.kernel.org/bpf/CAEf4BzYmj_ZPDq8Zi4dbntboJKRPU2TVopysBNrdd9foHTfLZw@mail.gmail.com/
>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---
>  tools/testing/selftests/bpf/bpf_util.h        |  7 --
>  .../bpf/map_tests/htab_map_batch_ops.c        | 87 +++++++++----------
>  .../selftests/bpf/prog_tests/map_init.c       |  9 +-
>  tools/testing/selftests/bpf/test_maps.c       | 84 +++++++++++-------
>  4 files changed, 96 insertions(+), 91 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/bpf_util.h b/tools/testing/selftests/bpf/bpf_util.h
> index a3352a64c067..105db3120ab4 100644
> --- a/tools/testing/selftests/bpf/bpf_util.h
> +++ b/tools/testing/selftests/bpf/bpf_util.h
> @@ -20,13 +20,6 @@ static inline unsigned int bpf_num_possible_cpus(void)
>         return possible_cpus;
>  }
>
> -#define __bpf_percpu_val_align __attribute__((__aligned__(8)))
> -
> -#define BPF_DECLARE_PERCPU(type, name)                         \
> -       struct { type v; /* padding */ } __bpf_percpu_val_align \
> -               name[bpf_num_possible_cpus()]
> -#define bpf_percpu(name, cpu) name[(cpu)].v
> -

Hmm. I wonder what Daniel has to say about it, since he
introduced it in commit f3515b5d0b71 ("bpf: provide a generic macro
for percpu values for selftests")
to address a class of bugs.
