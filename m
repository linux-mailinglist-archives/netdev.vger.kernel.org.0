Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1840C5EB36F
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 23:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiIZVpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 17:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbiIZVpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 17:45:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F8AA4B3E;
        Mon, 26 Sep 2022 14:45:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F202C61472;
        Mon, 26 Sep 2022 21:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959DAC433B5;
        Mon, 26 Sep 2022 21:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664228703;
        bh=+Y0sv9EVA4FqX8Y8XRokZjKKQ2LuMoLdfY5z5p8QA+Q=;
        h=Date:From:To:Cc:Subject:From;
        b=YmOESp3i1XstTxOo9vtfKCKVjOsylGX+KyQJnPQ9ZdUgdT+GCLOIfd+NaYYPabGf/
         Kx/n87dltynjj1Uwhni6B6vHgx+XHk3QKMsnunD3rDT3lN/a7UGEnF2tYfIpBvBkRy
         bHySwYcfInk4GCG2fvE4K36Jxu2nS/77sUTAt8k99dQQsk9zd8zDiszoKxKgVeXseY
         ibBMzDO35dQttB/nHYzcsH3chQsUtBSGj56UxqXN1K3a1aWQ8Wdc7Oq5IAN2XGiT8m
         IL0OFNyWcOjQB9krgS/1lwroTTImpspEur3wlAdBRQXoY/gm9Kofra1KWfhv8npNJR
         60Hn3rbHXuJ2A==
Date:   Mon, 26 Sep 2022 16:44:57 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] carl9170: Replace zero-length array with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <YzIdWc8QSdZFHBYg@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays are deprecated and we are moving towards adopting
C99 flexible-array members, instead. So, replace zero-length arrays
declarations in anonymous union with the new DECLARE_FLEX_ARRAY()
helper macro.

This helper allows for flexible-array members in unions.

Link: https://github.com/KSPP/linux/issues/193
Link: https://github.com/KSPP/linux/issues/215
Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ath/carl9170/wlan.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/wlan.h b/drivers/net/wireless/ath/carl9170/wlan.h
index 0a4e42e806b9..ded2c6d0a759 100644
--- a/drivers/net/wireless/ath/carl9170/wlan.h
+++ b/drivers/net/wireless/ath/carl9170/wlan.h
@@ -271,7 +271,7 @@ struct ar9170_tx_frame {
 
 	union {
 		struct ieee80211_hdr i3e;
-		u8 payload[0];
+		DECLARE_FLEX_ARRAY(u8, payload);
 	} data;
 } __packed;
 
-- 
2.34.1

