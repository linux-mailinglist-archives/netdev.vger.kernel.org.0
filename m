Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E271C49F0
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 01:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgEDXAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 19:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728145AbgEDXAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 19:00:45 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFC6C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 16:00:45 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id d15so468867wrx.3
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 16:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=k84+CyeUkzPtWA1Vkzw4sOhnnGMXXH5R2rSUq2n4/8w=;
        b=G+Ia9Swt+aANCwa4tiOIpudMjPG06jby673pLz6c9+qTt1rxHDucRSoGCQrDFKuCEV
         /kMde4t02xq3rxuxly04PMgwqoSXXO4jVdvAvYzJ5MxTsXa6vCA4rvkeTq/qC9y2v87m
         SUrw1GWL2KS8q90VXC/tsgs1U5XaxC8j+0aMPr9wKol9HkUZdOuFLQIaxqogMYc1SV/C
         xz2KVSUmsrdvzOL2lwZw0Cb7afxJLkm2tViw4EFhQ91GvNvitpsFiog7FvhsD5vTbQgU
         BRtVZT2NGb20kA9o9sUu/zBqSfpPM0V31vHN+TRLfMfh/3P5kytbdMMRTxcYJcOAXSxy
         UUVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=k84+CyeUkzPtWA1Vkzw4sOhnnGMXXH5R2rSUq2n4/8w=;
        b=DpDL0ZIKJW/sFzogzgJfhRld0gGO3XvMQ9RnoNoIbP2BoFlRydVbxYnq9CieXa5Wm2
         IbG4I73WnvfAkLQimkaN4H4V/4M9xOtY+dGZzzy0hx96FI0D8cPcnL+Dgzra4SeJt2rL
         F59lRf2xNalU84I8q1nk/gUFDqsCOC76BZDjDXyXLTGC5d29RgXW7ya2CDe2EfWkfbJk
         xMRIFZVR6GAXY/mt1OMXKvq3oGL6tKzc8XQcbz7XCkyb9nIkslGTpgMDXIYvHJlFH+8S
         XRMoPDrzQ0D5Tbqp2aVrSWGXFMcEvGXipZFGWFM1A30f25fJw9+yYMfhieDaTDMetBOW
         /MjA==
X-Gm-Message-State: AGi0PububSKOuec1xhl7nhSZ+3gxX27wJ0EZWP4brfjCX4vhf4rt4Wu/
        xmY+pWD5wUvZniA1fiL71rJsWpS+17Q=
X-Google-Smtp-Source: APiQypIZk0Jl4H/lDcgVyx9iDLDIcAd/G9H2V8nvgACXr+ShTwlz52khxhq2HX/z+sUoDq2FE0E65Q==
X-Received: by 2002:a5d:4645:: with SMTP id j5mr174384wrs.282.1588633243953;
        Mon, 04 May 2020 16:00:43 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id r23sm15322570wra.74.2020.05.04.16.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 16:00:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, po.liu@nxp.com, xiaoliang.yang_1@nxp.com,
        mingkai.hu@nxp.com, christian.herber@nxp.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        vlad@buslov.dev, jiri@mellanox.com, idosch@mellanox.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 0/6] tc-gate offload for SJA1105 DSA switch
Date:   Tue,  5 May 2020 02:00:28 +0300
Message-Id: <20200504230034.23958-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Expose the TTEthernet hardware features of the switch using standard
tc-flower actions: trap, drop, redirect and gate.

v1 was submitted at:
https://patchwork.ozlabs.org/project/netdev/cover/20200503211035.19363-1-olteanv@gmail.com/

Changes in v2:
Using a newly introduced dsa_port_from_netdev public helper.

Vladimir Oltean (6):
  net: dsa: introduce a dsa_port_from_netdev public helper
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
 include/net/dsa.h                             |   1 +
 net/dsa/dsa.c                                 |   9 +
 17 files changed, 1741 insertions(+), 44 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_vl.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_vl.h

-- 
2.17.1

