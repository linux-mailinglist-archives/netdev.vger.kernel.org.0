Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7836B5FAC
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 19:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjCKSTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 13:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjCKST2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 13:19:28 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC74E5F534;
        Sat, 11 Mar 2023 10:19:17 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id r5so9301241qtp.4;
        Sat, 11 Mar 2023 10:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678558757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1/QWyN+1rTXKKFO+psZRLLz7sEIRxuKnLx8615NJfo=;
        b=kABZzwS+f+kxgP9qwE6a+QVqZVqf36WgUvect6GHtczuVX4Qapk42L4yTC4j5D5AB4
         J2tdU5cGVZPgQvxhG5qd+qZScQ9RRGO+cwnEPil80cwXQwaZJEXzFe17Mdm6yLO4u0ra
         T1KFnDGSJNDLULtOUA7smYUdgJnlWz2JRakfyEUMvQNEGOtA6e/5IW8z7pDIeB+70u73
         zLWBFHMMmuC3Xm6OgmrWb5usN2064QNflN1dYt106ZGzRhXxsnPb5P1aq1nNeNNZB3Bo
         QMb++LDw6p+3yLEYSw37dzXMqGM8JzMjSR8EycSrEFRfIUsI87tAiRz4lcHLAEvqzjEi
         7XJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678558757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b1/QWyN+1rTXKKFO+psZRLLz7sEIRxuKnLx8615NJfo=;
        b=oum5x5zPF74iLXOSg0BZTVuDybqm3cmSpy75wu7MsRBl/pEgIB/NUWeTIjsFCcQbpW
         Gyyq4eSpVhnmNaTKO6bjvDys3/ExXsTFg0mDNLuzSyNzwPgE+1r8mLoCwQsWx9BZEViU
         a0A2Ec7SvacS4n5+Bj3oKloCb/GssuH2vdX+A+W/VXhFaeh17jmff5MfIh8BWAit+8nc
         q7fXa6SZHtRisAMV+Pjy2wbPNfn3GyRP72yf7Jv31sJyZyBjKmeTeIYcYbor6kXghOIv
         NW/rlRfKAMaWSJ7VKr3zk5ho4m5WE2cfKvMhi2y+aJH+SCFkrkWoydhWwlD+yTMTO3ee
         /CrA==
X-Gm-Message-State: AO0yUKX52h75x+KromRr8HmJlsjPV0E9S46q6u8fKiC1XAhP/JvpLFt2
        CKEQk29fuIHBKertDi66QmY=
X-Google-Smtp-Source: AK7set95h1GZcZZjolX4JBnLly9/5WpT8elYlHe/moPp1qEFMSttHOD5qgn3Z2K9ct9duQ1fLrzFvQ==
X-Received: by 2002:ac8:5acd:0:b0:3bf:b896:ff72 with SMTP id d13-20020ac85acd000000b003bfb896ff72mr51235588qtd.68.1678558756856;
        Sat, 11 Mar 2023 10:19:16 -0800 (PST)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id i3-20020a37b803000000b007424239e4casm2162172qkf.117.2023.03.11.10.19.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 10:19:16 -0800 (PST)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v2 8/9] net: sunhme: Inline error returns
Date:   Sat, 11 Mar 2023 13:19:04 -0500
Message-Id: <20230311181905.3593904-9-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230311181905.3593904-1-seanga2@gmail.com>
References: <20230311181905.3593904-1-seanga2@gmail.com>
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

The err_out label used to have cleanup. Now that it just returns, inline it
everywhere.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

Changes in v2:
- New

 drivers/net/ethernet/sun/sunhme.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 41b2f941c607..0b903ece624a 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2622,30 +2622,25 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
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
 				goto found_slot;
 
-		err = -ENODEV;
-		goto err_out;
+		return -ENODEV;
 	}
 
 found_slot:
 	dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct happy_meal));
-	if (!dev) {
-		err = -ENOMEM;
-		goto err_out;
-	}
+	if (!dev)
+		return -ENOMEM;
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	hp = netdev_priv(dev);
@@ -2793,8 +2788,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 err_out_clear_quattro:
 	if (qp != NULL)
 		qp->happy_meals[qfe_slot] = NULL;
-
-err_out:
 	return err;
 }
 
-- 
2.37.1

