Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC0C6E2600
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjDNOmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 10:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDNOmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 10:42:42 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E1972BE
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:42:31 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-54fc337a650so96859637b3.4
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dneg.com; s=google; t=1681483350; x=1684075350;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MyWqJg+TEEMkoUyXIV4qRUXghOyIcc1b77Z/puaO8vo=;
        b=gwacbKk8ZhAw/+4XWDKbLBigHaYvNUIUpTATkPqb5TsgWk47p0IlMhF4habn6ly3q+
         EdOhisafu607FxcK5j2P0BL2S3WpgHAnunYhQ9TrdVySAU3dfKWPIdodlP5wIoBps+63
         M5XRXeJyDChxoxs0c08zhUhL/pvQ1jSyM/zKVZuXaz0M0d+udQofR3M9RNbHfFfXM/38
         QcgOmDq0hgYAomtXXd+kxVXsJ98oSqM8IJs7kZmovc1mw6nh6GF6Lw9H5eg1uxtSQCVq
         N1Qio8FeCOrT0UrnDo3JrjCNf/pgm9l7tSjCgTVG5sysEzOTNi4SJUGx4a9fL/bZ6aln
         Sp9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681483350; x=1684075350;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MyWqJg+TEEMkoUyXIV4qRUXghOyIcc1b77Z/puaO8vo=;
        b=MtYGZEHUWTXC48PmmYAyKwWNNXGhx5K/ZU9Pmv1gQs29GM1Xo7fsinlv+FnsPNhqsJ
         WL9jHe1z3Ii3c5O6q/bT1VL9/AZRSTO/977UB2rRaWVYt2Hs/TVfcJa0IlFj+WZNrQdW
         oNTgVLYZFUn9Gv0+mLlrQy0zsLX0E16ulR3bwOeA5YSvyJ459cU0C3SAMeoyiqxk7nW1
         eU4yGZNCIgPdAD0ujtX47BiehX4WrKzKPHkJ1k6Q31M/4RyNx67laMbQaUKEIK7AFIi8
         /K0LkjsMAIc6+2ihCgtIORa4bZ6hiUIFStzOp1Th/yqKkVhnp3eoQP3hYO6tM0GSBloG
         OV7Q==
X-Gm-Message-State: AAQBX9eQMpglvc+gEj+AICtueuTmtkHlKYUxUeZRRIOyg9xpa80UjHKI
        2PPNEn2M9nT6Spzf709q8Z/2o4eHx42oIyq9wy7wjg==
X-Google-Smtp-Source: AKy350ZSIgWGAXJ/jDcFVW6ZtIlOPzVRFSQW/9QwuupeF38JoI4hw3A4zo92XzTsE4M00u8OgP/Ymg6nq18qvR4uLY8=
X-Received: by 2002:a81:ae12:0:b0:545:8202:bbcf with SMTP id
 m18-20020a81ae12000000b005458202bbcfmr3804319ywh.9.1681483350245; Fri, 14 Apr
 2023 07:42:30 -0700 (PDT)
MIME-Version: 1.0
References: <3A132FA8-A764-416E-9753-08E368D6877A@oracle.com>
 <812034.1680181285@warthog.procyon.org.uk> <6F2985FF-2474-4F36-BD94-5F8E97E46AC2@oracle.com>
 <20230329141354.516864-1-dhowells@redhat.com> <20230329141354.516864-41-dhowells@redhat.com>
 <812755.1680182190@warthog.procyon.org.uk> <822317.1680186419@warthog.procyon.org.uk>
 <A03755D2-3EEB-4A21-9302-6F03316F2709@oracle.com>
In-Reply-To: <A03755D2-3EEB-4A21-9302-6F03316F2709@oracle.com>
From:   Daire Byrne <daire@dneg.com>
Date:   Fri, 14 Apr 2023 15:41:53 +0100
Message-ID: <CAPt2mGOR6y+m1PNKLSjnaiDGBrDypvSb2ciChn+PMY7+it7-2w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 40/48] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather
 then sendpage
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     David Howells <dhowells@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I gave this a spin because I had noticed a previous regression around
the 5.7 time frame in sendpage/sendmsg code changes:

https://bugzilla.kernel.org/show_bug.cgi?id=209439

In that case there was a noticeable regression in performance for high
performance servers (100gbit).

I see no such performance problems with David's iov-sendpage branch
and it all looks good to me with simple benchmarks (100gbit server,
100 x 1gbit clients reading data).

Tested-by: Daire Byrne <daire@dneg.com>

Cheers,

Daire

On Thu, 30 Mar 2023 at 17:37, Chuck Lever III <chuck.lever@oracle.com> wrote:
>
>
>
> > On Mar 30, 2023, at 10:26 AM, David Howells <dhowells@redhat.com> wrote:
> >
> > Chuck Lever III <chuck.lever@oracle.com> wrote:
> >
> >> Don't. Just change svc_tcp_send_kvec() to use sock_sendmsg, and
> >> leave the marker alone for now, please.
> >
> > If you insist.  See attached.
>
> Very good, thank you for accommodating my regression paranoia.
>
> Acked-by: Chuck Lever <chuck.lever@oracle.com>
>
>
> >
> > David
> > ---
> > sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
> >
> > When transmitting data, call down into TCP using sendmsg with
> > MSG_SPLICE_PAGES to indicate that content should be spliced rather than
> > performing sendpage calls to transmit header, data pages and trailer.
> >
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > cc: Trond Myklebust <trond.myklebust@hammerspace.com>
> > cc: Anna Schumaker <anna@kernel.org>
> > cc: Chuck Lever <chuck.lever@oracle.com>
> > cc: Jeff Layton <jlayton@kernel.org>
> > cc: "David S. Miller" <davem@davemloft.net>
> > cc: Eric Dumazet <edumazet@google.com>
> > cc: Jakub Kicinski <kuba@kernel.org>
> > cc: Paolo Abeni <pabeni@redhat.com>
> > cc: Jens Axboe <axboe@kernel.dk>
> > cc: Matthew Wilcox <willy@infradead.org>
> > cc: linux-nfs@vger.kernel.org
> > cc: netdev@vger.kernel.org
> > ---
> > include/linux/sunrpc/svc.h |   11 +++++------
> > net/sunrpc/svcsock.c       |   40 +++++++++++++---------------------------
> > 2 files changed, 18 insertions(+), 33 deletions(-)
> >
> > diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
> > index 877891536c2f..456ae554aa11 100644
> > --- a/include/linux/sunrpc/svc.h
> > +++ b/include/linux/sunrpc/svc.h
> > @@ -161,16 +161,15 @@ static inline bool svc_put_not_last(struct svc_serv *serv)
> > extern u32 svc_max_payload(const struct svc_rqst *rqstp);
> >
> > /*
> > - * RPC Requsts and replies are stored in one or more pages.
> > + * RPC Requests and replies are stored in one or more pages.
> >  * We maintain an array of pages for each server thread.
> >  * Requests are copied into these pages as they arrive.  Remaining
> >  * pages are available to write the reply into.
> >  *
> > - * Pages are sent using ->sendpage so each server thread needs to
> > - * allocate more to replace those used in sending.  To help keep track
> > - * of these pages we have a receive list where all pages initialy live,
> > - * and a send list where pages are moved to when there are to be part
> > - * of a reply.
> > + * Pages are sent using ->sendmsg with MSG_SPLICE_PAGES so each server thread
> > + * needs to allocate more to replace those used in sending.  To help keep track
> > + * of these pages we have a receive list where all pages initialy live, and a
> > + * send list where pages are moved to when there are to be part of a reply.
> >  *
> >  * We use xdr_buf for holding responses as it fits well with NFS
> >  * read responses (that have a header, and some data pages, and possibly
> > diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> > index 03a4f5615086..af146e053dfc 100644
> > --- a/net/sunrpc/svcsock.c
> > +++ b/net/sunrpc/svcsock.c
> > @@ -1059,17 +1059,18 @@ static int svc_tcp_recvfrom(struct svc_rqst *rqstp)
> >       svc_xprt_received(rqstp->rq_xprt);
> >       return 0;       /* record not complete */
> > }
> > -
> > +
> > static int svc_tcp_send_kvec(struct socket *sock, const struct kvec *vec,
> >                             int flags)
> > {
> > -     return kernel_sendpage(sock, virt_to_page(vec->iov_base),
> > -                            offset_in_page(vec->iov_base),
> > -                            vec->iov_len, flags);
> > +     struct msghdr msg = { .msg_flags = MSG_SPLICE_PAGES | flags, };
> > +
> > +     iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, vec, 1, vec->iov_len);
> > +     return sock_sendmsg(sock, &msg);
> > }
> >
> > /*
> > - * kernel_sendpage() is used exclusively to reduce the number of
> > + * MSG_SPLICE_PAGES is used exclusively to reduce the number of
> >  * copy operations in this path. Therefore the caller must ensure
> >  * that the pages backing @xdr are unchanging.
> >  *
> > @@ -1109,28 +1110,13 @@ static int svc_tcp_sendmsg(struct socket *sock, struct xdr_buf *xdr,
> >       if (ret != head->iov_len)
> >               goto out;
> >
> > -     if (xdr->page_len) {
> > -             unsigned int offset, len, remaining;
> > -             struct bio_vec *bvec;
> > -
> > -             bvec = xdr->bvec + (xdr->page_base >> PAGE_SHIFT);
> > -             offset = offset_in_page(xdr->page_base);
> > -             remaining = xdr->page_len;
> > -             while (remaining > 0) {
> > -                     len = min(remaining, bvec->bv_len - offset);
> > -                     ret = kernel_sendpage(sock, bvec->bv_page,
> > -                                           bvec->bv_offset + offset,
> > -                                           len, 0);
> > -                     if (ret < 0)
> > -                             return ret;
> > -                     *sentp += ret;
> > -                     if (ret != len)
> > -                             goto out;
> > -                     remaining -= len;
> > -                     offset = 0;
> > -                     bvec++;
> > -             }
> > -     }
> > +     msg.msg_flags = MSG_SPLICE_PAGES;
> > +     iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, xdr->bvec,
> > +                   xdr_buf_pagecount(xdr), xdr->page_len);
> > +     ret = sock_sendmsg(sock, &msg);
> > +     if (ret < 0)
> > +             return ret;
> > +     *sentp += ret;
> >
> >       if (tail->iov_len) {
> >               ret = svc_tcp_send_kvec(sock, tail, 0);
> >
>
> --
> Chuck Lever
>
>
