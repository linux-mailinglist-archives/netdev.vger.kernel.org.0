Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD5B2F46C1
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 09:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbhAMIoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 03:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbhAMIoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 03:44:23 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EFCC061794
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 00:43:43 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id v67so1602683lfa.0
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 00:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=JrPBS0zJD7+lalmOwJEn9u18RSbGdCouKuN9XZPvKCc=;
        b=WHTWuiDbhzHrbQrg/k4uoHdsuTIakK+6oUV2Nna95wIu/qutbc8y2zsDoklRPN2wxn
         5WwYy99YoTTR+1Qg2i4a1/7cni1iPDTvbh01CJXhesvUjZ+vgZy0mR0s0W/PD3B2rAEU
         AYFHU0utsQcNLc8I7NH5q4IDof8svp7ZYlVGWFy1eCNVoOtmLJnPV0H3YtPKBjdo6Nw2
         u6bKLXhB91ba9ZKPBMG/LdTUshGaY7h3HBu2xsE+DjQWfJ0ANykyjpmf4sn26Gz6cf7E
         R3Uob33e6iNv8UqerySwEIgECxlBxjUMwwJCdF2S8+iIGeE3yPgkRHX8JoGHyJ8RN4om
         v0eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=JrPBS0zJD7+lalmOwJEn9u18RSbGdCouKuN9XZPvKCc=;
        b=O0xfY5sY7t1aEhqEjnZBfm87ma0dUjuVwyJSwOytgGcg7kMT0TeRepAmb3jkBtEOEU
         AMazieAOrlp/DKaJ5EFL28G60Ae88D+Rm7rOLSUgKysLZQgmfDKD9ktpmrqyxXBemTaq
         FJmYVynfSiiqhLtfMKOuMXXGVG5MC6rl3J4UEBgRHQ6S5tMbG4uLRguGJKntLtPLNGje
         UYVJ6nlsbd1n4i10CYkb3GITSYn8gbU9OCUO7nYKXykH7fHyHaTeIq1R0nEk3fTPMB0Y
         Slgf4LpKo3fjUOSx/mp34l02wbu2g9OZj3RA17ze3a1AUX5EPxbtwpMlMe9EFQc9Z+5V
         3FQw==
X-Gm-Message-State: AOAM532HKz31Qf6rGBgMuUa2P8aQLKYSLZstktPphJWM1eivja39FBe/
        H/QfelIAxjlhieuRSu/c43RYVA==
X-Google-Smtp-Source: ABdhPJzhcAA6yBgNMFenQ5O5bSQZk6x2Sk6OAVEVrHA3JWyjSWXAAA/CUK3MWycw/40MQGiXDMEnNA==
X-Received: by 2002:a19:8214:: with SMTP id e20mr417418lfd.16.1610527421539;
        Wed, 13 Jan 2021 00:43:41 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id u14sm137027lfk.108.2021.01.13.00.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 00:43:37 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH v5 net-next 0/5] net: dsa: Link aggregation support
Date:   Wed, 13 Jan 2021 09:42:50 +0100
Message-Id: <20210113084255.22675-1-tobias@waldekranz.com>
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

v4 -> v5:
- Cleanup PVT configuration for LAGed ports in mv88e6xxx (Vladimir)
- Document dsa_lag_{map,unmap} (Vladimir)

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
 drivers/net/dsa/mv88e6xxx/chip.c    | 296 +++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/global2.c |   8 +-
 drivers/net/dsa/mv88e6xxx/global2.h |   5 +
 drivers/net/dsa/mv88e6xxx/port.c    |  21 ++
 drivers/net/dsa/mv88e6xxx/port.h    |   5 +
 include/net/dsa.h                   |  60 ++++++
 net/dsa/dsa.c                       |  12 +-
 net/dsa/dsa2.c                      |  93 +++++++++
 net/dsa/dsa_priv.h                  |  36 ++++
 net/dsa/port.c                      |  79 ++++++++
 net/dsa/slave.c                     |  71 ++++++-
 net/dsa/switch.c                    |  50 +++++
 net/dsa/tag_dsa.c                   |  17 +-
 14 files changed, 742 insertions(+), 13 deletions(-)

-- 
2.17.1

