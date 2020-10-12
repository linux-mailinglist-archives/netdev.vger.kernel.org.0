Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E2C28C129
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 21:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390131AbgJLTJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 15:09:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731037AbgJLTCy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 15:02:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC43920BED;
        Mon, 12 Oct 2020 19:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529374;
        bh=S0KZYLLGViKT+39FRrXiwxyyEjpKYZusv+4UoPxSpf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kqRniX6148EcNpuyQt0PQDenn3z8ZxgpNGMv7HNJ0WxEfmlEfdYp0RmbXHfohXPV7
         c7lDTJsLczncS5GSnRA26OEYf3hYZNcIPEpNCfRKSVeR9viY2pT3gmYytZ9EEAe1Ox
         Rc0OcA2iogKJh55X8gQMoF7HSInxw+GGdDN0zZC0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Igor Russkikh <irusskikh@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 11/24] net: atlantic: fix build when object tree is separate
Date:   Mon, 12 Oct 2020 15:02:26 -0400
Message-Id: <20201012190239.3279198-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190239.3279198-1-sashal@kernel.org>
References: <20201012190239.3279198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>

[ Upstream commit 059432495e209279bae12db3d2b0bc8c8fe987bb ]

Driver subfolder files refer parent folder includes in an
absolute manner.

Makefile contains a -I for this, but apparently that does not
work if object tree is separated.

Adding srctree to fix that.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/Makefile b/drivers/net/ethernet/aquantia/atlantic/Makefile
index 130a105d03f3b..8ebcc68e807fc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/Makefile
+++ b/drivers/net/ethernet/aquantia/atlantic/Makefile
@@ -8,7 +8,7 @@
 
 obj-$(CONFIG_AQTION) += atlantic.o
 
-ccflags-y += -I$(src)
+ccflags-y += -I$(srctree)/$(src)
 
 atlantic-objs := aq_main.o \
 	aq_nic.o \
@@ -33,4 +33,4 @@ atlantic-objs := aq_main.o \
 
 atlantic-$(CONFIG_MACSEC) += aq_macsec.o
 
-atlantic-$(CONFIG_PTP_1588_CLOCK) += aq_ptp.o
\ No newline at end of file
+atlantic-$(CONFIG_PTP_1588_CLOCK) += aq_ptp.o
-- 
2.25.1

