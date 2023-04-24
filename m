Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85796ED20B
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 18:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbjDXQHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 12:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbjDXQG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 12:06:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49ECC6EA1
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 09:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682352366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UvD4N29l/ZIppjDRrnUsGmGtNacE+xibdoS17eqPvOQ=;
        b=DD4jc1GUdNzaOX9qbO+m7uYTqE+fgdXweKs8XwABFKCBE/tFj6M2MbV3sDVQxxizfuHk/U
        v/Y4x5G8Y4Tu0Zr2dzP0pYoH8Yn/qHRph1F7DxLkotoeLlkRHGYlV6QTDl1UwdVed0vSob
        LXwr5kkAfv90ODwHhzDJkzVahLkNwHA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-fw-hO7gKOXiCYc7jHZzciQ-1; Mon, 24 Apr 2023 12:06:02 -0400
X-MC-Unique: fw-hO7gKOXiCYc7jHZzciQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DEEBA29AB3E1;
        Mon, 24 Apr 2023 16:06:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 075232027043;
        Mon, 24 Apr 2023 16:05:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CACT4Y+YajDb5QpSziTazoyn587JXwXet2w7Jkqkj9v31HZtJxw@mail.gmail.com>
References: <CACT4Y+YajDb5QpSziTazoyn587JXwXet2w7Jkqkj9v31HZtJxw@mail.gmail.com> <000000000000e7c6d205fa10a3cd@google.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     dhowells@redhat.com,
        syzbot <syzbot+ebc945fdb4acd72cba78@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [afs?] [net?] KCSAN: data-race in rxrpc_send_data / rxrpc_set_call_completion
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <457893.1682352358.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 24 Apr 2023 17:05:58 +0100
Message-ID: <457894.1682352358@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitry Vyukov <dvyukov@google.com> wrote:

> If I am reading this correctly, rxrpc_send_data() can read wrong
> call->completion and state and incorrectly exit with an error if
> rxrpc_wait_to_be_connected() exists early right after observing error
> set here:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
net/rxrpc/sendmsg.c?id=3D148341f0a2f53b5e8808d093333d85170586a15d#n58
> The code seems to assume that at that point all writes done by
> rxrpc_set_call_completion() are already finished, but it's not
> necessarily the case.

I'm not sure it matters.  call->error can only be set by the I/O thread an=
d
only if a call fails - in which case the call state will be set shortly
thereafter - plus a couple of places where we fail to set the call up, in
which case we're under the call's user_mutex or didn't even manage to full=
y
allocate it.

That said, I probably should check the call state first.  I might also wan=
t to
ignore any signal if the call did manage to get connected, lest I leave it
dangling - a problem might come if userspace issues a single sendmsg() to =
set
up the call and supply data to be transmitted.  I need to have a ponder on
that one.

David

