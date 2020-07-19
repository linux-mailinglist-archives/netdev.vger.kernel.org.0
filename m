Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBF322541E
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 22:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgGSU0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 16:26:55 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:43666 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbgGSU0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 16:26:55 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 78FF3BC085;
        Sun, 19 Jul 2020 20:26:50 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net, kuba@kernel.org,
        corbet@lwn.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH for v5.9] sctp: Replace HTTP links with HTTPS ones
Date:   Sun, 19 Jul 2020 22:26:44 +0200
Message-Id: <20200719202644.61663-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
X-Spam: Yes
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


 Documentation/networking/sctp.rst | 4 ++--
 net/sctp/Kconfig                  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/sctp.rst b/Documentation/networking/sctp.rst
index 9f4d9c8a925b..e2b9f4d9a8a2 100644
--- a/Documentation/networking/sctp.rst
+++ b/Documentation/networking/sctp.rst
@@ -15,8 +15,8 @@ developed the SCTP protocol and later handed the protocol over to the
 Transport Area (TSVWG) working group for the continued evolvement of SCTP as a
 general purpose transport.
 
-See the IETF website (http://www.ietf.org) for further documents on SCTP.
-See http://www.ietf.org/rfc/rfc2960.txt
+See the IETF website (https://www.ietf.org) for further documents on SCTP.
+See https://www.ietf.org/rfc/rfc2960.txt
 
 The initial project goal is to create an Linux kernel reference implementation
 of SCTP that is RFC 2960 compliant and provides an programming interface
diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
index 39d7fa9569f8..0d4ac89ad695 100644
--- a/net/sctp/Kconfig
+++ b/net/sctp/Kconfig
@@ -14,7 +14,7 @@ menuconfig IP_SCTP
 	help
 	  Stream Control Transmission Protocol
 
-	  From RFC 2960 <http://www.ietf.org/rfc/rfc2960.txt>.
+	  From RFC 2960 <https://www.ietf.org/rfc/rfc2960.txt>.
 
 	  "SCTP is a reliable transport protocol operating on top of a
 	  connectionless packet network such as IP.  It offers the following
-- 
2.27.0

