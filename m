Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2E43A4906
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhFKTDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhFKTDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:03:44 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC4AC0617AF
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:01:45 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id ce15so6029653ejb.4
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3pDtYpUsnA0jpurkBzyUaqdeveASWrdqGaFuapRPnEM=;
        b=BY+oSUj/9LhZcHcUbA1TAaxYA4GgFYdxf2CDNRWbCabNLo7DbpR1vrKtBVLot4ztsK
         d8tSagoJf07ebEnvFZe2sVXfgvdOVKta6TdPwrI3k4IZmcHgKxEB866FfhwiGio7cqIU
         dpEmWVe8zf6QLnMMOsXWxEKgjORAIpTcPRDi8C9bj8CpL9DKVsyIqsmR3gB/9cZ2iZxu
         xB9Y+89qMGTRPZCxVjVV+ZU160LRYdoCOgLTU3JscI48QNr4Xjs0yUrhI8UHqR9XIHuP
         /Na8VjAtidvamJLCQoQj+gGIE+e45PtYHhiNtSIzwWJp78E2eSrFjgal47grvhLu2i93
         F4qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3pDtYpUsnA0jpurkBzyUaqdeveASWrdqGaFuapRPnEM=;
        b=eH9Vp7m/go6wuZxr8IYveCG+OZkDwKPrE7+h0rFZXr2j8maPbuxTZW1N9K13SiHrNg
         sbdj9dZZ6Mo0pbcJJHc+TGu042BhrNdruoO51ExmMuVAFk7XY84dTnOBSViKbWQV14Cw
         kjIPJsG7YmvlLCTgpaEcreZNKebcim0jxtY75HRFbnu5vP3yjqUMIjYLjuEF+dIZUJDO
         kBdKjTotcP7Fo6boRcJoGqK4Ep9+AbPPfojq5B3gGSY7JDpXk4CkIYQaSzdeXZ+zB6Uy
         jPMiRyh8vCfiqYHZl5nRwB8sN1BgxbB//gKkqRpa+ir7UnOXBksiJ7PfnOO5IiyyKgWe
         pGWA==
X-Gm-Message-State: AOAM532UtCBzDlF+k645Sb3oIJ6sDzm7CRnc7IQD2Q85aDt+8z3UMQKQ
        a+tJ5taHXWAVPt8wr8HoMbY=
X-Google-Smtp-Source: ABdhPJwp5SqZebaeRnVTUYHhnHqg6WmLFeYWqZ0y90/+BK2D+v7gNaBoexywO4r1CyaRTietvcQ4fg==
X-Received: by 2002:a17:907:2895:: with SMTP id em21mr4791962ejc.164.1623438103912;
        Fri, 11 Jun 2021 12:01:43 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id c19sm2922016edw.10.2021.06.11.12.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:01:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 00/10] DSA tagging driver for NXP SJA1110
Date:   Fri, 11 Jun 2021 22:01:21 +0300
Message-Id: <20210611190131.2362911-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series adds support for tagging data and control packets on the new
NXP SJA1110 switch (supported by the sja1105 driver). Up to this point
it used the sja1105 driver, which allowed it to send data packets, but
not PDUs as those required by STP and PTP.

To accommodate this new tagger which has both a header and a trailer, we
need to refactor the entire DSA tagging scheme, to replace the "overhead"
concept with separate "needed_headroom" and "needed_tailroom" concepts,
so that SJA1110 can declare its need for both.

There is also some consolidation work for the receive path of tag_8021q
and its callers (sja1105 and ocelot-8021q).

Changes in v3:
Rebase in front of the "Port the SJA1105 DSA driver to XPCS" series
which seems to have stalled for now.

Changes in v2:
Export the dsa_8021q_rcv and sja1110_process_meta_tstamp symbols to
avoid build errors as modules.

Vladimir Oltean (10):
  net: dsa: sja1105: enable the TTEthernet engine on SJA1110
  net: dsa: sja1105: allow RX timestamps to be taken on all ports for
    SJA1110
  net: dsa: generalize overhead for taggers that use both headers and
    trailers
  net: dsa: tag_sja1105: stop resetting network and transport headers
  net: dsa: tag_8021q: remove shim declarations
  net: dsa: tag_8021q: refactor RX VLAN parsing into a dedicated
    function
  net: dsa: sja1105: make SJA1105_SKB_CB fit a full timestamp
  net: dsa: add support for the SJA1110 native tagging protocol
  net: dsa: sja1105: add the RX timestamping procedure for SJA1110
  net: dsa: sja1105: implement TX timestamping for SJA1110

 Documentation/networking/dsa/dsa.rst          |  21 +-
 drivers/net/dsa/sja1105/sja1105.h             |   4 +
 drivers/net/dsa/sja1105/sja1105_main.c        |  35 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c         |  97 +++++-
 drivers/net/dsa/sja1105/sja1105_ptp.h         |  13 +
 drivers/net/dsa/sja1105/sja1105_spi.c         |  28 ++
 .../net/dsa/sja1105/sja1105_static_config.c   |   1 +
 .../net/dsa/sja1105/sja1105_static_config.h   |   1 +
 include/linux/dsa/8021q.h                     |  79 +----
 include/linux/dsa/sja1105.h                   |  26 +-
 include/net/dsa.h                             |   8 +-
 net/core/flow_dissector.c                     |   2 +-
 net/dsa/dsa_priv.h                            |   5 +
 net/dsa/master.c                              |   6 +-
 net/dsa/slave.c                               |  10 +-
 net/dsa/tag_8021q.c                           |  23 ++
 net/dsa/tag_ar9331.c                          |   2 +-
 net/dsa/tag_brcm.c                            |   6 +-
 net/dsa/tag_dsa.c                             |   4 +-
 net/dsa/tag_gswip.c                           |   2 +-
 net/dsa/tag_hellcreek.c                       |   3 +-
 net/dsa/tag_ksz.c                             |   9 +-
 net/dsa/tag_lan9303.c                         |   2 +-
 net/dsa/tag_mtk.c                             |   2 +-
 net/dsa/tag_ocelot.c                          |   4 +-
 net/dsa/tag_ocelot_8021q.c                    |  20 +-
 net/dsa/tag_qca.c                             |   2 +-
 net/dsa/tag_rtl4_a.c                          |   2 +-
 net/dsa/tag_sja1105.c                         | 312 ++++++++++++++++--
 net/dsa/tag_trailer.c                         |   3 +-
 net/dsa/tag_xrs700x.c                         |   3 +-
 31 files changed, 551 insertions(+), 184 deletions(-)

-- 
2.25.1

