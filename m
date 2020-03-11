Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F3F1823A6
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 22:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729302AbgCKVDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 17:03:01 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:43843 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgCKVDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 17:03:01 -0400
Received: by mail-qv1-f68.google.com with SMTP id c28so1572857qvb.10;
        Wed, 11 Mar 2020 14:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t/D1HizcxL3d98BRAkRQRNugcsYRa+ck1qR5swC+n6o=;
        b=mxV6LXTw8GKgMbagZSV6wHQkalDWq3qSeuObUUCUtyb3AMY5VzOsr4OmkLbEY+4MKb
         EzhVeuyZ6/WtVD+1UO84IvdjTdZxEcUlGhX/mcYaEUmVswzGQfHDHFhwL7ZqTf/7JV+n
         1wS+cefmaa9t/fXB47tlblU09opLP1toyWeHViMOiuqZnovCTQJTTq6/1uWUb2DNsaQu
         /JWDCxuecYM9PKfv8pVJveaCRwf/zF7XDESFfFSSikZxLZWndy7Uawps2/pvjWWHVBM6
         F+7Xy8CVPJCg0jZI57ekH/mssM0zhy28jfMSw3pdTMrK/sbqVzeSrMc84D5DmtAHrzRR
         kA3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t/D1HizcxL3d98BRAkRQRNugcsYRa+ck1qR5swC+n6o=;
        b=ttCFzamfHjNOcByJKpSmyRsHgaCTddozsq3VRh+E2YahP1ACeNF/LwyD8K5fMLtZeF
         XZTPw3BU5mBN8h8hsdWzHPKpc7eEITmBotU/XIgaIFGSBH+J7PA17biJe+hntazU49s1
         risyZ5zRsc3Uc4/kgnyM4L4NFlYtqI7TgaW4GM00bQwgFtqgjaithc6mf8XRVJqZMHnC
         dhmtyojYEmBIHLd+gJmvQ8sg5zTvzzvGdB1ofBaH3AVg5r9CzhKMP9pTfVHqgr8pjZuK
         +DqCAsxBhLwxOtIMETH1vZXNzvp3KTENqUUKpjhK5JfMDDV5ywrjKWYk/Y1Pl+ypp5E9
         N1YA==
X-Gm-Message-State: ANhLgQ3pYjLPHDqgjkG4Q1XY6glTzGzjkyzA7vfIk+QKhGbPlFXgWHcJ
        IpMVp6B+Z+uDoJRUrap0D4xL5RAqB12N6SqipwNKdzoPOt8=
X-Google-Smtp-Source: ADFU+vuDpbFyNsoec8MklDj/XpXxaRPeruP7GgHcDdXdEgw9Q20qcK+1dG3MG3tWd9FD7nuW4D1wVnWudCQP0Gqa/W8=
X-Received: by 2002:a05:6214:11af:: with SMTP id u15mr4464442qvv.247.1583960578921;
 Wed, 11 Mar 2020 14:02:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200127125534.137492-1-jakub@cloudflare.com> <20200127125534.137492-13-jakub@cloudflare.com>
 <CAEf4Bzadh2T43bYbLO0EuKceUKr3SkfXK8Tj_fXFNj8BWtot1Q@mail.gmail.com> <87sgiey8mc.fsf@cloudflare.com>
In-Reply-To: <87sgiey8mc.fsf@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Mar 2020 14:02:47 -0700
Message-ID: <CAEf4BzbSrnwq7ZC1j5YrqdJGO9bhgw=gpBmuTNP1UQFnDKABgA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 12/12] selftests/bpf: Tests for SOCKMAP
 holding listening sockets
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 12:49 PM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Wed, Mar 11, 2020 at 07:48 PM CET, Andrii Nakryiko wrote:
> > On Mon, Jan 27, 2020 at 4:58 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >>
> >> Now that SOCKMAP can store listening sockets, user-space and BPF API is
> >> open to a new set of potential pitfalls. Exercise the map operations (with
> >> extra attention to code paths susceptible to races between map ops and
> >> socket cloning), and BPF helpers that work with SOCKMAP to gain confidence
> >> that all works as expected.
> >>
> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> ---
> >>  .../selftests/bpf/prog_tests/sockmap_listen.c | 1455 +++++++++++++++++
> >>  .../selftests/bpf/progs/test_sockmap_listen.c |   77 +
> >>  2 files changed, 1532 insertions(+)
> >>  create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> >>  create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_listen.c
> >>
> >
> > Hey Jakub!
> >
> > I'm frequently getting spurious failures for sockmap_listen selftest.
> > We also see that in libbpf's Github CI testing as well. Do you mind
> > taking a look? Usually it's the following kinds of error:
> >
> > ./test_progs:connect_accept_thread:733: accept: Resource temporarily unavailable
> > connect_accept_thread:FAIL:733
>
> Hey Andrii,
>
> Sorry about that. Will investigate why this is happening.
>
> Can't say I've seen those. Any additional details about the test
> enviroment would be helpful. Like the kernel build config and qemu
> params (e.g. 1 vCPU vs more).

It happens quite regularly for me, once every few runs locally. You
can take a kernel config we use for Travis CI at [0].

  [0] https://github.com/libbpf/libbpf/blob/master/travis-ci/vmtest/configs/latest.config

>
> I've taken a quick look at Github CI [0] to see if I can find a sample
> failure report and fish out the kernel config & VM setup from the test
> job spec, but didn't succeed. Will dig more later, unless you have a
> link handy?

We are blacklisting sockmap_listen test right now, so you won't find
anything recent on Travis.

>
> Thanks,
> -jkbs
>
> [0] https://travis-ci.org/github/libbpf/libbpf
