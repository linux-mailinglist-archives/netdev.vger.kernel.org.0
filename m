Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B37D672120
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjARPYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbjARPXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:23:44 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB72D474E3
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:18 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id vw16so20912679ejc.12
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uii9wi0asYgS8aiqgRrWXU+WIKSIASmk3GSzYNJ6v1I=;
        b=i0Ok4aKpdIYnXUF47/5lFNXPJztGfGQmooB8UJsYrhghTFDMVAkCpJdX/lF/6kGt4Q
         Sn7EPRJNjK/zCQ29UT8tPtIrDgCp5Qgv7aYXK9ob7muJpKKL0FC0yqrmeLlH95DfaemD
         zuxx6U1aPuzc0klUVNTjMzxPL+5twPZt7Ti4L1jFTx8nPlGUd3NIIcysoP1iqWMgah+c
         AEl7dmH2pvNy0LQuCe7qvyBHqagMhdlWMleacFK6F//vABnAQj82wMPutPMR5Vd9R/vA
         HJX/jyIajkB3An7bBJaMoziLKLMnJVYY60hJocbrELOKvUodCC+kqOigx46huDdUp/Qi
         Fmnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uii9wi0asYgS8aiqgRrWXU+WIKSIASmk3GSzYNJ6v1I=;
        b=AsNJeb7xHKEHzQ/6Frjw31xA6HK3d6GRs3cSeNVS+Qd3q+V6eSBg/vEXnF447fmAF9
         KA9mHRWxC2gybTRfiXffb0oZAuAI6o1z/biqVLcPAHTyo75pj3ZGcfRqf9Or1rr5/epg
         B7V5fcJXHPPiL82f1r8p2evQs5tSoWUqurQ7rAgeVtRSwhkjFb+cocnCV2I25wsT+xsf
         DF37JODJoa+iUEGwWesiRKz11xhv0GPzqaBRqcYgJZhkfbYWps/cdCHxqurenaz+Rl31
         GrDuYlzUUFhbl7uAjuDezSDpg3gdKOlFHB+QY9g9+/vNbGHbXr/ZoQL+QiTNobRWLY+8
         OmRw==
X-Gm-Message-State: AFqh2ko8DcYazVTnbii+OoLL2zy5VzgX8So50aSjPNtiEX9N1I0LKH0m
        uT3NRALhuhbO8S/Qh1Y2Q5ysG99LgQXj3/T8A0n1rg==
X-Google-Smtp-Source: AMrXdXvSR3yDNifubZhn2x6VGoZMJmGgCP9XXPJhlspm/6ka0VzlB+nIP3+iJLWQfwEwoMYnYbbsnQ==
X-Received: by 2002:a17:907:1390:b0:7ae:987d:d7f9 with SMTP id vs16-20020a170907139000b007ae987dd7f9mr5847811ejb.17.1674055277256;
        Wed, 18 Jan 2023 07:21:17 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id t27-20020a170906179b00b008762e2b7004sm1374730eje.208.2023.01.18.07.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:21:16 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v5 00/12] devlink: linecard and reporters locking cleanup
Date:   Wed, 18 Jan 2023 16:21:03 +0100
Message-Id: <20230118152115.1113149-1-jiri@resnulli.us>
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

Patches 1-2 remove linecards lock and reference counting, converting
them to be protected by devlink instance lock as the rest of
the objects.

Patches 3-4 fix the mlx5 auxiliary device devlink locking scheme whis is
needed for proper reporters lock conversion done in the following
patches.

Patches 5-8 remove reporters locks and reference counting, converting
them to be protected by devlink instance lock as the rest of
the objects.

Patches 9 and 10 convert linecards and reporters dumpit callbacks to
recently introduced devlink_nl_instance_iter_dump() infra.

Patch 11 removes no longer needed devlink_dump_for_each_instance_get()
helper.

The last patch adds assertion to devl_is_registered() as dependency on
other locks is removed.

---
v4->v5:
- fixed mlx5 locking issues
v3->v4:
- patch #1 was removed from the set and will be sent as a part of
  another patchset
v2->v3:
- see individual patches for changelog, mainly original patch #4 was
  split into 3 patches for easier review
v1->v2:
- patch 7 bits were unsquashed to patch 8

Jiri Pirko (12):
  devlink: remove linecards lock
  devlink: remove linecard reference counting
  net/mlx5e: Create separate devlink instance for ethernet auxiliary
    device
  net/mlx5: Remove MLX5E_LOCKED_FLOW flag
  devlink: protect health reporter operation with instance lock
  devlink: remove reporters_lock
  devlink: remove devl*_port_health_reporter_destroy()
  devlink: remove reporter reference counting
  devlink: convert linecards dump to devlink_nl_instance_iter_dump()
  devlink: convert reporters dump to devlink_nl_instance_iter_dump()
  devlink: remove devlink_dump_for_each_instance_get() helper
  devlink: add instance lock assertion in devl_is_registered()

 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   4 +
 .../ethernet/mellanox/mlx5/core/en/devlink.c  |  44 +-
 .../ethernet/mellanox/mlx5/core/en/devlink.h  |   5 +-
 .../mellanox/mlx5/core/en/reporter_rx.c       |   2 +-
 .../mellanox/mlx5/core/en/reporter_tx.c       |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  25 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |   8 +-
 .../ethernet/mellanox/mlxsw/core_linecards.c  |   8 +-
 drivers/net/netdevsim/health.c                |  20 +-
 include/linux/mlx5/driver.h                   |   4 -
 include/net/devlink.h                         |  27 +-
 net/devlink/core.c                            |   4 -
 net/devlink/devl_internal.h                   |  20 +-
 net/devlink/leftover.c                        | 442 +++++++-----------
 net/devlink/netlink.c                         |  12 +-
 16 files changed, 272 insertions(+), 369 deletions(-)

-- 
2.39.0

