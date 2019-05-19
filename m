Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E29122775
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 19:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfESRFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 13:05:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34278 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfESRFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 13:05:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=L0vlj2iMWRZgm7lLdmLDWIZy9oiNW+0fCxPYNKJJpvw=; b=rZLymEIyAW8iZz/qrYhbmpAkk
        bPJMrHA4cACHXxaLehb50zxApq2zrEBEhT8xKr1q5JECG44nPh54mv4fydnmqAvv9Omeislvf+r0r
        WrficZru6LY4dimjje9FDBtnBrk+fHEHARreopgI322AotEm2mE4FMlgETWEHwZbouSeX4RdBxJRP
        Qt43iV7zfR1zsyuzfQKTmoZ+vJLRat33QARhUbk8/9yHaLVh/ElST/m1ilF65Mm7eFpAelsNp0208
        +K8lYD07pehHDF2fJ2rDeb4SopaVFZciBTCmRam0HV//5LamStEcYlabMlLiO9JVLbY+utXfSfidU
        v1j5LVZjQ==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=dragon.dunlab)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hSDLo-0005CA-2j; Sun, 19 May 2019 04:23:08 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH -next] net: fix kernel-doc warnings for socket.c
Message-ID: <cf9917f9-740d-4185-49bd-b8872ce2dd61@infradead.org>
Date:   Sat, 18 May 2019 21:23:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix kernel-doc warnings by moving the kernel-doc notation to be
immediately above the functions that it describes.

Fixes these warnings for sock_sendmsg() and sock_recvmsg():

../net/socket.c:658: warning: Excess function parameter 'sock' description in 'INDIRECT_CALLABLE_DECLARE'
../net/socket.c:658: warning: Excess function parameter 'msg' description in 'INDIRECT_CALLABLE_DECLARE'
../net/socket.c:889: warning: Excess function parameter 'sock' description in 'INDIRECT_CALLABLE_DECLARE'
../net/socket.c:889: warning: Excess function parameter 'msg' description in 'INDIRECT_CALLABLE_DECLARE'
../net/socket.c:889: warning: Excess function parameter 'flags' description in 'INDIRECT_CALLABLE_DECLARE'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 net/socket.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- linux-next-20190517.orig/net/socket.c
+++ linux-next-20190517/net/socket.c
@@ -645,14 +645,6 @@ void __sock_tx_timestamp(__u16 tsflags,
 }
 EXPORT_SYMBOL(__sock_tx_timestamp);
 
-/**
- *	sock_sendmsg - send a message through @sock
- *	@sock: socket
- *	@msg: message to send
- *
- *	Sends @msg through @sock, passing through LSM.
- *	Returns the number of bytes sent, or an error code.
- */
 INDIRECT_CALLABLE_DECLARE(int inet_sendmsg(struct socket *, struct msghdr *,
 					   size_t));
 static inline int sock_sendmsg_nosec(struct socket *sock, struct msghdr *msg)
@@ -663,6 +655,14 @@ static inline int sock_sendmsg_nosec(str
 	return ret;
 }
 
+/**
+ *	sock_sendmsg - send a message through @sock
+ *	@sock: socket
+ *	@msg: message to send
+ *
+ *	Sends @msg through @sock, passing through LSM.
+ *	Returns the number of bytes sent, or an error code.
+ */
 int sock_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	int err = security_socket_sendmsg(sock, msg,
@@ -875,15 +875,6 @@ void __sock_recv_ts_and_drops(struct msg
 }
 EXPORT_SYMBOL_GPL(__sock_recv_ts_and_drops);
 
-/**
- *	sock_recvmsg - receive a message from @sock
- *	@sock: socket
- *	@msg: message to receive
- *	@flags: message flags
- *
- *	Receives @msg from @sock, passing through LSM. Returns the total number
- *	of bytes received, or an error.
- */
 INDIRECT_CALLABLE_DECLARE(int inet_recvmsg(struct socket *, struct msghdr *,
 					   size_t , int ));
 static inline int sock_recvmsg_nosec(struct socket *sock, struct msghdr *msg,
@@ -893,6 +884,15 @@ static inline int sock_recvmsg_nosec(str
 				   msg_data_left(msg), flags);
 }
 
+/**
+ *	sock_recvmsg - receive a message from @sock
+ *	@sock: socket
+ *	@msg: message to receive
+ *	@flags: message flags
+ *
+ *	Receives @msg from @sock, passing through LSM. Returns the total number
+ *	of bytes received, or an error.
+ */
 int sock_recvmsg(struct socket *sock, struct msghdr *msg, int flags)
 {
 	int err = security_socket_recvmsg(sock, msg, msg_data_left(msg), flags);


