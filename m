Return-Path: <netdev+bounces-1879-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 94C236FF667
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:47:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5050B281807
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:47:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 210ED629;
	Thu, 11 May 2023 15:47:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E9B20F6;
	Thu, 11 May 2023 15:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6D1C433D2;
	Thu, 11 May 2023 15:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683820045;
	bh=UGhqSuV6JX3lX5Q1zPu27/jaTssPmiyfw7JooAHm4xA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=qOr6zBb/9wfxEZ4ARoHji6dmghUqnNSZIjeHJLn4QAzfAsbdEzxOHImQnw2SUPC3T
	 7IyvVtTurSFay3sfEDgiIfra6gS9mnNX2YJgFeg8MqoKeq0kGcRghLLp5c+5DB4ubw
	 SSBDdRabLRhQNB9NeRsRx2EjnqHpmlQCvRS/wyz/A1WFsTbrCL4IsaT0ZeAPs88KFv
	 ozqnIYI9Mv6iyfiiUtgwRyQo2KmiQ+HRZP9rvcUjmLxn2omukzXcSEfwrhOYZC+gAc
	 wvJ4W+zGn1gxWebtmpOn9l6D5VUAArpnhf9AmHp0UmLCoh1nHAn0R1E1jDEDCqTz+5
	 vL6je6UnZuvag==
Subject: [PATCH v3 1/6] net/handshake: Remove unneeded check from
 handshake_dup()
From: Chuck Lever <cel@kernel.org>
To: netdev@vger.kernel.org
Cc: kernel-tls-handshake@lists.linux.dev, dan.carpenter@linaro.org,
 chuck.lever@oracle.com
Date: Thu, 11 May 2023 11:47:09 -0400
Message-ID: 
 <168382001980.84244.8076640509647029086.stgit@91.116.238.104.host.secureserver.net>
In-Reply-To: 
 <168381978252.84244.1933636428135211300.stgit@91.116.238.104.host.secureserver.net>
References: 
 <168381978252.84244.1933636428135211300.stgit@91.116.238.104.host.secureserver.net>
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



