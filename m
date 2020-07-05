Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87034214DF0
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 18:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgGEQQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 12:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbgGEQQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 12:16:57 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F3AC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 09:16:57 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id e22so32423408edq.8
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 09:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bUX/WnNXUWDVHm+m6XYGrdqmfw1d62Sd8NDDECwdtv4=;
        b=hK79qi33TitEdfHdQgLsgtstQWcXE/07ajR8uPyAQexxzn+xu+v/75oSSg2mG6H5xF
         bB4yruW/OeMyNV0SZHBjuCQAlV60cfw8xBRi7QNkEcS3Hr+2oc/HT+mS6qNc7sUWxfs7
         HVzpW4TKA2khmKxHaUYAQinMbKIPQnjalngq7ISunwcETjD4EimFsX9q+MtM/brsouVJ
         RmKqj0p6glop39wXUzlBAN7dA/2nAY5jIBeApIFTgcg1Et4Y9NX/tQpMMc+dolB7JSHO
         oBEYqp8o3I4e2hi9aNb8qo/THBE5ZVzVBrQKlaV9RsrpJshNM8yvV1MJ/+f5ya/fIMjj
         zSdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bUX/WnNXUWDVHm+m6XYGrdqmfw1d62Sd8NDDECwdtv4=;
        b=jDCzqdfnLYvo9IMqZfQr5zzQ8tFG2GA3iz+k7HGIXyNqR0c8rmwE2WsJhWmUp895E5
         wMB4ap4EmBvXqDkHgGcr/ZX0yAyZhjXy7ByxHhYyAb+67k3LMiuFL2LMV2S3ZXSXlA13
         leYQ6rAmBHPHOtdvFo5U3/e0vJpGJPlrKEwehr+e6z2tcncJPVfkNo9EbmjLd69tjCGN
         RIQjeZA5oObOgFCJkKVgdYzFcmfylEYoLbL2INIerelrWZC4HCS++OnBpBvhUf59j0OR
         l+bGU0GY6Q/AF3RHrUWrDU9eexxd0H4pBo1Bl73Zw4CXoe6IbIhoqeNbti5+0lVyOT/P
         V3TQ==
X-Gm-Message-State: AOAM530oMCESoXOxBfakkUu2K4nHnlDGcuAx6c48EBYUr9KQeRqMBR7d
        Kzl/RxNqdRcC+njlByLvcwxNoEEN
X-Google-Smtp-Source: ABdhPJyasdOitk1HIBqKFlFfC4iQ39nmg9pZOnGRqqDQY6do+oRwyyId8bU1ry7clncyqMOiP2cSig==
X-Received: by 2002:a05:6402:16c7:: with SMTP id r7mr33302866edx.288.1593965815900;
        Sun, 05 Jul 2020 09:16:55 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id x4sm14406126eju.2.2020.07.05.09.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 09:16:55 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH v3 net-next 0/6] Phylink integration improvements for Felix DSA driver
Date:   Sun,  5 Jul 2020 19:16:20 +0300
Message-Id: <20200705161626.3797968-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is an overhaul of the Felix switch driver's phylink operations.

Patches 1, 3, 4 and 5 are cleanup, patch 2 is adding a new feature and
and patch 6 is adaptation to the new format of an existing phylink API
(mac_link_up).

Changes since v2:
- Replaced "PHYLINK" with "phylink".
- Rewrote commit message of patch 5/6.

Changes since v1:
- Now using phy_clear_bits and phy_set_bits instead of plain writes to
  MII_BMCR. This combines former patches 1/7 and 6/7 into a single new
  patch 1/6.
- Updated commit message of patch 5/6.

Vladimir Oltean (6):
  net: dsa: felix: clarify the intention of writes to MII_BMCR
  net: dsa: felix: support half-duplex link modes
  net: dsa: felix: unconditionally configure MAC speed to 1000Mbps
  net: dsa: felix: set proper pause frame timers based on link speed
  net: dsa: felix: delete .phylink_mac_an_restart code
  net: dsa: felix: use resolved link config in mac_link_up()

 drivers/net/dsa/ocelot/felix.c         | 108 +++++----
 drivers/net/dsa/ocelot/felix.h         |  11 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 298 ++++++++++++-------------
 include/linux/fsl/enetc_mdio.h         |   1 +
 4 files changed, 213 insertions(+), 205 deletions(-)

-- 
2.25.1

