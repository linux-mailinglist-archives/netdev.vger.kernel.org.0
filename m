Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB514EEAF1
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 12:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344900AbiDAKG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 06:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344894AbiDAKG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 06:06:57 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6435E170DBA
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 03:05:08 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id d5so3918268lfj.9
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 03:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BFmaRwqz6kl69pLD8szpaAIHhtoMySKy8H4lO8JEek8=;
        b=RXdliukJvfvrnBXItF0gwe/dHvDSBm+O9hlrjso3cQZdw1B6b1W2aZuwCtdHyPtBVw
         GtZ5yz3VkuURiUmOXGgBXAtsZV3kZl0FSb364d8OQGhXBlzQE9a3SeNUVp73qHc9fH5h
         If7cZp1nm9TQHVNxVcPZ7vQ+laQjSCZTGwUINkm3dpr5gN0h46fj6ZQtKRZBlcd5yoCX
         pQoz9ZRrZdAS7rlYFptGpJgtR50zUAFiiWggQVMfaDhWAcnz5bDZIzvRk5dHQFe1Trxy
         Pokp/NEcwTyAAtq1RmCIWOS6VZDYjqv4FHQb9B9uBTS/vtoA4/nGN5zghtNTZhcMBOOa
         PgNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BFmaRwqz6kl69pLD8szpaAIHhtoMySKy8H4lO8JEek8=;
        b=XW87oifARV9GIu+6WOmHArQwV6okO7f3geYUN+oTAcQ4Z0IZpOICJUyEY/ivRkB4pv
         pMuID1YhW579DyRJJW1S5ftx2ICLizsatfgwFSO2UnsMgBr034I2VKC5j9VKp9tVIzVB
         22R0CbBPpyryU1zcsw6Tzk0YevKyQ9AQbdCwWld5jQRQAUnQy1grxUlEaNpa+kyrOCgT
         8/ujNnPKClb2ALhnL3o3VbU0Hxfq1I3fgFj4yjd1ZUu0mLS3vLRZJbgsCSJy+AHn0hsG
         GCZ2ykzIJXwjCQASl2rudxrCuBUaJolZ158VV4gvk5rUKkAt1mn22BSsVp2nPFtXNHVK
         uxaA==
X-Gm-Message-State: AOAM530HDNlX8VQ2ZMJr0KdDzQthjfD5XTxFXtT07u0dSkpDkI5Uv/Mw
        kzzLvvyHxLQQdIPP2Lm56Iwp0lmOnxJhlw==
X-Google-Smtp-Source: ABdhPJxwb4/cMeu5kO/4RFijU+QVAr3GVX8z5372IeAbtu3L8SAHmLQtUqXDSqabqsRy6gRpULeUMg==
X-Received: by 2002:ac2:4f92:0:b0:448:b49f:dd23 with SMTP id z18-20020ac24f92000000b00448b49fdd23mr13511653lfs.684.1648807506264;
        Fri, 01 Apr 2022 03:05:06 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id z17-20020a19e211000000b0044a1348fc87sm197903lfg.43.2022.04.01.03.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 03:05:04 -0700 (PDT)
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
Subject: [PATCH v1 net-next 0/2] net: tc: dsa: Implement offload of matchall for bridged DSA ports
Date:   Fri,  1 Apr 2022 12:04:16 +0200
Message-Id: <20220401100418.3762272-1-mattias.forsblad@gmail.com>
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

RFC -> v1: Monitor bridge join/leave and re-evaluate offloading (Vladimir Oltean)

Mattias Forsblad (2):
  net: tc: dsa: Add the matchall filter with drop action for bridged DSA
    ports.
  net: dsa: Implement tc offloading for drop target.

 drivers/net/dsa/mv88e6xxx/chip.c |  23 +++-
 include/net/dsa.h                |  14 ++
 net/dsa/dsa2.c                   |   5 +
 net/dsa/dsa_priv.h               |   3 +
 net/dsa/port.c                   |   2 +
 net/dsa/slave.c                  | 221 ++++++++++++++++++++++++++++++-
 6 files changed, 264 insertions(+), 4 deletions(-)

-- 
2.25.1

