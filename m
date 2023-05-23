Return-Path: <netdev+bounces-4752-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED31570E189
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 18:16:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8269281213
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF4E22069D;
	Tue, 23 May 2023 16:15:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBB1200D7
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 16:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84506C4339B;
	Tue, 23 May 2023 16:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684858504;
	bh=82gs0Pjf3fbxHV8zKIPqxCGEen285wFF+IW8Zt1vbis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBd1DMFLFWDj68RiKm/MarAsfMGsSlauPxOfSsgbfwSxhvbystmAWD8Ty4vAe9WbR
	 RTfIvRyulDcArgRDEwAl2cW9PmF4LGTYJrOWMnxJLMgG3+/uBRO/D5x8SFMQPFne9M
	 mzB+rHWKkWC3OAfDTozhzkUaAsPkSKw13V74VAPjykqsrD0F1XA02Bw4fI27yEKc6V
	 LynUkneMZDjwtU/cy99iSD6QVXLvk/zmewyk2bB6u4hoKoW14VtrMRQXs1QvDVXGq1
	 0sE58piDRFZOtvufdNa2a0HbJ8qKCxIjZLWE9og9LETv9iDsfIOXsUZKUH6OEEvD1G
	 a3Pb4tixLSaLA==
From: Antoine Tenart <atenart@kernel.org>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Cc: Antoine Tenart <atenart@kernel.org>,
	netdev@vger.kernel.org,
	i.maximets@ovn.org,
	dceara@redhat.com
Subject: [PATCH net-next v2 3/3] Documentation: net: net.core.txrehash is not specific to listening sockets
Date: Tue, 23 May 2023 18:14:53 +0200
Message-Id: <20230523161453.196094-4-atenart@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230523161453.196094-1-atenart@kernel.org>
References: <20230523161453.196094-1-atenart@kernel.org>
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
Reviewed-by: Eric Dumazet <edumazet@google.com>
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


