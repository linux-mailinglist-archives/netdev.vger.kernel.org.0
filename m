Return-Path: <netdev+bounces-291-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD77A6F6EDC
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:24:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 263AD280D7C
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 15:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8D6D79D0;
	Thu,  4 May 2023 15:24:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C471855;
	Thu,  4 May 2023 15:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10CCC433D2;
	Thu,  4 May 2023 15:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683213890;
	bh=FTouDkykxMQRz9rZE9nkcyfGey/Gq8f8Xobzg602TKk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=sJWHtWYfWW2UBqQ/i7O6mFTpL2HsdSDbh10hddAJbSW12FVl3jNUl16s1FYsgFB5j
	 mWfrcVgSEZ4VyYSW4dlQGYMLqEQAAuT/7M3H24rDo1ZVI9BktutmVr1MJwy79Rtp6N
	 UrWlKbkw1Y7PGo2a3VtiLqKhb/at1av5NKbQ/jx3K/r42WSHTxno+UiBkDZZe1MiKx
	 iEKt7eOBbwjiboL2aKL5mIbxcmRa2zO0P7MNAuJANXgJqCgqKUoZgcYK4YUSHwy7cg
	 T1oOvRbgc0QzAhaUC6WSLHj5i/ms1cNvcmwlquHyT0dkjgyBrdBK5ZhUtEbnYqxhKA
	 UZ9H8or+3FVgg==
Subject: [PATCH 1/5] net/handshake: Remove unneeded check from handshake_dup()
From: Chuck Lever <cel@kernel.org>
To: kernel-tls-handshake@lists.linux.dev
Cc: netdev@vger.kernel.org, dan.carpenter@linaro.org
Date: Thu, 04 May 2023 11:24:38 -0400
Message-ID: 
 <168321386878.16695.14651822244436092067.stgit@oracle-102.nfsv4bat.org>
In-Reply-To: 
 <168321371754.16695.4217960864733718685.stgit@oracle-102.nfsv4bat.org>
References: 
 <168321371754.16695.4217960864733718685.stgit@oracle-102.nfsv4bat.org>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Chuck Lever <chuck.lever@oracle.com>

handshake_req_submit() now verifies that the socket has a file.

Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/handshake/netlink.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index 35c9c445e0b8..7ec8a76c3c8a 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -99,9 +99,6 @@ static int handshake_dup(struct socket *sock)
 	struct file *file;
 	int newfd;
 
-	if (!sock->file)
-		return -EBADF;
-
 	file = get_file(sock->file);
 	newfd = get_unused_fd_flags(O_CLOEXEC);
 	if (newfd < 0) {



