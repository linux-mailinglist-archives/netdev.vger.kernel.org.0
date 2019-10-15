Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697F1D83A2
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 00:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389883AbfJOW0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 18:26:15 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33913 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732259AbfJOW0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 18:26:14 -0400
Received: by mail-pl1-f195.google.com with SMTP id k7so10274196pll.1
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 15:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vVaF3Z0aZnn74T0+fhpc76Lpt98jgY+vejo7A/5Cz0E=;
        b=tjpuw2lRaWZ6BLWJPfe+bH7kN3E+6zELZdsvnPiS3UxkyIYhe2QYZz9+E6oR2LvVO4
         6bb1vezeo6jr/u2rWPcN2EieoqduJgaX/GndG1V5J8VxvYQi1XojSRRxGOcmeXXH8s++
         zomZXZ2bafap+Yd+Vzg4kEZiqeiN9mMY25o7lOGW64TSXuddNxZ9G52a2/I7CyPomWW0
         5bfNuSCTu9ME6qEaydVs0jZtOWlgdCQ9yIs4st2RnFgCwM36W65CLHHW3/mmGw5HcMvO
         SSzKynKMYqoiOzMP2RDsBYxwLxxGbHGY3x09fibv63ehnLfgs9mNDU3TtSgN+7CZWE5N
         MpYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vVaF3Z0aZnn74T0+fhpc76Lpt98jgY+vejo7A/5Cz0E=;
        b=cnEinm1WQXGwSmtiWbCeFSa+9V5N4g3k+AHo1uijiN9OxMXwUbb/1Nqq2nMfaOQFAJ
         yPphKh4H1N2WaW8mMGIb/AGW32YmATYjO9Sg2vhUf124wCxhyMvEq97ZzmXunPCKwkaI
         HSrJi7HT6WARaX6amWc3Axq6+8m/RnxW38paTGfc3NN+YO0e2k7fd20b2BmouwAaHkj4
         tnHiC//KAsggvRm6yMC0QP9HZyqrW+G8P3bYjyCmoXKwNhJpssp1ZvabRI30B7nC7m9N
         WBuHR2Kjy6ZdrSJ9oBBsdx7/I/QBHr9mOW19MjqhTnfziYWjnVNojdy7NEqChi/ISxM+
         8UYA==
X-Gm-Message-State: APjAAAUoBVk9DW75Do5jyvAuiaHlm2agwDmaaEv79Id99e+FdNL059Kk
        3BO1tBQ8JBNHagh8ezS1s0Q5sA==
X-Google-Smtp-Source: APXvYqy3X64BTPhiVViirng7qJQJr1av8aP7t7Uc13aY1gcQHh8yyfZcMUUbCMtMj//F2GM39Zotwg==
X-Received: by 2002:a17:902:9a41:: with SMTP id x1mr37045086plv.331.1571178373075;
        Tue, 15 Oct 2019 15:26:13 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id b16sm30568675pfb.54.2019.10.15.15.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 15:26:12 -0700 (PDT)
Date:   Tue, 15 Oct 2019 15:26:12 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Subject: Re: debug annotations for bpf progs. Was: [PATCH bpf-next 1/3] bpf:
 preserve command of the process that loaded the program
Message-ID: <20191015222612.GB1897241@mini-arch>
References: <20191011162124.52982-1-sdf@google.com>
 <CAADnVQLKPLXej_v7ymv3yJakoFLGeQwdZOJ5cZmp7xqOxfebqg@mail.gmail.com>
 <20191012003819.GK2096@mini-arch>
 <CAADnVQKuysEvFAX54+f0YPJ1+cgcRJbhrpVE7xmvLqu-ADrk+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKuysEvFAX54+f0YPJ1+cgcRJbhrpVE7xmvLqu-ADrk+Q@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15, Alexei Starovoitov wrote:
> On Fri, Oct 11, 2019 at 5:38 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 10/11, Alexei Starovoitov wrote:
> > > On Fri, Oct 11, 2019 at 9:21 AM Stanislav Fomichev <sdf@google.com> wrote:
> > > >
> > > > Even though we have the pointer to user_struct and can recover
> > > > uid of the user who has created the program, it usually contains
> > > > 0 (root) which is not very informative. Let's store the comm of the
> > > > calling process and export it via bpf_prog_info. This should help
> > > > answer the question "which process loaded this particular program".
> > > >
> > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > ---
> > > >  include/linux/bpf.h      | 1 +
> > > >  include/uapi/linux/bpf.h | 2 ++
> > > >  kernel/bpf/syscall.c     | 4 ++++
> > > >  3 files changed, 7 insertions(+)
> > > >
> > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > index 5b9d22338606..b03ea396afe5 100644
> > > > --- a/include/linux/bpf.h
> > > > +++ b/include/linux/bpf.h
> > > > @@ -421,6 +421,7 @@ struct bpf_prog_aux {
> > > >                 struct work_struct work;
> > > >                 struct rcu_head rcu;
> > > >         };
> > > > +       char created_by_comm[BPF_CREATED_COMM_LEN];
> > > >  };
> > > >
> > > >  struct bpf_array {
> > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > index a65c3b0c6935..4e883ecbba1e 100644
> > > > --- a/include/uapi/linux/bpf.h
> > > > +++ b/include/uapi/linux/bpf.h
> > > > @@ -326,6 +326,7 @@ enum bpf_attach_type {
> > > >  #define BPF_F_NUMA_NODE                (1U << 2)
> > > >
> > > >  #define BPF_OBJ_NAME_LEN 16U
> > > > +#define BPF_CREATED_COMM_LEN   16U
> > >
> > > Nack.
> > > 16 bytes is going to be useless.
> > > We found it the hard way with prog_name.
> > > If you want to embed additional debug information
> > > please use BTF for that.
> > BTF was my natural choice initially, but then I saw created_by_uid and
> > thought created_by_comm might have a chance :-)
> >
> > To clarify, by BTF you mean creating some unused global variable
> > and use its name as the debugging info? Or there is some better way?
> 
> I was thinking about adding new section to .btf.ext with this extra data,
> but global variable is a better idea indeed.
> We'd need to standardize such variables names, so that
> bpftool can parse and print it while doing 'bpftool prog show'.
> We see more and more cases where services use more than
> one program in single .c file to accomplish their goals.
> Tying such debug info (like 'created_by_comm') to each program
> individually isn't quite right.
> In that sense global variables are better, since they cover the
> whole .c file.
> Beyond 'created_by_comm' there are others things that people
> will likely want to know.
> Like which version of llvm was used to compile this .o file.
> Which unix user name compiled it.
> The name of service/daemon that will be using this .o
> and so on.
> May be some standard prefix to such global variables will do?
> Like "bpftool prog show" can scan global data for
> "__annotate_#name" and print both name and string contents ?
> For folks who regularly ssh into servers to debug bpf progs
> that will help a lot.
> May be some annotations llvm can automatically add to .o.
> Thoughts?
We started some proof-of-concept prototyping yesterday; the idea, roughly:
* build system generates build_info.h header which contains:
  char __attribute__((section("aux_timestamp"))) *__aux_<build timestamp> = "";
  char __attribute__((section("aux_version"))) *__aux_<version> = "";
  ...
* clang has -include flag which includes this auto-generated file,
  so we don't rely on users including it
* 'bpftool show btf | grep aux_' can be used for low-level debugging

It's not pretty, but it gets the job done. I agree that having some sort of
convention is nice to make it more usable. If we can agree on a pre-defined
section (aux in my case) so that bpftool can take "variable" from
aux_<variable> section name and print "value" from __aux_<value>,
that would be nice.

One thing I still have no idea how to implement with this scheme
is some alternative to created_by_comm. There is no easy way to
add some BTF at runtime (load) time. Ideas?

> "__annotate_#name" and print both name and string contents ?
As Andrii just pointed out, this requires knowing where to look
for the obj files to print the contents of the vars :-(
