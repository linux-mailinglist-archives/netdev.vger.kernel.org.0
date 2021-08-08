Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216313E3D1E
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 01:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbhHHXFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 19:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbhHHXFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 19:05:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA46C061760;
        Sun,  8 Aug 2021 16:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=C/1IRvAYJBsaYvy+rvH1W2Ek7uoYE0PQhNwYNDxHrGo=; b=D53sizGKDESGiHk16q1wDCmfkf
        UwM9k1ESrxX3a6a1ZY2gADhOQEjgGllKDHhavEwCQZXtb60uYzrCA3daa9WEbC4sHf97DcuNqhzDR
        72HaTDDa6ZxbEY1tn52owsmesD7IRYesLsjU+x8C471yyTdx+rLz7YOSYpq+d7Bsdil6165DMpKLf
        mRIdc6ktyw2wvOPBzJJoqWISjLaPeZmW19MFadws0xm//6ERIb2LAWJlQxksIZ2mU/kruCCnYwKgO
        u4v8H+bPoaeEYOq9y4xbJLDKd2cXaH/qzFV6/ya9MCyZA0nfNOIxS9/0qaT7nl89MqJKWcq4KxbOb
        LAhxK3Og==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mCrqT-00Gghh-3C; Sun, 08 Aug 2021 23:04:41 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, dccp@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>
Subject: [PATCH -net] dccp: add do-while-0 stubs for dccp_pr_debug macros
Date:   Sun,  8 Aug 2021 16:04:40 -0700
Message-Id: <20210808230440.15784-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC complains about empty macros in an 'if' statement, so convert
them to 'do {} while (0)' macros.

Fixes these build warnings:

net/dccp/output.c: In function 'dccp_xmit_packet':
../net/dccp/output.c:283:71: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
  283 |                 dccp_pr_debug("transmit_skb() returned err=%d\n", err);
net/dccp/ackvec.c: In function 'dccp_ackvec_update_old':
../net/dccp/ackvec.c:163:80: warning: suggest braces around empty body in an 'else' statement [-Wempty-body]
  163 |                                               (unsigned long long)seqno, state);

Fixes: dc841e30eaea ("dccp: Extend CCID packet dequeueing interface")
Fixes: 380240864451 ("dccp ccid-2: Update code for the Ack Vector input/registration routine")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: dccp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Gerrit Renker <gerrit@erg.abdn.ac.uk>
---
 net/dccp/dccp.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20210806.orig/net/dccp/dccp.h
+++ linux-next-20210806/net/dccp/dccp.h
@@ -41,9 +41,9 @@ extern bool dccp_debug;
 #define dccp_pr_debug_cat(format, a...)   DCCP_PRINTK(dccp_debug, format, ##a)
 #define dccp_debug(fmt, a...)		  dccp_pr_debug_cat(KERN_DEBUG fmt, ##a)
 #else
-#define dccp_pr_debug(format, a...)
-#define dccp_pr_debug_cat(format, a...)
-#define dccp_debug(format, a...)
+#define dccp_pr_debug(format, a...)	  do {} while (0)
+#define dccp_pr_debug_cat(format, a...)	  do {} while (0)
+#define dccp_debug(format, a...)	  do {} while (0)
 #endif
 
 extern struct inet_hashinfo dccp_hashinfo;
