Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6672339F469
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 12:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbhFHK6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 06:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbhFHK6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 06:58:17 -0400
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24874C061787
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 03:56:19 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:c184:ea65:c3d6:a616])
        by albert.telenet-ops.be with bizsmtp
        id EawC250031G4u2S06awCew; Tue, 08 Jun 2021 12:56:17 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1lqZP1-00EOq1-D6; Tue, 08 Jun 2021 12:56:11 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1lqZP0-008IPP-RD; Tue, 08 Jun 2021 12:56:10 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        Dean Balandin <dbalandin@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Shai Malin <smalin@marvell.com>
Cc:     Petr Mladek <pmladek@suse.com>, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] nvme: NVME_TCP_OFFLOAD should not default to m
Date:   Tue,  8 Jun 2021 12:56:09 +0200
Message-Id: <39b1a3684880e1d85ef76e34403886e8f1d22508.1623149635.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The help text for the symbol controlling support for the NVM Express
over Fabrics TCP offload common layer suggests to not enable this
support when unsure.

Hence drop the "default m", which actually means "default y" if
CONFIG_MODULES is not enabled.

Fixes: f0e8cb6106da2703 ("nvme-tcp-offload: Add nvme-tcp-offload - NVMeTCP HW offload ULP")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/nvme/host/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
index 9c6f4d776daf14cf..f76cc4690bfc37bc 100644
--- a/drivers/nvme/host/Kconfig
+++ b/drivers/nvme/host/Kconfig
@@ -88,7 +88,6 @@ config NVME_TCP
 
 config NVME_TCP_OFFLOAD
 	tristate "NVM Express over Fabrics TCP offload common layer"
-	default m
 	depends on BLOCK
 	depends on INET
 	select NVME_CORE
-- 
2.25.1

