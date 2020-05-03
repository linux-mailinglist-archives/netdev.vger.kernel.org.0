Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433301C2F5F
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 23:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgECVK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 17:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729089AbgECVK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 17:10:57 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855C6C061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 14:10:55 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s8so8244589wrt.9
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 14:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MBPV0ZSKVwApIY7NcTsAchXJNIl1nqt2hzkdLCcOyeo=;
        b=h5eVRN7UJet5W30ejMnNNfG+R3yOqxTQZIU4EGw56zq6iKyNxpvJrbn0KLIuzjP4eN
         BHg2zCrwfQEj6xlgeLaBYLd3pNZllkXb301V8PubHHCcL/trLNznMi0Ey7nSyjDitg1r
         rCQvWEJDAepdZLzX67QulU58hAcgWqZJ7OUqNLHQ4RTgQl7wMf6gfB0duL4Xuwf42svX
         +Ql+H8j1vGWAqAhht5O+Fr0gZJSzmyd53RBgeynNm+iq0wRCTJQCdM5c5DFXh3BVzL7z
         RpV5eEOnNUFzO2pe6eLnDkjzNjduG8IYfK6ufo+f7mCalwvFmRqUTyiZYCO9batsESqk
         zp5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MBPV0ZSKVwApIY7NcTsAchXJNIl1nqt2hzkdLCcOyeo=;
        b=IIVK3RoT14dwQY5MyhvLZRVkJ+q+fOVtTcrvl185qac6Za9UwbUvyHF4+YvqYJvWwe
         nHl2luIkSQrseXjWY3G3vzE9OBC7IRzsPUvu11Ta+EECl3Wh/+6/qg584XUX/Pw8Fndt
         hq/I9ROXVRtEX5W2Tze1MmTcKLV+d4fXwf7ZydlMoJnjCCobN1Nj2JPSzl8AtAmXhXNw
         44s710cEUdzYDelp5GFwjEuWSbp5GpTVYLi5b/Lg9XVA8AvhoxD3uHNFMLRR9NURao9X
         WoW79BoqnDPHMz2gB90eBkimFWS/sfs4DZhIZ3ImlWJWinZnr8s7Pm/bl9SKd4Zge/QT
         2jZg==
X-Gm-Message-State: AGi0PuYo6BlGnZ5DubNOo5aSUVt5w9k3SJRUWBu2+3rifaUC+E31+YY8
        XIriPKNL95YsIIgXFf1KlcrRtqp1
X-Google-Smtp-Source: APiQypJ0L5v81bguFDIKJPm044ZyxcZlKQMTxY20EDE3TvdBrFWn+LY1rG00q6Vn6J70iriDDXLKQg==
X-Received: by 2002:adf:978c:: with SMTP id s12mr15297817wrb.312.1588540253068;
        Sun, 03 May 2020 14:10:53 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id s6sm10252682wmh.17.2020.05.03.14.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 14:10:52 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, po.liu@nxp.com, xiaoliang.yang@nxp.com,
        mingkai.hu@nxp.com, christian.herber@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, vlad@buslov.dev, jiri@mellanox.com,
        idosch@mellanox.com, kuba@kernel.org
Subject: [PATCH net-next 0/6] tc-gate offload for SJA1105 DSA switch
Date:   Mon,  4 May 2020 00:10:29 +0300
Message-Id: <20200503211035.19363-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Expose the TTEthernet hardware features of the switch using standard
tc-flower actions: trap, drop, redirect and gate.

Vladimir Oltean (6):
  net: dsa: export dsa_slave_dev_check and dsa_slave_to_port
  net: dsa: sja1105: add static tables for virtual links
  net: dsa: sja1105: make room for virtual link parsing in flower
    offload
  net: dsa: sja1105: support flow-based redirection via virtual links
  net: dsa: sja1105: implement tc-gate using time-triggered virtual
    links
  docs: net: dsa: sja1105: document intended usage of virtual links

 Documentation/networking/dsa/sja1105.rst      | 116 +++
 drivers/net/dsa/sja1105/Kconfig               |   9 +
 drivers/net/dsa/sja1105/Makefile              |   4 +
 drivers/net/dsa/sja1105/sja1105.h             |  59 +-
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |  51 ++
 drivers/net/dsa/sja1105/sja1105_flower.c      | 215 ++++-
 drivers/net/dsa/sja1105/sja1105_main.c        |  13 +-
 drivers/net/dsa/sja1105/sja1105_ptp.h         |  13 +
 drivers/net/dsa/sja1105/sja1105_spi.c         |   2 +
 .../net/dsa/sja1105/sja1105_static_config.c   | 202 +++++
 .../net/dsa/sja1105/sja1105_static_config.h   |  65 ++
 drivers/net/dsa/sja1105/sja1105_tas.c         | 127 ++-
 drivers/net/dsa/sja1105/sja1105_tas.h         |  31 +
 drivers/net/dsa/sja1105/sja1105_vl.c          | 796 ++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_vl.h          |  72 ++
 include/net/dsa.h                             |   2 +
 net/dsa/dsa_priv.h                            |   8 -
 net/dsa/slave.c                               |   9 +
 18 files changed, 1742 insertions(+), 52 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_vl.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_vl.h

-- 
2.17.1

