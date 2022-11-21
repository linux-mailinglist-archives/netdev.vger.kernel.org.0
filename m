Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1180D63285D
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 16:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiKUPhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 10:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiKUPhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 10:37:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E323389
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 07:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669045012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N+IXGSr/QapNFQNwDjLcq8ZySHfdZUj+HKivm9ng9X8=;
        b=VbgX2WQ3cRGNomB+l06CFq6qoMBtOXHFk75aRzRDwCGo1pGLGhk6G5ni6llAZtNo5xc42v
        17gkma0j3PbKYingsJY5aS+L1mXryUUB9tkCzQ6+tAxHibs8H0cOMI24YLS4j2eK20f84d
        vZH0dKDnrfhDoNG9Sk/YRsVrjuFfiog=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-JwXneHvjPxW-PO-QQSQeYA-1; Mon, 21 Nov 2022 10:36:50 -0500
X-MC-Unique: JwXneHvjPxW-PO-QQSQeYA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9BBB811E7A;
        Mon, 21 Nov 2022 15:36:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 916A3C15BB3;
        Mon, 21 Nov 2022 15:36:48 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAO4mrfdN6_FE5ObRkcgwYZqedOijbwhjDnBKRf5qfE69DxwEhA@mail.gmail.com>
References: <CAO4mrfdN6_FE5ObRkcgwYZqedOijbwhjDnBKRf5qfE69DxwEhA@mail.gmail.com>
To:     Wei Chen <harperchen1110@gmail.com>
Cc:     dhowells@redhat.com, marc.dionne@auristor.com, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>, kuba@kernel.org,
        pabeni@redhat.com, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, syzkaller@googlegroups.com
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in udpv6_sendmsg
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <417206.1669045006.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 21 Nov 2022 15:36:46 +0000
Message-ID: <417207.1669045006@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wei Chen <harperchen1110@gmail.com> wrote:

> HEAD commit: 147307c69ba

fatal: ambiguous argument '147307c69ba': unknown revision or path not in t=
he working tree.

> git tree: upstream

Depends what you mean by "upstream".  do_udp_sendmsg net/rxrpc/output.c:27
should only be in net-next/master outside of my tree; it shouldn't be in
Linus's tree yet.

Was the crash fixed by either of:

66f6fd278c67 (tag: rxrpc-next-20221116) rxrpc: Fix network address validat=
ion
6423ac2eb31e rxrpc: Fix oops from calling udpv6_sendmsg() on AF_INET socke=
t

David

