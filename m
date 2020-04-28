Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43BA11BB37C
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 03:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgD1Bja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 21:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726233AbgD1Bja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 21:39:30 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A794DC03C1A8
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 18:39:29 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id k12so919205wmj.3
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 18:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+VHDToFUkQx17F7vpQL7qWDgEvwbDvbGLlw9yW0HZ/w=;
        b=nioYlwqaAvMTfCI3Cs3Uz7jevUlrujv5JDikc4FaFoBNwlKhI23HFrFshE3t2YsiIj
         LOoL7IOqQnU+vD882F9tdPzqeY8+UwdjcdkxewWFy/Omn6rnPoKrjhbTGjgEFXdrDdz7
         uQdIvBWl8f3LhsEn4ggBWLQCyddSPfDdAsJJz8npIwM8IyX9J6z2eC8eLQO+kF3i4kGF
         q5uldQV2IF9LKWRCrCWlFggeKePvvTK3H/RdzUyJFczwNB6/TsiKL+dV7V/H03rGCDyB
         +lOwiC1vTGkweEWfChWGUXmridvHEXtZ1v8Igkes1Hxo9iO/YSGIQ6avJSvCghGnbTfV
         NKGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+VHDToFUkQx17F7vpQL7qWDgEvwbDvbGLlw9yW0HZ/w=;
        b=eXy2oamgRbWvVsb8LUEHXlzvtAx/xuFKps3u3JtyAYCgtxbDB5N6Tp/XcpMhi/5hII
         KjamaliZCX+jHZJWNeJjTsrQhWugSIBweqhzCRWDb4VcQxxZQzT1sMV2nmSbVv1nfVmG
         aGdZsOYiDNP5DK5cMNZa2r/2nBVLr9hlcdzpd25RBn9iBjPqHKiG3NfaKOKIFdm+rBqo
         n6uuLA+GXKXZCVgrjDiBg3VLg2ZrFIOB0MdJUsr1v1G6zvgFVPpJflrjE5ohi3O+bBEh
         4pZNGUuO0PD0ocAQVXFwOBLDf6Pzy0MkMLum/FZaLet4glkFGQxpQ3u9FCBTMU69moen
         EEdw==
X-Gm-Message-State: AGi0PuaaQY/wMrQ+wXpo+PXy9/bz4dO1h3nZ4HhFWs6oBhspIHfszgYq
        l019wZc1xt9ZxikxS9Hh7L7V2O3g
X-Google-Smtp-Source: APiQypLjMP9kIDjF1BhBNpMpjPHvGrRtfB4DvklnsALRvoXcf/mb0JKLM3N9snjc4NxMuhMqzL4TQQ==
X-Received: by 2002:a1c:a794:: with SMTP id q142mr1699465wme.4.1588037968101;
        Mon, 27 Apr 2020 18:39:28 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id u188sm1235348wmg.37.2020.04.27.18.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 18:39:26 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, po.liu@nxp.com, xiaoliang.yang@nxp.com,
        mingkai.hu@nxp.com, christian.herber@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, vlad@buslov.dev, jiri@mellanox.com,
        idosch@mellanox.com, kuba@kernel.org
Subject: [RFC PATCH 0/5] tc-gate offload for SJA1105 DSA switch
Date:   Tue, 28 Apr 2020 04:39:01 +0300
Message-Id: <20200428013906.19904-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is a prototype implementation of tc-gate offload, implemented using
Po Liu's patch series:

https://patchwork.ozlabs.org/project/netdev/cover/20200422024852.23224-1-Po.Liu@nxp.com/

Posting as RFC until the above is merged.

Vladimir Oltean (5):
  net: dsa: export dsa_slave_dev_check and dsa_slave_to_port
  net: dsa: sja1105: add static tables for virtual links
  net: dsa: sja1105: make room for virtual link parsing in flower
    offload
  net: dsa: sja1105: support flow-based redirection via virtual links
  net: dsa: sja1105: implement tc-gate using time-triggered virtual
    links

 drivers/net/dsa/sja1105/Kconfig               |   9 +
 drivers/net/dsa/sja1105/Makefile              |   4 +
 drivers/net/dsa/sja1105/sja1105.h             |  59 +-
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |  51 ++
 drivers/net/dsa/sja1105/sja1105_flower.c      | 207 ++++-
 drivers/net/dsa/sja1105/sja1105_main.c        |  13 +-
 drivers/net/dsa/sja1105/sja1105_ptp.h         |  13 +
 drivers/net/dsa/sja1105/sja1105_spi.c         |   2 +
 .../net/dsa/sja1105/sja1105_static_config.c   | 202 +++++
 .../net/dsa/sja1105/sja1105_static_config.h   |  65 ++
 drivers/net/dsa/sja1105/sja1105_tas.c         | 127 ++-
 drivers/net/dsa/sja1105/sja1105_tas.h         |  31 +
 drivers/net/dsa/sja1105/sja1105_vl.c          | 797 ++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_vl.h          |  72 ++
 .../net/ethernet/freescale/enetc/enetc_qos.c  |  17 +
 include/net/dsa.h                             |   2 +
 net/dsa/dsa_priv.h                            |   8 -
 net/dsa/slave.c                               |   9 +
 18 files changed, 1636 insertions(+), 52 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_vl.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_vl.h

-- 
2.17.1

