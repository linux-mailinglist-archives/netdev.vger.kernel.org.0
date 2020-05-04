Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41EBB1C49EB
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 00:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgEDW5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 18:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728118AbgEDW5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 18:57:21 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46402C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 15:57:21 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x17so446892wrt.5
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 15:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=p0wqQckVgtJPU/WsIc2gqoqI8PhGIAOFQ0q1H46E9lo=;
        b=or5SyXEK2vhpj50NNKXUIF95YBvlZAB1mMeaawUkMookPLxbeU9I5CCYCuUWg/PzsA
         NGVFbstcwDhs8NmcOupHZ2rw5IcYyMsPVxE+5v2vnao7/CSV9Vkqu37iATRzBfkyMXEz
         slzW2b+7a68tpFD/poqJBmUE9if14ZoXDyEf7EVxv8nEOmrShc2bo46VfTbpYmyFFNh+
         EcuhJoElEn1dXaCyq/7S0LucnSCL9FjmX7Ttu9sDqw7MfaK/nfrfjxxJNTgxbOGs59IW
         x7n7fMdqMVzYs4Ti7j1LX97fvajGLilwznC+l6JUBJxBczI2ghBzV7GDhqf9fh2zNXdY
         1T2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=p0wqQckVgtJPU/WsIc2gqoqI8PhGIAOFQ0q1H46E9lo=;
        b=ai9J7TXop65akDdORPBX5az9XVxdPoMfmu4AeY8Aznir0+F/a9xCRq2dqbKJlvQRCw
         ovo5ppDwzkOrP5UPYldF53IkHnd8FmTROM/XkS4G93sf6yg2YfSFnf6WKMUctcT6Kj71
         3gY0NzOQzmbs5lHUNycV748hcfY/bKRmichVPYIQHiF/gqqtfaKYB2tYXuazm/EdtOiX
         HHIJntihRQi+2Nd0y/cvVtxCZU+MegOZjnTD4AR9cuCHfxN0VNRHAjriV3rRggaKv7OH
         32cXBFAh98egSPf+NRXV1PPvy+183b5jPEcQjoLyin37NM2JPKPP+5n+AFAuDTxcb+RE
         D6jg==
X-Gm-Message-State: AGi0PuavTHtDynBBy1jfVMpFMA9hzF5haOKsgKZmwPLq1TPuVaSYSKK4
        2QhRDm1JR8gRm8VKlqoE4xTxqz0IakE=
X-Google-Smtp-Source: APiQypJguVxoUXvq20w0YUlpRGPDmR+w95WV5+8vslc5J8lNGvAwVAChb6x2pQiFKysAR9gn6wRoGw==
X-Received: by 2002:a5d:6850:: with SMTP id o16mr128331wrw.309.1588633039706;
        Mon, 04 May 2020 15:57:19 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id e2sm21146075wrv.89.2020.05.04.15.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 15:57:19 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, po.liu@nxp.com, xiaoliang.yang_1@nxp.com,
        mingkai.hu@nxp.com, christian.herber@nxp.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        vlad@buslov.dev, jiri@mellanox.com, idosch@mellanox.com,
        kuba@kernel.org
Subject: [PATCH net-next 0/6] tc-gate offload for SJA1105 DSA switch
Date:   Tue,  5 May 2020 01:56:42 +0300
Message-Id: <20200504225648.23085-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Expose the TTEthernet hardware features of the switch using standard
tc-flower actions: trap, drop, redirect and gate.

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

