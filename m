Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC8E6C83BA
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbjCXRwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjCXRwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:52:00 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F8B11164;
        Fri, 24 Mar 2023 10:51:41 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id 31so2191789qvc.1;
        Fri, 24 Mar 2023 10:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679680300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HEKl1KK7ZlF8f1b0XHNy3aS7ALtOEGTZ1dh0r4qD514=;
        b=Y2KjvMxOjZnEjfu6VJ64oKgo0ZlCt2qKQz3IpvqttbRfllzpRD0i4q08cjo5VvCBtd
         4P2pEdbcvSwGkPt5DuoTeAXJ1Fjkz3ChUCImIPREFAxs71VRRq8lnSuFWJ6c6o87kfnb
         sSclbHa8kjHUnXDnoL6tdNjMX7LtfkjsZ5bAZ4ibBxwYJ9Y32e0NWaIfUF70qUk6YyBD
         d139F1zWqVEPFBqn5AS47f1rQAvR9eAcyFa/JAQVLUSjpJ4M2rLYebjaREeJ1GW8HEm+
         LHRMHgMQQvXCNKoQwtywSgqGSdd9cn/YVjfkYzu4zdZKxCRUbXX5HWgoTCheJrRy5a1x
         /1rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679680300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HEKl1KK7ZlF8f1b0XHNy3aS7ALtOEGTZ1dh0r4qD514=;
        b=7vHc53bHNxewJjP2Kn8QZMwADqJaxNY5yQbCNnB78AVueAbWFAJ8mvj0Oj18gJaRON
         eRj7WZsX42XhImX2Bf+Ka1keP5kNNCllJ/EzTdY/422K3WaESqN1Rn/czpQwhE4OrLWj
         EO9EbRVULKjkJ0FTVzdOftgqo4S0QTnPyzfSdvnb8vd/hN0HABA0WzlSZht/RBk/N9cs
         JKB+QjvHtF2FUEmy3eK2MkwA5e74f955WIg/0VYeUbE45IfGcKlj1bgEeZfyjUS0lhk1
         WcoToqnhPF7QGbNZVMsEnQuJRWNDqc/eZrsMmB6rBDp5/gG24IYeLql3g7klATcN5Hic
         OWVQ==
X-Gm-Message-State: AAQBX9cLJ5+nVhmEoRf7mwbfK7rEekD9oKkQCsDXTZgKdLmNwP5ynu8+
        vlswEH9rfSj99ovmIi6b5A0=
X-Google-Smtp-Source: AKy350YlgAF9hhE4PNRtjuZ7kiZQdD4E7aXLESIfB24AIm65l1ex8gz626fPyihD4LxZBXgo2qBiCg==
X-Received: by 2002:a05:6214:2a8f:b0:5b4:55d3:90bc with SMTP id jr15-20020a0562142a8f00b005b455d390bcmr5384276qvb.35.1679680299813;
        Fri, 24 Mar 2023 10:51:39 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id bp5-20020a05621407e500b005dd8b9345dcsm849889qvb.116.2023.03.24.10.51.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 10:51:39 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH net-next v4 01/10] net: sunhme: Fix uninitialized return code
Date:   Fri, 24 Mar 2023 13:51:27 -0400
Message-Id: <20230324175136.321588-2-seanga2@gmail.com>
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

Fix an uninitialized return code if we never found a qfe slot. It would be
a bug if we ever got into this situation, but it's good to return something
tracable.

Fixes: acb3f35f920b ("sunhme: forward the error code from pci_enable_device()")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

Changes in v4:
- Move this fix to its own commit

 drivers/net/ethernet/sun/sunhme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index b0c7ab74a82e..7cf8210ebbec 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2834,7 +2834,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	int i, qfe_slot = -1;
 	char prom_name[64];
 	u8 addr[ETH_ALEN];
-	int err;
+	int err = -ENODEV;
 
 	/* Now make sure pci_dev cookie is there. */
 #ifdef CONFIG_SPARC
-- 
2.37.1

