Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515511F7143
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 02:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgFLASc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 20:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgFLASb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 20:18:31 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E21C03E96F
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 17:18:31 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t16so2992685plo.7
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 17:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=KbKMyyrBf46AzWjBJp6RIY6HEIppW9kqp77zLWMYWs8=;
        b=oUKpb7LNVmEd4PxNV0YG/s6WhCvuu+YsSXZzLfEFn+pQ3ALIFDIw9xuQ80p9GlLLrC
         YdMfs2F2wO0vTnY3E8zpSWRv8NgMAB/7D3sFygTZazjgZ024059gUX7MqU40nA0fN4qy
         dfWFo60u7Mb0ozC0O3chyDTlW92YbUjrSWYPIemXmrBTkY8mrAnC+kMOU+miTb1o3kiL
         isupIPEl8yss5EV8lHvtMjX3NGmBycUWuYndT3ibcVQ6n5vlWKTOrA2hGEwB8nvPzLos
         PbvSVCRipY4TQ/7jDp2auXyr23TvuK0zSo6G9WawTiU0npiXmOh1H8EC4YQJfIXvdJdj
         gBIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KbKMyyrBf46AzWjBJp6RIY6HEIppW9kqp77zLWMYWs8=;
        b=fh5DC1hhw0+XKGilQr1peHsQ05sCEqVWzuZMiOzXdNjKFrLqASB1qKVjQ41N38meq/
         S/nJFBe4wdHjd0P3RYIuERD1oNFAKOoP3a3MpHu5YFl5hHU3w/lX8EzEOhx0pww8S8gs
         D+WRFQccMzcNZ8zgccxAqrDJdXq2isPhrgqOkygHrbA8LvPSH68sBDvOwDcGoAR1l0YW
         1W5SAAS80VSQ1wcS421j9q1pdxGOCLE16yakPn8fphYwHnQQLI5Qs1f+R+muIgltd0A7
         oUogETLjNdPbkH/AR7d+RZW7cQV5DX5V25Tuw6TjM+aiCdANxUGRyuPr0n3AKeMH1NYH
         be9Q==
X-Gm-Message-State: AOAM531VwFB+upBIu6OMr69WywC64ls5px6hMdN5MstxChq7wGhFa63L
        hLk47uJCLlx/ZTHeazJS0x21Zo6jAAI=
X-Google-Smtp-Source: ABdhPJxiM8UlU3M+bC0XfrEq+1Gg5jwL5XszxPWcD5BDpzja5ky5GBio0cMg2GcKQLu9RpWs7V3m6g==
X-Received: by 2002:a17:90a:4ecb:: with SMTP id v11mr10268570pjl.75.1591921110478;
        Thu, 11 Jun 2020 17:18:30 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id j17sm206897pgn.87.2020.06.11.17.18.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jun 2020 17:18:30 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: add pcie_print_link_status
Date:   Thu, 11 Jun 2020 17:18:15 -0700
Message-Id: <20200612001815.48182-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print the PCIe link information for our device.

Fixes: 77f972a7077d ("ionic: remove support for mgmt device")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 0ac6acbc5f31..2924cde440aa 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -248,6 +248,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	pci_set_master(pdev);
+	pcie_print_link_status(pdev);
 
 	err = ionic_map_bars(ionic);
 	if (err)
-- 
2.17.1

