Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151B66C83C6
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbjCXRwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjCXRwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:52:14 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34924CDD3;
        Fri, 24 Mar 2023 10:51:50 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id n2so2227891qtp.0;
        Fri, 24 Mar 2023 10:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679680307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PuV3IriHAW7aZC8rFN25zhcR9dc8l3Vh+GPx6NtpMpU=;
        b=eRtC81NEQErSKAXM26X0ZVcHMgVlSXptqsLo2uzPa5TVXpleoAySQirq87pHRV45tp
         qhk7ybka5bI+FSZDmoM9luXnUusiHRVXtNiZDaa9c/qAKKoY5AM+UxHMqIFu1WBaF3ig
         zlGXH2dtZixOq4IsBr+FIkJ5B5HrocEnaGb2kfDOHVzVsOpTk2r+hYWrWSVHTQjKYnaL
         NKVjBJIvOM2YONGm+6vA9JTRdgDJMkpZfz99oSUJPpdIZfkviYUyL3o3Gf68j4QpRdhM
         9uiGucM9E+Cx+jzN5pEJV8pnMytFoMvCOEitO056sfXELl/KJ9xvVE2x5Wr+3BysQRLo
         WV9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679680307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PuV3IriHAW7aZC8rFN25zhcR9dc8l3Vh+GPx6NtpMpU=;
        b=KMCBKb2FdH6GWwfVmMjSaE8ka56mrZl9g120gvIUuG41+Hbrm+sWXG5t729zdMeUpT
         JY7LULIEiaJk6FPYyR06jEUbBP44tE6hX4Xe0k0lYiI9weoLZiV6vdDWXzw8cn54Xyml
         BTHkZK1tuy0tFkHc1jCa5HJxEaHVm5rvZM/LbrIehvnZ89gMG3UWTvfDByyqSLeIUNs5
         y23yDmQ5CExrGZoe2sLDKjWZ3Y8hUjjULrFbLk7Q7/D5nAImbLzbLzHigMbkiN6Q54Al
         cXfsBMk5BcLN+woXEZ+Ukr3ARzZ9qVD5l+kt0jFLn4lamIjWxQ66Meq3J+bv61JD0FDA
         6Jgw==
X-Gm-Message-State: AO0yUKXdUXuCk3SWbnuaJinhRmklzo1de92uMRTi5K4VfNmwVnKNqgwD
        0jUrzPx62q0i9fl2W0f68Ue7PPcLuXMGqQ==
X-Google-Smtp-Source: AK7set+r8l/F2yXLaXu5mH+cnXIvEz7HmBX4IEYNffVIBg2BQhTHV3haOyGSS/io9TY7B/4tpSVCWQ==
X-Received: by 2002:ac8:5802:0:b0:3db:fba6:53f8 with SMTP id g2-20020ac85802000000b003dbfba653f8mr6667662qtg.25.1679680307357;
        Fri, 24 Mar 2023 10:51:47 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id bk12-20020a05620a1a0c00b0074357a6529asm14512289qkb.105.2023.03.24.10.51.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 10:51:46 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v4 08/10] net: sunhme: Clean up mac address init
Date:   Fri, 24 Mar 2023 13:51:34 -0400
Message-Id: <20230324175136.321588-9-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230324175136.321588-1-seanga2@gmail.com>
References: <20230324175136.321588-1-seanga2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up some oddities suggested during review.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---

(no changes since v2)

Changes in v2:
- New

 drivers/net/ethernet/sun/sunhme.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 4fe67623b924..b51b8930bef1 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2348,9 +2348,7 @@ static int find_eth_addr_in_vpd(void __iomem *rom_base, int len, int index, unsi
 		p += 6;
 
 		if (index == 0) {
-			int i;
-
-			for (i = 0; i < 6; i++)
+			for (int i = 0; i < 6; i++)
 				dev_addr[i] = readb(p + i);
 			return 1;
 		}
@@ -2362,9 +2360,10 @@ static int find_eth_addr_in_vpd(void __iomem *rom_base, int len, int index, unsi
 static void __maybe_unused get_hme_mac_nonsparc(struct pci_dev *pdev,
 						unsigned char *dev_addr)
 {
+	void __iomem *p;
 	size_t size;
-	void __iomem *p = pci_map_rom(pdev, &size);
 
+	p = pci_map_rom(pdev, &size);
 	if (p) {
 		int index = 0;
 		int found;
@@ -2386,7 +2385,7 @@ static void __maybe_unused get_hme_mac_nonsparc(struct pci_dev *pdev,
 	dev_addr[2] = 0x20;
 	get_random_bytes(&dev_addr[3], 3);
 }
-#endif /* !(CONFIG_SPARC) */
+#endif
 
 static void happy_meal_addr_init(struct happy_meal *hp,
 				 struct device_node *dp, int qfe_slot)
-- 
2.37.1

