Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA9F1D7607
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 14:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730777AbfJOMKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 08:10:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:58068 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730681AbfJOMKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 08:10:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EEE54B395;
        Tue, 15 Oct 2019 12:10:00 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH v10 3/6] MIPS: PCI: Fix fake subdevice ID for IOC3
Date:   Tue, 15 Oct 2019 14:09:48 +0200
Message-Id: <20191015120953.2597-4-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191015120953.2597-1-tbogendoerfer@suse.de>
References: <20191015120953.2597-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Generation of fake subdevice ID had vendor and device ID swapped.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 arch/mips/pci/pci-xtalk-bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/pci/pci-xtalk-bridge.c b/arch/mips/pci/pci-xtalk-bridge.c
index dcf6117a17c3..d1d5f54c2632 100644
--- a/arch/mips/pci/pci-xtalk-bridge.c
+++ b/arch/mips/pci/pci-xtalk-bridge.c
@@ -437,7 +437,7 @@ static int bridge_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 	return irq;
 }
 
-#define IOC3_SID(sid)	(PCI_VENDOR_ID_SGI << 16 | (sid))
+#define IOC3_SID(sid)	(PCI_VENDOR_ID_SGI | ((sid) << 16))
 
 static void bridge_setup_ip27_baseio6g(struct bridge_controller *bc)
 {
-- 
2.16.4

