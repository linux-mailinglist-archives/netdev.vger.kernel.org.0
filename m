Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D769C1CFBE4
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 19:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgELRUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 13:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgELRUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 13:20:45 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B217C061A0C;
        Tue, 12 May 2020 10:20:45 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id z72so14791035wmc.2;
        Tue, 12 May 2020 10:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UJ/ZO7NVjTI8/N9JusANSsKU0IfkbbuVbjw6eJjkZ2Y=;
        b=OfXGFXMrMj5oF3yTTiW06ie8qAkkpkyzl75ZaExFkMZs07ZuWcqLHK8+jim5gfQVyZ
         cKDMkcLx1VVR3KrCBuWHPB6b3ydeOi3rRUdHO+sfM35bimMI0d3A7tnfnLbnF1BmvqPx
         DlXAaxVCbFJtX4aUDY9gRo18c8pB/bR0aQFMsETsaV9NeEdGJ7ydSYNz0BdgA0uLqxVF
         0DGV//rM3K3P1gnKw/rzECnCX/tXCxihAHr0Cp44kqW7qsp1FZ5NODFhxSI+vCrMoFfJ
         sHnAKoALgHMedP1mFUzsENdea9OIZ1MiC6J2LgDWgSa9bDohZ4Tb997w/Ullv+qYyTAg
         39Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UJ/ZO7NVjTI8/N9JusANSsKU0IfkbbuVbjw6eJjkZ2Y=;
        b=oBIwl6j/SVaBVcELn4+i7NERje/pSv0z9m+QXgiiUljHuFeV8tyXSaSCTpm7BVjwR+
         KGkiRpMWbqBcqp9PNOo+KhnFjvv38XsirMkvhwB6++EZN6WQ/TAprRXpqsZhkNj2V4RT
         /iBcneT/18dAmfPxLN3hkST2Cn4dxNyDoSgGcnowDF+sPG9xZkAR2Q/DPPDz7TQihavg
         WK9VbEpIAOaZyjfxYWqZNM+O5Vb4IzQDODj8dJsfWqMufG4sGHqdyMB0u+WR9W4TpKcl
         WYQnA/+6nUUMOfs6mOwFAtF0PjlcfJz9VITa8kDBLv5Vx6o/OCq0jOQ5/r73Rgky3Sqn
         kVEA==
X-Gm-Message-State: AGi0PuYTPVcUe8nBf2LyOy9IWlqznyfk4PPp3Y+P3eanQluhzqTBfLmh
        /iDinq5lwXSn7hmH1/cXPJ8=
X-Google-Smtp-Source: APiQypInQX09sXD0NPZjPv55LEMtUhZoO3s3CO58PIIS5jRjJp7B4IKuSzD8Tj+kwzb4TBDu+AVyUA==
X-Received: by 2002:a7b:c046:: with SMTP id u6mr8501942wmc.57.1589304043804;
        Tue, 12 May 2020 10:20:43 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id a15sm23999743wrw.56.2020.05.12.10.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 10:20:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 00/15] Traffic support for dsa_8021q in vlan_filtering=1 mode
Date:   Tue, 12 May 2020 20:20:24 +0300
Message-Id: <20200512172039.14136-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series is an attempt to support as much as possible in terms of
traffic I/O from the network stack with the only dsa_8021q user thus
far, sja1105.

The hardware doesn't support pushing a second VLAN tag to packets that
are already tagged, so our only option is to combine the dsa_8021q with
the user tag into a single tag and decode that on the CPU.

The assumption is that there is a type of use cases for which 7 VLANs
per port are more than sufficient, and that there's another type of use
cases where the full 4096 entries are barely enough. Those use cases are
very different from one another, so I prefer trying to give both the
best experience by creating this best_effort_vlan_filtering knob to
select the mode in which they want to operate in.

v2 was submitted here:
https://patchwork.ozlabs.org/project/netdev/cover/20200511135338.20263-1-olteanv@gmail.com/

v1 was submitted here:
https://patchwork.ozlabs.org/project/netdev/cover/20200510164255.19322-1-olteanv@gmail.com/

Changes in v3:
Patch 01/15:
- Rename again to configure_vlan_while_not_filtering, and add a helper
  function for skipping VLAN configuration.
Patch 03/15:
- Remove sja1105_can_use_vlan_as_tags from driver code.
Patch 06/15:
- Adapt sja1105 driver to the second variable name change.
Patch 08/15:
- Provide an implementation of sja1105_can_use_vlan_as_tags as part of
  the tagger and not as part of the switch driver. So we have to look at
  the skb only, and not at the VLAN awareness state.

Changes in v2:
Patch 01/15:
- Rename variable from vlan_bridge_vtu to configure_vlans_while_disabled.
Patch 03/15:
- Be much more thorough, and make sure that things like virtual links
  and FDB operations still work properly.
Patch 05/15:
- Free the vlan lists on teardown.
- Simplify sja1105_classify_vlan: only look at priv->expect_dsa_8021q.
- Keep vid 1 in the list of dsa_8021q VLANs, to make sure that untagged
  packets transmitted from the stack, like PTP, continue to work in
  VLAN-unaware mode.
Patch 06/15:
- Adapt to vlan_bridge_vtu variable name change.
Patch 11/15:
- In sja1105_best_effort_vlan_filtering_set, get the vlan_filtering
  value of each port instead of just one time for port 0. Normally this
  shouldn't matter, but it avoids issues when port 0 is disabled in
  device tree.
Patch 14/14:
- Only do anything in sja1105_build_subvlans and in
  sja1105_build_crosschip_subvlans when operating in
  SJA1105_VLAN_BEST_EFFORT state. This avoids installing VLAN retagging
  rules in unaware mode, which would cost us a penalty in terms of
  usable frame memory.

Russell King (1):
  net: dsa: provide an option for drivers to always receive bridge VLANs

Vladimir Oltean (14):
  net: dsa: tag_8021q: introduce a vid_is_dsa_8021q helper
  net: dsa: sja1105: keep the VLAN awareness state in a driver variable
  net: dsa: sja1105: deny alterations of dsa_8021q VLANs from the bridge
  net: dsa: sja1105: save/restore VLANs using a delta commit method
  net: dsa: sja1105: allow VLAN configuration from the bridge in all
    states
  net: dsa: sja1105: exit sja1105_vlan_filtering when called multiple
    times
  net: dsa: sja1105: prepare tagger for handling DSA tags and VLAN
    simultaneously
  net: dsa: tag_8021q: support up to 8 VLANs per port using sub-VLANs
  net: dsa: tag_sja1105: implement sub-VLAN decoding
  net: dsa: sja1105: add a new best_effort_vlan_filtering devlink
    parameter
  net: dsa: sja1105: add packing ops for the Retagging Table
  net: dsa: sja1105: implement a common frame memory partitioning
    function
  net: dsa: sja1105: implement VLAN retagging for dsa_8021q sub-VLANs
  docs: net: dsa: sja1105: document the best_effort_vlan_filtering
    option

 .../networking/devlink-params-sja1105.txt     |   27 +
 Documentation/networking/dsa/sja1105.rst      |  211 +++-
 drivers/net/dsa/sja1105/sja1105.h             |   29 +
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |   33 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 1120 +++++++++++++++--
 drivers/net/dsa/sja1105/sja1105_spi.c         |    6 +
 .../net/dsa/sja1105/sja1105_static_config.c   |   62 +-
 .../net/dsa/sja1105/sja1105_static_config.h   |   16 +
 drivers/net/dsa/sja1105/sja1105_vl.c          |   44 +-
 include/linux/dsa/8021q.h                     |   42 +-
 include/linux/dsa/sja1105.h                   |    3 +
 include/net/dsa.h                             |    7 +
 net/dsa/dsa_priv.h                            |    1 +
 net/dsa/port.c                                |   14 +
 net/dsa/slave.c                               |    8 +-
 net/dsa/tag_8021q.c                           |  108 +-
 net/dsa/tag_sja1105.c                         |   51 +-
 17 files changed, 1522 insertions(+), 260 deletions(-)
 create mode 100644 Documentation/networking/devlink-params-sja1105.txt

-- 
2.17.1

