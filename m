Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC36A20A66C
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391024AbgFYUMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390575AbgFYUM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 16:12:28 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C491BC08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 13:12:28 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x11so3285073plo.7
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 13:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=TZkmITq0yB9yABymTgHxtBRI8stTftqyXT2Al5YTnWc=;
        b=3lrvX07GGMC6+qyl+X+ZzSpSucXNAfeUhk+IDKAHGSl+gRbwW9kkAhJlgU/DlR/6kn
         9y8KHeoykKeaAgyfqW+m60xr8FcqWslKtNHKV8vp1DXKJssK6fg0sXCLw6eQr1Mddu5h
         faWaeLq5GZnCCuwe3oGYToow1mZe/yOiC0n7O6dTwOk24O1f+jGHeZ5X+eD0l5S6pv5r
         kEtIkp9CFn+5SEfOrs4w5RfcTfpwoCLUMf+z+T4n0a9O2YHCyb9tCuegN2j7LTMOGt5/
         iQeudTFocSPR8JP+wTu+14k//dwicZNtniHlRFoh7j61I4IBP/2RCRidh8J6ntLIP8aR
         R5vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TZkmITq0yB9yABymTgHxtBRI8stTftqyXT2Al5YTnWc=;
        b=BNdaYvCBlK6rtEMK0wWCArHibIYSWHHVHR7xf+jtJ4rX/Ya1fGUj+r55TpGDEvIahs
         e8zlHJ+M9039T5P1fYKS0tHNU3f7iOqHoKOrQJul62p1bi7g3fyLhBalJvCcBrlZLAWA
         kxXmb2T4G5rOOSqJYd99LYNDUqxMeillvaeYm5kjPFxV6I2b/tG5XkUEsRqw7uavZmPB
         EhhdpNBNhdY6XM/hVinZbhJugu+IIw6KlSTld42Vtvb4tu835xvDRfs0a+cjOQzneDyJ
         Tx3KALYtH+3NpJRhnPdP6xkVzFBsPjq6GSCsJnL5TJnErWrh0f4i+klCq/s+fQLWag9G
         tiqA==
X-Gm-Message-State: AOAM532HSTp0p0LeHYpMNaJgeFri0gKYEwR64ZIvct3Dl4gG2mfQSJVM
        nuDC3slM1gEPqHCwCwtj1SJuICwTsn4MRw==
X-Google-Smtp-Source: ABdhPJwk3M1mCh8tLme3nQAeSA93Hy11AP8z9PsWBuq4HwwdvXbW+cC6fvyCXAdJFl+DK8EE9JsljA==
X-Received: by 2002:a17:902:9a49:: with SMTP id x9mr3417290plv.7.1593115948111;
        Thu, 25 Jun 2020 13:12:28 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id gp4sm9003725pjb.26.2020.06.25.13.12.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jun 2020 13:12:27 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: update the queue count on open
Date:   Thu, 25 Jun 2020 13:12:15 -0700
Message-Id: <20200625201215.57833-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let the network stack know the real number of queues that
we are using.

Fixes: 49d3b493673a ("ionic: disable the queues on link down")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index aaa00edd9d5b..62858c7afae0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1673,6 +1673,9 @@ int ionic_open(struct net_device *netdev)
 	if (err)
 		goto err_out;
 
+	netif_set_real_num_tx_queues(netdev, lif->nxqs);
+	netif_set_real_num_rx_queues(netdev, lif->nxqs);
+
 	/* don't start the queues until we have link */
 	if (netif_carrier_ok(netdev)) {
 		err = ionic_start_queues(lif);
-- 
2.17.1

