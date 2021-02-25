Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A173324F17
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 12:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235522AbhBYLZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 06:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbhBYLYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 06:24:55 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F09C061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 03:24:15 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id c6so6407082ede.0
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 03:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f9CoI6+o7lHbdWJowEye8ec9en6enB/DY/bQIiYRvWc=;
        b=SvPI81APbZUTYOQXhbmKgti+xvxHQjW4jrQ+Pa9ToMvcF3EAClyX4DQJQgQLQNA1wm
         riwNPH131AMQS2ehDRiUAglvEyNAGFkjnRHHfSesZlNXEtE6tDOmSQhRzWaHhkQ+8aW6
         9e89xJ/5KZ23+HpTeV0FryJpMy04Ia+tAUMaqspoccPmc1DtGPTcsGo9rvUBULFKS7JL
         It7JyGObcgzRn/63QEpPmWqIbwFYOpX/BdB7R3Zz09Y9Posyob1gMou6SlZkjv5hqA1N
         /8QqNVpYAYohkmrp/vYqdPoQQh8ub4Ai0VBQu+8xXfQV5eIWe4XhtwqoLn/yBXHhKL/V
         dTpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f9CoI6+o7lHbdWJowEye8ec9en6enB/DY/bQIiYRvWc=;
        b=gZeNiGVTp9dszzUe4d1Zf39ZGGC98D3aFjwAtWRHWtvi2ib7ZCOa7tMufTgKgg0eNK
         BKpI+pS0yjOengDyGtw1oqn3OiQQMb3HovpxTurqsaBBSeexT1qRULwVzZlxVjISSwjH
         aLf78VNJ3jAv/IDkk3Lsjhst5nupFMbtKL2ERrR2n3KX374C8zQFbwgN/OTWifnleYF5
         aFlDXIBPKfieWMFuxI041eVPlskncqow03XG8Qm5LKspIvoIkLwKU1Q4ikRCTJSXrGib
         e2pO+VTArzj8LDcv08Sh3Lsoja7wJp/rdZC39Wb88KOZI4fKP3sD/OhBWdAVDduxMe2a
         PNLQ==
X-Gm-Message-State: AOAM533UOELih4GLXD1QuYIjcB9iKqfJBBnDyAbGyfzuXGeo1kPVzv/v
        rmKZFCTk7bhuvIv9KT9Xum4=
X-Google-Smtp-Source: ABdhPJwfzJtJTSM2OXHQdlDGwobBNuuj2y0AH4opY7AK+yNkS6UrRzqTzXlwusb2coiptA6nes6s6A==
X-Received: by 2002:a05:6402:95b:: with SMTP id h27mr2337535edz.77.1614252254165;
        Thu, 25 Feb 2021 03:24:14 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id v12sm2977156ejh.94.2021.02.25.03.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 03:24:13 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net 0/6] Fixes for NXP ENETC driver
Date:   Thu, 25 Feb 2021 13:23:51 +0200
Message-Id: <20210225112357.3785911-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This contains an assorted set of fixes collected over the past week on
the enetc driver. Some are related to VLAN processing, some to physical
link settings, some are fixups of previous hardware workarounds.

Vladimir Oltean (6):
  net: enetc: don't overwrite the RSS indirection table when
    initializing
  net: enetc: initialize RFS/RSS memories for unused ports too
  net: enetc: take the MDIO lock only once per NAPI poll cycle
  net: enetc: fix incorrect TPID when receiving 802.1ad tagged packets
  net: enetc: don't disable VLAN filtering in IFF_PROMISC mode
  net: enetc: force the RGMII speed and duplex instead of operating in
    inband mode

 drivers/net/ethernet/freescale/enetc/enetc.c  | 127 +++++-------------
 drivers/net/ethernet/freescale/enetc/enetc.h  |   5 +
 .../net/ethernet/freescale/enetc/enetc_cbdr.c |  54 ++++++++
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  18 ++-
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 103 +++++++++++---
 .../net/ethernet/freescale/enetc/enetc_vf.c   |   7 +
 6 files changed, 202 insertions(+), 112 deletions(-)

-- 
2.25.1

