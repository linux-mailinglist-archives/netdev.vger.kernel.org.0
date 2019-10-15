Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF6C6D83C5
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 00:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732481AbfJOWeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 18:34:17 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38645 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732040AbfJOWeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 18:34:16 -0400
Received: by mail-qk1-f196.google.com with SMTP id p4so305186qkf.5;
        Tue, 15 Oct 2019 15:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4AyMktzsTkv7aY4ZRJQAUNTUY8eMY0KqI0FaLqiE3Fo=;
        b=KCJY/TuKPwuRUnx6pza32kr3b4+favZGvpkv5SZACHhUlm3F5Hz6h5/zJBWbHKWw5F
         xKlfKx2GGUeR1SRfUGGHucF1kA9lTiqbLdG1+9upXsVCS0dCFCijqZMQLcYY8Kf6VKm3
         ZN2CiodXpEtCZzxYCy+qmwzg3kEZmGAUPzexZiIBHpCqd8H7d/WgF7bcwZC4mmi2tkgg
         bMHBlG82Ea6b6X9EtmfMfGpmG6PLe//XzpDp4UP8PNbc7YCWuY7N7KprKDkEQRy52OsK
         EQiGwDfib+0FVyLZa9gywLIut0degBF4xWpB5DDSfmYpcerFq5uGLA1TNJrNVaoX4rSC
         T9Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4AyMktzsTkv7aY4ZRJQAUNTUY8eMY0KqI0FaLqiE3Fo=;
        b=iqQnEWmtQnE5Q5p10L6CAp6GnzGWsQTPVFgpb3ZeFmyQfKD6LxXx5E9PQAb35j46e/
         Kf7eVcphN16dye7Tpnq+53LnNwjI0k4wTHStm38RiiMIVO0kW6Iz/BqjEwehksrutuLl
         1HaGPjZtu1xumNLQABbxoEbfi0cQIGdB7ucSsURT+du9Bq4u4t44HH7uz9MDmKAPTdsB
         lo0IJA1y2wVw3JqO6QSXb7MO/eFM11tioSbSyB2EIV3c+fa5fkR3t0tSUwyzHs8GkNO2
         ECpNv7ipdB7xWP4AGscxiPlitKvN1Gd1lwD1HuYOQL241w7peVm1kg1ypxk9Kme97Mqg
         eYHQ==
X-Gm-Message-State: APjAAAXmZgfFvdFPw2zXyAkhn9kPlAFOICZdH6i6tqWeDiMaBrWR9t5z
        hea5UOx67dOqGfbzrvYn5Xtu3he0JuETs0dy65dOQ+wN
X-Google-Smtp-Source: APXvYqzIzcgB3Huzz14rqnHe/p4tutlP/9m/kZbwrhw1m/RlBiVbkl5OwlXF+3FRybhVeKxvc3ojWcxVoIAVkNcRnK4=
X-Received: by 2002:a37:4c13:: with SMTP id z19mr39679360qka.449.1571178853685;
 Tue, 15 Oct 2019 15:34:13 -0700 (PDT)
MIME-Version: 1.0
References: <20191011162124.52982-1-sdf@google.com> <CAADnVQLKPLXej_v7ymv3yJakoFLGeQwdZOJ5cZmp7xqOxfebqg@mail.gmail.com>
 <20191012003819.GK2096@mini-arch> <CAADnVQKuysEvFAX54+f0YPJ1+cgcRJbhrpVE7xmvLqu-ADrk+Q@mail.gmail.com>
 <CAEf4BzaKn0ztTCJq7VOsyMfCqqq1HkxXwD6xEYL_3cbYkiPEgg@mail.gmail.com> <CAADnVQ+1HRrMsv4NKvZ_=LWHrWTXWd8RYJS4ybXJXgdLuHugMA@mail.gmail.com>
In-Reply-To: <CAADnVQ+1HRrMsv4NKvZ_=LWHrWTXWd8RYJS4ybXJXgdLuHugMA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Oct 2019 15:33:58 -0700
Message-ID: <CAEf4Bzby5ixEzrmXJOYP9WNORQ1HWCfXVN+EtcjBVz2J1XwEfQ@mail.gmail.com>
Subject: Re: debug annotations for bpf progs. Was: [PATCH bpf-next 1/3] bpf:
 preserve command of the process that loaded the program
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Tue, Oct 15, 2019 at 3:24 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Oct 15, 2019 at 3:14 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Oct 15, 2019 at 2:22 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Fri, Oct 11, 2019 at 5:38 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > > >
> > > > On 10/11, Alexei Starovoitov wrote:
> > > > > On Fri, Oct 11, 2019 at 9:21 AM Stanislav Fomichev <sdf@google.com> wrote:
> > > > > >
> > > > > > Even though we have the pointer to user_struct and can recover
> > > > > > uid of the user who has created the program, it usually contains
> > > > > > 0 (root) which is not very informative. Let's store the comm of the
> > > > > > calling process and export it via bpf_prog_info. This should help
> > > > > > answer the question "which process loaded this particular program".
> > > > > >
> > > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > > ---
> > > > > >  include/linux/bpf.h      | 1 +
> > > > > >  include/uapi/linux/bpf.h | 2 ++
> > > > > >  kernel/bpf/syscall.c     | 4 ++++
> > > > > >  3 files changed, 7 insertions(+)
> > > > > >
> > > > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > > > index 5b9d22338606..b03ea396afe5 100644
> > > > > > --- a/include/linux/bpf.h
> > > > > > +++ b/include/linux/bpf.h
> > > > > > @@ -421,6 +421,7 @@ struct bpf_prog_aux {
> > > > > >                 struct work_struct work;
> > > > > >                 struct rcu_head rcu;
> > > > > >         };
> > > > > > +       char created_by_comm[BPF_CREATED_COMM_LEN];
> > > > > >  };
> > > > > >
> > > > > >  struct bpf_array {
> > > > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > > > index a65c3b0c6935..4e883ecbba1e 100644
> > > > > > --- a/include/uapi/linux/bpf.h
> > > > > > +++ b/include/uapi/linux/bpf.h
> > > > > > @@ -326,6 +326,7 @@ enum bpf_attach_type {
> > > > > >  #define BPF_F_NUMA_NODE                (1U << 2)
> > > > > >
> > > > > >  #define BPF_OBJ_NAME_LEN 16U
> > > > > > +#define BPF_CREATED_COMM_LEN   16U
> > > > >
> > > > > Nack.
> > > > > 16 bytes is going to be useless.
> > > > > We found it the hard way with prog_name.
> > > > > If you want to embed additional debug information
> > > > > please use BTF for that.
> > > > BTF was my natural choice initially, but then I saw created_by_uid and
> > > > thought created_by_comm might have a chance :-)
> > > >
> > > > To clarify, by BTF you mean creating some unused global variable
> > > > and use its name as the debugging info? Or there is some better way?
> > >
> > > I was thinking about adding new section to .btf.ext with this extra data,
> > > but global variable is a better idea indeed.
> > > We'd need to standardize such variables names, so that
> > > bpftool can parse and print it while doing 'bpftool prog show'.
> > > We see more and more cases where services use more than
> > > one program in single .c file to accomplish their goals.
> > > Tying such debug info (like 'created_by_comm') to each program
> > > individually isn't quite right.
> > > In that sense global variables are better, since they cover the
> > > whole .c file.
> > > Beyond 'created_by_comm' there are others things that people
> > > will likely want to know.
> > > Like which version of llvm was used to compile this .o file.
> > > Which unix user name compiled it.
> > > The name of service/daemon that will be using this .o
> > > and so on.
> > > May be some standard prefix to such global variables will do?
> > > Like "bpftool prog show" can scan global data for
> > > "__annotate_#name" and print both name and string contents ?
> > > For folks who regularly ssh into servers to debug bpf progs
> > > that will help a lot.
> > > May be some annotations llvm can automatically add to .o.
> > > Thoughts?
> >
> > We can dedicate separate ELF section for such variables, similar to
> > license and version today, so that libbpf will know that those
> > variables are not real variables and shouldn't be used from BPF
> > program itself. But we can have many of them in single section, unlike
> > version and license. :) With that, we'll have metadata and list of
> > variables in BTF (DATASEC + VARs). The only downside - you'll need ELF
> > itself to get the value of that variable, no? Is that acceptable? Do
> > we always know where original ELF is?
>
> Having .o around is not acceptable.
> That was already tried and didn't work with bcc.
> I was proposing to have these special vars to be loaded into the kernel
> as part of normal btf loading.

BTF is just metadata for variables. We'll know name and type
information about variable, but we need a string contents. That is
stored in ELF, so without .o file we won't be able to extract it.
Unless you have something else in mind?

> Not sure what special section gives.

It's a marker that libbpf doesn't have to allocate memory and create
internal map for that section. We don't want those annotation
variables to be backed by BPF map, do we?
