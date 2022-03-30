Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229FD4EBFC9
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 13:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343642AbiC3LdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 07:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236467AbiC3LdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 07:33:16 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A311C1ECB
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 04:31:31 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id bt26so35239244lfb.3
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 04:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eyf3tYoEpX+4LqW8YaCZ/R5bUdr87XDjXip9dqr73Fo=;
        b=N8B1GBPImEWO9hckDw2jVlPx81RGY7RdERYOZMnLWu4bNJ4WY4eHyDe7M7BP6BuAaD
         2D9Tc2epMEdIFSH5k1hxZ5O3HBDOqJR8O6P2eKYy9DbOkxnKVtOpK8zCwyR08+LLC0AF
         LiGuOKybDeGuQx3M921YeIfBDNcdHRs4rPKqSKLqudAZGB/4+DJbLePnQsxk2z0cm8ei
         jto+qkcsalVhletWXG0IkC1D3Ztogs4SiMu7ziNQEteqaubI4eFfVZrngsNkz1WtBzgj
         RA0w2SRGIvzvHtNwCK301i+EUG5ktmHBfJUZPHEB1pyCIxtzqNVZAeO2egvB8XcPJz9Q
         1uNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eyf3tYoEpX+4LqW8YaCZ/R5bUdr87XDjXip9dqr73Fo=;
        b=t1IokAfuM5BF9JWA2kdDHz9o+vjF7Vp5xP1QrgInkxPGUMOdPSJbi5UOwIT14DXexo
         05RQOsdT/ihmFDHV/l80bGdOA9GziWIIbydwNAuRnN8YuQnotDP+fmdLpRKxStrV1HAb
         W5UJQLNAQhTuSMAYUqsQu6KueJSG77OgMGz8deXTfyDtYVtrY+sQOImk5adwAyUkVvbI
         x1Rbe9Dxvhf4vN0h4MUlR4bijPaqrR4BqUn3o5f1qx6KrO8JBCDeitmQoq2hkqz6uwkS
         8D0ckEL+vpNq0apf5E8AM4hDao/x371bu3fh85XLrs0lxWgUGXG3moV18wyJO9JrohSZ
         4FSA==
X-Gm-Message-State: AOAM530ft6ItB5XJ7A3krhBIYkCrXu7YimM0lOU1pcEes7yWnqucgyJx
        VKEmuQpJBy6MyCGFiR9pB+7dt2uQPvbTsNFJ
X-Google-Smtp-Source: ABdhPJwJutBdChCksb7+VHobWzglTDur/LM75Og+UAJt+feS/GTkyP26IRO7fmpso3epZ4XGj6VsGw==
X-Received: by 2002:a05:6512:1316:b0:44a:26d1:c72b with SMTP id x22-20020a056512131600b0044a26d1c72bmr6235032lfu.384.1648639887802;
        Wed, 30 Mar 2022 04:31:27 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id l3-20020a056512332300b0044a34844974sm2305909lfe.12.2022.03.30.04.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 04:31:26 -0700 (PDT)
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
Subject: [RFC PATCH net-next 0/2] net: tc: dsa: Implement offload of matchall for bridged DSA ports
Date:   Wed, 30 Mar 2022 13:31:14 +0200
Message-Id: <20220330113116.3166219-1-mattias.forsblad@gmail.com>
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

A sample configuration could be something like this:

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

Limitations
If there is tc rules on a bridge and all the ports leave the bridge
and then joins the bridge again, the indirect framwork doesn't seem
to reoffload them at join. The tc rules need to be torn down and
re-added.

The first part of this serie uses the flow indirect framework to
setup monitoring of tc qdisc and filters added to a bridge.
The second part offloads the matchall filter to HW for Marvell
switches.

Mattias Forsblad (2):
  net: tc: dsa: Add the matchall filter with drop action for bridged DSA ports.
  net: dsa: Implement tc offloading for drop target.

 drivers/net/dsa/mv88e6xxx/chip.c |  23 +++-
 include/net/dsa.h                |  13 ++
 net/dsa/dsa2.c                   |   5 +
 net/dsa/dsa_priv.h               |   3 +
 net/dsa/port.c                   |   1 +
 net/dsa/slave.c                  | 217 ++++++++++++++++++++++++++++++-
 6 files changed, 258 insertions(+), 4 deletions(-)

-- 
2.25.1

