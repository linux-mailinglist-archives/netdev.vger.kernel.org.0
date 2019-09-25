Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DADA1BDC19
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 12:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389514AbfIYKYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 06:24:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727698AbfIYKYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 06:24:08 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C7C5C1918640;
        Wed, 25 Sep 2019 10:24:08 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-243.ams2.redhat.com [10.36.117.243])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C348B61F24;
        Wed, 25 Sep 2019 10:24:07 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, Thomas Haller <thaller@redhat.com>
Subject: [PATCH] man: add note to ip-macsec manual about necessary key management
Date:   Wed, 25 Sep 2019 12:24:03 +0200
Message-Id: <20190925102403.17146-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Wed, 25 Sep 2019 10:24:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The man page of ip-macsec and the existance of the tool makes it seem like
the user could just configure static keys once, and be done with it. That is
not the case. Some form or key management must be done in user space.

Add a note about that.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 man/man8/ip-macsec.8 | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/man/man8/ip-macsec.8 b/man/man8/ip-macsec.8
index 4fd8a5b6591a..2179b33683d5 100644
--- a/man/man8/ip-macsec.8
+++ b/man/man8/ip-macsec.8
@@ -102,8 +102,19 @@ type.
 .SS Display MACsec configuration
 .nf
 # ip macsec show
+
+.SH NOTES
+This tool can be used to configure the 802.1AE keys of the interface. Note that 802.1AE uses GCM-AES
+with a initialization vector (IV) derived from the packet number. The same key must not be used
+with the same IV more than once. Instead, keys must be frequently regenerated and distibuted.
+This tool is thus mostly for debugging and testing, or in combination with a user-space application
+that reconfigures the keys. It is wrong to just configure the keys statically and assume them to work
+indefinitely. The suggested and standardized way for key management is 802.1X-2010, which is implemented
+by wpa_supplicant.
+
 .SH SEE ALSO
 .br
 .BR ip-link (8)
+.BR wpa_supplicant (8)
 .SH AUTHOR
 Sabrina Dubroca <sd@queasysnail.net>
-- 
2.21.0

