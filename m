Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22183B3B01
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 04:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhFYC6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 22:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbhFYC6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 22:58:21 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72D9C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 19:56:01 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id l12-20020a25ad4c0000b029055444b6e99bso2310777ybe.5
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 19:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=IHbdHWh1W7jCDPqMJ5B5oDsJ3CePKn2rlYaaN7qNhz0=;
        b=sa2ns3bAYdaZBsb5ZVFWsPmtu13F4dm8R0iekQYTA/zAm6uFO2/y5rIl0NvtIouel/
         OzNKcPnD+MgjiYWw5x6eEao6qa3iYO6XqSZPcTmJY8BIgNVeSyMcsmThFHpUBLbZtzFl
         pebH6Uso1oHyW9nuQ7NjTCHNwUygMIJlstb3nsA4+cHwLvaA8McSLLkL9TQVQ7Q7yjU0
         ENsVldVivwI1lWEwOGwjDBZbShs/4+BdiQLpbhla7QDFfoAsEhSbc4qgtqNc08qNiDYc
         dwY1gssVSFbbfKx13FRO3793tY6TNEqbd9QrNm2BZyWTZpoEljwULTGvwnu434qNGtjV
         RW1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=IHbdHWh1W7jCDPqMJ5B5oDsJ3CePKn2rlYaaN7qNhz0=;
        b=lex0/M1HqEOZFobmE+dKtEDXnsxog5D4gbRGr++b6HgHVl0o8Pikl0gjuk8S66yHUd
         KYGtoRPXW3AEROMoKSK7SQ+vSv9ERShkD3vRJ07Pn6/tYgJ1Ei/4j/0EO2pDa/toT/n6
         q6GQ3s0FUG3/1aY41qNx7xp4GndYzKjF8mcXK8RpY2fd8kBosN6iK6XMwHmnBscFH7Vd
         qsOPU/IzgAtkpL+wKX2NHc+jb7yrUE+WEIvrQsFy86lHvM9E+k78QAJRxnQEvv7fz3Jt
         E3BUAy6Dr+683woNB1lUdTGDf7XyeUGeQ58hRvF3kkxrhdg4fJJqKBhrcIBAn0qNWgJr
         o02g==
X-Gm-Message-State: AOAM5326X1xHNRBdZzgSeOAYhs4BNVFND+9PSOjNV/B2U0dFD5k0NTel
        Ibv5AS+CHC/PZWpk5B+TDG8EIdI=
X-Google-Smtp-Source: ABdhPJwKHAXl2wqCFtd/rD4t2gKwuE90POXjGBLLMnIet0Ise+WAc9vuH/AeuUkuAs72lkmg8BagOEc=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:cb6c:4753:6df0:b898])
 (user=bcf job=sendgmr) by 2002:a5b:7d1:: with SMTP id t17mr9692203ybq.334.1624589760845;
 Thu, 24 Jun 2021 19:56:00 -0700 (PDT)
Date:   Thu, 24 Jun 2021 19:55:41 -0700
Message-Id: <20210625025542.4057943-1-bcf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH net] gve: Fix swapped vars when fetching max queues
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 893ce44df565 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
Signed-off-by: Bailey Forrest <bcf@google.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index bbc423e93122..79cefe85a799 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1295,8 +1295,8 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	gve_write_version(&reg_bar->driver_version);
 	/* Get max queues to alloc etherdev */
-	max_rx_queues = ioread32be(&reg_bar->max_tx_queues);
-	max_tx_queues = ioread32be(&reg_bar->max_rx_queues);
+	max_tx_queues = ioread32be(&reg_bar->max_tx_queues);
+	max_rx_queues = ioread32be(&reg_bar->max_rx_queues);
 	/* Alloc and setup the netdev and priv */
 	dev = alloc_etherdev_mqs(sizeof(*priv), max_tx_queues, max_rx_queues);
 	if (!dev) {
-- 
2.32.0.93.g670b81a890-goog

