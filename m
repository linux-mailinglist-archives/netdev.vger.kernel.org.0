Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D88A1C0163
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgD3QFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727797AbgD3QEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:39 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 841782498E;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=HmyB3mSvSoBZPTU9c0iLb35gC8/ETJP1f64nm3K/i1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vex0vRLfRaPVrDWeUZX5D7AZbuVYx+maDsfpkaQR2lYLrvz6Y/IEFw6KhhR4aTzUT
         YZ5CMzEjin0mg2YFFcoKaYFttoivJ+bX/6XlfhS+2eyvb0OB4QTaMHC88/EYyKLktd
         ZVV42aeM5mxj86iSlDx4aBMxMFdBj21z2/XxQi9U=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxGQ-P1; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 29/37] docs: networking: convert seg6-sysctl.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:24 +0200
Message-Id: <3d8b7e996ad24578d9dcc72de4e0d4bc1479ddd2.1588261997.git.mchehab+huawei@kernel.org>
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
- mark code blocks and literals as such;
- add a document title;
- adjust chapters, adding proper markups;
- mark lists as such;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst       |  1 +
 Documentation/networking/seg6-sysctl.rst | 26 ++++++++++++++++++++++++
 Documentation/networking/seg6-sysctl.txt | 18 ----------------
 3 files changed, 27 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/networking/seg6-sysctl.rst
 delete mode 100644 Documentation/networking/seg6-sysctl.txt

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 8b672f252f67..716744c568b7 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -102,6 +102,7 @@ Contents:
    rxrpc
    sctp
    secid
+   seg6-sysctl
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/seg6-sysctl.rst b/Documentation/networking/seg6-sysctl.rst
new file mode 100644
index 000000000000..ec73e1445030
--- /dev/null
+++ b/Documentation/networking/seg6-sysctl.rst
@@ -0,0 +1,26 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================
+Seg6 Sysfs variables
+====================
+
+
+/proc/sys/net/conf/<iface>/seg6_* variables:
+============================================
+
+seg6_enabled - BOOL
+	Accept or drop SR-enabled IPv6 packets on this interface.
+
+	Relevant packets are those with SRH present and DA = local.
+
+	* 0 - disabled (default)
+	* not 0 - enabled
+
+seg6_require_hmac - INTEGER
+	Define HMAC policy for ingress SR-enabled packets on this interface.
+
+	* -1 - Ignore HMAC field
+	* 0 - Accept SR packets without HMAC, validate SR packets with HMAC
+	* 1 - Drop SR packets without HMAC, validate SR packets with HMAC
+
+	Default is 0.
diff --git a/Documentation/networking/seg6-sysctl.txt b/Documentation/networking/seg6-sysctl.txt
deleted file mode 100644
index bdbde23b19cb..000000000000
--- a/Documentation/networking/seg6-sysctl.txt
+++ /dev/null
@@ -1,18 +0,0 @@
-/proc/sys/net/conf/<iface>/seg6_* variables:
-
-seg6_enabled - BOOL
-	Accept or drop SR-enabled IPv6 packets on this interface.
-
-	Relevant packets are those with SRH present and DA = local.
-
-	0 - disabled (default)
-	not 0 - enabled
-
-seg6_require_hmac - INTEGER
-	Define HMAC policy for ingress SR-enabled packets on this interface.
-
-	-1 - Ignore HMAC field
-	0 - Accept SR packets without HMAC, validate SR packets with HMAC
-	1 - Drop SR packets without HMAC, validate SR packets with HMAC
-
-	Default is 0.
-- 
2.25.4

