Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64732CB862
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 10:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388097AbgLBJPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 04:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388089AbgLBJPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 04:15:15 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFFCC0613D4
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 01:14:29 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id f24so2394021ljk.13
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 01:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=Ie2ld9Un8Q65LJsVCG5FgRyM1Hw+tZhVUprllDEZJk0=;
        b=Ax7MAzcAy+jRr4Y9HB0Cng7XVbQySJHYn9ZCS/a2R0cdc8blAcl5nNpVW3/sBGN6dE
         5rrYQRUGO4xEiLrzA+9R5t97LFkurG83tAEQWrjkp6kytZuQquhatxmvnfx1NroWN02Y
         EOI/nB/IG+wCav6Opodb9cPHaM5VYwkFkuATqh3JzW+8z3EP453aw61UrSOYhu+byl/W
         c7Z0zPilY1jph8oS4TgIlRYgqiJ7yPi26tRcoHsTpmNi3/8GycyQgJXWjdk4NJAXbfat
         4CjHdIcIjJgyva6NiZ3w+uekjcA7GEBOjKtmP5B5RFF0SsDUwrWM1oKdT4V5xlF0X9oi
         mxow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=Ie2ld9Un8Q65LJsVCG5FgRyM1Hw+tZhVUprllDEZJk0=;
        b=HVPWjw9rNHVhzMrkCiYPKaTaxKAef2+C9eBnXoRwwwPd8PFoyd3SoxzF5o/iU3vxnG
         Ch6p9Ct8L46Y3TN3JPTga12w207etlIf8pNIwsxmnik5CxXOKPXuhcdEXiu5jRTgzFot
         4hVdQfsSHYx+3L55Z7GFobj0SfUlkJ36UKFnXV7v4dtT7L54SIJ5aYwji0dChBoDbtoC
         IDYVKacw0UHY5XfR023ST9IxkZ8LCzjGE512aqQpml0SAsZVoATsT/wUFaXqgQM/rBEr
         +PEQYDYhYuYA/Lm9+5u9slJKkaPXnRbkUaGL4/pHvdhxiPQ4ojSvb9y24sMuxJnrSuRC
         lK9g==
X-Gm-Message-State: AOAM530AuGSzZP6MSSaBtlV/9NVcBM1OMSHTPMMvgbTm3W31v/CBznIa
        iH17v9vx2MtRESIvh2OWoMY6RA==
X-Google-Smtp-Source: ABdhPJyt/66LddJXgyhkVcQ19dIGfjeLmjF77RDFUW+t6Rm/GYrPvlyFUmi7EI8epV2nlNLIfYFmaA==
X-Received: by 2002:a2e:a543:: with SMTP id e3mr733426ljn.421.1606900466368;
        Wed, 02 Dec 2020 01:14:26 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v1sm295970lfg.252.2020.12.02.01.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 01:14:25 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 0/4] net: dsa: Link aggregation support
Date:   Wed,  2 Dec 2020 10:13:52 +0100
Message-Id: <20201202091356.24075-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Start of by adding an extra notification when adding a port to a bond,
this allows static LAGs to be offloaded using the bonding driver.

Then add the generic support required to offload link aggregates to
drivers built on top of the DSA subsystem.

Finally, implement offloading for the mv88e6xxx driver, i.e. Marvell's
LinkStreet family.

Supported LAG implementations:
- Bonding
- Team

Supported modes:
- Isolated. The LAG may be used as a regular interface outside of any
  bridge.
- Bridged. The LAG may be added to a bridge, in which case switching
  is offloaded between the LAG and any other switch ports. I.e. the
  LAG behaves just like a port from this perspective.

In bridged mode, the following is supported:
- STP filtering.
- VLAN filtering.
- Multicast filtering. The bridge correctly snoops IGMP and configures
  the proper groups if snooping is enabled. Static groups can also be
  configured. MLD seems to work, but has not been extensively tested.
- Unicast filtering. Automatic learning works. Static entries are
  _not_ supported. This will be added in a later series as it requires
  some more general refactoring in mv88e6xxx before I can test it.

v2 -> v3:
- Skip unnecessary RCU protection of the LAG device pointer, as
  suggested by Vladimir.
- Refcount LAGs with a plain refcount_t instead of `struct kref`, as
  suggested by Vladimir.

v1 -> v2:
- Allocate LAGs from a static pool to avoid late errors under memory
  pressure, as suggested by Andrew.

RFC -> v1:
- Properly propagate MDB operations.
- Support for bonding in addition to team.
- Fixed a locking bug in mv88e6xxx.
- Make sure ports are disabled-by-default in mv88e6xxx.
- Support for both DSA and EDSA tagging.

Tobias Waldekranz (4):
  net: bonding: Notify ports about their initial state
  net: dsa: Link aggregation support
  net: dsa: mv88e6xxx: Link aggregation support
  net: dsa: tag_dsa: Support reception of packets from LAG devices

 drivers/net/bonding/bond_main.c     |   2 +
 drivers/net/dsa/mv88e6xxx/chip.c    | 234 +++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h    |   4 +
 drivers/net/dsa/mv88e6xxx/global2.c |   8 +-
 drivers/net/dsa/mv88e6xxx/global2.h |   5 +
 drivers/net/dsa/mv88e6xxx/port.c    |  21 +++
 drivers/net/dsa/mv88e6xxx/port.h    |   5 +
 include/net/dsa.h                   |  97 ++++++++++++
 net/dsa/dsa.c                       |  12 +-
 net/dsa/dsa2.c                      |  51 ++++++
 net/dsa/dsa_priv.h                  |  31 ++++
 net/dsa/port.c                      | 132 ++++++++++++++++
 net/dsa/slave.c                     |  83 +++++++++-
 net/dsa/switch.c                    |  49 ++++++
 net/dsa/tag_dsa.c                   |  17 +-
 15 files changed, 735 insertions(+), 16 deletions(-)

-- 
2.17.1

