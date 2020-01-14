Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B96FE13B2F2
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 20:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbgANTYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 14:24:33 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43936 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgANTYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 14:24:32 -0500
Received: by mail-qk1-f193.google.com with SMTP id t129so13236376qke.10
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 11:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SvPYpJ3+ZQRE3RpgnFrfhCFn0sFFgxXkJCxLs6MF/eU=;
        b=IYJqCcsmY3UmyL4J7VlHj6X+04mwAifaJQcJmyH55kxjQnz3O0kpjx8n3NJEJmBsTF
         A6z+04dTxFro/fimq/5FHbbV84ey+mcNMCB8tz5qWQh1qJyrf2xLzq9GP7b2sFYDk/JH
         5WJuvUhKNCJWersYWsu23xIXLTyj4ZyRXMOk87R91DDIR/ji9sOCXBdqrQmVLaI8+39M
         t8zZCGrUS8BRPouK5+RaZ2pJfpYG2NQODy7vGPeq2+144RmVjTr1zBiAGvLzCbEF8Spl
         k+lNSL1rFhITVxZxNXOpZYX+mAfMp+pEalwX1tf8/BDvOqgUdiBfuDWADyxvAIJdsA7M
         24PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SvPYpJ3+ZQRE3RpgnFrfhCFn0sFFgxXkJCxLs6MF/eU=;
        b=NDAqnLzVYxJRcwYK6xcwhPvGnNbYvmK7cYkQ7m8voiCV471Y0H//ciETyq9g9n8+JO
         GTk/mTLnuC6KVMkqewGLjUBKR/BIutPhaF3mECR71ftAmQM3wOdb0XCfQ5IAZ7uprbe5
         qPkJUEv4X5BO+WpG/eZR0Qv+8BaB9vCT7ltFJMGuU4C4iG0cnam2kiPrmlvOneJeir45
         1LHZAeX6NpY5Xb4qoUwTFV9L4Os1G6fUhU1plcsXCT4hNDWAIvmAMKSxDJVUE1PtaZiU
         b7P9TwVtfEP27iWsQbeROur1rirG9ZyIuHxXynsN2wr3bO86HNpfdg7NW/y5mZbXa9hG
         9R8g==
X-Gm-Message-State: APjAAAUqG7F0bXqOmPcGMVVJP9rn2F7+2ZRBD3vbN0lrjOdHr6Tzcxli
        sPAfPwDZ2BSkWbIRC0pTNnjvXW3P1PNfAtYuCxmFbQ==
X-Google-Smtp-Source: APXvYqxoDWcLzvT0ADhs2MR76vNNs6QJsCex2oYZpKenCQQZGtkUzGotvNyOaTJOW9MjbW+61wHJoDBOo787DUOhabc=
X-Received: by 2002:a05:620a:1010:: with SMTP id z16mr19021899qkj.237.1579029871343;
 Tue, 14 Jan 2020 11:24:31 -0800 (PST)
MIME-Version: 1.0
References: <20200114164614.47029-1-brianvv@google.com> <20200114164614.47029-9-brianvv@google.com>
 <CAEf4BzYEGv-q7p0rK-d94Ng0fyQLuTEvsy1ZSzTdk0xZcyibQA@mail.gmail.com>
 <CAMzD94ScYuQfvx2FLY7RAzgZ8xO-E31L79dGEJH-tNDKJzrmOg@mail.gmail.com> <CAEf4BzZHFaCGNg21VuWywB0Qsa_AkqDPnM4k_pcU_ssmFjd0Yg@mail.gmail.com>
In-Reply-To: <CAEf4BzZHFaCGNg21VuWywB0Qsa_AkqDPnM4k_pcU_ssmFjd0Yg@mail.gmail.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Tue, 14 Jan 2020 11:24:20 -0800
Message-ID: <CAMzD94Tf0B9nm7GJOQJ9XCz+yEDWDA4JrP0wwNFyLx42jif7Dw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 7/9] libbpf: add libbpf support to batch ops
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Yonghong Song <yhs@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 11:13 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Jan 14, 2020 at 10:54 AM Brian Vazquez <brianvv@google.com> wrote:
> >
> > On Tue, Jan 14, 2020 at 10:36 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Tue, Jan 14, 2020 at 8:46 AM Brian Vazquez <brianvv@google.com> wrote:
> > > >
> > > > From: Yonghong Song <yhs@fb.com>
> > > >
> > > > Added four libbpf API functions to support map batch operations:
> > > >   . int bpf_map_delete_batch( ... )
> > > >   . int bpf_map_lookup_batch( ... )
> > > >   . int bpf_map_lookup_and_delete_batch( ... )
> > > >   . int bpf_map_update_batch( ... )
> > > >
> > > > Signed-off-by: Yonghong Song <yhs@fb.com>
> > > > ---
> > > >  tools/lib/bpf/bpf.c      | 60 ++++++++++++++++++++++++++++++++++++++++
> > > >  tools/lib/bpf/bpf.h      | 22 +++++++++++++++
> > > >  tools/lib/bpf/libbpf.map |  4 +++
> > > >  3 files changed, 86 insertions(+)
> > > >
> > > > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> > > > index 500afe478e94a..12ce8d275f7dc 100644
> > > > --- a/tools/lib/bpf/bpf.c
> > > > +++ b/tools/lib/bpf/bpf.c
> > > > @@ -452,6 +452,66 @@ int bpf_map_freeze(int fd)
> > > >         return sys_bpf(BPF_MAP_FREEZE, &attr, sizeof(attr));
> > > >  }
> > > >
> > > > +static int bpf_map_batch_common(int cmd, int fd, void  *in_batch,
> > > > +                               void *out_batch, void *keys, void *values,
> > > > +                               __u32 *count,
> > > > +                               const struct bpf_map_batch_opts *opts)
> > > > +{
> > > > +       union bpf_attr attr = {};
> > > > +       int ret;
> > > > +
> > > > +       if (!OPTS_VALID(opts, bpf_map_batch_opts))
> > > > +               return -EINVAL;
> > > > +
> > > > +       memset(&attr, 0, sizeof(attr));
> > > > +       attr.batch.map_fd = fd;
> > > > +       attr.batch.in_batch = ptr_to_u64(in_batch);
> > > > +       attr.batch.out_batch = ptr_to_u64(out_batch);
> > > > +       attr.batch.keys = ptr_to_u64(keys);
> > > > +       attr.batch.values = ptr_to_u64(values);
> > > > +       if (count)
> > > > +               attr.batch.count = *count;
> > > > +       attr.batch.elem_flags  = OPTS_GET(opts, elem_flags, 0);
> > > > +       attr.batch.flags = OPTS_GET(opts, flags, 0);
> > > > +
> > > > +       ret = sys_bpf(cmd, &attr, sizeof(attr));
> > > > +       if (count)
> > > > +               *count = attr.batch.count;
> > >
> > > what if syscall failed, do you still want to assign *count then?
> >
> > Hi Andrii, thanks for taking a look.
> >
> > attr.batch.count should report the number of entries correctly
> > processed before finding and error, an example could be when you
> > provided a buffer for 3 entries and the map only has 1, ret is going
> > to be -ENOENT meaning that you traversed the map and you still want to
> > assign *count.
>
> ah, ok, tricky semantics :) if syscall failed before kernel got to
> updating count, I'm guessing it is guaranteed to preserve old value?
>
I think for correctness as a first step inside the syscall we should
update count to 0 and copy back to user, so we never preserve the old
value and we can trust what count is reporting. WDYT?
> >
> > That being said, the condition 'if (count)' is wrong and I think it
> > should be removed.
>
> So count is mandatory, right? In that case both `if (count)` checks are wrong.
Yes, you are right. I'll remove them in next version.
>
> >
> > >
> > > > +
> > > > +       return ret;
> > > > +}
> > > > +
> > >
> > > [...]
