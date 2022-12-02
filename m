Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67C263FFB7
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 06:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbiLBFFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 00:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiLBFFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 00:05:41 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF978CFE42
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 21:05:40 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id z192so4799938yba.0
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 21:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Vhe0TmBmcMpXBlfJ6TPbqd5wC4r2cqoonsCw7lEpw8w=;
        b=SP1VJ/q9/KT7X5Cgea3OTjfkzFzENKi5KluDmlkz0dWtDcTRLPiMYS1k/kldX5gDLC
         NJX9aPJWSG7yOEMvLW0xz7KOoDkmAgeNgglXF+t7hBT89ZL3Mbsv1TcZoN6W5WWg7AFS
         2AS5N9Wb5dpFos2BFs7b8QAnBxqyL6HXJASbIMOrtolVnUzOg4jidbP/v09pk2n1ThVI
         kVUp2RRV9HiBb96RpKGlTKCDdiGNM/BdImF3a1TjfqmPciO4VgZ+u0fGgHMa2jx4uSnD
         9kzioZ/sFe3QHOaYq2y30dfKGbG75cWV/3MhJfayDAsWbtPfzFM2OseY52KmjiniEXPT
         8M+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vhe0TmBmcMpXBlfJ6TPbqd5wC4r2cqoonsCw7lEpw8w=;
        b=qcbCiMQqq/Sb1fSXrNmA/8/c1P6Il/ZtKdxKKexzJe1eqfr8Lq911s3SucKl2/e+PY
         InIkpyhQKHwgY+oowSYdQWTepsfFrPDjPAMCDUXdrSv6MGo1NXvH0uqHRr8W9IHuXvxN
         RdU8AcWMnkwq5Wh1fNNKUtXpT8eSqgCuIFFayA7qlDhAJhJUnMCHGiwhJqH4oJbX6Ehp
         nQ7+oj0ifYcmD2NQbze7V141grDg0E5Qv73y3ACbV8NTL8farfCNkofjXNzJ8Dm21FKV
         977F0ZwQbwtc8FChrqiUmyY7zJFyEVd/kp7ex3hXxjst5uerj3ysZwiYzeCZ+4qrY3ya
         9PIg==
X-Gm-Message-State: ANoB5pmSw7RMHrODavVAu1YE3JTQclF9Pr3J+GERtDz6bwuH2D+8GdJE
        MnWCV++OSJJTKRao6OCV6oafLRYh7ZLVYr1l0diwkw==
X-Google-Smtp-Source: AA0mqf4kHPlsC8WkHLl8Dp2kIV/cYi+4qqMe55OQD2v6YGezKpR75AWPN6HsqPXzmLyLsvvfWndsMFjyOv/Gpomuav0=
X-Received: by 2002:a25:d655:0:b0:6fc:1c96:c9fe with SMTP id
 n82-20020a25d655000000b006fc1c96c9femr5314859ybg.36.1669957539732; Thu, 01
 Dec 2022 21:05:39 -0800 (PST)
MIME-Version: 1.0
References: <20221123173859.473629-1-dima@arista.com> <20221123173859.473629-4-dima@arista.com>
 <CANn89iJEYhTFsF8vqe6enE7d107HfXZvgxN=iLGQj21sx9gwcQ@mail.gmail.com>
In-Reply-To: <CANn89iJEYhTFsF8vqe6enE7d107HfXZvgxN=iLGQj21sx9gwcQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 2 Dec 2022 06:05:28 +0100
Message-ID: <CANn89i+6dKFvBRHNyfSbZ6e+Azjz-x48D1um0qrKVRw0xoUquA@mail.gmail.com>
Subject: Re: [PATCH v6 3/5] net/tcp: Disable TCP-MD5 static key on
 tcp_md5sig_info destruction
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 1, 2022 at 8:38 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Nov 23, 2022 at 6:39 PM Dmitry Safonov <dima@arista.com> wrote:
> >
> > To do that, separate two scenarios:
> > - where it's the first MD5 key on the system, which means that enabling
> >   of the static key may need to sleep;
> > - copying of an existing key from a listening socket to the request
> >   socket upon receiving a signed TCP segment, where static key was
> >   already enabled (when the key was added to the listening socket).
> >
> > Now the life-time of the static branch for TCP-MD5 is until:
> > - last tcp_md5sig_info is destroyed
> > - last socket in time-wait state with MD5 key is closed.
> >
> > Which means that after all sockets with TCP-MD5 keys are gone, the
> > system gets back the performance of disabled md5-key static branch.
> >
> > While at here, provide static_key_fast_inc() helper that does ref
> > counter increment in atomic fashion (without grabbing cpus_read_lock()
> > on CONFIG_JUMP_LABEL=y). This is needed to add a new user for
> > a static_key when the caller controls the lifetime of another user.
> >
> > Signed-off-by: Dmitry Safonov <dima@arista.com>
> > Acked-by: Jakub Kicinski <kuba@kernel.org>
>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Hmm, I missed two kfree_rcu(key) calls, I will send the following fix:

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 7fae586405cfb10011a0674289280bf400dfa8d8..8320d0ecb13ae1e3e259f3c13a4c2797fbd984a5
100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1245,7 +1245,7 @@ int tcp_md5_do_add(struct sock *sk, const union
tcp_md5_addr *addr,

                        md5sig =
rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk));
                        rcu_assign_pointer(tp->md5sig_info, NULL);
-                       kfree_rcu(md5sig);
+                       kfree_rcu(md5sig, rcu);
                        return -EUSERS;
                }
        }
@@ -1271,7 +1271,7 @@ int tcp_md5_key_copy(struct sock *sk, const
union tcp_md5_addr *addr,
                        md5sig =
rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk));
                        net_warn_ratelimited("Too many TCP-MD5 keys in
the system\n");
                        rcu_assign_pointer(tp->md5sig_info, NULL);
-                       kfree_rcu(md5sig);
+                       kfree_rcu(md5sig, rcu);
                        return -EUSERS;
                }
        }
