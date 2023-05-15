Return-Path: <netdev+bounces-2491-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32F9B702357
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:33:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A9572810A0
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 05:33:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E94B1FC8;
	Mon, 15 May 2023 05:33:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD0E10E6
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:33:16 +0000 (UTC)
X-Greylist: delayed 2773 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 14 May 2023 22:33:11 PDT
Received: from a27-42.smtp-out.us-west-2.amazonses.com (a27-42.smtp-out.us-west-2.amazonses.com [54.240.27.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BEB172B;
	Sun, 14 May 2023 22:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=s25kmyuhzvo7troimxqpmtptpemzlc6l; d=exabit.dev; t=1684125267;
	h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding;
	bh=xW3rxFkN4NA+Ni5VqmohYWC3KEwvEQmf7u0nnIteFxU=;
	b=X5NegJI36XAHLVkvqp61iMI5HhXC2THuXUg+EZdOBvZfSmqXgMYaIcirrGvPeuN6
	jn0cr9gc/OIRiDfiYOI6nHQLm7Oih4tdIS3y2xYNyhSOo/8yI5otHx9CKMeO8meLxZp
	WwjnV+PXkOJs3ddA3UEZjpJ8FelbtPexCdd+iQ9/HdxSxCvbAodbIQu1hlENZ9vkKex
	xcwnOznir1TQKam/b/r6F6nhcDW0lpbc97K7wfQDiuRnH2J8800UREob7xXHkyMiSsS
	K98IEHEEvTovkGWiOGPTBh3/X7YZZj+/TAcq4DH6OpVHY3YjMILnldDbYt/PiOg6TRK
	uEqjGiGOkA==
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1684125267;
	h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding:Feedback-ID;
	bh=xW3rxFkN4NA+Ni5VqmohYWC3KEwvEQmf7u0nnIteFxU=;
	b=pghg48d+b1otJg9ucGyl42t3TpwNbG8wiQrIRtowF2HGW+jPaM3Vom9Io7alS6lW
	i/pmrjNZYLNB6rb5mnmsJbGD9oWzXEfs3Dcdd5f4lxi9ArBLM8Qc3NmD+ipVs5ACJLC
	Dpj4t/SmkMS8Qjlvn0IU6cahQpvb+FldWB5gIjX8=
From: FUJITA Tomonori <tomo@exabit.dev>
To: rust-for-linux@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH 0/2] rust: networking and crypto abstractions
Date: Mon, 15 May 2023 04:34:27 +0000
Message-ID: <010101881db036fb-2fb6981d-e0ef-4ad1-83c3-54d64b6d93b3-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-ID: 1.us-west-2.j0GTvY5MHQQ5Spu+i4ZGzzYI1gDE7m7iuMEacWMZbe8=:AmazonSES
X-SES-Outgoing: 2023.05.15-54.240.27.42
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_BL_SPAMCOP_NET,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This includes initial rust abstractions for networking and crypto.

I've been working on in-kernel TLS 1.3 handshake in Rust on the top of
this. Currently you can run simple TLS server code, which does a
handshake, sets up kTLS (Kernel TLS offload) to read and write some
bytes.

https://github.com/fujita/rust-tls

Seems that there are some potential users for in-kernel TLS 1.3
handshake (can be used for QUIC protocol too). Hopefully Rust could
help with auditing complicated security-relevant code in the kernel.

The TLS code isn't ready for reviewing yet but I like to push the
dependency for upstream. There might be other potential users for
networking and crypto abstractions.

The series should be cleanly applied to rust-next tree (ac9a786).

Note that this doesn't include all the dependency for the in-kernel
TLS handshake code. You can find at:

https://github.com/fujita/linux/tree/rust-tls


FUJITA Tomonori (2):
 rust: add synchronous message digest support
 rust: add socket support

rust/bindings/bindings_helper.h |   4 +
 rust/helpers.c                  |  24 ++++++
 rust/kernel/crypto.rs           | 108 +++++++++++++++++++++++++
 rust/kernel/lib.rs              |   4 +
 rust/kernel/net.rs              | 174 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 314 insertions(+)


