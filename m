Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D9B334907
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 21:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhCJUlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 15:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbhCJUlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 15:41:32 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AAEC061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 12:41:32 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so7896606pjq.5
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 12:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BwgXnGR0N+gUP78VfMHMc3cKJ2gfkEcBbBaReQaadHA=;
        b=I5frcIjUw9EYsfKbvnPMSEi6lDyscevVPZCOUSAveLygdpuhu2ELzWRSB+Wsvg54k4
         Dz9C9Pquw683s21E8NXH6ogFbEe+5JuOBcRnQ/+HIWoxhCcn+pQ8GAOnIokrJli9lYw5
         A9b5J5H6U+pD0KD/NBy2/Cok+e8NsY6vVoCVMFtqWhVJhEX0chau607iwfkpYL0pCV8N
         S8Dxc9xF7RXvv9s5bUTy8aGiFZexMYzkEDNg5BzXVgxGJjLDKZKmcdmd0ClMhIHNA4Tk
         a99LdGHl4Lg2sEwYflXm5m2ccNAb8RAvB6Z+zsIKNGfXeLn55Obs5Vw4vUADPbbsKZyU
         NXYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BwgXnGR0N+gUP78VfMHMc3cKJ2gfkEcBbBaReQaadHA=;
        b=epUOtqac5dY65yl9G3l9HUJUPg7+ggtaQ1Au7O63Fwr3nSyKUvP9LddGIVxaNF3Vmr
         W1M9rH7AV3yg00CceWHlmEGLfbNL6qF2EqYwaXYuwdCAcmCmCAFXECZ0qbPldXTWjZaL
         XAZ7r9/zuhCwwg0v0VyIuB/u6Y1h94TWK7H6iklfhd9vWHnpKiBS77LlEny7bNav34/P
         ZkqgFxxn+7T9OI5WxVvlk/V0I8yJWEB7D+f57SXR70E/QDaNUI/vKof0nwopUcLhVagT
         NhVkHLfI/zYppFNMTnGo+KfE2TkNHGl3yiiRazGCyf7t3cxuRDg/mRRLl5I3hZUFRw7u
         jvDQ==
X-Gm-Message-State: AOAM532B3HdkRgEuS2XTlGTXpNrwrj858lR17FqDS3JRaaFoh1W10ELQ
        3xHSxXWWVo8LirsFn/XpiqkePeMyBuM=
X-Google-Smtp-Source: ABdhPJyoXAdHUi4YqMWIgXVsbL6N51sULRIbciwKMc/whQYR1vC9yZZ0rHbf8IXSacJHoJLvQYtSXA==
X-Received: by 2002:a17:90b:1007:: with SMTP id gm7mr5400993pjb.17.1615408891289;
        Wed, 10 Mar 2021 12:41:31 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 1sm370213pfh.90.2021.03.10.12.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 12:41:30 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, kuba@kernel.org, davem@davemloft.net
Subject: [PATCH net 0/3] net: phy: broadcom: Suspend fixes
Date:   Wed, 10 Mar 2021 12:41:03 -0800
Message-Id: <20210310204106.2767772-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This patch series fixes the suspend entry for BCM54810 and BCM54811 PHYs
which can be put into an incorrect state depending on the timing of the
BMCR.PDOWN write and essentially not achieve the desired power savings.

In addition, there is a correctness change added that waits 40us upon
clearing the BMCR.PDOWN bit per the datasheet information.

The BCM5464 PHY entry is not changed since I do no have hardware to test
this on, however it could be switched to the non read/modify/write
version of the suspend routine if necessary.

Florian Fainelli (3):
  net: phy: broadcom: Add power down exit reset state delay
  net: phy: broadcom: Only set BMCR.PDOWN to suspend
  net: phy: broadcom: Use corrected suspend for BCM54811

 drivers/net/phy/broadcom.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

-- 
2.25.1

