Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959136B8707
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjCNAhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjCNAgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:36:47 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA948C592;
        Mon, 13 Mar 2023 17:36:24 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id m6so421617qvq.0;
        Mon, 13 Mar 2023 17:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678754183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MUg2QzMJL1lA1j5wto2RGOAT+HfO1sOCXGSoRe+2FbI=;
        b=AsuqJYecuA53+MFcru+ZjyCCc9wkzivS506xH+97NFFJFbdT/WtI90A2neYLGTQf/d
         viZGY7R8mMswLzXYl/0nA3nkd6sws/C7l1KlTpiPxa4cuf3W4cv2HiwfhIRSrqLV6btv
         CMDyHqbAgUwFD/jwX4xIVQcXQTT82e9mTRdTsXWjsMsaPt/eArU6+a0hsyMJ0ems/FEe
         KkrKCQZlNKG3n32Jp7o4iLtQHcjNwig2gC/hovTo31X6OTD5ado7kdIdpWBnhXbphFwO
         ys93eDnBJ7Jmep+MxlOt/TKa/U812EZsJFr4knS71oysIpPb7D1HI9ozT8cz93gKKOkY
         DXmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678754183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MUg2QzMJL1lA1j5wto2RGOAT+HfO1sOCXGSoRe+2FbI=;
        b=osCxVhO2oSdpYWgnQGC7S8+o2xj/8x+r8fjt4dn3mWgmBELpqi1A8L+l2PTxAooxyf
         OvrYqSi8Y0pkyeOaY+xpD2mU3PJnqQoKCX36rV3+gfFGMEwkXzybnbjSxb46MS2rx0YD
         kBjy3GbbZKk+Q2T2qRc3nfy4E2IICiglLdn03e90ioPPTVvLlWak1ExVhMXZVOvvGSPW
         S0mhWlfX91Q9mmfuVzyOhzkRtHEFncUOc/HJpKD1BGWeoKjHvVCLiQvFyA4zTo9HTrOw
         /le9+w6W9T+i3uU9kC3yA61WWecmRSkoFD0RZpg23ipw/Zi4QM3xDOKpqYNRUOZwu+Tb
         vTAg==
X-Gm-Message-State: AO0yUKVA4i7N8VDaC7PiE+xS8nMpVqvuxgvniUB5dG0eVxQoWM83QKPd
        DrXU7MY0Rq+2E6F8+83SY50=
X-Google-Smtp-Source: AK7set9CvsNjayW00Os2w+QYcHeQFTFuRyByYy+M9yQwPjev0vWePVnyHkWNb6/z2+L3ieQ33hOqbQ==
X-Received: by 2002:ad4:5d64:0:b0:56e:9d09:5150 with SMTP id fn4-20020ad45d64000000b0056e9d095150mr19035317qvb.15.1678754183287;
        Mon, 13 Mar 2023 17:36:23 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id c186-20020a379ac3000000b007456c75edbbsm677695qke.129.2023.03.13.17.36.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 17:36:23 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v3 7/9] net: sunhme: Clean up mac address init
Date:   Mon, 13 Mar 2023 20:36:11 -0400
Message-Id: <20230314003613.3874089-8-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230314003613.3874089-1-seanga2@gmail.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
MIME-Version: 1.0
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

Clean up some oddities suggested during review.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

(no changes since v2)

Changes in v2:
- New

 drivers/net/ethernet/sun/sunhme.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index c2737f26afbe..1f27e99abf17 100644
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

