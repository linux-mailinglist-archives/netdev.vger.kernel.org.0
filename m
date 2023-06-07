Return-Path: <netdev+bounces-9041-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22059726B52
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:24:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 102741C20EEF
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 573493AE5B;
	Wed,  7 Jun 2023 20:24:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EAA3AE49
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930FFC4339E;
	Wed,  7 Jun 2023 20:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686169447;
	bh=FSeAqnsbmwauOttshODd1cydkY4koag1biNqUGGLFH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KGNc2tS7le6CueaKN0FSEu/jWRzMbPIL1TZLlD/SIX+a4wMlr/1c18VB2wUQZJDhZ
	 zt+W5nFOEQox5x9c6EFByKJhQ9DckIUNACH4dJOW89fgoHgdGFzH0W9YemQymr+adK
	 qE2y93CsMzDBbGhWSwnMSvS1/FAxoZ+arSe0+mq0Yln5LU3Guv4Y8G/Pydj61GeDEn
	 c0MGXs8YIqN/pgfsYLW3UKLLhEePr6F8kzSBJhvwCqFxZkXl/Gx6r+NcASrMt0jZ+E
	 4AxzTjN1A5IeyunjqPb3q4OIfHpo4Kso9F71hNVJ6ORFQB1eWgPZN3Z3RN1/xeOsYm
	 hxy1Grq/aBb3A==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	jiri@resnulli.us,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 01/11] netlink: specs: devlink: fill in some details important for C
Date: Wed,  7 Jun 2023 13:23:53 -0700
Message-Id: <20230607202403.1089925-2-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607202403.1089925-1-kuba@kernel.org>
References: <20230607202403.1089925-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Python YNL is much more forgiving than the C code gen in terms
of the spec completeness. Fill in a handful of devlink details
to make the spec usable in C.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/specs/devlink.yaml | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/netlink/specs/devlink.yaml b/Documentation/netlink/specs/devlink.yaml
index 90641668232e..5d46ca966979 100644
--- a/Documentation/netlink/specs/devlink.yaml
+++ b/Documentation/netlink/specs/devlink.yaml
@@ -9,6 +9,7 @@ doc: Partial family for Devlink.
 attribute-sets:
   -
     name: devlink
+    name-prefix: devlink-attr-
     attributes:
       -
         name: bus-name
@@ -95,10 +96,12 @@ doc: Partial family for Devlink.
       -
         name: reload-action-info
         type: nest
+        multi-attr: true
         nested-attributes: dl-reload-act-info
       -
         name: reload-action-stats
         type: nest
+        multi-attr: true
         nested-attributes: dl-reload-act-stats
   -
     name: dl-dev-stats
@@ -196,3 +199,8 @@ doc: Partial family for Devlink.
           attributes:
             - bus-name
             - dev-name
+            - info-driver-name
+            - info-serial-number
+            - info-version-fixed
+            - info-version-running
+            - info-version-stored
-- 
2.40.1


