Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B6D13B263
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 19:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgANSyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 13:54:01 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38140 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgANSyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 13:54:01 -0500
Received: by mail-qk1-f194.google.com with SMTP id k6so13157317qki.5
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 10:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FR9lhCYEbw12H0zeobUybUOQGm2CoSvzvFRxTVTYgPU=;
        b=sWhN4A1jJF4zgCnuuE5MvnlwpdRSGb5ico9T3aDZ5KVbTDha/ZNXBr4OzGPVv1W4u4
         tPz+4LZCRuC6dGCMw/qdT5wxChox1sGnbGmwwTuiFG3KCWEf+YaHUwD/1PI5a3HlFCeK
         dvl/mvQmsKoIpfv803qf8biN8MP72s0uuFWGQzKc1cIo/52Mi1EhgtZjOSY0IqwtVETi
         Z0HU5wvFqcUxXEaOHTQoqOU9fZis1x2p3ayPvgs4iN8elUrp9k7n8eCn4BpmRnA/z7wb
         0vXLk0ZbZwDBTr4NrkKE83d4lE1ythYkAgjmMIw17D/rAwUOk26JkBQL+c0+czvy79Xw
         1FNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FR9lhCYEbw12H0zeobUybUOQGm2CoSvzvFRxTVTYgPU=;
        b=iyxgRfToetph8Pj1zz+rMRUudsQvFonT00aRTeVF214cTh4D8Gd2cO+TXlkSo/6QFZ
         nmA7o8IebfaaDj8NimH2UG8Np/NRJMx1GjVv7h3BdNuGjay+pmyEMTgkTMLCq2aWP/u4
         NHa4pKMyYivxX5PSA/efEHTYxuUtiRyLVWuRVgYXaHEbeu6A2dHeMjIHojGdZhVjV6fv
         Zt+2a6Kz3tl/gq9E3GvTrtbDt+FfbWlrHHFlO0ciFrmURWkGtIT8L/JFdaFmEgzp0Per
         ZmWCFZWT3i394t37SiFLb/Wzti6KR/VfnV4g8DxHt/yiRo33xlVPmkzGNmHA0BnuX1zc
         qDAQ==
X-Gm-Message-State: APjAAAWghSmoaInbrmnRqDxwHcKS8tvy9SR720qIByEGKd1NoQk4QMyc
        7azvQitnv0cdjwOvdESku5mXbxyx3SWVJDJSbPSBkg==
X-Google-Smtp-Source: APXvYqx/CCE+s/Di7ck1wYwWrImCMzsEIMAjT6dwMMAl1rCV2+iOYzwsERCylc5qObPwRLK5zC8zX+ClZqlVCoWu7os=
X-Received: by 2002:a05:620a:997:: with SMTP id x23mr18899493qkx.143.1579028040132;
 Tue, 14 Jan 2020 10:54:00 -0800 (PST)
MIME-Version: 1.0
References: <20200114164614.47029-1-brianvv@google.com> <20200114164614.47029-9-brianvv@google.com>
 <CAEf4BzYEGv-q7p0rK-d94Ng0fyQLuTEvsy1ZSzTdk0xZcyibQA@mail.gmail.com>
In-Reply-To: <CAEf4BzYEGv-q7p0rK-d94Ng0fyQLuTEvsy1ZSzTdk0xZcyibQA@mail.gmail.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Tue, 14 Jan 2020 10:53:48 -0800
Message-ID: <CAMzD94ScYuQfvx2FLY7RAzgZ8xO-E31L79dGEJH-tNDKJzrmOg@mail.gmail.com>
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

On Tue, Jan 14, 2020 at 10:36 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Jan 14, 2020 at 8:46 AM Brian Vazquez <brianvv@google.com> wrote:
> >
> > From: Yonghong Song <yhs@fb.com>
> >
> > Added four libbpf API functions to support map batch operations:
> >   . int bpf_map_delete_batch( ... )
> >   . int bpf_map_lookup_batch( ... )
> >   . int bpf_map_lookup_and_delete_batch( ... )
> >   . int bpf_map_update_batch( ... )
> >
> > Signed-off-by: Yonghong Song <yhs@fb.com>
> > ---
> >  tools/lib/bpf/bpf.c      | 60 ++++++++++++++++++++++++++++++++++++++++
> >  tools/lib/bpf/bpf.h      | 22 +++++++++++++++
> >  tools/lib/bpf/libbpf.map |  4 +++
> >  3 files changed, 86 insertions(+)
> >
> > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> > index 500afe478e94a..12ce8d275f7dc 100644
> > --- a/tools/lib/bpf/bpf.c
> > +++ b/tools/lib/bpf/bpf.c
> > @@ -452,6 +452,66 @@ int bpf_map_freeze(int fd)
> >         return sys_bpf(BPF_MAP_FREEZE, &attr, sizeof(attr));
> >  }
> >
> > +static int bpf_map_batch_common(int cmd, int fd, void  *in_batch,
> > +                               void *out_batch, void *keys, void *values,
> > +                               __u32 *count,
> > +                               const struct bpf_map_batch_opts *opts)
> > +{
> > +       union bpf_attr attr = {};
> > +       int ret;
> > +
> > +       if (!OPTS_VALID(opts, bpf_map_batch_opts))
> > +               return -EINVAL;
> > +
> > +       memset(&attr, 0, sizeof(attr));
> > +       attr.batch.map_fd = fd;
> > +       attr.batch.in_batch = ptr_to_u64(in_batch);
> > +       attr.batch.out_batch = ptr_to_u64(out_batch);
> > +       attr.batch.keys = ptr_to_u64(keys);
> > +       attr.batch.values = ptr_to_u64(values);
> > +       if (count)
> > +               attr.batch.count = *count;
> > +       attr.batch.elem_flags  = OPTS_GET(opts, elem_flags, 0);
> > +       attr.batch.flags = OPTS_GET(opts, flags, 0);
> > +
> > +       ret = sys_bpf(cmd, &attr, sizeof(attr));
> > +       if (count)
> > +               *count = attr.batch.count;
>
> what if syscall failed, do you still want to assign *count then?

Hi Andrii, thanks for taking a look.

attr.batch.count should report the number of entries correctly
processed before finding and error, an example could be when you
provided a buffer for 3 entries and the map only has 1, ret is going
to be -ENOENT meaning that you traversed the map and you still want to
assign *count.

That being said, the condition 'if (count)' is wrong and I think it
should be removed.

>
> > +
> > +       return ret;
> > +}
> > +
>
> [...]
