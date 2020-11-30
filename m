Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AE62C89B3
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 17:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgK3Qi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 11:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgK3Qiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 11:38:55 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FD9C0613D6
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 08:38:15 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id t13so8047480plo.16
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 08:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=UX816yw8DAh1erZp5BAVsdx8QFf8rexiapeSutLKtDU=;
        b=aWSKDPWCTob0IK1uVdpoZExn/2n8CYvY2YxJHGV7pOqCTh4+TONEsVWIUMaAUuguq2
         dcBlye7LYlvaYBk4/yHBfa+BmQE3wZJBjzNhNEWXi4g4v2SMBKRi1T4yrZ2ffvOzi+mr
         7nSJTU4YOQd+6xMVkTn9qrdzxKd6wNWjx7pFSnRt2RsKiw9fTCIr0JeHoguG6ifQfP3P
         jNF7hh97DpSLS4NSF8AKpq0m00ZudomNZgURlpW8rPXmlSrjlQgSKBWlTEeOp6b5QDJ5
         IWM7na3y74brpwholwgkLE8EAM89Z/ns7MxWq3V1W1JO19ULqNDYKVlIpTwHFm7sjdCv
         xNjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UX816yw8DAh1erZp5BAVsdx8QFf8rexiapeSutLKtDU=;
        b=OJv5nJmhJVu7qlB69nh2mFGzNNAISHEOeyyRQmV+Yh6YFp+8l/SfE6Jp7c4/JKesqt
         moYjGJmQl/Lmi35eoBPXps9o58hlV39bnVQZOj8UFr6S3W8p3bfTtaKnOOjPfcZqZhKW
         hsEpr8tN+PN0vBToIBAG1K3yc9Fx737aedOAtOqYnFXAvSBQ2eW4rcPOdxi5985LXi6p
         I4Z/g8gZgIst48ip/fHq5C2hYqk2VwJVX6qhupjlfUzgiM/KNZcAGzKOQxYdLyXUxvYH
         zvk7UsgH90PKWpgzLIeORpE4+9vgVtyY661EUCWSA6FYUOYJZnvc2e9dJjGcptHRXpoj
         FdiA==
X-Gm-Message-State: AOAM533LJpK+zlSfOeg4sdrokO0VyNZR7E+/YuTBkVLbGthtZyxOIbY3
        73byBJIoxBvCi1fgFclF+JUvekE=
X-Google-Smtp-Source: ABdhPJxxRiSiL9TZBSG3e6fLHbVnNFg0unRsc3Mpp53zJ4Q+9PeSkn26dUkTkrBDuAqW0MgjKB3SlLo=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a17:90a:f691:: with SMTP id
 cl17mr27419417pjb.206.1606754294970; Mon, 30 Nov 2020 08:38:14 -0800 (PST)
Date:   Mon, 30 Nov 2020 08:38:13 -0800
In-Reply-To: <20201130010559.GA1991@rdna-mbp>
Message-Id: <20201130163813.GA553169@google.com>
Mime-Version: 1.0
References: <20201118001742.85005-1-sdf@google.com> <20201118001742.85005-3-sdf@google.com>
 <CAADnVQLxt11Zx8553fegoSWCtt0SQ_6uYViMtuhGxA7sv1YSxA@mail.gmail.com> <20201130010559.GA1991@rdna-mbp>
Subject: Re: [PATCH bpf-next 2/3] bpf: allow bpf_{s,g}etsockopt from cgroup
 bind{4,6} hooks
From:   sdf@google.com
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29, Andrey Ignatov wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> [Tue, 2020-11-17 20:05  
> -0800]:
> > On Tue, Nov 17, 2020 at 4:17 PM Stanislav Fomichev <sdf@google.com>  
> wrote:
[..]
> >
> > I think it is ok, but I need to go through the locking paths more.
> > Andrey,
> > please take a look as well.

> Sorry for delay, I was offline for the last two weeks.
No worries, I was OOO myself last week, thanks for the feedback!

>  From the correctness perspective it looks fine to me.

>  From the performance perspective I can think of one relevant scenario.
> Quite common use-case in applications is to use bind(2) not before
> listen(2) but before connect(2) for client sockets so that connection
> can be set up from specific source IP and, optionally, port.

> Binding to both IP and port case is not interesting since it's already
> slow due to get_port().

> But some applications do care about connection setup performance and at
> the same time need to set source IP only (no port). In this case they
> use IP_BIND_ADDRESS_NO_PORT socket option, what makes bind(2) fast
> (we've discussed it with Stanislav earlier in [0]).

> I can imagine some pathological case when an application sets up tons of
> connections with bind(2) before connect(2) for sockets with
> IP_BIND_ADDRESS_NO_PORT enabled (that by itself requires setsockopt(2)
> though, i.e. socket lock/unlock) and that another lock/unlock to run
> bind hook may add some overhead. Though I do not know how critical that
> overhead may be and whether it's worth to benchmark or not (maybe too
> much paranoia).

> [0] https://lore.kernel.org/bpf/20200505182010.GB55644@rdna-mbp/
Even in case of IP_BIND_ADDRESS_NO_PORT, inet[6]_bind() does
lock_sock down the line, so it's not like we are switching
a lockless path to the one with the lock, right?

And in this case, similar to listen, the socket is still uncontended and
owned by the userspace. So that extra lock/unlock should be cheap
enough to be ignored (spin_lock_bh on the warm cache line).

Am I missing something?
