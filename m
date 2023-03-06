Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9939D6AD0DB
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjCFVwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCFVwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:52:00 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2406A1C2
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 13:51:44 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id x3so44658611edb.10
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 13:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678139503;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XSyFQUQStI3uYWc7w52pTDITGMYk+1A6xzE6MaVuQZk=;
        b=EYCcmcQd5bOr2S0oVJxK7x9HSYELuQCI8HZfnDK/kUMj1ss7coS5uYu6se7VbfcSn/
         WjSZzGh/tmb8OxZ2YEN8kaig1IvDWSgSRPYBJkekVJuSiT3a5KfMYN1Pjr/tihQKWVQ4
         uIgUvIGARRI3eKvCjfrevB+o18+kZSq8QGxecLiJyCR0BUSOI642Ne2b2/86NULXZ5AG
         Y8wMTiDC1hRl/ir/5cofehk46SdT1lZB1MKw2cJ9C223EEK9ZtRG2H4DPKilYuD2rdB9
         6D9uPshINx8+61CN78IH1L8nWVdnCGPFla8ux19oHqpy+02rmqMBWOblPE09WghSgAby
         NLwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678139503;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XSyFQUQStI3uYWc7w52pTDITGMYk+1A6xzE6MaVuQZk=;
        b=In3rrI7oLPlm+md5jphsAa9Bz6loSBj9r7JLV8TBWehUzvlfTaeEss4SuOCmsiD6pL
         Jo2IA+qiSQlXrLpZBz4gJjqoU1nfADdae+v+GEdpebkEAjQQIZyUYn+XzjW55UaTth4F
         ykX4mHcZn09WfO3JoFvyM0/gYKtgYl0ci/PhrW8QGbeIfu4XWhc+oLbJH9HIp1s0ew4u
         PE3f6wyvtnIetjN5yDoEvXn6W9ctKh2BxJJ9kD7QKLf9Mqu/QTS5gdNPKnFO7yGGTITg
         eOTTKFhJw9y6xUZq+UCApNxReKNwpU7uq1Mat6XlJLf7bGdnQBrsRexAczvm6AbVf9nC
         ug4A==
X-Gm-Message-State: AO0yUKWvUhhu2rpLSBw0ziHYM9jktJu2FlMYHLferbBGrpansubeW7bs
        VByUmx0wld3F+lwklXaDNQZFNBugMYg=
X-Google-Smtp-Source: AK7set/iBG7SHBHB9vvg1RzjGaMVs5FoPc4YCuUyoP+slPWZoSI4RRw3nf+7LbnSRJYyJfT7d3Owtw==
X-Received: by 2002:a05:6402:1655:b0:4bf:c590:3c4e with SMTP id s21-20020a056402165500b004bfc5903c4emr11748691edx.4.1678139502681;
        Mon, 06 Mar 2023 13:51:42 -0800 (PST)
Received: from ?IPV6:2a01:c22:7bf4:7d00:9590:4142:18ea:aa32? (dynamic-2a01-0c22-7bf4-7d00-9590-4142-18ea-aa32.c22.pool.telefonica.de. [2a01:c22:7bf4:7d00:9590:4142:18ea:aa32])
        by smtp.googlemail.com with ESMTPSA id d17-20020a50f691000000b004c0cc79f4aesm5669171edn.92.2023.03.06.13.51.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 13:51:42 -0800 (PST)
Message-ID: <6d8274ac-4344-23b4-d9a3-cad4c39517d4@gmail.com>
Date:   Mon, 6 Mar 2023 22:51:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: improve phy_read_poll_timeout
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

cond sometimes is (val & MASK) what may result in a false positive
if val is a negative errno. We shouldn't evaluate cond if val < 0.
This has no functional impact here, but it's not nice.
Therefore switch order of the checks.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/linux/phy.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 36bf0bbc8..fefd5091b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1130,16 +1130,15 @@ static inline int phy_read(struct phy_device *phydev, u32 regnum)
 #define phy_read_poll_timeout(phydev, regnum, val, cond, sleep_us, \
 				timeout_us, sleep_before_read) \
 ({ \
-	int __ret = read_poll_timeout(phy_read, val, (cond) || val < 0, \
+	int __ret = read_poll_timeout(phy_read, val, val < 0 || (cond), \
 		sleep_us, timeout_us, sleep_before_read, phydev, regnum); \
-	if (val <  0) \
+	if (val < 0) \
 		__ret = val; \
 	if (__ret) \
 		phydev_err(phydev, "%s failed: %d\n", __func__, __ret); \
 	__ret; \
 })
 
-
 /**
  * __phy_read - convenience function for reading a given PHY register
  * @phydev: the phy_device struct
-- 
2.39.2

