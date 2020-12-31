Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EC82E7DE5
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 04:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgLaDqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 22:46:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbgLaDqG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 22:46:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 787A720773;
        Thu, 31 Dec 2020 03:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609386325;
        bh=/pNIMhyFxuBrNoAC44wYsU9ecqwq9kYdOVhKeGBXRpM=;
        h=From:To:Cc:Subject:Date:From;
        b=QronkQZv1SMvJitVFQMMSuB50J+tvPEmVlPxEVsJpqp11ov0EWsJXuorFEuLrOK6p
         BFgmlbTf5J6XMcyPgc5RORW79CtgDOm74UeRZ2Hy/CO0podhQUuhlbgBcjIRIE34Bd
         0psb7ev6a/dHVe2BCfoYotk7H5CKjz/2gDnPM2Adl6+xXE4SR5qJ7rKzAe2EqCj01c
         EeUm3/BD0qSXNOL6WfDv3gdAD2HWPg71OgTjMdpqoZ7XlgKo8+7Eso+wnN2RukrTvF
         9WHkPImrR6f6aZX2yNmc/GywdYGU9jtB18zu6m4A4Bp8AZB+yz4Iuc24E/UAHut+aH
         TsiUNRK0ag0Dw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, olteanv@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] docs: net: fix documentation on .ndo_get_stats
Date:   Wed, 30 Dec 2020 19:45:24 -0800
Message-Id: <20201231034524.1570729-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix calling context.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdevices.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
index 5a85fcc80c76..a80676f5477d 100644
--- a/Documentation/networking/netdevices.rst
+++ b/Documentation/networking/netdevices.rst
@@ -64,8 +64,8 @@ struct net_device synchronization rules
 	Context: process
 
 ndo_get_stats:
-	Synchronization: dev_base_lock rwlock.
-	Context: nominally process, but don't sleep inside an rwlock
+	Synchronization: rtnl_lock() semaphore, or RCU.
+	Context: atomic
 
 ndo_start_xmit:
 	Synchronization: __netif_tx_lock spinlock.
-- 
2.26.2

