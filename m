Return-Path: <netdev+bounces-660-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 242B66F8D37
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 02:47:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15F02281181
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 00:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96873EC3;
	Sat,  6 May 2023 00:47:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BC4621;
	Sat,  6 May 2023 00:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4BEC433D2;
	Sat,  6 May 2023 00:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683334025;
	bh=VudGxq1D7OyOAMqXLSH6yW5wjYf40RGPSvsQrHbIwpU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=oePL+z45mek07X87FKg02R/B0JiVTG/mdIraE7XvTpy1Effm8nbr9FUNxqnKGdOHO
	 F2rIlhgb/hQFXQ9nWwiLKXTOdspV5Hl3l/cJg+uCIXxpVE6DrtWsx3cdYYToVop4CB
	 JjEPq0JF+1WDvb0Dl+nhty5NUl1XMiVbfIrDK0gd8ly/l3BYwIE5UHDWZ+LOmAZJbp
	 YMn1Jq4cb/9tm0wV0wtJehCH9BvG0mhD04nEb2mPsROk44LDtIAwtYO6ZZhbB+zkSe
	 QBcxBFbMcedVqngRzWwAIkwdp/MwH+ghwMMcx7i+Wiy1/lk8ZjGgVvG6qmWR6IOett
	 CZWqSTuryfPIQ==
Subject: [PATCH v2 4/6] net/handshake: handshake_genl_notify() shouldn't
 ignore @flags
From: Chuck Lever <cel@kernel.org>
To: kernel-tls-handshake@lists.linux.dev
Cc: netdev@vger.kernel.org, dan.carpenter@linaro.org
Date: Fri, 05 May 2023 20:46:54 -0400
Message-ID: 
 <168333400429.7813.12377237975512449615.stgit@oracle-102.nfsv4bat.org>
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

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/handshake/netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index 11cc275d726a..e865fcf68433 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -48,7 +48,7 @@ int handshake_genl_notify(struct net *net, const struct handshake_proto *proto,
 				proto->hp_handler_class))
 		return -ESRCH;
 
-	msg = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	msg = genlmsg_new(GENLMSG_DEFAULT_SIZE, flags);
 	if (!msg)
 		return -ENOMEM;
 



