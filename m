Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE1A64BA11
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 15:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730404AbfFSNeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 09:34:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:36490 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726089AbfFSNeM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 09:34:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6207BAE84;
        Wed, 19 Jun 2019 13:34:11 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     Paul Mackerras <paulus@samba.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-ppp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] ppp: mppe: Add softdep to arc4
Date:   Wed, 19 Jun 2019 15:34:07 +0200
Message-Id: <20190619133407.6800-1-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The arc4 crypto is mandatory at ppp_mppe probe time, so let's put a
softdep line, so that the corresponding module gets prepared
gracefully.  Without this, a simple inclusion to initrd via dracut
failed due to the missing dependency, for example.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/net/ppp/ppp_mppe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
index ff61dd8748de..66c8e65f6872 100644
--- a/drivers/net/ppp/ppp_mppe.c
+++ b/drivers/net/ppp/ppp_mppe.c
@@ -63,6 +63,7 @@ MODULE_AUTHOR("Frank Cusack <fcusack@fcusack.com>");
 MODULE_DESCRIPTION("Point-to-Point Protocol Microsoft Point-to-Point Encryption support");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_ALIAS("ppp-compress-" __stringify(CI_MPPE));
+MODULE_SOFTDEP("pre: arc4");
 MODULE_VERSION("1.0.2");
 
 static unsigned int
-- 
2.16.4

