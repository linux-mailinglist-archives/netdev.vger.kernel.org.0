Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C68D327995
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 11:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbfEWJpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 05:45:13 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:32825 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730034AbfEWJpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 05:45:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id d9so5529093wrx.0
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 02:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=NxGHefe6hWpEFp9LBZSGI9/TbmOU09arjq604Xawxho=;
        b=YEFstDq4WsG/IVUwMYKJ+VkpklcNHaKJ8uB2zgVZ9bwk13IHUmLu9cxwjpn+/1OIx6
         49O/a8Xz6PRR5sQWWcppm2fupMax/7jQIuwE6i0P1/qjJFncA3pmCHz13V4lwklkOfng
         FLVdgY9Ls+t2Z3+s5/Ps16aEZSlf2yoEFyznG7Jikc0bwsaYWNJ+8hwe0uWbIgILlRYr
         SEU0m5zYMt7AmS8AamClDlh8CBt2iB8ZSEWe3Ot+CNLvE5PGEHUUjjPLXK1KiYmCerVb
         FmefWqnBrjngnEDmUc0gzuThcj3rQFKiG6mjf2StosMCWabl+EgTJQ2zo0K7mNFotoAP
         OsSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NxGHefe6hWpEFp9LBZSGI9/TbmOU09arjq604Xawxho=;
        b=d33EZLXSaBQqoVH3yNJy9Z+yVs8x8iMSO7QaECh5UPwHU6cOkqAm2aD5HCyrFmvjPD
         KB2oOqz+p4BbkYJp8flGYYNlLyP4LEUZbuXAznENJBevopd8WQFUKio+17FSV9HEiEw0
         SO8wLRf84aT++e+qxTiubwxwLPnlPh941iei7rSPdo7fonARgP1VczFX24dMlewXg2mH
         mrfEXTeLS0VnpFjTAIM84NRkmcWDr3uRwVxnRkKoRZZFqBsKYIjKsFBiquz7/6xUOvgX
         Y+6GfdMJ4wKqVLR8ZLyqxI74CPqTqKEce+RhQWLuONbRoPeK4CHazw40Up1ppMB8rdpZ
         7eTQ==
X-Gm-Message-State: APjAAAVxRLx7fyOr3d+yqRhi77jDpOL1UmIbqgIAPS5dNRU0nlxGwSc2
        UlVNBvOuaAr7uBS7lJalqY91Uh8BrEo=
X-Google-Smtp-Source: APXvYqwa1bf5aT7ruRDS104ZF2O7uewNkxvFSrnB4db+MdAYH6UWEcRBPyfgNc2R6RMEAr4mBXE/dQ==
X-Received: by 2002:adf:9dd0:: with SMTP id q16mr58332352wre.28.1558604711596;
        Thu, 23 May 2019 02:45:11 -0700 (PDT)
Received: from localhost (ip-89-176-222-123.net.upcbroadband.cz. [89.176.222.123])
        by smtp.gmail.com with ESMTPSA id g11sm23463190wrx.62.2019.05.23.02.45.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 May 2019 02:45:11 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org
Subject: [patch net-next 0/7] expose flash update status to user
Date:   Thu, 23 May 2019 11:45:03 +0200
Message-Id: <20190523094510.2317-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

When user is flashing device using devlink, he currenly does not see any
information about what is going on, percentages, etc.
Drivers, for example mlxsw and mlx5, have notion about the progress
and what is happening. This patchset exposes this progress
information to userspace.

See this console recording which shows flashing FW on a Mellanox
Spectrum device:
https://asciinema.org/a/247926

Jiri Pirko (7):
  mlxsw: Move firmware flash implementation to devlink
  mlx5: Move firmware flash implementation to devlink
  mlxfw: Propagate error messages through extack
  devlink: allow driver to update progress of flash update
  mlxfw: Introduce status_notify op and call it to notify about the
    status
  mlxsw: Implement flash update status notifications
  netdevsim: implement fake flash updating with notifications

 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   2 -
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  35 ------
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   6 +-
 .../mellanox/mlx5/core/ipoib/ethtool.c        |   9 --
 .../net/ethernet/mellanox/mlx5/core/main.c    |  20 ++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   3 +-
 drivers/net/ethernet/mellanox/mlxfw/mlxfw.h   |  11 +-
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   |  57 ++++++++--
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  15 +++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   3 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  75 +++++++------
 drivers/net/netdevsim/dev.c                   |  35 ++++++
 include/net/devlink.h                         |   8 ++
 include/uapi/linux/devlink.h                  |   5 +
 net/core/devlink.c                            | 102 ++++++++++++++++++
 15 files changed, 295 insertions(+), 91 deletions(-)

-- 
2.17.2

