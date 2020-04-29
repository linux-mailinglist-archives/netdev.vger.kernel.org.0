Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8941BE794
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgD2Tqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726456AbgD2Tqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:46:35 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B768C03C1AE;
        Wed, 29 Apr 2020 12:46:35 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 18so1575109pfx.6;
        Wed, 29 Apr 2020 12:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Jasr6jlZgCzqBOuA5EUCTCY8i3t2aut5HXZlE2l+ixA=;
        b=V5Rsj6ogWUsnxpcbrNBduosMFpgn/mqOzZyU41YO7+hJjMaILBQDYl8/3W+pwQBVLW
         mF1kFlWOaA1lB28nvhuA6RCyhaJb7EYyBEEG7cqnb8LR3yL6ND8ieRjn/Zl/BnWvIFzE
         tKkEqq70tzoGYRLKjD7EVBCIHQYQgcR6KKwtzuFEGMFNjwzDWVp4uvrEVC8STfCq5l5h
         dxBzCbQEyAeZ2NCGMMZPhu7gATryqlmkI0monwxKI8mqjHSESR6Par1Rx5gEJ/K/8U7k
         /mVA/Qirfx9zVaJuJkeCG+BdmBM9zsPEaPV/wojTeyGDn5LDdgDxttaSayGncSVeC6Q9
         0oRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Jasr6jlZgCzqBOuA5EUCTCY8i3t2aut5HXZlE2l+ixA=;
        b=gjdkM0hgImXWGmBBLNXiGUkaGVyi0t9jRyjZqHlBycKCN0pusD1M+14S3/qWWqpjEN
         nnLBxmzoboM6Y2oylg6g3WBWeyFpNGcOpbZKgOn50OtdG4e25PRRupsWcl+EaUH1CRTq
         3yVlXyo9/sMvp1LMCmRpLIIXpQl3jMjj9kJ/ZxxwTM2fo1Gy/DWj0ORQjvhS9dcP/HDd
         Jd8V0T6/Eh+1fCCHNWYEZ/q/NEZFPkqCKwP2V6vXW4uL/cXByGa/BXG+XbP+dQdHAHR/
         mOwQDQB2UDSpYocf4fY07xuCfxQHUuvW5C/odwOlUc40s4dRL94ne4H+/pCyGj3vTps0
         8+0Q==
X-Gm-Message-State: AGi0PuYgdvM29/ZVGyZZ/QAGZFr2+N2pw6LVBpH/0DfFZ9eubJLk+QDZ
        c8CnPZbSxHo201jS9AYayAI=
X-Google-Smtp-Source: APiQypLNPyaOVHptLXLwofZRhTyh5Co3/5V4oGBIpBOmhMKLW9FtjbmEsf+iMFy9tGKjI1iWiBdT2Q==
X-Received: by 2002:a62:35c3:: with SMTP id c186mr13328125pfa.261.1588189594608;
        Wed, 29 Apr 2020 12:46:34 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z15sm87956pjt.20.2020.04.29.12.46.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2020 12:46:33 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 0/7] net: bcmgenet: add support for Wake on Filter
Date:   Wed, 29 Apr 2020 12:45:45 -0700
Message-Id: <1588189552-899-1-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit set adds support for waking from 'standby' using a
Rx Network Flow Classification filter specified with ethtool.

The first two commits are bug fixes that should be applied to the
stable branches, but are included in this patch set to reduce merge
conflicts that might occur if not applied before the other commits
in this set.

The next commit consolidates WoL clock managment as a part of the
overall WoL configuration.

The next commit restores a set of functions that were removed from
the driver just prior to the 4.9 kernel release.

The following commit relocates the functions in the file to prevent
the need for additional forward declarations.

Next, support for the Rx Network Flow Classification interface of
ethtool is added.

Finally, support for the WAKE_FILTER wol method is added.

Doug Berger (7):
  net: bcmgenet: set Rx mode before starting netif
  net: bcmgenet: Fix WoL with password after deep sleep
  net: bcmgenet: move clk_wol management to bcmgenet_wol
  Revert "net: bcmgenet: remove unused function in bcmgenet.c"
  net: bcmgenet: code movement
  net: bcmgenet: add support for ethtool rxnfc flows
  net: bcmgenet: add WAKE_FILTER support

 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 673 +++++++++++++++++++--
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |  21 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |  90 ++-
 3 files changed, 708 insertions(+), 76 deletions(-)

-- 
2.7.4
