Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABFB1BE801
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgD2UCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgD2UCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:02:11 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5A0C03C1AE;
        Wed, 29 Apr 2020 13:02:11 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a7so1196825pju.2;
        Wed, 29 Apr 2020 13:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FbKgYhNUuDOHJsHnW/KP1GDdDFu/iaKsEDkt0G2dvIM=;
        b=PQJK8PYa3TgWlIlaOjhepDfffncYsNJM9d7nrGNG1YF74plyvZOHcwJF7i/cBAfit2
         5qFNSGz9r5dsnXtEYnME3KPa7PnDIffdDqyyO3Cz+QmAjyIzMOxexw+Vc9Q8GLJz7wUw
         TAi8oFs8gugm7P1Dl1rUDnP6Efeld1Va72gSTlTyiEdnXhCEexc4iQhBTbvbK9yp4vx8
         p/hM42zhRZ+/GyuFWqJeDRyS/teI3rGX2O+ReuPlN5zIDMEVSjBhDsZqFSCOVT7+lrhR
         1IlxSsZIsmBHkbfaAPal/IXJLAVyhA/rbc46+COdLzcXppIOaO8oOrVEuDgocdQIUBER
         6LGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FbKgYhNUuDOHJsHnW/KP1GDdDFu/iaKsEDkt0G2dvIM=;
        b=HXUah+S/caLEAVJD40CoZMFKZp1Z9mxDSn3Ndp/5n9PqM1Z3lUQGw9KG4gL0IK27DQ
         qlDdRRTSTNIqpT9HhWpC7diXvcMgjCvyDtLZQGl10Y8CJ65EwylL8vYbSA17OwClKrLu
         WGSycxO6YVR7ZDIJftKUzPZyNdwE/AwnxB+ZMxyavfxkBZv+hxw8M5sz3hB2w+L47XlQ
         6ThTVmKZSASQ48fokKg/yESAk42PJEe1dbhfxPd5VMLwHswrDM/Ys2VviAvsV1nZr0z8
         B5O7Z12F4UqPxIdHErIJJCDsJugEf5O2BR7S2R/BVEKQ4gV4xEUYx3Iw3Fz7mId1yFz1
         Wm+A==
X-Gm-Message-State: AGi0Pub2YQyLryXJI2OeDt49G7k7mThQR61aAaPnIz+VNN/P78ypkBIG
        o2vHHBbj5VQwcTUDXc5EY74=
X-Google-Smtp-Source: APiQypLd7oTlojrgKsENfngJ6kgBaUMRvE7QpUxCW/jUWLZXE09y+Qavjl2CYK9Uj4/lIYVdOn5qMA==
X-Received: by 2002:a17:902:7d98:: with SMTP id a24mr24166plm.97.1588190530612;
        Wed, 29 Apr 2020 13:02:10 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r128sm1705817pfc.141.2020.04.29.13.02.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2020 13:02:09 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next v2 0/7] net: bcmgenet: add support for Wake on Filter
Date:   Wed, 29 Apr 2020 13:01:59 -0700
Message-Id: <1588190526-2082-1-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Changes in v2:
	Corrected Signed-off-by for commit 3/7.

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

