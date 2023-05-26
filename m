Return-Path: <netdev+bounces-5820-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E4E6712FB7
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 00:07:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26BAB2818A2
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 22:07:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E4B62A9F4;
	Fri, 26 May 2023 22:06:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BC42CA9
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 22:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F0FC433D2;
	Fri, 26 May 2023 22:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685138817;
	bh=IGn6CrEaroN/i6VY660iW7p85iV1o4jlsZrWi6mYmXI=;
	h=From:To:Cc:Subject:Date:From;
	b=ahkYQdRNwo82IUiWbxDWmEKHnPqWDVeBFYsuj94puYQ9wEuTDL8/EfmK8cvRh4iA6
	 HbPBq6b286dIF+oeUFFqJ7+8m+WdYuLSb1O+sqKOQGvVV2Wtz60RnQgPqJQgBaG/nA
	 ygYrv97tq3XJQjI6L4SnZ6hnP/UG2oNJ94eAFKbJs+EaU/ZkDK7jHK0dW9JOfm4eWs
	 tS4Arj4tc/t3/ayl3CmTG1JWecaEIAGvXRzLLYl6BZJrbU7c4gbBLkj9U9iLexgyi3
	 sW8H1epcmjtif9BZYBK0REE2KMJfJQrB5mU5FpsAds5KWkOiOkSUagBWN2K2OsFCDC
	 D2mKnTd7xgT5g==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>,
	sdf@google.com
Subject: [PATCH net] netlink: specs: correct types of legacy arrays
Date: Fri, 26 May 2023 15:06:53 -0700
Message-Id: <20230526220653.65538-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ethtool has some attrs which dump multiple scalars into
an attribute. The spec currently expects one attr per entry.

Fixes: a353318ebf24 ("tools: ynl: populate most of the ethtool spec")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: sdf@google.com
---
 Documentation/netlink/specs/ethtool.yaml | 32 ++++++------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index 129f413ea349..3abc576ff797 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -60,22 +60,6 @@ doc: Partial family for Ethtool Netlink.
         type: nest
         nested-attributes: bitset-bits
 
-  -
-    name: u64-array
-    attributes:
-      -
-        name: u64
-        type: nest
-        multi-attr: true
-        nested-attributes: u64
-  -
-    name: s32-array
-    attributes:
-      -
-        name: s32
-        type: nest
-        multi-attr: true
-        nested-attributes: s32
   -
     name: string
     attributes:
@@ -705,16 +689,16 @@ doc: Partial family for Ethtool Netlink.
         type: u8
       -
         name: corrected
-        type: nest
-        nested-attributes: u64-array
+        type: binary
+        sub-type: u64
       -
         name: uncorr
-        type: nest
-        nested-attributes: u64-array
+        type: binary
+        sub-type: u64
       -
         name: corr-bits
-        type: nest
-        nested-attributes: u64-array
+        type: binary
+        sub-type: u64
   -
     name: fec
     attributes:
@@ -827,8 +811,8 @@ doc: Partial family for Ethtool Netlink.
         type: u32
       -
         name: index
-        type: nest
-        nested-attributes: s32-array
+        type: binary
+        sub-type: s32
   -
     name: module
     attributes:
-- 
2.40.1


