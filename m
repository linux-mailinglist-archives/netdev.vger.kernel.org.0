Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B50333C21
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbhCJMEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbhCJMEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:04:44 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D98CC061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:43 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id mm21so38114738ejb.12
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LHpzGm8+FreuOROoPwKoj8lTjYfDOBZcAFwlRXowdYQ=;
        b=M7wbcQD28ITQRWMQo2mOWYNPkv0pNyRXngzZXXMyZSfK5UqVEeUPgDZVwhjdKYBnC1
         QObVvDauALS/PZXUUXBXkZMjBLOLRT1ZnJzPL2lvM1HjzGBV488PepGTjwEUQfMvA8Ae
         WwrOCDCZD+qVgnJtrCi1aQr/Oa2K8aSe2VP1bhCI6bsri7qwgJpd2+hwdkOrJJRymMzP
         qhSyNS0nNfbj8kVwDK1WRjDtzTHzRmHSsXenYHoH9QMvwTTnih6mUkgLeEw382YChyTE
         mx6yMn6rnOhxBSJo23xVdaJHe8u4NAC5lofE9Mq3lDHdGdWIimv1k5SMlMcJGCntVQIE
         41bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LHpzGm8+FreuOROoPwKoj8lTjYfDOBZcAFwlRXowdYQ=;
        b=VaPY6UulyszPciLThE6QPJgPnFobGmHGgLttWocvpI7PVoB0XAKiCgG9XoI47Qnzw8
         G288h0HjMuZjAm09fpfbqvJMu6mEfC0VcqE88StHkzy0G/febhcIOYn3cEZFOyTjTY/Y
         1gcn2DLeSSTUiuCXxUZCdxXuQWwqJN+2lfL19wurchoAkQK60yHF/yDyT3SwrnTyIXwt
         MnuYtQyoaT0zEMXAcyCRezqQPOZRBnfLBiAEQ4BLd/CoBl16hESTxmqwxUcdjGjrtvIe
         JLhDChT+4/RESkfSEHoyoCXeWNQFANzB+KD2tItrLRMY+nOYcOaIUMW3UK5QJPQqCzn9
         hxSQ==
X-Gm-Message-State: AOAM532IFlVvLfzE6QwLB9zNvY22DqiGiO2rxc9qNZAluaw+7YSAShVK
        IiE+T4M7BWUuaFXcCUs3IN8=
X-Google-Smtp-Source: ABdhPJznqw2zLOTOZsnMDxnw6hgwLE0cUSAuekNQVyZcTuZudId60y3YhE1JCS4PuVIwzoyyr4jmRQ==
X-Received: by 2002:a17:907:16a8:: with SMTP id hc40mr3262537ejc.40.1615377881831;
        Wed, 10 Mar 2021 04:04:41 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id q20sm9913239ejs.41.2021.03.10.04.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:04:41 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 00/12] Refactoring/cleanup for NXP ENETC
Date:   Wed, 10 Mar 2021 14:03:39 +0200
Message-Id: <20210310120351.542292-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series performs the following:
- makes the API for Control Buffer Descriptor Rings in enetc_cbdr.c a
  bit more tightly knit.
- moves more logic into enetc_rxbd_next to make the callers simpler
- moves more logic into enetc_refill_rx_ring to make the callers simpler
- removes forward declarations
- simplifies the probe path to unify probing for used and unused PFs.

Nothing radical.

Vladimir Oltean (12):
  net: enetc: move the CBDR API to enetc_cbdr.c
  net: enetc: save the DMA device for enetc_free_cbdr
  net: enetc: squash enetc_alloc_cbdr and enetc_setup_cbdr
  net: enetc: save the mode register address inside struct enetc_cbdr
  net: enetc: squash clear_cbdr and free_cbdr into teardown_cbdr
  net: enetc: pass bd_count as an argument to enetc_setup_cbdr
  net: enetc: don't initialize unused ports from a separate code path
  net: enetc: simplify callers of enetc_rxbd_next
  net: enetc: use enum enetc_active_offloads
  net: enetc: remove forward-declarations of enetc_clean_{rx,tx}_ring
  net: enetc: remove forward declaration for enetc_map_tx_buffs
  net: enetc: make enetc_refill_rx_ring update the consumer index

 drivers/net/ethernet/freescale/enetc/enetc.c  | 284 ++++++------------
 drivers/net/ethernet/freescale/enetc/enetc.h  |  34 ++-
 .../net/ethernet/freescale/enetc/enetc_cbdr.c |  82 ++++-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  56 ++--
 .../net/ethernet/freescale/enetc/enetc_vf.c   |   7 +
 5 files changed, 212 insertions(+), 251 deletions(-)

-- 
2.25.1

