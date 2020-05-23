Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE851DF6D4
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 13:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387790AbgEWLXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 07:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387783AbgEWLXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 07:23:43 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBEEC061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 04:23:42 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id c3so8533851wru.12
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 04:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7sHfwcN2DcKFB66ineZRdffLT1xwlBWIMeE9cARjn+Q=;
        b=IX+Z5r5nyveViwYaPG2VXXEFT97ikbOBMp0i+VGC+PPrdpw9+FlZnPlMtQmMgHmrXW
         4eeuMkd49+Pnbk2GXv9AjGdXnQhnTyslFYVRxO3ngeO1QRWPd2QgFjTQV0z4Xg24bFyI
         U4BjBLEJM+0yizfeQvXZHB7qeF5ySPnPoLQwxZhBUIYWfneLHokG1xThiTfO3za5z6x/
         zxxgH8qU+4wk63azIwfBwn2k8QBgkMXHuG42TXlJlHs5vzAWHvB0M9feE72gYnNZ1CFf
         xx9V2c84np0yO6NilmB07uwUBxINPjHwFZRYwKftsy+awDderc4rxdqhQNBBhMxnoynR
         hs4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7sHfwcN2DcKFB66ineZRdffLT1xwlBWIMeE9cARjn+Q=;
        b=oobClAj2ZgwPPZLmaVCrvga8jrLHm2MKX4J9TeEN7MdRXQmE14Jx4uoz8exTqOQgx7
         xPBbeKYHdmfzC+av1pXk5nIUtVaWr2WQVeQDLTb503pySuQoLA7XEQVNJiJaHHjuoQLp
         3W2rB8fQbYvumN9pif2mSidAjMFQwUIlJsijxzKLtEcXw+5ShMp2ZvKhCNpjXw3g3qOY
         jsaPwpoyPGRHhkcvsYokSvcgta98jOzkCqIu7km9YF8fgM7EY5QkB6JBJyuF15Teq6cD
         pJoS1yulCN/WrwCJlZWG4SMkD+AjRZW9S4edFr1JHxgjD9A/H7fO3CjJq1Ultl7MuYyJ
         qIvw==
X-Gm-Message-State: AOAM531cLJa2BrZGvjuOCGN+4zbARKS2VQLfSduL9VyOs2QyMBw9Kda7
        3uSscCnci5UXSoPFXeDkxfPyPgXL
X-Google-Smtp-Source: ABdhPJyCaXtFGEeJrY3J0qSD3XhPcTwe8UqPJwKN8unUJE4jCZvGpPSvJuq+ZC1Di27JHNOsoRp0BQ==
X-Received: by 2002:adf:9795:: with SMTP id s21mr949698wrb.166.1590233021261;
        Sat, 23 May 2020 04:23:41 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:69db:99aa:4dc0:a302? (p200300ea8f28520069db99aa4dc0a302.dip0.t-ipconnect.de. [2003:ea:8f28:5200:69db:99aa:4dc0:a302])
        by smtp.googlemail.com with ESMTPSA id n6sm11761155wrt.58.2020.05.23.04.23.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2020 04:23:40 -0700 (PDT)
Subject: [PATCH net-next 3/3] r8169: remove mask argument from
 r8168ep_ocp_read
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ba72d0ee-713b-0721-ed50-5dbfe502ffba@gmail.com>
Message-ID: <c366e9aa-30b9-93ab-45dc-a7848cad77b2@gmail.com>
Date:   Sat, 23 May 2020 13:23:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <ba72d0ee-713b-0721-ed50-5dbfe502ffba@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the mask argument as it's not used by r8168ep_ocp_read().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6674ea529..79090aefa 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1098,7 +1098,7 @@ static u32 r8168dp_ocp_read(struct rtl8169_private *tp, u16 reg)
 		RTL_R32(tp, OCPDR) : ~0;
 }
 
-static u32 r8168ep_ocp_read(struct rtl8169_private *tp, u8 mask, u16 reg)
+static u32 r8168ep_ocp_read(struct rtl8169_private *tp, u16 reg)
 {
 	return _rtl_eri_read(tp, reg, ERIAR_OOB);
 }
@@ -1145,7 +1145,7 @@ DECLARE_RTL_COND(rtl_dp_ocp_read_cond)
 
 DECLARE_RTL_COND(rtl_ep_ocp_read_cond)
 {
-	return r8168ep_ocp_read(tp, 0x0f, 0x124) & 0x00000001;
+	return r8168ep_ocp_read(tp, 0x124) & 0x00000001;
 }
 
 DECLARE_RTL_COND(rtl_ocp_tx_cond)
@@ -1170,8 +1170,7 @@ static void rtl8168dp_driver_start(struct rtl8169_private *tp)
 static void rtl8168ep_driver_start(struct rtl8169_private *tp)
 {
 	r8168ep_ocp_write(tp, 0x01, 0x180, OOB_CMD_DRIVER_START);
-	r8168ep_ocp_write(tp, 0x01, 0x30,
-			  r8168ep_ocp_read(tp, 0x01, 0x30) | 0x01);
+	r8168ep_ocp_write(tp, 0x01, 0x30, r8168ep_ocp_read(tp, 0x30) | 0x01);
 	rtl_loop_wait_high(tp, &rtl_ep_ocp_read_cond, 10000, 10);
 }
 
@@ -1202,8 +1201,7 @@ static void rtl8168ep_driver_stop(struct rtl8169_private *tp)
 {
 	rtl8168ep_stop_cmac(tp);
 	r8168ep_ocp_write(tp, 0x01, 0x180, OOB_CMD_DRIVER_STOP);
-	r8168ep_ocp_write(tp, 0x01, 0x30,
-			  r8168ep_ocp_read(tp, 0x01, 0x30) | 0x01);
+	r8168ep_ocp_write(tp, 0x01, 0x30, r8168ep_ocp_read(tp, 0x30) | 0x01);
 	rtl_loop_wait_low(tp, &rtl_ep_ocp_read_cond, 10000, 10);
 }
 
@@ -1233,7 +1231,7 @@ static bool r8168dp_check_dash(struct rtl8169_private *tp)
 
 static bool r8168ep_check_dash(struct rtl8169_private *tp)
 {
-	return !!(r8168ep_ocp_read(tp, 0x0f, 0x128) & 0x00000001);
+	return r8168ep_ocp_read(tp, 0x128) & 0x00000001;
 }
 
 static bool r8168_check_dash(struct rtl8169_private *tp)
-- 
2.26.2


