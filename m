Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CF6662F2F
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbjAISeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237829AbjAISdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:33:44 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B3D6086F
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:31:24 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id z4-20020a17090a170400b00226d331390cso10611529pjd.5
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zLEGGY4qDatHuTEp56hlxfU6sODR32wtdxHq+IuXbSM=;
        b=UuTjFptN6NQD/W9NWj7EnUbDgm4WSQ739aMudnFVheLKuDnz20x3wnWUNDiBUEXMJ3
         3cp7kte/gpHHyPrlTSfFZ9Hf/sfqasq9P4SVHmcT10N78NoXZQUWgtVtBqp65XjvCgJk
         CkHtu+5HhxkR0VfhAdicjUSqbrzh0xp0KS792MEHQJhe4upwoLRslD0B7LqM9RaNJf37
         w4/t0bm9omYxep7KMuhMLOyOlXsrOoMfz4FRzkMmxyAZlH89J5xCelQdLtoR/fsPL+Os
         udDmjd7F231hhrh/UODMI+ssmLtyWgRs4Kh5etEuWwO9YIN5/AVtF2mnYwfb3rDvwvfj
         hI5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zLEGGY4qDatHuTEp56hlxfU6sODR32wtdxHq+IuXbSM=;
        b=Vpa+BaX8RXpcDit+5nTdRDZza+D/TnfFNa40jvDvNjf2PDG5zSmwe8OIQuZSoN1k4b
         IXWXbbVURjgbIesu3Jpf6zuggVo1GV8jg0gJ+Ujk3C9uIItxQm2KKFxu98fIH3oCDP0B
         3+zue6lBJJQvAcaZ3FeqhXtXzgvLPo71fwjgMPdqKQ+QJUv7OQvIvb/Hy2UNFmpjCuwj
         BAqKXXO00TkgouX3UyCpSnASPPSxkcT72RHiBsn7d5LA2KLI1YtVSFA5jMNcs39EYiZV
         NA2u4+7Bnr5qG0yfdEFfU72P2WewAcdHOL3k6YDjDHPqorDpPzZA2IXu1FgI1dTdARBd
         PkuQ==
X-Gm-Message-State: AFqh2kqlerlNq1QSbUZF6YbFLz0dblvMLj/WciEX38ltwb17xIFZxCIW
        BRmxGpFPzTawh8bLUxng+RheKROAL5aiR5RbGKABpQ==
X-Google-Smtp-Source: AMrXdXtWBXOS0ToCMJJiBEvClq1HahVrEVjis1eXwh2JZeaC8rK+8b83ssUfdlY0LNriRppt/4Qhyg==
X-Received: by 2002:a17:90a:7142:b0:226:19ea:5c2a with SMTP id g2-20020a17090a714200b0022619ea5c2amr43595264pjs.43.1673289084349;
        Mon, 09 Jan 2023 10:31:24 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id v14-20020a17090a4ece00b002194319662asm7460026pjl.42.2023.01.09.10.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 10:31:23 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v3 00/11] devlink: features, linecard and reporters locking cleanup
Date:   Mon,  9 Jan 2023 19:31:09 +0100
Message-Id: <20230109183120.649825-1-jiri@resnulli.us>
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

Patches 2-7 removes linecards and reporters locks and reference counting,
converting them to be protected by devlink instance lock as the rest of
the objects.

Patches 8 and 9 convert linecards and reporters dumpit callbacks to
recently introduced devlink_nl_instance_iter_dump() infra.
Patch 10 removes no longer needed devlink_dump_for_each_instance_get()
helper.

The last patch adds assertion to devl_is_registered() as dependency on
other locks is removed.

---
v2->v3:
- see individual patches for changelog, mainly original patch #4 was
  split into 3 patches for easier review
v1->v2:
- patch 7 bits were unsquashed to patch 8

Jiri Pirko (11):
  devlink: remove devlink features
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
 include/net/devlink.h                         |  28 +-
 net/devlink/core.c                            |  23 -
 net/devlink/devl_internal.h                   |  21 +-
 net/devlink/leftover.c                        | 431 +++++++-----------
 net/devlink/netlink.c                         |  12 +-
 18 files changed, 219 insertions(+), 372 deletions(-)

-- 
2.39.0

