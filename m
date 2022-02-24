Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C5D4C3767
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbiBXVIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiBXVIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:08:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE38718FACE;
        Thu, 24 Feb 2022 13:08:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99F15B829BA;
        Thu, 24 Feb 2022 21:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70918C340E9;
        Thu, 24 Feb 2022 21:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645736898;
        bh=GgSxQ7JcNCf7iXwHIZ1kVpdtf4ZgVxohv71Xw6IqHns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IejOzqjiR5HQke6tO+7QmVutkvmvKXRNIZk+kSQ80ASJxP9o2jxzeu60GvJVtB75f
         kNZ56dombH4QOB3ZzCraSNKn4zwNuAlMdhojH4Tv8AJDvDlgsidZmeCF/DHetnP7yf
         2FBl2bu2EbHe2HVRPoAtTzHo/Aar7HR4v89HyN8iBSba6HpYWwRPHqsgduv3e/TWpV
         30WWT1z9GiALFLb64H4gucWKjXxd3ue7CCkm9cKELJgRNnsuindPvuVLEgLEPffECM
         0FKOjTN2s5q7koIj7BHm1CljI5y5SZkARJMRdJWlNNxau+FzWkrXXWk2RZv/Pz2xy1
         Jb78G42uj2Rng==
Date:   Thu, 24 Feb 2022 15:16:16 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH v2 2/6][next] ath6kl: wmi: Replace one-element array with
 flexible-array member in struct wmi_start_scan_cmd
Message-ID: <8b33c6d86a6bd40b5688cf118b4b35850db8d8c7.1645736204.git.gustavoars@kernel.org>
References: <cover.1645736204.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1645736204.git.gustavoars@kernel.org>
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
wmi_start_scan_cmd. Also, make use of the struct_size() helper.

This issue was found with the help of Coccinelle and audited and fixed,
manually.

Link: https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
Link: https://github.com/KSPP/linux/issues/79
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v2:
 - None.

 drivers/net/wireless/ath/ath6kl/wmi.c | 8 +-------
 drivers/net/wireless/ath/ath6kl/wmi.h | 2 +-
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index e1c950014f3e..bdfc057c5a82 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1959,21 +1959,15 @@ static int ath6kl_wmi_startscan_cmd(struct wmi *wmi, u8 if_idx,
 {
 	struct sk_buff *skb;
 	struct wmi_start_scan_cmd *sc;
-	s8 size;
 	int i, ret;
 
-	size = sizeof(struct wmi_start_scan_cmd);
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
index 322539ed9c12..9e168752bec2 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -889,7 +889,7 @@ struct wmi_start_scan_cmd {
 	u8 num_ch;
 
 	/* channels in Mhz */
-	__le16 ch_list[1];
+	__le16 ch_list[];
 } __packed;
 
 /*
-- 
2.27.0

