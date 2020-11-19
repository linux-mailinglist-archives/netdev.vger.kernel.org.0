Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0C02B956F
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 15:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgKSOpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 09:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbgKSOpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 09:45:46 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117E0C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 06:45:46 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id x9so6495918ljc.7
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 06:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=k0MQYt/4B8jO35Lz1v1WOO0Dw+u3B79svRkaBDsJWrQ=;
        b=YNuKZ1CIAkYN4Ygv3EWCak7VWs4tq9aaN25fz16SYOfqmEGRhzWUfz27+W2XTTjzMl
         jQkrS4I+4XxI5RQUfBcX7gxNODLUoNj9KAbsnwJKeTC5HXHpUkiIuElQCDpAVNljrcPp
         8WsWsYJN00X1ppKRm2SV3gzw0tbHUMFHYqcOdVLPeEOvlq2d6s+PBxLPAawVRlz4/z+p
         ZhoEJP1STIYWmk5PlI4mM1BTmhRGU5C8yzyCIoGTJlOMV+fMrT35tWeC8F6Jzt2wLNsa
         4PKyfj105hYFTA9PfsNHiC9MAi4glKF2AMFWtEddToSNGbiJCrY//1VfYIOwYSFhXmih
         /SXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=k0MQYt/4B8jO35Lz1v1WOO0Dw+u3B79svRkaBDsJWrQ=;
        b=pL2czfC4u3HbLVE9GmWbhEge6ls9yRypQBUGveLmQqwW8wVWJkbbLZHZioZqj7TWD7
         fP9lUIihO6YTBepKU5TOjyWIvKQW83e22aI4VNAhG9veRzwGRj5U0Se7lqeRhmQT7NR5
         N3RZFe+HILXluxKw/iROQowxTTd+dELOjZKhnfZgbkJbiPjyL0Mf3s1MLNJmaBMEWDx2
         Vkserdo0y58J+LrlduQjmjRaHg5dg8xNsYpBUV/efMPkeNNC6ud0KNpxGgkPI/sotuib
         me/SLup2zgbDNO7jd6oIOK/970ywEszAzo/3YgkHa7PjqICL+sZThUSkL4zd+pHI5obq
         x8TA==
X-Gm-Message-State: AOAM530sFBng02jg2MCZgi89KXiCxkAr1H4epXG5uIZdE1A542aOYSC2
        TrkbSj50g5enYCFu3YeV9eM/pQ==
X-Google-Smtp-Source: ABdhPJzA5VWjZJnXjYuSwOgsEZB8rZh0jSBN+w1QJyDoHpB8CSt4Rej9WXh8O2jw7uVN04ArrxdNpw==
X-Received: by 2002:a2e:9ad0:: with SMTP id p16mr6623851ljj.424.1605797144474;
        Thu, 19 Nov 2020 06:45:44 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 123sm3993483lfe.161.2020.11.19.06.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 06:45:43 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH net-next 0/4] net: dsa: Link aggregation support
Date:   Thu, 19 Nov 2020 15:45:04 +0100
Message-Id: <20201119144508.29468-1-tobias@waldekranz.com>
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
 drivers/net/dsa/mv88e6xxx/chip.c    | 226 +++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h    |   4 +
 drivers/net/dsa/mv88e6xxx/global2.c |   8 +-
 drivers/net/dsa/mv88e6xxx/global2.h |   5 +
 drivers/net/dsa/mv88e6xxx/port.c    |  21 +++
 drivers/net/dsa/mv88e6xxx/port.h    |   5 +
 include/net/dsa.h                   |  66 ++++++++
 net/dsa/dsa.c                       |  12 +-
 net/dsa/dsa2.c                      |   3 +
 net/dsa/dsa_priv.h                  |  31 ++++
 net/dsa/port.c                      | 143 ++++++++++++++++++
 net/dsa/slave.c                     |  55 ++++++-
 net/dsa/switch.c                    |  49 ++++++
 net/dsa/tag_dsa.c                   |  17 ++-
 15 files changed, 631 insertions(+), 16 deletions(-)

-- 
2.17.1

