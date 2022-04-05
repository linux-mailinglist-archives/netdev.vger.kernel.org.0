Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05084F2163
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 06:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiDECPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 22:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiDECPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 22:15:24 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96B117ABB2;
        Mon,  4 Apr 2022 18:10:16 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id o20so3852261pla.13;
        Mon, 04 Apr 2022 18:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=woWc2+lO22HzkiGe6tfKJYkKrmQ1CA7aDFe+SOO4MVo=;
        b=kfJo4Xj4tsvv/raS2h6Me0pD+/r2cSvGc3gqTYzD3/0o2MAiYvQwl6ekwsFdIjmSE/
         8e8EX3k9sUmWEP3lmVSt90/6vPD3SGyNwpLLgWJ81KPGtgjXiXA3Y2Opzk2N3uMrJe0k
         0645Ol9XN1/Sa+kXLJJ/qiRJtTt41BJofHvOAA/fMU+Rb+VUeItqT0mS9IxOlsK6l5HU
         Z3Hqy8RY1hBwBDPqUX8Oz8gao9TEWxVhfVSqci1C7q7JI7Ht7UQqVK+vHPnxiOoEbF/j
         /u0wVzWgPfrsuc6ux9NXuku6WHeu/2TX+iONMFZpROfl7DspH33C/kGU28f4h9+Ybj5A
         WyKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=woWc2+lO22HzkiGe6tfKJYkKrmQ1CA7aDFe+SOO4MVo=;
        b=RM7g+sLwVy6aoF9jzLGG1dWsuMT2RzLkQdzaSAi0P/Ojqx9MwbOP0dSwLOJcYa04Dx
         H7jtmFA4WbyKcY5D6aXFg+xZvwJh4lgwoZY3yl1LrqOTblt0kkQfoN9nC49TwsRcsHwO
         BZEnnsJg+9KZYz5+R7OVjAY0k8i9t3dydh+LKVW3jvjlXzm4Sq8QRw61OsbgTHoHmy7h
         fkgXxIKSugkZXjoKZSQGg54Yy363E1sl0r8INSIxvpdITd9Y5cNID/sIg03NDL5Yn39l
         /QsRmE2ch5eUFrIVKgmsbK2XNlsGkxSqgrwROgeRc4U8en8UyxKBWmYbd4j+aQSMnzzN
         aELQ==
X-Gm-Message-State: AOAM531lG6YImeiPvuj19Ux4dSuWeQFR9EBbcyAPmkzkJKi2W+NcvIij
        l/mP+rvrr0ms8MEDtjGmCC1rUxKq7V6LDA==
X-Google-Smtp-Source: ABdhPJyU90xOzeJ4z46zscOLk3F/0p1/sSaacQYJrTAKfRMomoQ2uWRBEXJPTNNlbKSA0irPj0sSuw==
X-Received: by 2002:a17:902:a581:b0:154:8c7d:736a with SMTP id az1-20020a170902a58100b001548c7d736amr835564plb.74.1649118196127;
        Mon, 04 Apr 2022 17:23:16 -0700 (PDT)
Received: from localhost ([183.156.181.188])
        by smtp.gmail.com with ESMTPSA id j6-20020a63b606000000b003808b0ea96fsm11091422pgf.66.2022.04.04.17.23.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Apr 2022 17:23:15 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [PATCH] qed: remove an unneed NULL check on list iterator
Date:   Tue,  5 Apr 2022 08:22:56 +0800
Message-Id: <20220405002256.22772-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The define for_each_pci_dev(d) is:
 while ((d = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, d)) != NULL)

Thus, the list iterator 'd' is always non-NULL so it doesn't need to
be checked. So just remove the unnecessary NULL check. Also remove the
unnecessary initializer because the list iterator is always initialized.

Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c
index 96a2077fd315..37af8395f1bd 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c
@@ -161,11 +161,11 @@ EXPORT_SYMBOL(qed_vlan_get_ndev);
 
 struct pci_dev *qed_validate_ndev(struct net_device *ndev)
 {
-	struct pci_dev *pdev = NULL;
+	struct pci_dev *pdev;
 	struct net_device *upper;
 
 	for_each_pci_dev(pdev) {
-		if (pdev && pdev->driver &&
+		if (pdev->driver &&
 		    !strcmp(pdev->driver->name, "qede")) {
 			upper = pci_get_drvdata(pdev);
 			if (upper->ifindex == ndev->ifindex)
-- 
2.17.1

