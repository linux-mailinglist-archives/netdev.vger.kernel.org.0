Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5538229FB0
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 20:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732537AbgGVSxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 14:53:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726841AbgGVSxP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 14:53:15 -0400
Received: from embeddedor (unknown [200.39.29.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0018A207E8;
        Wed, 22 Jul 2020 18:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595443995;
        bh=f8L1/mWk1WxKSeB8IoWJ9p9hZ6uj4JQNstTzmlRy1F4=;
        h=Date:From:To:Cc:Subject:From;
        b=ZMJLGObp80o7pPgKnfWFkKyW2KzENFNfm63e0wL9cCU+MqXE9pt1OlKZd4bRytXMo
         tWWNWe5I09MuQ1dOuk2JhzjFPfi9D06qKS9h6gHkIX8HBii2rva3Cedi5STQbaFl4V
         y2/uHqeOd3AYbq0eZu755l3gXsWf1S+INmZfbcHc=
Date:   Wed, 22 Jul 2020 13:58:52 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Ariel Elior <aelior@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] net: qed_hsi.h: Avoid the use of one-element array
Message-ID: <20200722185852.GA16220@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One-element arrays are being deprecated[1]. Replace the one-element
array with a simple value type '__le32 reserved1'[2], once it seems
this is just a placeholder for alignment.

[1] https://github.com/KSPP/linux/issues/79
[2] https://github.com/KSPP/linux/issues/86

Tested-by: kernel test robot <lkp@intel.com>
Link: https://github.com/GustavoARSilva/linux-hardening/blob/master/cii/0-day/qed_hsi-20200718.md
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_hsi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index 1af3f65ab862..559df9f4d656 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -361,7 +361,7 @@ struct core_tx_update_ramrod_data {
 	u8 update_qm_pq_id_flg;
 	u8 reserved0;
 	__le16 qm_pq_id;
-	__le32 reserved1[1];
+	__le32 reserved1;
 };
 
 /* Enum flag for what type of dcb data to update */
-- 
2.27.0

