Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AE96D38C0
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 17:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbjDBPSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 11:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjDBPS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 11:18:28 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C08DDBC8
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 08:18:23 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id er13so66935599edb.9
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 08:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680448703;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FHt3FWLjHDC9hshm9BOf8mHp4Hkxi+Xn48pQS9ShfZE=;
        b=lSqTgViQ0PHr1p5uHtQu18Jgoi4ztIxy4WlUFPn8doIpwmjdbw4U1ZmmnR1u3h9kLK
         BwQMlQ5C+nuVB+O9jWPFd9Ruxq+BVUUH3OV5zLXF0hdIRqDINWMG1EChjneJyJgv4dUT
         EqsJ0GQfNvte7yWdt+zBp1l1l5d8AZqhZixMakeOERAjsmBu1ss5Y8NcIreBJiQafIvw
         L3pX5Zy3S3iJVABSbseWr1GiSvkm44N/UQdsw6hCOdZLFVH9H4XFei3DowRULQ0LaSHX
         460W3TAQyScTKBTkm4kst+JHHUopCwD3SmMQKYSwOO0ZjY+TWxgutZ+KoJbK8fMbeFlj
         +5dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680448703;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FHt3FWLjHDC9hshm9BOf8mHp4Hkxi+Xn48pQS9ShfZE=;
        b=VkY6ZJkx2TqcSMjeC3i6m/V+Vap9vMyS3hWbZGnyQ7zpMOCNOyj6MV288V6A9KglxR
         EUsWt0GkZCRPXiyrZBM5Tew9ghYDM0HGSksT5Ogy/VuFq5wu+rDjg/4pBXwsBWJQXOct
         N97PMFed9MZpXXFqCxBz9sOUImN1LzvRQehjbXcCISzcDiKrBL/yc0JxA53pS+IG6qLA
         KbAmoXL0bjARc0s01z0uYiifnElqQy3pDlU3RtjfpcVmXXsK7qIqXI4ySbjJG1ynC5Yn
         RTvg9/kYvgSXRueLJTX0VHVYw7DMFNw6AotrSbWPs0PV8hLS7H7Jb2hDOB0+MPfIO/VU
         aGwQ==
X-Gm-Message-State: AAQBX9dCCgE9oMA66N2O10bY4WSAZ+mb+EMyBIvWVXENI6t6JLMN4hp5
        UjQna3Rz3CZOPIcnVYohyRs=
X-Google-Smtp-Source: AKy350aWQVLljdUCbiEp1xniGevQ9h3WauJDs6aGlgyhiXr/M7tswNf44sY5A+/uxJ0gcpI0QDNa1Q==
X-Received: by 2002:aa7:c1d7:0:b0:4fa:ba31:6c66 with SMTP id d23-20020aa7c1d7000000b004faba316c66mr31403047edp.42.1680448703533;
        Sun, 02 Apr 2023 08:18:23 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b85:6800:129:5577:2076:7bf8? (dynamic-2a01-0c22-7b85-6800-0129-5577-2076-7bf8.c22.pool.telefonica.de. [2a01:c22:7b85:6800:129:5577:2076:7bf8])
        by smtp.googlemail.com with ESMTPSA id n19-20020a509353000000b004c09527d62dsm3410553eda.30.2023.04.02.08.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 08:18:23 -0700 (PDT)
Message-ID: <d78e0ee3-55b2-e2bd-c9f4-b8a88f31366b@gmail.com>
Date:   Sun, 2 Apr 2023 17:17:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: [PATCH net-next v2 7/7] net: phy: smsc: enable edpd tunable support
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Healy <cphealy@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d0e999eb-d148-a5c1-df03-9b4522b9f2fd@gmail.com>
In-Reply-To: <d0e999eb-d148-a5c1-df03-9b4522b9f2fd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable EDPD PHY tunable support for all drivers using
lan87xx_read_status.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 0eba69ad5..692930750 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -469,6 +469,9 @@ static struct phy_driver smsc_phy_driver[] = {
 	.get_strings	= smsc_get_strings,
 	.get_stats	= smsc_get_stats,
 
+	.get_tunable	= smsc_phy_get_tunable,
+	.set_tunable	= smsc_phy_set_tunable,
+
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
@@ -513,6 +516,9 @@ static struct phy_driver smsc_phy_driver[] = {
 	.get_strings	= smsc_get_strings,
 	.get_stats	= smsc_get_stats,
 
+	.get_tunable	= smsc_phy_get_tunable,
+	.set_tunable	= smsc_phy_set_tunable,
+
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
@@ -539,6 +545,9 @@ static struct phy_driver smsc_phy_driver[] = {
 	.get_strings	= smsc_get_strings,
 	.get_stats	= smsc_get_stats,
 
+	.get_tunable	= smsc_phy_get_tunable,
+	.set_tunable	= smsc_phy_set_tunable,
+
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
@@ -569,6 +578,9 @@ static struct phy_driver smsc_phy_driver[] = {
 	.get_strings	= smsc_get_strings,
 	.get_stats	= smsc_get_stats,
 
+	.get_tunable	= smsc_phy_get_tunable,
+	.set_tunable	= smsc_phy_set_tunable,
+
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 } };
-- 
2.40.0


