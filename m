Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9233B4245AF
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 20:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239125AbhJFSJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 14:09:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229992AbhJFSJw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 14:09:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F174961039;
        Wed,  6 Oct 2021 18:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633543679;
        bh=4H3UbAzOvhL7VvGwxsIUhSjoYwJuXz+t9/UCE0IhIcA=;
        h=Date:From:To:Cc:Subject:From;
        b=A/Y1PTcGhYR2SWXNRvxtC7lddnL5VsWZ80djNr0oiFXb2HltlVb9hQaiTTsd0abpP
         xmBVlcixn0lMZHFcOMtx1M9eLLABaseXSlE9NIlqoM/SGyD55xAVlkBH7l7x306x6d
         2bNEQOklusyFgJqhpk8aJYWAlKG3FeXVAkbiejBlbu7SazegjcXXZaF1xUoHL5Htop
         wqo8U+OEM0a12bY2L4xO4Ok9zYzIuHOgOG7Xkxkt2daPpUfRjIibM6mA7ww1vCSClN
         g4VOrH6k+fbV6eRET7p6upCT5/3dt+85rKjoQgSIlVdTM6W9n7ENm2bLh+pkxdUlwF
         pI+trbHwr/emw==
Date:   Wed, 6 Oct 2021 13:12:04 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] ath11k: Use kcalloc() instead of kzalloc()
Message-ID: <20211006181204.GA913553@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use 2-factor multiplication argument form kcalloc() instead
of kzalloc().

Link: https://github.com/KSPP/linux/issues/162
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 6c253eae9d06..0bbda81117df 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -4046,8 +4046,8 @@ static int ath11k_wmi_tlv_mac_phy_caps_parse(struct ath11k_base *soc,
 
 	len = min_t(u16, len, sizeof(struct wmi_mac_phy_capabilities));
 	if (!svc_rdy_ext->n_mac_phy_caps) {
-		svc_rdy_ext->mac_phy_caps = kzalloc((svc_rdy_ext->tot_phy_id) * len,
-						    GFP_ATOMIC);
+		svc_rdy_ext->mac_phy_caps = kcalloc(svc_rdy_ext->tot_phy_id,
+						    len, GFP_ATOMIC);
 		if (!svc_rdy_ext->mac_phy_caps)
 			return -ENOMEM;
 	}
@@ -4447,8 +4447,8 @@ static struct cur_reg_rule
 	struct cur_reg_rule *reg_rule_ptr;
 	u32 count;
 
-	reg_rule_ptr =  kzalloc((num_reg_rules * sizeof(*reg_rule_ptr)),
-				GFP_ATOMIC);
+	reg_rule_ptr = kcalloc(num_reg_rules, sizeof(*reg_rule_ptr),
+			       GFP_ATOMIC);
 
 	if (!reg_rule_ptr)
 		return NULL;
-- 
2.27.0

