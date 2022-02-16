Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B8F4B8A0B
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 14:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbiBPNaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 08:30:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbiBPNai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 08:30:38 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E5E172265
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 05:30:25 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id a42so3260582ljq.13
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 05:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=7QqLZbURjfzrJmew4Nev3nfIU835eXeMgxWsq8ycOmk=;
        b=8NOmVFFzzhW84LcTC8FUSG7v+xkhO1kmFLtdiXP71jkAj/ZqJjSumEtDVTX43BmOxN
         Qiuxy7Y8e7uThI96MQmYQeVxylr28Onc0ULrJcMg1srI1t5FiYEcO1nCo4j+zRsNPkzw
         xu13xWXrf1lVSJ3xNCq+19EyabVMb+kUBZNP1NlKaoU7pnNeYcctoAlEyskwjV0KT25Z
         M9/QdiICoj4Lr9oMUyeDyiocsSX9/fb16XcVLsghcCKiktSp0wlNVr4pPTtNJJwiLy5f
         BzsGA4sV3wXnIous6TulReojV7EU78ynNCLM/NMHpDHY68p6M39hRQGOZqnaEwfT7BY7
         zG2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=7QqLZbURjfzrJmew4Nev3nfIU835eXeMgxWsq8ycOmk=;
        b=fUuYTjcnDp1Iqsi+bHmB3a7DdIJrrHzOl7gttnbA2waYjb7JxD1Za37o96Dh+TN3YT
         +tzbYr0jS9+MSwmExN9fwve7Nu26rqnQ+0NFp1GIxHDkBYwVoEUEHCnxMzX/5xyosyv9
         zU5wZI0tx7OQFcwJzIQaTmVwqYbvTbYDCkbz3Xa7hAjQ6k4DYOAIHehF4OEwIrbMCwrY
         /ToL+VdZzGcK7OhoSv6MLZdCEeJMxiWMDGFqPmcEEcK4eF76/yOMVEfEOt8erNqh41Sb
         k8FuoZY2/FzHLAlGkoxtuBO3D55g3ABoDI4Z71Bd1q8EGHKkL6q1dCqgCAL/m8V9hbgH
         Ut0Q==
X-Gm-Message-State: AOAM531LMBWhziW4ko8D+LxnjoRgWPM3cc5DQDCaEQjbHdB1s9nNpeV4
        aTQpEtT0l2TwcxYnE7gW/vTb0w==
X-Google-Smtp-Source: ABdhPJwPyBoUdwJeujjp6omA1mXViAkpti3m/aV9s2ddBHMtuHY4H2Qo4ODdReqTLbrp1F2ckCZW/w==
X-Received: by 2002:a05:651c:1725:b0:244:bbe7:2433 with SMTP id be37-20020a05651c172500b00244bbe72433mr2099951ljb.144.1645018223261;
        Wed, 16 Feb 2022 05:30:23 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v6sm234780ljd.86.2022.02.16.05.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 05:30:22 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [RFC net-next 0/9] net: bridge: vlan: Multiple Spanning Trees
Date:   Wed, 16 Feb 2022 14:29:25 +0100
Message-Id: <20220216132934.1775649-1-tobias@waldekranz.com>
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

This series adds support for an arbitrary M:N mapping of VIDs to
MSTIs, proposing one solution to the first issue. An example of an
offload implementation for mv88e6xxx is also provided. Offloading is
done on a best-effort basis, i.e. notifications of the relevant events
are generated, but there is no way for the user to see whether the
per-VLAN state has been offloaded or not. There is also no handling of
the relationship between the port-global state the the per-VLAN ditto.

If I was king of net/bridge/*, I would make the following additional
changes:

- By default, when a VLAN is created, assign it to MSTID 0, which
  would mean that no per-VLAN state is used and that packets belonging
  to this VLAN should be filtered according to the port-global state.

  This way, when a VLAN is configured to use a separate tree (setting
  a non-zero MSTID), an underlying switchdev could oppose it if it is
  not supported.

  Obviously, this adds an extra step for existing users of per-VLAN
  STP states and would thus not be backwards compatible. Maybe this
  means that that is impossible to do, maybe not.

- Swap the precedence of the port-global and the per-VLAN state,
  i.e. the port-global state only applies to packets belonging to
  VLANs that does not make use of a per-VLAN state (MSTID != 0).

  This would make the offloading much more natural, as you avoid all
  of the caching stuff described above.

  Again, this changes the behavior of the kernel so it is not
  backwards compatible. I suspect that this is less of an issue
  though, since my guess is that very few people rely on the old
  behavior.

Thoughts?

Tobias Waldekranz (9):
  net: bridge: vlan: Introduce multiple spanning trees (MST)
  net: bridge: vlan: Allow multiple VLANs to be mapped to a single MST
  net: bridge: vlan: Notify switchdev drivers of VLAN MST migrations
  net: bridge: vlan: Notify switchdev drivers of MST state changes
  net: dsa: Pass VLAN MST migration notifications to driver
  net: dsa: Pass MST state changes to driver
  net: dsa: mv88e6xxx: Disentangle STU from VTU
  net: dsa: mv88e6xxx: Export STU as devlink region
  net: dsa: mv88e6xxx: MST Offloading

 drivers/net/dsa/mv88e6xxx/chip.c        | 223 +++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h        |  38 +++
 drivers/net/dsa/mv88e6xxx/devlink.c     |  94 +++++++
 drivers/net/dsa/mv88e6xxx/global1.h     |  10 +
 drivers/net/dsa/mv88e6xxx/global1_vtu.c | 311 ++++++++++++++----------
 include/linux/if_bridge.h               |   6 +
 include/net/dsa.h                       |   5 +
 include/net/switchdev.h                 |  17 ++
 include/uapi/linux/if_bridge.h          |   1 +
 net/bridge/br_private.h                 |  44 +++-
 net/bridge/br_vlan.c                    | 249 ++++++++++++++++++-
 net/bridge/br_vlan_options.c            |  48 +++-
 net/dsa/dsa_priv.h                      |   3 +
 net/dsa/port.c                          |  40 +++
 net/dsa/slave.c                         |  12 +
 15 files changed, 941 insertions(+), 160 deletions(-)

-- 
2.25.1

