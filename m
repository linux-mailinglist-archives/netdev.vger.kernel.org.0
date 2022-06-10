Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E748E545BB5
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 07:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238894AbiFJFfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 01:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234813AbiFJFfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 01:35:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155C47A455;
        Thu,  9 Jun 2022 22:35:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8107BCE31C0;
        Fri, 10 Jun 2022 05:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E213C3411B;
        Fri, 10 Jun 2022 05:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654839345;
        bh=ALsvmGxxP/RujwthTDr4s5rJuyAwyD4iIWuXDGgTq/s=;
        h=From:To:Cc:Subject:Date:From;
        b=dFRG6wfjdOExRn+CHQcmLpP9blzV929mo5XHAwzF1fwpwCccnqC+447h5CkaYNiH6
         RevcgMKLjYWClcMtMNitZgWumdaTQVhRHs+ga7cXIKwnn7ZWur/GUOSb91OK9+XNlu
         ImXQ8i1Ci7G1YDVqz/7ZpoXA4gCkUVG6e7/aW5n+gUu08Cxv+equj5rR6vS0v1sKEr
         JzjRG+Nf2hDEmuOWgsoEcrTaFx/iinDYZe6mvF/gxsT0/zVxIbNTjZAiZcogmjuFaF
         53wOT7OH+AAfkanNRvNg4sIeH4yGbur6uPjp5sLhsd8IpG7UYNyR4abLhTm8loPz9T
         lOibleb109MMA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.19-rc2 (follow up)
Date:   Thu,  9 Jun 2022 22:35:44 -0700
Message-Id: <20220610053544.417023-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Quick follow up PR, I managed to catch your tree at a point where AFS
did not build on GCC < 12. Before I tried building it on an older distro
I already pushed a few things. I figured cleanest if I just send a quick
follow up and forward again. Please LMK if I should have just merged
your tree in.

The following changes since commit 825464e79db4aac936e0fdae62cdfb7546d0028f:

  Merge tag 'net-5.19-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-06-09 12:06:52 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc2-2

for you to fetch changes up to bf56a0917fd329d5adecfd405e681ff7ba1abb52:

  Merge tag 'mlx5-fixes-2022-06-08' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2022-06-09 22:05:37 -0700)

----------------------------------------------------------------
Quick follow up, to cleanly fast-forward net again.

Current release - new code bugs:

 - Revert "net/mlx5e: Allow relaxed ordering over VFs"

Previous releases - regressions:

 - seg6: fix seg6_lookup_any_nexthop() to handle VRFs using
   flowi_l3mdev

Misc:

 - rename TLS_INFO_ZC_SENDFILE to better express the meaning

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Andrea Mayer (1):
      net: seg6: fix seg6_lookup_any_nexthop() to handle VRFs using flowi_l3mdev

Etienne van der Linde (1):
      nfp: flower: restructure flow-key for gre+vlan combination

Fei Qin (1):
      nfp: avoid unnecessary check warnings in nfp_app_get_vf_config

Feras Daoud (1):
      net/mlx5: Rearm the FW tracer after each tracer event

Jakub Kicinski (2):
      Merge branch 'nfp-fixes-for-v5-19'
      Merge tag 'mlx5-fixes-2022-06-08' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux

Lukas Bulwahn (1):
      MAINTAINERS: adjust MELLANOX ETHERNET INNOVA DRIVERS to TLS support removal

Mark Bloch (2):
      net/mlx5: E-Switch, pair only capable devices
      net/mlx5: fs, fail conflicting actions

Maxim Mikityanskiy (1):
      tls: Rename TLS_INFO_ZC_SENDFILE to TLS_INFO_ZC_TX

Paul Blakey (1):
      net/mlx5e: CT: Fix cleanup of CT before cleanup of TC ct rules

Saeed Mahameed (1):
      Revert "net/mlx5e: Allow relaxed ordering over VFs"

 MAINTAINERS                                        |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      | 18 -----------
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  7 +++--
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |  5 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 31 +++++++++----------
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  9 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 35 ++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h  | 10 +++++++
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  1 -
 .../net/ethernet/netronome/nfp/flower/conntrack.c  | 32 ++++++++++----------
 drivers/net/ethernet/netronome/nfp/flower/match.c  | 16 +++++-----
 drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c | 28 +++++++++--------
 include/uapi/linux/tls.h                           |  4 +--
 net/ipv6/seg6_local.c                              |  1 +
 net/tls/tls_main.c                                 |  8 ++---
 16 files changed, 120 insertions(+), 89 deletions(-)
