Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427654DE5F8
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 05:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242125AbiCSEhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 00:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242120AbiCSEhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 00:37:40 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CC3195D8A;
        Fri, 18 Mar 2022 21:36:19 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s72so3710909pgc.5;
        Fri, 18 Mar 2022 21:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=woWc2+lO22HzkiGe6tfKJYkKrmQ1CA7aDFe+SOO4MVo=;
        b=jvaK9r3TsTbFAiCASU8hDVRNQR/TpJ+j/sFQLFC2SjXL9YegobThrGohsvNfZ6Q8jt
         DPN/+rV1MiBPwD+nFUrE1T/1iDGAVJNSgknBYoSMSsu7XAJjOAbot4idH1LG8dt+Ep0f
         YfAWMIgR9Sis/DmLnrLBHgBBSMvjynpCmHu9jxe2lbQDd0bpSSwgPAT6ua+7xOf+Dj/m
         TLyfBkFb8U+0Z7uxJUkhyov54Fi6he1RpOOfex8k7kpXAn7LpEEatLY0Gqmeef0x+EU+
         xVRfdLm595l1xco/GykoPHXsl9D2EFqsmBD1waf4Wlkj3atUrrr/ns0Lj5gZa7j5x/fW
         1o+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=woWc2+lO22HzkiGe6tfKJYkKrmQ1CA7aDFe+SOO4MVo=;
        b=cqMDUboGiJcujds3PzseUcpzyGxFUwwRIFrDRRoZRw4wR5ifrmgFa27wkdahQlgMaM
         goEtx1GZE/epqtEQlRMrvuyV+C3EN9HMCeWxrkwQ/TelGPCg9RNDLxB+W0pTCSrXbh5N
         AyVhIpT7ev6pgSHIFUkwkj1uu/4S7/rIgWtonGnfjGx4o2nRsipRwTu++HxDbn5HzXdI
         orm0aoXhzV3b8/y+9s2f3y1flcON4rZuRHEvQimkccOrupDvLBHrogtdC/WyuWcksT8p
         r8VJfKBTHQIulG21PHJ9JP52XA/zRrRxr7I7JWrEu1zdVSbLRWNqJA8lqis5AcQ2YVbk
         iHlw==
X-Gm-Message-State: AOAM5330BVtuxzGvoI0yS39mspyOWE8U0WVgE+hOyraZpEbFD7uN6G7c
        1L5MgZ/teiHIqtjVezG20YU=
X-Google-Smtp-Source: ABdhPJwHjXachEbC9jh3Il4IjkYfSCQZxQn2Flq3KZAULIDWsY9UAVu5opzZM6X/B6C8LY9CO8m6/Q==
X-Received: by 2002:a65:5a0d:0:b0:381:3c1e:9aca with SMTP id y13-20020a655a0d000000b003813c1e9acamr10294707pgs.562.1647664578830;
        Fri, 18 Mar 2022 21:36:18 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id m125-20020a628c83000000b004f7baad5c20sm11027526pfd.144.2022.03.18.21.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 21:36:18 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     aelior@marvell.com, manishc@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [PATCH] qed: remove an unneed NULL check on list iterator
Date:   Sat, 19 Mar 2022 12:36:06 +0800
Message-Id: <20220319043606.23292-1-xiam0nd.tong@gmail.com>
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

