Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C2A3AD228
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 20:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234943AbhFRScs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 14:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbhFRScm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 14:32:42 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587DCC061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 11:30:31 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id dm5so4862876ejc.9
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 11:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NP39N2p1sOG3pP25GYklTOuIg8pyw1VNbgSyH17kW/g=;
        b=bXpcgua0SAm8D1MGVN5OXfbBE0e71dxW92LcCxi6BJpsnA0vM/933cziUI4gUWpHbw
         Kqs3IEAWHq9yRM5QZT8cjFNven/5tAP8RrV+DVxnuvisZf8nbhavuXC1nXQ0I/s8Wnkm
         s6BauyVhdavnxiLLTcVs+H2insvJrc9EAa7BYM5B5Rq1SZXsALc60iYTUxuj3HScjMnL
         AFC1N7W0nRBH4Y4n4uYHK9q8NJ0Dw0qrbgv2uIsp8yXthBAK5a6LxYPiiTT+0IZLXwxG
         q3jvi0EaSkySAHq31Ay8zGWET+tceZMOqM3N1dTEpKuvMMl7+LW1w8q6v7FXitnT0mbi
         nAZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NP39N2p1sOG3pP25GYklTOuIg8pyw1VNbgSyH17kW/g=;
        b=JthaOTZB8WHVHnjqhw5zhmvTaenyYyBLaK0GhMBpH/AiapBE8X9EG5+GPHLrRuaWnm
         j5ym6mTqB3WkU6d4jBe+qUdBzGdmQl3J8Q7Ly0ARf01pWRHgKzkLwWTa5d+I4u50A3tG
         AWooDmgxH7vUVQgJln7ZQ8Dz2lgmsgYtF8iUL0TbCFhETp7lcw4vZd7uXNzy8JpIJ6a/
         intNrWvpPxMFUx3lE26Bv5DPt7sGOY6TxOgnSujrZgziY0+bqSEaKIHWVpT0g+tXRi8i
         RxzGBby6W5ftYWoXGRhmZFJtUZvkQCUGiatXsXXq8QuA/Pd23zSWi7nGP+sX8KevHTFP
         Xqlg==
X-Gm-Message-State: AOAM533tQQUarWdVQs49zpu9uddps28+pu1cD3USUDV0oRkq7Zg67PVs
        QwFSqajNDMybs4fUKq77mTI=
X-Google-Smtp-Source: ABdhPJzxtQ91LmZItgvJrzivGpHKiyYyY2rxoTiJ0QLHtwA3XOvwLwrlUgzfdNo8IyggrDUzYoXxCQ==
X-Received: by 2002:a17:907:990f:: with SMTP id ka15mr12494279ejc.132.1624041029873;
        Fri, 18 Jun 2021 11:30:29 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s11sm6071988edd.65.2021.06.18.11.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 11:30:29 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 0/6] Improvement for DSA cross-chip setups
Date:   Fri, 18 Jun 2021 21:30:11 +0300
Message-Id: <20210618183017.3340769-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series improves some aspects in multi-switch DSA tree topologies:
- better device tree validation
- better handling of MTU changes
- better handling of multicast addresses
- removal of some unused code

Vladimir Oltean (6):
  net: dsa: assert uniqueness of dsa,member properties
  net: dsa: export the dsa_port_is_{user,cpu,dsa} helpers
  net: dsa: execute dsa_switch_mdb_add only for routing port in
    cross-chip topologies
  net: dsa: calculate the largest_mtu across all ports in the tree
  net: dsa: targeted MTU notifiers should only match on one port
  net: dsa: remove cross-chip support from the MRP notifiers

 include/net/dsa.h  | 15 ++++++++
 net/dsa/dsa2.c     | 22 ++++--------
 net/dsa/dsa_priv.h |  4 +--
 net/dsa/port.c     |  4 +--
 net/dsa/slave.c    | 22 ++++++------
 net/dsa/switch.c   | 87 ++++++++--------------------------------------
 6 files changed, 53 insertions(+), 101 deletions(-)

-- 
2.25.1

