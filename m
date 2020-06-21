Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B51202A62
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 13:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbgFULqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 07:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729943AbgFULqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 07:46:19 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835CEC061794
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 04:46:19 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w6so3704031ejq.6
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 04:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZRpikGhkBamqSBjWe8Xtg1XnOCZq7+OK54VyJz48sZw=;
        b=HuQRGBxM4PasA/sfqjOdiRyrrX48C461p1HixszpTIwNRoW2aJ/KtN1bs1YbdQ1bZm
         gg5Qqw4A99ayVaCVi7lJWxXe3HLIb0SVi9NqGeJms7HbuvGgAN66wXTHGjKpFfFNrMRP
         QJgjEy9Jw6KLoljTjU3HyAiEvrc9Z1BTi08knauLLu2R/Gce8wk363hGjsdK/qjNodyM
         Xh/EgBHfc0kPnLmYIfPfyxMLkVKldToP9JMDM2522/hOfAAi3Mf27i0N8Ue19mPxY3Vf
         81nAhi0KvMKLbvsnh90jW1/4pa6lC0tzOOTitTO4zEt30xWL9RYHkfS0cUHsPFsBCkry
         S0MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZRpikGhkBamqSBjWe8Xtg1XnOCZq7+OK54VyJz48sZw=;
        b=ueylg0uwwqjcm3LRPoc9nsFE7IutYqlqX8zm2j8u+XT2xOfJaiPpWILUQoUOc6JQmZ
         Jlt3A5JZyv5NW52PGheU/gs7JEoL4A2Nfb9jvi/V2AtG0dTvFGmtVTgLh5Iu2kFSl2Ys
         Jf8/U+1s08c+sZlH2NnI64XoiHUqjtms6SueHClmmbmhp2XEjvW0ZESkadvBWX/uDYWn
         H4efR0fv48VAii5ejyQRJH6oysUTdG0YOauJaRd0PDetyGuqpHKuENYX+KcBJCEpIhvd
         Rs2vbukFxiMMDWPDMAi5JdFH+MJ9hBU8I4WSWDNqhgzlPCLvlhom9tWFGsV0hiyTd71X
         okBQ==
X-Gm-Message-State: AOAM531Aj6g4NkyM2V6B6xUA7v8gWkQJmVJxJ6ovXRXjJ0pkffNQFzis
        co0fCMcbaSeqT0Tec3OMzts=
X-Google-Smtp-Source: ABdhPJyJbKzjAtoi1tGAIpo51hWEJnm1Q1A5tojSia/g8sCulvWRB7+Xr+jz/yLccE+XfH8/hqwXdA==
X-Received: by 2002:a17:906:ca81:: with SMTP id js1mr6313367ejb.369.1592739978066;
        Sun, 21 Jun 2020 04:46:18 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id k23sm9155508ejg.89.2020.06.21.04.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 04:46:17 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com
Subject: [PATCH net-next 0/5] Multicast improvement in Ocelot and Felix drivers
Date:   Sun, 21 Jun 2020 14:45:58 +0300
Message-Id: <20200621114603.119608-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series makes some basic multicast forwarding functionality work for
Felix DSA and for Ocelot switchdev. IGMP/MLD snooping in Felix is still
missing, and there are other improvements to be made in the general area
of multicast address filtering towards the CPU, but let's get these
hardware-specific fixes out of the way first.

Vladimir Oltean (5):
  net: mscc: ocelot: fix encoding destination ports into multicast IPv4
    address
  net: mscc: ocelot: make the NPI port a proper target for FDB and MDB
  net: dsa: felix: call port mdb operations from ocelot
  net: mscc: ocelot: introduce macros for iterating over PGIDs
  net: mscc: ocelot: support IPv4, IPv6 and plain Ethernet mdb entries

 drivers/net/dsa/ocelot/felix.c         |  26 +++++
 drivers/net/ethernet/mscc/ocelot.c     | 137 ++++++++++++++++++-------
 drivers/net/ethernet/mscc/ocelot.h     |   6 +-
 drivers/net/ethernet/mscc/ocelot_net.c |  28 ++++-
 include/soc/mscc/ocelot.h              |  19 ++++
 5 files changed, 175 insertions(+), 41 deletions(-)

-- 
2.25.1

