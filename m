Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC3A377F83
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 11:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhEJJkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 05:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbhEJJkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 05:40:23 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE13AC06175F
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 02:39:17 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id n2so15930673wrm.0
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 02:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+SgeOxyLw6D2/NYUiDSf169BhY4hR61jsyOaUfcQmUE=;
        b=XlM1DnUAdIcmRd9TXZWdY9CWrS0mBvGfYTBvFolXTxqwL5oqT3SCt07EGI9jam1/J6
         Z8q/RI5Z49cZrpH4nD/6T20lpXaijCiCs2yg9dk6M1yxmKpniS5/b4PVK+l48EFhAEKs
         veYDSmkY/231J2Xof0kELRRPvG//BbFLEzXedfp/T3pO2a5hy5HuFqCtig37gCBcv2Ig
         8IRly157ocv7K5IKSPUegLICEwv771rniCizPr+1PQ0CnFpXQCM9Whig7eADf+qhrTSv
         Da8WopB6wCDVNkBOzVVXPkT21IE+tZExMUz1ASTAALp5A0xJv19F3d8gibQJjDgODiGE
         KNzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+SgeOxyLw6D2/NYUiDSf169BhY4hR61jsyOaUfcQmUE=;
        b=LZtlfZ7NU4yPrN6pnh++vf0vEunD4QWgj8ZvlMEepOkoD03g6BR5buKAN+r18g2FRz
         ycFCaNvo1i9N5KRTs0RcQ7gE6ElX/MpgeWP/d0k+9owOodqVDUNyGoTyCZEmYcbMDC5c
         J0+QwqVhspRSdfUkqDxSHx50PB7lkk9WgzHki3gKaYesly3Q014sImdbFVuc8p7wYNbt
         17qLUM1ZRwtwdnzo43LIEk8GMiwo2RHFIhxMNOjqXgnQJRj2sNLq4Djy1TcgcAllQGkV
         RYaZb4EHEK+dI9bg0uW/8vpmK18vdldZzPnw3Ny5ifxWcVye5O7TqO+YKcX6qGQWLG88
         MF9w==
X-Gm-Message-State: AOAM5319IP0DoI4YDh9zEIpgjPSGLCYXY1Gtxk1jykE6xJ5tPE2VMZ/8
        OENQ8maYanFa9RMdaO7GcacWR/Cc0qVcNA==
X-Google-Smtp-Source: ABdhPJzlLsWqwkVkk3M/J7zDqY+T8QpXyIetN4EkJV3yzpQaVNedgCpq8B9+7JaF5aBwr7cupfg6eg==
X-Received: by 2002:adf:f60d:: with SMTP id t13mr30146922wrp.189.1620639556750;
        Mon, 10 May 2021 02:39:16 -0700 (PDT)
Received: from localhost.localdomain (h-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id i2sm25892933wro.0.2021.05.10.02.39.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 May 2021 02:39:16 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        netdev@vger.kernel.org, brouer@redhat.com
Subject: [PATCH intel-net v2 0/6] i40e: ice: ixgbe: ixgbevf: igb: igc: add correct exception tracing for XDP
Date:   Mon, 10 May 2021 11:38:48 +0200
Message-Id: <20210510093854.31652-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing exception tracing to XDP when a number of different errors
can occur. The support was only partial. Several errors where not
logged which would confuse the user quite a lot not knowing where and
why the packets disappeared.

This patch set fixes this for all Intel drivers with XDP support.

v1 -> v2:
* Applied fix to new XDP support in igc driver
* Rebased on latest net

Thanks: Magnus

Magnus Karlsson (6):
  i40e: add correct exception tracing for XDP
  ice: add correct exception tracing for XDP
  ixgbe: add correct exception tracing for XDP
  igb: add correct exception tracing for XDP
  ixgbevf: add correct exception tracing for XDP
  igc: add correct exception tracing for XDP

 drivers/net/ethernet/intel/i40e/i40e_txrx.c      |  7 ++++++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c       |  8 ++++++--
 drivers/net/ethernet/intel/ice/ice_txrx.c        | 12 +++++++++---
 drivers/net/ethernet/intel/ice/ice_xsk.c         |  8 ++++++--
 drivers/net/ethernet/intel/igb/igb_main.c        | 10 ++++++----
 drivers/net/ethernet/intel/igc/igc_main.c        | 11 +++++------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c    | 16 ++++++++--------
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c     | 14 ++++++++------
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c    |  3 +++
 9 files changed, 57 insertions(+), 32 deletions(-)


base-commit: b741596468b010af2846b75f5e75a842ce344a6e
--
2.29.0
