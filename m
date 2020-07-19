Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8592251C0
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 14:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgGSMCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 08:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgGSMCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 08:02:24 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046C4C0619D2;
        Sun, 19 Jul 2020 05:02:23 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 0E25BBC065;
        Sun, 19 Jul 2020 12:02:18 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     paul@paul-moore.com, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH for v5.9] netfilter: xtables: Replace HTTP links with HTTPS ones
Date:   Sun, 19 Jul 2020 14:02:12 +0200
Message-Id: <20200719120212.58514-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
X-Spam-Level: *****
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 Continuing my work started at 93431e0607e5.
 See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
 (Actually letting a shell for loop submit all this stuff for me.)

 If there are any URLs to be removed completely
 or at least not (just) HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also: https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See: https://lkml.org/lkml/2020/6/26/837

 If you apply the patch, please let me know.

 Sorry again to all maintainers who complained about subject lines.
 Now I realized that you want an actually perfect prefixes,
 not just subsystem ones.
 I tried my best...
 And yes, *I could* (at least half-)automate it.
 Impossible is nothing! :)


 net/netfilter/xt_CONNSECMARK.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index a5c8b653476a..76acecf3e757 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -6,7 +6,7 @@
  * with the SECMARK target and state match.
  *
  * Based somewhat on CONNMARK:
- *   Copyright (C) 2002,2004 MARA Systems AB <http://www.marasystems.com>
+ *   Copyright (C) 2002,2004 MARA Systems AB <https://www.marasystems.com>
  *    by Henrik Nordstrom <hno@marasystems.com>
  *
  * (C) 2006,2008 Red Hat, Inc., James Morris <jmorris@redhat.com>
-- 
2.27.0

