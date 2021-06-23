Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27CC3B13B1
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 08:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhFWGJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 02:09:21 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:54880 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbhFWGJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 02:09:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1624428424; x=1655964424;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YCtpVTQAaNY+hgGVKdr0kJYx/uxBrYXjRLRe3p6CJqg=;
  b=TjKeW12Djx7IUHLQ+8ZksD5Xu0N2DHCMVYtdQO3+wgTs5p4ZCO82la5c
   jaVUZ//QvMyTP8k3elCniUflsiroU4sZcfkNt+SzXpb6OpsVW94gGwtFg
   F2DILhfC3phyZMq/3bLj7myG4hlf6PiRu/JU50MLQq9sg9+/IhE8vHeJl
   E=;
X-IronPort-AV: E=Sophos;i="5.83,293,1616457600"; 
   d="scan'208";a="116186703"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 23 Jun 2021 06:07:03 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id 9A207A1880;
        Wed, 23 Jun 2021 06:07:01 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 23 Jun 2021 06:07:00 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.36) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 23 Jun 2021 06:06:57 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>
Subject: [PATCH net-next] net/tls: Remove the __TLS_DEC_STATS() macro.
Date:   Wed, 23 Jun 2021 15:06:34 +0900
Message-ID: <20210623060634.1909-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.36]
X-ClientProxiedBy: EX13P01UWA002.ant.amazon.com (10.43.160.46) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit d26b698dd3cd ("net/tls: add skeleton of MIB statistics")
introduced __TLS_DEC_STATS(), but it is not used and __SNMP_DEC_STATS() is
not defined also. Let's remove it.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
The commit d26b698dd3cd does not contain a bug, so I think Fixes tag is not
necessary and post this to net-next. But if the tag is needed, I'll respin
to the net tree with the tag, so please let me know.
---
 include/net/tls.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 8341a8d1e807..8d398a5de3ee 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -79,8 +79,6 @@
 	__SNMP_INC_STATS((net)->mib.tls_statistics, field)
 #define TLS_INC_STATS(net, field)				\
 	SNMP_INC_STATS((net)->mib.tls_statistics, field)
-#define __TLS_DEC_STATS(net, field)				\
-	__SNMP_DEC_STATS((net)->mib.tls_statistics, field)
 #define TLS_DEC_STATS(net, field)				\
 	SNMP_DEC_STATS((net)->mib.tls_statistics, field)
 
-- 
2.30.2

