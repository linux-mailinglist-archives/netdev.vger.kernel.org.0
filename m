Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06165187432
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 21:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732591AbgCPUrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 16:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732537AbgCPUrX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 16:47:23 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E2232071C;
        Mon, 16 Mar 2020 20:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584391643;
        bh=ws6SIXQPtwGp2/bp0/7FS1oVheMCa2u02DDYEjUnsSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vh/fMIqve+X6dwCLNATNGG4YMBWU9omXewDst4FYbefUQwT1rGvsNr1pviDGCP8fW
         iFWleULycp9XXdQmdMa7+IzVOtPfKURTlUx7MneAOf2nKtq2FIcandfWgvTkh8izUH
         P9Kr8jvzatuLd7s1ViFjgXytdml1d0dep7tm+bHo=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        ecree@solarflare.com, mhabets@solarflare.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        Jose.Abreu@synopsys.com, andy@greyhouse.net,
        grygorii.strashko@ti.com, andrew@lunn.ch, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/9] net: socionext: reject unsupported coalescing params
Date:   Mon, 16 Mar 2020 13:47:05 -0700
Message-Id: <20200316204712.3098382-3-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200316204712.3098382-1-kuba@kernel.org>
References: <20200316204712.3098382-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->supported_coalesce_params to let
the core reject unsupported coalescing parameters.

This driver did not previously reject unsupported parameters.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/socionext/netsec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 58b9b7ce7195..a5a0fb60193a 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -589,6 +589,8 @@ static void netsec_et_set_msglevel(struct net_device *dev, u32 datum)
 }
 
 static const struct ethtool_ops netsec_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES,
 	.get_drvinfo		= netsec_et_get_drvinfo,
 	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
 	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
-- 
2.24.1

