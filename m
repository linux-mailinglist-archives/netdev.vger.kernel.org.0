Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83836A2BF0
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 22:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjBYVrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 16:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjBYVrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 16:47:49 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0A016AEB
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 13:47:47 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id p26so1964654wmc.4
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 13:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XZ0wcNd8yHxm+yQ6j8mxrrOX8gL8+IfMQlDnuGgN7EQ=;
        b=PRRhPeaLRo2COntuhoue+gn1LYH9gPFd0PZ0KWaDMwkcBhsyAuv1EFlDJMqz9xTbUw
         I8dBAeDCqTcQ8riA/EjAjWflSy+kv/bSXxblk5eM1MBLT8T9tpQfCDRT3moyQRS2DGM5
         e4BmxyQJtBijA2U6SO+OjJ9XOBoZZuHI8eMPKQ5qR3ic7RzhfVHPtA2tWD0+vX3ed7eu
         dhQN93pWskpcNqBKGRTK2fghtpiG8n+GNOqJQ52gjaFRtj9FYcVXrIUduVFU/nWLUFJH
         Di8gwq/D6RE7Z+HDM7EHnUvfbI5KcM9gXt2nfPytMqcqPZuGBB2JqgFbUbfdtEzZVtIo
         OsZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XZ0wcNd8yHxm+yQ6j8mxrrOX8gL8+IfMQlDnuGgN7EQ=;
        b=lGlhSMRrd4978tDKGzZLgfVi3JB1q71gkYq1wKVKGdAJVOAwBYanRsToYhxAIR/YhB
         g2TgM4ATrh2MqfIO/qz0Z6UHYyj/Siy6b/GfcuWA+0vakkeagK/GiT+r7uXOtPdY7QD4
         R1TkLhCJZ8ptC3ntYHdwgN7q+bZw1cWdgolnF5DT1qvQSJS2p8zvCR2Q4i/Ruz3anxwk
         P6rxLq0AzUlrpu9pITOa7XzkxNsCKmAuM34toFA+22Zly1rSc1IM2WpL9c4FQLTdN2/N
         n+zxFN3fWlFzRuAvvTobTFyGWJrBYecqlgvX3K8ruYUHwCuvy69KVJMohCaRhCM+OrTj
         +4cA==
X-Gm-Message-State: AO0yUKWl8FPtBlgQSpCng/TOXhs34nA7MPRZ0st6hm42sQPxgNVOgU/b
        5U0Dm+Zo9IT3uR3vIkS1Wy8=
X-Google-Smtp-Source: AK7set/8HuT70SEC4UVq2RE//M8xp5YFm7W1Kpe/Az26SzxmBuM1hibTZWdbCt1Vn2FKsUAGzij63w==
X-Received: by 2002:a05:600c:ccc:b0:3df:db20:b0ae with SMTP id fk12-20020a05600c0ccc00b003dfdb20b0aemr3130675wmb.17.1677361666086;
        Sat, 25 Feb 2023 13:47:46 -0800 (PST)
Received: from ?IPV6:2a01:c22:7715:8b00:51a3:9e62:de37:8c49? (dynamic-2a01-0c22-7715-8b00-51a3-9e62-de37-8c49.c22.pool.telefonica.de. [2a01:c22:7715:8b00:51a3:9e62:de37:8c49])
        by smtp.googlemail.com with ESMTPSA id p13-20020a1c544d000000b003e208cec49bsm13324759wmi.3.2023.02.25.13.47.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 13:47:45 -0800 (PST)
Message-ID: <a21451a7-dce8-7647-fed3-7615aaa64c9f@gmail.com>
Date:   Sat, 25 Feb 2023 22:46:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: [PATCH RFC 4/6] r8169: prepare rtl_hw_aspm_clkreq_enable for usage in
 atomic context
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <af076f1f-a034-82e5-8f76-f3ec32a14eaa@gmail.com>
In-Reply-To: <af076f1f-a034-82e5-8f76-f3ec32a14eaa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bail out if the function is used with chip versions that don't support
ASPM configuration. In addition remove the delay, it tuned out that
it's not needed, also vendor driver r8125 doesn't have it.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 61cbf498f..96af31aea 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2741,6 +2741,9 @@ static void rtl_disable_exit_l1(struct rtl8169_private *tp)
 
 static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 {
+	if (tp->mac_version < RTL_GIGA_MAC_VER_32)
+		return;
+
 	/* Don't enable ASPM in the chip if OS can't control ASPM */
 	if (enable && tp->aspm_manageable) {
 		rtl_mod_config5(tp, 0, ASPM_en);
@@ -2770,8 +2773,6 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 		rtl_mod_config2(tp, ClkReqEn, 0);
 		rtl_mod_config5(tp, ASPM_en, 0);
 	}
-
-	udelay(10);
 }
 
 static void rtl_set_fifo_size(struct rtl8169_private *tp, u16 rx_stat,
-- 
2.39.2


