Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2648664DCA5
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 15:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiLOOAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 09:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiLOOAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 09:00:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE50B303C7
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 05:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671112756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ptrim93QWKctrUDeEGusCkUkiC3svr3HEd5GjvZqw38=;
        b=HsZvxW919Mw7uji1S8bG5QRzhjU2xgbLnsEvKRXt4cy1UMVZ3AjW1AQd4VinhOxxrC6bVp
        dNB/Op/S9m/kc9zi2UHBftMD5Y0zqdR3JOcMhUUJcwXwIp8hg8JWvq3LbXHILsq219IEQB
        HDtkEl29/s/i0vRf7qbU4fJIaut7BNA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-338-0pr0-PjMN-qWh-_AHklMig-1; Thu, 15 Dec 2022 08:59:09 -0500
X-MC-Unique: 0pr0-PjMN-qWh-_AHklMig-1
Received: by mail-wr1-f70.google.com with SMTP id e7-20020adf9bc7000000b00242121eebe2so661514wrc.3
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 05:59:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ptrim93QWKctrUDeEGusCkUkiC3svr3HEd5GjvZqw38=;
        b=zfEhLtX12rZo35GOSOJkCiGx0uZmXjaHz4Il9nZ3L/K9k8+vZt70wRmuUTKjC15AT7
         Gt8kCJknUYuLShrnG/u5Mmx98ndPnrTcTzqI1emhBob5b7DMOV9tGfpExuIednG0fzIS
         lfvKkxv1qUlnKB2wTdQazKvMrmYSe2hkEq+bpCw7Q88jNCncOZk1Uvti5nx1mJt98evO
         0tGkC1aKUtIf+8ZC8Z1uad62UZ6mnLz6ZfbFY0MsmFUfkEgBbIb+/AjdlzM6IRVs7gdS
         eZr38xcXngf8PvhwRqnhSQAZCxbhdd6nj8S7yLGnB8vlc3zj2vB1MML516YNJwl+Z4ZI
         xALw==
X-Gm-Message-State: ANoB5pl+MqrPYH9UKWM4gn6iGGDrZzF7iUzLt4uCx1CxOMKHXOt/7I9B
        SN3oTx023+Ac68uHKYFnsLrvwU4RSV0E6KktTAMtq+Cn6bgre7V2+6FKEWfrxN3NIjrP8rvNClo
        Xf+2XxXM0XQNp1hEG
X-Received: by 2002:a05:6000:d:b0:242:5dd7:8115 with SMTP id h13-20020a056000000d00b002425dd78115mr17635990wrx.64.1671112748760;
        Thu, 15 Dec 2022 05:59:08 -0800 (PST)
X-Google-Smtp-Source: AA0mqf66Sp1oJrww79ntq6HbU8MG+hVJwQy9RanCpnLjrPAXDCNt6qfQXjNp/PtsFDS5lTNjhJLl1g==
X-Received: by 2002:a05:6000:d:b0:242:5dd7:8115 with SMTP id h13-20020a056000000d00b002425dd78115mr17635953wrx.64.1671112748526;
        Thu, 15 Dec 2022 05:59:08 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id bx5-20020a5d5b05000000b00241cfa9333fsm6371201wrb.5.2022.12.15.05.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 05:59:07 -0800 (PST)
Date:   Thu, 15 Dec 2022 14:59:05 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Howells <dhowells@redhat.com>
Cc:     Benjamin Coddington <bcodding@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
Subject: Re: [PATCH net v3 2/3] Treewide: Stop corrupting socket's task_frag
Message-ID: <20221215135905.GA19378@pc-4.home>
References: <92b887a9b90dcbf5083d1f47699c2f785820d708.1670929442.git.bcodding@redhat.com>
 <cover.1670929442.git.bcodding@redhat.com>
 <122424.1671106362@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <122424.1671106362@warthog.procyon.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 12:12:42PM +0000, David Howells wrote:
> 
> Benjamin Coddington <bcodding@redhat.com> wrote:
> 
> > diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
> > index eccc3cd0cb70..ac75ad18db83 100644
> > --- a/fs/afs/rxrpc.c
> > +++ b/fs/afs/rxrpc.c
> > @@ -46,6 +46,7 @@ int afs_open_socket(struct afs_net *net)
> >  		goto error_1;
> >  
> >  	socket->sk->sk_allocation = GFP_NOFS;
> > +	socket->sk->sk_use_task_frag = false;
> >  
> >  	/* bind the callback manager's address to make this a server socket */
> >  	memset(&srx, 0, sizeof(srx));
> 
> Possibly this should be done in net/rxrpc/local_object.c too?  Or maybe in
> udp_sock_create() or sock_create_kern()?

UDP tunnels typically don't need to set sk_use_task_frag, as they don't
call sk_page_frag(). One exception would be if they called
ip_append_data() (or ip6_append_data()), but none of them seem to do
that (and I can't see any reason why they would).

And net/rxrpc/local_object.c doesn't seems very different in this regard.

Maybe setting sk_use_task_frag in fs/afs/rxrpc.c was overzealous but
I'm not familiar enough with the AF_RXRPC family to tell. If AF_RXRPC
sockets can't call sk_page_frag() and have no reason to do so in the
future, then it should be safe to drop this chunk.

> David
> 

