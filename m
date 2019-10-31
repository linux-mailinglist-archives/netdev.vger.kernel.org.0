Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F71BEA9BE
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 04:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfJaDqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 23:46:39 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:34210 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbfJaDqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 23:46:39 -0400
Received: by mail-il1-f193.google.com with SMTP id a13so4144493ilp.1
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 20:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bECn23kNz46LjNQHGu0hpk5jfVhF0dRpyW/5v3CVsyg=;
        b=wG7bh3YKBbbpsPsu1TBTEJ0B1VSe9w74sARZ/+NgdqK3hiGWGdfBVi9MDEVZxwYBdx
         eFbcdRJOgci7GYU6Jm8xzipzBKJoPy5AZavO3SH4JrzGZBXaznvrSEhgqVMNESKAdLdY
         f7ZCxZheabPasJ7aDHtrmzi5elQlKXTdewvlmBrWAyrb6DkMNIJPpAwn+ZWVoWJnAog5
         Uo3nnXQgItGuwP4vOuqCj/pqQAb2g5dz3GHohbi6B1BfyVlHHSo0qEA6WLbnKXNJjxL8
         QP6mQ4AP9xo7wzd/xb4I2KBHzx/OrSGf6eRckHlP2AjC6DM5BKLbmJzO3XhMUH/rYa98
         jNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bECn23kNz46LjNQHGu0hpk5jfVhF0dRpyW/5v3CVsyg=;
        b=uN3SSCKJxBsOvi2yLv9kGOwbqAs37CyXyeklXYzoY7aKV54JWLnkW2jIJeEpCti/Vn
         Ev1UJORI+fzqFaXPQzMnynFLVkWKA5B1uyTxegSRmSi4Kv0ENjsI8xNQx8x2nKpTraSZ
         OHMqZxulNetUBMZr1k/QHhZflxJjpUue571ZFC1ngCeP+etHhGbUGGts4NBvtFiM4rc6
         eYLqii7zHqQe6xofwC5PEP+JTEkF9cwI3S9aeRFbyUAzKyNHQdoMnLcJ/frN1aNwjEgx
         RRqtFOdfhYWEde5dl2skz6sQV4hWq3ub0BO5FGVg42+MRG9IXcT7jgHtlDq6h1tUrf17
         zoOw==
X-Gm-Message-State: APjAAAVmE0wQwFlfoYyPoVR4j/FW1kBlUyIQPj4EPSqF5yFE2pXRlle9
        YIeg2LGAGmHs9HnpD+a5hfUB8L6FTZeMP8YfHqprjA==
X-Google-Smtp-Source: APXvYqxwZaghkI56w1HTWeNSbLHo2RZ5MPTuYhoViPlao4bSOANi36FZZ4kDmuN5kfinPbzlIJqHkJqsNIlNfLYeHWU=
X-Received: by 2002:a05:6e02:689:: with SMTP id o9mr4055734ils.168.1572493597547;
 Wed, 30 Oct 2019 20:46:37 -0700 (PDT)
MIME-Version: 1.0
References: <20191030163620.140387-1-edumazet@google.com> <20191031033632.GE29986@1wt.eu>
In-Reply-To: <20191031033632.GE29986@1wt.eu>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 30 Oct 2019 20:46:26 -0700
Message-ID: <CANn89i+8FOTfq328Tv4YvhcTEn9fte6Wm4YizqubcRz=0gyiwQ@mail.gmail.com>
Subject: Re: [PATCH net] net: increase SOMAXCONN to 4096
To:     Willy Tarreau <w@1wt.eu>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Yue Cao <ycao009@ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 8:36 PM Willy Tarreau <w@1wt.eu> wrote:
>
> On Wed, Oct 30, 2019 at 09:36:20AM -0700, Eric Dumazet wrote:
> > SOMAXCONN is /proc/sys/net/core/somaxconn default value.
> >
> > It has been defined as 128 more than 20 years ago.
> >
> > Since it caps the listen() backlog values, the very small value has
> > caused numerous problems over the years, and many people had
> > to raise it on their hosts after beeing hit by problems.
> >
> > Google has been using 1024 for at least 15 years, and we increased
> > this to 4096 after TCP listener rework has been completed, more than
> > 4 years ago. We got no complain of this change breaking any
> > legacy application.
> >
> > Many applications indeed setup a TCP listener with listen(fd, -1);
> > meaning they let the system select the backlog.
> >
> > Raising SOMAXCONN lowers chance of the port being unavailable under
> > even small SYNFLOOD attack, and reduces possibilities of side channel
> > vulnerabilities.
>
> Just a quick question, I remember that when somaxconn is greater than
> tcp_max_syn_backlog, SYN cookies are never emitted, but I think it
> recently changed and there's no such constraint anymore. Do you
> confirm it's no more needed, or should we also increase this latter
> one accordingly ?
>

There is no relationship like that.

The only place somaxconn is use is in __sys_listen() to cap the
user-provided backlog.

somaxconn = sock_net(sock->sk)->core.sysctl_somaxconn;
if ((unsigned int)backlog > somaxconn)
       backlog = somaxconn;

There is a second place in fastopen_queue_tune() but this is not
relevant for this discussion.
