Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65FC331B104
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 16:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhBNPzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 10:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhBNPzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 10:55:10 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4955EC061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 07:54:29 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id l12so5357802edt.3
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 07:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AwMk/kalLyDokHCM5RI1avVwvdbNcsILetiSswflN14=;
        b=ti+bdeKunPn9c3RUZan4rFyK9YMueMFshAd+uKUToLkudlJvy3W7dKREE2Y+GyX9cD
         CG9KxfAA26R3qqxj66EVY4m3OZyHq4cPLz0/QLfMGvGJWNgnlCnQLMahNWyTWGobAuTa
         cRfhql9001+7k7+UqSjdU8sR5KYk4A+CmR5yQbdSvnDxFlO0sMfkM+8oCv3VG6n7m5uF
         /KoYhuQfeN9dHKROIMcbkNb6JjhhGnlezIFnjqjrIWE0+iI3B1L9htq8uPl+s4fMFWFR
         9bg74KbPsDZJMPrd6L5OcwWZ90B0OPm4aa3i/P+5tEpR2Um7QEUE8x47g5rTsaZoSZG/
         smGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AwMk/kalLyDokHCM5RI1avVwvdbNcsILetiSswflN14=;
        b=d50P6mBekdssTqU8SVKN9rDTchZO+Xq4EqoZGhf8m3abOOtQj+7fzg0YNwjxV4W5xQ
         6E6XwY0+apAa7rQNWuAGcs29PBfxD+NGfmj5b47VHQ8hV8gypzxWkwyJjelUJOYL+TfW
         Ct314HYSFEZ4A4bhMTNHXAdyiJp72wgJc6vG1MQWWzvn/OOqR5Qj4D+js7l44D4BPA4w
         8Q4qbFd+4wPnX0p0Hfo+KlQZX7WMfoitkhQzOJJLXZmYv5XVPD1ENBzYSxYgjbj8wcef
         z93T/9YxCl6pOyngqXCTuzQ/OzDoTCHzihW3qww+5NJ41JPkK+3BY6JwQxsIX6VtSXzv
         HVFw==
X-Gm-Message-State: AOAM533UIb9L4KpifFhcT3F8AXU6j+uOUmG9+9lxHE3zhFGVsUQqSQCu
        IjVVcmpeqcqjm/xFwBvfEKQ=
X-Google-Smtp-Source: ABdhPJxt59Mmt5arXEyJ737vvEOoJTYxt9UhYS824bqQfrsnvLj48Ty23g5CMsoA1ad/dIpFciN73A==
X-Received: by 2002:a05:6402:270d:: with SMTP id y13mr11939483edd.149.1613318067849;
        Sun, 14 Feb 2021 07:54:27 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id cn18sm8576003edb.66.2021.02.14.07.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 07:54:27 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH net-next 0/4] Software fallback for bridging in DSA
Date:   Sun, 14 Feb 2021 17:53:22 +0200
Message-Id: <20210214155326.1783266-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

As was discussed here:
https://patchwork.kernel.org/project/netdevbpf/patch/20201202091356.24075-3-tobias@waldekranz.com/

it is desirable to not reject a LAG interface (bonding, team) even if
the switch isn't able to offload bridging towards that link aggregation
group. At least the DSA setups I have are not that unbalanced between
the horsepower of the CPU and the horsepower of the switch such that
software forwarding to be completely impractical.

This series makes all switch drivers theoretically able to do the right
thing when they are configured in a way similar to this (credits to
Tobias Waldekranz for the drawing):

      br0
     /   \
  team0   \
   / \     \
swp0 swp1  swp2

although in practice there is one more prerequisite: for software
fallback mode, they need to disable address learning. It is preferable
that they do this by implementing the .port_pre_bridge_join and
.port_bridge_join methods.

Vladimir Oltean (4):
  net: dsa: don't offload switchdev objects on ports that don't offload
    the bridge
  net: dsa: reject switchdev objects centrally from
    dsa_slave_port_obj_{add,del}
  net: dsa: return -EOPNOTSUPP if .port_lag_join is not implemented
  net: dsa: don't set skb->offload_fwd_mark when not offloading the
    bridge

 net/dsa/dsa_priv.h         | 16 ++++++++++++++++
 net/dsa/slave.c            | 21 +++++++++++----------
 net/dsa/switch.c           | 13 ++++++++++---
 net/dsa/tag_brcm.c         |  2 +-
 net/dsa/tag_dsa.c          |  9 +++++----
 net/dsa/tag_hellcreek.c    |  2 +-
 net/dsa/tag_ksz.c          |  2 +-
 net/dsa/tag_lan9303.c      |  4 +++-
 net/dsa/tag_mtk.c          |  2 +-
 net/dsa/tag_ocelot.c       |  2 +-
 net/dsa/tag_ocelot_8021q.c |  2 +-
 net/dsa/tag_rtl4_a.c       |  2 +-
 net/dsa/tag_sja1105.c      |  4 ++--
 net/dsa/tag_xrs700x.c      |  3 +--
 14 files changed, 55 insertions(+), 29 deletions(-)

-- 
2.25.1

