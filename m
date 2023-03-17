Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6B76BE3BE
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 09:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjCQIfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 04:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbjCQIe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 04:34:57 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341A3E20D1;
        Fri, 17 Mar 2023 01:33:54 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id d13so4405720pjh.0;
        Fri, 17 Mar 2023 01:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679042025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EVQRC1/6jsM6rnT7EHgyJF3q/qUoPSo4wdjRlPKVijI=;
        b=H8U7DCRusRVf7mDVicyvVaWgb35QLUNbKpdcxfOkPnzTgKNg8dCk2VBvkIS1/o+Sru
         ExtSgiZ+CGdzpsTIdPaem1sBjitSxIBjjRNxyWqiTwdfoz1jBUBPvVqaSjIBn1bqGvAO
         CfG/7rt0pEt0nHj5NdKSquc0FSNlORHgHH8ZjYlW/CfB4KZonCrQnT3uNP7VdWW3TClI
         9pKLu1OWnSQvYBpfzQ97s5FSkdt0lSKq8FfBKWrS6p2C3D4tVi6Cf+w5bTGnvCqwSXU9
         EmYb8ezivAwkQcpmMlqBdceEiFnD5I41NcL19UqSxitlGC2kQFZpOMhk4+EVKtqmtCkx
         WZaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679042025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EVQRC1/6jsM6rnT7EHgyJF3q/qUoPSo4wdjRlPKVijI=;
        b=mKwUteRV2RJScus87R+0nYiBW4a/hMqV85KlTWSK6q/T9R9GSOb6urLFLIMo8GrPq9
         2uJRUXVq1U4wICUxwyUs2l/l1W6+S/chbgsyft2zvuR7liHHouY9fMgAXlVn2AV8ZnSk
         /ALSIF6NvfHT5WpmSo+2t/ZFl2jms/eWrD7fR75RVECcN6UIRi8yqY4lpx2+c0+QnDm3
         cpq4d+at6zsz5aO0xD3Fd7KT1GJCCdwqM4ive6qztGSNJa4GWDjR7/WdeqwVHM3ugNtQ
         xtGBTLssmbWXC6ky04Qq4qPbkKYozP6acqEcfWNcdut33Pt+UINi0aftRLy0kxBqHpzZ
         nkUQ==
X-Gm-Message-State: AO0yUKVSARzkv3Vsr6SyytLe6BVbYoTKk5BW9sVfUYChRW/C6I0PRQo4
        2Lxa4CfAS/i+1820A1MUS9c=
X-Google-Smtp-Source: AK7set/dBtfvilETTNoTPYDJ1y0e04eNUZhZDMhz2vsNXn+fEMnANY4Ulsq6/hXjHeeD57ttXRUcew==
X-Received: by 2002:a17:902:db0f:b0:1a1:8edc:c5f8 with SMTP id m15-20020a170902db0f00b001a18edcc5f8mr7363787plx.56.1679042025281;
        Fri, 17 Mar 2023 01:33:45 -0700 (PDT)
Received: from passwd123-ThinkStation-P920.. ([222.20.94.23])
        by smtp.gmail.com with ESMTPSA id g1-20020a170902868100b0019a593e45f1sm972287plo.261.2023.03.17.01.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 01:33:44 -0700 (PDT)
From:   Kang Chen <void0red@gmail.com>
To:     horatiu.vultur@microchip.com
Cc:     borisp@nvidia.com, davem@davemloft.net,
        dirk.vandermerwe@netronome.com, edumazet@google.com,
        john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, void0red@gmail.com
Subject: [PATCH net v2] net/tls: refine the branch condition in tls_dev_event
Date:   Fri, 17 Mar 2023 16:33:38 +0800
Message-Id: <20230317083338.1085194-1-void0red@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230317081513.ktllct3rqaisummm@soft-dev3-1>
References: <20230317081513.ktllct3rqaisummm@soft-dev3-1>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev->tlsdev_ops may be null and cause null pointer dereference later.

Fixes: eeb2efaf36c7 ("net/tls: generalize the resync callback")
Signed-off-by: Kang Chen <void0red@gmail.com>
---
v2 -> v1: simplify the condition

 net/tls/tls_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index a7cc4f9faac2..45b07162d062 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1449,7 +1449,8 @@ static int tls_dev_event(struct notifier_block *this, unsigned long event,
 		if (netif_is_bond_master(dev))
 			return NOTIFY_DONE;
 		if ((dev->features & NETIF_F_HW_TLS_RX) &&
-		    !dev->tlsdev_ops->tls_dev_resync)
+		   (!dev->tlsdev_ops ||
+		    !dev->tlsdev_ops->tls_dev_resync))
 			return NOTIFY_BAD;
 
 		if  (dev->tlsdev_ops &&
-- 
2.34.1

