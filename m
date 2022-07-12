Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32EF1571CF8
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 16:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbiGLOlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 10:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiGLOlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 10:41:17 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D00ABA389
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:41:15 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id v67-20020a1cac46000000b003a1888b9d36so6895740wme.0
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BVhC7qnlQr71rFqxNgBM/T1aEtLyPvyLIPg7ZZrYI2s=;
        b=jLcyvDf8m9ZocbRKOQo2omfT0RJzzKl20KFNCkgUD1HDJLwBTKAoLdRC7p7A9zmx5C
         yVRWmwCb20d0pLeHh9d9gSVdIR0yoyK172rdbzcPiqM3sfe1pCjFMGS4wcNy/S4MgCjF
         +fXDMmX7RY+p+xFLDCAKHebleHHUEOl5ipEKCpqD0QjellALrRVyyunVXMqwPAyNtzox
         KCnF1OfeH+TAm5oemXvl070tBHGNw9ULs0i4rpmCy2WPHdrc7O8pA1uDzqUc1QPeljGM
         UEp5cGfJ8OqnpUFcC9Efbj5DBO49AxL5qNar9Vl9Vp7sk/kXKLUxJdvTeZ0wCu41cffE
         be+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BVhC7qnlQr71rFqxNgBM/T1aEtLyPvyLIPg7ZZrYI2s=;
        b=wbaFcpeyT8yZ/1oZ36VItG6D+k9o3yGYyIPmrK0PkpM0k6TmbMuq9VKJyXBrvjgYk0
         6zfG+UZSZqe/RF29wZZvEMiEdeClWPf4qZwcpeXMN2BchMrWYbvR8w/webu89wysyP4r
         sMVdYTWOmYwUyOQpPHh70abnSjbfcbUKQyxLFiw6uKgFelv8YOWZB+lLTZBQt9gcc71E
         ROStyrs6j0N8+jN/I42xfnLNwDn4A3XDfEEzCwy8+mJWaxtdB97BaQkkdpIBFVcqh7EW
         g30FgDOFkzY42dZnKCmBciRrPNN42KJmWBSr3M+auKnXlgMDiSVv+ZYUuwTUdfUbn1Pm
         KAiw==
X-Gm-Message-State: AJIora+uMuqjN6sLj56r6VO6OXjDM4kYMnYndhgy87qCKkYdskK5IrEp
        5cZ1WVIWnXdwWGin+lH3YKTIRRyFU0yH6K4oRRI=
X-Google-Smtp-Source: AGRyM1vEFGN3bia5V9WfIA89a467ByAh615F+hMBC3DY15Fb7+768v6F/TjeMaJXwsrcwF89v6+vAw==
X-Received: by 2002:a05:600c:5108:b0:3a1:a0c2:ba47 with SMTP id o8-20020a05600c510800b003a1a0c2ba47mr4604989wms.68.1657636874083;
        Tue, 12 Jul 2022 07:41:14 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k18-20020a5d6e92000000b0021d746d4820sm8574135wrz.37.2022.07.12.07.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 07:41:13 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, idosch@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: [patch net-next RFCv2 0/9] net: devlink: prepare mlxsw and netdevsim for locked reload
Date:   Tue, 12 Jul 2022 16:41:03 +0200
Message-Id: <20220712144112.2905407-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

This is preparation patchset to be able to eventually make a switch and
make reload cmd to take devlink->lock as the other commands do.

This patchset is preparing 2 major users of devlink API - mlxsw and
netdevsim. The sets of functions are similar, therefore taking care of
both here.

I would like to ask you to take this RFC for a test spin, will send v1
after you give me a go.

Jiri Pirko (8):
  net: devlink: add unlocked variants of devling_trap*() functions
  net: devlink: add unlocked variants of devlink_resource*() functions
  net: devlink: add unlocked variants of devlink_sb*() functions
  net: devlink: add unlocked variants of devlink_dpipe*() functions
  mlxsw: convert driver to use unlocked devlink API during init/fini
  net: devlink: add unlocked variants of devlink_region_create/destroy()
    functions
  netdevsim: convert driver to use unlocked devlink API during init/fini
  net: devlink: remove unused locked functions

Moshe Shemesh (1):
  net: devlink: avoid false DEADLOCK warning reported by lockdep

 drivers/net/ethernet/mellanox/mlxsw/core.c    |  53 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 103 ++-
 .../ethernet/mellanox/mlxsw/spectrum1_kvdl.c  |  82 +--
 .../mellanox/mlxsw/spectrum_buffers.c         |  14 +-
 .../ethernet/mellanox/mlxsw/spectrum_cnt.c    |  62 +-
 .../ethernet/mellanox/mlxsw/spectrum_dpipe.c  |  88 +--
 .../mellanox/mlxsw/spectrum_policer.c         |  32 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  22 +-
 .../ethernet/mellanox/mlxsw/spectrum_span.c   |   6 +-
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  27 +-
 drivers/net/netdevsim/bus.c                   |  19 -
 drivers/net/netdevsim/dev.c                   | 134 ++--
 drivers/net/netdevsim/fib.c                   |  62 +-
 drivers/net/netdevsim/netdevsim.h             |   3 -
 include/net/devlink.h                         |  76 ++-
 net/core/devlink.c                            | 637 ++++++++++++------
 16 files changed, 816 insertions(+), 604 deletions(-)

-- 
2.35.3

