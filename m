Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD8AB183D83
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgCLXrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:47:21 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:32816 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgCLXrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 19:47:21 -0400
Received: by mail-qt1-f196.google.com with SMTP id d22so6059164qtn.0;
        Thu, 12 Mar 2020 16:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lpl2QV0RKXwDmI8MubsMiuk111nEHMnLP4UT1DO8Mho=;
        b=bxNqYPT5JTuXMck79mwmNTqg6v/lFRntWvwyUfLe7bCEyTuZQmDMiTqeLk+5vW5vJ9
         zyd1D1dBF4IhTTC6BcACfywkZbYncuerakEg/CRBc53Pmiy/twKRywSrrQs1RdGzD0eh
         StgUWd1sSI2ZVTp7HXyiE9GY9CCkLul9A+ADpxqY3T9nHtWZ3AZMABn+pxvmPqJiRnFM
         56RHeK7OCUeWGP0Pq7xUEMYpOo0fHb1ftF6XLqYOmwEwk4QSBCKvwjGMLNFjFL4ElNEF
         Vbr22K+7aJFb0pIBekirqzrTTsQbTR8NmGeQUYb9/JDs4q58J/6eO/Q7ssrcHRePt9Oq
         ZXfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lpl2QV0RKXwDmI8MubsMiuk111nEHMnLP4UT1DO8Mho=;
        b=VtTlmt7qhxTGtYbfQtlJu4UHhpxvbKyLbplTOWpACtrKleBmh+3Pzrlr0fFfLZLfzu
         8EWy3QdtDRp8q76cQSLQKmfLEhOhfhQRB6FuMQ1axOZhjmlQ59KsUdc8e2+ZpAksM5EO
         uRnHW3gbU6eQqr9ol2u4Qn3CWyCsxPE1j1rYTCj15yQKkfwJ/fxhBbCe9utnYm0+TjP0
         9mBj7SAaslaj3Soe1PUcWZ5aLymEaXocgkko2oj7E1ZJJw6rQQ18lB+q1IQ7firQE0az
         7QPIgK5kbB6mCASI+49YCOuTjzogR4KN6o0jhpX7b7YUIIElqTl3nh7jGcoL5eYhfguk
         JwOg==
X-Gm-Message-State: ANhLgQ1KN9Oa5GKJI/O/TbzMoThwMwBUn5kqQ/HyFSmOAdfHSO4L4MQv
        UkOMtU+zl7JIJ7QrBxwlsLA1OrhXpef0j2/mK+o=
X-Google-Smtp-Source: ADFU+vst1ucxeTOlWGXd+1TVcOO/Ws08yxiRqBrllUjsR7tYAi6+VzVvMvgL1TaHLdJ8fMfUlwDCGO4333nX6izqcw0=
X-Received: by 2002:ac8:4e14:: with SMTP id c20mr9736769qtw.141.1584056839320;
 Thu, 12 Mar 2020 16:47:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200312203914.1195762-1-andriin@fb.com> <2d6ae192-fe22-0239-54c7-142ec21b7794@iogearbox.net>
 <CAEf4BzbcSC3LXckg3ksRhTN27g4sAXp_9-GgJFog21ZWAJU-DQ@mail.gmail.com> <e8845220-9817-6364-ffa8-f7195241881c@iogearbox.net>
In-Reply-To: <e8845220-9817-6364-ffa8-f7195241881c@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 12 Mar 2020 16:47:08 -0700
Message-ID: <CAEf4BzbjbXEBpYuhn_yQdHOb5Q3_WovEo87k0i+cu2BtCa_eOA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: abstract away entire bpf_link clean up procedure
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 4:41 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 3/13/20 12:27 AM, Andrii Nakryiko wrote:
> > On Thu, Mar 12, 2020 at 4:23 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >> On 3/12/20 9:39 PM, Andrii Nakryiko wrote:
> >>> Instead of requiring users to do three steps for cleaning up bpf_link, its
> >>> anon_inode file, and unused fd, abstract that away into bpf_link_cleanup()
> >>> helper. bpf_link_defunct() is removed, as it shouldn't be needed as an
> >>> individual operation anymore.
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>> ---
> >>>    include/linux/bpf.h  |  3 ++-
> >>>    kernel/bpf/syscall.c | 18 +++++++++++-------
> >>>    2 files changed, 13 insertions(+), 8 deletions(-)
> >>>
> >>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> >>> index 4fd91b7c95ea..358f3eb07c01 100644
> >>> --- a/include/linux/bpf.h
> >>> +++ b/include/linux/bpf.h
> >>> @@ -1075,7 +1075,8 @@ struct bpf_link_ops {
> >>>
> >>>    void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops,
> >>>                   struct bpf_prog *prog);
> >>> -void bpf_link_defunct(struct bpf_link *link);
> >>> +void bpf_link_cleanup(struct bpf_link *link, struct file *link_file,
> >>> +                   int link_fd);
> >>>    void bpf_link_inc(struct bpf_link *link);
> >>>    void bpf_link_put(struct bpf_link *link);
> >>>    int bpf_link_new_fd(struct bpf_link *link);
> >>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> >>> index b2f73ecacced..d2f49ae225b0 100644
> >>> --- a/kernel/bpf/syscall.c
> >>> +++ b/kernel/bpf/syscall.c
> >>> @@ -2188,9 +2188,17 @@ void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops,
> >>>        link->prog = prog;
> >>>    }
> >>>
> >>> -void bpf_link_defunct(struct bpf_link *link)
> >>> +/* Clean up bpf_link and corresponding anon_inode file and FD. After
> >>> + * anon_inode is created, bpf_link can't be just kfree()'d due to deferred
> >>> + * anon_inode's release() call. This helper manages marking bpf_link as
> >>> + * defunct, releases anon_inode file and puts reserved FD.
> >>> + */
> >>> +void bpf_link_cleanup(struct bpf_link *link, struct file *link_file,
> >>> +                   int link_fd)
> >>
> >> Looks good, but given it is only used here this should be static instead.
> >
> > This is part of bpf_link internal API. I have patches locally for
> > cgroup bpf_link that use this for clean up as well already, other
> > bpf_link types will also use this.
>
> Meaning it's a logical part of your future series. When you added the bpf_link_*
> stuff only the symbols should have been in bpf.h that are actually used in the
> tree outside of syscall.c, and when you extend the series in future /then/ we
> can export more as needed, so everything is kept self-contained. This is common
> practice.

Alright, will remove in v2.

>
> Thanks,
> Daniel
