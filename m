Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4F7201A5C
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731228AbgFSSZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbgFSSZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 14:25:39 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF1CC06174E;
        Fri, 19 Jun 2020 11:25:39 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id u17so7955485qtq.1;
        Fri, 19 Jun 2020 11:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UKQDrHfQKlAwRetqN3yWweOMe2a7d5XeUCsMt86IhZU=;
        b=CoxRKf4Yb4EnJGtJlcc23tfjvdWywG5lvFfK3kQ3BgtRTJLl5ChNhKuooKerJ5LXor
         Hh6CeksJ3q5uFnD0TDK8swFFXRyo6GTudVZyedIJm9YJNavgFv98tMHdYW9LKVoLM50J
         pnw4WK2kyyGVJXfXVj9eHSXeK3dVgB9+AdCYpZ2FtpjZZa9wQt+lnCazwtxAYcP+hcpI
         y1yLwgQbPaow/qiOCuVjWX3Gg2ozQelJmtG2CQR+6ur014n7ga1ZIuIJ/llnpX5at8y1
         kvIXuuXUxBEeUSVdm/+aH35RmY9hFi53/6tF0fQcUR9phA3s/0dOIQVQvhceo+E5kwhr
         E3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UKQDrHfQKlAwRetqN3yWweOMe2a7d5XeUCsMt86IhZU=;
        b=Dkx39GMZDixeY5bYFrAidyeXNy+lf1lO6Q9kUSmCD9XizgPEuFEbK6Tz/agdl/j/lE
         n74KGdETXQHlFIaKPrUI0dudQKOJ7Naf+wNxAzoVIPP2+ksHelkE2GLG9+BFQI4Sv3lF
         Y5gJED/9iZHovJu8DqxPN4JFWoYWYaSCCnbXrSVAkrYxh2qoYR+IZJPrxirOZcGYPEas
         Vto81Gn1t40Hj6KNMS/fWN+ektqAptP843Iwg52cXOBbBzxfA81jkWeRhIXbN+5TjFPW
         OqR0hyDC0MJVcIyklCZcL7IEvlIKQS/9SjJ+9i0dBLYPDetHxI0lLQUr6pb+4zlTlImG
         mByQ==
X-Gm-Message-State: AOAM530cM1axLRcUP9otmPbGF/W2Wop34o6/vm6wA6j4uwmZlREbBEeF
        N29wA5ZEUk/x309BAPziPd/oQK5hnfTg9XEbh2A=
X-Google-Smtp-Source: ABdhPJy1hobkBSHWIJdIcaUbIy4e9uYICyr0E/cEj+L0b26153zLZ3WhHbepdDK1to8A510PcOPo17ixrlGSogOlHes=
X-Received: by 2002:ac8:342b:: with SMTP id u40mr4668299qtb.59.1592591138774;
 Fri, 19 Jun 2020 11:25:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200616100512.2168860-1-jolsa@kernel.org> <20200616100512.2168860-10-jolsa@kernel.org>
 <CAEf4BzY=d5y_-fXvomG7SjkbK7DZn5=-f+sdCYRdZh9qeynQrQ@mail.gmail.com> <20200619133124.GJ2465907@krava>
In-Reply-To: <20200619133124.GJ2465907@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 19 Jun 2020 11:25:27 -0700
Message-ID: <CAEf4BzZDCtW-5r5rN+ufZi1hUXjw8QCF+CiyT5sOvQQEEOqtiQ@mail.gmail.com>
Subject: Re: [PATCH 09/11] bpf: Add d_path helper
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
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

On Fri, Jun 19, 2020 at 6:31 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Jun 18, 2020 at 09:35:10PM -0700, Andrii Nakryiko wrote:
> > On Tue, Jun 16, 2020 at 3:07 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > Adding d_path helper function that returns full path
> > > for give 'struct path' object, which needs to be the
> > > kernel BTF 'path' object.
> > >
> > > The helper calls directly d_path function.
> > >
> > > Updating also bpf.h tools uapi header and adding
> > > 'path' to bpf_helpers_doc.py script.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  include/linux/bpf.h            |  4 ++++
> > >  include/uapi/linux/bpf.h       | 14 ++++++++++++-
> > >  kernel/bpf/btf_ids.c           | 11 ++++++++++
> > >  kernel/trace/bpf_trace.c       | 38 ++++++++++++++++++++++++++++++++++
> > >  scripts/bpf_helpers_doc.py     |  2 ++
> > >  tools/include/uapi/linux/bpf.h | 14 ++++++++++++-
> > >  6 files changed, 81 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index a94e85c2ec50..d35265b6c574 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -1752,5 +1752,9 @@ extern int bpf_skb_output_btf_ids[];
> > >  extern int bpf_seq_printf_btf_ids[];
> > >  extern int bpf_seq_write_btf_ids[];
> > >  extern int bpf_xdp_output_btf_ids[];
> > > +extern int bpf_d_path_btf_ids[];
> > > +
> > > +extern int btf_whitelist_d_path[];
> > > +extern int btf_whitelist_d_path_cnt;
> >
> > So with suggestion from previous patch, this would be declared as:
> >
> > extern const struct btf_id_set btf_whitelist_d_path;
>
> yes
>
> SNIP
>
> > >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > >   * function eBPF program intends to call
> > > diff --git a/kernel/bpf/btf_ids.c b/kernel/bpf/btf_ids.c
> > > index d8d0df162f04..853c8fd59b06 100644
> > > --- a/kernel/bpf/btf_ids.c
> > > +++ b/kernel/bpf/btf_ids.c
> > > @@ -13,3 +13,14 @@ BTF_ID(struct, seq_file)
> > >
> > >  BTF_ID_LIST(bpf_xdp_output_btf_ids)
> > >  BTF_ID(struct, xdp_buff)
> > > +
> > > +BTF_ID_LIST(bpf_d_path_btf_ids)
> > > +BTF_ID(struct, path)
> > > +
> > > +BTF_WHITELIST_ENTRY(btf_whitelist_d_path)
> > > +BTF_ID(func, vfs_truncate)
> > > +BTF_ID(func, vfs_fallocate)
> > > +BTF_ID(func, dentry_open)
> > > +BTF_ID(func, vfs_getattr)
> > > +BTF_ID(func, filp_close)
> > > +BTF_WHITELIST_END(btf_whitelist_d_path)
> >
> > Oh, so that's why you added btf_ids.c. Do you think centralizing all
> > those BTF ID lists in one file is going to be more convenient? I lean
> > towards keeping them closer to where they are used, as it was with all
> > those helper BTF IDS. But I wonder what others think...
>
> either way works for me, but then BTF_ID_* macros needs to go
> to include/linux/btf_ids.h header right?
>

given it's internal API, I'd probably just put it in
include/linux/btf.h or include/linux/bpf.h, don't think we need extra
header just for these


> jirka
>
> >
> > > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > > index c1866d76041f..0ff5d8434d40 100644
> > > --- a/kernel/trace/bpf_trace.c
> > > +++ b/kernel/trace/bpf_trace.c
> > > @@ -1016,6 +1016,42 @@ static const struct bpf_func_proto bpf_send_signal_thread_proto = {
> > >         .arg1_type      = ARG_ANYTHING,
> > >  };
> > >
> >
> > [...]
> >
>
