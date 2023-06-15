Return-Path: <netdev+bounces-11081-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 921B5731826
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:08:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C366C1C20E6B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87A1A1426C;
	Thu, 15 Jun 2023 12:08:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E8313AD6
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 12:08:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3ECC184
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686830883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BvRHsFB/oRi8HTtrrWbsQwfbB532rVXuG7TnMUDF+bc=;
	b=Z7EnlIdTXb8rrowTKM33gxiNKzg0OcMX84A4BvC2DFmYwx7ntQvGDk3pwg+KX1igVKjVcp
	s65uO1wpAuSJn3XQOjIKMGUSLMKcXDCiqWxdLQWM1Z8B09WhiVYS/ATstVRETTyJUZLE8c
	iaA/X7ICsOvDJlFCetnX7sr86YpQ6ic=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-z09Qo7_-MFOSQSQDj1rioA-1; Thu, 15 Jun 2023 08:07:57 -0400
X-MC-Unique: z09Qo7_-MFOSQSQDj1rioA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D503101CC8D;
	Thu, 15 Jun 2023 12:07:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 161092026D49;
	Thu, 15 Jun 2023 12:07:49 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <000000000000b2585a05fdeb8379@google.com>
References: <000000000000b2585a05fdeb8379@google.com>
To: syzbot <syzbot+6efc50cc1f8d718d6cb7@syzkaller.appspotmail.com>
Cc: dhowells@redhat.com, davem@davemloft.net,
    herbert@gondor.apana.org.au, kuba@kernel.org,
    linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
    netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] KASAN: slab-out-of-bounds Read in extract_iter_to_sg
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <89570.1686830867.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Jun 2023 13:07:47 +0100
Message-ID: <89571.1686830867@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.g=
it main

diff --git a/fs/splice.c b/fs/splice.c
index 67ddaac1f5c5..17d692449e83 100644
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
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 457598dfa128..6e70839257f7 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1041,7 +1041,8 @@ static int __ip_append_data(struct sock *sk,
 	} else if ((flags & MSG_SPLICE_PAGES) && length) {
 		if (inet->hdrincl)
 			return -EPERM;
-		if (rt->dst.dev->features & NETIF_F_SG)
+		if (rt->dst.dev->features & NETIF_F_SG &&
+		    getfrag =3D=3D ip_generic_getfrag)
 			/* We need an empty buffer to attach stuff to */
 			paged =3D true;
 		else
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index c06ff7519f19..1e8c90e97608 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1593,7 +1593,8 @@ static int __ip6_append_data(struct sock *sk,
 	} else if ((flags & MSG_SPLICE_PAGES) && length) {
 		if (inet_sk(sk)->hdrincl)
 			return -EPERM;
-		if (rt->dst.dev->features & NETIF_F_SG)
+		if (rt->dst.dev->features & NETIF_F_SG &&
+		    getfrag =3D=3D ip_generic_getfrag)
 			/* We need an empty buffer to attach stuff to */
 			paged =3D true;
 		else


