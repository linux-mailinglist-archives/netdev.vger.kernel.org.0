Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEB265C9B8
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 23:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbjACWih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 17:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjACWif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 17:38:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2662AB82
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 14:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672785468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O7q9NLRqHpcz+PgkDLSNPwabJ77PBKh9UnqB8G+IY+M=;
        b=XuWCkFrQMA5/8cS6hjrFgV/U4qSKtk5bTxCBvSNClQmLhSd+u9i6aChpp1AMuM/+J/RbXR
        XU4rXXu5UgcK5CYmF+MbE26P7eTm58u72+r50Xhg36JGwg0tzWNEJdcltOcib+7S8XpQ8J
        tKJw8EpSBNfENV4eHXLnalGwcYVJt1I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-106-6C67rRONPRW9m41rx2R0NQ-1; Tue, 03 Jan 2023 17:37:47 -0500
X-MC-Unique: 6C67rRONPRW9m41rx2R0NQ-1
Received: by mail-wm1-f71.google.com with SMTP id m7-20020a05600c4f4700b003d971a5e770so15089813wmq.3
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 14:37:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O7q9NLRqHpcz+PgkDLSNPwabJ77PBKh9UnqB8G+IY+M=;
        b=cemdrqH0QvkpTSo/IZmTTxTc6uCQLV2YXNsAmmDvHHwrHHYlY9oUtDFVXwY2MTHHfb
         hyzyEEpmRUo8fUaN7EwwAKhsLACrrTJhlhn641czlW0gi7dFWLfU6/A3SILMdN4tSNmy
         aJGZmQPOaNuXXpjZ6mTVKbC+GGscAX38pxmICzWtmnrBf3IhoqS+41xDPogK/aQ1UjJ9
         26SZK2HFRdD41Ug9rQaTUldhGCYEsJKG6+B0Nwr1nyQycDqfFnREsQ35NCiZJETZd/ZR
         0xCOISjtf1kmOI+Qz8Q/H7zWL3SNQfwCHsvELUd9iTvtiAWGuLKXntFQXsQ8pEmD7EDv
         w4PQ==
X-Gm-Message-State: AFqh2krr97E2+2py9fPnde+W0fVKGHmua/WM8Q99M9n800gVljcs43xI
        bZVOWl72iabkd1PGzaTDmDG5eYxLUgsN0e+Rfgdt5Kgj3ztJdbv88UciecEaf/CxLDtNhIu8bo1
        a1il6S7NVFKLgKfgf
X-Received: by 2002:a05:600c:3b29:b0:3cf:d18e:528b with SMTP id m41-20020a05600c3b2900b003cfd18e528bmr32885782wms.39.1672785465984;
        Tue, 03 Jan 2023 14:37:45 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs2lF4ZaL9Qq5wxtBpEHF17Z21I7yqZS02wMkzXr9XDmkyhVpIi5GXh8MgQGTWURrA/VwpKhg==
X-Received: by 2002:a05:600c:3b29:b0:3cf:d18e:528b with SMTP id m41-20020a05600c3b2900b003cfd18e528bmr32885759wms.39.1672785465680;
        Tue, 03 Jan 2023 14:37:45 -0800 (PST)
Received: from debian (2a01cb058918ce00dbd9ec1bc2618687.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dbd9:ec1b:c261:8687])
        by smtp.gmail.com with ESMTPSA id r7-20020a05600c458700b003c6b7f5567csm8943wmo.0.2023.01.03.14.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 14:37:45 -0800 (PST)
Date:   Tue, 3 Jan 2023 23:37:42 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Benjamin Coddington <bcodding@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Christoph =?iso-8859-1?Q?B=F6hmwalder?= 
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
Subject: Re: [PATCH net v4 2/3] Treewide: Stop corrupting socket's task_frag
Message-ID: <Y7SuNg4Ewesb7l9T@debian>
References: <cover.1671194454.git.bcodding@redhat.com>
 <ceaf7a4b035e78cdbdde4e9a4ab71ba61a5e5457.1671194454.git.bcodding@redhat.com>
 <CANn89iKik8uMO6=ztufPwYdg1qRPsxToz0Nu-uaZWkE63bKSUQ@mail.gmail.com>
 <Y7RGSbWX0L4EoA8W@debian>
 <CANn89iKEP+LZGHh=ud_c0_RCNM2OHRxF0jeg1EkPpNmTnaXLSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKEP+LZGHh=ud_c0_RCNM2OHRxF0jeg1EkPpNmTnaXLSQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 05:10:24PM +0100, Eric Dumazet wrote:
> On Tue, Jan 3, 2023 at 4:14 PM Guillaume Nault <gnault@redhat.com> wrote:
> >
> > On Tue, Jan 03, 2023 at 03:26:27PM +0100, Eric Dumazet wrote:
> > > On Fri, Dec 16, 2022 at 1:45 PM Benjamin Coddington <bcodding@redhat.com> wrote:
> > > >
> > > > Since moving to memalloc_nofs_save/restore, SUNRPC has stopped setting the
> > > > GFP_NOIO flag on sk_allocation which the networking system uses to decide
> > > > when it is safe to use current->task_frag.  The results of this are
> > > > unexpected corruption in task_frag when SUNRPC is involved in memory
> > > > reclaim.
> > > >
> > > > The corruption can be seen in crashes, but the root cause is often
> > > > difficult to ascertain as a crashing machine's stack trace will have no
> > > > evidence of being near NFS or SUNRPC code.  I believe this problem to
> > > > be much more pervasive than reports to the community may indicate.
> > > >
> > > > Fix this by having kernel users of sockets that may corrupt task_frag due
> > > > to reclaim set sk_use_task_frag = false.  Preemptively correcting this
> > > > situation for users that still set sk_allocation allows them to convert to
> > > > memalloc_nofs_save/restore without the same unexpected corruptions that are
> > > > sure to follow, unlikely to show up in testing, and difficult to bisect.
> > > >
> > >
> > > I am back from PTO.
> > >
> > > It seems inet_ctl_sock_create() has been forgotten.
> > >
> > > Without following fix, ICMP messages sent from softirq would corrupt
> > > innocent thread task_frag.
> >
> > I didn't consider setting ->sk_use_task_frag on ICMP sockets as my
> > understanding was that only TCP and ip_append_data() could eventually
> > call sk_page_frag(). Therefore, I didn't see how ICMP sockets could be
> > affected. Did I miss something?
> 
> net/ipv4/ping.c
> 
> ICMP uses per-cpu sockets (look in icmp_init(), icmp_xmit_lock()...)
> 
> icmp_rcv()
>   -> icmp_echo()
>      -> icmp_reply()
>        -> icmp_push_reply()
>          -> ip_append_data()
>            -> sk_page_frag_refill()

Thanks, that looks so obvious now :/
Sorry for missing that case.

> >
> > > (I will submit this patch formally a bit later today)
> > >
> > > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > > index ab4a06be489b5d410cec603bf56248d31dbc90dd..6c0ec27899431eb56e2f9d0c3a936b77f44ccaca
> > > 100644
> > > --- a/net/ipv4/af_inet.c
> > > +++ b/net/ipv4/af_inet.c
> > > @@ -1665,6 +1665,7 @@ int inet_ctl_sock_create(struct sock **sk,
> > > unsigned short family,
> > >         if (rc == 0) {
> > >                 *sk = sock->sk;
> > >                 (*sk)->sk_allocation = GFP_ATOMIC;
> > > +               (*sk)->sk_use_task_frag = false;
> > >                 /*
> > >                  * Unhash it so that IP input processing does not even see it,
> > >                  * we do not wish this socket to see incoming packets.
> > >
> >
> 

