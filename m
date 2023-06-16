Return-Path: <netdev+bounces-11255-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2D6E732468
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 03:03:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71506280DA1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 01:03:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 717DD373;
	Fri, 16 Jun 2023 01:03:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7AC36D
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 01:03:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BA9296F
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 18:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686877414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kcEnbXGcWdas9JneXh0Lv5Rsvonbjggxw0qCFC163g8=;
	b=ELyNMjV05NMOei3qp9wQLjMosL7cNVerTg0JUaMN0pmf8oqH/sTP0uSAbE0X8itAhIP2fU
	sDVxyHH88831pDM5D2Q9hAXSXRgX093x/8BZCkW9mpvLV4NyObqrqsxFiw5jZn3a8ifzhh
	WosFGx1lM+Yt/RvhhKmHJgnIft4/mv8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-5ATaZ5wBOeK4-I-YWKB-ew-1; Thu, 15 Jun 2023 21:03:30 -0400
X-MC-Unique: 5ATaZ5wBOeK4-I-YWKB-ew-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D04D85A58A;
	Fri, 16 Jun 2023 01:03:30 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 03B47492C38;
	Fri, 16 Jun 2023 01:03:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <ZIrWOe4pG7M3TJic@gondor.apana.org.au>
References: <ZIrWOe4pG7M3TJic@gondor.apana.org.au> <000000000000b928f705fdeb873a@google.com> <1433015.1686741914@warthog.procyon.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dhowells@redhat.com,
    syzbot <syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com>,
    davem@davemloft.net, linux-crypto@vger.kernel.org,
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
    pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] general protection fault in shash_async_final
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <415468.1686877408.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Jun 2023 02:03:28 +0100
Message-ID: <415469.1686877408@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Herbert,

Here's a slightly more comprehensive test program for the hashing code to
exercise some combinations of sendmsg, sendmsg+MSG_MORE and recvmsg.

David
---
#define _GNU_SOURCE
#include <endian.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>
#include <linux/if_alg.h>

#define OSERROR(R, S) do { if ((long)(R) =3D=3D -1L) { perror((S)); exit(1=
); } } while(0)

static int hashfd;
static unsigned char buf[1024], sbuf[1024];
static const unsigned char no_zeros[2]  =3D { 0xe3, 0xb0 };
static const unsigned char one_zero[2]  =3D { 0x6e, 0x34 };
static const unsigned char two_zeros[2] =3D { 0x96, 0xa2 };

static void do_send(unsigned int n, unsigned int flags)
{
	struct msghdr msg;
	struct iovec iov[1];
	int res;

	memset(&msg, 0, sizeof(msg));
	iov[0].iov_base =3D sbuf;
	iov[0].iov_len =3D n;
	msg.msg_iov =3D iov;
	msg.msg_iovlen =3D 1;
	res =3D sendmsg(hashfd, &msg, flags);
	OSERROR(res, "sendmsg");
}

static void do_recv(unsigned int ix, const unsigned char r[2])
{
	struct msghdr msg;
	struct iovec iov[1];
	int res, i;

	memset(&msg, 0, sizeof(msg));
	iov[0].iov_base =3D buf;
	iov[0].iov_len =3D sizeof(buf);
	msg.msg_iov =3D iov;
	msg.msg_iovlen =3D 1;
	res =3D recvmsg(hashfd, &msg, 0);
	OSERROR(res, "recvmsg");

	printf("%3u: ", ix);
	for (i =3D 0; i < res; i++)
		 printf("%02x", buf[i]);
	printf("\n");

	if (buf[0] !=3D r[0] || buf[1] !=3D r[1])
		 fprintf(stderr, "     ^ Bad result!\n");
}

int main(void)
{
	struct sockaddr_alg salg;
	int algfd, res;

	algfd =3D socket(AF_ALG, SOCK_SEQPACKET, 0);
	OSERROR(algfd, "socket");

	memset(&salg, 0, sizeof(salg));
	salg.salg_family =3D AF_ALG;
	strcpy(salg.salg_type, "hash");
	strcpy(salg.salg_name, "sha256");
	res =3D bind(algfd, (struct sockaddr *)&salg, sizeof(salg));
	OSERROR(res, "bind/alg");

	hashfd =3D accept4(algfd, NULL, 0, 0);
	OSERROR(hashfd, "accept/alg");

	//res =3D setsockopt(3, SOL_ALG, ALG_SET_KEY, NULL, 0);
	//OSERROR(res, "setsockopt/ALG_SET_KEY");
	=

	/* Test no send */
	do_recv(__LINE__, no_zeros);

	/* Test single send of 0 */
	do_send(0, 0);
	do_recv(__LINE__, no_zeros);

	do_send(0, MSG_MORE);
	do_recv(__LINE__, no_zeros);

	/* Test single send of 1 */
	do_send(1, 0);
	do_recv(__LINE__, one_zero);

	do_send(1, MSG_MORE);
	do_recv(__LINE__, one_zero);

	/* Test single send of 2 */
	do_send(2, 0);
	do_recv(__LINE__, two_zeros);

	do_send(2, MSG_MORE);
	do_recv(__LINE__, two_zeros);

	/* Test two sends of 1 */
	do_send(1, 0);
	do_send(1, 0);
	do_recv(__LINE__, one_zero);

	do_send(1, 0);
	do_send(1, MSG_MORE);
	do_recv(__LINE__, one_zero);

	do_send(1, MSG_MORE);
	do_send(1, 0);
	do_recv(__LINE__, two_zeros);

	do_send(1, MSG_MORE);
	do_send(1, MSG_MORE);
	do_recv(__LINE__, two_zeros);

	/* Test send of 0 then send of 2 */
	do_send(0, 0);
	do_send(2, 0);
	do_recv(__LINE__, two_zeros);

	do_send(0, 0);
	do_send(2, MSG_MORE);
	do_recv(__LINE__, two_zeros);

	do_send(0, MSG_MORE);
	do_send(2, 0);
	do_recv(__LINE__, two_zeros);

	do_send(0, MSG_MORE);
	do_send(2, MSG_MORE);
	do_recv(__LINE__, two_zeros);

	/* Test send of 2 then send of 0 */
	do_send(2, 0);
	do_send(0, 0);
	do_recv(__LINE__, no_zeros);

	do_send(2, 0);
	do_send(0, MSG_MORE);
	do_recv(__LINE__, no_zeros);

	do_send(2, MSG_MORE);
	do_send(0, 0);
	do_recv(__LINE__, two_zeros);

	do_send(2, MSG_MORE);
	do_send(0, MSG_MORE);
	do_recv(__LINE__, two_zeros);

	return 0;
}


