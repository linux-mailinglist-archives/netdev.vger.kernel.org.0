Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEFB373735
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 11:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbhEEJVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 05:21:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:41552 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232515AbhEEJUk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 05:20:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9975AB2AF;
        Wed,  5 May 2021 09:19:42 +0000 (UTC)
From:   Jiri Slaby <jslaby@suse.cz>
To:     gregkh@linuxfoundation.org
Cc:     linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org
Subject: [PATCH 33/35] isdn: capi, drop useless pr_debugs
Date:   Wed,  5 May 2021 11:19:26 +0200
Message-Id: <20210505091928.22010-34-jslaby@suse.cz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505091928.22010-1-jslaby@suse.cz>
References: <20210505091928.22010-1-jslaby@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

capi have many pr_debugs in tty_operations hooks to print only a
functions name. We have better debugging aids in the kernel many years
now. So remove these useless pr_debugs.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
---
 drivers/isdn/capi/capi.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index bf8a8809eff1..d5f9261fa879 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1158,8 +1158,6 @@ static void capinc_tty_flush_chars(struct tty_struct *tty)
 	struct capiminor *mp = tty->driver_data;
 	struct sk_buff *skb;
 
-	pr_debug("capinc_tty_flush_chars\n");
-
 	spin_lock_bh(&mp->outlock);
 	skb = mp->outskb;
 	if (skb) {
@@ -1200,7 +1198,6 @@ static unsigned int capinc_tty_chars_in_buffer(struct tty_struct *tty)
 static void capinc_tty_throttle(struct tty_struct *tty)
 {
 	struct capiminor *mp = tty->driver_data;
-	pr_debug("capinc_tty_throttle\n");
 	mp->ttyinstop = 1;
 }
 
@@ -1208,7 +1205,6 @@ static void capinc_tty_unthrottle(struct tty_struct *tty)
 {
 	struct capiminor *mp = tty->driver_data;
 
-	pr_debug("capinc_tty_unthrottle\n");
 	mp->ttyinstop = 0;
 	handle_minor_recv(mp);
 }
@@ -1217,7 +1213,6 @@ static void capinc_tty_stop(struct tty_struct *tty)
 {
 	struct capiminor *mp = tty->driver_data;
 
-	pr_debug("capinc_tty_stop\n");
 	mp->ttyoutstop = 1;
 }
 
@@ -1225,7 +1220,6 @@ static void capinc_tty_start(struct tty_struct *tty)
 {
 	struct capiminor *mp = tty->driver_data;
 
-	pr_debug("capinc_tty_start\n");
 	mp->ttyoutstop = 0;
 	handle_minor_send(mp);
 }
@@ -1234,7 +1228,6 @@ static void capinc_tty_hangup(struct tty_struct *tty)
 {
 	struct capiminor *mp = tty->driver_data;
 
-	pr_debug("capinc_tty_hangup\n");
 	tty_port_hangup(&mp->port);
 }
 
-- 
2.31.1

