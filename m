Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0976B8709
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbjCNAhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjCNAgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:36:49 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBF5838BD;
        Mon, 13 Mar 2023 17:36:25 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id c18so15209437qte.5;
        Mon, 13 Mar 2023 17:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678754184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SOCOjPd5JpdHiLSR/P7sXnrUCKXyem7paBgrkQ5Wp0o=;
        b=UaCYiEHEWdVEKZ35OqXD+F2I1+pJVYxTIGR0lIjznZpNsKRAU3sLqHKElISUQVlqm5
         SGMeGndNYHG7M0YJP/xAs3+UmIedBOD72oV2XmUQHjTErtYQJ5kfjLJqlZYudcYu4ZHy
         DjUrqrcveg60WeIWR5T2yXmeogoK6KTVx4yJaI6lYEOZw98CtCq9jTnHyJrqQtIwqV9t
         r5eu3h8cFR6sG6/b15NE7/LslVhwWsfeCxrbyJ9Tk6FKusJKL8JO0GtQ4xOzofguD4lN
         1xegTf9tgJwRbpPOdtkGZ/hE4Zlr0iRPTimDh9j4IJgWPcjof3q3mxeMviTOfkCzqIeM
         Y6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678754184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SOCOjPd5JpdHiLSR/P7sXnrUCKXyem7paBgrkQ5Wp0o=;
        b=qf4jLRTsVbzEsT+sWEqXP+YihR0kEKdB09lnKVDwBYItBVI8xBjS/97EMOehwFbHFS
         LuPDEFCl0JYslIfsQ9s6sbbCBsheQN6Cqn9eSOBxC4UoQoFLr20iwcsYSiwQnl0cxuJG
         1y6Enc8nOQUBsN4ey06co2lrzH7zmmOxUV6Y49jCXvslk2f3aFFJtmc3sC2BHWu37xRU
         Q2VH5P688bi9R3ajYygcuDvb0B4cqfL5nZzzE59PHWVEo+2hacns+ZGm3HN+8tonlCAZ
         sEbXNGkoWXBsogyVxwRwK6Pye9IpOD9zDPOJPEaB0pxDQpUXRicG19l2x6+V/+oHfGYO
         2l2w==
X-Gm-Message-State: AO0yUKU/p4j7HEEqQtqAgMVny974ci/hcX8DKj+ov8NFoX5IZ/DjP23z
        w8EGs2ih9hPX1iHCmHvY4J8=
X-Google-Smtp-Source: AK7set96rxov+2IiQhKKbU+qGrxezwXTHwxe4qUajECCw5UhdYZRog3KjQLrtyj1kDRE2MvDCRK+gg==
X-Received: by 2002:a05:622a:148c:b0:3bf:b829:1939 with SMTP id t12-20020a05622a148c00b003bfb8291939mr27838813qtx.3.1678754184342;
        Mon, 13 Mar 2023 17:36:24 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id a23-20020ac86117000000b003b868cdc689sm841185qtm.5.2023.03.13.17.36.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 17:36:24 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH net-next v3 8/9] net: sunhme: Inline error returns
Date:   Mon, 13 Mar 2023 20:36:12 -0400
Message-Id: <20230314003613.3874089-9-seanga2@gmail.com>
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

The err_out label used to have cleanup. Now that it just returns, inline it
everywhere. While we're at it, fix an uninitialized return code if we never
found a qfe slot.

Fixes: 96c6e9faecf1 ("sunhme: forward the error code from pci_enable_device()")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

Changes in v3:
- Incorperate a fix from another series into this commit

Changes in v2:
- New

 drivers/net/ethernet/sun/sunhme.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 1f27e99abf17..a59b998062d9 100644
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

