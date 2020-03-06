Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58D7C17B36F
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 02:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgCFBGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 20:06:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbgCFBGt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 20:06:49 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFC6120848;
        Fri,  6 Mar 2020 01:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583456808;
        bh=MnSx+bRM3bH2XiO0Bs9afQghY0J5GNchXPkSWXLLq9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4gn3Onzd39vjbS4WUY4DHugnMU8BK/REwM4+XVaV2bhs81F9FpAFTN4iLyHcS4hg
         3CtL1IEuhYU/zfQ5Plb1Mmdwh1OQfd3aSAgc2/nc8pkE7WCmm/sAk+mfxirK6eCQnA
         EEF4o4/w1/CFEEEMlSmgL5cfdZbYh5MHI+sGC4IM=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        linux-um@lists.infradead.org, dledford@redhat.com, jgg@ziepe.ca,
        leon@kernel.org, linux-rdma@vger.kernel.org, edumazet@google.com,
        jasowang@redhat.com, mkubecek@suse.cz, hayeswang@realtek.com,
        doshir@vmware.com, pv-drivers@vmware.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, gregkh@linuxfoundation.org,
        merez@codeaurora.org, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/7] um: reject unsupported coalescing params
Date:   Thu,  5 Mar 2020 17:05:56 -0800
Message-Id: <20200306010602.1620354-2-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200306010602.1620354-1-kuba@kernel.org>
References: <20200306010602.1620354-1-kuba@kernel.org>
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
 arch/um/drivers/vector_kern.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 0ff86391f77d..e98304d0219e 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1508,6 +1508,7 @@ static int vector_set_coalesce(struct net_device *netdev,
 }
 
 static const struct ethtool_ops vector_net_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_TX_USECS,
 	.get_drvinfo	= vector_net_get_drvinfo,
 	.get_link	= ethtool_op_get_link,
 	.get_ts_info	= ethtool_op_get_ts_info,
-- 
2.24.1

