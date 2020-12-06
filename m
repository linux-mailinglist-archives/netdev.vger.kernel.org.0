Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012652CFFDE
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 01:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgLFABw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 19:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbgLFABv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 19:01:51 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9081AC0613D4
        for <netdev@vger.kernel.org>; Sat,  5 Dec 2020 16:01:05 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id h21so10297985wmb.2
        for <netdev@vger.kernel.org>; Sat, 05 Dec 2020 16:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=XhypvLhjLjgPJLi+sFOljhwXZxv/PXDgkLN+nebBmD0=;
        b=t0/B0io+oHAvDcsX82vtNSqwUZsUL8rcZ6IXJxPkVOz5eH4zHkaQNm+OBhwq4rcDtx
         y8cr3zJLSrTBJw/rYbEgX918m1aYotTRBGSdzuxu1otaY5wGIGpk/CwQ7QL7vy3VXFSm
         QXzIOqV0+gYqYQxc2jsRDuM97meEOlxpcUFHeCFX/LmiiDfNlLW7Po79fF3n4tOVugzM
         A0ikq6LXLgsdqhca4Eud3nzbuBtr7qKxoWsCpaGHuaDMMCDnh475qC/vt1ciWUdyiX3m
         FSd6jTi1mlzR+J9Pgr7VVTDSBS+IJxW+XsYz050JqG0Bp6cvw6dBN7uWQjYLPvX1ZY2Z
         ViMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=XhypvLhjLjgPJLi+sFOljhwXZxv/PXDgkLN+nebBmD0=;
        b=sFLXxMe6NkqDpzC2rDZIOoRLw2Dw/kWLa8UX6La6F7hITbAJPCGl4kGUfrRMt7tRGs
         zqHPxv+Kua1elUiCFzpXF5ESripBVq3UF746ztTEoTCb0HLZAVf4vabMfY4f79OPFfe9
         XstoD3NF4UAd0SgiXyrcpHW4XoFEYUa4cI93yXaTJ9uATqAHtGNLb9t4dUEQe0ipooz4
         0gQE4HVGw4htXotNyxjf4po2a3WXNIcm8ZAue51WbEUq8bGBztAYtCQq7b82BsSP8oBE
         0xGPxPZzdNEpjmYXqhwPbr3yKwg70t92ZIElI0eVVtMY+4mJVhQxbV6p5mTBDsOL1CNY
         aNwQ==
X-Gm-Message-State: AOAM532KZRxy+voXpK4Ur78GXXFI4LF/KXld/ex+fnK2XWPKRtVmmmdG
        zGZPn0OvhMhAbNYbFtECOPg5HRqJ638=
X-Google-Smtp-Source: ABdhPJxNsIlDmmrawUIUBYBrsX3bwvTOeViSGZdHOctudecwH1cEJwUrVWNmgRWt37GQ9iobfcuRcQ==
X-Received: by 2002:a1c:9d8b:: with SMTP id g133mr11277572wme.189.1607212864103;
        Sat, 05 Dec 2020 16:01:04 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2e:e00:6845:f25a:bfd1:6598? (p200300ea8f2e0e006845f25abfd16598.dip0.t-ipconnect.de. [2003:ea:8f2e:e00:6845:f25a:bfd1:6598])
        by smtp.googlemail.com with ESMTPSA id z3sm3459348wrn.59.2020.12.05.16.01.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Dec 2020 16:01:03 -0800 (PST)
Subject: [PATCH net-next 2/2] r8169: make NUM_RX_DESC a signed int
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bf2db26b-5188-7311-a89a-32fafcd653ac@gmail.com>
Message-ID: <c7fce55c-ae84-80c3-4f8c-0fe3aefde98a@gmail.com>
Date:   Sun, 6 Dec 2020 01:00:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <bf2db26b-5188-7311-a89a-32fafcd653ac@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After recent changes there's no need any longer to define NUM_RX_DESC
as an unsigned value.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3ea27a657..46d8510b2 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -68,7 +68,7 @@
 #define R8169_REGS_SIZE		256
 #define R8169_RX_BUF_SIZE	(SZ_16K - 1)
 #define NUM_TX_DESC	256	/* Number of Tx descriptor registers */
-#define NUM_RX_DESC	256U	/* Number of Rx descriptor registers */
+#define NUM_RX_DESC	256	/* Number of Rx descriptor registers */
 #define R8169_TX_RING_BYTES	(NUM_TX_DESC * sizeof(struct TxDesc))
 #define R8169_RX_RING_BYTES	(NUM_RX_DESC * sizeof(struct RxDesc))
 
@@ -3844,7 +3844,7 @@ static struct page *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
 
 static void rtl8169_rx_clear(struct rtl8169_private *tp)
 {
-	unsigned int i;
+	int i;
 
 	for (i = 0; i < NUM_RX_DESC && tp->Rx_databuff[i]; i++) {
 		dma_unmap_page(tp_to_dev(tp),
@@ -3859,7 +3859,7 @@ static void rtl8169_rx_clear(struct rtl8169_private *tp)
 
 static int rtl8169_rx_fill(struct rtl8169_private *tp)
 {
-	unsigned int i;
+	int i;
 
 	for (i = 0; i < NUM_RX_DESC; i++) {
 		struct page *data;
-- 
2.29.2


