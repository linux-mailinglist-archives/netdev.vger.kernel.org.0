Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A626B4C376A
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234611AbiBXVJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiBXVJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:09:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C4228ADB1;
        Thu, 24 Feb 2022 13:09:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0AA0B824F5;
        Thu, 24 Feb 2022 21:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40EEC340E9;
        Thu, 24 Feb 2022 21:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645736956;
        bh=cZBJxU1epNW3z8QizvNd22wtWv1wIJN5kVmUoG10Rj0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YSMzWLZZruovBLcZtvzebIuy3tnllYaXluyE1kZdc/lemw4ts6GeQ+iYqukkB7TuM
         OUvygpcL60eVYnzOgKsDJ/SWBW2z8KXvH2nWLSMRi9fBIBufnF8lNSk493eDKioues
         gqoQuGdk+X8lwimOu3obQCZhdSlH4uPMZp+fE32pjIH27vlmDidqv4qWRNVQO2ATVB
         vG6ajtxMgY8lvO9V7cLjAeF26WT/p7aO2XlWunNNe0a9Z5DrX/zSZthFkKP1Je07F6
         0ItKxloHzRnRMDXniOz3i1RYCz7wj+Tv5UOUEzGFu2mHv3ub3RRP0pD+rc53KehyIr
         b2y5UsvTPq9og==
Date:   Thu, 24 Feb 2022 15:17:15 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH v2 4/6][next] ath6kl: wmi: Replace one-element array with
 flexible-array member in struct wmi_connect_event
Message-ID: <290a0cb7bddd813a6a96a59853880e66917aa03d.1645736204.git.gustavoars@kernel.org>
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
wmi_connect_event.

This issue was found with the help of Coccinelle and audited and fixed,
manually.

Link: https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
Link: https://github.com/KSPP/linux/issues/79
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v2:
 - Revert changes in if-statement logic:
        if (len < sizeof(struct wmi_connect_event))
   Link: https://lore.kernel.org/linux-hardening/6106494b-a1b3-6b57-8b44-b9528127533b@quicinc.com/
 - Update changelog text.
 - Add Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com> tag.

 drivers/net/wireless/ath/ath6kl/wmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 432e4f428a4a..6b064e669d87 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1545,7 +1545,7 @@ struct wmi_connect_event {
 	u8 beacon_ie_len;
 	u8 assoc_req_len;
 	u8 assoc_resp_len;
-	u8 assoc_info[1];
+	u8 assoc_info[];
 } __packed;
 
 /* Disconnect Event */
-- 
2.27.0

