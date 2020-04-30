Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9851C012F
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgD3QEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:04:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbgD3QEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:39 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A60924975;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=pdicZomMtf28CtsI0bBw5bIyiIGVYP4UbC45/HOcPuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+0kfYQ8ug5CaCrOOdG771Rb9c40Wm0NqaHAa2n9Yr8SoKq/rTCv/GssKvOWM0iRs
         UnAdPALXndBCia7ozw4FVbdINfr+JGAaUb3gBjQfi6nP05MtkoJW7Xl5q4/k81Hagg
         5YymVlvou+Iraan40oXBxKupKTOTZuDYf64LT7WA=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxFr-IR; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 22/37] docs: networking: convert radiotap-headers.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:17 +0200
Message-Id: <7916711801e55e457baed67023c47b0fd5fa56f7.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust title markup;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 .../networking/mac80211-injection.rst         |  2 +-
 ...iotap-headers.txt => radiotap-headers.rst} | 99 ++++++++++---------
 include/net/cfg80211.h                        |  2 +-
 net/wireless/radiotap.c                       |  2 +-
 5 files changed, 57 insertions(+), 49 deletions(-)
 rename Documentation/networking/{radiotap-headers.txt => radiotap-headers.rst} (70%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 0da7eb0ec85a..85bc52d0b3a6 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -95,6 +95,7 @@ Contents:
    plip
    ppp_generic
    proc_net_tcp
+   radiotap-headers
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/mac80211-injection.rst b/Documentation/networking/mac80211-injection.rst
index 75d4edcae852..be65f886ff1f 100644
--- a/Documentation/networking/mac80211-injection.rst
+++ b/Documentation/networking/mac80211-injection.rst
@@ -13,7 +13,7 @@ following format::
  [ payload ]
 
 The radiotap format is discussed in
-./Documentation/networking/radiotap-headers.txt.
+./Documentation/networking/radiotap-headers.rst.
 
 Despite many radiotap parameters being currently defined, most only make sense
 to appear on received packets.  The following information is parsed from the
diff --git a/Documentation/networking/radiotap-headers.txt b/Documentation/networking/radiotap-headers.rst
similarity index 70%
rename from Documentation/networking/radiotap-headers.txt
rename to Documentation/networking/radiotap-headers.rst
index 953331c7984f..1a1bd1ec0650 100644
--- a/Documentation/networking/radiotap-headers.txt
+++ b/Documentation/networking/radiotap-headers.rst
@@ -1,3 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===========================
 How to use radiotap headers
 ===========================
 
@@ -5,9 +8,9 @@ Pointer to the radiotap include file
 ------------------------------------
 
 Radiotap headers are variable-length and extensible, you can get most of the
-information you need to know on them from:
+information you need to know on them from::
 
-./include/net/ieee80211_radiotap.h
+    ./include/net/ieee80211_radiotap.h
 
 This document gives an overview and warns on some corner cases.
 
@@ -21,6 +24,8 @@ of the it_present member of ieee80211_radiotap_header is set, it means that
 the header for argument index 0 (IEEE80211_RADIOTAP_TSFT) is present in the
 argument area.
 
+::
+
    < 8-byte ieee80211_radiotap_header >
    [ <possible argument bitmap extensions ... > ]
    [ <argument> ... ]
@@ -76,6 +81,8 @@ ieee80211_radiotap_header.
 Example valid radiotap header
 -----------------------------
 
+::
+
 	0x00, 0x00, // <-- radiotap version + pad byte
 	0x0b, 0x00, // <- radiotap header length
 	0x04, 0x0c, 0x00, 0x00, // <-- bitmap
@@ -89,64 +96,64 @@ Using the Radiotap Parser
 
 If you are having to parse a radiotap struct, you can radically simplify the
 job by using the radiotap parser that lives in net/wireless/radiotap.c and has
-its prototypes available in include/net/cfg80211.h.  You use it like this:
+its prototypes available in include/net/cfg80211.h.  You use it like this::
 
-#include <net/cfg80211.h>
+    #include <net/cfg80211.h>
 
-/* buf points to the start of the radiotap header part */
+    /* buf points to the start of the radiotap header part */
 
-int MyFunction(u8 * buf, int buflen)
-{
-	int pkt_rate_100kHz = 0, antenna = 0, pwr = 0;
-	struct ieee80211_radiotap_iterator iterator;
-	int ret = ieee80211_radiotap_iterator_init(&iterator, buf, buflen);
+    int MyFunction(u8 * buf, int buflen)
+    {
+	    int pkt_rate_100kHz = 0, antenna = 0, pwr = 0;
+	    struct ieee80211_radiotap_iterator iterator;
+	    int ret = ieee80211_radiotap_iterator_init(&iterator, buf, buflen);
 
-	while (!ret) {
+	    while (!ret) {
 
-		ret = ieee80211_radiotap_iterator_next(&iterator);
+		    ret = ieee80211_radiotap_iterator_next(&iterator);
 
-		if (ret)
-			continue;
+		    if (ret)
+			    continue;
 
-		/* see if this argument is something we can use */
+		    /* see if this argument is something we can use */
 
-		switch (iterator.this_arg_index) {
-		/*
-		 * You must take care when dereferencing iterator.this_arg
-		 * for multibyte types... the pointer is not aligned.  Use
-		 * get_unaligned((type *)iterator.this_arg) to dereference
-		 * iterator.this_arg for type "type" safely on all arches.
-		 */
-		case IEEE80211_RADIOTAP_RATE:
-			/* radiotap "rate" u8 is in
-			 * 500kbps units, eg, 0x02=1Mbps
-			 */
-			pkt_rate_100kHz = (*iterator.this_arg) * 5;
-			break;
+		    switch (iterator.this_arg_index) {
+		    /*
+		    * You must take care when dereferencing iterator.this_arg
+		    * for multibyte types... the pointer is not aligned.  Use
+		    * get_unaligned((type *)iterator.this_arg) to dereference
+		    * iterator.this_arg for type "type" safely on all arches.
+		    */
+		    case IEEE80211_RADIOTAP_RATE:
+			    /* radiotap "rate" u8 is in
+			    * 500kbps units, eg, 0x02=1Mbps
+			    */
+			    pkt_rate_100kHz = (*iterator.this_arg) * 5;
+			    break;
 
-		case IEEE80211_RADIOTAP_ANTENNA:
-			/* radiotap uses 0 for 1st ant */
-			antenna = *iterator.this_arg);
-			break;
+		    case IEEE80211_RADIOTAP_ANTENNA:
+			    /* radiotap uses 0 for 1st ant */
+			    antenna = *iterator.this_arg);
+			    break;
 
-		case IEEE80211_RADIOTAP_DBM_TX_POWER:
-			pwr = *iterator.this_arg;
-			break;
+		    case IEEE80211_RADIOTAP_DBM_TX_POWER:
+			    pwr = *iterator.this_arg;
+			    break;
 
-		default:
-			break;
-		}
-	}  /* while more rt headers */
+		    default:
+			    break;
+		    }
+	    }  /* while more rt headers */
 
-	if (ret != -ENOENT)
-		return TXRX_DROP;
+	    if (ret != -ENOENT)
+		    return TXRX_DROP;
 
-	/* discard the radiotap header part */
-	buf += iterator.max_length;
-	buflen -= iterator.max_length;
+	    /* discard the radiotap header part */
+	    buf += iterator.max_length;
+	    buflen -= iterator.max_length;
 
-	...
+	    ...
 
-}
+    }
 
 Andy Green <andy@warmcat.com>
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e67897fabacd..582881d67f70 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5300,7 +5300,7 @@ u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband,
  * Radiotap parsing functions -- for controlled injection support
  *
  * Implemented in net/wireless/radiotap.c
- * Documentation in Documentation/networking/radiotap-headers.txt
+ * Documentation in Documentation/networking/radiotap-headers.rst
  */
 
 struct radiotap_align_size {
diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index 6582d155e2fc..d5e28239e030 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -90,7 +90,7 @@ static const struct ieee80211_radiotap_namespace radiotap_ns = {
  * iterator.this_arg for type "type" safely on all arches.
  *
  * Example code:
- * See Documentation/networking/radiotap-headers.txt
+ * See Documentation/networking/radiotap-headers.rst
  */
 
 int ieee80211_radiotap_iterator_init(
-- 
2.25.4

