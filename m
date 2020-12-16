Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BABE2DC3A8
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 17:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgLPQCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 11:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgLPQCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 11:02:25 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99744C061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:01:44 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id u18so49614700lfd.9
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=ikLPeuPlMCDoDblTFvewyJmg+Cssxk2lXSHgkPgxJ8s=;
        b=BkHwcKXhU6K0QCrm7WKeC49zcQv7441GYtZ6wyB/kK8G72rbCS9YV5/QEzeomEtrCv
         OpqqZb6Md+sspXcpU2sqE+tRRaXBexKxE0qs/AcurHut3zuXckOW4EiU1OHuPZkPeWW0
         y8ET3XuqcXlgSF17ynD0qGJVTsea0/CWuPbTMh/yEeq6l3KyxrVH+cCmq1eQ651GI7cw
         gVSb5HIUWzqOvUSAwG5+zYBzejlUgblr8Y3ozX3imuWa1CQ6fbnsdRlKlOG7s+eEtw0C
         BVZD+R+3SLldEgk9vvqBA5mUVIf7qWuLYSjmbCslmuFxUrtUXt2chwwdR31cSasm2gdn
         rnBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=ikLPeuPlMCDoDblTFvewyJmg+Cssxk2lXSHgkPgxJ8s=;
        b=qWcYcMKZdkZCLIwOkqkHySbP0Jij/0LLTqt9xymUtM4NzxWeM1hWSso0auow0PVkJ5
         EaGviAzT9WBe/3S218do9+lK+uPe9+x61QS9QTAFwiBqrpI6jyPfSwmzk1bUHQPNVZS3
         Z4rBB14FMbn3hjHvpBWdS+EBEsI1e0KGrA8/r8eY5s53mGPVgmrJCsHGkrUjWTczj0g/
         xRtRML1KNx2kcI4AEUhu63ua6MMCbsZX9OX37wA2FFJ+mY9gl77CQQDZoi5ruxd3mR1F
         jCZcZpxAvJJ22ea8pbpwKXFcPRlw5vDWaCWNFmsLdNr3OwgL+BK+DEH3KVANLXz9m7Yp
         wjVQ==
X-Gm-Message-State: AOAM5311yZuKnvi/h/Ycz4aKNSkb2J27OLl9YixRXBrfBILDscoOXotI
        6HppdxDLIck/1qWop0I2VsbPwA==
X-Google-Smtp-Source: ABdhPJxhJ4pTNzkGQmIFmpAr0ITVRx13gFLJ6+wZm29YUW8ei5zijpDptapWebRJOdGH3OKr/M2IAw==
X-Received: by 2002:a19:5f5d:: with SMTP id a29mr12735126lfj.212.1608134501952;
        Wed, 16 Dec 2020 08:01:41 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id e25sm275877lfc.40.2020.12.16.08.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 08:01:41 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH v4 net-next 0/5] net: dsa: Link aggregation support
Date:   Wed, 16 Dec 2020 17:00:51 +0100
Message-Id: <20201216160056.27526-1-tobias@waldekranz.com>
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

v3 -> v4:
- Remove `struct dsa_lag`, leaving only a linear mapping to/from
  ID/netdev that drivers can opt-in to.
- Always fallback to a software LAG if offloading is not possible.
- mv88e6xxx: Do not offload unless the LAG mode matches what the
  hardware can do (hash based balancing).

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

Tobias Waldekranz (5):
  net: bonding: Notify ports about their initial state
  net: dsa: Don't offload port attributes on standalone ports
  net: dsa: Link aggregation support
  net: dsa: mv88e6xxx: Link aggregation support
  net: dsa: tag_dsa: Support reception of packets from LAG devices

 drivers/net/bonding/bond_main.c     |   2 +
 drivers/net/dsa/mv88e6xxx/chip.c    | 298 +++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/global2.c |   8 +-
 drivers/net/dsa/mv88e6xxx/global2.h |   5 +
 drivers/net/dsa/mv88e6xxx/port.c    |  21 ++
 drivers/net/dsa/mv88e6xxx/port.h    |   5 +
 include/net/dsa.h                   |  60 ++++++
 net/dsa/dsa.c                       |  12 +-
 net/dsa/dsa2.c                      |  74 +++++++
 net/dsa/dsa_priv.h                  |  36 ++++
 net/dsa/port.c                      |  79 ++++++++
 net/dsa/slave.c                     |  71 ++++++-
 net/dsa/switch.c                    |  50 +++++
 net/dsa/tag_dsa.c                   |  17 +-
 14 files changed, 722 insertions(+), 16 deletions(-)

-- 
2.17.1

