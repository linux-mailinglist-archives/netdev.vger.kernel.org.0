Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E60B2D8395
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 00:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389858AbfJOWYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 18:24:34 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39435 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389809AbfJOWYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 18:24:34 -0400
Received: by mail-lj1-f195.google.com with SMTP id y3so21905050ljj.6;
        Tue, 15 Oct 2019 15:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4A3UP5Q4Bqw8pssESrvwJKKsDGCOUUS60rTGAoCDNBw=;
        b=M6SwAkC/48nx2tt6txnhnj0pzWzIVT3fFWMsUghr7ITfyGpLZRo7/m/fPisQtnh2hR
         okpmKY7167bzPlJwyHrsy7V3st+5eb9LpHdN9oD6RVZ0p8k+m44BfP30PQaDHjpza3Ju
         TuXl/3ItnW/X8CM3L8TcZpzP8cjfkMIOPCe0VkAMPVx3ttTBnr/2zWY2S9e+w6AgH9jC
         tKvcbXow67mm0+MuQsLpfV+PNji606g/rqHSwPgIXCU5/VD9Js5jC+t0icQeinUsgqUm
         6sGhVj2okTKH+STi5jPbp/BwGUpkDyqh9qto4rpxCG4SE3bzkm+a4RD7dRhy8hXcGpkf
         H20A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4A3UP5Q4Bqw8pssESrvwJKKsDGCOUUS60rTGAoCDNBw=;
        b=DIykIe2AAwedIwpZ9IDxuZM4Pj/ZeeehbxMmJ73K1QpkHsRZO/DMli3aEtOiWdfbLV
         KSX84tgzXvjUFxoKjWI3QxDcvEWfFqdjwgNFUQIInbua2n+PJog7QiWkjt8O/BsyyjRl
         VdRq+o8jgOoPgkLl+R4J19BjEnE2SvOG9y77bBvkO5zgiZlVATl91r8nZxktDvLz1+CD
         GrBL+HY4NKRWdp7WkJK6gvE4hRQ6w5a3XApwidjX7ZdkyMTl5J+22G8a5lctUZ+hQBOw
         R6k9b0XnZtdskESGZ1QEhr0h/PUQodJ/9ik6E+lubT/cws+JN1iyIuSQCJQA8/X1UQpr
         axIg==
X-Gm-Message-State: APjAAAWmzF8gnx5AxCLu/Av2kPARKCBCCYLKveE1qZNikf32Iv8LJ6rQ
        ZUfwYZGHhgnFhej53uRnvpNLJ075R0IjKQFzukw=
X-Google-Smtp-Source: APXvYqweUlDS9HeOjPbHSSk911TgOKZrp5iN3Qoa1Poy3xm9Bdk0UgBkt4Ql3AB/rPl3TQwk+/FV1/By4k+3EeLJwZ0=
X-Received: by 2002:a2e:4e12:: with SMTP id c18mr24646843ljb.51.1571178271625;
 Tue, 15 Oct 2019 15:24:31 -0700 (PDT)
MIME-Version: 1.0
References: <20191011162124.52982-1-sdf@google.com> <CAADnVQLKPLXej_v7ymv3yJakoFLGeQwdZOJ5cZmp7xqOxfebqg@mail.gmail.com>
 <20191012003819.GK2096@mini-arch> <CAADnVQKuysEvFAX54+f0YPJ1+cgcRJbhrpVE7xmvLqu-ADrk+Q@mail.gmail.com>
 <CAEf4BzaKn0ztTCJq7VOsyMfCqqq1HkxXwD6xEYL_3cbYkiPEgg@mail.gmail.com>
In-Reply-To: <CAEf4BzaKn0ztTCJq7VOsyMfCqqq1HkxXwD6xEYL_3cbYkiPEgg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 15 Oct 2019 15:24:19 -0700
Message-ID: <CAADnVQ+1HRrMsv4NKvZ_=LWHrWTXWd8RYJS4ybXJXgdLuHugMA@mail.gmail.com>
Subject: Re: debug annotations for bpf progs. Was: [PATCH bpf-next 1/3] bpf:
 preserve command of the process that loaded the program
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 3:14 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Oct 15, 2019 at 2:22 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Oct 11, 2019 at 5:38 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > >
> > > On 10/11, Alexei Starovoitov wrote:
> > > > On Fri, Oct 11, 2019 at 9:21 AM Stanislav Fomichev <sdf@google.com> wrote:
> > > > >
> > > > > Even though we have the pointer to user_struct and can recover
> > > > > uid of the user who has created the program, it usually contains
> > > > > 0 (root) which is not very informative. Let's store the comm of the
> > > > > calling process and export it via bpf_prog_info. This should help
> > > > > answer the question "which process loaded this particular program".
> > > > >
> > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > ---
> > > > >  include/linux/bpf.h      | 1 +
> > > > >  include/uapi/linux/bpf.h | 2 ++
> > > > >  kernel/bpf/syscall.c     | 4 ++++
> > > > >  3 files changed, 7 insertions(+)
> > > > >
> > > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > > index 5b9d22338606..b03ea396afe5 100644
> > > > > --- a/include/linux/bpf.h
> > > > > +++ b/include/linux/bpf.h
> > > > > @@ -421,6 +421,7 @@ struct bpf_prog_aux {
> > > > >                 struct work_struct work;
> > > > >                 struct rcu_head rcu;
> > > > >         };
> > > > > +       char created_by_comm[BPF_CREATED_COMM_LEN];
> > > > >  };
> > > > >
> > > > >  struct bpf_array {
> > > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > > index a65c3b0c6935..4e883ecbba1e 100644
> > > > > --- a/include/uapi/linux/bpf.h
> > > > > +++ b/include/uapi/linux/bpf.h
> > > > > @@ -326,6 +326,7 @@ enum bpf_attach_type {
> > > > >  #define BPF_F_NUMA_NODE                (1U << 2)
> > > > >
> > > > >  #define BPF_OBJ_NAME_LEN 16U
> > > > > +#define BPF_CREATED_COMM_LEN   16U
> > > >
> > > > Nack.
> > > > 16 bytes is going to be useless.
> > > > We found it the hard way with prog_name.
> > > > If you want to embed additional debug information
> > > > please use BTF for that.
> > > BTF was my natural choice initially, but then I saw created_by_uid and
> > > thought created_by_comm might have a chance :-)
> > >
> > > To clarify, by BTF you mean creating some unused global variable
> > > and use its name as the debugging info? Or there is some better way?
> >
> > I was thinking about adding new section to .btf.ext with this extra data,
> > but global variable is a better idea indeed.
> > We'd need to standardize such variables names, so that
> > bpftool can parse and print it while doing 'bpftool prog show'.
> > We see more and more cases where services use more than
> > one program in single .c file to accomplish their goals.
> > Tying such debug info (like 'created_by_comm') to each program
> > individually isn't quite right.
> > In that sense global variables are better, since they cover the
> > whole .c file.
> > Beyond 'created_by_comm' there are others things that people
> > will likely want to know.
> > Like which version of llvm was used to compile this .o file.
> > Which unix user name compiled it.
> > The name of service/daemon that will be using this .o
> > and so on.
> > May be some standard prefix to such global variables will do?
> > Like "bpftool prog show" can scan global data for
> > "__annotate_#name" and print both name and string contents ?
> > For folks who regularly ssh into servers to debug bpf progs
> > that will help a lot.
> > May be some annotations llvm can automatically add to .o.
> > Thoughts?
>
> We can dedicate separate ELF section for such variables, similar to
> license and version today, so that libbpf will know that those
> variables are not real variables and shouldn't be used from BPF
> program itself. But we can have many of them in single section, unlike
> version and license. :) With that, we'll have metadata and list of
> variables in BTF (DATASEC + VARs). The only downside - you'll need ELF
> itself to get the value of that variable, no? Is that acceptable? Do
> we always know where original ELF is?

Having .o around is not acceptable.
That was already tried and didn't work with bcc.
I was proposing to have these special vars to be loaded into the kernel
as part of normal btf loading.
Not sure what special section gives.
