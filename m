Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C804D205A
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 19:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344067AbiCHSoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 13:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349178AbiCHSoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 13:44:01 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD14EBAD
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 10:43:03 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id k8-20020a05600c1c8800b003899c7ac55dso1583936wms.1
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 10:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=WPSR5Pt5CyT3sNl2ngwE6qDTVKse5DLOw/U1LDqYMBg=;
        b=W5xLQ/VvKJrQobnASIqIOUeXdu5LvZwL5CZjqip4x2czfPRBmOOle2igTyF5q/P1To
         2Vpat+WamBy8TV67fwXu7DU39Ep47pZUdfCydEmv7JuoS5Gqk+2nz8aya3/ApMuxGLCa
         dYQ3zrlqVzgc236yc2n/vObRV69OiMI0UWJ1CyjIh521pB0+iCZ5VcPPp5kQ7wcU2Ex+
         JcqSx62AmINDi5urIeW1xz4R5+KUvgqtbQEpksKX+PICypBSXf0SYdFQ816hakCpJA7W
         tLGZ+NGP1UbsPG4jbqZygA0VO0RXBTrexH5o0mAj5Rk+/y/l9VMsggXKCMoasthupgVY
         RKUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=WPSR5Pt5CyT3sNl2ngwE6qDTVKse5DLOw/U1LDqYMBg=;
        b=SqYVXN9vLNlkz9AnMm9lwfq4BK5W97JyqIFfHe4+X9tPVoscmJKfVaJ5/SqwTDG+mW
         q1racgeH1DQzlMvcmf22Ildmc6TLwXLP+SVDxZN0aJI3cchv+3fOGo4YCPk00Nm+tnul
         zfIabY1OPAqAGnetWJKfQi3IIqSWMPqCFN2u9a4vpTVe/eY80uJGiY5LVnn+yr6ibtQV
         hG3QCMdBtx6ErOZnLlmugp4B+hBRqSt34bjaBOwd9qlSiOXH+iWmduM3mw0STDgWPPeN
         DHX/QrcNmdhv3fuID+GhwGLMrRTC76pAUQkC2qjAbTdiK2V4YWfDh4h4r/0sSUd6VNEA
         8fVw==
X-Gm-Message-State: AOAM530tuafODuaZCsL3tDDb0/d5PjtXVzW1REGSLLLd631yDLBq49eP
        Il2NpfELIPKazRNlrzkiSos=
X-Google-Smtp-Source: ABdhPJwssyolF7w+4CyCS2TboMQECwBl9var3nzNWRK0sQ7ZDQ+b8NMYecp6FwF72IxyBfDn1//wVQ==
X-Received: by 2002:a05:600c:4ec7:b0:389:bf36:ce3a with SMTP id g7-20020a05600c4ec700b00389bf36ce3amr509566wmq.118.1646764982229;
        Tue, 08 Mar 2022 10:43:02 -0800 (PST)
Received: from ?IPV6:2a01:c22:7b54:500:3175:f9ac:af86:a778? (dynamic-2a01-0c22-7b54-0500-3175-f9ac-af86-a778.c22.pool.telefonica.de. [2a01:c22:7b54:500:3175:f9ac:af86:a778])
        by smtp.googlemail.com with ESMTPSA id p2-20020a1c7402000000b0038159076d30sm2906185wmc.22.2022.03.08.10.43.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 10:43:01 -0800 (PST)
Message-ID: <ee685745-f1ab-e9bf-f20e-077d55dff441@gmail.com>
Date:   Tue, 8 Mar 2022 19:42:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: stmmac: switch no PTP HW support message to
 info level
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If HW doesn't support PTP, then it doesn't support it. This is neither
a problem nor can the user do something about it. Therefore change the
message level to info.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index cf4e077d2..c1bfd89a5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3275,7 +3275,7 @@ static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 
 	ret = stmmac_init_ptp(priv);
 	if (ret == -EOPNOTSUPP)
-		netdev_warn(priv->dev, "PTP not supported by HW\n");
+		netdev_info(priv->dev, "PTP not supported by HW\n");
 	else if (ret)
 		netdev_warn(priv->dev, "PTP init failed\n");
 	else if (ptp_register)
-- 
2.35.1

