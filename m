Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC7F63D75
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 23:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbfGIVoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 17:44:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbfGIVod (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 17:44:33 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EECE420656;
        Tue,  9 Jul 2019 21:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562708673;
        bh=gggl7A2wJdeZAgh2OPmiKur73mIEstkR1mHtTV7pI1k=;
        h=From:To:Cc:Subject:Date:From;
        b=K8W6ebSg/kNS+aQWUlwoBNAN4PA3xNTz/zGC80XcrwEQVMAuAbImFqr8N/YoB4a0P
         6inOx8i8RzwTQgNZJ2zeEZNLo4NbfVFzflT0szPatYn2tReE6YqZ+iNUwvyjuxHtZr
         nmCQp8Fa4OQQOyH06ell0Rc7BAnNIpi8q5EtRAV4=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH net-next] pkt_sched: Include const.h
Date:   Tue,  9 Jul 2019 14:45:17 -0700
Message-Id: <20190709214517.31684-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Commit 9903c8dc7342 changed TC_ETF defines to use _BITUL instead of BIT
but did not add the dependecy on linux/const.h. As a consequence,
importing the uapi headers into iproute2 causes builds to fail. Add
the dependency.

Fixes: 9903c8dc7342 ("etf: Don't use BIT() in UAPI headers.")
Cc: Vedang Patel <vedang.patel@intel.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
This is meant for net-next as in 5.3 merge window.

 include/uapi/linux/pkt_sched.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 390efb54b2e0..1f623252abe8 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -2,6 +2,7 @@
 #ifndef __LINUX_PKT_SCHED_H
 #define __LINUX_PKT_SCHED_H
 
+#include <linux/const.h>
 #include <linux/types.h>
 
 /* Logical priority bands not depending on specific packet scheduler.
-- 
2.11.0

