Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5A1369002
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 12:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241755AbhDWKFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 06:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhDWKFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 06:05:41 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564ECC061574
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 03:05:05 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id g9so31757120wrx.0
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 03:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r4tFvADt1vOjGuicyc10hP8PHZVHJ+hNpypqyZ4CeHc=;
        b=gPdjnFBfJ7XHP6uPz0huOkxajCxgMf766QrhET6PpZJeSLhGzkmzitKdWQaIHUftZS
         n1yOcYCb/GV4Y4vPOY44nYlDKAePuWg7J9BX6I1PivLrVaxDrgSYhRQe7JqjLFOdyG2Z
         H3LTEiTc143PYZA6zSzWTK7NGTKtBc4IuJsjlhtSHRha8TXS05BrgWN2xQEPA1pjV6QZ
         LS+IJS2lwEaJzGOHK5QRvMd3eDsjC9nSyRS9qKPmeqEe5BCKdLi0SshDoRItWkwRgwkJ
         ow9oGcY9XRGJvAzn6M3nfOvCWvPjBmwaNUiEcWqmR9qimQn22dmri1L2waK11kEQ+tO8
         l0rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r4tFvADt1vOjGuicyc10hP8PHZVHJ+hNpypqyZ4CeHc=;
        b=n4xJoGtpUPqmSZg08wqZbb3uyEsbODE8JXoVIAyckT8P6bZ2tjRSKPXyrsW8LPKKqT
         Mwdcmgjvqyw3L6mpYLvXo81AANVXnFCh18Rw1Tkt5YmhFwMdO5PO7QQagjquDmYgB4Z+
         C/XMza8eraj3yPn47xIU6ECPvTh94eogBiwKeW6WhoQLXff4KDi4n0gySePNCszbX/bu
         sINITJ9gUdZtdknGoXy/LRw4MI5cPtsZ/PAApcGo2A30OmTgctYKYAXeTkhCfTSipxo1
         YHw9fHIa5cDLwfmvtu3b9Gp8YHPLibm7dz5/bIDdfsTHZ7zHBJXdD97z04ln3MMnm6a1
         KeTw==
X-Gm-Message-State: AOAM5321RCh3OBPQUAkoLy1dFO0NnMc5V5/tL6AtAZg9oSCv1PoK93Y3
        4QPzvCU7dRi51MnzMmkJdec=
X-Google-Smtp-Source: ABdhPJxYh8G37u54IHqUpwjDdauZRWo/0vwozNTHzrei35CVUTlpatOyHc94wyT3jSolHlNuMgEQAw==
X-Received: by 2002:a05:6000:190:: with SMTP id p16mr3699901wrx.334.1619172304101;
        Fri, 23 Apr 2021 03:05:04 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id t12sm8599481wrs.42.2021.04.23.03.05.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Apr 2021 03:05:03 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        netdev@vger.kernel.org, brouer@redhat.com
Subject: [PATCH intel-net 0/5] i40e: ice: ixgbe: ixgbevf: igb: add correct exception tracing for XDP
Date:   Fri, 23 Apr 2021 12:04:41 +0200
Message-Id: <20210423100446.15412-1-magnus.karlsson@gmail.com>
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

Thanks: Magnus

Magnus Karlsson (5):
  i40e: add correct exception tracing for XDP
  ice: add correct exception tracing for XDP
  ixgbe: add correct exception tracing for XDP
  igb add correct exception tracing for XDP
  ixgbevf: add correct exception tracing for XDP

 drivers/net/ethernet/intel/i40e/i40e_txrx.c      |  7 ++++++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c       |  7 ++++++-
 drivers/net/ethernet/intel/ice/ice_txrx.c        | 12 +++++++++---
 drivers/net/ethernet/intel/ice/ice_xsk.c         |  7 ++++++-
 drivers/net/ethernet/intel/igb/igb_main.c        | 10 ++++++----
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c    | 16 ++++++++--------
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c     | 13 ++++++++-----
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c    |  3 +++
 8 files changed, 52 insertions(+), 23 deletions(-)


base-commit: bb556de79f0a9e647e8febe15786ee68483fa67b
--
2.29.0
