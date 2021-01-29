Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E9C308BDF
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 18:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhA2RpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 12:45:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232456AbhA2RnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 12:43:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611942094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f0G6YrULWY0Hpt3rLR1Rw+mBqOBEBcyFzEyoDQIunkM=;
        b=JtyM4YHJr8GY8G7NSchJG04pySBkomM1EUohNH5GrUHgfNychcdwHofClIK4m4pq4xdsCz
        ZaslRi9JH+0I94VdnM1zdge3Z27rmfy9+DgjlZEzdK8EU+E+HZOjxpMhixImSfCeLkR+TK
        rcS/l04JhxSbGVw19XlAEEXRjeWux/Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-2lwRzLMEPXWK5VVa-IqQcA-1; Fri, 29 Jan 2021 12:41:32 -0500
X-MC-Unique: 2lwRzLMEPXWK5VVa-IqQcA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF877806693;
        Fri, 29 Jan 2021 17:41:30 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AD445B694;
        Fri, 29 Jan 2021 17:41:29 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <076fad09-b59e-cb6d-6303-adf5964e13c7@novek.ru>
References: <076fad09-b59e-cb6d-6303-adf5964e13c7@novek.ru> <161193864000.3781058.7593105791689441003.stgit@warthog.procyon.org.uk>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     dhowells@redhat.com,
        syzbot+df400f2f24a1677cd7e0@syzkaller.appspotmail.com,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Fix deadlock around release of dst cached on udp tunnel
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3834975.1611942088.1@warthog.procyon.org.uk>
Date:   Fri, 29 Jan 2021 17:41:28 +0000
Message-ID: <3834976.1611942088@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vadim Fedorenko <vfedorenko@novek.ru> wrote:

> You missed the call to dst_release(sk->sk_rx_dst) in
> rxrpc_sock_destructor. Without it we are still leaking the dst.

Hmmm...  I no longer get the messages appearing with this patch.  I'll have
another look.

David

