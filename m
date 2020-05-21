Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680D21DD91F
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730502AbgEUVKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgEUVKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:10:52 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF47C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:10:52 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id bs4so7723645edb.6
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QX3I8TlF7tJksuVOjy8rUEM0jJDmxfXsujuNxJFHGXQ=;
        b=mMbOm+vzEpHxKLQRcwutq7DEU6jXS7l27tczAIM6o3oKjJmKNUEeAVs6h6scxFbZUU
         ZpAjBaW+/U8RUAs7f0yPnfvSqdGNgXn76kzK9hugHnp+07OmYK9+OwZy293/cG0CGCL/
         1CGYhcGtc6Mq326An+t96N7MNUUytLICvkgI0KkHaTWYtB02oWQqgvsGj05t3kHYghZH
         6OGIt8Oeb4be7LBg1r0eFzGz50fAcJkb+SmUKtM6HXiD4x+PL6uBFT1q7NpvFNdibvrh
         CkXfmLswOMlhy5K1FPEOvSSnOvphrSXz3zI08KluLFUI57bgqyIm/qui+6XlmuFXQIbk
         QpTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QX3I8TlF7tJksuVOjy8rUEM0jJDmxfXsujuNxJFHGXQ=;
        b=nocbM6tnymDudoVpvg6ZDfmDXCNaV1FALMYvERG1PWWD8swAYiTorhaadJJkhGBM7W
         JpEU0UmDPBi34sVI+bZTcCsxHYv2xAs/ZikRNX2mG9SYe0LGGmY+nVmWoCsiJX7QHRG+
         ultTGIwTe82Fk1i7+0L84PEL/q53oKEvtx4pkxdZCQZwWeif+/YQ99PmQxRf881Q0mmZ
         4K8zadtfLUoaujSgT2sk/u3HX1JsMOtrB2zNJZRodvMkpWD9sQc1+3ABINpk7X7vbr5h
         kQiTrpwzM8NwxCRdaxy8mtHkmMqHVYkalydDvFR7FN/dv4S1T/lXXc0vwx9BqBPVqLn1
         rwrw==
X-Gm-Message-State: AOAM531ZlNplXfkG5DuwG7w/41btHHt+XWq2z7W6MAgCCzd/ybwLPuPj
        zLGEQRNyO+LhsF732zYBsQc=
X-Google-Smtp-Source: ABdhPJzCeX2r1Mb6FeifLhJroWyoc1ob/hogLMvzzB58Xtcmzp72x7eB9GoW/Aa/11ZkJIWj22fm6g==
X-Received: by 2002:a50:b586:: with SMTP id a6mr564855ede.292.1590095451032;
        Thu, 21 May 2020 14:10:51 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id h8sm5797637edk.72.2020.05.21.14.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 14:10:50 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        ivecera@redhat.com, netdev@vger.kernel.org,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH RFC net-next 00/13] RX filtering for DSA switches
Date:   Fri, 22 May 2020 00:10:23 +0300
Message-Id: <20200521211036.668624-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is a WIP series whose stated goal is to allow DSA and switchdev
drivers to flood less traffic to the CPU while keeping the same level of
functionality.

The strategy is to whitelist towards the CPU only the {DMAC, VLAN} pairs
that the operating system has expressed its interest in, either due to
those being the MAC addresses of one of the switch ports, or addresses
added to our device's RX filter via calls to dev_uc_add/dev_mc_add.
Then, the traffic which is not explicitly whitelisted is not sent by the
hardware to the CPU, under the assumption that the CPU didn't ask for it
and would have dropped it anyway.

The ground for these patches were the discussions surrounding RX
filtering with switchdev in general, as well as with DSA in particular:

"[PATCH net-next 0/4] DSA: promisc on master, generic flow dissector code":
https://www.spinics.net/lists/netdev/msg651922.html
"[PATCH v3 net-next 2/2] net: dsa: felix: Allow unknown unicast traffic towards the CPU port module":
https://www.spinics.net/lists/netdev/msg634859.html
"[PATCH v3 0/2] net: core: Notify on changes to dev->promiscuity":
https://lkml.org/lkml/2019/8/29/255
LPC2019 - SwitchDev offload optimizations:
https://www.youtube.com/watch?v=B1HhxEcU7Jg

Unicast filtering comes to me as most important, and this includes
termination of MAC addresses corresponding to the network interfaces in
the system (DSA switch ports, VLAN sub-interfaces, bridge interface).
The first 4 patches use Ivan Khoronzhuk's IVDF framework for extending
network interface addresses with a Virtual ID (typically VLAN ID). This
matches DSA switches perfectly because their FDB already contains keys
of the {DMAC, VID} form.

Multicast filtering was taken and reworked from Florian Fainelli's
previous attempts, according to my own understanding of multicast
forwarding requirements of an IGMP snooping switch. This is the part
that needs the most extra work, not only in the DSA core but also in
drivers. For this reason, I've left out of this patchset anything that
has to do with driver-level configuration (since the audience is a bit
larger than usual), as I'm trying to focus more on policy for now, and
the series is already pretty huge.

Florian Fainelli (3):
  net: bridge: multicast: propagate br_mc_disabled_update() return
  net: dsa: add ability to program unicast and multicast filters for CPU
    port
  net: dsa: wire up multicast IGMP snooping attribute notification

Ivan Khoronzhuk (4):
  net: core: dev_addr_lists: add VID to device address
  net: 8021q: vlan_dev: add vid tag to addresses of uc and mc lists
  net: 8021q: vlan_dev: add vid tag for vlan device own address
  ethernet: eth: add default vid len for all ethernet kind devices

Vladimir Oltean (6):
  net: core: dev_addr_lists: export some raw __hw_addr helpers
  net: dsa: don't use switchdev_notifier_fdb_info in
    dsa_switchdev_event_work
  net: dsa: mroute: don't panic the kernel if called without the prepare
    phase
  net: bridge: add port flags for host flooding
  net: dsa: deal with new flooding port attributes from bridge
  net: dsa: treat switchdev notifications for multicast router connected
    to port

 include/linux/if_bridge.h |   3 +
 include/linux/if_vlan.h   |   2 +
 include/linux/netdevice.h |  11 ++
 include/net/dsa.h         |  17 +++
 net/8021q/Kconfig         |  12 ++
 net/8021q/vlan.c          |   3 +
 net/8021q/vlan.h          |   2 +
 net/8021q/vlan_core.c     |  25 ++++
 net/8021q/vlan_dev.c      | 102 +++++++++++---
 net/bridge/br_if.c        |  40 ++++++
 net/bridge/br_multicast.c |  21 ++-
 net/bridge/br_switchdev.c |   4 +-
 net/core/dev_addr_lists.c | 144 +++++++++++++++----
 net/dsa/Kconfig           |   1 +
 net/dsa/dsa2.c            |   6 +
 net/dsa/dsa_priv.h        |  27 +++-
 net/dsa/port.c            | 155 ++++++++++++++++----
 net/dsa/slave.c           | 288 +++++++++++++++++++++++++++++++-------
 net/dsa/switch.c          |  36 +++++
 net/ethernet/eth.c        |  12 +-
 20 files changed, 780 insertions(+), 131 deletions(-)

-- 
2.25.1

