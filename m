Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEDE6AD049
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjCFV25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjCFV2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:28:53 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C58A474DA
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 13:28:32 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id fm20-20020a05600c0c1400b003ead37e6588so9139751wmb.5
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 13:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678138111;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=soPTZuxKkPs8F671BDUXDGY7ntnppFcO4XnsaBkc22I=;
        b=M3Pqeo7qCHCdt2exp003r44xWg4XvxyrzpSQB9izPqkIvU7x1m1Bi1aktzUG3nv2Xz
         To9ukeu0kZ8yE79daSmdC1unYGnokn2/wKEY9DmvGjqAbF88dcqvqTl3141mRmpca3Lu
         RnUqnzkDfa4czqWNwUKLfxBw1Z1tMOeqb5WtkRFvZR3qODBOwU9Iv8AILJnug6EHFHxA
         7qhGIhBMkTuohAWyPmNcqKsBY7GMYEwvj3KvdZ0Gk/YM8cAOemfkCah1Yx1xL/+YX6BG
         74lPY/502PgD1CXPLy0+bqQ0g2VwmIOHmz3n5PbJo+5Fjg9z6c+8QXkBJTmkwvv6PueJ
         sHcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678138111;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=soPTZuxKkPs8F671BDUXDGY7ntnppFcO4XnsaBkc22I=;
        b=uyNO09+NPI71OgDdTHxbqlESSFyoEoTuBqgKETF0txeygwkEc+80fxZuKPEJgxcKyy
         dEr7aA5ZGb3bglJ8EOWiR0oNgW/v+XCsvC0p4W45CyYqDST7DAgAFCXfrAezjGC7WIAD
         CPSTtPDbnaKZQDMGUcT4W911m0MhJ+iiDvXYggGvT4/o3RV1KfuojJxjGv62Abum+gjf
         0GvIr+xxYKQweq4UITBxA0ApnMeNeFqrC0LIt+kWwmq0P17ak4SmzHxYcbsqh4QqQ4YW
         ZzTcX6b09FZdMpHxYTzg3n7t5JuqYOzVA+l7f0LoK3GRjwOewdyzZHqy2iwlNofWU6Be
         X4zQ==
X-Gm-Message-State: AO0yUKVUX08NIZUzdrFwgYH8PtBJXQxtAghRcqOUjGTo7YAxtdQ2Bd41
        TT3NkbyaThVgZqVDTp4s/XfOtLZXdEc=
X-Google-Smtp-Source: AK7set9tSV5ePU4+bZh11wdi5N1u2vtLUzAItzLXEQ7c2ImZRcOLir5F1qz4HYhUqa+4dwdM/8fRnQ==
X-Received: by 2002:a05:600c:3ca3:b0:3db:8de:6993 with SMTP id bg35-20020a05600c3ca300b003db08de6993mr8456246wmb.4.1678138110871;
        Mon, 06 Mar 2023 13:28:30 -0800 (PST)
Received: from ?IPV6:2a01:c22:7bf4:7d00:9590:4142:18ea:aa32? (dynamic-2a01-0c22-7bf4-7d00-9590-4142-18ea-aa32.c22.pool.telefonica.de. [2a01:c22:7bf4:7d00:9590:4142:18ea:aa32])
        by smtp.googlemail.com with ESMTPSA id h22-20020a05600c351600b003daf6e3bc2fsm22119735wmq.1.2023.03.06.13.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 13:28:30 -0800 (PST)
Message-ID: <eacc78aa-d2ad-2db5-e41d-e7852c7b170b@gmail.com>
Date:   Mon, 6 Mar 2023 22:26:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: [PATCH net-next 5/6] r8169: disable ASPM during NAPI poll
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

Several chip versions have problems with ASPM, what may result in
rx_missed errors or tx timeouts. The root cause isn't known but
experience shows that disabling ASPM during NAPI poll can avoid
these problems.

Suggested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 96af31aea..2897b9bf2 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4577,6 +4577,10 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 	}
 
 	if (napi_schedule_prep(&tp->napi)) {
+		rtl_unlock_config_regs(tp);
+		rtl_hw_aspm_clkreq_enable(tp, false);
+		rtl_lock_config_regs(tp);
+
 		rtl_irq_disable(tp);
 		__napi_schedule(&tp->napi);
 	}
@@ -4636,9 +4640,14 @@ static int rtl8169_poll(struct napi_struct *napi, int budget)
 
 	work_done = rtl_rx(dev, tp, budget);
 
-	if (work_done < budget && napi_complete_done(napi, work_done))
+	if (work_done < budget && napi_complete_done(napi, work_done)) {
 		rtl_irq_enable(tp);
 
+		rtl_unlock_config_regs(tp);
+		rtl_hw_aspm_clkreq_enable(tp, true);
+		rtl_lock_config_regs(tp);
+	}
+
 	return work_done;
 }
 
-- 
2.39.2



