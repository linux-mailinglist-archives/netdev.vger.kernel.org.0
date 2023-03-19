Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23B46C01DD
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 14:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbjCSNAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 09:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjCSNAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 09:00:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC84F1CBCB;
        Sun, 19 Mar 2023 05:59:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C62461045;
        Sun, 19 Mar 2023 12:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3149BC433EF;
        Sun, 19 Mar 2023 12:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679230781;
        bh=gDaXQWRIWOFDoMT2HKKfGlOZpdDfn6wX64P8nzMh+Es=;
        h=From:To:Cc:Subject:Date:From;
        b=hbfp9rpyEqLC86zpaz8TqW7HmnnToKcOaEjSY+FBM6HQDAMidkddp7AICPXi165Lh
         RS/IKB7/luODy41KvMvAQv5xwqQpjFyycZpdT8VLqzGwsVW7m+BmJbDZdxWWhPo1de
         JOIGe3CYZKEbODIa6Z6BzCngdDswRWyj7HKdGf5tibSD182Q/AFEchMudEFEDelREC
         toJTSBNAn5FcRaFempiBz1vxPwyL9QzNy1pmcSkHdIuKpo8JXPts+av89TSAT7t2i5
         uVK309sTF9ci74428DNn0uFkWykA0tQ1O0mFV/PrkDM+lqdOb3vTdFTPF3ipGGlWk/
         WHmFi8ftFykag==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Or Har-Toov <ohartoov@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next 0/3] Enable IB out-of-order by default in mlx5
Date:   Sun, 19 Mar 2023 14:59:29 +0200
Message-Id: <cover.1679230449.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This series from Or changes default of IB out-of-order feature and
allows to the RDMA users to decide if they need to wait for completion
for all segments or it is enough to wait for last segment completion only.

Thanks

Or Har-Toov (3):
  net/mlx5: Expose bits for enabling out-of-order by default
  RDMA/mlx5: Disable out-of-order in integrity enabled QPs
  net/mlx5: Set out of order (ooo) by default

 drivers/infiniband/hw/mlx5/qp.c                |  8 ++++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c |  3 +++
 include/linux/mlx5/mlx5_ifc.h                  | 10 +++++++---
 3 files changed, 18 insertions(+), 3 deletions(-)

-- 
2.39.2

