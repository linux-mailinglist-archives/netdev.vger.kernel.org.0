Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB492C37F4
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgKYEP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 23:15:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:56032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbgKYEP2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 23:15:28 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DD0820789;
        Wed, 25 Nov 2020 04:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606277727;
        bh=zl/iJOodk/DX/6g3xXSpVmcKoydYtO7Qdk5r99+cFHQ=;
        h=From:To:Cc:Subject:Date:From;
        b=PmxjospUiMvgUhkHXJ7IPdsuX0TAlOlu5SkjeyHwrsH0MM00Q4OvGkcocHUTXPDZN
         rOBeE06G010MpKn6UfNVZKD93BIk6U9DaH91HrZk3I/aG4DZIoti71UD65i9rDfCrL
         WjE7xJsmthmgNeJWYX5VClBLYzWcb2lqd6+ul4DA=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, brouer@redhat.com, f.fainelli@gmail.com,
        andrea.mayer@uniroma2.it, dsahern@gmail.com,
        stephen@networkplumber.org, ast@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2] Documentation: netdev-FAQ: suggest how to post co-dependent series
Date:   Tue, 24 Nov 2020 20:15:24 -0800
Message-Id: <20201125041524.190170-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make an explicit suggestion how to post user space side of kernel
patches to avoid reposts when patchwork groups the wrong patches.

v2: mention the cases unlike iproute2 explicitly

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/netdev-FAQ.rst | 26 +++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index 21537766be4d..4b9ed5874d5a 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -254,6 +254,32 @@ you will have done run-time testing specific to your change, but at a
 minimum, your changes should survive an ``allyesconfig`` and an
 ``allmodconfig`` build without new warnings or failures.
 
+Q: How do I post corresponding changes to user space components?
+----------------------------------------------------------------
+A: User space code exercising kernel features should be posted
+alongside kernel patches. This gives reviewers a chance to see
+how any new interface is used and how well it works.
+
+When user space tools reside in the kernel repo itself all changes
+should generally come as one series. If series becomes too large
+or the user space project is not reviewed on netdev include a link
+to a public repo where user space patches can be seen.
+
+In case user space tooling lives in a separate repository but is
+reviewed on netdev  (e.g. patches to `iproute2` tools) kernel and
+user space patches should form separate series (threads) when posted
+to the mailing list, e.g.::
+
+  [PATCH net-next 0/3] net: some feature cover letter
+   └─ [PATCH net-next 1/3] net: some feature prep
+   └─ [PATCH net-next 2/3] net: some feature do it
+   └─ [PATCH net-next 3/3] selftest: net: some feature
+
+  [PATCH iproute2-next] ip: add support for some feature
+
+Posting as one thread is discouraged because it confuses patchwork
+(as of patchwork 2.2.2).
+
 Q: Any other tips to help ensure my net/net-next patch gets OK'd?
 -----------------------------------------------------------------
 A: Attention to detail.  Re-read your own work as if you were the
-- 
2.26.2

