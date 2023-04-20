Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB606E8C01
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbjDTIDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234019AbjDTIC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:02:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B1BB4
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:02:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A737264147
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 08:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD57C433EF;
        Thu, 20 Apr 2023 08:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681977777;
        bh=5BkFyFIu8Suh/i1Y1ccwyf8L9Zd07HwJQ3b/wA0OE2c=;
        h=From:To:Cc:Subject:Date:From;
        b=egN6LkIQkkSWYs370tYxUmsH8FTQeSq1ZQENlWlyM0O6hipYCF2mJJKyNWGix7cJ4
         zAbQ2swy6lPbIdXnWyHIAQAmT60FvQuF89eaNbCHKE08XV27TQ6fvXC/+N/4CmfqbD
         cg8PkqOKguHG/Ra8cviGvTu4zhUhcuNxza/XC3vSqFzj5ShvLg4H/lBHLkHLV1m3T7
         LmjFo3PAQXL+VUoWcQLnbMJIDaZwYf+hEJuwv/rwRInHcxr5xtNuvRWTX4qJrExohP
         EpcwVStCKha2KN6i0lfJEw9hk1MLO4aFH64d/czwGaWyf1OI6gFjoOjoP+fdffB0tW
         lra56dMz74DtA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 0/5] Fixes to mlx5 IPsec implementation
Date:   Thu, 20 Apr 2023 11:02:46 +0300
Message-Id: <cover.1681976818.git.leon@kernel.org>
X-Mailer: git-send-email 2.40.0
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

This small patchset includes various fixes and one refactoring patch
which I collected for the features sent in this cycle, with one exception -
first patch.

First patch fixes code which was introduced in previous cycle, however I
was able to trigger FW error only in custom debug code, so don't see a
need to send it to net-rc.

Thanks

Leon Romanovsky (5):
  net/mlx5e: Fix FW error while setting IPsec policy block action
  net/mlx5e: Don't overwrite extack message returned from IPsec SA
    validator
  net/mlx5e: Compare all fields in IPv6 address
  net/mlx5e: Properly release work data structure
  net/mlx5e: Refactor duplicated code in mlx5e_ipsec_init_macs

 .../mellanox/mlx5/core/en_accel/ipsec.c       | 53 +++++++++----------
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  2 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 16 +++---
 3 files changed, 35 insertions(+), 36 deletions(-)

-- 
2.40.0

