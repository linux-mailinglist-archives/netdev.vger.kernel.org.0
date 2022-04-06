Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4715B4F655E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237550AbiDFQ31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237556AbiDFQ2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:28:48 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E151959EE;
        Tue,  5 Apr 2022 18:59:30 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id z128so972732pgz.2;
        Tue, 05 Apr 2022 18:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=+BstM1DCdFbQuAlRW/IeV8n77RnYrDsExx6xUkF9F50=;
        b=BPh/+CjuD7rDuppV0GoliHkk7R3hrR/pyI7wPE/Haf62N9SEtYHw9KgbnnAiq9bTIX
         NwtCWISFym95Iz20Q5Eb1Ftb+AhJMcomYiIvNBOys7wXRwTz1tVpVz8t216McAxRmGmm
         R/7/tZiv/P6T2zZVLVUvKTaIamxc+Txs6yIHcLQuTNDCqbx6zXGKwzRlwzbYk3mgWzjR
         W2dTjrikDYKvgAmypnPNuDwemeUmT/2PQPPr1YT1pOf9vn3ZMPMAWka33CckFt4Pw8Er
         /UnY5NuKnudBPKhyns6iShR6jsTwtLPyj1t52DcegKBBoJcSj8BpBHPf0HVPmgoHZf7P
         d3Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+BstM1DCdFbQuAlRW/IeV8n77RnYrDsExx6xUkF9F50=;
        b=CUEFmowGbXEtPUhe78EaodrHBLRHcN3XsBGcORBNUOCOxRtOUAVdwRP58jVmBSDmbQ
         M2y2MuZTyLbmdeIaXwjNpmN8UqtdJN17EZoSSHRriEkdV0wMr/LrXcHBIh+mXzqjNxxK
         hVa2AHlUza6Ih7/k/hSP+IgZ6N2yP6Owo0i7ZbxBHqvTE0dgVjAWpsCKHQj2TgQXhOwG
         vEjmjIEpv0Q9XksXWPdDcZ56OImu+1RnfJ/mUirZrHv1tztGnIBWx8EvpS9KHajYn7cg
         Qdp7IKUM5DXvEhqIbdsdGFbrzrC6VOg3PNLdgL6W4zo9jvghTgDKoVICJxgbuPMpilcz
         rALQ==
X-Gm-Message-State: AOAM531EvUlCnd67XJF96ZtxD+ovDOOpQwwgbW7Ld/4teXGnMh9EdKSf
        30sBf0R89oBD6FIEL6HIU/A=
X-Google-Smtp-Source: ABdhPJwPLc6eiC8kYZI0FvlIO0ksvFtwkLurfxC+5y9YmyYVlkeIrs5vZdlEQZX13lV1sYiKXTXMXw==
X-Received: by 2002:a65:434b:0:b0:382:4fa9:3be6 with SMTP id k11-20020a65434b000000b003824fa93be6mr5120938pgq.459.1649210369734;
        Tue, 05 Apr 2022 18:59:29 -0700 (PDT)
Received: from localhost.localdomain ([119.3.119.18])
        by smtp.gmail.com with ESMTPSA id br8-20020a056a00440800b004fe10df2d3fsm7230996pfb.157.2022.04.05.18.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 18:59:28 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [PATCH v2] qed: remove an unneed NULL check on list iterator
Date:   Wed,  6 Apr 2022 09:59:21 +0800
Message-Id: <20220406015921.29267-1-xiam0nd.tong@gmail.com>
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

changes since v1:
 - adjust the order of variable declaration (Jakub Kicinski)

v1: https://lore.kernel.org/lkml/20220405002256.22772-1-xiam0nd.tong@gmail.com/

---
 drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c
index 96a2077fd315..7e286cddbedb 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c
@@ -161,11 +161,11 @@ EXPORT_SYMBOL(qed_vlan_get_ndev);
 
 struct pci_dev *qed_validate_ndev(struct net_device *ndev)
 {
-	struct pci_dev *pdev = NULL;
 	struct net_device *upper;
+	struct pci_dev *pdev;
 
 	for_each_pci_dev(pdev) {
-		if (pdev && pdev->driver &&
+		if (pdev->driver &&
 		    !strcmp(pdev->driver->name, "qede")) {
 			upper = pci_get_drvdata(pdev);
 			if (upper->ifindex == ndev->ifindex)
-- 
2.17.1

