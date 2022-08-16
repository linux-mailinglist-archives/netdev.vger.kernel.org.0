Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5887E5959EB
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbiHPLYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234237AbiHPLYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:24:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417A0F6197
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:38:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C362F60FD0
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DF1C433C1;
        Tue, 16 Aug 2022 10:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646300;
        bh=n3b1uCFoE5SbWAUF6LO07X4jK9H9M6FvtSi85b+fgHM=;
        h=From:To:Cc:Subject:Date:From;
        b=RytPo3KoD2I+ZLM2shtmIFATbbgW1StMShzqj/9bfFHMMoyRHE++eQO5DuZncEr9e
         +a5xlvBZKAPmHYe/tfd4FUFa2fOMdohHleRagSyq7qspigbnKhwZJJpjeraqHPnsYA
         fqSNIIGWou50PUrnKXAryqxjzd0zMRFNZzFUPd/kZhlZ4hYxvEoEXf9FwUef78XMDt
         Lway8JxQ3dKoryCOuHv7EgUhk45H/99LXERSNdDjPpm4F42KoU8ctI/gCr7yaL9Ko4
         sIRtRw9BhPC43l3Jk9yyKkOjgNUy11O+N7HfnkU1dK+6mkeTp48hll58NeiTKgeoYP
         wpmzPwXyiaiHA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 00/26] mlx5 IPsec full offload part
Date:   Tue, 16 Aug 2022 13:37:48 +0300
Message-Id: <cover.1660641154.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
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

This is supplementary part of "Extend XFRM core to allow full offload configuration"
series https://lore.kernel.org/all/cover.1660639789.git.leonro@nvidia.com

The series starts from very basic cleanup, continues with code alignment and
adds IPsec full offload logic to mlx5 driver.

Thanks

Leon Romanovsky (25):
  net/mlx5: Delete esp_id field that is not used
  net/mlx5: Add HW definitions for IPsec full offload
  net/mlx5: Remove from FPGA IFC file not-needed definitions
  net/mlx5e: Advertise IPsec full offload support
  net/mlx5e: Store replay window in XFRM attributes
  net/mlx5e: Remove extra layers of defines
  net/mlx5e: Create symmetric IPsec RX and TX flow steering structs
  net/mlx5e: Use mlx5 print routines for low level IPsec code
  net/mlx5e: Remove accesses to priv for low level IPsec FS code
  net/mlx5e: Validate that IPsec full offload can handle packets
  net/mlx5e: Create Advanced Steering Operation object for IPsec
  net/mlx5e: Create hardware IPsec full offload objects
  net/mlx5e: Move IPsec flow table creation to separate function
  net/mlx5e: Refactor FTE setup code to be more clear
  net/mlx5e: Flatten the IPsec RX add rule path
  net/mlx5e: Make clear what IPsec rx_err does
  net/mlx5e: Group IPsec miss handles into separate struct
  net/mlx5e: Generalize creation of default IPsec miss group and rule
  net/mlx5e: Create IPsec policy offload tables
  net/mlx5e: Add XFRM policy offload logic
  net/mlx5e: Use same coding pattern for Rx and Tx flows
  net/mlx5e: Configure IPsec full offload flow steering
  net/mlx5e: Improve IPsec flow steering autogroup
  net/mlx5e: Skip IPsec encryption for TX path without matching policy
  net/mlx5e: Open mlx5 driver to accept IPsec full offload

Raed Salem (1):
  net/mlx5e: Add statistics for Rx/Tx IPsec offloaded flows

 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |    3 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  209 +++-
 .../mellanox/mlx5/core/en_accel/ipsec.h       |   93 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 1066 ++++++++++++-----
 .../mlx5/core/en_accel/ipsec_offload.c        |   81 +-
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c |   52 +
 .../ethernet/mellanox/mlx5/core/en_stats.c    |    1 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |    1 +
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |    6 +-
 include/linux/mlx5/fs.h                       |    5 +-
 include/linux/mlx5/mlx5_ifc.h                 |   71 +-
 include/linux/mlx5/mlx5_ifc_fpga.h            |   24 -
 12 files changed, 1223 insertions(+), 389 deletions(-)

-- 
2.37.2

