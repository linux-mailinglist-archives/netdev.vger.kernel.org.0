Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF54D2B11
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 15:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388205AbfJJNS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 09:18:56 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:42773 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388187AbfJJNS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 09:18:56 -0400
Received: by mail-wr1-f47.google.com with SMTP id n14so7838304wrw.9
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 06:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7ZMBPmFv0eFP8ZpRrxlw3T9MpSXeVND1qhlW0d7u3xc=;
        b=0Jkaqu66qvD278F+/BDmqcSyXCSrUVWXdHmLLYgcFI9/Yi7R8P65cYTZC7GaTu3HKZ
         JzmGdpUIcHTEkAd4AkrsXuWGrsMUpyHpVAJDPLi6AlRYodsXGtMZYKMeUVILGeFNvaiR
         xdDojwRK7MgVXQTyNn0cJCA1odlLn2nFTaSLOReEdXlZVC8S+7lT7H/YGN+k29B3ZfM6
         5ScW4VgrCmHfe+EpyndLxtdBc4LHDz7j+jShrsrtzc+CwKA29lgH7oJyZtE9NwQcOZL+
         Do+5UIO4n+jdrFlzPYEP2qzTux7VdeV+msojSX0oVFKAPH6qaQ6s+V1suaL96dvbsVB1
         y3jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7ZMBPmFv0eFP8ZpRrxlw3T9MpSXeVND1qhlW0d7u3xc=;
        b=iBUBIrBOJNa42QlRzaXv83nY5zdHaLDMJptB4GLn2h18Yz6VrQiq+rnv6Bog4V+rrl
         6GBPn2B2V9XbO2BDGOusNB4p32zXv9OE4ujXnIAVcWMuzPpl+XDnc1Dp7uJmeZusl6Zc
         Ej/rLzkcWWDAIBMEXdAB5BOFwTd62w+w9KZof8STicTugn4mtxtTZTg8rHYNy61IQD6w
         GA2iogKac35bUWMLWcSCoa0Sv6uwp4pa3C91UCKtyVxXAkRpJWGHffZ1E+df3Vwm1QkT
         UTXcVLLNyW9yoEHYrPiZiMCF2/LDAEolreTfKOlBXhk8wz70U4d9oLmtZNNItOK7CJZD
         pjcg==
X-Gm-Message-State: APjAAAWsQnr6b5TiMOwgXnCh7C5LOLBJXHakQZkXCtNvR8ULnfHuEMDl
        Un9CTaahmcZD5g1Muu50uX4bAgiVccM=
X-Google-Smtp-Source: APXvYqyu31V2crjblDb/RaQkBgfWQXhu8jarlm7XyGcnDBguVLN1bIlA8ryjVzpvc6doeuSwN4I0pA==
X-Received: by 2002:a5d:4a0e:: with SMTP id m14mr8328836wrq.102.1570713533427;
        Thu, 10 Oct 2019 06:18:53 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id d78sm6565580wmd.47.2019.10.10.06.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 06:18:52 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        ayal@mellanox.com, moshe@mellanox.com, eranbe@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 0/4] netdevsim: add devlink health reporters suppor
Date:   Thu, 10 Oct 2019 15:18:47 +0200
Message-Id: <20191010131851.21438-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

This patchset adds support for devlink health reporter interface
testing. First 2 patches are small dependencies of the last 2.

Jiri Pirko (4):
  devlink: don't do reporter recovery if the state is healthy
  devlink: propagate extack down to health reporter ops
  netdevsim: implement couple of testing devlink health reporters
  selftests: add netdevsim devlink health tests

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |   9 +-
 .../mellanox/mlx5/core/en/reporter_rx.c       |   6 +-
 .../mellanox/mlx5/core/en/reporter_tx.c       |   6 +-
 .../net/ethernet/mellanox/mlx5/core/health.c  |  12 +-
 drivers/net/netdevsim/Makefile                |   2 +-
 drivers/net/netdevsim/dev.c                   |  17 +-
 drivers/net/netdevsim/health.c                | 325 ++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h             |  13 +
 include/net/devlink.h                         |   9 +-
 net/core/devlink.c                            |  23 +-
 .../drivers/net/netdevsim/devlink.sh          | 127 ++++++-
 11 files changed, 522 insertions(+), 27 deletions(-)
 create mode 100644 drivers/net/netdevsim/health.c

-- 
2.21.0

