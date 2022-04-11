Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF754FBBB5
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 14:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245753AbiDKMIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 08:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbiDKMIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 08:08:54 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E513CA66
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:06:40 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id x17so17098246lfa.10
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bMXbnPtGZfpLqftwbrCknYC2/BkmXdyyMdRk7l2b/O8=;
        b=k+vPu5Ce21FCvW/A8Tz/eBZJwsLAhpitDUWwJcELmdb7EP/kfbGu35ogpZt0iQc6t0
         Gl7pLztN3k4RVA9v5f2Vzxu8yim/T54qRtillf6LBLHEKxsumzkThdJ8+s1m2hOGpsDt
         O/6PLjeVierKYuyCvpjoLldXdkf044PgGYNKw6Fnovy3R09sNjSdoP5x9L79eYJmlXFD
         DetGIGAZPGv60pdXmI3c7QRrKE5H/MtMKMvkKkObLeWjOnMeREGic02K9IxAmZBWnzgo
         tuQZqEIyJKX48lUEZOc7hUa9m8V0zUQQf1MyZpe9rw5nwzQhxRL5fX7g9lsqSg48HQ1G
         S/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bMXbnPtGZfpLqftwbrCknYC2/BkmXdyyMdRk7l2b/O8=;
        b=sMslYcsIQh44wMdREpFbkPxLzDbkVbAw5FRNTEC56N43HNAS9bbu9LHC6QHI+A8Tbj
         rImGf8VeGbWI36c7uBGZNsKJA1wehutvIze8/89KbqR+LnBPFrKIraIEMRfCO0TbSqn2
         Mx/+Qy3fpATig4E4anBTclWEnqd/GHCfHhVi3nN80wAskARHl2KCSIznwoaXQa8HB3n/
         FxjuZjKiExm3Fd1XX7XSGJjUnjLbq3C1e3KPHQekxjx27YE15dEz0zMYxocn/ROikQ6S
         ataLQZVx6hmp5egaZ79Iw9Jw42egnnntkzEdYmZAS0udLtb/UWHgu67azmOS901f+FSW
         ekBg==
X-Gm-Message-State: AOAM531lgugIt6wNvMmacw4A3fh7vFurPVNHzrbc1SuSH9o5gaw1A03J
        tYYa9oYtq+CmRg7+b9Yr2vOs1y7Vf8kwug==
X-Google-Smtp-Source: ABdhPJxrTSCmmdQydlBVzPUkns6CBH4YHCUz+xSfI4s9B+ZSzLF5c2+oWM2vVV02zkavuVXh2d6W2Q==
X-Received: by 2002:a05:6512:131d:b0:464:f4f7:1b2d with SMTP id x29-20020a056512131d00b00464f4f71b2dmr13603861lfu.143.1649678797483;
        Mon, 11 Apr 2022 05:06:37 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id s10-20020a19ad4a000000b0044826a25a2esm3297627lfd.292.2022.04.11.05.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 05:06:36 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH v4 net-next 0/3] net: dsa: mv88e6xxx: Implement offload of matchall for bridged DSA ports
Date:   Mon, 11 Apr 2022 14:06:30 +0200
Message-Id: <20220411120633.40054-1-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

This series implements offloading of tc matchall filter to HW
for bridged DSA ports.

Background
When using a non-VLAN filtering bridge we want to be able to drop
traffic directed to the CPU port so that the CPU doesn't get unnecessary loaded.
This is specially important when we have disabled learning on user ports.

A basic sample configuration could be something like this:

       br0
      /   \
   swp0   swp1

ip link add dev br0 type bridge stp_state 0 vlan_filtering 0
ip link set swp0 master br0
ip link set swp1 master br0
ip link set swp0 type bridge_slave learning off
ip link set swp1 type bridge_slave learning off
ip link set swp0 up
ip link set swp1 up
ip link set br0 up

After discussions here: https://lore.kernel.org/netdev/YjMo9xyoycXgSWXS@shredder/
it was advised to use tc to set an ingress filter that could then
be offloaded to HW, like so:

tc qdisc add dev br0 clsact
tc filter add dev br0 ingress pref 1 proto all matchall action drop

Another situation that needs to be handled is when there is a
foreign interface in the bridge. In this case traffic must reach the
bridge, like the setup below.

               br0
             /  |  \
          swp0 swp1 veth0

Yet another case is when we have ports that are bonded with an
foreign interface added to the bridge.

               br0
             /     \
          bond0   veth0
         /     \
       swp0   swp1

These examples highlight the need to evaluate the bridge stack
to be able to make the right decision about whetever we can
offload this to hw or not.

Limitations
If there is tc rules on a bridge and all the ports leave the bridge
and then joins the bridge again, the indirect framwork doesn't seem
to reoffload them at join. The tc rules need to be torn down and
re-added. This seems to be because of limitations in the tc
framework. A fix for this would need another patch-series in itself.
However we prepare for when this issue is fixed by registring and
deregistring when a dsa_bridge is created/destroyed so it should
work when it's solved.

The first patch in this series now include changes done by Vladimir
Oltean to cleanup netdev notifier code and check for foreign
interfaces. The second part uses the flow indirect framework to
setup monitoring of tc qdisc and filters added to a bridge.
The last part offloads the matchall filter to HW for Marvell
switches.

RFC -> v1: Monitor bridge join/leave and re-evaluate offloading (Vladimir Oltean)
v2: Fix code standard compliance (Jakub Kicinski)
v3: Fix warning from kernel test robot (<lkp@intel.com>)
v4: Check matchall priority (Jakub)
    Use boolean type (Vladimir)
    Use Vladimirs code for checking foreign interfaces
    Drop unused argument (Vladimir)
    Add switchdev notifier (Vladimir)
    Only call ops when value have changed (Vladimir)
    Add error check (Vladimir)

Mattias Forsblad (3):
  net: dsa: track whetever bridges have foreign interfaces in them
  net: dsa: Add support for offloading tc matchall with drop target
  net: dsa: mv88e6xxx: Add HW offload support for tc matchall in Marvell
    switches

 drivers/net/dsa/mv88e6xxx/chip.c |  17 +-
 include/net/dsa.h                |  15 ++
 include/net/switchdev.h          |   2 +
 net/dsa/dsa2.c                   |   2 +
 net/dsa/dsa_priv.h               |   3 +
 net/dsa/port.c                   |  14 ++
 net/dsa/slave.c                  | 321 +++++++++++++++++++++++++++++--
 7 files changed, 361 insertions(+), 13 deletions(-)

-- 
2.25.1

