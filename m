Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9385BC08E
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 01:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiIRX0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 19:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiIRX0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 19:26:36 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A25815FE6;
        Sun, 18 Sep 2022 16:26:35 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id d17so18726404qko.13;
        Sun, 18 Sep 2022 16:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=NzRHpoTpsrlpXyhZKqhzPJYHc2m+m1CqpwVJsw9K03E=;
        b=kZeSSlfdoy1P2sRt7qqoYGoAwx/phSjyxHfbIhEjMZBES67nE6a/V8YBKay0f2rrD1
         YIs75LEnHpo8naj28BLdOLQIW6Hpx8p9emiSgBxj/NdcR/82q0f+9hFm17osGRdiZSXC
         p40pbWovrMEU4XGx8DoDfJ27skCkVsXuGT8w+RdugpYaQeTleD9aqIKop+BRHcKMQEeR
         3eOv35ju6HRE680IitbvhstObMFfTatrUo5WULT3j/Cb0An+SWGL4SVMjuFK1Ynh6ntZ
         gjkCjnxBTRWWtk8XM2QZoLVkp0g9saBEgAq0AgFmJ3jI1gJE9AzLg5xqFPm5Qs+3fv4P
         osvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=NzRHpoTpsrlpXyhZKqhzPJYHc2m+m1CqpwVJsw9K03E=;
        b=N8RYzELwlA5kWreskD3HqQ2DbrVnQ2taNt3v5/YTODmhafqB08RCxJ5Tzg2aHEDeDR
         VFF8qQO1n+mN4JEZw3mUd5GZ7w4+JNronGqg0rkE3ZoUpBFavgs263WCu8cMIEcl8K5v
         b5zVLHexEe52Wj+kWgUKvfGdGf/cXeTAm2mAuKD2E516swHghEBndif/wJ4nBgePMe/2
         nsSIqMHe4zHTVqvS8Y7OADUAdt1HpZ8dAsX3Ga3VsdZgt0U55wIQb7nGplSB6q23n23K
         4WtV4dz+haSMplaVXetEQSPacWRg92JFFaGJsWnM/lR72bPByDfBeXbd5Tuo//p5L7QL
         RKVQ==
X-Gm-Message-State: ACrzQf0Wau4+lJpIZIqn8Jm2G+sHR7/ei3HrxyxvCjCJGo1HV7+BOvMK
        oaKKpDJgUCc+ceMyTQB+KmQ=
X-Google-Smtp-Source: AMsMyM7PjPfYV3Nu5YuKR04p6vKlxlfFu079PmgEeMgdFwF8iV7l0jUBHfo7DbrvBos/kfvJS0IFiw==
X-Received: by 2002:a05:620a:4c:b0:6ce:b5f:1320 with SMTP id t12-20020a05620a004c00b006ce0b5f1320mr11402514qkt.569.1663543594531;
        Sun, 18 Sep 2022 16:26:34 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id hf22-20020a05622a609600b0035ba90126e7sm9347886qtb.91.2022.09.18.16.26.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 16:26:34 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list),
        Zheyu Ma <zheyuma97@gmail.com>,
        Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next 04/13] sunhme: Return an ERR_PTR from quattro_pci_find
Date:   Sun, 18 Sep 2022 19:26:17 -0400
Message-Id: <20220918232626.1601885-5-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220918232626.1601885-1-seanga2@gmail.com>
References: <20220918232626.1601885-1-seanga2@gmail.com>
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

In order to differentiate between a missing bridge and an OOM condition,
return ERR_PTRs from quattro_pci_find. This also does some general linting
in the area.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

 drivers/net/ethernet/sun/sunhme.c | 33 +++++++++++++++++++------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 1fc16801f520..52247505d08e 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2569,30 +2569,33 @@ static void quattro_sbus_free_irqs(void)
 #ifdef CONFIG_PCI
 static struct quattro *quattro_pci_find(struct pci_dev *pdev)
 {
+	int i;
 	struct pci_dev *bdev = pdev->bus->self;
 	struct quattro *qp;
 
-	if (!bdev) return NULL;
+	if (!bdev)
+		return ERR_PTR(-ENODEV);
+
 	for (qp = qfe_pci_list; qp != NULL; qp = qp->next) {
 		struct pci_dev *qpdev = qp->quattro_dev;
 
 		if (qpdev == bdev)
 			return qp;
 	}
+
 	qp = kmalloc(sizeof(struct quattro), GFP_KERNEL);
-	if (qp != NULL) {
-		int i;
+	if (!qp)
+		return ERR_PTR(-ENOMEM);
 
-		for (i = 0; i < 4; i++)
-			qp->happy_meals[i] = NULL;
+	for (i = 0; i < 4; i++)
+		qp->happy_meals[i] = NULL;
 
-		qp->quattro_dev = bdev;
-		qp->next = qfe_pci_list;
-		qfe_pci_list = qp;
+	qp->quattro_dev = bdev;
+	qp->next = qfe_pci_list;
+	qfe_pci_list = qp;
 
-		/* No range tricks necessary on PCI. */
-		qp->nranges = 0;
-	}
+	/* No range tricks necessary on PCI. */
+	qp->nranges = 0;
 	return qp;
 }
 #endif /* CONFIG_PCI */
@@ -2949,11 +2952,15 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	if (!strcmp(prom_name, "SUNW,qfe") || !strcmp(prom_name, "qfe")) {
 		qp = quattro_pci_find(pdev);
-		if (qp == NULL)
+		if (IS_ERR(qp)) {
+			err = PTR_ERR(qp);
 			goto err_out;
+		}
+
 		for (qfe_slot = 0; qfe_slot < 4; qfe_slot++)
-			if (qp->happy_meals[qfe_slot] == NULL)
+			if (!qp->happy_meals[qfe_slot])
 				break;
+
 		if (qfe_slot == 4)
 			goto err_out;
 	}
-- 
2.37.1

