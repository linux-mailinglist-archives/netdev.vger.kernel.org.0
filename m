Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46495A567D
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 23:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiH2VvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 17:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiH2VvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 17:51:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418A37CB49;
        Mon, 29 Aug 2022 14:51:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3A96611B8;
        Mon, 29 Aug 2022 21:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4834C433D7;
        Mon, 29 Aug 2022 21:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661809865;
        bh=fXRYrMEM8Kk9+epg4G5pFtUERqSSGU8XuYoO6vErhkM=;
        h=Date:From:To:Cc:Subject:From;
        b=SWAzvLQHq6MKKoZVJQRmwywvjem5AjdbGmOtmsa8n4SdUSrwzoKWS04r1Q7uzGnAp
         e2Nocsr45XUJtOl78NNUowJa74WDxeB242k9Sx2Unu76qCw1sDOHMpirZWfXRaGaBT
         mkXvf1D4Hw/Yjyz5WRG394hiET42VHptEduU+2UokaFstMkjo84qCBT/AyeiJ0Osa/
         oPZzRWiI3ZQHnUoDC57GZw9AP1xmgUAPPwFB5nfg1zV6zUftGjHgXfDBzTm4KlWCPQ
         4IRP51HBalW+LP0mnJ6G1TFTzGkpNs9vuZcO/VEzTAoJdSgS5KOHPG3Zw4ggPjlWq5
         b2aFUnLyiL+dQ==
Date:   Mon, 29 Aug 2022 16:50:59 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] can: etas_es58x: Replace zero-length array with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <Yw00w6XRcq7B6ub6@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays are deprecated and we are moving towards adopting
C99 flexible-array members, instead. So, replace zero-length array
declaration in union es58x_urb_cmd with the new DECLARE_FLEX_ARRAY()
helper macro.

This helper allows for a flexible-array member in a union.

Link: https://github.com/KSPP/linux/issues/193
Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/can/usb/etas_es58x/es58x_core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.h b/drivers/net/can/usb/etas_es58x/es58x_core.h
index d769bdf740b7..640fe0a1df63 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.h
@@ -222,7 +222,7 @@ union es58x_urb_cmd {
 		u8 cmd_type;
 		u8 cmd_id;
 	} __packed;
-	u8 raw_cmd[0];
+	DECLARE_FLEX_ARRAY(u8, raw_cmd);
 };
 
 /**
-- 
2.34.1

