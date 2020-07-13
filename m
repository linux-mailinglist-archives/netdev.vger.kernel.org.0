Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D715421D0EC
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 09:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgGMHvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 03:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgGMHvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 03:51:18 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175DBC061755;
        Mon, 13 Jul 2020 00:51:18 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 00FF2BC0CB;
        Mon, 13 Jul 2020 07:51:14 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, kuba@kernel.org,
        masahiroy@kernel.org, dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] [DCCP]: Replace HTTP links with HTTPS ones
Date:   Mon, 13 Jul 2020 09:51:08 +0200
Message-Id: <20200713075108.32143-1-grandmaster@al2klimov.de>
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

 If there are any URLs to be removed completely or at least not just HTTPSified:
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


 net/dccp/Kconfig                    | 2 +-
 net/dccp/ccids/Kconfig              | 4 ++--
 net/dccp/ccids/ccid3.c              | 2 +-
 net/dccp/ccids/ccid3.h              | 2 +-
 net/dccp/ccids/lib/packet_history.c | 2 +-
 net/dccp/ccids/lib/packet_history.h | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/dccp/Kconfig b/net/dccp/Kconfig
index 51ac2631fb48..0c7d2f66ba27 100644
--- a/net/dccp/Kconfig
+++ b/net/dccp/Kconfig
@@ -5,7 +5,7 @@ menuconfig IP_DCCP
 	help
 	  Datagram Congestion Control Protocol (RFC 4340)
 
-	  From http://www.ietf.org/rfc/rfc4340.txt:
+	  From https://www.ietf.org/rfc/rfc4340.txt:
 
 	  The Datagram Congestion Control Protocol (DCCP) is a transport
 	  protocol that implements bidirectional, unicast connections of
diff --git a/net/dccp/ccids/Kconfig b/net/dccp/ccids/Kconfig
index 4d7771f36eff..a3eeb84d16f9 100644
--- a/net/dccp/ccids/Kconfig
+++ b/net/dccp/ccids/Kconfig
@@ -26,13 +26,13 @@ config IP_DCCP_CCID3
 	  relatively smooth sending rate is of importance.
 
 	  CCID-3 is further described in RFC 4342,
-	  http://www.ietf.org/rfc/rfc4342.txt
+	  https://www.ietf.org/rfc/rfc4342.txt
 
 	  The TFRC congestion control algorithms were initially described in
 	  RFC 5348.
 
 	  This text was extracted from RFC 4340 (sec. 10.2),
-	  http://www.ietf.org/rfc/rfc4340.txt
+	  https://www.ietf.org/rfc/rfc4340.txt
 
 	  If in doubt, say N.
 
diff --git a/net/dccp/ccids/ccid3.c b/net/dccp/ccids/ccid3.c
index 9ef9bee9610f..aef72f6a2829 100644
--- a/net/dccp/ccids/ccid3.c
+++ b/net/dccp/ccids/ccid3.c
@@ -7,7 +7,7 @@
  *  An implementation of the DCCP protocol
  *
  *  This code has been developed by the University of Waikato WAND
- *  research group. For further information please see http://www.wand.net.nz/
+ *  research group. For further information please see https://www.wand.net.nz/
  *
  *  This code also uses code from Lulea University, rereleased as GPL by its
  *  authors:
diff --git a/net/dccp/ccids/ccid3.h b/net/dccp/ccids/ccid3.h
index 081c195e7f7d..02e0fc9f6334 100644
--- a/net/dccp/ccids/ccid3.h
+++ b/net/dccp/ccids/ccid3.h
@@ -6,7 +6,7 @@
  *  An implementation of the DCCP protocol
  *
  *  This code has been developed by the University of Waikato WAND
- *  research group. For further information please see http://www.wand.net.nz/
+ *  research group. For further information please see https://www.wand.net.nz/
  *  or e-mail Ian McDonald - ian.mcdonald@jandi.co.nz
  *
  *  This code also uses code from Lulea University, rereleased as GPL by its
diff --git a/net/dccp/ccids/lib/packet_history.c b/net/dccp/ccids/lib/packet_history.c
index 2d41bb036271..0bef57b908fb 100644
--- a/net/dccp/ccids/lib/packet_history.c
+++ b/net/dccp/ccids/lib/packet_history.c
@@ -6,7 +6,7 @@
  *  An implementation of the DCCP protocol
  *
  *  This code has been developed by the University of Waikato WAND
- *  research group. For further information please see http://www.wand.net.nz/
+ *  research group. For further information please see https://www.wand.net.nz/
  *  or e-mail Ian McDonald - ian.mcdonald@jandi.co.nz
  *
  *  This code also uses code from Lulea University, rereleased as GPL by its
diff --git a/net/dccp/ccids/lib/packet_history.h b/net/dccp/ccids/lib/packet_history.h
index a157d874840b..159cc9326eab 100644
--- a/net/dccp/ccids/lib/packet_history.h
+++ b/net/dccp/ccids/lib/packet_history.h
@@ -6,7 +6,7 @@
  *  Copyright (c) 2005-6 The University of Waikato, Hamilton, New Zealand.
  *
  *  This code has been developed by the University of Waikato WAND
- *  research group. For further information please see http://www.wand.net.nz/
+ *  research group. For further information please see https://www.wand.net.nz/
  *  or e-mail Ian McDonald - ian.mcdonald@jandi.co.nz
  *
  *  This code also uses code from Lulea University, rereleased as GPL by its
-- 
2.27.0

