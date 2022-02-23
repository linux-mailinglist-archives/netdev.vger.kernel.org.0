Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E544C08CF
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235157AbiBWCdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237233AbiBWCcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:32:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9DA5A5B8;
        Tue, 22 Feb 2022 18:30:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51324B81E15;
        Wed, 23 Feb 2022 02:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563D1C340F1;
        Wed, 23 Feb 2022 02:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583437;
        bh=5J/lYOlg+fnmxcJ6RZWQwnyehKvMIl8d1ncoQiQ9fcw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l5XjhmXsJFytYXELA4i2ZwCcGg+xyPVOUOmnnsbNJQ341mu1a0oVQivPUKHALanHC
         mpVNPFyLG4OiYCzy8Nf3m8am4Xm+5NCM/Y32QDMo02QsTh5ygKLaJdZK3iv5ikJl9h
         68RSNY4/+tfWZ2IIoOCbVxU2a/wdr35rKdHztRXsPeGgTtxP9YwbtKTlEOyHQgE3v2
         AzS4tXqV3OeSgLE69yzpYmRC7sOdujBNcVhxVF3b9zpsqm5fl04oGy1E4D+xwmD+nw
         L05CUHVP7AjL5m7TchcP9uU4Cd0vgWHFVvYh3dmGPnxiJI1Ez3IOSwl2JZd2FEOk+r
         Jt36jNXVXUPpw==
Date:   Tue, 22 Feb 2022 20:38:31 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 1/6][next] ath6kl: wmi: Replace one-element array with
 flexible-array member in struct wmi_begin_scan_cmd
Message-ID: <af3e7cf6101586a6de9710d8f1302763aa7c6396.1645583264.git.gustavoars@kernel.org>
References: <cover.1645583264.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1645583264.git.gustavoars@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace one-element array with flexible-array member in struct
wmi_begin_scan_cmd. Also, make use of the struct_size() helper.

This issue was found with the help of Coccinelle and audited and fixed,
manually.

Link: https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
Link: https://github.com/KSPP/linux/issues/79
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/wmi.c | 9 ++-------
 drivers/net/wireless/ath/ath6kl/wmi.h | 2 +-
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index bd1ef6334997..e1c950014f3e 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2008,7 +2008,7 @@ int ath6kl_wmi_beginscan_cmd(struct wmi *wmi, u8 if_idx,
 	struct ieee80211_supported_band *sband;
 	struct sk_buff *skb;
 	struct wmi_begin_scan_cmd *sc;
-	s8 size, *supp_rates;
+	s8 *supp_rates;
 	int i, band, ret;
 	struct ath6kl *ar = wmi->parent_dev;
 	int num_rates;
@@ -2023,18 +2023,13 @@ int ath6kl_wmi_beginscan_cmd(struct wmi *wmi, u8 if_idx,
 						num_chan, ch_list);
 	}
 
-	size = sizeof(struct wmi_begin_scan_cmd);
-
 	if ((scan_type != WMI_LONG_SCAN) && (scan_type != WMI_SHORT_SCAN))
 		return -EINVAL;
 
 	if (num_chan > WMI_MAX_CHANNELS)
 		return -EINVAL;
 
-	if (num_chan)
-		size += sizeof(u16) * (num_chan - 1);
-
-	skb = ath6kl_wmi_get_new_buf(size);
+	skb = ath6kl_wmi_get_new_buf(struct_size(sc, ch_list, num_chan));
 	if (!skb)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 784940ba4c90..322539ed9c12 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -863,7 +863,7 @@ struct wmi_begin_scan_cmd {
 	u8 num_ch;
 
 	/* channels in Mhz */
-	__le16 ch_list[1];
+	__le16 ch_list[];
 } __packed;
 
 /* wmi_start_scan_cmd is to be deprecated. Use
-- 
2.27.0

