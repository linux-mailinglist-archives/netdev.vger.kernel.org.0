Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4702251CB
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 14:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgGSMMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 08:12:34 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:55526 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgGSMMe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 08:12:34 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 6A638BC07E;
        Sun, 19 Jul 2020 12:12:30 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     mcgrof@kernel.org, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, gustavoars@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH for v5.9] prism54: Replace HTTP links with HTTPS ones
Date:   Sun, 19 Jul 2020 14:12:24 +0200
Message-Id: <20200719121224.58581-1-grandmaster@al2klimov.de>
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


 drivers/net/wireless/intersil/prism54/isl_oid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/prism54/isl_oid.h b/drivers/net/wireless/intersil/prism54/isl_oid.h
index 1afc2ccf94ca..b889bb73a485 100644
--- a/drivers/net/wireless/intersil/prism54/isl_oid.h
+++ b/drivers/net/wireless/intersil/prism54/isl_oid.h
@@ -143,7 +143,7 @@ enum dot11_priv_t {
  * together with a CSMA contention. Without this all frames are
  * sent with a CSMA contention.
  * Bibliography:
- * http://www.hpl.hp.com/personal/Jean_Tourrilhes/Papers/Packet.Frame.Grouping.html
+ * https://www.hpl.hp.com/personal/Jean_Tourrilhes/Papers/Packet.Frame.Grouping.html
  */
 enum dot11_maxframeburst_t {
 	/* Values for DOT11_OID_MAXFRAMEBURST */
-- 
2.27.0

