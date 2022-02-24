Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972B64C3773
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbiBXVKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbiBXVKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:10:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCDB18FAE0;
        Thu, 24 Feb 2022 13:09:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEC6BB824F5;
        Thu, 24 Feb 2022 21:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1537C340E9;
        Thu, 24 Feb 2022 21:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645736973;
        bh=DcAufs9Hrmo8JESsKyMlW7GHd+f4ZhKBuP43hQIXIFU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B+BhV6pvi/ih5l34RdQQ+65B4ws/9rDkE6x4Bpf5tr7381ZEopE+yMRmHwVn9N4XR
         n5VyVGyCIXX0sJCtXZI7QD5MUwbW3RwK/zBdyAn6iqRgNX9+CALlk2gZkninIIZfaO
         C4wYnsm7I4XZ7JvdtmD/yikkC9ioOxIX/UQQNtzdYDk07cJ876LOaFK3+32oM3a51g
         pTTxbXmaCVlJc8YBLRIrcQkWkIqp42tYTv9aowU1DTJ+UoqExz1GUscSwb8nyMl3fU
         RDDvspL0Lb94pvdqopi/+2k2Pj/12jnsO4dNSEeOzuCBupVKP7mcHDzSY9UjAr/1tQ
         P9/xgrzPyqrZg==
Date:   Thu, 24 Feb 2022 15:17:32 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH v2 5/6][next] ath6kl: wmi: Replace one-element array with
 flexible-array member in struct wmi_disconnect_event
Message-ID: <e9957dc53ae48c2f39ae57b0157a67d844b5bc20.1645736204.git.gustavoars@kernel.org>
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
wmi_disconnect_event.

This issue was found with the help of Coccinelle and audited and fixed,
manually.

Link: https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
Link: https://github.com/KSPP/linux/issues/79
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v2:
 - Revert changes in if-statement logic:
        if (len < sizeof(struct wmi_disconnect_event))
   Link: https://lore.kernel.org/linux-hardening/03cee2a7-1455-b788-e1f0-5fb48db3478c@quicinc.com/
 - Update changelog text.
 - Add Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com> tag.

 drivers/net/wireless/ath/ath6kl/wmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 6b064e669d87..6a7fc07cd9aa 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1596,7 +1596,7 @@ struct wmi_disconnect_event {
 	u8 disconn_reason;
 
 	u8 assoc_resp_len;
-	u8 assoc_info[1];
+	u8 assoc_info[];
 } __packed;
 
 /*
-- 
2.27.0

