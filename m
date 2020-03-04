Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFA61789A2
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 05:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgCDEej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 23:34:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:42712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728268AbgCDEeg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 23:34:36 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 852F1215A4;
        Wed,  4 Mar 2020 04:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583296476;
        bh=QC7bHbAPsHNj33rAj0r1wHdPf3SzfjBPDkwT+LKKjnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQbQsqSbjh3lSuhYifTk3bgvjd2wejUHZb1FGFUDQT3YAwuUmWCouad4WsUXA1cis
         4e3OC7mYOQUO3aI4iOfaHIOr5jA4bTEBqd/qazXriqnXAuIKCbr/cxkFifinKUe12j
         1bRuc+sp/zYh3j2eZKqkklSWUI5mAvh3f9yVWVUM=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     mkubecek@suse.cz, thomas.lendacky@amd.com, benve@cisco.com,
        _govind@gmx.com, pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 11/12] e1000e: reject unsupported coalescing params
Date:   Tue,  3 Mar 2020 20:33:53 -0800
Message-Id: <20200304043354.716290-12-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304043354.716290-1-kuba@kernel.org>
References: <20200304043354.716290-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->coalesce_types to let the core reject
unsupported coalescing parameters.

This driver did not previously reject unsupported parameters.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 9e7881db7859..9aef691a0e3a 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -2307,6 +2307,7 @@ static int e1000e_get_ts_info(struct net_device *netdev,
 }
 
 static const struct ethtool_ops e1000_ethtool_ops = {
+	.coalesce_types = ETHTOOL_COALESCE_RX_USECS,
 	.get_drvinfo		= e1000_get_drvinfo,
 	.get_regs_len		= e1000_get_regs_len,
 	.get_regs		= e1000_get_regs,
-- 
2.24.1

