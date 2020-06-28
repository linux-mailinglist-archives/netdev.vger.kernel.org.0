Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32E320CA49
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 22:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgF1UA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 16:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgF1UA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 16:00:58 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6AC3C03E979;
        Sun, 28 Jun 2020 13:00:58 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id j10so11361881qtq.11;
        Sun, 28 Jun 2020 13:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TKxKoLfzBm9KqJHTkvg4khJDO8ga+nlpUFpUM+gKWEQ=;
        b=nB3Qqv1EoSGEC0OC2Gb+Btb4pCfsPVw+ekkS0rOWhHjnNUvJvL6nj3v0CNvrIg8jh3
         h4tOUgBj+WYbNSu66uLwz/7/v3b1daJUTLJWQdwTSATUnIIH3xMdD7wB5wWwO0+qhwoW
         Yab9mfjxxGYZ8bEKy+c7fHyGu9VU+fi6mOnwJAhvqs4/mT73OPCx8+mFJ2I0991FPiur
         zOOgnAo0/1/N5UKg7o++krVzWS58WMDZAnRclHj25IPbTndpS80kIjat6BkcQC8VxPCO
         IX18tU8tUjQgdKFQNB3vGkEctHPd+a3ESl/ZOFRR3xMKIB/7pkeAx7bewgsARCh9jufN
         db3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TKxKoLfzBm9KqJHTkvg4khJDO8ga+nlpUFpUM+gKWEQ=;
        b=KWJUXkW3H9bxq+G1zPfeVd+71kAZ+gkM8oZDCgSS9Mn4znHPcukOE0HaBOzO63iyn8
         LzC1SAGjHDeAq+pks0S3plYqcapcE9Dp978bjsBwk23oNOnSNqT2xydnjBXsUjYc9fBG
         N2U2DKg1S8O83mI57lQ+ol2NEgaJhBaAJfhaYnNM/ZCIfa0IYs2W3qcd4jUgTeSxZzYf
         FlZ21IvYhINdlEHMOby75MeU/8k7vkiGy1pOZnQZqmSeZqYT3SUcU8Vi0tW3Yk/ZzOYw
         GX3xvXg+0u8nddBPTA69qpBFAWQnN2qOGMdkigPOqM3ETMdgxalMoZw7ppv3nm+Zxhmt
         Vpkw==
X-Gm-Message-State: AOAM533BuT9ytWJXBgl/C+0udB7VetCvtWh3qvmh7NAd0WJ/XxaNKnsf
        sOb63jEzLV85p6NUYhtvqWL0K4KAW2x2jBSO7mcgrw61n7Y=
X-Google-Smtp-Source: ABdhPJyL4V3GCnrk7mOlyRFZ2HpcUqgag1JI5EF6K9Fh35Q4Tz9zTp4iwG6sOx9KV/oq0MHSCLx/0sj+Adg26q8Ti50=
X-Received: by 2002:aed:2cc5:: with SMTP id g63mr12617382qtd.59.1593374457221;
 Sun, 28 Jun 2020 13:00:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200625221304.2817194-1-jolsa@kernel.org> <20200625221304.2817194-6-jolsa@kernel.org>
 <7480f7b2-01f0-f575-7e4f-cf3bde851c3f@fb.com> <CAEf4BzYPvNbYNBuqFDY8xCqSGTZ2G8HM=waq9b=qO9UYOUK7+A@mail.gmail.com>
 <b9258020-cd38-b818-e3a9-4f6d9cdf6b88@fb.com> <20200628185046.vryhuc23f6yu5fy4@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200628185046.vryhuc23f6yu5fy4@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 28 Jun 2020 13:00:46 -0700
Message-ID: <CAEf4BzZxivU8zNfzuQQJyVs=HF7ckjuWZFa=HgpPD-VgpWyVWQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 05/14] bpf: Remove btf_id helpers resolving
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 28, 2020 at 11:50 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jun 26, 2020 at 04:29:23PM -0700, Yonghong Song wrote:
> > > > >
> > > > > -int btf_resolve_helper_id(struct bpf_verifier_log *log,
> > > > > -                       const struct bpf_func_proto *fn, int arg)
> > > > > -{
> > > > > -     int *btf_id = &fn->btf_id[arg];
> > > > > -     int ret;
> > > > > -
> > > > > -     if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID)
> > > > > +     if (!id || id > btf_vmlinux->nr_types)
> > > > >                return -EINVAL;
> > > >
> > > > id == 0 if btf_id cannot be resolved by resolve_btfids, right?
> > > > when id may be greater than btf_vmlinux->nr_types? If resolve_btfids
> > > > application did incorrect transformation?
> > > >
> > > > Anyway, this is to resolve helper meta btf_id. Even if you
> > > > return a btf_id > btf_vmlinux->nr_types, verifier will reject
> > > > since it will never be the same as the real parameter btf_id.
> > > > I would drop id > btf_vmlinux->nr_types here. This should never
> > > > happen for a correct tool. Even if it does, verifier will take
> > > > care of it.
> > > >
> > >
> > > I'd love to hear Alexei's thoughts about this change as well. Jiri
> > > removed not just BTF ID resolution, but also all the sanity checks.
> > > This now means more trust in helper definitions to not screw up
> > > anything. It's probably OK, but still something to consciously think
> > > about.
> >
> > The kernel will have to trust the result.
>
> +1
> I think 'if (!id || id > btf_vmlinux->nr_types)' at run-time and
> other sanity checks I saw in other patches are unnecessary.
> resolve_btfids should do all checks and fail vmlinux linking.
> We trust gcc to generate correct assembly code in the first place
> and correct dwarf. We trust pahole do correct BTF conversion from
> dwarf and dedup. We should trust resolve_btfids.
> It's imo the simplest tool comparing to gcc.
> btf_parse_vmlinux() is doing basic sanity check of BTF mainly
> to populate 'struct btf *btf_vmlinux;' for further use.
> I think we can add a scan over resolved btfids to btf_parse_vmlinux()
> to make sure that all ids are within the range, but I don't think
> it's mandatory for this patch set. Would be a reasonable sanity
> check for the future. Of course, checking for sorted set_start/end
> is overkill. Basic simplest sanity is ok.

My point was *not* about trusting resolve_btfids tool, it was about
trusting BPF helper definitions. But it's more of help for developer
while developing new helpers, so it's not a major thing.
