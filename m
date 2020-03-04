Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A18D178951
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 04:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgCDD4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 22:56:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728004AbgCDD4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 22:56:08 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69E23215A4;
        Wed,  4 Mar 2020 03:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583294168;
        bh=Km7DdSOTyW+8QDzMJxXnlic+b2kwO2EPkx+4eyErBxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5+RNxMIatSOtOuEmWITWOpYxeoWPHUe8D15AFuUNijA9KUGptZzMEq3Jxo6ZObUi
         xn1dWY2UKjn1ruqXx/fhkPXJvAiKE/aXRrzy35KSKML64OJaaToeRJAhGKSxL8nUjR
         ajtTZz0Xl+0xWmzM0iakTt3l70TfYOPF2StVaeeo=
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
Subject: [PATCH net-next 12/12] virtio_net: reject unsupported coalescing params
Date:   Tue,  3 Mar 2020 19:55:01 -0800
Message-Id: <20200304035501.628139-13-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304035501.628139-1-kuba@kernel.org>
References: <20200304035501.628139-1-kuba@kernel.org>
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
 drivers/net/virtio_net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 84c0d9581f93..cfca3d134d4e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2273,6 +2273,7 @@ static void virtnet_update_settings(struct virtnet_info *vi)
 }
 
 static const struct ethtool_ops virtnet_ethtool_ops = {
+	.coalesce_types = ETHTOOL_COALESCE_TX_MAX_FRAMES,
 	.get_drvinfo = virtnet_get_drvinfo,
 	.get_link = ethtool_op_get_link,
 	.get_ringparam = virtnet_get_ringparam,
-- 
2.24.1

