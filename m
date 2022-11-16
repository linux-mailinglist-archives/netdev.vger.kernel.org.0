Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4B862C55F
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbiKPQvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239139AbiKPQuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:50:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BE05B580;
        Wed, 16 Nov 2022 08:49:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4058161EEF;
        Wed, 16 Nov 2022 16:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EA0C433C1;
        Wed, 16 Nov 2022 16:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668617361;
        bh=3PXc8b0NW5v6xJidUcpApot9Eggk1dZUefh1V9dUkp8=;
        h=From:To:Cc:Subject:Date:From;
        b=fWk8VSQG4LrhUsu7cg1IKndN3Hob3rGNPaPU0wO8msrpAkSsfS/TYV/UszE0e9yzZ
         IvesQNWSpPJeiAZVOZ6WKDKQCT1UKLsL/JUXDEXbjizo8hekz+Vh81P/x1ObI6ZXno
         9bN7z29cykEGY0k+2jLp81Yf2Z8kKjV6W/nrifHfqs1kEKkKB0i9IVVTzPWE4Xiq+h
         AfBCB/7K2iDKihV1gSs7zdkLtVhZUVQVoc6Lwt9E3L8TeqCFYEj8FR5s5SNWF+I3xG
         j/BC1uI6gvumL/2BD960NXColdrzoiaDIYWp592eQhn77lcmggLs7P9BUvf8fdme9j
         YBup39MHr1ixA==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     edumazet@google.com, pabeni@redhat.com, vigneshr@ti.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roger Quadros <rogerq@kernel.org>
Subject: [PATCH 0/4] net: ethernet: ti: am65-cpsw: Fix set channel operation
Date:   Wed, 16 Nov 2022 18:49:11 +0200
Message-Id: <20221116164915.13236-1-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This contains a critical bug fix for the recently merged suspend/resume
support that broke set channel operation. (ethtool -L eth0 tx <n>)

Remaining patches are optimizations.

cheers,
-roger

Roger Quadros (4):
  net: ethernet: ti: am65-cpsw: Fix set channel operation
  net: ethernet: ti: am65-cpsw-nuss: Remove redundant ALE_CLEAR
  net: ethernet: ti: am65-cpsw: Restore ALE only if any interface was up
  net: ethernet: ti: cpsw_ale: optimize cpsw_ale_restore()

 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 166 +++++++++++++----------
 drivers/net/ethernet/ti/cpsw_ale.c       |   7 +-
 2 files changed, 97 insertions(+), 76 deletions(-)

-- 
2.17.1

