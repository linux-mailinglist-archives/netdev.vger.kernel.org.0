Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66EBC5185DA
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 15:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236462AbiECNtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 09:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbiECNtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 09:49:19 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC501165AD
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 06:45:45 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id r11so8264882ybg.6
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 06:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g1pU5XI6ljn+7UJoKbM3rS+gYEntC9K9xEfeaVv0hHY=;
        b=itRY4PSZQZEtMhK3UggR+gtKNEgiWeV4zElcf2qYwF2LAHJzpFo2KaaVt1aACJM92e
         VQ5gYJ8bF6MW6mMUIwHJ+pLGjkhT+veWpvGLovwfVLtG0BSoZ3zGxuAOAz4rGB4B8g+X
         XGumnrMXN6ireNNroaHZzYrS4My+eVCz4xpIgszWasdrQgmmSZ0q95X1aJy2WPB183HC
         2thVkHvsk8LWDKCPq0k62XofdYoNxPgaI8vrD5EcphVKnRVQt40yXWR/cFxnHj9LFgOI
         aVASJG+OUCpHN6m+LnL8IoJ3Yoq6C+Joh/onVo2GsI/EZrKEO/qvHzNIGvxcbRnhvFWK
         7hpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g1pU5XI6ljn+7UJoKbM3rS+gYEntC9K9xEfeaVv0hHY=;
        b=FV+30LZ62vLQlkrexjJOQvVyfZ/bEDY2T50OffZ8pdwhye1h0pGkwAfHgK4FNTCNra
         uQcoRSR5F3pCCqiZXbOfR7zCngJRLLCwZiyt2K3MGYNeGmeRzHrcwquHXgCSM/xQZV1i
         3ELXXh3+ycr9ACPdygA8P7Vl3DwMX59k1s/TP6yLShtYBHfjCZEnsvDYi1cGbjacMICp
         2ILpcAmyLvcg6ccL0P888S4LzgmgthTc63uGpZkE5s5bkoaZUDOa87VMe7+uoEXpn6/a
         dOzDIOXu2rOph+V/B6sfXHwNqDxLKUxfjuuyyTVpvIiRKKE1hKEvgjy0PfSdUZpfxlcw
         w67g==
X-Gm-Message-State: AOAM533cJmjZSdCsoCFp38wMH5fJZmstKkPUDn7vyuuUPZTew3ePMfJT
        t5P39g7Z6Njb+S8P7BoXnYo16lYxnRxD1vNgGZTdrw==
X-Google-Smtp-Source: ABdhPJx3eWh0jJqJT+d0YzradfinfQxNdPwhkhHj7yULlZrdGRESZEz5iu3aXozlUUIF3GRE66s+EBtNoRMmHwA1Uck=
X-Received: by 2002:a25:6157:0:b0:645:8d0e:f782 with SMTP id
 v84-20020a256157000000b006458d0ef782mr14803876ybb.36.1651585544858; Tue, 03
 May 2022 06:45:44 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000045dc96059f4d7b02@google.com> <000000000000f75af905d3ba0716@google.com>
 <c389e47f-8f82-fd62-8c1d-d9481d2f71ff@I-love.SAKURA.ne.jp>
 <b0f99499-fb6a-b9ec-7bd3-f535f11a885d@I-love.SAKURA.ne.jp>
 <5f90c2b8-283e-6ca5-65f9-3ea96df00984@I-love.SAKURA.ne.jp>
 <f8ae5dcd-a5ed-2d8b-dd7a-08385e9c3675@I-love.SAKURA.ne.jp>
 <CANn89iJukWcN9-fwk4HEH-StAjnTVJ34UiMsrN=mdRbwVpo8AA@mail.gmail.com>
 <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp> <3b6bc24c8cd3f896dcd480ff75715a2bf9b2db06.camel@redhat.com>
In-Reply-To: <3b6bc24c8cd3f896dcd480ff75715a2bf9b2db06.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 3 May 2022 06:45:33 -0700
Message-ID: <CANn89iK5WmzyPNyUzuoDyDZQWpbBaffEXxEvmOhz5wJ+9facFg@mail.gmail.com>
Subject: Re: [PATCH v2] net: rds: acquire refcount on TCP sockets
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 3, 2022 at 2:02 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Mon, 2022-05-02 at 10:40 +0900, Tetsuo Handa wrote:
> > syzbot is reporting use-after-free read in tcp_retransmit_timer() [1],
> > for TCP socket used by RDS is accessing sock_net() without acquiring a
> > refcount on net namespace. Since TCP's retransmission can happen after
> > a process which created net namespace terminated, we need to explicitly
> > acquire a refcount.
> >
> > Link: https://syzkaller.appspot.com/bug?extid=694120e1002c117747ed [1]
> > Reported-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
> > Fixes: 26abe14379f8e2fa ("net: Modify sk_alloc to not reference count the netns of kernel sockets.")
> > Fixes: 8a68173691f03661 ("net: sk_clone_lock() should only do get_net() if the parent is not a kernel socket")
> > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Tested-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
> > ---
> > Changes in v2:
> >   Add Fixes: tag.
> >   Move to inside lock_sock() section.
> >
> > I chose 26abe14379f8e2fa and 8a68173691f03661 which went to 4.2 for Fixes: tag,
> > for refcount was implicitly taken when 70041088e3b97662 ("RDS: Add TCP transport
> > to RDS") was added to 2.6.32.
> >
> >  net/rds/tcp.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/net/rds/tcp.c b/net/rds/tcp.c
> > index 5327d130c4b5..2f638f8b7b1e 100644
> > --- a/net/rds/tcp.c
> > +++ b/net/rds/tcp.c
> > @@ -495,6 +495,14 @@ void rds_tcp_tune(struct socket *sock)
> >
> >       tcp_sock_set_nodelay(sock->sk);
> >       lock_sock(sk);
> > +     /* TCP timer functions might access net namespace even after
> > +      * a process which created this net namespace terminated.
> > +      */
> > +     if (!sk->sk_net_refcnt) {
> > +             sk->sk_net_refcnt = 1;
> > +             get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
> > +             sock_inuse_add(net, 1);
> > +     }
> >       if (rtn->sndbuf_size > 0) {
> >               sk->sk_sndbuf = rtn->sndbuf_size;
> >               sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
>
> This looks equivalent to the fix presented here:
>
> https://lore.kernel.org/all/CANn89i+484ffqb93aQm1N-tjxxvb3WDKX0EbD7318RwRgsatjw@mail.gmail.com/

I think this is still needed for layers (NFS ?) that dismantle their
TCP sockets whenever a netns
is dismantled. But RDS case was different, only the listener is a kernel socket.

>
> but the latter looks a more generic solution. @Tetsuo could you please
> test the above in your setup?
>
> Thanks!
>
> Paolo
>
