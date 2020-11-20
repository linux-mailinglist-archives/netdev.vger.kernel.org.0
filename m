Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B6D2B9F6F
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 01:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgKTAwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 19:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgKTAwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 19:52:00 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71775C0617A7
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 16:51:58 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id y16so8306451ljh.0
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 16:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mKrN4he/vrkvSrt1zels/CsZiFdIdrq/rbFyu4ivPdo=;
        b=G0OBorvPg6QLTXy0J826VdaMJhGCVThSwjj+bJlGsE1FzCeRy34fdo3fP95cwfZsBV
         pBdW9+mgCmyROiX0rFTyOO6Epo96f0KfNBCnhp/WjIiKcA4VOYKxL/6QgtZrFzwAVUy9
         EGB7Cjv5dLrkBNexClj4soBKqMbASC8/nIHqk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mKrN4he/vrkvSrt1zels/CsZiFdIdrq/rbFyu4ivPdo=;
        b=A1Q9DtxHw4CoG9fyECV5Ge3RykOwFLXITe5zDj1ws9PpXgv3ZdE/wJtShHqKVmi2a/
         6uZ3M9RZO8k1DENBCK3LXDTRB20nrTLuhbVcgrVuWQVGoqHLYUt8SxfUspO5TLzDmkzO
         FhAuvwIalDx0n57YzoWAFWxTlYqqHxu39r3CKYuxP1r5m4/VDAkrTPCX/LGVxZaWvcRM
         YAaFfShghiEjwJqZODa6B0M9Q7SaSytIxfZTbAgGnrJtPj3nW4nprAAVoG/RCsm2/Bbo
         2CeJAFBIZpEGqk26d2qT+sfuVggO1gaIDeCJtwMACPW8wshkx5Mcz3ED8otxOOMHYGjb
         JBcQ==
X-Gm-Message-State: AOAM532HXXfB77Q+fRqyq1LSAr91qhEoxkWR+ciGJ8ghKcNqxXMrQNw4
        PSXIjbjzMHQGTSPeyYcik70sacRZj6kGWYM0P0rlyg==
X-Google-Smtp-Source: ABdhPJzEixQlbGMhcCEj/OFUKI1Rd6geRcbZACBNq38zAfavN0BMSsd96rY2DYd4IGhTHca3FYYOCrh9nhLWIXql9ko=
X-Received: by 2002:a2e:85c6:: with SMTP id h6mr7382215ljj.110.1605833516848;
 Thu, 19 Nov 2020 16:51:56 -0800 (PST)
MIME-Version: 1.0
References: <20201119162654.2410685-1-revest@chromium.org> <20201119162654.2410685-5-revest@chromium.org>
 <20201120003217.pnqu66467punkjln@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201120003217.pnqu66467punkjln@kafai-mbp.dhcp.thefacebook.com>
From:   KP Singh <kpsingh@chromium.org>
Date:   Fri, 20 Nov 2020 01:51:46 +0100
Message-ID: <CACYkzJ5z1CQjdMjsZK=3A9tRuWXtmJ-f2nrgbfBGXn_d-KknoA@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] bpf: Add an iterator selftest for bpf_sk_storage_get
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Florent Revest <revest@chromium.org>, bpf <bpf@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Florent Revest <revest@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 1:32 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Nov 19, 2020 at 05:26:54PM +0100, Florent Revest wrote:
> > From: Florent Revest <revest@google.com>
> >
> > The eBPF program iterates over all files and tasks. For all socket
> > files, it stores the tgid of the last task it encountered with a handle
> > to that socket. This is a heuristic for finding the "owner" of a socket
> > similar to what's done by lsof, ss, netstat or fuser. Potentially, this
> > information could be used from a cgroup_skb/*gress hook to try to
> > associate network traffic with processes.
> >
> > The test makes sure that a socket it created is tagged with prog_tests's
> > pid.
> >
> > Signed-off-by: Florent Revest <revest@google.com>
> > ---
> >  .../selftests/bpf/prog_tests/bpf_iter.c       | 35 +++++++++++++++++++
> >  .../progs/bpf_iter_bpf_sk_storage_helpers.c   | 26 ++++++++++++++
> >  2 files changed, 61 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> > index bb4a638f2e6f..4d0626003c03 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> > @@ -975,6 +975,39 @@ static void test_bpf_sk_storage_delete(void)
> >       bpf_iter_bpf_sk_storage_helpers__destroy(skel);
> >  }
> >
> > +/* The BPF program stores in every socket the tgid of a task owning a handle to
> > + * it. The test verifies that a locally-created socket is tagged with its pid
> > + */
> > +static void test_bpf_sk_storage_get(void)
> > +{
> > +     struct bpf_iter_bpf_sk_storage_helpers *skel;
> > +     int err, map_fd, val = -1;
> > +     int sock_fd = -1;
> > +
> > +     skel = bpf_iter_bpf_sk_storage_helpers__open_and_load();
> > +     if (CHECK(!skel, "bpf_iter_bpf_sk_storage_helpers__open_and_load",
> > +               "skeleton open_and_load failed\n"))
> > +             return;
> > +
> > +     sock_fd = socket(AF_INET6, SOCK_STREAM, 0);
> > +     if (CHECK(sock_fd < 0, "socket", "errno: %d\n", errno))
> > +             goto out;
> > +
> > +     do_dummy_read(skel->progs.fill_socket_owners);
> > +
> > +     map_fd = bpf_map__fd(skel->maps.sk_stg_map);
> > +
> > +     err = bpf_map_lookup_elem(map_fd, &sock_fd, &val);
> > +     CHECK(err || val != getpid(), "bpf_map_lookup_elem",
> > +           "map value wasn't set correctly (expected %d, got %d, err=%d)\n",
> > +           getpid(), val, err);
> > +
> > +     if (sock_fd >= 0)
> > +             close(sock_fd);
> > +out:
> > +     bpf_iter_bpf_sk_storage_helpers__destroy(skel);
> > +}
> > +
> >  static void test_bpf_sk_storage_map(void)
> >  {
> >       DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
> > @@ -1131,6 +1164,8 @@ void test_bpf_iter(void)
> >               test_bpf_sk_storage_map();
> >       if (test__start_subtest("bpf_sk_storage_delete"))
> >               test_bpf_sk_storage_delete();
> > +     if (test__start_subtest("bpf_sk_storage_get"))
> > +             test_bpf_sk_storage_get();
> >       if (test__start_subtest("rdonly-buf-out-of-bound"))
> >               test_rdonly_buf_out_of_bound();
> >       if (test__start_subtest("buf-neg-offset"))
> > diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
> > index 01ff3235e413..7206fd6f09ab 100644
> > --- a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
> > +++ b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
> > @@ -21,3 +21,29 @@ int delete_bpf_sk_storage_map(struct bpf_iter__bpf_sk_storage_map *ctx)
> >
> >       return 0;
> >  }
> > +
> > +SEC("iter/task_file")
> > +int fill_socket_owners(struct bpf_iter__task_file *ctx)
> > +{
> > +     struct task_struct *task = ctx->task;
> > +     struct file *file = ctx->file;
> > +     struct socket *sock;
> > +     int *sock_tgid;
> > +
> > +     if (!task || !file || task->tgid != task->pid)
> > +             return 0;
> > +
> > +     sock = bpf_sock_from_file(file);
> > +     if (!sock)
> > +             return 0;
> > +
> > +     sock_tgid = bpf_sk_storage_get(&sk_stg_map, sock->sk, 0,
> > +                                    BPF_SK_STORAGE_GET_F_CREATE);
> Does it affect all sk(s) in the system?  Can it be limited to
> the sk that the test is testing?

Yeah, one such way would be to set the socket storage on the socket
from userspace and then "search" for the socket in the iterator and
mark it as found in a shared global variable.
