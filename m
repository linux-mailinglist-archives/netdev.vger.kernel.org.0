Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9BC65CE0C
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 09:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbjADILf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 03:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjADILd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 03:11:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5FDDEAC;
        Wed,  4 Jan 2023 00:11:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D163615C1;
        Wed,  4 Jan 2023 08:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E509C433EF;
        Wed,  4 Jan 2023 08:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672819891;
        bh=SIPCFfmc72iP44TKzaToJdxfKCMW0e9hhb3cSHdlX8g=;
        h=From:To:Cc:Subject:Date:From;
        b=jgwopIAIv0bRg9NMUyNLs86h3NhcGTgxs1/Husy6wNrnoeY74XxzztEJdIiOU08ZF
         TyD9as1T4iMvqVL15mHRsOVLZ9DNt39f92lTvFtLCQOkU3iJ0Jgk8j97amZOZ6eLpB
         0DuB2VHi6Z+wYka9GvozKlMT9dnsq4O/Yis+sTL12DNdhQA5VJofuqPo4Bwt84sI/S
         PQjml2a48mKqouGZnLwyB3q/i/9LEOjkxSwiGuFgcrUwvJrRFxt2jUQ5iWBvtyshLe
         lI/ebQAmbwoKWUXgK/o8jKG/fGgrV6r5DJh6ggzPpOWmuh9AAU51PAecmspB0n8AaI
         iSEf5uTUKeEoA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Or Har-Toov <ohartoov@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next 0/4] Rely on firmware to get special mkeys
Date:   Wed,  4 Jan 2023 10:11:21 +0200
Message-Id: <cover.1672819469.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

This series from Or extends mlx5 driver to rely on firmware to get
special mkey values.

Thanks

Or Har-Toov (4):
  net/mlx5: Expose bits for querying special mkeys
  net/mlx5: Change define name for 0x100 lkey value
  net/mlx5: Use query_special_contexts for mkeys
  RDMA/mlx5: Use query_special_contexts for mkeys

 drivers/infiniband/hw/mlx5/cmd.c              | 41 ++++++++++---------
 drivers/infiniband/hw/mlx5/cmd.h              |  3 +-
 drivers/infiniband/hw/mlx5/main.c             | 10 ++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  9 +++-
 drivers/infiniband/hw/mlx5/odp.c              | 27 ++++--------
 drivers/infiniband/hw/mlx5/srq.c              |  2 +-
 drivers/infiniband/hw/mlx5/wr.c               |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  3 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 27 ++++++++++++
 include/linux/mlx5/driver.h                   |  1 +
 include/linux/mlx5/mlx5_ifc.h                 | 10 ++++-
 include/linux/mlx5/qp.h                       |  2 +-
 12 files changed, 85 insertions(+), 52 deletions(-)

-- 
2.38.1

