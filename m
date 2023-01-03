Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D174C65C39B
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 17:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjACQKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 11:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238141AbjACQKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 11:10:38 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7046B497
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 08:10:36 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id n78so33555438yba.12
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 08:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hURxTtC69iBK1DO81vGVV4QRdR2a5rU+W3mJCLMYlbo=;
        b=k7hwXEkIOUrm4KOtT9sQcWvvEvIXQLiRICl2HCLHWFqRDO9P+b0Ajlo6kTaPTKf1Hb
         hJMI29/uwijzXedb5/2H4Cg0MhNwOVeaPQKJ1tos/VUh+TtVh2CuzBZF8GBir/WpJApu
         ZDQeB5ymgcPpL5f1rguioZNFzHaLIlqvHkqhp1njrxZHvHTiKH6OYPMjuSA4d81aJ4Rh
         EvYXA11K/VLyoTUdOorn5DWfwDtJMm5sRg66sY8WlYk0Oa19mU9+72WP69ZizSk/cPo5
         BTVuDFp4ky4bdVWyVkcoPix23C4ucPoYHCOIJWQ+NG4EGOa3tH2l3GSzqdcghs3gPfom
         kepQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hURxTtC69iBK1DO81vGVV4QRdR2a5rU+W3mJCLMYlbo=;
        b=SO5UFwBqMn7uJ5ZUe5Ka41zxeTKLqmdao7juSuVlz3/4OmK1wItBf3WsZtdupA5T0R
         ISpR7UjNRMjJ/v5PwiZZeMKhzqoSnmtt98wqBOnHmt+OWrk3hAMmf8I3u5kVeG6RBO7O
         BxyKcorgQtJLzW7z1rIPX18gB2KlPPai+1fR+YHkqzD5JdmvDwQ2JB1DxpF4WqNFI5x+
         PuhHRoq87iYD79I5/mJKr3fnNXdNwFAjl3LA70uukeCaAheO2WcsM4piz2CsKYdTA2QP
         vbSkCuVsd2rYTb7BhqNcdj7YtSAAR7qZW2KLWR5Ap3TAbGSuLBHMJo9NK62RdCdKdNdB
         WE/Q==
X-Gm-Message-State: AFqh2kq6NrZnpM15RTWLI27hNzn6d5HqPq0VE71j9QhvRxJ/VMw9is1l
        VSFNL0p7QaEpJKnQNXdPVjpxH2SDlxK9HiKrss4IqA==
X-Google-Smtp-Source: AMrXdXsw3Gb6r6RB9gvWQYKzJk3rUpGgRjs5mMk0Za3DkvdOwFJOafOTi76ypbH5TSIq5RQ0rggeDX73lWZdLFfXDI4=
X-Received: by 2002:a25:4cf:0:b0:757:bf6:9bef with SMTP id 198-20020a2504cf000000b007570bf69befmr2517652ybe.427.1672762235477;
 Tue, 03 Jan 2023 08:10:35 -0800 (PST)
MIME-Version: 1.0
References: <cover.1671194454.git.bcodding@redhat.com> <ceaf7a4b035e78cdbdde4e9a4ab71ba61a5e5457.1671194454.git.bcodding@redhat.com>
 <CANn89iKik8uMO6=ztufPwYdg1qRPsxToz0Nu-uaZWkE63bKSUQ@mail.gmail.com> <Y7RGSbWX0L4EoA8W@debian>
In-Reply-To: <Y7RGSbWX0L4EoA8W@debian>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 3 Jan 2023 17:10:24 +0100
Message-ID: <CANn89iKEP+LZGHh=ud_c0_RCNM2OHRxF0jeg1EkPpNmTnaXLSQ@mail.gmail.com>
Subject: Re: [PATCH net v4 2/3] Treewide: Stop corrupting socket's task_frag
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Benjamin Coddington <bcodding@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        =?UTF-8?Q?Christoph_B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        Josef Bacik <josef@toxicpanda.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Steve French <sfrench@samba.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
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

On Tue, Jan 3, 2023 at 4:14 PM Guillaume Nault <gnault@redhat.com> wrote:
>
> On Tue, Jan 03, 2023 at 03:26:27PM +0100, Eric Dumazet wrote:
> > On Fri, Dec 16, 2022 at 1:45 PM Benjamin Coddington <bcodding@redhat.com> wrote:
> > >
> > > Since moving to memalloc_nofs_save/restore, SUNRPC has stopped setting the
> > > GFP_NOIO flag on sk_allocation which the networking system uses to decide
> > > when it is safe to use current->task_frag.  The results of this are
> > > unexpected corruption in task_frag when SUNRPC is involved in memory
> > > reclaim.
> > >
> > > The corruption can be seen in crashes, but the root cause is often
> > > difficult to ascertain as a crashing machine's stack trace will have no
> > > evidence of being near NFS or SUNRPC code.  I believe this problem to
> > > be much more pervasive than reports to the community may indicate.
> > >
> > > Fix this by having kernel users of sockets that may corrupt task_frag due
> > > to reclaim set sk_use_task_frag = false.  Preemptively correcting this
> > > situation for users that still set sk_allocation allows them to convert to
> > > memalloc_nofs_save/restore without the same unexpected corruptions that are
> > > sure to follow, unlikely to show up in testing, and difficult to bisect.
> > >
> >
> > I am back from PTO.
> >
> > It seems inet_ctl_sock_create() has been forgotten.
> >
> > Without following fix, ICMP messages sent from softirq would corrupt
> > innocent thread task_frag.
>
> I didn't consider setting ->sk_use_task_frag on ICMP sockets as my
> understanding was that only TCP and ip_append_data() could eventually
> call sk_page_frag(). Therefore, I didn't see how ICMP sockets could be
> affected. Did I miss something?

net/ipv4/ping.c

ICMP uses per-cpu sockets (look in icmp_init(), icmp_xmit_lock()...)

icmp_rcv()
  -> icmp_echo()
     -> icmp_reply()
       -> icmp_push_reply()
         -> ip_append_data()
           -> sk_page_frag_refill()


>
> > (I will submit this patch formally a bit later today)
> >
> > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > index ab4a06be489b5d410cec603bf56248d31dbc90dd..6c0ec27899431eb56e2f9d0c3a936b77f44ccaca
> > 100644
> > --- a/net/ipv4/af_inet.c
> > +++ b/net/ipv4/af_inet.c
> > @@ -1665,6 +1665,7 @@ int inet_ctl_sock_create(struct sock **sk,
> > unsigned short family,
> >         if (rc == 0) {
> >                 *sk = sock->sk;
> >                 (*sk)->sk_allocation = GFP_ATOMIC;
> > +               (*sk)->sk_use_task_frag = false;
> >                 /*
> >                  * Unhash it so that IP input processing does not even see it,
> >                  * we do not wish this socket to see incoming packets.
> >
>
