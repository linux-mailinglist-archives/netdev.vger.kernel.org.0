Return-Path: <netdev+bounces-1707-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AA686FEEF9
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:36:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 934792816E3
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 431C71C74D;
	Thu, 11 May 2023 09:35:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247C91C741
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 09:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B286C4339E;
	Thu, 11 May 2023 09:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683797709;
	bh=+5crpwNYqK528To5BDEJCT90P3XZ+NwSQhG7Xu/xuLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXu8BbWHoUAdGmdnuEhdwK2wOaxEnVk3rCTag80bjge8Hwv/SDFH2bqLJhszlGPIN
	 VyFeRGiMOLgQkv+uaNirxQHNnhNBvHMuyzZxx+CufUzwgmM04xxgvBcaOGnxxgxviv
	 2ORR2EQZyieUiS5b5bRhkpYnCb11wP2/OKmKK19L3yLvn+mVxlIPss2/oCxEse3U6+
	 jEsIvl4GvqO3319zhFzrzKssBFSxpxy5HaNoOyg6H7oqzO3CicYB8r9OJVaJ17XOT4
	 oiSX2yg8o0u4begPQG32BVq4Bv6QCglX835HESGtOHMmWW0GG/ji70+yCOhIzrSsj5
	 X0niAG9oZp5Jg==
From: Antoine Tenart <atenart@kernel.org>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Cc: Antoine Tenart <atenart@kernel.org>,
	netdev@vger.kernel.org
Subject: [PATCH net-next 3/4] Documentation: net: net.core.txrehash is not specific to listening sockets
Date: Thu, 11 May 2023 11:34:55 +0200
Message-Id: <20230511093456.672221-4-atenart@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511093456.672221-1-atenart@kernel.org>
References: <20230511093456.672221-1-atenart@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The net.core.txrehash documentation mentions this knob is for listening
sockets only, while sk_rethink_txhash can be called on SYN and RTO
retransmits on all TCP sockets.

Remove the listening socket part.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 Documentation/admin-guide/sysctl/net.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 466c560b0c30..4877563241f3 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -386,8 +386,8 @@ Default : 0  (for compatibility reasons)
 txrehash
 --------
 
-Controls default hash rethink behaviour on listening socket when SO_TXREHASH
-option is set to SOCK_TXREHASH_DEFAULT (i. e. not overridden by setsockopt).
+Controls default hash rethink behaviour on socket when SO_TXREHASH option is set
+to SOCK_TXREHASH_DEFAULT (i. e. not overridden by setsockopt).
 
 If set to 1 (default), hash rethink is performed on listening socket.
 If set to 0, hash rethink is not performed.
-- 
2.40.1


