Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E7D4AF24D
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbiBINGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233824AbiBINGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:06:00 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B774C0613CA
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 05:06:03 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id c15so3254259ljf.11
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 05:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=ik/qwif2JQQYaftr1F0ovk4W9b9PouoozjP+RTv1j6s=;
        b=XB8Yuh+ZabNCCSs3EIoU8U8OTVNGSPp65Bg+6grOBLwAF4WhEVXOGVp16aJCCrUNKA
         /xBez+Tn9eKPIGdKL+fQz/lW6Fd+GxDQ+TeyXMtvJCWWRSqGWc27FXWluvuLLnGxcd0F
         qWUY6JrjeZa3iied0K/N/M1wRKIA+l4MUv9AygSXyGVnRpKNC3QPPKuvfg7NUA6FooC6
         N3H5MXqWhzW7HhidRRuHWfe5pU2o5ykYNLTQ8P0y3FGE5gBL2fl3AsH6wgAdFGpUplpw
         L+GDLb/ICMMXRbqv1fpZgpcHTZp/3I07H9kqqHF0v4HBQ3sxDnSnmzhhCwOLWulssyPh
         Zh4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=ik/qwif2JQQYaftr1F0ovk4W9b9PouoozjP+RTv1j6s=;
        b=F45Zyiss9FjIG03mBa7J5HZEj5sVotfqeKIT035f8euQL1yn4fUUQCrAq4cvyHBoXd
         whn0wQCBS5y7TI6WbaS5iGis098Pd+tmv4SVSw0wRcH7SoSoNMPDn4V+kAScZV5j9ky7
         9MK9MCtJ8F06VkOowafhT+sGVHEpjGRmR2ICdMhZjmagMO4DTiQE2yzq62Fd6rCbSAdV
         e637x6TGaBJfyOFvEizyMbsIfb0lb+hWsZ8Y1K91RJ8kCetkehoxlTfOPNMgBOgx/NGQ
         DzkH2V8OPq+nM0Nz8ZQLFfVyhl9897oPHEOFDJVxEEU22cHnqUhbPNJQDVsFA64zDqVz
         SdJA==
X-Gm-Message-State: AOAM531fJ6DT+WZKSDEkPUgf3/ty8XT7ecvtglmiy0vdpF7uUyIglzy9
        TXKdO+PVn/xkpZZU75DTQBDj28d3t2KNuPaAPC8=
X-Google-Smtp-Source: ABdhPJyfLPcG7qY6SNiS1QeTxQ1G1fn6+hfieAv+IhkaMShlVKuaqsgQWLGZTwRjli4xc+h+oeKxHw==
X-Received: by 2002:a05:651c:507:: with SMTP id o7mr1470965ljp.125.1644411961600;
        Wed, 09 Feb 2022 05:06:01 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id k3sm2352608lfo.127.2022.02.09.05.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 05:06:01 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>
Subject: [PATCH net-next v2 0/5] Add support for locked bridge ports (for 802.1X)
Date:   Wed,  9 Feb 2022 14:05:32 +0100
Message-Id: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

This series starts by adding support for SA filtering to the bridge,
which is then allowed to be offloaded to switchdev devices. Furthermore
an offloading implementation is supplied for the mv88e6xxx driver.

Public Local Area Networks are often deployed such that there is a
risk of unauthorized or unattended clients getting access to the LAN.
To prevent such access we introduce SA filtering, such that ports
designated as secure ports are set in locked mode, so that only
authorized source MAC addresses are given access by adding them to
the bridges forwarding database. Incoming packets with source MAC
addresses that are not in the forwarding database of the bridge are
discarded. It is then the task of user space daemons to populate the
bridge's forwarding database with static entries of authorized entities.

The most common approach is to use the IEEE 802.1X protocol to take
care of the authorization of allowed users to gain access by opening
for the source address of the authorized host.

With the current use of the bridge parameter in hostapd, there is
a limitation in using this for IEEE 802.1X port authentication. It
depends on hostapd attaching the port on which it has a successful
authentication to the bridge, but that only allows for a single
authentication per port. This patch set allows for the use of
IEEE 802.1X port authentication in a more general network context with
multiple 802.1X aware hosts behind a single port as depicted, which is
a commonly used commercial use-case, as it is only the number of
available entries in the forwarding database that limits the number of
authenticated clients.

      +--------------------------------+
      |                                |
      |      Bridge/Authenticator      |
      |                                |
      +-------------+------------------+
       802.1X port  |
                    |
                    |
             +------+-------+
             |              |
             |  Hub/Switch  |
             |              |
             +-+----------+-+
               |          |
            +--+--+    +--+--+
            |     |    |     |
    Hosts   |  a  |    |  b  |   . . .
            |     |    |     |
            +-----+    +-----+

The 802.1X standard involves three different components, a Supplicant
(Host), an Authenticator (Network Access Point) and an Authentication
Server which is typically a Radius server. This patch set thus enables
the bridge module together with an authenticator application to serve
as an Authenticator on designated ports.


For the bridge to become an IEEE 802.1X Authenticator, a solution using
hostapd with the bridge driver can be found at
https://github.com/westermo/hostapd/tree/bridge_driver .


The relevant components work transparently in relation to if it is the
bridge module or the offloaded switchcore case that is in use.

Hans Schultz (5):
  net: bridge: Add support for bridge port in locked mode
  net: bridge: Add support for offloading of locked port flag
  net: dsa: Add support for offloaded locked port flag
  net: dsa: mv88e6xxx: Add support for bridge port locked mode
  net: bridge: Refactor bridge port in locked mode to use jump labels

 drivers/net/dsa/mv88e6xxx/chip.c |  9 ++++++++-
 drivers/net/dsa/mv88e6xxx/port.c | 33 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h |  9 ++++++++-
 include/linux/if_bridge.h        |  1 +
 include/uapi/linux/if_link.h     |  1 +
 net/bridge/br_input.c            | 24 ++++++++++++++++++++++-
 net/bridge/br_netlink.c          | 12 +++++++++++-
 net/bridge/br_private.h          |  2 ++
 net/bridge/br_switchdev.c        |  2 +-
 net/dsa/port.c                   |  4 ++--
 10 files changed, 90 insertions(+), 7 deletions(-)

-- 
2.30.2

