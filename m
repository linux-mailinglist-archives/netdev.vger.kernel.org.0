Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B748237372F
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 11:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhEEJVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 05:21:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:41500 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232502AbhEEJUk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 05:20:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5704CB2AA;
        Wed,  5 May 2021 09:19:42 +0000 (UTC)
From:   Jiri Slaby <jslaby@suse.cz>
To:     gregkh@linuxfoundation.org
Cc:     linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org
Subject: [PATCH 32/35] isdn: capi, remove optional tty ops
Date:   Wed,  5 May 2021 11:19:25 +0200
Message-Id: <20210505091928.22010-33-jslaby@suse.cz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505091928.22010-1-jslaby@suse.cz>
References: <20210505091928.22010-1-jslaby@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

break_ctl and set_ldisc are optional tty_operations hooks. Given capi
does nothing useful in them, just remove these.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
---
 drivers/isdn/capi/capi.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 693b0bc31395..bf8a8809eff1 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1238,17 +1238,6 @@ static void capinc_tty_hangup(struct tty_struct *tty)
 	tty_port_hangup(&mp->port);
 }
 
-static int capinc_tty_break_ctl(struct tty_struct *tty, int state)
-{
-	pr_debug("capinc_tty_break_ctl(%d)\n", state);
-	return 0;
-}
-
-static void capinc_tty_set_ldisc(struct tty_struct *tty)
-{
-	pr_debug("capinc_tty_set_ldisc\n");
-}
-
 static void capinc_tty_send_xchar(struct tty_struct *tty, char ch)
 {
 	pr_debug("capinc_tty_send_xchar(%d)\n", ch);
@@ -1267,8 +1256,6 @@ static const struct tty_operations capinc_ops = {
 	.stop = capinc_tty_stop,
 	.start = capinc_tty_start,
 	.hangup = capinc_tty_hangup,
-	.break_ctl = capinc_tty_break_ctl,
-	.set_ldisc = capinc_tty_set_ldisc,
 	.send_xchar = capinc_tty_send_xchar,
 	.install = capinc_tty_install,
 	.cleanup = capinc_tty_cleanup,
-- 
2.31.1

