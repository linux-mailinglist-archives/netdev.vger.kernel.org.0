Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6FC4D9151
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343778AbiCOA1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 20:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237473AbiCOA1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:27:33 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4AE3D1C1
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:22 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id s25so24350501lji.5
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=ec58JOIkOTTKzCKr2jXeDEf3Rw8k2rtjgb1MBmxLJ1E=;
        b=QVNDsNUvC/rx7Kz3ufShdR0v73ddYa8VE/PYciU7R1mnbreuq2FK96FD35LR+Xvucd
         qd3FytQCFfLzzDbHVyZiP29Lxht4jZmVV12bRnR1xwbBgimzMFdaiyFg81CXXPq0FbzB
         6tLuhg+IwhABOKkC5k6LFZTwfy6wEVCHtvoGRImrwb1x+6Ba0jObt8qbzFEPa6klXh3l
         BansazG1L+I+C/SkJhkoLgYqum0b0nZvSqllnmJOZyaol7Kay6siW+xMR1ow6jD7FWxv
         jTOFpHIYziV7cedWxKL3wPb3JSri+YHlL0b+Oju8SrUQBlSRS0uqNnLvqzMeQAKd6QVa
         ibSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=ec58JOIkOTTKzCKr2jXeDEf3Rw8k2rtjgb1MBmxLJ1E=;
        b=MHgNhaqKro7Rx9MJDbo97zaZTZrE7MeIr6w94LRTiXrTY/kqJYueysdr0excEtJEbI
         IikJKsrBU8RM1A9Zuq1IaeAFfsaTPSP3qQW/IvFwmiV/oJLQ/Ym/2QFxCqYhgn0ePTwh
         EZkKNvJ2v9+4AVRWUICDIbQ0KCxvMoVQV5w9+bOwBDnARJcZVoSq7Mc+iFHaWyFTbGjA
         oogvVM2itgU2UK8V7nmcGycwGaEehKSdtOLZu9BnBy/I3koVCL/WJQ8qtVh8jo/8IkpE
         tXzp5czwcP3Bl8ruvwo9ANz3nuDhZ1uhgC7l+bs14imAhXwNOnCZLmTJjY+Z0JyvjdIV
         Wbcw==
X-Gm-Message-State: AOAM530dMCqPLBGfLAj08N0ckB/GSbwpW1FKBopwj0rWkqPdnHDmhfCr
        uj5u3LOyMwb20nVefJOGryESpA==
X-Google-Smtp-Source: ABdhPJyxesLMiK7JReVVdTYrnYO1m7W2p2e0LbH+TwKWf4MfpoDyy9xADCyyygoVxN0TqSVjPx1Fzw==
X-Received: by 2002:a2e:bc0e:0:b0:247:f348:d6dd with SMTP id b14-20020a2ebc0e000000b00247f348d6ddmr15800785ljf.323.1647303980242;
        Mon, 14 Mar 2022 17:26:20 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y14-20020a2e544e000000b0024800f8286bsm4219923ljd.78.2022.03.14.17.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 17:26:19 -0700 (PDT)
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
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [PATCH v4 net-next 00/15] net: bridge: Multiple Spanning Trees
Date:   Tue, 15 Mar 2022 01:25:28 +0100
Message-Id: <20220315002543.190587-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
  Spanning Tree) (1/15)

- Ingress STP filtering is deferred until the frame's VLAN has been
  resolved (1/15)

- The preexisting per-VLAN states can no longer be controlled directly
  (1/15). They are instead placed under the MST module's control,
  which is managed using a new netlink interface (described in 3/15)

- VLANs can br mapped to MSTIs in an arbitrary M:N fashion, using a
  new global VLAN option (2/15)

Switchdev notifications are added so that a driver can track:
- MST enabled state
- VID to MSTI mappings
- MST port states

An offloading implementation is this provided for mv88e6xxx.

A proposal for the corresponding iproute2 interface is available here:

https://github.com/wkz/iproute2/tree/mst

v3 -> v4:
  Bridge:
  - Constify arguments where possible (Nik)
  - Use non-atomic bitmap operators (Nik)
  - Rename br_mst_parse -> br_mst_process (Nik)
  - Account for the dynamic size of generated MST netlink data (Nik)
  - Provide proper error reporting on invalid input (Nik)
  - Export bridge helpers under GPL (Nik)
  - Fix build when bridge VLAN filtering is compiled out (Intel bot)
  - Allocate VLAN bitmaps on the stack (Vladimir)
  DSA:
  - Propagate MST state change errors back to the bridge layer
    (Vladimir)
  - Fix issue with software fallback (Vladimir)
  - Ignore FDB events on software bridged ports
  mv88e6xxx:
  - Use non-atomic bitmap operators (Vladimir)
  - Restore refcount in error path (Vladimir)

v2 -> v3:
  Bridge:
  - Use new boolopt API to enable/disable the MST mode (Nik)
  - Mark br_mst_vlan_set_state as static (Vladimir)
  - Avoid updates/notifications on repeated VLAN to MSTI mapping
    configurations (Vladimir)
  - Configure MSTI states via the existing RTM_GET/SETLINK interface
    (Roopa)
  - Refactor switchdev replay logic (Vladimir)
  - Send switchdev notifications when enabling/disabling MST
    (Vladimir)
  DSA:
  - Align VLAN MSTI callback with existing APIs (Vladimir)
  - Only flush entries in the affected VLANs when changing an MST
    state (Vladimir)
  - Refuse offloading, unless all required ops are implemented
    (Vladimir)
  mv88e6xxx:
  - Always keep the driver's MST state in sync with hardware
    (Vladimir)
  - Fix SID leaks (Vladimir)
  - Only flush entries in the affected VLANs when changing an MST
    state (Vladimir)

v1 (RFC) -> v2:
  - Add a separate MST mode that is distinct from the exiting per-VLAN
    state functionality
  - Control MSTI states explicitly, rather than via an associated VLAN

Tobias Waldekranz (15):
  net: bridge: mst: Multiple Spanning Tree (MST) mode
  net: bridge: mst: Allow changing a VLAN's MSTI
  net: bridge: mst: Support setting and reporting MST port states
  net: bridge: mst: Notify switchdev drivers of MST mode changes
  net: bridge: mst: Notify switchdev drivers of VLAN MSTI migrations
  net: bridge: mst: Notify switchdev drivers of MST state changes
  net: bridge: mst: Add helper to map an MSTI to a VID set
  net: bridge: mst: Add helper to check if MST is enabled
  net: dsa: Never offload FDB entries on standalone ports
  net: dsa: Validate hardware support for MST
  net: dsa: Pass VLAN MSTI migration notifications to driver
  net: dsa: Handle MST state changes
  net: dsa: mv88e6xxx: Disentangle STU from VTU
  net: dsa: mv88e6xxx: Export STU as devlink region
  net: dsa: mv88e6xxx: MST Offloading

 drivers/net/dsa/mv88e6xxx/chip.c        | 304 +++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h        |  38 +++
 drivers/net/dsa/mv88e6xxx/devlink.c     |  94 +++++++
 drivers/net/dsa/mv88e6xxx/global1.h     |  10 +
 drivers/net/dsa/mv88e6xxx/global1_vtu.c | 311 ++++++++++++----------
 include/linux/if_bridge.h               |  13 +
 include/net/dsa.h                       |   6 +
 include/net/switchdev.h                 |  16 ++
 include/uapi/linux/if_bridge.h          |  18 ++
 include/uapi/linux/rtnetlink.h          |   1 +
 net/bridge/Makefile                     |   2 +-
 net/bridge/br.c                         |   5 +
 net/bridge/br_input.c                   |  17 +-
 net/bridge/br_mst.c                     | 332 ++++++++++++++++++++++++
 net/bridge/br_netlink.c                 |  44 +++-
 net/bridge/br_private.h                 |  56 ++++
 net/bridge/br_stp.c                     |   3 +
 net/bridge/br_switchdev.c               |  46 ++++
 net/bridge/br_vlan.c                    |  20 +-
 net/bridge/br_vlan_options.c            |  20 ++
 net/dsa/dsa_priv.h                      |   6 +
 net/dsa/port.c                          | 106 +++++++-
 net/dsa/slave.c                         |  21 ++
 23 files changed, 1337 insertions(+), 152 deletions(-)
 create mode 100644 net/bridge/br_mst.c

-- 
2.25.1

