Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681F92740B0
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 13:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgIVLXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 07:23:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726610AbgIVLW7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 07:22:59 -0400
Received: from mail.kernel.org (ip5f5ad5bc.dynamic.kabel-deutschland.de [95.90.213.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4504A238A1;
        Tue, 22 Sep 2020 11:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600773778;
        bh=g4d13BGuduKPDFBeIc0TlyYXYMgjU5xW76V6a9jLQR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFAC4RZfT24s/PKljc7ePg9CEg6N48QFIfbVuvW7LSEciDZtp1roeIHpygS8F0xlk
         0ACjF6eT9NgVwfNvgrOQdqYrAFMeCbUbnUHQViLke/7l05Cu+6EkKpgVTGyA/srih5
         QPlW0Dyz0vLtinRbxAxNYsUbY9iAQiSCje7BZi+8=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kKgNr-0010Kg-Lx; Tue, 22 Sep 2020 13:22:55 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Taehee Yoo <ap420073@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/3] net: fix a new kernel-doc warning at dev.c
Date:   Tue, 22 Sep 2020 13:22:52 +0200
Message-Id: <dbe62eb5e9dda5a5ee145f866a24c4cfddbd754f.1600773619.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1600773619.git.mchehab+huawei@kernel.org>
References: <cover.1600773619.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel-doc expects the function prototype to be just after
the kernel-doc markup, as otherwise it will get it all wrong:

	./net/core/dev.c:10036: warning: Excess function parameter 'dev' description in 'WAIT_REFS_MIN_MSECS'

Fixes: 0e4be9e57e8c ("net: use exponential backoff in netdev_wait_allrefs")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 net/core/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a268ff35ad38..873b50ac9668 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10021,6 +10021,8 @@ int netdev_refcnt_read(const struct net_device *dev)
 }
 EXPORT_SYMBOL(netdev_refcnt_read);
 
+#define WAIT_REFS_MIN_MSECS 1
+#define WAIT_REFS_MAX_MSECS 250
 /**
  * netdev_wait_allrefs - wait until all references are gone.
  * @dev: target net_device
@@ -10033,8 +10035,6 @@ EXPORT_SYMBOL(netdev_refcnt_read);
  * We can get stuck here if buggy protocols don't correctly
  * call dev_put.
  */
-#define WAIT_REFS_MIN_MSECS 1
-#define WAIT_REFS_MAX_MSECS 250
 static void netdev_wait_allrefs(struct net_device *dev)
 {
 	unsigned long rebroadcast_time, warning_time;
-- 
2.26.2

