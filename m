Return-Path: <netdev+bounces-1882-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8883F6FF66B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:49:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9ABAD1C20FF6
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:49:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50A53642;
	Thu, 11 May 2023 15:49:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC833647;
	Thu, 11 May 2023 15:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DB5C433D2;
	Thu, 11 May 2023 15:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683820142;
	bh=2VbS/0HefNIvSk0HPkdVusgEbPCircg9pXTOurvUYnw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=AL03aW/KAN8REAFVNU7mUie0k50qGL1ifOL/VRS7IcFvByuSzN//zeG6KfPTn19F6
	 RxsfRD37npHVBnUf2mRnCZ/99Wap5oX9BHPey7XLefGZbnV524xV1TIi0bOOvSCuHL
	 oc17rH60y6qaKYmQoLAy6yZPXfSwaCh4BuPHHYW4is4ht2iGLpNpVleix3A5yaU+Jn
	 B4+IfzfJACtZY1F2NS5TozfNPuALuZDcelFPHGAVTjTnxV8DBW+JLS7kSAfM2oE2z4
	 ZlVrx981NCSYknV52BltCEwrCA7JG9FriJTdjgIuw+9U5QAQSDrbHf/9LMlgOa4Xuh
	 WLtJZ8Hxdt8kQ==
Subject: [PATCH v3 4/6] net/handshake: handshake_genl_notify() shouldn't
 ignore @flags
From: Chuck Lever <cel@kernel.org>
To: netdev@vger.kernel.org
Cc: kernel-tls-handshake@lists.linux.dev, dan.carpenter@linaro.org,
 chuck.lever@oracle.com
Date: Thu, 11 May 2023 11:48:45 -0400
Message-ID: 
 <168382011519.84244.803200053084819033.stgit@91.116.238.104.host.secureserver.net>
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

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/handshake/netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index 16a4bde648ba..1086653e1fad 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -48,7 +48,7 @@ int handshake_genl_notify(struct net *net, const struct handshake_proto *proto,
 				proto->hp_handler_class))
 		return -ESRCH;
 
-	msg = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	msg = genlmsg_new(GENLMSG_DEFAULT_SIZE, flags);
 	if (!msg)
 		return -ENOMEM;
 



