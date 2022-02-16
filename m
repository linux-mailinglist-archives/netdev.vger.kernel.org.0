Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7510B4B9195
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238258AbiBPTnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:43:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238001AbiBPTnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:43:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18327D0071;
        Wed, 16 Feb 2022 11:43:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F4FE618CC;
        Wed, 16 Feb 2022 19:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37738C004E1;
        Wed, 16 Feb 2022 19:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645040588;
        bh=vBUFtqU9xaEDtrCpZcGQYn7RAcYm9CMccb0wG8HPStQ=;
        h=Date:From:To:Cc:Subject:From;
        b=VTm7D3reMVnfuFASVyzY0zFKU/nf8t85RH4Skpx+du3VJDUOqWvvfyHbcycWCsbmz
         hJ5Pc/w1aMJAik97ztwwjONThijXMvjXs137HeomB8khtyoUwNrKrk5Hg0f+XTUAKE
         07+RtAgTjj9dIYeNabfYczPOIpxM5qCLs9CRo0bcwuQVSUyfkZJiKmSuR66WS4RTzm
         5r5V/eZHY3qMhIWzb+bnFxJol8AYVsmMiOBBRJRO0731EIs7VYM8g5CxHZpuCyXw22
         ko1oVvUIXb9nbdNRI/MT882L37WDlYc76e4QOY3KBPJMoSSrNhYWOb8DZqhS0z0Yol
         aGq+rizFU33DQ==
Date:   Wed, 16 Feb 2022 13:50:47 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] tw89: core.h: Replace zero-length array with
 flexible-array member
Message-ID: <20220216195047.GA904198@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare
having a dynamically sized set of trailing elements in a structure.
Kernel code should always use “flexible array members”[1] for these
cases. The older style of one-element or zero-length arrays should
no longer be used[2].

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/78
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 7c84556ec4ad..b15b529e19ed 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -2847,7 +2847,7 @@ struct rtw89_dev {
 	int napi_budget_countdown;
 
 	/* HCI related data, keep last */
-	u8 priv[0] __aligned(sizeof(void *));
+	u8 priv[] __aligned(sizeof(void *));
 };
 
 static inline int rtw89_hci_tx_write(struct rtw89_dev *rtwdev,
-- 
2.27.0

