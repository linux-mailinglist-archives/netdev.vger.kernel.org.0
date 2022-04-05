Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044364F3265
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 14:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbiDEIZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 04:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239297AbiDEIUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 04:20:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C2A6E8ED;
        Tue,  5 Apr 2022 01:12:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22DF2B81B92;
        Tue,  5 Apr 2022 08:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CFAC385A0;
        Tue,  5 Apr 2022 08:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649146367;
        bh=wPJh3L6sAf0k8m8Hb7tGFjV8N3Jfh2AkqN4+6yfXQZM=;
        h=From:To:Cc:Subject:Date:From;
        b=pNNlxsQ7BjaUPDpIw3aEJUsoX+27K/f2I0nu4LvcwYijZUIqjr/x52fO1xdsqPgqJ
         CaeQ1CP3Sqz2MuE57InW4xc9ADnVn0W32Cnixov5+plAPl5moa69NBPVx8sFX/zH54
         YK864X3+6t5uw1STV6szBgfEbnV72E6q41OKHFtgNhgSnndyKUauVgQ0eIBU8vVbBf
         tOtfuThcOYVT7qH1LePfnIe80EnGSeofqFry8c/dWthRsDTjzRTzr236hKVMsGjRRi
         lVsDocntliKn08eolsa5PHcYNhWPbokEZasMQVKMPqy9Kor4196RSjzTu2fqj3e1km
         kD/n369duRcfQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Patrisious Haddad <phaddad@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH rdma-next 0/3] Handle FW failures to destroy QP/RQ objects
Date:   Tue,  5 Apr 2022 11:12:39 +0300
Message-Id: <cover.1649139915.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

This series from Patrisious extends mlx5 driver to convey FW failures
back to the upper layers and allow retry to delete these hardware
resources.

Thanks

Patrisious Haddad (3):
  net/mlx5: Nullify eq->dbg and qp->dbg pointers post destruction
  RDMA/mlx5: Handling dct common resource destruction upon firmware
    failure
  RDMA/mlx5: Return the firmware result upon destroying QP/RQ

 drivers/infiniband/hw/mlx5/qpc.c              | 13 +++++++------
 .../net/ethernet/mellanox/mlx5/core/debugfs.c | 12 ++++++------
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 19 +++++++++++++------
 3 files changed, 26 insertions(+), 18 deletions(-)

-- 
2.35.1

