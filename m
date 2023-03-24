Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B893D6C83C8
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbjCXRwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjCXRwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:52:23 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361CEFF31;
        Fri, 24 Mar 2023 10:51:50 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id g9so2106495qvt.8;
        Fri, 24 Mar 2023 10:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679680308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vrlw2rRFPR/eSSIFUVW3e377Xx72Gk415j7uJGfCXws=;
        b=qgEtp8vc+L5rmjlL9msnQ7wlRAgsFhZqspaoi7vXObSu4q23r7NawU/mukvwmEsRfm
         3MYquyphkbvLjwoYkGoB4/WPKNPoyZlFj6Pubtxuji//dEjj6VY7ORyrgHoLnKqbPjTk
         rIaoTwIRZPxF2gJXT0nXIrjTAUp5Q5h2KTmqt+CWsVj6cU2WMGfU5YlGGhPHeOdorI1f
         xhr0lsVq7AvVhE7cJUKJ/r4WiBTaWSaOKdCZIxo1KFNdwc345/l1edmxgG5N4GBp3A3+
         Tt5xKvvdVFjiw2lXa0JDyZpZZdFmJxrVKiMOKYegWF3U0AwbXvVJBXpKx5f/OimflCUw
         h5NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679680308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vrlw2rRFPR/eSSIFUVW3e377Xx72Gk415j7uJGfCXws=;
        b=KJRCA6ionw1MGutPzPIg5yCV7GJKeJom5KMnMEELjDM2MY8Mr7/n9sRQV64zkcixIw
         AckM9Z6//Gak6JoUpfhUzi4ornKolXfwPOiUZtu1Qt44Gw9t/+dyLUitUXKj/fgMWSIN
         P/HRshc3NWiLz2HpMg72FIiKi4UeQWDOMw1AUfX2heoDkeoztgX5vH5n0CGwf6Qr/jMV
         jKAsYmKaTf/gzV13B+Ks+Sn0Scol/picLQWTD6rQH9cyXXzxHfs9QDojyKSm7Ceuo6qD
         dZzoMs26Qv7ClXaWvaKuVd9tl73CTwrqv0wLJOGyELPFcMriVycUBlR8ft1ZkxqHxQ6F
         rbJg==
X-Gm-Message-State: AAQBX9e9k+rFkQiZmBQKG9coxiuz5DVugrp0t5BZCoUlGN+IXyNweVei
        vF+CenErWhaxFV93ELr2y80=
X-Google-Smtp-Source: AKy350agO0lFA3WOrJ94Nri5uWAMh4cV25PyeNM4L60yW+tCAd+U5jRUfMJOr2yG/SOoFsVcMlETHA==
X-Received: by 2002:a05:6214:f67:b0:5a9:d6dd:271e with SMTP id iy7-20020a0562140f6700b005a9d6dd271emr7471074qvb.18.1679680308530;
        Fri, 24 Mar 2023 10:51:48 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id mk5-20020a056214580500b005dd8b93459csm846081qvb.52.2023.03.24.10.51.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 10:51:48 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v4 09/10] net: sunhme: Inline error returns
Date:   Fri, 24 Mar 2023 13:51:35 -0400
Message-Id: <20230324175136.321588-10-seanga2@gmail.com>
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

The err_out label used to have cleanup. Now that it just returns, inline it
everywhere.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

Changes in v4:
- Move uninitialized return to its own commit

Changes in v3:
- Incorperate a fix from another series into this commit

Changes in v2:
- New

 drivers/net/ethernet/sun/sunhme.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index b51b8930bef1..bd1925f575c4 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2622,29 +2622,25 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	err = pcim_enable_device(pdev);
 	if (err)
-		goto err_out;
+		return err;
 	pci_set_master(pdev);
 
 	if (!strcmp(prom_name, "SUNW,qfe") || !strcmp(prom_name, "qfe")) {
 		qp = quattro_pci_find(pdev);
-		if (IS_ERR(qp)) {
-			err = PTR_ERR(qp);
-			goto err_out;
-		}
+		if (IS_ERR(qp))
+			return PTR_ERR(qp);
 
 		for (qfe_slot = 0; qfe_slot < 4; qfe_slot++)
 			if (!qp->happy_meals[qfe_slot])
 				break;
 
 		if (qfe_slot == 4)
-			goto err_out;
+			return -ENODEV;
 	}
 
 	dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct happy_meal));
-	if (!dev) {
-		err = -ENOMEM;
-		goto err_out;
-	}
+	if (!dev)
+		return -ENOMEM;
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	hp = netdev_priv(dev);
@@ -2792,8 +2788,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 err_out_clear_quattro:
 	if (qp != NULL)
 		qp->happy_meals[qfe_slot] = NULL;
-
-err_out:
 	return err;
 }
 
-- 
2.37.1

