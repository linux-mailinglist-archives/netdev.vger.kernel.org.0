Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754526E0D6E
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 14:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjDMM3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 08:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDMM3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 08:29:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237AB93C7
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 05:29:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68C1263D9B
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D81C433EF;
        Thu, 13 Apr 2023 12:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681388977;
        bh=+FAEm49Gnb3Jc3MymV2jpeJTE/YJHhjTtOf1ublD/Og=;
        h=From:To:Cc:Subject:Date:From;
        b=PdENr0J57fTXlbErAUZijcJLIZfp9D3x9oqBZ9RETUTAHOHFgLAVcZ5GrrkZNIUNI
         +LvWS7w6n/rjU4u006JisRxjGZwZV7l9WURVy1Lj5TFDwcRNT/OeVi74X+hmEr6Fkc
         i/SscRtS/joAMIskYl37YRSjaRkuZDrBIFxsoR3ymdwZajaOpFYb1IHLmSZ+2ZwzEQ
         3PdSH1p8e4qdWsS2fof6SWi60hXSGdFPrFOiRmpTj3Qvysmlhrj95TFFbai2CU93fy
         Mt9zM4AfBNqnltTXFMd0kFs8Yep7hhZGPcQX8a6bwUc81Ezy8PRuysPfmVyzpwGs79
         UYED9PEcD9VPg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v1 00/10] Support tunnel mode in mlx5 IPsec packet offload
Date:   Thu, 13 Apr 2023 15:29:18 +0300
Message-Id: <cover.1681388425.git.leonro@nvidia.com>
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
 * Added Simon's ROB tags
 * Changed some hard coded values to be defines
 * Dropped custom MAC header struct in favor of struct ethhdr
 * Fixed missing returned error
 * Changed "void *" casting to "struct ethhdr *" casting
v0: https://lore.kernel.org/all/cover.1681106636.git.leonro@nvidia.com

---------------------------------------------------------------------
Hi,

This series extends mlx5 to support tunnel mode in its IPsec packet
offload implementation.

Thanks

---------------------------------------------------------------------
I would like to ask to apply it directly to netdev tree as PR is not
really needed here.
---------------------------------------------------------------------

Leon Romanovsky (10):
  net/mlx5e: Add IPsec packet offload tunnel bits
  net/mlx5e: Check IPsec packet offload tunnel capabilities
  net/mlx5e: Configure IPsec SA tables to support tunnel mode
  net/mlx5e: Prepare IPsec packet reformat code for tunnel mode
  net/mlx5e: Support IPsec RX packet offload in tunnel mode
  net/mlx5e: Support IPsec TX packet offload in tunnel mode
  net/mlx5e: Listen to ARP events to update IPsec L2 headers in tunnel
    mode
  net/mlx5: Allow blocking encap changes in eswitch
  net/mlx5e: Create IPsec table with tunnel support only when encap is
    disabled
  net/mlx5e: Accept tunnel mode for IPsec packet offload

 .../mellanox/mlx5/core/en_accel/ipsec.c       | 202 ++++++++++++++-
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  11 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 239 +++++++++++++++---
 .../mlx5/core/en_accel/ipsec_offload.c        |   6 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  14 +
 .../mellanox/mlx5/core/eswitch_offloads.c     |  48 ++++
 include/linux/mlx5/mlx5_ifc.h                 |   8 +-
 7 files changed, 481 insertions(+), 47 deletions(-)

-- 
2.39.2

