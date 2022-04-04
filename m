Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47D54F0F72
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 08:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377469AbiDDGfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 02:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351199AbiDDGf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 02:35:29 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD75617B
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 23:33:33 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id m3so15281994lfj.11
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 23:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LDu2pYceig49uOZ9WZN/eN+3K74oIjjLv6dHS5iQxeE=;
        b=B0xKWSBLjErJKNgOL1cCyVyXw2bx7cieLzufd2ESkvmX/kNDQm7kB5SEsm2fZA8EjY
         FoOVEl7utRagrPfphqeaJaKSulcy4ksHv22WIeTptPFoiaP+dJzR5MtHxqB6LVdwJ/2u
         yV395aPbbhvdPkrVzGchim9VI6N92GwPh2LJbnh/iVMXe2Dx7Ht8qyf/cNzLRx8RFYQT
         NXsfme2bzDO4NHnuIuDTNKPhSy9hLWYIqtvCZN5eRjPHRo7Xop5mbKFBA1j8Nk4sOFEt
         OuXQfJPV5HnOp2SaguW0qg7eLUKfNzGKGXNmLkr2tjRvUUGoB2ClaEUg989FWoT8j2HV
         xHRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LDu2pYceig49uOZ9WZN/eN+3K74oIjjLv6dHS5iQxeE=;
        b=v9zB3kxFLSmOHE3sA1MrXWmHYmU6HDrrCXcVY7mR8rCWyRLGvpwKBDHqzek6oOK+r1
         wofQ5uHEoLHaiGTbnQwqEIYCKPAQxn2KieNBxLCbM+vka+A2PIgAZqi7CTwtqt8HFRJa
         QusXdKRH8uEeLNUqL8ng02Z4pjQzCPCTGyboMqC9rWAsXRSOaix8W71Cta1GYi+/NcW8
         3md7NULpkyXK2cO5DFV8cknANnyHATWAcVXcH9llAnoBY0YFJLu9ZgvL3BccSSt+iUV+
         CRkcMbxF3FaCwGc9fOluamnxblmnagw0WP7Da0agMJhSGSQjjH9fS6GMby1LxvlCicO0
         /QDw==
X-Gm-Message-State: AOAM5300WHakAbupGu4+t7MdbVTsIGYVtqu8i6HU8AECewi7Y3MS4ztu
        QLeH/wCA6ARKuvuGXuUJoDk8b7XFTVKkmg==
X-Google-Smtp-Source: ABdhPJyHtQF/R/2nnr7yp94qT9874Is1Gxv3b0oNWy8yMceuThDDYh0YAwUU6RXCj3VacoiW4/SuBg==
X-Received: by 2002:a05:6512:1695:b0:44a:a96e:a086 with SMTP id bu21-20020a056512169500b0044aa96ea086mr21353110lfb.405.1649054011853;
        Sun, 03 Apr 2022 23:33:31 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id d17-20020a194f11000000b0044a30825a6fsm1033771lfb.42.2022.04.03.23.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 23:33:31 -0700 (PDT)
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
Subject: [PATCH v2 net-next 0/2] net: tc: dsa: Implement offload of matchall for bridged DSA ports
Date:   Mon,  4 Apr 2022 08:33:25 +0200
Message-Id: <20220404063327.1017157-1-mattias.forsblad@gmail.com>
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
v2: Fix code standard compliance (Jakub Kicinski)

Mattias Forsblad (2):
  net: tc: dsa: Add the matchall filter with drop action for bridged DSA
    ports.
  net: dsa: Implement tc offloading for drop target.

 drivers/net/dsa/mv88e6xxx/chip.c |  23 +++-
 include/net/dsa.h                |  14 ++
 net/dsa/dsa2.c                   |   5 +
 net/dsa/dsa_priv.h               |   3 +
 net/dsa/port.c                   |   2 +
 net/dsa/slave.c                  | 224 ++++++++++++++++++++++++++++++-
 6 files changed, 266 insertions(+), 5 deletions(-)

-- 
2.25.1

