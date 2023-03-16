Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880316BD0FB
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 14:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjCPNjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 09:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjCPNjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 09:39:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FBBB9528;
        Thu, 16 Mar 2023 06:39:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26E81B82147;
        Thu, 16 Mar 2023 13:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0669C433D2;
        Thu, 16 Mar 2023 13:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678973976;
        bh=sfBb0BwnrI83qHlxp6xUA/pGLholRdVIF2fJbDUvthw=;
        h=From:To:Cc:Subject:Date:From;
        b=I3vzTE8r3bhNXg3OHpOLanHnyAyakHTUEmwROaXp9MMC25xFREuf7ZYWtec1enCFO
         gGnCLG8mwErTI6NDqyyyCqqLwN8nhsBcxBTj71uVh1XvXcnc/xUjucqWFmqZKu9p2R
         nZcR1LxxeAYwgfmzS6eDTg1Qw5DBQa6YPciyO0go5ol2Ox1O+XebyhgWlJgrV3WOnS
         gdMpT7OnC6yd/6tf8WV/RoqWpkM00ZaCCDfoviZdUrqWwXlHS1mrTk+XQJqJcnnt+z
         H77Fx1E5SS6koX/fzJ069TkjgOpehKarQUkjGwTkbwsxTl9nPLiVq6mWFQJxnEfO88
         CXoa9JTDilPkw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Patrisious Haddad <phaddad@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next v1 0/3] Handle FW failures to destroy QP/RQ objects
Date:   Thu, 16 Mar 2023 15:39:25 +0200
Message-Id: <cover.1678973858.git.leon@kernel.org>
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

Changelog:
v1: 
 * Dropped EQ changes
v0: https://lore.kernel.org/all/cover.1649139915.git.leonro@nvidia.com
-----------------------------------------------------------------------

Hi,

This series from Patrisious extends mlx5 driver to convey FW failures
back to the upper layers and allow retry to delete these hardware
resources.

Thanks

Patrisious Haddad (3):
  net/mlx5: Nullify qp->dbg pointer post destruction
  RDMA/mlx5: Handling dct common resource destruction upon firmware
    failure
  RDMA/mlx5: Return the firmware result upon destroying QP/RQ

 drivers/infiniband/hw/mlx5/qpc.c                  | 13 +++++++------
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c |  6 +++---
 2 files changed, 10 insertions(+), 9 deletions(-)

-- 
2.39.2

