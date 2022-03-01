Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFAA4C88C7
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 11:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbiCAKEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 05:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbiCAKEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 05:04:32 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417838BF2C
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 02:03:49 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id j15so25921155lfe.11
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 02:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=1yqD4KQaM9b/j4qTrGplWK9SeozZApe70PduPs9Vk3k=;
        b=ok+9qxMt9502Oui1Sb99TSBc1nMun/S4I+2zm9uMBsy9S2ZWqO/7/Wdh7OkhImeF8B
         TF/J4GXLY3GeZKzuF/0jIH4/jxCxVZxOfqfCdfARMS462dxwd5UVXMkRJVr62Z2gxcgB
         iopiSpgnOk6Nk7MXlQBCPGh1XpBAhDHzWvZzZif9A9V0oh1PS6qhhAh8X2w2tA9nrwR0
         Ua1iyFST+99T1dDsWxCgqJeaeIt4wpUNMJTd+Gl2Z0iF2aJ6E7UdHkub7bDRpT86Cu5c
         ZQkWSItIfktnccjGPegT9KTh3D/8Qin3tqiCI0SDIRZ3qvAQ3vZ8dEm7cyDqofHrjuFk
         Hzbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=1yqD4KQaM9b/j4qTrGplWK9SeozZApe70PduPs9Vk3k=;
        b=SOLbL8XOwxFzEtwlEHrhVZJpzh7W/ypBVc8IiVJZsKPQC/napW5W+uZdAy3Seoeh7m
         /oJ/u/EdoPWWLzAEBAD0XqsRYU2TGW0xPobk+MVcA/GOyOaBrGmbqVE0/6ISL2mOeRfA
         Vaqy1feqD4GXLo4B9ip1989GTC9jwu8SOOnZREdbQZElUBd+SNTKc7w1AJ746HpJqDek
         VyKmw4LxxGqTolvrw9RAnQSoA+KwgmQS4WmrLwYYl+9JfQp9MhE6KJfzKG8pnnRJxpwZ
         qPr2FmcKh4o8eN029Lz7kJXsD41XN0/hazYAqvpZ5tUXYG1UI1ZPqtA/rbTl5Rma43Ig
         QGPA==
X-Gm-Message-State: AOAM531R0UVidG03re6AsCXBhJ8Xd+PvwtGDINO/oXlKhYw1p9XuYzFD
        hqiLK/vpdWT1fIYcMjGrnjjUwO9yQ2wNn2wI
X-Google-Smtp-Source: ABdhPJyZkqkffd6OzcKZDgXSOmBna7OCxMtSnaz/N5ibfBd4pawWA0csNQynqxC9BUFtF+f3ZljV7A==
X-Received: by 2002:a05:6512:3caa:b0:443:7e66:b98a with SMTP id h42-20020a0565123caa00b004437e66b98amr15570936lfv.169.1646129027199;
        Tue, 01 Mar 2022 02:03:47 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id s27-20020a05651c049b00b002460fd4252asm1826822ljc.100.2022.03.01.02.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 02:03:46 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: [PATCH v2 net-next 00/10] net: bridge: Multiple Spanning Trees
Date:   Tue,  1 Mar 2022 11:03:11 +0100
Message-Id: <20220301100321.951175-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bridge has had per-VLAN STP support for a while now, since:

https://lore.kernel.org/netdev/20200124114022.10883-1-nikolay@cumulusnetworks.com/

The current implementation has some problems:

- The mapping from VLAN to STP state is fixed as 1:1, i.e. each VLAN
  is managed independently. This is awkward from an MSTP (802.1Q-2018,
  Clause 13.5) point of view, where the model is that multiple VLANs
  are grouped into MST instances.

  Because of the way that the standard is written, presumably, this is
  also reflected in hardware implementations. It is not uncommon for a
  switch to support the full 4k range of VIDs, but that the pool of
  MST instances is much smaller. Some examples:

  Marvell LinkStreet (mv88e6xxx): 4k VLANs, but only 64 MSTIs
  Marvell Prestera: 4k VLANs, but only 128 MSTIs
  Microchip SparX-5i: 4k VLANs, but only 128 MSTIs

- By default, the feature is enabled, and there is no way to disable
  it. This makes it hard to add offloading in a backwards compatible
  way, since any underlying switchdevs have no way to refuse the
  function if the hardware does not support it

- The port-global STP state has precedence over per-VLAN states. In
  MSTP, as far as I understand it, all VLANs will use the common
  spanning tree (CST) by default - through traffic engineering you can
  then optimize your network to group subsets of VLANs to use
  different trees (MSTI). To my understanding, the way this is
  typically managed in silicon is roughly:

  Incoming packet:
  .----.----.--------------.----.-------------
  | DA | SA | 802.1Q VID=X | ET | Payload ...
  '----'----'--------------'----'-------------
                        |
                        '->|\     .----------------------------.
                           | +--> | VID | Members | ... | MSTI |
                   PVID -->|/     |-----|---------|-----|------|
                                  |   1 | 0001001 | ... |    0 |
                                  |   2 | 0001010 | ... |   10 |
                                  |   3 | 0001100 | ... |   10 |
                                  '----------------------------'
                                                             |
                               .-----------------------------'
                               |  .------------------------.
                               '->| MSTI | Fwding | Lrning |
                                  |------|--------|--------|
                                  |    0 | 111110 | 111110 |
                                  |   10 | 110111 | 110111 |
                                  '------------------------'

  What this is trying to show is that the STP state (whether MSTP is
  used, or ye olde STP) is always accessed via the VLAN table. If STP
  is running, all MSTI pointers in that table will reference the same
  index in the STP stable - if MSTP is running, some VLANs may point
  to other trees (like in this example).

  The fact that in the Linux bridge, the global state (think: index 0
  in most hardware implementations) is supposed to override the
  per-VLAN state, is very awkward to offload. In effect, this means
  that when the global state changes to blocking, drivers will have to
  iterate over all MSTIs in use, and alter them all to match. This
  also means that you have to cache whether the hardware state is
  currently tracking the global state or the per-VLAN state. In the
  first case, you also have to cache the per-VLAN state so that you
  can restore it if the global state transitions back to forwarding.

This series adds a new mst_enable bridge setting (as suggested by Nik)
that can only be changed when no VLANs are configured on the
bridge. Enabling this mode has the following effect:

- The port-global STP state is used to represent the CST (Common
  Spanning Tree) (1/10)

- Ingress STP filtering is deferred until the frame's VLAN has been
  resolved (1/10)

- The preexisting per-VLAN states can no longer be controlled directly
  (1/10). They are instead placed under the MST module's control,
  which is managed using a new netlink interface (described in 3/10)

- VLANs can br mapped to MSTIs in an arbitrary M:N fashion, using a
  new global VLAN option (2/10)

4-5/10 adds switchdev notifications so that a driver can track VID to
MSTI mappings and MST port states.

An offloading implementation is this provided for mv88e6xxx.

A proposal for the corresponding iproute2 interface is available here:

https://github.com/wkz/iproute2/tree/mst

Tobias Waldekranz (10):
  net: bridge: mst: Multiple Spanning Tree (MST) mode
  net: bridge: mst: Allow changing a VLAN's MSTI
  net: bridge: mst: Support setting and reporting MST port states
  net: bridge: mst: Notify switchdev drivers of VLAN MSTI migrations
  net: bridge: mst: Notify switchdev drivers of MST state changes
  net: dsa: Pass VLAN MSTI migration notifications to driver
  net: dsa: Pass MST state changes to driver
  net: dsa: mv88e6xxx: Disentangle STU from VTU
  net: dsa: mv88e6xxx: Export STU as devlink region
  net: dsa: mv88e6xxx: MST Offloading

 drivers/net/dsa/mv88e6xxx/chip.c        | 232 ++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h        |  38 +++
 drivers/net/dsa/mv88e6xxx/devlink.c     |  94 ++++++
 drivers/net/dsa/mv88e6xxx/global1.h     |  10 +
 drivers/net/dsa/mv88e6xxx/global1_vtu.c | 311 ++++++++++--------
 include/net/dsa.h                       |   5 +
 include/net/switchdev.h                 |  17 +
 include/uapi/linux/if_bridge.h          |  17 +
 include/uapi/linux/if_link.h            |   1 +
 include/uapi/linux/rtnetlink.h          |   5 +
 net/bridge/Makefile                     |   2 +-
 net/bridge/br_input.c                   |  17 +-
 net/bridge/br_mst.c                     | 402 ++++++++++++++++++++++++
 net/bridge/br_netlink.c                 |  17 +-
 net/bridge/br_private.h                 |  31 ++
 net/bridge/br_stp.c                     |   3 +
 net/bridge/br_switchdev.c               |  57 ++++
 net/bridge/br_vlan.c                    |  20 +-
 net/bridge/br_vlan_options.c            |  24 +-
 net/dsa/dsa_priv.h                      |   3 +
 net/dsa/port.c                          |  40 +++
 net/dsa/slave.c                         |  12 +
 22 files changed, 1216 insertions(+), 142 deletions(-)
 create mode 100644 net/bridge/br_mst.c

-- 
2.25.1

