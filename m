Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0FB17B37B
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 02:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgCFBG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 20:06:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbgCFBGw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 20:06:52 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 080BE21556;
        Fri,  6 Mar 2020 01:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583456811;
        bh=t6+kueVIWNtLUqViCk3MdqFhB51exWacT2hvYbn4hoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xdk2QAQZ24xQ+XNnceK3ptrcg2bWbXOcr9edHCgW/cXLqloNOsBzFBFHkh9fZ17u/
         UTSOplONajI9FemA3ollW3gpdBxDi42uXizDTyOzUnVChUfYu9ictQzzt1NcQhxxKi
         mlXYnjjf8vCnK3wYVfT27cEmWiwwbI1lNXUchhlQ=
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
Subject: [PATCH net-next 4/7] r8152: reject unsupported coalescing params
Date:   Thu,  5 Mar 2020 17:05:59 -0800
Message-Id: <20200306010602.1620354-5-kuba@kernel.org>
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
 drivers/net/usb/r8152.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index b8d2722a1b33..f27fdd6ab86f 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6345,6 +6345,7 @@ static int rtl8152_set_ringparam(struct net_device *netdev,
 }
 
 static const struct ethtool_ops ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS,
 	.get_drvinfo = rtl8152_get_drvinfo,
 	.get_link = ethtool_op_get_link,
 	.nway_reset = rtl8152_nway_reset,
-- 
2.24.1

