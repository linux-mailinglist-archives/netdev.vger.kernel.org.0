Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E07C53FDAA
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243039AbiFGLkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242018AbiFGLkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:40:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6B6A7E05;
        Tue,  7 Jun 2022 04:40:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27ACBB81F6D;
        Tue,  7 Jun 2022 11:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AB6C34114;
        Tue,  7 Jun 2022 11:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654602020;
        bh=m7BeAXQ1laCDGCzhtdylfwmmCG2fi+2Glu3szRWrmOw=;
        h=From:To:Cc:Subject:Date:From;
        b=S64aGcD2OppNDcUPrt0Dn46vAZOVQ5rLacYwzGG5KB0Oiq3mveBVz633LQa95wbbv
         EnBkvlTijVKQ4qzEYYzjA9E3bSaVopccKcV1PQdcxqnLL6+Q4Ov91IpU/6ic564+hI
         8MmKCGz6xTtMcoYmFT14Yk81USUZ/12XveDd4fCigqCJu7UvnOQKuPhwnIoi1SpToJ
         TbRNILVcaZJ26E5tL1HUETku9e55djiWOy7Ege2Db2H8T3h+fXRPTjv283be72Whx7
         iLgB+x9N3XqEk2HVqE+CMlM+cKLWoBfGBEMuhc2rDPHtHUnbwmCH6MuChKPlkcVoi9
         6NEthhB1e/P7g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next 0/5] MR cache cleanup
Date:   Tue,  7 Jun 2022 14:40:10 +0300
Message-Id: <cover.1654601897.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
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

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

In this series, Aharon continues to clean mlx5 MR cache logic.

Thanks

Aharon Landau (5):
  RDMA/mlx5: Replace ent->lock with xa_lock
  RDMA/mlx5: Replace cache list with Xarray
  RDMA/mlx5: Store the number of in_use cache mkeys instead of total_mrs
  RDMA/mlx5: Store in the cache mkeys instead of mrs
  RDMA/mlx5: Rename the mkey cache variables and functions

 drivers/infiniband/hw/mlx5/main.c    |   4 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  61 ++--
 drivers/infiniband/hw/mlx5/mr.c      | 505 +++++++++++++++------------
 drivers/infiniband/hw/mlx5/odp.c     |   2 +-
 include/linux/mlx5/driver.h          |   6 +-
 5 files changed, 304 insertions(+), 274 deletions(-)

-- 
2.36.1

