Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9BF1FEE75
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 16:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730816AbfKPPvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:51:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730805AbfKPPvj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:51:39 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEF7420871;
        Sat, 16 Nov 2019 15:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919499;
        bh=ZbZQWLNVEAwI0OA//as0xFt12U2YZ+kzigbVogJ9SX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kmAKKDu1Qq8K1a/vMemjlsL063LRAabFDtKy4wlM1ts3G21sWNNe40e91P/mK4Wvb
         j/H/jDWe3HqL+3y0hfHry+pw9K047x7POHUTRIyyWb+a5qC7MpT2jlMfRCujo5g9Tz
         gWMs/0lpUy0H1LBM3G8yfzW1u7fqcfYJbIu2qOOI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Netanel Belgazal <netanel@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 26/99] net: ena: Fix Kconfig dependency on X86
Date:   Sat, 16 Nov 2019 10:49:49 -0500
Message-Id: <20191116155103.10971-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Netanel Belgazal <netanel@amazon.com>

[ Upstream commit 8c590f9776386b8f697fd0b7ed6142ae6e3de79e ]

The Kconfig limitation of X86 is to too wide.
The ENA driver only requires a little endian dependency.

Change the dependency to be on little endian CPU.

Signed-off-by: Netanel Belgazal <netanel@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/Kconfig b/drivers/net/ethernet/amazon/Kconfig
index 99b30353541ab..9e87d7b8360f5 100644
--- a/drivers/net/ethernet/amazon/Kconfig
+++ b/drivers/net/ethernet/amazon/Kconfig
@@ -17,7 +17,7 @@ if NET_VENDOR_AMAZON
 
 config ENA_ETHERNET
 	tristate "Elastic Network Adapter (ENA) support"
-	depends on (PCI_MSI && X86)
+	depends on PCI_MSI && !CPU_BIG_ENDIAN
 	---help---
 	  This driver supports Elastic Network Adapter (ENA)"
 
-- 
2.20.1

