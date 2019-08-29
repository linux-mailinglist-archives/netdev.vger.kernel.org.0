Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 917DFA2001
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 17:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbfH2Pue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 11:50:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:60820 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727207AbfH2Pue (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 11:50:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 27E81AFB2;
        Thu, 29 Aug 2019 15:50:33 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next 01/15] MIPS: SGI-IP27: remove ioc3 ethernet init
Date:   Thu, 29 Aug 2019 17:49:59 +0200
Message-Id: <20190829155014.9229-2-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190829155014.9229-1-tbogendoerfer@suse.de>
References: <20190829155014.9229-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removed not needed disabling of ethernet interrupts in IP27 platform code.

Acked-by: Paul Burton <paul.burton@mips.com>
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 arch/mips/sgi-ip27/ip27-init.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/arch/mips/sgi-ip27/ip27-init.c b/arch/mips/sgi-ip27/ip27-init.c
index 066b33f50bcc..59d5375c9021 100644
--- a/arch/mips/sgi-ip27/ip27-init.c
+++ b/arch/mips/sgi-ip27/ip27-init.c
@@ -130,17 +130,6 @@ cnodeid_t get_compact_nodeid(void)
 	return NASID_TO_COMPACT_NODEID(get_nasid());
 }
 
-static inline void ioc3_eth_init(void)
-{
-	struct ioc3 *ioc3;
-	nasid_t nid;
-
-	nid = get_nasid();
-	ioc3 = (struct ioc3 *) KL_CONFIG_CH_CONS_INFO(nid)->memory_base;
-
-	ioc3->eier = 0;
-}
-
 extern void ip27_reboot_setup(void);
 
 void __init plat_mem_setup(void)
@@ -182,8 +171,6 @@ void __init plat_mem_setup(void)
 		panic("Kernel compiled for N mode.");
 #endif
 
-	ioc3_eth_init();
-
 	ioport_resource.start = 0;
 	ioport_resource.end = ~0UL;
 	set_io_port_base(IO_BASE);
-- 
2.13.7

