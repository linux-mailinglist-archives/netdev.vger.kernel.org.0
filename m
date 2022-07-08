Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E77756BFD5
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239093AbiGHRv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 13:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238866AbiGHRv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 13:51:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE65D1EC79
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 10:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657302714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6KWJmt/L63aILYBkGN/cLQbCz5oWuh1LBplmugt4zus=;
        b=Pc/GeamUFjD0WTZseHuuviw5cvpUoPMQs0C6iJZ2VG5yIEBcBD4sxBRRVz3/QmsCzBZ8fE
        GCdW40pb9G19NVcyPO8ka6c5wiZsQrtzrICdQ74tWCrzSZ2YC5FzvqjeAGJxk6jlmzQ/3Y
        CagoWga2D/+oOAtoN0b3IncioFQNXDg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-VL0BNkleP0O6iKUxkCAPvg-1; Fri, 08 Jul 2022 13:51:53 -0400
X-MC-Unique: VL0BNkleP0O6iKUxkCAPvg-1
Received: by mail-wm1-f72.google.com with SMTP id 83-20020a1c0256000000b003a2d01897e4so2085808wmc.9
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 10:51:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6KWJmt/L63aILYBkGN/cLQbCz5oWuh1LBplmugt4zus=;
        b=SYsn41jb7Fxf7288yRzXGYBc4H7gLwcEIGXPb37y4yU/CNBueJ5OUBZUWeK2fcFR0A
         Kc1gXHVVY9aB3asU9lWXwVsyJAVIoEfiyGw18dP9PJLJEeKoqKvb1JAcGhy5HdKQcdhi
         GJo7gcIcG9vIJZDgzi9+42SGAeEipTlykCwCevQri9KAdqhaJ5BlhgUxvKE+zEEG0FAG
         K9T53H/ZJ3SlYz8eWkh0XGTMvaf5aW8Y3hSnOT4rr83FZ1wurT5QzHJ8UQmFKEuDu/JL
         dL5SCRoKre6jg/cm0blzNH764Eajp1FD5Ei+PNA714LpDQrjLTG3NwIxifHyEO77uuBp
         X+3w==
X-Gm-Message-State: AJIora+zD2EP1X6bDCZfVDLHZ4M95qd1vuUK/zXmmuvCt3QDpa3En7uO
        L/+28bh/9NZmfFQdc1ZLUOh9j/PIgNUQjj6WW0/hkxt2njJJ0T7rvrvg9qOrobuVH3bV/2gzV6D
        qvpe0SGbRcEmv7Soz
X-Received: by 2002:a05:600c:203:b0:3a1:9726:ad85 with SMTP id 3-20020a05600c020300b003a19726ad85mr1033789wmi.180.1657302710271;
        Fri, 08 Jul 2022 10:51:50 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vygzE/ZixvWHoFK0HUui2DyxYSR4HG4MzT42rbFaAG7lKpfqcAkoe8oZPX7jYC0NhtocLlTQ==
X-Received: by 2002:a05:600c:203:b0:3a1:9726:ad85 with SMTP id 3-20020a05600c020300b003a19726ad85mr1033770wmi.180.1657302710064;
        Fri, 08 Jul 2022 10:51:50 -0700 (PDT)
Received: from debian.home (2a01cb058d1194004161f17a6a9ad508.ipv6.abo.wanadoo.fr. [2a01:cb05:8d11:9400:4161:f17a:6a9a:d508])
        by smtp.gmail.com with ESMTPSA id p8-20020a056000018800b0021d7f032022sm7155441wrx.17.2022.07.08.10.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 10:51:49 -0700 (PDT)
Date:   Fri, 8 Jul 2022 19:51:47 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Steve French <sfrench@samba.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Scott Mayhew <smayhew@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC net] Should sk_page_frag() also look at the current GFP
 context?
Message-ID: <20220708175147.GA3166@debian.home>
References: <b4d8cb09c913d3e34f853736f3f5628abfd7f4b6.1656699567.git.gnault@redhat.com>
 <CANn89i+=GyHjkrHMZAftB-toEhi9GcAQom1_bpT+S0qMvCz0DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+=GyHjkrHMZAftB-toEhi9GcAQom1_bpT+S0qMvCz0DQ@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 06:29:03PM +0200, Eric Dumazet wrote:
> On Fri, Jul 1, 2022 at 8:41 PM Guillaume Nault <gnault@redhat.com> wrote:
> >
> > I'm investigating a kernel oops that looks similar to
> > 20eb4f29b602 ("net: fix sk_page_frag() recursion from memory reclaim")
> > and dacb5d8875cc ("tcp: fix page frag corruption on page fault").
> >
> > This time the problem happens on an NFS client, while the previous bzs
> > respectively used NBD and CIFS. While NBD and CIFS clear __GFP_FS in
> > their socket's ->sk_allocation field (using GFP_NOIO or GFP_NOFS), NFS
> > leaves sk_allocation to its default value since commit a1231fda7e94
> > ("SUNRPC: Set memalloc_nofs_save() on all rpciod/xprtiod jobs").
> >
> > To recap the original problems, in commit 20eb4f29b602 and dacb5d8875cc,
> > memory reclaim happened while executing tcp_sendmsg_locked(). The code
> > path entered tcp_sendmsg_locked() recursively as pages to be reclaimed
> > were backed by files on the network. The problem was that both the
> > outer and the inner tcp_sendmsg_locked() calls used current->task_frag,
> > thus leaving it in an inconsistent state. The fix was to use the
> > socket's ->sk_frag instead for the file system socket, so that the
> > inner and outer calls wouln't step on each other's toes.
> >
> > But now that NFS doesn't modify ->sk_allocation anymore, sk_page_frag()
> > sees sunrpc sockets as plain TCP ones and returns ->task_frag in the
> > inner tcp_sendmsg_locked() call.
> >
> > Also it looks like the trend is to avoid GFS_NOFS and GFP_NOIO and use
> > memalloc_no{fs,io}_save() instead. So maybe other network file systems
> > will also stop setting ->sk_allocation in the future and we should
> > teach sk_page_frag() to look at the current GFP flags. Or should we
> > stick to ->sk_allocation and make NFS drop __GFP_FS again?
> >
> > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> 
> Can you provide a Fixes: tag ?

Fixes: a1231fda7e94 ("SUNRPC: Set memalloc_nofs_save() on all rpciod/xprtiod jobs")

> > ---
> >  include/net/sock.h | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index 72ca97ccb460..b934c9851058 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -46,6 +46,7 @@
> >  #include <linux/netdevice.h>
> >  #include <linux/skbuff.h>      /* struct sk_buff */
> >  #include <linux/mm.h>
> > +#include <linux/sched/mm.h>
> >  #include <linux/security.h>
> >  #include <linux/slab.h>
> >  #include <linux/uaccess.h>
> > @@ -2503,14 +2504,17 @@ static inline void sk_stream_moderate_sndbuf(struct sock *sk)
> >   * socket operations and end up recursing into sk_page_frag()
> >   * while it's already in use: explicitly avoid task page_frag
> >   * usage if the caller is potentially doing any of them.
> > - * This assumes that page fault handlers use the GFP_NOFS flags.
> > + * This assumes that page fault handlers use the GFP_NOFS flags
> > + * or run under memalloc_nofs_save() protection.
> >   *
> >   * Return: a per task page_frag if context allows that,
> >   * otherwise a per socket one.
> >   */
> >  static inline struct page_frag *sk_page_frag(struct sock *sk)
> >  {
> > -       if ((sk->sk_allocation & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC | __GFP_FS)) ==
> > +       gfp_t gfp_mask = current_gfp_context(sk->sk_allocation);
> 
> This is slowing down TCP sendmsg() fast path, reading current->flags,
> possibly cold value.
> 
> I would suggest using one bit in sk, close to sk->sk_allocation to
> make the decision,
> instead of testing sk->sk_allocation for various flags.

current_gfp_context() looked quite elegant to me as it avoided the need
to duplicate the NOFS/NOIO flag in the socket. But I understand the
performance concern.

> Not sure if we have available holes.

Nothing in the same cache line at least. There's a 1 bit hole in
struct sock_common after skc_net_refcnt. And it should be hot because
of sk->sk_state. We could add a "skc_use_task_frag" bit there, but I'm
not sure if it's worth using this last available bit for this.

Otherwise, the next available hole is right after sk_bind_phc.
According to pahole, it's two cache lines away from sk_allocation on my
x86_64 build, but that will depend of the size of spinlock_t and thus
on CONFIG_ options. It doesn't look very natural to add a no-reclaim
bit there.

Or maybe we could base the test on sk_kern_sock since the problem
happens on kernel sockets. But that looks like a hack to me, and it
might impact MPTCP, which also creates kernel TCP sockets but shouldn't
have the same constraints as NFS.

> > +
> > +       if ((gfp_mask & ( | __GFP_MEMALLOC | __GFP_FS)) ==
> >             (__GFP_DIRECT_RECLAIM | __GFP_FS))
> >                 return &current->task_frag;
> >
> > --
> > 2.21.3
> >
> 

