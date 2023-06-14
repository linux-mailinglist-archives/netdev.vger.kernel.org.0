Return-Path: <netdev+bounces-10824-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81CEB73060A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:25:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AE86281507
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC05E2EC37;
	Wed, 14 Jun 2023 17:22:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE26C2EC1A
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 17:22:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465B9B3
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 10:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686763330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HQz5NdE45oaAvzySylSACbH+ABZmOjstmJq8mz1VYQk=;
	b=gnFz0LDO5ArCgJqHO8+viG+y6R8hlkHWQiM8TWrbIXyff/oi3pSJdCAT6Qgk1hN1g2VBXs
	W6MSulYpNd3x1iJ9vO33oGwX/4oe4buh9TRpxDeSNT3XcLK2DCLjT0+n/for32Kg+it+TS
	q3ySYQxv4CbXbcum/2IgPAa2UgarOS4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-za5E70CiPiqH928GIvIN5g-1; Wed, 14 Jun 2023 13:22:08 -0400
X-MC-Unique: za5E70CiPiqH928GIvIN5g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B60F185A78B;
	Wed, 14 Jun 2023 17:22:04 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C25E0492CA6;
	Wed, 14 Jun 2023 17:22:02 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <000000000000a61ffe05fe0c3d08@google.com>
References: <000000000000a61ffe05fe0c3d08@google.com>
To: syzbot <syzbot+dd1339599f1840e4cc65@syzkaller.appspotmail.com>
Cc: dhowells@redhat.com, bpf@vger.kernel.org, davem@davemloft.net,
    edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
    netdev@vger.kernel.org, pabeni@redhat.com,
    syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [net?] WARNING in unreserve_psock
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1665042.1686763322.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Jun 2023 18:22:02 +0100
Message-ID: <1665043.1686763322@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.g=
it main

    kcm: Fix unnecessary psock unreservation.
    =

    kcm_write_msgs() calls unreserve_psock() to release its hold on the
    underlying TCP socket if it has run out of things to transmit, but if =
we
    have nothing in the write queue on entry (e.g. because someone did a
    zero-length sendmsg), we don't actually go into the transmission loop =
and
    as a consequence don't call reserve_psock().
    =

    Fix this by skipping the call to unreserve_psock() if we didn't reserv=
e a
    psock.
    =

    Fixes: c31a25e1db48 ("kcm: Send multiple frags in one sendmsg()")
    Reported-by: syzbot+dd1339599f1840e4cc65@syzkaller.appspotmail.com
    Link: https://lore.kernel.org/r/000000000000a61ffe05fe0c3d08@google.co=
m/
    Signed-off-by: David Howells <dhowells@redhat.com>
    cc: Tom Herbert <tom@herbertland.com>
    cc: Tom Herbert <tom@quantonium.net>
    cc: "David S. Miller" <davem@davemloft.net>
    cc: Eric Dumazet <edumazet@google.com>
    cc: Jakub Kicinski <kuba@kernel.org>
    cc: Paolo Abeni <pabeni@redhat.com>
    cc: Jens Axboe <axboe@kernel.dk>
    cc: Matthew Wilcox <willy@infradead.org>
    cc: netdev@vger.kernel.org

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index d75d775e9462..d0537c1c8cd7 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -661,6 +661,7 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
 				kcm_abort_tx_psock(psock, ret ? -ret : EPIPE,
 						   true);
 				unreserve_psock(kcm);
+				psock =3D NULL;
 =

 				txm->started_tx =3D false;
 				kcm_report_tx_retry(kcm);
@@ -696,7 +697,8 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
 	if (!head) {
 		/* Done with all queued messages. */
 		WARN_ON(!skb_queue_empty(&sk->sk_write_queue));
-		unreserve_psock(kcm);
+		if (psock)
+			unreserve_psock(kcm);
 	}
 =

 	/* Check if write space is available */


