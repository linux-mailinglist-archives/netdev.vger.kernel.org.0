Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C11272C8A1
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 16:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbfE1OYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 10:24:55 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:47746 "EHLO
        baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727611AbfE1OYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 10:24:45 -0400
Received: from ramsan ([84.194.111.163])
        by baptiste.telenet-ops.be with bizsmtp
        id HqQS2000C3XaVaC01qQSFC; Tue, 28 May 2019 16:24:42 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hVd1e-00058N-5X; Tue, 28 May 2019 16:24:26 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hVd1e-00057W-3p; Tue, 28 May 2019 16:24:26 +0200
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Igor Konopko <igor.j.konopko@intel.com>,
        David Howells <dhowells@redhat.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Matias Bjorling <mb@lightnvm.io>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Joe Perches <joe@perches.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/5] ALSA: fireface: Use ULL suffixes for 64-bit constants
Date:   Tue, 28 May 2019 16:24:23 +0200
Message-Id: <20190528142424.19626-5-geert@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190528142424.19626-1-geert@linux-m68k.org>
References: <20190528142424.19626-1-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With gcc 4.1:

    sound/firewire/fireface/ff-protocol-latter.c: In function ‘latter_switch_fetching_mode’:
    sound/firewire/fireface/ff-protocol-latter.c:97: warning: integer constant is too large for ‘long’ type
    sound/firewire/fireface/ff-protocol-latter.c: In function ‘latter_begin_session’:
    sound/firewire/fireface/ff-protocol-latter.c:170: warning: integer constant is too large for ‘long’ type
    sound/firewire/fireface/ff-protocol-latter.c:197: warning: integer constant is too large for ‘long’ type
    sound/firewire/fireface/ff-protocol-latter.c:205: warning: integer constant is too large for ‘long’ type
    sound/firewire/fireface/ff-protocol-latter.c: In function ‘latter_finish_session’:
    sound/firewire/fireface/ff-protocol-latter.c:214: warning: integer constant is too large for ‘long’ type

Fix this by adding the missing "ULL" suffixes.
Add the same suffix to the last constant, to maintain consistency.

Fixes: fd1cc9de64c2ca6c ("ALSA: fireface: add support for Fireface UCX")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 sound/firewire/fireface/ff-protocol-latter.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/firewire/fireface/ff-protocol-latter.c b/sound/firewire/fireface/ff-protocol-latter.c
index c8236ff89b7fb9de..b30d02d359b1d21b 100644
--- a/sound/firewire/fireface/ff-protocol-latter.c
+++ b/sound/firewire/fireface/ff-protocol-latter.c
@@ -9,11 +9,11 @@
 
 #include "ff.h"
 
-#define LATTER_STF		0xffff00000004
-#define LATTER_ISOC_CHANNELS	0xffff00000008
-#define LATTER_ISOC_START	0xffff0000000c
-#define LATTER_FETCH_MODE	0xffff00000010
-#define LATTER_SYNC_STATUS	0x0000801c0000
+#define LATTER_STF		0xffff00000004ULL
+#define LATTER_ISOC_CHANNELS	0xffff00000008ULL
+#define LATTER_ISOC_START	0xffff0000000cULL
+#define LATTER_FETCH_MODE	0xffff00000010ULL
+#define LATTER_SYNC_STATUS	0x0000801c0000ULL
 
 static int parse_clock_bits(u32 data, unsigned int *rate,
 			    enum snd_ff_clock_src *src)
-- 
2.17.1

