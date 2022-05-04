Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B675195BB
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 05:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344156AbiEDDNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 23:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234553AbiEDDNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 23:13:23 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BF121822
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 20:09:49 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id s30so312806ybi.8
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 20:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/X8Hjb4daos1PdFlsd6ZENb/G2iOid1kzGm39p/9gOA=;
        b=fnmqkW173nVSF4MTU+RDbcmQ8UyBKGZMVNYWF2rE2oZZ35UVFmOjlPx8J8kDMJ8DCQ
         mc/gOFi2wMIVj7+9X3L+FoG2ydo6Q6VxdFHX29btWfZzUM1250azZImUqDGAF+SIevHb
         W7XDEpkcGuDAjcMhsSPnjhymBOEkcmoUkRixvMK22jeKvck8CP+yS9q5siYJ5CQAmQ3d
         fd4rxI676hJ4rwiUQg2ZnJEdGzrWTN06yFx4Lk+N5w5jaTnof95+MqcSa+0mzIywnIWL
         EHNb0Pf0vB9+gPs8QEiaOvJA5QCiON8br18qQqXxgHTg0inFThDYnk3Y/eL6Y7MKKXnm
         ebdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/X8Hjb4daos1PdFlsd6ZENb/G2iOid1kzGm39p/9gOA=;
        b=hYEQlRhDdOmS3fBcL8GJ2IDtPn7WGXNyH1f4irc9VBvV6kIZqR+eBiHjDOKY+zM6a3
         YQ7HhfeDxsI8qDwyyosEB0jPTnSE7Qn/vlkIv0+RYI62xZfY5Tr/Que8Oa6DYju2XNKx
         /s9SiPogT0cY1GhYK4V9/sINetlVagy2OkHM6ImMaYNC+6X/FlQgcmAVnp5aOn9nxnf4
         DAXOjzyxs5ITicX8Dgif+J3NnZQP58CdxaYRouFVB34joF0fym04oMOI8VeiOacXyT/F
         JgLXb55+T1Bc3yxdl4P7HlUXxHzX9OfDm/skiYv8pK9dXNqRL7NQ5sRH98mCS2z5l/bI
         iReA==
X-Gm-Message-State: AOAM532Os0DnwYt3FWawd3QGQAah/FGY12SxvsUuVSyN06i9I0c6CE8V
        tr4EIJR6DInhcFv1WL2fq7s0wTUjqrOUpijZMk/E5Q==
X-Google-Smtp-Source: ABdhPJxHf8K38kpIjSTjz6rZPweIGtRfZ2eWSi9c2C2wsx5oalodieYktnKy1AvOtJt9qTAnxlOfif3QDFHepZ9CA/s=
X-Received: by 2002:a25:ba50:0:b0:649:b5b2:6fca with SMTP id
 z16-20020a25ba50000000b00649b5b26fcamr6986833ybj.55.1651633788016; Tue, 03
 May 2022 20:09:48 -0700 (PDT)
MIME-Version: 1.0
References: <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
 <165157801106.17866.6764782659491020080.git-patchwork-notify@kernel.org>
 <CANn89iLHihonbBUQWkd0mjJPUuYBLMVoLCsRswtXmGjU3NKL5w@mail.gmail.com>
 <CANn89iJ=LF0KhRXDiFcky7mqpVaiHdbc6RDacAdzseS=iwjr4Q@mail.gmail.com> <f6f9f21d-7cdd-682f-f958-5951aa180ec7@I-love.SAKURA.ne.jp>
In-Reply-To: <f6f9f21d-7cdd-682f-f958-5951aa180ec7@I-love.SAKURA.ne.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 3 May 2022 20:09:36 -0700
Message-ID: <CANn89iJOt9oC_sSmVhRx8fyyvJ2hWzYKcTfH1Rvbzpt5aP0qNA@mail.gmail.com>
Subject: Re: [PATCH v2] net: rds: acquire refcount on TCP sockets
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-rdma <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 3, 2022 at 6:04 PM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> On 2022/05/04 7:37, Eric Dumazet wrote:
> >> I think we merged this patch too soon.
> >>
> >> My question is : What prevents rds_tcp_conn_path_connect(), and thus
> >> rds_tcp_tune() to be called
> >> after the netns refcount already reached 0 ?
> >>
> >> I guess we can wait for next syzbot report, but I think that get_net()
> >> should be replaced
> >> by maybe_get_net()
> >
> > Yes, syzbot was fast to trigger this exact issue:
>
> Does maybe_get_net() help?
>
> Since rds_conn_net() returns a net namespace without holding a ref, it is theoretically
> possible that the net namespace returned by rds_conn_net() is already kmem_cache_free()d
> if refcount dropped to 0 by the moment sk_alloc() calls sock_net_set().

Nope. RDS has an exit() handler called from cleanup_net()

(struct pernet_operations)->exit() or exit_batch() :
rds_tcp_exit_net() (rds_tcp_kill_sock())

This exit() handler _has_ to remove all known listeners, and
definitely cancel work queues (synchronous operation)
before the actual "struct net" free can happen later.



>
> rds_tcp_conn_path_connect() {
>   sock_create_kern(net = rds_conn_net(conn)) {
>     __sock_create(net = rds_conn_net(conn), kern = 1) {
>       err = pf->create(net = rds_conn_net(conn), kern = 1) {
>         // pf->create is either inet_create or inet6_create
>         sk_alloc(net = rds_conn_net(conn), kern = 1) {
>           sk->sk_net_refcnt = kern ? 0 : 1;
>           if (likely(sk->sk_net_refcnt)) {
>             get_net_track(net, &sk->ns_tracker, priority);
>             sock_inuse_add(net, 1);
>           }
>           sock_net_set(sk, net);
>         }
>       }
>     }
>   }
>   rds_tcp_tune() {
>     if (!sk->sk_net_refcnt) {
>       sk->sk_net_refcnt = 1;
>       get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
>       sock_inuse_add(net, 1);
>     }
>   }
> }
>
> "struct rds_connection" needs to hold a ref in order to safely allow
> rds_tcp_tune() to call maybe_get_net(), which in turn makes pointless
> to use maybe_get_net() from rds_tcp_tune() because "struct rds_connection"
> must have a ref. Situation where we are protected by maybe_get_net() is
> quite limited if long-lived object is not holding a ref.
>
> Hmm, can we simply use &init_net instead of rds_conn_net(conn) ?

Only if you plan making RDS unavailable for non init netns.
