Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116CD1C0165
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgD3QFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:05:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727813AbgD3QEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:39 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A39024995;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=2swBC8r+6DylYJS2HK2nzZ/1FoxLj3zxrPtfpoRAFVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ok9ZinEe1ctZCFADH2tEs/hUj+qvCbP71fEhwL5gKyOyork/CvCHVF0g3V5W+QhBg
         f05pc27u5ieV54rR1ZLXVWUIFcD7XuRgrxqR4iP4DfeWiUoA8/MuG8ovBQjbykjpo1
         6uWXUqh3Ds3UPKhS7/IB8DuLC0Mhef05A25cf/Us=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxGl-SV; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 33/37] docs: networking: convert tc-actions-env-rules.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:28 +0200
Message-Id: <88a50c11478412a67595b1b93d2e79ebe5ba150a.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- add a document title;
- use the right numbered list markup;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 .../networking/tc-actions-env-rules.rst       | 29 +++++++++++++++++++
 .../networking/tc-actions-env-rules.txt       | 24 ---------------
 3 files changed, 30 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/networking/tc-actions-env-rules.rst
 delete mode 100644 Documentation/networking/tc-actions-env-rules.txt

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 5e495804f96f..f53d89b5679a 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -106,6 +106,7 @@ Contents:
    skfp
    strparser
    switchdev
+   tc-actions-env-rules
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/tc-actions-env-rules.rst b/Documentation/networking/tc-actions-env-rules.rst
new file mode 100644
index 000000000000..86884b8fb4e0
--- /dev/null
+++ b/Documentation/networking/tc-actions-env-rules.rst
@@ -0,0 +1,29 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+================================
+TC Actions - Environmental Rules
+================================
+
+
+The "environmental" rules for authors of any new tc actions are:
+
+1) If you stealeth or borroweth any packet thou shalt be branching
+   from the righteous path and thou shalt cloneth.
+
+   For example if your action queues a packet to be processed later,
+   or intentionally branches by redirecting a packet, then you need to
+   clone the packet.
+
+2) If you munge any packet thou shalt call pskb_expand_head in the case
+   someone else is referencing the skb. After that you "own" the skb.
+
+3) Dropping packets you don't own is a no-no. You simply return
+   TC_ACT_SHOT to the caller and they will drop it.
+
+The "environmental" rules for callers of actions (qdiscs etc) are:
+
+#) Thou art responsible for freeing anything returned as being
+   TC_ACT_SHOT/STOLEN/QUEUED. If none of TC_ACT_SHOT/STOLEN/QUEUED is
+   returned, then all is great and you don't need to do anything.
+
+Post on netdev if something is unclear.
diff --git a/Documentation/networking/tc-actions-env-rules.txt b/Documentation/networking/tc-actions-env-rules.txt
deleted file mode 100644
index f37814693ad3..000000000000
--- a/Documentation/networking/tc-actions-env-rules.txt
+++ /dev/null
@@ -1,24 +0,0 @@
-
-The "environmental" rules for authors of any new tc actions are:
-
-1) If you stealeth or borroweth any packet thou shalt be branching
-from the righteous path and thou shalt cloneth.
-
-For example if your action queues a packet to be processed later,
-or intentionally branches by redirecting a packet, then you need to
-clone the packet.
-
-2) If you munge any packet thou shalt call pskb_expand_head in the case
-someone else is referencing the skb. After that you "own" the skb.
-
-3) Dropping packets you don't own is a no-no. You simply return
-TC_ACT_SHOT to the caller and they will drop it.
-
-The "environmental" rules for callers of actions (qdiscs etc) are:
-
-*) Thou art responsible for freeing anything returned as being
-TC_ACT_SHOT/STOLEN/QUEUED. If none of TC_ACT_SHOT/STOLEN/QUEUED is
-returned, then all is great and you don't need to do anything.
-
-Post on netdev if something is unclear.
-
-- 
2.25.4

