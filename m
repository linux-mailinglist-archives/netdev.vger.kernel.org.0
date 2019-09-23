Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D77EBB820
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 17:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732214AbfIWPiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 11:38:22 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35840 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbfIWPiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 11:38:22 -0400
Received: by mail-pl1-f194.google.com with SMTP id f19so6672385plr.3
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 08:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=M/PMh4r97tv7nGSf4Rke5Y5OiYt7ZTJmWzGerKhb1gY=;
        b=RwY7dq9n7GbzC73yE6fHmE/aQUXzDH2sOFHkeOPM/+YWb//8H6SaSJLL9gxgd4kfFM
         eFApB+kysf61LLta+9m1CIZpG9smzamplACVnREr/gmMH6vaCF9UgAsoEyPwqsK/uZ+A
         79PQ8DckIm3V8I/v1L60KIbl/W2dpRRLMFeBfuHrXXdwzyuN58AjMbVQvhuV0u8rz/nG
         I2PPdR/F4+qCKuDvK4alH7rFOM6liO0cpj8aVudv5mnijQ9SIKHMk5mzVVH3YF/+FuMW
         quspNDLnD3gRj5CyNcDl9ebryddGZo9FyuLBVKqdzAXJ5uBKKS6Pdc2u+sCgsKJLBYgo
         q+4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=M/PMh4r97tv7nGSf4Rke5Y5OiYt7ZTJmWzGerKhb1gY=;
        b=MP9tOJhuPNjFke8qgz6ZJe4yY8y6MG1jEFH2Rl4qm9T/GVQvBjmDKw4XYy0ArZWtxO
         /wWnQ9vr5I7NTU4HC/L3wicXU84zQ7Ik7JIYPH81L3jQ1nuPUgOT2PXZKRhS89C4L3gH
         GwHk3Xg1zcnqulHWJg861lpw/JT2lmrJ7Ic5jz/J1OyHa2EQaQy3AnGboSiy/ksaVqlb
         8QvQSdClhWHKXlenCycxDxvSO42tQFZvxjhZ6XQhL5Xt0oM3WBhwNF7iqOFsC4/ov6mT
         8Vo3CBYxMcjbz6v3xsoUVN+5rCJAXShZQ7sOp4w7E670B6htavRrw2lR2DEGrDsXt0+g
         OlkQ==
X-Gm-Message-State: APjAAAVcHbVYYuTGrUN7ghuiSbryplkkgt7xtjtetVtd9nUhATZXy34m
        nqFcEYrEYSlEKiCDpSdKgHh2yw==
X-Google-Smtp-Source: APXvYqzs9ASBw3DusM2g13xJf9ooEmKRG6t7dzWdPpIv7Y9FcVG6jm8BnPklKFEo8ruXldMBOBVQYQ==
X-Received: by 2002:a17:902:b902:: with SMTP id bf2mr425171plb.56.1569253101493;
        Mon, 23 Sep 2019 08:38:21 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id fa24sm6409690pjb.13.2019.09.23.08.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 08:38:20 -0700 (PDT)
Date:   Mon, 23 Sep 2019 08:38:19 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf] selftests/bpf: test_progs: fix client/server race in
 tcp_rtt
Message-ID: <20190923153819.GA21441@mini-arch>
References: <20190920233019.187498-1-sdf@google.com>
 <CAEf4BzYFQhPKoDG7kq=_B5caL-0Af2duL_Uz5v3oVw=BKQ430w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYFQhPKoDG7kq=_B5caL-0Af2duL_Uz5v3oVw=BKQ430w@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/22, Andrii Nakryiko wrote:
> On Sun, Sep 22, 2019 at 12:10 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > This is the same problem I found earlier in test_sockopt_inherit:
> > there is a race between server thread doing accept() and client
> > thread doing connect(). Let's explicitly synchronize them via
> > pthread conditional variable.
> >
> > Fixes: b55873984dab ("selftests/bpf: test BPF_SOCK_OPS_RTT_CB")
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  tools/testing/selftests/bpf/prog_tests/tcp_rtt.c | 16 +++++++++++++++-
> >  1 file changed, 15 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> > index fdc0b3614a9e..e64058906bcd 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> > @@ -203,6 +203,9 @@ static int start_server(void)
> >         return fd;
> >  }
> >
> > +static pthread_mutex_t server_started_mtx = PTHREAD_MUTEX_INITIALIZER;
> > +static pthread_cond_t server_started = PTHREAD_COND_INITIALIZER;
> > +
> >  static void *server_thread(void *arg)
> >  {
> >         struct sockaddr_storage addr;
> > @@ -215,6 +218,10 @@ static void *server_thread(void *arg)
> >                 return NULL;
> >         }
> >
> > +       pthread_mutex_lock(&server_started_mtx);
> > +       pthread_cond_signal(&server_started);
> > +       pthread_mutex_unlock(&server_started_mtx);
> > +
> >         client_fd = accept(fd, (struct sockaddr *)&addr, &len);
> >         if (CHECK_FAIL(client_fd < 0)) {
> >                 perror("Failed to accept client");
> > @@ -248,7 +255,14 @@ void test_tcp_rtt(void)
> >         if (CHECK_FAIL(server_fd < 0))
> >                 goto close_cgroup_fd;
> >
> > -       pthread_create(&tid, NULL, server_thread, (void *)&server_fd);
> > +       if (CHECK_FAIL(pthread_create(&tid, NULL, server_thread,
> > +                                     (void *)&server_fd)))
> > +               goto close_cgroup_fd;
> > +
> > +       pthread_mutex_lock(&server_started_mtx);
> > +       pthread_cond_wait(&server_started, &server_started_mtx);
> > +       pthread_mutex_unlock(&server_started_mtx);
> 
> 
> If the server fails to listen, then we'll never get a signal, right?
> Let's use timedwait instead to avoid test getting stuck forever in
> such cases?
Good point. How about I do the same thing I do in sockopt_inherit tests:
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c#n73

	err = listen()
	pthread_cond_signal()
	if (CHECK_FAIL(err)) {
		return;
	}

Should fix the problem of getting stuck forever without any timeouts.
I'll send a v2 later today.

> > +
> >         CHECK_FAIL(run_test(cgroup_fd, server_fd));
> >         close(server_fd);
> >  close_cgroup_fd:
> > --
> > 2.23.0.351.gc4317032e6-goog
> >
