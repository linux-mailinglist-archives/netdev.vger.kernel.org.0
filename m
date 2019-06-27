Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C053958934
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfF0Rqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:46:49 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38591 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbfF0Rqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:46:48 -0400
Received: by mail-pf1-f195.google.com with SMTP id y15so1597455pfn.5;
        Thu, 27 Jun 2019 10:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=VunMILyBRvBUh7WpINrrKE93lqMfcAEq17rKOg7ZmjA=;
        b=RCynl1w0cRddlViRReBIItmlHmfN5Zx2Yg1tVg6t0t4fRmBlSYXLpEV/+2MQpPwhTj
         pxBM2H4/9SbxVQh9edPPxiiMicTvEtv5U/66QPO+F//9NoBeW959GlUPLRBZCU9e5BGK
         cE1lXvYq37hMJ6l7RlDXKkCkAm+KMQe3LzaQK8eCYFlL/bZ2zfBJah70zNMmFor7b9b6
         i8G7IPZnuQXuFXfO1/8eBgvQfgFZN5dLxOxWWARCs6MDTKWyCr4ncPcZbRWPBNPcgSKH
         /80psgyyzK4tzbYhPlHhjTpxYPM1HFKbuz8I4MEC1hWdIf9OS6+KeJhHiMDZ4PvUjyyj
         aHaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VunMILyBRvBUh7WpINrrKE93lqMfcAEq17rKOg7ZmjA=;
        b=Nl57xA3c5YlNA4aPe/f/SiU3SPdulZ8XCB1IVZuVWyEd3BrgvkoNoCQQmyw4XKijXT
         QCUg7YY/LKVgIYKUV7rVMohyHM95BoLUbEGsG24b48LLx5rJuiTxYgJ4yif4rKCoAFmF
         aYE/eZVTGlKyo/uosPfUigDbBsnZQVSmLlJKEsl5Yvmw4XDFvAC/SSC2ZTPAMjEp7J8w
         dxPNYltpzehUkb6N3lvhenQ2WSyoVHufxWFSDBZejHav8xlImOPy1QazHG7dQVwKq5UH
         9NmMhClp2buNLPBaLzp5D/lmxzYbof4MtWAqIC9Sp/UvESUcPztelmbjH1AmJOJMzC36
         s3Bw==
X-Gm-Message-State: APjAAAUBo+22xEa5XInh7Zf/3IgxinxGKJ58W/rPMU62pYxRgUbUKfX3
        WjszEtK7FmIrNBNfjRXAvd8=
X-Google-Smtp-Source: APXvYqyut8DtvXqqufCRCzki4fyFf3GbeOUn1gT/1InVNE0zQGziRoZikJLxkWnR0M/QdcSMhV2ocQ==
X-Received: by 2002:a17:90a:26e4:: with SMTP id m91mr7492906pje.93.1561657607793;
        Thu, 27 Jun 2019 10:46:47 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id r2sm5373668pfl.67.2019.06.27.10.46.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:46:47 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 73/87] ethernet: freescale: Remove memset after dma_alloc_coherent
Date:   Fri, 28 Jun 2019 01:46:41 +0800
Message-Id: <20190627174641.6474-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 38f10f7dcbc3..ec87b8b78d21 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3143,8 +3143,6 @@ static int fec_enet_init(struct net_device *ndev)
 		return -ENOMEM;
 	}
 
-	memset(cbd_base, 0, bd_size);
-
 	/* Get the Ethernet address */
 	fec_get_mac(ndev);
 	/* make sure MAC we just acquired is programmed into the hw */
-- 
2.11.0

