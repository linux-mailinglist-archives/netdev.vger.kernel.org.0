Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA102C8630
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgK3OHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgK3OHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:07:14 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74709C0613D2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 06:06:28 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id r24so21842647lfm.8
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 06:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=Xd7jLYR4Ehqome+9xeBwbqcakvdUYSmUYKgnjFaM6/4=;
        b=uD9PNPaNij1WSSWD0lc+HAVuuxZrHucRuXqNCnFmVSLYTQ/NSz/0FHPLWvtXgCFMtO
         RuNeYJMc0DX1RhDpq4gUuCW/vZ/YQCgyRG4zoAVcwV5pH8XZXTXgAlLd4oQZcrRw23er
         cP+JDmQHZlDrzGLwrkyf3FSZcF77+TDtsgNo06ty5aZsjeN47zv64Jed0jsS3xFW6CrR
         KjejlJKzcNZ/g245+jRiLAFC3edExwcG283IRua8dZaKr+4QLb6fJaDjM5ZePfnzZK5k
         ZH2WiJVf+XEcId2s0+yW8FP8N16NKowDX9JtBPpSOsJnw3htVPRkQYv72bPKeVtK3RnY
         i/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=Xd7jLYR4Ehqome+9xeBwbqcakvdUYSmUYKgnjFaM6/4=;
        b=AkQNwVEBLEyZM0Uvb2cy6dKBNlnl3VJHO8Kepti74W1KDE/wK83lFIoqs3V9W8Tydt
         9GxAVJoDhkykMYKRqcBegSAYMu3bsxja8a2BKYuC6HqXrGbiGiZ12jqkmmvPmMKkg6Ip
         Dp+mSFLmltUYddt0teAZIq0sIe/vX4MNwDC1mw629nNX5sQ4jive+m629U7UGy08YkUI
         84ilwXrOcg5ixf+UQdGcL52vNZp6at7CzdEx/3CzDCYEkBL74PEEjvruyuDuXT0Pif/k
         p4dbGbG5hKeWExkxvkKfHQM2h9MH6AjWZOLzm3MoD4v4VbdUYotucPnwbHapU1AQOtpw
         5oRw==
X-Gm-Message-State: AOAM531pYKgnr4CGakz+luWYZmJ11nRJFndl4t/WEjxMtc8RxJtxUlml
        99Nm/+h41P2sbF8e3tVnpXlS8g==
X-Google-Smtp-Source: ABdhPJwoH7e61ZV9E1XYtd1P5c2+/2Lj1qpnY8b7vYqhstCmC2FA2T8cXa/xqxyfZH2HSGOczsxTkw==
X-Received: by 2002:a05:6512:6c9:: with SMTP id u9mr9293708lff.475.1606745183729;
        Mon, 30 Nov 2020 06:06:23 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v22sm2977292ljd.9.2020.11.30.06.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 06:06:22 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 0/4] net: dsa: Link aggregation support
Date:   Mon, 30 Nov 2020 15:06:06 +0100
Message-Id: <20201130140610.4018-1-tobias@waldekranz.com>
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
 net/dsa/port.c                      | 141 +++++++++++++++++
 net/dsa/slave.c                     |  83 +++++++++-
 net/dsa/switch.c                    |  49 ++++++
 net/dsa/tag_dsa.c                   |  17 +-
 15 files changed, 744 insertions(+), 16 deletions(-)

-- 
2.17.1

