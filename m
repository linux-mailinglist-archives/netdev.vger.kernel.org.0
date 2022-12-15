Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2395164DCF4
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 15:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiLOOh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 09:37:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiLOOh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 09:37:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A974D13CE9
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 06:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671115028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/D687QegGww0pxnZ9+mN8tLEmEvWg+oO0pfwDRAqVMg=;
        b=KyLnIkoKpeULRKYyBD2dgafHgMnjLhjlIvYy1Z6+IrhRb+P4dNeJuYKmtI1jBrhicX7JZi
        WdHGEDu2ZzviJhnyHJv17gGDdJjIysYacFkPVy/f83EB+1QcLLdMRWCGTo66rOGSvIxrWo
        gvVi1+ZweJTMn5MJ7oABhz+7YMFgV3I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-SUS0fRfqMsGwHjZsIz3q8w-1; Thu, 15 Dec 2022 09:37:01 -0500
X-MC-Unique: SUS0fRfqMsGwHjZsIz3q8w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13B06101A55E;
        Thu, 15 Dec 2022 14:37:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C82C114171BE;
        Thu, 15 Dec 2022 14:36:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20221215135905.GA19378@pc-4.home>
References: <20221215135905.GA19378@pc-4.home> <92b887a9b90dcbf5083d1f47699c2f785820d708.1670929442.git.bcodding@redhat.com> <cover.1670929442.git.bcodding@redhat.com> <122424.1671106362@warthog.procyon.org.uk>
To:     Guillaume Nault <gnault@redhat.com>
cc:     dhowells@redhat.com, Benjamin Coddington <bcodding@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Christoph =?utf-8?Q?B=C3=B6hmwalder?= 
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
MIME-Version: 1.0
Content-Type: text/plain
Date:   Thu, 15 Dec 2022 14:36:52 +0000
Message-ID: <139538.1671115012@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Guillaume Nault <gnault@redhat.com> wrote:

> Maybe setting sk_use_task_frag in fs/afs/rxrpc.c was overzealous but
> I'm not familiar enough with the AF_RXRPC family to tell. If AF_RXRPC
> sockets can't call sk_page_frag() and have no reason to do so in the
> future, then it should be safe to drop this chunk.

As of this merge window, AF_RXRPC doesn't actually allocate sk_buffs apart
from when it calls skb_unshare().  It does steal the incoming sk_buffs from
the UDP socket it uses as a transport, but they're allocated in the IP/IP6
stack somewhere.

The UDP transport socket, on the other hand, will allocate sk_buffs for
transmission, but rxrpc sends an entire UDP packet at a time, each with a
single sendmsg call.

Further, this mostly now moved such that the UDP sendmsg calls are performed
inside an I/O thread.  The application thread does not interact directly with
the UDP transport socket.

David

