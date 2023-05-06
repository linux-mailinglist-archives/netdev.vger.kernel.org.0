Return-Path: <netdev+bounces-657-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 945AD6F8D34
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 02:45:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDE4F1C21A9E
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 00:45:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04CAAEC3;
	Sat,  6 May 2023 00:45:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F79621;
	Sat,  6 May 2023 00:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7456C433EF;
	Sat,  6 May 2023 00:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683333946;
	bh=UGhqSuV6JX3lX5Q1zPu27/jaTssPmiyfw7JooAHm4xA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=MgWYZCUU7PQAvNZToLXNYbEwdqpEnQNENkBOQE5gqbTLWUTUUhWHjXsKotw20Z7QG
	 AcQ0M8Jk97v0QdrsBa1GAchvV/WpNicow8N2jzB4CPALmA0447CyLiHxBV4+YVULem
	 UYGx4CevZ/EUSFp28NT0U1+daSOSl+Tmh5BCwKrajOadFvaNRWCjpILSm4OLvBM5JH
	 4QMXIG9dR8pKgGU5mQu0k1cEZSV/0PAThgOjfOr3ihZrhfuQiLah/+Glexiz1oA/jp
	 Cguz3ETUYzBowovEQTU62IcHYuBwaf8Iyr9qLU9wYxp0M11WlzA3YCcikaeJXN+ZoL
	 ZZHI6Ax3pmkIg==
Subject: [PATCH v2 1/6] net/handshake: Remove unneeded check from
 handshake_dup()
From: Chuck Lever <cel@kernel.org>
To: kernel-tls-handshake@lists.linux.dev
Cc: netdev@vger.kernel.org, dan.carpenter@linaro.org
Date: Fri, 05 May 2023 20:45:34 -0400
Message-ID: 
 <168333392465.7813.6150331019194277990.stgit@oracle-102.nfsv4bat.org>
In-Reply-To: 
 <168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
References: 
 <168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
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



