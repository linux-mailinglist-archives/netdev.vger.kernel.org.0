Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020A1665701
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238528AbjAKJLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238703AbjAKJLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:11:08 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF160140BF
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:07:51 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 78so10082933pgb.8
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z+bM4cCfh5OieOiVDLrT0LHCofSrdVNzQ3Qr61R6yJE=;
        b=Mcv8m5n+bBZNxxXQlObif2iP96anYoGwp4ndPVv9UKISYAiEfHtJ+6n+IslB571UQG
         ZcxIiFKvU6YBNG438f5Oq6v1299TROMGURHXPKnnImcQGrgCYmV6nINJZUGGqAPdls/B
         YARHOK56g28PC1vEtMdSUm4x+laUID2C0AgzAchw8wPksV/2IiL3VDXAkM2hkcRqlUBe
         TFo31Xxvf3is2r6/tz1XdkhwI/P35LNu5YGBJSZBbO1WAC0glApEXhBnFatmZh/8Slzj
         pXal1/NmqBs1/eKwlYxC0KzpNaofeVvRKUXr0bkW+s9xCbiXRyi1r5b7UktsUwu11u7+
         F1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z+bM4cCfh5OieOiVDLrT0LHCofSrdVNzQ3Qr61R6yJE=;
        b=ZWvU/BnF6NDBv6JIrJkJR/yRyYWq8m4EP1YLSJLsHVpGHScHuDahsPiXQssNeYHyBZ
         XuGxP0HofLQmSOlt1y4WfsTO5vhEZpraTlu812MbAao0oW2+y70Uf+KWALltMs3C2ad/
         u2HI3leCUjOrxcemWmN1qH3g5enKP58ukvyKNSebxnLmx3Gp5WrBd0+SNrnLR05j5VXo
         0SKSEHIaW1L4+Q+yLkqWsmNJdA0pXFi5PFnsJ+LG+Qlqptm3faWnj/rXICydF5sctsVY
         xXvImKyNnUTWcEhamZ+ZflVqMK1o+w++et19ezLaSn5SkHMDsCgwxHkZHCqe5skX0JHq
         MCig==
X-Gm-Message-State: AFqh2kpRnq1EYPZqj6g0OAVVu9DGps07RAdGpGCKWcjhswO0c5TWcXc7
        tg2VTEdCX4IBrgNcWPB+ye1joVYk9vJdhhvsO6qOsA==
X-Google-Smtp-Source: AMrXdXuehSug5S63fJRS8LTP7f8JYRCW4xdZeLfCFSl6jajmKLzfMY8nFDgdne69LK0KKzw5p2i+sA==
X-Received: by 2002:a05:6a00:400e:b0:577:9807:543b with SMTP id by14-20020a056a00400e00b005779807543bmr78790665pfb.16.1673428071142;
        Wed, 11 Jan 2023 01:07:51 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id p128-20020a622986000000b00581172f7456sm9498462pfp.56.2023.01.11.01.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 01:07:50 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v4 00/10] devlink: linecard and reporters locking cleanup
Date:   Wed, 11 Jan 2023 10:07:38 +0100
Message-Id: <20230111090748.751505-1-jiri@resnulli.us>
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

Patches 1-6 removes linecards and reporters locks and reference counting,
converting them to be protected by devlink instance lock as the rest of
the objects.

Patches 7 and 8 convert linecards and reporters dumpit callbacks to
recently introduced devlink_nl_instance_iter_dump() infra.
Patch 9 removes no longer needed devlink_dump_for_each_instance_get()
helper.

The last patch adds assertion to devl_is_registered() as dependency on
other locks is removed.

---
v3->v4:
- patch #1 was removed from the set and will be sent as a part of
  another patchset
v2->v3:
- see individual patches for changelog, mainly original patch #4 was
  split into 3 patches for easier review
v1->v2:
- patch 7 bits were unsquashed to patch 8


Jiri Pirko (10):
  devlink: remove linecards lock
  devlink: remove linecard reference counting
  devlink: protect health reporter operation with instance lock
  devlink: remove reporters_lock
  devlink: remove devl_port_health_reporter_destroy()
  devlink: remove reporter reference counting
  devlink: convert linecards dump to devlink_nl_instance_iter_dump()
  devlink: convert reporters dump to devlink_nl_instance_iter_dump()
  devlink: remove devlink_dump_for_each_instance_get() helper
  devlink: add instance lock assertion in devl_is_registered()

 .../ethernet/mellanox/mlx5/core/en/health.c   |  12 +
 .../mellanox/mlx5/core/en/reporter_rx.c       |   6 +-
 .../mellanox/mlx5/core/en/reporter_tx.c       |   6 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |   8 +-
 .../ethernet/mellanox/mlxsw/core_linecards.c  |   8 +-
 drivers/net/netdevsim/health.c                |  20 +-
 include/net/devlink.h                         |  26 +-
 net/devlink/core.c                            |   4 -
 net/devlink/devl_internal.h                   |  20 +-
 net/devlink/leftover.c                        | 428 +++++++-----------
 net/devlink/netlink.c                         |  12 +-
 11 files changed, 213 insertions(+), 337 deletions(-)

-- 
2.39.0

