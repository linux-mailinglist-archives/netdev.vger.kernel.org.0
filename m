Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD59CDA9A
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 05:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfJGDSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 23:18:44 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35743 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbfJGDSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 23:18:44 -0400
Received: by mail-qk1-f196.google.com with SMTP id w2so11316712qkf.2;
        Sun, 06 Oct 2019 20:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hvH1YSakClr+2Sbw2X50DoDwa2weMTl5+3fyP6fp5l4=;
        b=r+7X9vGWSmIsRAoAgGvrfC2lDwtXhqvUvJzV+P9Un86XjnqF9b5uezdgaE41TEVrDM
         M3sa597q55E/6zHHjsxrt77CJ2gEnhl3e8whtTJguSwPBQRXwm/AvmF269wNDBcYsgO7
         iQjH5/RQHYDahcVjXfhplqcI+Qm7a7OsL6yZj8yVe87yMtBee5CoGv67Df1sXfpotuQx
         +FOa7B+W8YJTJiMv+SzCw5M2Y2dCMr9Vka2+NN3CMYOuHsyUGIDb5BUW87YQuiepc2xk
         H5eu7S71vcJwhfzpwTNvn3iLMzy/IK3vblUXTMcEkNcqeDcxQzuTBUMxarwYVbt3PApB
         75wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hvH1YSakClr+2Sbw2X50DoDwa2weMTl5+3fyP6fp5l4=;
        b=PQkViO2IyepNuFY+zxckE+ix6xkWZ1inisKiBH8V8GgDfY0qy3BJTtWwDi/tYgIpd5
         JM+CS3jvww1lEVobUL26NJEg8hlaxIG+rWuyCqvj1worf1zb/k+ODMd0w9oiom3mk1ie
         /ZBtRVZ5rXV1qK1WoGvM6KESXNpXlfsOit/iPNiUJvOzEXJVr7fn9KTUzclCwJOKeD09
         sfgXnVi/VZ7WLBLYfqaO1+fqOd8Qei1zsU5tsqjj2COQB/dQ8bB4rNvmK1Dd1mmgHK93
         bawx1vYgMVL0VbjBmELhsi00wNSmwNOfsAuCca8Z7qeIE1vPKa9BBbyfTWMIGeGsEWDS
         e3Dw==
X-Gm-Message-State: APjAAAWt6pbSKaMYe0EmytQoXkuhYVgYiR/AOgBPMev71zlxzQHxkmvh
        DYJ1Fq9cPQH8uxzKSq7x1J8yrKj5WEKbx0kom2eU0PPa+mk=
X-Google-Smtp-Source: APXvYqymVOYQh0Cxjw11LjlKrZSqyUhhgdSnIvFnM9ZocbUA5ag6YldMZDvBSV0SGRuAnSlw2k7Ap9peS1d2IxBtQM8=
X-Received: by 2002:ae9:eb93:: with SMTP id b141mr22031518qkg.36.1570418323257;
 Sun, 06 Oct 2019 20:18:43 -0700 (PDT)
MIME-Version: 1.0
References: <20191006054350.3014517-1-andriin@fb.com> <20191006054350.3014517-4-andriin@fb.com>
 <CAADnVQ+CmZ+=GTrW=GOOnaJBB-th60SEnPacX4w7+gt8bKKueQ@mail.gmail.com>
 <CAEf4BzZ5KUX5obfqxd7RkguaQ0g1JYbKs=RkrHKdDFDGbaSJ_w@mail.gmail.com>
 <CAADnVQJDFhqqxzFXoWxJk5KAnnfxwyZw-QGT+e-9mOUsGEi8_g@mail.gmail.com> <CAEf4BzbGOyCa3OXFMQHmtwrC2uB3K0QFs3GBDeVt8PDDOAnSVQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbGOyCa3OXFMQHmtwrC2uB3K0QFs3GBDeVt8PDDOAnSVQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 6 Oct 2019 20:18:32 -0700
Message-ID: <CAEf4Bzaz=wG1=3gs4-nQ7xe1eE8TENQP3Kj0ZqhzkiUQ02Phbg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 3/3] libbpf: auto-generate list of BPF helper definitions
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 6, 2019 at 7:24 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, Oct 6, 2019 at 5:32 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Sun, Oct 6, 2019 at 5:13 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Sun, Oct 6, 2019 at 4:56 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Sat, Oct 5, 2019 at 10:46 PM Andrii Nakryiko <andriin@fb.com> wrote:
> > > > >
> > > > > Get rid of list of BPF helpers in bpf_helpers.h (irony...) and
> > > > > auto-generate it into bpf_helpers_defs.h, which is now included from
> > > > > bpf_helpers.h.
> > > > >
> > > > > Suggested-by: Alexei Starovoitov <ast@fb.com>
> > > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > > ---
> > > > >  tools/lib/bpf/.gitignore    |   1 +
> > > > >  tools/lib/bpf/Makefile      |  10 +-
> > > > >  tools/lib/bpf/bpf_helpers.h | 264 +-----------------------------------
> > > > >  3 files changed, 10 insertions(+), 265 deletions(-)
> > > >
> > > > This patch doesn't apply to bpf-next.
> > >
> > > Yes, it has to be applied on top of bpf_helpers.h move patch set. I
> > > can bundle them together and re-submit as one patch set, but I don't
> > > think there were any remaining issues besides the one solved in this
> > > patch set (independence from any specific bpf.h UAPI), so that one can
> > > be applied as is.
> >
> > It looks to me that auto-gen of bpf helpers set is ready,
> > whereas move is till being debated.
> > I also would like to test autogen-ed .h in my environment first
> > before we move things around.
>
> Alright, will post v4 based on master with bpf_helpers.h still in selftests/bpf

Posted v4 w/ completely different Makefile change. For libbpf it's
going to be the one from v3 of this patch set.

But I'm not sure what debate you mean for bpf_helpers.h move. The only
contentious issue was bpf_helpers.h depending on BPF_FUNC_xxx enum
values, which is solved/bypassed by this auto-generation approach. So
if we are landing auto-generation of helpers, there is nothing for me
to address for bpf_helpers.h move.

Keep in mind, that depending on order of applying this and bpf_helpers
move patchsets, it will be either:

1. Apply bpf_helpers.h move patchset
2. Apply v3 of this patch set

Or:

1. Apply v4 of this patch set
2. I'll have to rebase bpf_helpers.h move patchset after that (it
probably won't apply cleanly)
3. Follow-up patches to undo selftests/bpf Makefile change and re-do
libbpf's Makefile change.

The latter one is the same end result with more work for me (part of
which I already did for v4, some part still needs to be done).
