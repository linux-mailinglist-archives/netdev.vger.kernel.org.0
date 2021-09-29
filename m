Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49CF41BC6D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 03:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243747AbhI2Bkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 21:40:55 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:47714 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243746AbhI2Bkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 21:40:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1632879553; x=1664415553;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=as9F99Rw2sYN624rwzXOlVPbg9dLXnwn/yeu6p1m7JE=;
  b=RdkFENtpV2jvaYT2SJ30MR7jN7JUDwUHr9hKPjOBUD1wucAuTVQF27ye
   YQadTPsYiigmvqz52ILieAu79t19/9HZI9twfbcBO/btcpOArjZCBfTgj
   1G4krSFZLJlKD7w9JI+qq6vBySnVKKLTRP7A4Q25JTKWTB5HBI9oOxh6O
   k=;
X-IronPort-AV: E=Sophos;i="5.85,331,1624320000"; 
   d="scan'208";a="30357305"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-1cb212d9.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 29 Sep 2021 01:39:13 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-1cb212d9.us-west-2.amazon.com (Postfix) with ESMTPS id D1BF8A0B2A;
        Wed, 29 Sep 2021 01:39:11 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Wed, 29 Sep 2021 01:39:10 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.90) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Wed, 29 Sep 2021 01:39:07 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     Michael Kerrisk <mtk.manpages@gmail.com>,
        Alejandro Colomar <alx.manpages@gmail.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <linux-man@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH] unix.7: Add a description for ENFILE.
Date:   Wed, 29 Sep 2021 10:38:41 +0900
Message-ID: <20210929013841.1694-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D13UWA004.ant.amazon.com (10.43.160.251) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When creating UNIX domain sockets, the kernel used to return -ENOMEM on
error where it should return -ENFILE.  The behaviour has been wrong since
2.2.4 and fixed in the recent commit f4bd73b5a950 ("af_unix: Return errno
instead of NULL in unix_create1().").

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
Note to maintainers of man-pages, the commit is merged in the net tree [0]
but not in the Linus' tree yet.

[0]: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=f4bd73b5a950
---
 man7/unix.7 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/man7/unix.7 b/man7/unix.7
index 6d30b25cd..2dc96fea1 100644
--- a/man7/unix.7
+++ b/man7/unix.7
@@ -721,6 +721,9 @@ invalid state for the applied operation.
 called on an already connected socket or a target address was
 specified on a connected socket.
 .TP
+.B ENFILE
+The system-wide limit on the total number of open files has been reached.
+.TP
 .B ENOENT
 The pathname in the remote address specified to
 .BR connect (2)
-- 
2.30.2

