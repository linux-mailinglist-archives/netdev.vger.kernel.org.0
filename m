Return-Path: <netdev+bounces-9379-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35565728A10
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:15:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E47712817FC
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C247539240;
	Thu,  8 Jun 2023 21:12:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7406A34D96
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 21:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85776C43445;
	Thu,  8 Jun 2023 21:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686258731;
	bh=1uMp2NJvZ+VL3dJd7kZjw0H83NP7grVkn+wjqaQYpT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bL24iHTLACjIhwQHA6ztFK2CdnFMZj3gjrX/CCGKhO9rlm4qYTiFIWQb69RrKTixv
	 k15WbkO8NHKag2eSEjwDTQIdz7YPteHU6T82uF51khslfgRDtL7XUhegPzMKyFCAvv
	 Dmm0Qc8kYLm8Kn/qmDmUsfVmC7qSPRJBLzLDMHk+6hYZGIqZWn8yfCydTcpHw4hK7w
	 qZl9++JAZLzjLx972B6JX7ulXtBVOfOmN8RM7mQ8Bl2l0UKlSCN+hdTS9DyAVLT1q9
	 NPzLTzIqYX7jVVHAnEPzfK/1sUmDzo3VrlSFZ093xE8ZFmE8Frd8PxpEtPMTEU/LNm
	 E0v2+wybOW5QQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 12/12] tools: ynl-gen: support / skip pads on the way to kernel
Date: Thu,  8 Jun 2023 14:12:00 -0700
Message-Id: <20230608211200.1247213-13-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608211200.1247213-1-kuba@kernel.org>
References: <20230608211200.1247213-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Kernel does not have padding requirements for 64b attrs.
We can ignore pad attrs.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index be860dee7239..7b051c00cfc3 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -227,12 +227,18 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
     def _attr_typol(self):
         return '.type = YNL_PT_IGNORE, '
 
+    def attr_put(self, ri, var):
+        pass
+
     def attr_get(self, ri, var, first):
         pass
 
     def attr_policy(self, cw):
         pass
 
+    def setter(self, ri, space, direction, deref=False, ref=None):
+        pass
+
 
 class TypeScalar(Type):
     def __init__(self, family, attr_set, attr, value):
-- 
2.40.1


