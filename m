Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A94F82C8AE
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 16:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfE1OYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 10:24:43 -0400
Received: from laurent.telenet-ops.be ([195.130.137.89]:60140 "EHLO
        laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbfE1OYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 10:24:43 -0400
Received: from ramsan ([84.194.111.163])
        by laurent.telenet-ops.be with bizsmtp
        id HqQS200083XaVaC01qQSAl; Tue, 28 May 2019 16:24:41 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hVd1e-00058L-4Z; Tue, 28 May 2019 16:24:26 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hVd1e-00057S-2y; Tue, 28 May 2019 16:24:26 +0200
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
Subject: [PATCH 3/5] net: sched: pie: Use ULL suffix for 64-bit constant
Date:   Tue, 28 May 2019 16:24:22 +0200
Message-Id: <20190528142424.19626-4-geert@linux-m68k.org>
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

With gcc 4.1, when compiling for a 32-bit platform:

    net/sched/sch_pie.c: In function ‘drop_early’:
    net/sched/sch_pie.c:116: warning: integer constant is too large for ‘long’ type
    net/sched/sch_pie.c:138: warning: integer constant is too large for ‘long’ type
    net/sched/sch_pie.c:144: warning: integer constant is too large for ‘long’ type
    net/sched/sch_pie.c:147: warning: integer constant is too large for ‘long’ type
    net/sched/sch_pie.c: In function ‘pie_qdisc_enqueue’:
    net/sched/sch_pie.c:173: warning: integer constant is too large for ‘long’ type
    net/sched/sch_pie.c: In function ‘calculate_probability’:
    net/sched/sch_pie.c:371: warning: integer constant is too large for ‘long’ type
    net/sched/sch_pie.c:372: warning: integer constant is too large for ‘long’ type
    net/sched/sch_pie.c:377: warning: integer constant is too large for ‘long’ type
    net/sched/sch_pie.c:382: warning: integer constant is too large for ‘long’ type
    net/sched/sch_pie.c:397: warning: integer constant is too large for ‘long’ type
    net/sched/sch_pie.c:398: warning: integer constant is too large for ‘long’ type
    net/sched/sch_pie.c:399: warning: integer constant is too large for ‘long’ type
    net/sched/sch_pie.c:407: warning: integer constant is too large for ‘long’ type
    net/sched/sch_pie.c:414: warning: integer constant is too large for ‘long’ type

Fix this by adding the missing "ULL" suffix.

Fixes: 3f7ae5f3dc5295ac ("net: sched: pie: add more cases to auto-tune alpha and beta")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 net/sched/sch_pie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index 8fa129d3943e32ad..f3424833e6a7cd3b 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -31,7 +31,7 @@
 
 #define QUEUE_THRESHOLD 16384
 #define DQCOUNT_INVALID -1
-#define MAX_PROB 0xffffffffffffffff
+#define MAX_PROB 0xffffffffffffffffULL
 #define PIE_SCALE 8
 
 /* parameters used */
-- 
2.17.1

