Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B83358B41
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 19:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbhDHRYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 13:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbhDHRYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 13:24:09 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3591FC061760;
        Thu,  8 Apr 2021 10:23:58 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id c4so3022220qkg.3;
        Thu, 08 Apr 2021 10:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eA2l4I7YtdtmIbE4ltx15DBrtYgk6xPqSlQ/gnRZkAc=;
        b=JYu0NkPE/XBp5dGZP75GvGBeqW+o5MefYszOWo5drZIAnguSQoyJrITQU/i0Ikhjis
         EfLsqLvAqiug9ZBobDGjt7VBPew7AXnFPhT8UYyHlZZYf/5cM2dShu4kd/MJ9/PIYa77
         x4y1y1FHo2euABmUZ8QIctNNPh/grB52XbTeypNuLuMLAj1hfkNcaoKc/bxNh4OnU4qd
         uSEA0946sZKprL0z2W4QHQpVTpkOCjWRPaY4Rdze5uJBTxlmVQVkvTLa7ofwP6pRBWh5
         v3FvngLirAmXimkt3eDFsQPjw3ZUsjp9DOLp/aM+7xh9W+gjpo/FFhw7/ZHwZRM4hXUz
         rLZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eA2l4I7YtdtmIbE4ltx15DBrtYgk6xPqSlQ/gnRZkAc=;
        b=kuEWZWHx/BzvixH8HAPeLAP82gDw6z8ADHVTRFlrvL+/D9avUREtmsa4AHsf0ds2li
         IJqEcO6AGd2pzd7NSVITWYGwSTpd2zu7Q7tdnc9E+6p3OnSCs6ELN9PFICmATWyGzXkm
         cfCyLiK9UZzny0UqekcVBqi493X/3F5slQ8zavBY8UzgaPvPmqVtnUsBu5d41BRIBRsE
         cgLAa2txzOEjoXbm2HEMc+4iaPMwTEbi6ROVa2bLVEWlGAoK5B83QUdsdnPdOUTU0t9J
         RledYabrDIyWFvmBygV7XOsRC3xxN/e2aWpgpJSPisStX4YwUjBNkHp2NMLKpKqb4vej
         3IBQ==
X-Gm-Message-State: AOAM533/LJ63erOMAjzTuGsDmEKf7CusnNL1mz+QxsGBUIKyzCf9WxA/
        tPvlL/c5ItL58bELVrKRwZ7CblZu4TyShw==
X-Google-Smtp-Source: ABdhPJz7AVao6IUeETblVXD2p8w1ggqOsoC1X3zJG9GRY1tKEx9obeJmM0n1TYvbqS+hdPAV/zz+pQ==
X-Received: by 2002:a05:620a:126d:: with SMTP id b13mr9840471qkl.122.1617902637234;
        Thu, 08 Apr 2021 10:23:57 -0700 (PDT)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id v7sm21054702qkv.86.2021.04.08.10.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 10:23:56 -0700 (PDT)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v1] Revert "lan743x: trim all 4 bytes of the FCS; not just 2"
Date:   Thu,  8 Apr 2021 13:23:53 -0400
Message-Id: <20210408172353.21143-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

This reverts commit 3e21a10fdea3c2e4e4d1b72cb9d720256461af40.

The reverted patch completely breaks all network connectivity on the
lan7430. tcpdump indicates missing bytes when receiving ping
packets from an external host:

host$ ping $lan7430_ip
lan7430$ tcpdump -v
IP truncated-ip - 2 bytes missing! (tos 0x0, ttl 64, id 21715,
    offset 0, flags [DF], proto ICMP (1), length 84)

Fixes: 3e21a10fdea3 ("lan743x: trim all 4 bytes of the FCS; not just 2")
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
To: George McCollister <george.mccollister@gmail.com>
Cc: UNGLinuxDriver@microchip.com
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

 drivers/net/ethernet/microchip/lan743x_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 1c3e204d727c..dbdfabff3b00 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2040,7 +2040,7 @@ lan743x_rx_trim_skb(struct sk_buff *skb, int frame_length)
 		dev_kfree_skb_irq(skb);
 		return NULL;
 	}
-	frame_length = max_t(int, 0, frame_length - RX_HEAD_PADDING - 4);
+	frame_length = max_t(int, 0, frame_length - RX_HEAD_PADDING - 2);
 	if (skb->len > frame_length) {
 		skb->tail -= skb->len - frame_length;
 		skb->len = frame_length;
-- 
2.17.1

