Return-Path: <netdev+bounces-11432-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9079733110
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:22:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9FB51C20B1D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 148D519924;
	Fri, 16 Jun 2023 12:22:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0901A18AE8
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 12:22:23 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C230B30DD
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:22:22 -0700 (PDT)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 682B33F04C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 12:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686918141;
	bh=zw1VmnyGgP9Z0XT+cVN9mnOntivZi1r272LyKdlNy7g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=RIJNmJNTJGsGBEUUh6kft2PO2UUoeSN+hEuO41fYKU9WR2SLgTviKxk95QvwDFzCw
	 ooIUmY6BhQLcAR9ySnoI1iBGgfwgj82oNBrqMq70UadcJz06nq+t4NCTvBsaQxWXRX
	 4FuE7WUmu6pCz6sGZpR2+WufYIbTxlFXKq6dlrsCWWZ9u8TIPhS/LY9uRQMSg8o0dl
	 7bVHs/Z+o2OYFs4e0SWDbOdIFsMyImdUfjLKv5hTpQ1+QkySK7Mkx+qxyyMUy3eA7i
	 q58OAQX7tbR8NAiiRsR11ov//bTuwl3M+50KzoQCGn9GMlkQ2Jhy4wjqUJFVL/Sn2b
	 StQKy1QFHAc5Q==
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f8fa2ef407so1500685e9.1
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:22:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686918141; x=1689510141;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zw1VmnyGgP9Z0XT+cVN9mnOntivZi1r272LyKdlNy7g=;
        b=hwuKprPw4kRfkh9VBGf+8e7k+vEARgrrpR2TcWY+KnfXpYvoq9MFwqGZPupIsulgKz
         wMLirZTXrW1BlDjb8USB3tnRoXPorenTNgXrwKkaREh67vOh7pXJaNhNGgnQCP6QHAmW
         bTJq1Usawtmwe3czP/082TaHs6ENprgFWu1s2fAAHz9ext8YXy2Krsk7AF3USgt3yqjZ
         hPBdG5iyHhaeJE9ZIoQ3xnL4vHi3BEZkmnPqOJBZ2QlDiWkb6qTU5Uokk3nq9JvAhzfX
         TvVGhqfGIctkqLiNYr69jIDwvKgvVqQX2UCHR9tUR13IH0blQqupJKYCdu3SzNs+2bX8
         foEg==
X-Gm-Message-State: AC+VfDyFq1M+ZxDH0r4tL333TRWxOf8+YZlJtkDOmtfs3TS1fMCxTTnv
	pvZNENNVd/6+du9YmjrmQkpMuNXS5xnfTg0tS7KardW+0TbN3EcEK2Po63VbHY+IsgIUketukFb
	C7ksUBKNMgEk/7cZ164KpqxNPxAB1cT5o0w==
X-Received: by 2002:a05:600c:2189:b0:3f6:7e6:44ea with SMTP id e9-20020a05600c218900b003f607e644eamr1430106wme.18.1686918141173;
        Fri, 16 Jun 2023 05:22:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5rBUPHGh+Xrw+/lwEv6Boc48lL+634iJofytBHc16kHMsIMMUVbLAnK1MqG7zZ49WoCqz1ww==
X-Received: by 2002:a05:600c:2189:b0:3f6:7e6:44ea with SMTP id e9-20020a05600c218900b003f607e644eamr1430100wme.18.1686918140883;
        Fri, 16 Jun 2023 05:22:20 -0700 (PDT)
Received: from localhost ([194.191.244.86])
        by smtp.gmail.com with ESMTPSA id i1-20020adff301000000b002f28de9f73bsm23571315wro.55.2023.06.16.05.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 05:22:20 -0700 (PDT)
From: Juerg Haefliger <juerg.haefliger@canonical.com>
To: krzysztof.kozlowski@linaro.org,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	davem@davemloft.net,
	shangxiaojing@huawei.com,
	juerg.haefliger@canonical.com
Subject: [PATCH] nfc: fdp: Add MODULE_FIRMWARE macros
Date: Fri, 16 Jun 2023 14:22:18 +0200
Message-Id: <20230616122218.1036256-1-juerg.haefliger@canonical.com>
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

The module loads firmware so add MODULE_FIRMWARE macros to provide that
information via modinfo.

Signed-off-by: Juerg Haefliger <juerg.haefliger@canonical.com>
---
 drivers/nfc/fdp/fdp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index f12f903a9dd1..da3e2dce8e70 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -762,3 +762,6 @@ EXPORT_SYMBOL(fdp_nci_remove);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("NFC NCI driver for Intel Fields Peak NFC controller");
 MODULE_AUTHOR("Robert Dolca <robert.dolca@intel.com>");
+
+MODULE_FIRMWARE(FDP_OTP_PATCH_NAME);
+MODULE_FIRMWARE(FDP_RAM_PATCH_NAME);
-- 
2.37.2


