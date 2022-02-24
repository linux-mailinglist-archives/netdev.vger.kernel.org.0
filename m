Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058864C376E
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiBXVJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234601AbiBXVJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:09:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980B61DED49;
        Thu, 24 Feb 2022 13:08:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41CD5B829B8;
        Thu, 24 Feb 2022 21:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226CCC340E9;
        Thu, 24 Feb 2022 21:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645736928;
        bh=Vl3ib7xbq47C3BnaPMshuk8tRt16r+WBcMwB0/gWLIo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Spsygd9HrvSsJS2wTixxcoZi9fmFnKZ/oQiYY8LJerITprwMV9xeRUNm6WhzcjH1o
         PaubA55gEG1Q55UDo6dJganqmVjzy4Bmfl7N9rPtxylEeyKzF61CBu6kzzcVRTlYiB
         pcOhdONjo4a+kXHJRlnzHmINHirTg+FQx2czebFOAfTKWV1nRUbQKhgFM18LzYe2Hj
         FbvjHrPf2zJ495rHKUlWzap1VXVrRDwZmXwlnw/vRbTx5YaDFlawET6GPxRW8K0/8m
         qYUyuS2x0QIZbQ25OjOlAMoaMA8idCyqOSq20CMytZEu+akI2xWgmJAkuhgy3BKwwY
         nhf28eCpvZA2A==
Date:   Thu, 24 Feb 2022 15:16:46 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH v2 3/6][next] ath6kl: wmi: Replace one-element array with
 flexible-array member in struct wmi_channel_list_reply
Message-ID: <f3f9728a1dfc3767340f25a963be374e2ef5d8ad.1645736204.git.gustavoars@kernel.org>
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
wmi_channel_list_reply.

This issue was found with the help of Coccinelle and audited and fixed,
manually.

Link: https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
Link: https://github.com/KSPP/linux/issues/79
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v2:
 - Revert changes in if-statement logic:
	if (len < sizeof(struct wmi_channel_list_reply))
   Link: https://lore.kernel.org/linux-hardening/3abb0846-a26f-3d76-8936-cd23cf4387f1@quicinc.com/
 - Update changelog text.
 - Add Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com> tag.

 drivers/net/wireless/ath/ath6kl/wmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 9e168752bec2..432e4f428a4a 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1373,7 +1373,7 @@ struct wmi_channel_list_reply {
 	u8 num_ch;
 
 	/* channel in Mhz */
-	__le16 ch_list[1];
+	__le16 ch_list[];
 } __packed;
 
 /* List of Events (target to host) */
-- 
2.27.0

