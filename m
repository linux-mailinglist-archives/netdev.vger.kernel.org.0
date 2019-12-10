Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 970EA119534
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbfLJVMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:12:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728944AbfLJVMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5828246A2;
        Tue, 10 Dec 2019 21:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012343;
        bh=Xc+R0wxmcm7rjXDmYijo1uCkTy8c9s8xszZck25u3nU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDxLI5GjCkQV+JpbZzuAzu5NzthKym3OISk7mGURqABUdcKp631uRLdPyEBZLEJjs
         MsA+s3mu6oKh6/oHl/roovml2SoNT/xNeK6CndTwYrjKM7qHn9Jp1DBjQI05Cn0J0A
         Dj+EMzPVq4lQCwjh07afWqRzAczqvqAPfANQsDXw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mao Wenan <maowenan@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 274/350] net: ethernet: ti: Add dependency for TI_DAVINCI_EMAC
Date:   Tue, 10 Dec 2019 16:06:19 -0500
Message-Id: <20191210210735.9077-235-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>

[ Upstream commit b2ef81dcdf3835bd55e5f97ff30131bb327be7fa ]

If TI_DAVINCI_EMAC=y and GENERIC_ALLOCATOR is not set,
below erros can be seen:
drivers/net/ethernet/ti/davinci_cpdma.o: In function `cpdma_desc_pool_destroy.isra.14':
davinci_cpdma.c:(.text+0x359): undefined reference to `gen_pool_size'
davinci_cpdma.c:(.text+0x365): undefined reference to `gen_pool_avail'
davinci_cpdma.c:(.text+0x373): undefined reference to `gen_pool_avail'
davinci_cpdma.c:(.text+0x37f): undefined reference to `gen_pool_size'
drivers/net/ethernet/ti/davinci_cpdma.o: In function `__cpdma_chan_free':
davinci_cpdma.c:(.text+0x4a2): undefined reference to `gen_pool_free_owner'
drivers/net/ethernet/ti/davinci_cpdma.o: In function `cpdma_chan_submit_si':
davinci_cpdma.c:(.text+0x66c): undefined reference to `gen_pool_alloc_algo_owner'
davinci_cpdma.c:(.text+0x805): undefined reference to `gen_pool_free_owner'
drivers/net/ethernet/ti/davinci_cpdma.o: In function `cpdma_ctlr_create':
davinci_cpdma.c:(.text+0xabd): undefined reference to `devm_gen_pool_create'
davinci_cpdma.c:(.text+0xb79): undefined reference to `gen_pool_add_owner'
drivers/net/ethernet/ti/davinci_cpdma.o: In function `cpdma_check_free_tx_desc':
davinci_cpdma.c:(.text+0x16c6): undefined reference to `gen_pool_avail'

This patch mades TI_DAVINCI_EMAC select GENERIC_ALLOCATOR.

Fixes: 99f629718272 ("net: ethernet: ti: cpsw: drop TI_DAVINCI_CPDMA config option")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 834afca3a0195..137632b09c729 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -22,6 +22,7 @@ config TI_DAVINCI_EMAC
 	depends on ARM && ( ARCH_DAVINCI || ARCH_OMAP3 ) || COMPILE_TEST
 	select TI_DAVINCI_MDIO
 	select PHYLIB
+	select GENERIC_ALLOCATOR
 	---help---
 	  This driver supports TI's DaVinci Ethernet .
 
-- 
2.20.1

