Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F145E67B3FE
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbjAYOOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjAYOOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:14:19 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6177144BC8
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:17 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id hw16so47915631ejc.10
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O/pW/Pf+CT3nkLWJ5qVvwfoniNiiewUIr46bWZnEEpc=;
        b=GSiqnsg3QTD0IPUB2W7CgeInyhOr+V12JSbR/qX0WT2VHSlEPxS1sm0TuC7ajtQZ4g
         gzWXecEB450RVC+thwJxMoh9M5wJuxB++GH51/b472ZPZDaovszZkNx4fdwjSavd3vBP
         s/88an5IMo28g26wa/25w2Wf6PTkWUxDneVL/utGQ8G8Q6al3LlPv39DuDrOVEfrD35u
         iwAQ4J/9vWv7Y/wsXhCalZNAdFCaCf+NlyCx0PuBnblhZtlI/rzdP54aT2TQ7N3aCEQg
         bBzUWVYFcvSFoYzNiu0+PxfR60aYxkBGX/mxeZQS/OJTNQaLq5ii2dLp5O+t3J9guAhE
         b4TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O/pW/Pf+CT3nkLWJ5qVvwfoniNiiewUIr46bWZnEEpc=;
        b=1r4jicFv2yQZfR5+MKT8aEpTqTbNLLtosvgQiqtdfNXM5eiMknIWEeh4u3McCOhko8
         OUIKMDZOA7aEWWpkFzUHsie0PT0+vBroCKZr+DIhh5CDqc4vHgQWjXmmxAJznIYtYjuH
         rjN2Q9+wdV702n0QQEIndSEMvqUy5FBUZVCDm244KODgWSR2ZGB1BPtUgNN9SNuYOuxq
         9Fu7izjsCqa7Fi4VVnhBSULuc2PvPX5j0ivHMqL0Q2Jzd4Zhc9vlq6402Z/rQ2bkCcKn
         eOLjdYpiwenhn8D2kIwvDrYH4XPLww0yWACtcSQz+mYlAJ6jzUKfQ/vEN99mhCXPI369
         lvaQ==
X-Gm-Message-State: AFqh2krEtBubSlQz37avheubf2W4AjulnWGJp1k65U3vpZIZwD8TE32f
        jxVz80JjsCC0LIMtVLQ4m9+mKV2pDQkbhaFER9I=
X-Google-Smtp-Source: AMrXdXvqTnU1e8su+lCkNZ0mq0Zuhwp2fJ2Bx6R79s2BBNNtdUZk8hQrcRdZSvHY6E8HosCItuzf9g==
X-Received: by 2002:a17:906:d787:b0:872:5c0a:5597 with SMTP id pj7-20020a170906d78700b008725c0a5597mr31269412ejb.70.1674656055627;
        Wed, 25 Jan 2023 06:14:15 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ui42-20020a170907c92a00b0085214114218sm2407426ejc.185.2023.01.25.06.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:14:14 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        aelior@marvell.com, manishc@marvell.com, jacob.e.keller@intel.com,
        gal@nvidia.com, yinjun.zhang@corigine.com, fei.qin@corigine.com,
        Niklas.Cassel@wdc.com
Subject: [patch net-next 00/12] devlink: Cleanup params usage
Date:   Wed, 25 Jan 2023 15:14:00 +0100
Message-Id: <20230125141412.1592256-1-jiri@resnulli.us>
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

This patchset takes care of small cleanup of devlink params usage.
Some of the patches (first 2/3) are cosmetic, but I would like to
point couple of interesting ones:

Patch 9 is the main one of this set and introduces devlink instance
locking for params, similar to other devlink objects. That allows params
to be registered/unregistered when devlink instance is registered.

Patches 10-12 change mlx5 code to register non-driverinit params in the
code they are related to, and thanks to patch 8 this might be when
devlink instance is registered - for example during devlink reload.

Jiri Pirko (12):
  net/mlx5: Change devlink param register/unregister function names
  net/mlx5: Covert devlink params registration to use
    devlink_params_register/unregister()
  devlink: make devlink_param_register/unregister static
  devlink: don't work with possible NULL pointer in
    devlink_param_unregister()
  ice: remove pointless calls to devlink_param_driverinit_value_set()
  qed: remove pointless call to devlink_param_driverinit_value_set()
  devlink: make devlink_param_driverinit_value_set() return void
  devlink: put couple of WARN_ONs in
    devlink_param_driverinit_value_get()
  devlink: protect devlink param list by instance lock
  net/mlx5: Move fw reset devlink param to fw reset code
  net/mlx5: Move flow steering devlink param to flow steering code
  net/mlx5: Move eswitch port metadata devlink param to flow eswitch
    code

 drivers/net/ethernet/intel/ice/ice_devlink.c  |  20 +-
 drivers/net/ethernet/mellanox/mlx4/main.c     |  80 ++---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  18 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 283 +++++-------------
 .../net/ethernet/mellanox/mlx5/core/devlink.h |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  12 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  10 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   4 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  92 +++++-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  84 +++++-
 .../ethernet/mellanox/mlx5/core/fw_reset.c    |  44 ++-
 .../ethernet/mellanox/mlx5/core/fw_reset.h    |   2 -
 .../net/ethernet/mellanox/mlx5/core/main.c    |  22 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  18 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  16 +-
 .../ethernet/netronome/nfp/devlink_param.c    |   8 +-
 .../net/ethernet/netronome/nfp/nfp_net_main.c |   7 +-
 drivers/net/ethernet/qlogic/qed/qed_devlink.c |   6 -
 drivers/net/netdevsim/dev.c                   |  36 +--
 include/net/devlink.h                         |  20 +-
 net/devlink/leftover.c                        | 185 ++++++------
 21 files changed, 521 insertions(+), 450 deletions(-)

-- 
2.39.0

