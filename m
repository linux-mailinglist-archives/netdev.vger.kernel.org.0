Return-Path: <netdev+bounces-11429-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 611657330FD
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:18:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 807681C20F5E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A61A19915;
	Fri, 16 Jun 2023 12:18:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C427BA23
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 12:18:15 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D6B30DE
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:18:13 -0700 (PDT)
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A30553F120
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 12:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686917890;
	bh=soiKTuNI2szr+B3DMv/HAX9nLtIBEiY4szgRtPOrfZw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=JXcYAdLaAV/oPZuyO0OvgdflLlZQpKFsff3mxithdfqthvrae5VgqqJ07S+NLz6wj
	 iyROW9JyNVh7AZNjfYiHbtgiPlgruiQRH2G10rkzAV25FKL8LB+cl/+TYVzRDUUJVF
	 GU435JqfLruHu4OhjlO78iAzT9AGpg2ABBdauMlOFECEecF43kUgxq1AocjjgcD9BT
	 ffYfQnWpFq/GAlNSeW4oJvbIMmlsGQH5elaw/ZbZDwbL0UkQZ8xFCwR4Xzv7ZRrY9f
	 cKv69zJUEqr5eJ1kxuIL0Ixy5Bp7lJ7widVmR/l9nQ2Wwt3pYBKSubni5ajLwBRR8i
	 QPBLpSfjU4rrw==
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4f84a8b00e3so558299e87.0
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:18:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686917890; x=1689509890;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=soiKTuNI2szr+B3DMv/HAX9nLtIBEiY4szgRtPOrfZw=;
        b=iqRt/RdcbMUapLViC5AfRvllckmuvmdTWsWgH2POkD8OkwliMfUf4yB0GTl83zRP3c
         7S5mfWuoyItEdJyEPgJ47Gk+Mk6g+W5IJ1vVOfIssY2gC7NdBr3a1l/K6HSKO1BD0TFv
         RP4/nEdeg8F2gdZLpfyqLRFcHYuuTrnfLGF7GZh7bMXTklrtivWWAaExzuV4ClV9LPmX
         Kgk8SIyuUJargBxF9Vuncrf2WHBV22fTpC0Zk7dQUCvRqHjSXD3Ev6l3GDEOpk2wUxY1
         SeF1tAtqy+z2ixoZH8jz3TVxuGe0gvDYZA5qXQ5FhprtmIJ4nFAYVpaI63mLwmpQen1m
         SFVA==
X-Gm-Message-State: AC+VfDwDc1DNRkCe3muQhnZCNCLYSQkEKqTnE0eFBsXiYUx77fr39ghE
	zmFQqKX0faeVtp0XydNybbPoPZiUyP7b7HTeu/rkTU96sba1APY0p18WWgwc28OAC/uP1mwOZ1b
	6i+qUlV20ia01RMgOpNfzSOukYw1Uy2dzCQ==
X-Received: by 2002:a19:e308:0:b0:4f8:4673:26ca with SMTP id a8-20020a19e308000000b004f8467326camr1292301lfh.47.1686917890090;
        Fri, 16 Jun 2023 05:18:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4/crAkK52hQhs4lvyn5+P+QYCK7oaPxGTbDvwaNgwbMhqTFQaK3EOu886oH2s+W1wZI3bZJg==
X-Received: by 2002:a19:e308:0:b0:4f8:4673:26ca with SMTP id a8-20020a19e308000000b004f8467326camr1292275lfh.47.1686917889721;
        Fri, 16 Jun 2023 05:18:09 -0700 (PDT)
Received: from localhost ([194.191.244.86])
        by smtp.gmail.com with ESMTPSA id 17-20020a05600c229100b003f7ff6b1201sm2045217wmf.29.2023.06.16.05.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 05:18:09 -0700 (PDT)
From: Juerg Haefliger <juerg.haefliger@canonical.com>
To: michael.hennerich@analog.com,
	alex.aring@gmail.com,
	stefan@datenfreihafen.org,
	miquel.raynal@bootlin.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-wpan@vger.kernel.org,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Juerg Haefliger <juerg.haefliger@canonical.com>
Subject: [PATCH] ieee802154/adf7242: Add MODULE_FIRMWARE macro
Date: Fri, 16 Jun 2023 14:18:07 +0200
Message-Id: <20230616121807.1034050-1-juerg.haefliger@canonical.com>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The module loads firmware so add a MODULE_FIRMWARE macro to provide that
information via modinfo.

Signed-off-by: Juerg Haefliger <juerg.haefliger@canonical.com>
---
 drivers/net/ieee802154/adf7242.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ieee802154/adf7242.c b/drivers/net/ieee802154/adf7242.c
index f9972b8140f9..a03490ba2e5b 100644
--- a/drivers/net/ieee802154/adf7242.c
+++ b/drivers/net/ieee802154/adf7242.c
@@ -1348,3 +1348,5 @@ module_spi_driver(adf7242_driver);
 MODULE_AUTHOR("Michael Hennerich <michael.hennerich@analog.com>");
 MODULE_DESCRIPTION("ADF7242 IEEE802.15.4 Transceiver Driver");
 MODULE_LICENSE("GPL");
+
+MODULE_FIRMWARE(FIRMWARE);
-- 
2.37.2


