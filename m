Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6703C660DA3
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 11:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjAGKL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 05:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjAGKLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 05:11:55 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD757CDF7
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 02:11:54 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso7807898pjt.0
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 02:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wpItY9Sz20amojq0jQWv/84F+QgeiJg5IKiSbEpUsr4=;
        b=1mfSZjOaKNg6lvrosJse0HvbPEFTSCcT8SP5+zVs7Rtwkn1Efb6pt95KpPTXvbNpzN
         6eP2aLkv7mxQsuT4VIE487Y7PHY+mEEhZrzvzBpbNLwOv26Jl27ixQ3Xp/u1vp1eheUp
         HUnTyrRa7CGhRbSawY9VzOqz6dVggFqqePE/CjT93dNaRDplBkJcjCMDVFw/skdqsxTm
         lEbcdkhDmwIoyzO+9dxAGTm0Q6INrLLS9hCkxUWEZSe0v7sVhSziKdFvq4c3+nEeS7cL
         afoTEUOBqlEWlc/m9f1cKOdIRhWBUbS0Kr1/GMQ1J10jqS8B50X88hrwc2QidcIKMh5R
         uKlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wpItY9Sz20amojq0jQWv/84F+QgeiJg5IKiSbEpUsr4=;
        b=0KrGsKhUM5/fAkyBPoQC+qQfNLUObeQ/1OMVl3yBiEcqqDbgvJQZD8MfUt9KT4J4R+
         Z1TSQixOA4rIWfIuH89LsVOxmGsoD6TGqxNslCweGUZuiKzHiwZw5Cc8/r+/w5HKhl8O
         EOmtPU4v9t8+nWgbcIpxRv9/G0R3mYyyyn4iNtCeuqTiUqdQy3AF8UlbQuedR1NVwWr4
         vs5GuWiNohR0qFwkNiSY6xwajUd4Pf1XlNo0c4hFdF/mot0suioBma9Rw8RnBxLSwUGZ
         5aajOVnByFUHQgvInTXFNJbmio6ro0ANuF9VEqi5I5gHpUAmVQ9JcLddOI0xKXVle7yd
         Pb5Q==
X-Gm-Message-State: AFqh2komyXDeUyl/CvxUUNB8qAgJ74/A6pS9WzrWyE4BLlc4GBXJxk09
        AFxKAtQ/VYcGSx3o/9K2cU1w8LTkCfR19kITHLRPJw==
X-Google-Smtp-Source: AMrXdXteTszP4PGBzkRQxoANazhmqOx+Bjdo2oWTTKlxyEX9P94NGnX6wixxSpLzjsNIOjOc5iU3mg==
X-Received: by 2002:a17:90b:2807:b0:219:5fc5:7790 with SMTP id qb7-20020a17090b280700b002195fc57790mr60518012pjb.16.1673086314511;
        Sat, 07 Jan 2023 02:11:54 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id l33-20020a635721000000b0047702d44861sm2077918pgb.18.2023.01.07.02.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 02:11:54 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v2 0/9] devlink: features, linecard and reporters locking cleanup
Date:   Sat,  7 Jan 2023 11:11:41 +0100
Message-Id: <20230107101151.532611-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

This patchset does not change functionality.

In the first patch, no longer needed devlink features are removed.

Patches 2-5 removes linecards and reporters locks and reference counting,
converting them to be protected by devlink instance lock as the rest of
the objects.

Patches 6 and 7 convert linecards and reporters dumpit callbacks to
recently introduced devlink_nl_instance_iter_dump() infra.
Patch 8 removes no longer needed devlink_dump_for_each_instance_get()
helper.

The last patch adds assertion to devl_is_registered() as dependency on
other locks is removed.

---
v1->v2:
- patch 7 bits were unsquashed to patch 8.

Jiri Pirko (9):
  devlink: remove devlink features
  devlink: remove linecards lock
  devlink: remove linecard reference counting
  devlink: remove reporters_lock
  devlink: remove reporter reference counting
  devlink: convert linecards dump to devlink_nl_instance_iter_dump()
  devlink: convert reporters dump to devlink_nl_instance_iter_dump()
  devlink: remove devlink_dump_for_each_instance_get() helper
  devlink: add instance lock assertion in devl_is_registered()

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |   1 -
 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |   1 -
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |   1 -
 drivers/net/ethernet/intel/ice/ice_devlink.c  |   1 -
 drivers/net/ethernet/mellanox/mlx4/main.c     |   1 -
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   9 +-
 .../ethernet/mellanox/mlx5/core/en/health.c   |  12 +
 .../mellanox/mlx5/core/en/reporter_rx.c       |   6 +-
 .../mellanox/mlx5/core/en/reporter_tx.c       |   6 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |   9 +-
 .../ethernet/mellanox/mlxsw/core_linecards.c  |   8 +-
 drivers/net/netdevsim/dev.c                   |   1 -
 drivers/net/netdevsim/health.c                |  20 +-
 include/net/devlink.h                         |  26 +-
 net/devlink/core.c                            |  23 -
 net/devlink/devl_internal.h                   |  20 +-
 net/devlink/leftover.c                        | 431 +++++++-----------
 net/devlink/netlink.c                         |  12 +-
 18 files changed, 218 insertions(+), 370 deletions(-)

-- 
2.39.0

