Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79232C3528
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 00:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgKXX6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 18:58:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:46078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgKXX6B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 18:58:01 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 048642137B;
        Tue, 24 Nov 2020 23:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606262280;
        bh=RC2bgkm+xUG7RQ1zFnMO2b06e8dIAZeplG9t7RM0NYQ=;
        h=From:To:Cc:Subject:Date:From;
        b=hNbyw4F68JHPXDvMGquOJ5eWiCIVsUW+LnV1ByJdKaAmUGvBHMN/lSID9O4Gw51ny
         xVJlz7sx/a+LcMsmauBx4mnb+9zpMIivET8PHrCzP4E/VNUSlx4OFDdbTMtMr61HG2
         h4vfmtX2iZViEN+yFs3RjvSDpqOYKyUUGNLKIQyU=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, brouer@redhat.com, f.fainelli@gmail.com,
        andrea.mayer@uniroma2.it, dsahern@gmail.com,
        stephen@networkplumber.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] Documentation: netdev-FAQ: suggest how to post co-dependent series
Date:   Tue, 24 Nov 2020 15:57:54 -0800
Message-Id: <20201124235755.159903-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make an explicit suggestion how to post user space side of kernel
patches to avoid reposts when patchwork groups the wrong patches.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index 21537766be4d..553eda8da9c7 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -254,6 +254,26 @@ you will have done run-time testing specific to your change, but at a
 minimum, your changes should survive an ``allyesconfig`` and an
 ``allmodconfig`` build without new warnings or failures.
 
+Q: How do I post corresponding changes to user space components?
+----------------------------------------------------------------
+A: Kernel patches often come with support in user space tooling
+(e.g. `iproute2`). It's best to post both kernel and user space
+code at the same time, so that reviewers have a chance to see how
+user space side looks when reviewing kernel code.
+If user space tooling lives in a separate repository kernel and user
+space patches should form separate series (threads) when posted
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

