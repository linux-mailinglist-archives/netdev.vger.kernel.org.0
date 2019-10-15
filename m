Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 421A6D820F
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 23:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbfJOVWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 17:22:05 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42300 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfJOVWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 17:22:05 -0400
Received: by mail-lj1-f194.google.com with SMTP id y23so21734953lje.9;
        Tue, 15 Oct 2019 14:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ii9vueLaDUep6/QZRi93XICeUHKX9eVAhqWMTcqPbY4=;
        b=IYGWViEXQODiRiHLJyVtOCJ3jTj9FJ48HkHVJCt7rqKSRt9u5u+SEMhC3sUsq2gAcX
         6cl+uyCvC/98Z/AapsltFl/tMj4TH+w9dPJg1ODAJH5W1enFNefZ6/Dl648FJ3wyE1+J
         Vm9plAfYjH/tAmJ/bXFm79B40tvUpsZjsiKU9fjNcKeggo9Gd6YcznFIM2CVQ6zri8zv
         qS2ZlsTZEUud0KGXkPQtnG4BF5FIFB2BggjPephHpFaEhTaLfDwtg+WaSgGQeDLWDVWQ
         gCJ7dJUN3QZZZwImXE6TtBjhLskf9tbqNdiReYBQdaA/9NDJ1z4KGxyM+aamJzpVlffv
         rJ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ii9vueLaDUep6/QZRi93XICeUHKX9eVAhqWMTcqPbY4=;
        b=IIsJ9oxQ5dpl1YPpSFFxCA9A2PbexXP2SNGuuvOkBkvNFYX6faGoPIjpvBrDQEcZSJ
         0dkiUctvfMy54KepV7TTwEDkikiO+cVaek95g4CVaEvORGiq8ixpO3RvM20ks3Cw+SNR
         Y7/SgeU8zTpUL09fRNyrde8ov4CaKsOVRyGbMqKxQ/noRnOm3sj/Tf8o7d84zZbkl+yN
         4txoaXE6HDFax9Tw0KWPVKiUpWLHYMRzN8M7Y/V0xLcK8KrSxYOXmB35anxx65Cl4C+4
         njAd8uLD1Y3vBhejNAOGJa4JQyPMepqT1Y/wpVf7vEGVzl1MUavHGfjs+SA2D+4lw8wZ
         vRDA==
X-Gm-Message-State: APjAAAW2MYulDyE16Z11Ppqbra3MiesssN1cVZFJJ+VRTZLvElBkVpIO
        O6zRb8J30Cg4Kq07C/uuogRBBtDqa7HN43R8fhw=
X-Google-Smtp-Source: APXvYqzf0h9hf5rTSvOLc63YQEFcPBL4hGQPEx2nK7D5fhBe36D3wXV0rcNvxEM6/Oc7sr+zZfbCL9Yq941njWf0Aqs=
X-Received: by 2002:a2e:9bc1:: with SMTP id w1mr18305743ljj.136.1571174522283;
 Tue, 15 Oct 2019 14:22:02 -0700 (PDT)
MIME-Version: 1.0
References: <20191011162124.52982-1-sdf@google.com> <CAADnVQLKPLXej_v7ymv3yJakoFLGeQwdZOJ5cZmp7xqOxfebqg@mail.gmail.com>
 <20191012003819.GK2096@mini-arch>
In-Reply-To: <20191012003819.GK2096@mini-arch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 15 Oct 2019 14:21:50 -0700
Message-ID: <CAADnVQKuysEvFAX54+f0YPJ1+cgcRJbhrpVE7xmvLqu-ADrk+Q@mail.gmail.com>
Subject: debug annotations for bpf progs. Was: [PATCH bpf-next 1/3] bpf:
 preserve command of the process that loaded the program
To:     Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
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

On Fri, Oct 11, 2019 at 5:38 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 10/11, Alexei Starovoitov wrote:
> > On Fri, Oct 11, 2019 at 9:21 AM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > Even though we have the pointer to user_struct and can recover
> > > uid of the user who has created the program, it usually contains
> > > 0 (root) which is not very informative. Let's store the comm of the
> > > calling process and export it via bpf_prog_info. This should help
> > > answer the question "which process loaded this particular program".
> > >
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  include/linux/bpf.h      | 1 +
> > >  include/uapi/linux/bpf.h | 2 ++
> > >  kernel/bpf/syscall.c     | 4 ++++
> > >  3 files changed, 7 insertions(+)
> > >
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index 5b9d22338606..b03ea396afe5 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -421,6 +421,7 @@ struct bpf_prog_aux {
> > >                 struct work_struct work;
> > >                 struct rcu_head rcu;
> > >         };
> > > +       char created_by_comm[BPF_CREATED_COMM_LEN];
> > >  };
> > >
> > >  struct bpf_array {
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index a65c3b0c6935..4e883ecbba1e 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -326,6 +326,7 @@ enum bpf_attach_type {
> > >  #define BPF_F_NUMA_NODE                (1U << 2)
> > >
> > >  #define BPF_OBJ_NAME_LEN 16U
> > > +#define BPF_CREATED_COMM_LEN   16U
> >
> > Nack.
> > 16 bytes is going to be useless.
> > We found it the hard way with prog_name.
> > If you want to embed additional debug information
> > please use BTF for that.
> BTF was my natural choice initially, but then I saw created_by_uid and
> thought created_by_comm might have a chance :-)
>
> To clarify, by BTF you mean creating some unused global variable
> and use its name as the debugging info? Or there is some better way?

I was thinking about adding new section to .btf.ext with this extra data,
but global variable is a better idea indeed.
We'd need to standardize such variables names, so that
bpftool can parse and print it while doing 'bpftool prog show'.
We see more and more cases where services use more than
one program in single .c file to accomplish their goals.
Tying such debug info (like 'created_by_comm') to each program
individually isn't quite right.
In that sense global variables are better, since they cover the
whole .c file.
Beyond 'created_by_comm' there are others things that people
will likely want to know.
Like which version of llvm was used to compile this .o file.
Which unix user name compiled it.
The name of service/daemon that will be using this .o
and so on.
May be some standard prefix to such global variables will do?
Like "bpftool prog show" can scan global data for
"__annotate_#name" and print both name and string contents ?
For folks who regularly ssh into servers to debug bpf progs
that will help a lot.
May be some annotations llvm can automatically add to .o.
Thoughts?
