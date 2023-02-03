Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687D1688C83
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 02:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbjBCB3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 20:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbjBCB3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 20:29:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20D47C71A;
        Thu,  2 Feb 2023 17:29:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AD8BB82560;
        Fri,  3 Feb 2023 01:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65836C433D2;
        Fri,  3 Feb 2023 01:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675387772;
        bh=hOtbfO5ACqKII86Tj3f0eqnQOhB2cqeQ/aBmhLjhLPI=;
        h=Date:From:To:Cc:Subject:From;
        b=JZhlctIc/IqnodVD0zClmzGgWe3S/rgUrNmM9dwtnucsYYu6/TOFWcqxhpOtt3Pa8
         XtBMq3k5YcGNXCDh5YWgQLMZ8yz+tKPMvX6fES63LC9RbThaWrTlkNSXniOLPXU/nX
         X4iFWg5T8latubEjcpytl5vZV1lLB4LhLf1/NxXV2HNp9xKZAytkfggs8IGrxzgFq7
         I2bi9duy4IkhwWpQJnxP6S7YF3LEQYvzPewjlEJ4rWD3i/SwalCS6Q6hpUE/dHJNJx
         jrZyZAk51dQaiWW8oRcs7FB/UsfvA6rP2gqephVlQ2ETkT+2m2ESvEMqjo5tDqdLQu
         DRz/21WL+4fRA==
Date:   Thu, 2 Feb 2023 19:29:47 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] brcmfmac: Replace one-element array with
 flexible-array member
Message-ID: <Y9xjizhMujNEtpB4@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One-element arrays are deprecated, and we are replacing them with flexible
array members instead. So, replace one-element array with flexible-array
member in struct brcmf_tlv.

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -fstrict-flex-arrays=3 [1].

This results in no differences in binary output.

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/253
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index e90a30808c22..0e1fa3f0dea2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -383,7 +383,7 @@ struct brcmf_cfg80211_info {
 struct brcmf_tlv {
 	u8 id;
 	u8 len;
-	u8 data[1];
+	u8 data[];
 };
 
 static inline struct wiphy *cfg_to_wiphy(struct brcmf_cfg80211_info *cfg)
-- 
2.34.1

