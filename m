Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6E26197B6
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 14:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbiKDNXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 09:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiKDNXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 09:23:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5E319A;
        Fri,  4 Nov 2022 06:23:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4D6FB82B68;
        Fri,  4 Nov 2022 13:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDBAC433D7;
        Fri,  4 Nov 2022 13:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667568197;
        bh=sDMsoprytbqmkwSBj1IS37nAywKoaXbS8hLbGeQnDMQ=;
        h=From:To:Cc:Subject:Date:From;
        b=trAabo5HBEaZhWUW6vjWgwCNmBp3n4132XKmNSDOyr73YWrAynlmo25cs8HY87hBT
         UBv3LrPpqgBPK8ZS63E/LNK4NgbSL0SzsZWu/oOl3WeS0mMHiwuueEnLIXo/CREhT0
         Vosm5zG+CFI8z9lL4u8uxVpv4byeDC60qT0gkI/8FMuR34pkJuHSVr+RbApZ9PSo6r
         Ysq8eNkBTaJRY4kZVPhMvaGoMYstg/9tCvPrFr6sLJbSdgaMvqQEeDiMQ5qOWPVQIf
         yeIXaj1udvnv0IFHqkGpq98JJxxpUnQ60/cLlwd+lqpE7te+2W+MSETfrnLb0r05YT
         FVueMdbZwRfLQ==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vigneshr@ti.com, vibhore@ti.com, srk@ti.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@kernel.org>
Subject: [PATCH 0/5] net: ethernet: ti: am65-cpsw: Add suspend/resume support
Date:   Fri,  4 Nov 2022 15:23:05 +0200
Message-Id: <20221104132310.31577-1-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series enables PM_SLEEP(suspend/resume) support to
the am65-cpsw network driver.

Dual-emac and Switch mode are tested to work with suspend/resume
on AM62-SK platform.

It can be verified on the following branch
https://github.com/rogerq/linux/commits/for-v6.2/am62-cpsw-lpm-1.0

cheers,
-roger

Roger Quadros (5):
  net: ethernet: ti: am65-cpsw/cpts: Add suspend/resume helpers
  net: ethernet: ti: am65-cpsw: Add suspend/resume support
  net: ethernet: ti: cpsw_ale: Add cpsw_ale_restore() helper
  net: ethernet: ti: am65-cpsw: retain PORT_VLAN_REG after
    suspend/resume
  net: ethernet: ti: am65-cpsw: Fix hardware switch mode on
    suspend/resume

 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 235 +++++++++++++++++------
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |   6 +
 drivers/net/ethernet/ti/am65-cpts.c      |  76 ++++++++
 drivers/net/ethernet/ti/am65-cpts.h      |  10 +
 drivers/net/ethernet/ti/cpsw_ale.c       |  10 +
 drivers/net/ethernet/ti/cpsw_ale.h       |   1 +
 6 files changed, 283 insertions(+), 55 deletions(-)

-- 
2.17.1

