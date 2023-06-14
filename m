Return-Path: <netdev+bounces-10644-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1B8372F888
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:00:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 082821C20C12
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8E185247;
	Wed, 14 Jun 2023 09:00:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9B67FC
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:00:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E941BD4
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 02:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686733250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l4sh/emgrXW2GPutta+QOSkzrAD5eaw/WkmUJz4ERH8=;
	b=Hjp7+EnKHLf0ZR8Mg7sbITFGoWytv698agebbJ6LdN31FJgqOfa86x/gpemOevsLI7hu4e
	L51J5DIr4nmIW2Hryd5CpvJJ+wverQ01HGMuH+zrw7v3pex9ke+FfnI20oDW4RXbQzvcSw
	oegKBhlKnqMBK8BVOgy6ksZvlTf5w18=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-lxvdGTXmNbK4vkz0lZm75w-1; Wed, 14 Jun 2023 05:00:49 -0400
X-MC-Unique: lxvdGTXmNbK4vkz0lZm75w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 455F2101A531;
	Wed, 14 Jun 2023 09:00:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 26114C1603B;
	Wed, 14 Jun 2023 09:00:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <0000000000000900e905fdeb8e39@google.com>
References: <0000000000000900e905fdeb8e39@google.com>
To: syzbot <syzbot+f9e28a23426ac3b24f20@syzkaller.appspotmail.com>
Cc: dhowells@redhat.com, brauner@kernel.org, kuba@kernel.org,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
    netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
    viro@zeniv.linux.org.uk
Subject: Re: [syzbot] [fs?] general protection fault in splice_to_socket
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1423847.1686733230.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Jun 2023 10:00:30 +0100
Message-ID: <1423848.1686733230@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.g=
it main

commit d302bc9baf84c549891bedee57ee917d9e0485d7
Author: David Howells <dhowells@redhat.com>
Date:   Wed Jun 14 09:14:50 2023 +0100

    splice: Fix splice_to_socket() to handle pipe bufs larger than a page
    =

    splice_to_socket() assumes that a pipe_buffer won't hold more than a s=
ingle
    page of data - but it seems that this assumption can be violated when
    splicing from a socket into a pipe.
    =

    The problem is that splice_to_socket() doesn't advance the pipe_buffer
    length and offset when transcribing from the pipe buf into a bio_vec, =
so if
    the buf is >PAGE_SIZE, it keeps repeating the same initial chunk and
    doesn't advance the tail index.  It then subtracts this from "remain" =
and
    overcounts the amount of data to be sent.
    =

    The cleanup phase then tries to overclean the pipe, hits an unused pip=
e buf
    and a NULL-pointer dereference occurs.
    =

    Fix this by not restricting the bio_vec size to PAGE_SIZE and instead
    transcribing the entirety of each pipe_buffer into a single bio_vec an=
d
    advancing the tail index if remain hasn't hit zero yet.
    =

    Large bio_vecs will then be split up iterator functions such as
    iov_iter_extract_pages().
    =

    This resulted in a KASAN report looking like:
    =

    general protection fault, probably for non-canonical address 0xdffffc0=
000000001: 0000 [#1] PREEMPT SMP KASAN
    KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
    ...
    RIP: 0010:pipe_buf_release include/linux/pipe_fs_i.h:203 [inline]
    RIP: 0010:splice_to_socket+0xa91/0xe30 fs/splice.c:933
    =

    Reported-by: syzbot+f9e28a23426ac3b24f20@syzkaller.appspotmail.com
    Fixes: 2dc334f1a63a ("splice, net: Use sendmsg(MSG_SPLICE_PAGES) rathe=
r than ->sendpage()")
    =

    Signed-off-by: David Howells <dhowells@redhat.com>
    cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
    cc: David Ahern <dsahern@kernel.org>
    cc: "David S. Miller" <davem@davemloft.net>
    cc: Eric Dumazet <edumazet@google.com>
    cc: Jakub Kicinski <kuba@kernel.org>
    cc: Paolo Abeni <pabeni@redhat.com>
    cc: Jens Axboe <axboe@kernel.dk>
    cc: Matthew Wilcox <willy@infradead.org>
    cc: Christian Brauner <brauner@kernel.org>
    cc: Alexander Viro <viro@zeniv.linux.org.uk>
    cc: netdev@vger.kernel.org
    cc: linux-fsdevel@vger.kernel.org

diff --git a/fs/splice.c b/fs/splice.c
index e337630aed64..567a1f03ea1e 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -886,7 +886,6 @@ ssize_t splice_to_socket(struct pipe_inode_info *pipe,=
 struct file *out,
 			}
 =

 			seg =3D min_t(size_t, remain, buf->len);
-			seg =3D min_t(size_t, seg, PAGE_SIZE);
 =

 			ret =3D pipe_buf_confirm(pipe, buf);
 			if (unlikely(ret)) {
@@ -897,10 +896,9 @@ ssize_t splice_to_socket(struct pipe_inode_info *pipe=
, struct file *out,
 =

 			bvec_set_page(&bvec[bc++], buf->page, seg, buf->offset);
 			remain -=3D seg;
-			if (seg >=3D buf->len)
-				tail++;
-			if (bc >=3D ARRAY_SIZE(bvec))
+			if (remain =3D=3D 0 || bc >=3D ARRAY_SIZE(bvec))
 				break;
+			tail++;
 		}
 =

 		if (!bc)


