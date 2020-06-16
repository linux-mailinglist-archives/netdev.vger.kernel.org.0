Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B971FB5A1
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 17:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbgFPPGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 11:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729378AbgFPPGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 11:06:40 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECFDC061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 08:06:39 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id bh7so8508375plb.11
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 08:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=zHFhO3wE4Iz0mUbiW0rYQ87K+JCO3k/FJgNtWhMhmy0=;
        b=gasyEVA4yBYIZv1unt4gOquCVgSf72Aodq+7HsWJnXozxcqTaLLgnmUSs4BHcvlMSw
         FW2/FexVct9jGQw78i3IqnGKo4Sy4xelB+6J/GlIr1mBfqP6ohVtMTCDUmdE3hNfvc4E
         mdC0dRbEq8FD9Pov8CjP8Rzxn8Ub9SdPD2qWfZuIzhT1s9qgb19z1hV1g/x0hSsSDdFQ
         6dOl5SuNnDqTs6mS72NkhYQWaETkmZr5ZdHOXl3kAJ3QJIsd/amGRIhG1LerG6GjZIR+
         fppGSM9IS86DOIvtW8uuXYnVWjncsMqP/Pgz7i+F+rXoKhikFNBaMGy7UVa9r9UvdM59
         hWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zHFhO3wE4Iz0mUbiW0rYQ87K+JCO3k/FJgNtWhMhmy0=;
        b=F4qZJi/5ATHlZSn+GrFF97Qeb4GBwK1taYOnj4NqJq9v3XsZdADbip/PdXoSmhi7By
         weP9LWo/8/EKCWjnGB9v/wFgGI7pV1ryy2syRCBn4RLvOc4c2aIXb//loEq2bqesafTH
         aiEvTkyon9T5Wqi6cDE7aci6+4gy1PmCmlaX9duV6e85blMPh6j68jJbwXio0nrqhgWh
         kGFoH2J7QX8uBxzf293bnctFtWX3vm7ds7gldz+dluW5e63sqcBbTDHv5Fomhh/h7JQL
         PdLgtJPvRBuvDrceSGbuSMUUAxe1Jkr3IclrmQHQ/aOWaiqYZSkxDPt2k/Qi5YnSrFSo
         +9qw==
X-Gm-Message-State: AOAM533Quvy0HG/oHqoxvCx2i52OzL5A+NKY0FDgekzX69lNpZhrxzWP
        3GOPz1VwonbyEocvwPmVlXPnH6EShos=
X-Google-Smtp-Source: ABdhPJwp0oq9uUd4UOB2yhq+thLp4Tgf0q1C3tb10+G4K6tpneC0xeRHf9NZCCSOcI63Wn3xkL10SA==
X-Received: by 2002:a17:902:7247:: with SMTP id c7mr2495261pll.103.1592319999059;
        Tue, 16 Jun 2020 08:06:39 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n69sm3383276pjc.25.2020.06.16.08.06.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jun 2020 08:06:38 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: export features for vlans to use
Date:   Tue, 16 Jun 2020 08:06:26 -0700
Message-Id: <20200616150626.42738-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set up vlan_features for use by any vlans above us.

Fixes: beead698b173 ("ionic: Add the basic NDO callbacks for netdev support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index bfadc4934702..8f29ef133743 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1246,6 +1246,7 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 
 	netdev->hw_features |= netdev->hw_enc_features;
 	netdev->features |= netdev->hw_features;
+	netdev->vlan_features |= netdev->features & ~NETIF_F_VLAN_FEATURES;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT |
 			      IFF_LIVE_ADDR_CHANGE;
-- 
2.17.1

