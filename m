Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142D85EB388
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 23:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiIZVtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 17:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiIZVtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 17:49:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14809AF4B3;
        Mon, 26 Sep 2022 14:49:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 82F04CE13C2;
        Mon, 26 Sep 2022 21:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863D0C433C1;
        Mon, 26 Sep 2022 21:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664228949;
        bh=c5mfyvzDdtpGvBZNQbXZ/taarYpntfkhxbA0y29pcg0=;
        h=Date:From:To:Cc:Subject:From;
        b=EqYLoFHjZB9GeNvg5n2j0bK9J6ES8kua1hp0Y4O/va9opVdpxZLsnlb6xsFdRCOZl
         jCzZNlrxwtVRg0gUTsSjbs3TzszokzPt3iAF6xIkgxFJwgCeck8YnmuMExrUEvYFJD
         rcDH7jGRj3ix9cf+F302oIGojrnthS6yPDftr8TlP27K88T6Uc2uk+5vVHyFgtAHNe
         VrjA6BcCdvrs12+LHCjK4+304y2xHpxv91nEjnk33B1RZnmNSgf18AAz0GO8U8Nqxl
         Cg+G3rGdiWBJQJ09RYvjL3hXJH5nqvPBuUlmrzq52Okm14PJgWh+PfnJeMgg3+cFcG
         zWwa0/HHp+fmQ==
Date:   Mon, 26 Sep 2022 16:49:04 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] ipw2x00: Replace zero-length array with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <YzIeULWc17XSIglv@work>
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
Link: https://github.com/KSPP/linux/issues/220
Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.h b/drivers/net/wireless/intel/ipw2x00/ipw2200.h
index 55cac934f4ee..09ddd21608d4 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.h
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.h
@@ -651,7 +651,7 @@ struct ipw_rx_notification {
 		struct notif_link_deterioration link_deterioration;
 		struct notif_calibration calibration;
 		struct notif_noise noise;
-		u8 raw[0];
+		DECLARE_FLEX_ARRAY(u8, raw);
 	} u;
 } __packed;
 
-- 
2.34.1

