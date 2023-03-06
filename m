Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEACE6AD047
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCFV24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjCFV2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:28:51 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2127974A5C
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 13:28:31 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id j2so10247587wrh.9
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 13:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678138109;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N9UWUbGKmEfF/ZCXlYPSs/b8L+hGvY0HicAyB0cfmWU=;
        b=BYUFh8zHKx8f5y4lhD9gTznGbsjDjKaDVNQ4WTJ7VJpfyyY3mq7Mk07SWm977U6K7I
         LeFmZN5Izi/UIkNPqcizimSUj5nU/FGi4xLCn6+L1dAtkqxQPB5ehVdy54KZMbshmD/B
         hVouzprxv5za+KoQMjVDIU1I8aws3Poy/mV2hVeScEgXE+udBwIkdRChTodSwkUcJVbD
         TPpdIGLU/ZNZOTAYbEpLMO4W/yfRSBvk6Tac1dSYn+ZgiKNTGO370GqTnD5H4Ftr8xqf
         yqHoZ/aT6Bttn3PZIazCt+DDevzNIo0Ecvcy+zeupzJ7ni9BQtqyvXJWkd4T9IDFdG22
         llmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678138109;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N9UWUbGKmEfF/ZCXlYPSs/b8L+hGvY0HicAyB0cfmWU=;
        b=idonVMRzcElZY/oXYqxy3zSIrsUj3IntwnhEvzllro/H1zPNMFBzZOITry+D+is7fV
         B/aKDNcF0qKqUSehj5cq3pRsC6kD2kDl8KQwhmfJFMgQvxHwWEubNb1TuGj595tx9y33
         IqDeA0XaUHoeUj2BhoPtNKTCmc1e8xYD+uF7oVfU6pdLL/omIBof0ImxyLV59Eb1eyv7
         A2JMru02owk2MAyjkZjkvCPD7OIt0gve+PAxeJi19iOryNdSS1CsWFFGUX4Wwh//IrrQ
         thFCs5+1RnkzI5xKWiIxyMAdABVmd/m+PEa7rOXXjWTtcGzbOlrc/69dJiq5QH0Pr1Li
         hllA==
X-Gm-Message-State: AO0yUKVB5qz6elrDCJPDxoXHdSO4R/vIEmFtaDpzT/b4j1DGlYR176IA
        vwRxao/pnWWdL9figibi/1Y=
X-Google-Smtp-Source: AK7set+suNpvmhZSG0PB+ahcd+KowARy5hF8e4NeYqAYUGWfMTGxGpCMyRtU+3lsVfSxQpB3rzYWeg==
X-Received: by 2002:adf:e585:0:b0:2c7:1e52:c5a8 with SMTP id l5-20020adfe585000000b002c71e52c5a8mr7757910wrm.21.1678138109495;
        Mon, 06 Mar 2023 13:28:29 -0800 (PST)
Received: from ?IPV6:2a01:c22:7bf4:7d00:9590:4142:18ea:aa32? (dynamic-2a01-0c22-7bf4-7d00-9590-4142-18ea-aa32.c22.pool.telefonica.de. [2a01:c22:7bf4:7d00:9590:4142:18ea:aa32])
        by smtp.googlemail.com with ESMTPSA id c12-20020a5d63cc000000b002c5801aa9b0sm10888506wrw.40.2023.03.06.13.28.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 13:28:29 -0800 (PST)
Message-ID: <acf3615b-e9c5-ccb6-65b2-885e86d74b7e@gmail.com>
Date:   Mon, 6 Mar 2023 22:25:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: [PATCH net-next 4/6] r8169: prepare rtl_hw_aspm_clkreq_enable for
 usage in atomic context
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
References: <b434a0ce-9a76-e227-3267-ee26497ec446@gmail.com>
In-Reply-To: <b434a0ce-9a76-e227-3267-ee26497ec446@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

Suggested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
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



