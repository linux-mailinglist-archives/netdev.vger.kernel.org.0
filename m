Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290673A322F
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhFJRhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbhFJRhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:37:08 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0CEC061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:34:58 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id r11so33954883edt.13
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G2dOZ8ymNMkSXXcUlvK4Aq7anW81kvR62sPQb/O4ikI=;
        b=HdcQ6MobrLufbzoBlhK09K05SUJMCg2oI5LL4tDPSQL/9N85IhXzqMhnIN1DD84qOy
         xc69FguNkIxxYDYj/jd8x+owEoGQE83g6O3QSxKCNFt2MaDvRHMF4NHM/SDr5J4qD7HM
         GUFPoi8npIqFLxKN5RWJPvpJVyah9SlhpogFgsrLF8R3MM66ZWHzgoMgjsrxCH1yXwP3
         yULfThO2MsutKlWdEF0EQB3MoZCjfitD+fi7SS/B5gAGyCoYxPqvfceBa/sE/fcRRdC7
         UIMdbZWfgBMVNF2cDAxtitonx9S3i6I2aAPK/vv2TvCoCEVFGrcIbnL4ywwoaD3E71Ch
         brGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G2dOZ8ymNMkSXXcUlvK4Aq7anW81kvR62sPQb/O4ikI=;
        b=BmTGXr8q6yvaNIzlBpRjnXTBCFQb7u0PigNX4g6DEh4+1T8r8JpdWP/fU2ZIfCxQ8F
         03uh+OmBOug/MOlRT2D+x92TlEs061LJUwfHr8Rc+cW92B/+HfNNp9/QfzGHArnMkW2i
         eG7JzikeMwiSjaWjnQVFSDT1LYhLYbk0FfAMCENF/GPV5IKrV5F1N4AmQHthRdplJmTS
         rUZAaiqt5YQSEQYFJE+myegSYSoe1HpS5SO85qTHHtOvfxUsFJMCe/ud/EnLvAA7rLy9
         mEXWn2iv3h3l5y/BtEi5TM3nmJ+23ho85d2PVFcX8Bew647uupB1YZbVJiH/2N2EXENm
         mpjw==
X-Gm-Message-State: AOAM532u+diXfm/xlmWZrNweLMnph9vBnhhw+rNTp1A/Cu4zwIKUAxTc
        OcTX3J4br+Z7u8cqvtMx+qk=
X-Google-Smtp-Source: ABdhPJzVuCE7hxhfhQEZ8cy6x8vFK1XTkAixIXat+wT6KeDRd9RFHurDedSywLhFpBndaFLYCxaVqA==
X-Received: by 2002:a50:a6c2:: with SMTP id f2mr602098edc.39.1623346497451;
        Thu, 10 Jun 2021 10:34:57 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g17sm1789595edp.14.2021.06.10.10.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 10:34:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 00/10] DSA tagging driver for NXP SJA1110
Date:   Thu, 10 Jun 2021 20:34:15 +0300
Message-Id: <20210610173425.1791379-1-olteanv@gmail.com>
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
 drivers/net/dsa/sja1105/sja1105_ptp.c         |  96 +++++-
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
 net/dsa/tag_8021q.c                           |  22 ++
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
 31 files changed, 549 insertions(+), 184 deletions(-)

-- 
2.25.1

