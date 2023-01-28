Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A14C67F991
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 17:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbjA1Q3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 11:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbjA1Q3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 11:29:32 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FECA2B625
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 08:29:30 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id m2so20731477ejb.8
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 08:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=diag.uniroma1.it; s=google;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xfm70SP1l59JhcKoSemzEu3h6qCqw1iIMU3wb3kUDO0=;
        b=Qw3Ef7EZ3Wp5F5CcE8D+eTv1C0ev9LdFae/M7VXqzm7f6iKU/ZT+uZ7n3PB+JG0pRr
         DJBjUUE34pDu0yJqOLJ89dwjf6ZcKvSHDwaGMqO2NKEJGo5nJ2BEXu17JqLTgE1TD4Sq
         Qkt2MPIGlL02TN9RHHoKvurJeA88QoKl/5vco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xfm70SP1l59JhcKoSemzEu3h6qCqw1iIMU3wb3kUDO0=;
        b=47U7JNqktgfU6X72Om6Jz0/GPT2FdPFrrKXJDB6CT8917oBgBzKqZlFUdQ7vXx0io2
         s8x95V+bH8QfZ3gSzHtDPOcQx01rd6SAiCtmg9OoACZOd9keXhEpT2w3mm6Z8tC43OJv
         ws8yt4/BM4xTQf4Tsb1WAazTzvLmzdwv+QsRnnPOBLLA3MZYn7b0hIh0Ie8CBlDIHotI
         hWgnxbEXwTY7RqUDscnZrOWWeQgPK/eYzNZYOpsh1qJTq52l+DytQpN8tQTExiftDCvS
         C+B9rK6IWhJ0xbu2/N23s0R39o8max9Wwyljw7BeLi7dV/IPpNrIhwZ7vXd+1/Ngk/7y
         VnPQ==
X-Gm-Message-State: AFqh2kosugH2heb4g8G8wBCNOel59i26yXQh44aDTjFSt6pP5zlEpsMT
        AWrN7a8dRmXEbFgxuV6X+p2AbQ==
X-Google-Smtp-Source: AMrXdXuTi4pLx8Ou03BZMGd/F6SGpm005fYDYEZdzbeFMeFJyXHijecg0b4JF5pwcyiYiaQ7LT7WKA==
X-Received: by 2002:a17:907:6e02:b0:84d:2eb0:57d6 with SMTP id sd2-20020a1709076e0200b0084d2eb057d6mr65619956ejc.52.1674923369052;
        Sat, 28 Jan 2023 08:29:29 -0800 (PST)
Received: from [192.168.17.2] (wolkje-127.labs.vu.nl. [130.37.198.127])
        by smtp.gmail.com with ESMTPSA id x25-20020a170906711900b00878b89075adsm3333464ejj.51.2023.01.28.08.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 08:29:28 -0800 (PST)
From:   Pietro Borrello <borrello@diag.uniroma1.it>
Date:   Sat, 28 Jan 2023 16:29:17 +0000
Subject: [PATCH net-next] net/tls: tls_is_tx_ready() checked list_entry
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230128-list-entry-null-check-tls-v1-1-525bbfe6f0d0@diag.uniroma1.it>
X-B4-Tracking: v=1; b=H4sIAF1N1WMC/x2NQQ7CMAwEv1L5jKU06QH4CuKQpoZEBINsFxVV/
 Tspx9FqdlZQkkIK524FoU/R8uIG/aGDlCPfCcvUGLzzwfX+iLWoIbHJF3muFVOm9ECriic/xTAM
 bgqeoPljVMJRIqe8PzyjGsk+vIVuZflHL8BkyLQYXLftBywqTj6OAAAA
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vakul Garg <vakul.garg@nxp.com>
Cc:     Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pietro Borrello <borrello@diag.uniroma1.it>
X-Mailer: b4 0.11.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1674923368; l=1132;
 i=borrello@diag.uniroma1.it; s=20221223; h=from:subject:message-id;
 bh=gllQ2JzOflyBu2ByfY+zK/jIDj3CW9IOGyqMdaDECh0=;
 b=LA7eBtt2956hfPfW1jmT/KBvISZ3D0TmCfhRabaikgOOdy03g0u8yt9BILIrwk6ZklZk0NMJPXhR
 t5Ovkg8+A8nQgHpuAFx+3jC13M3MX7cGTbxAdgp9abaxV1KWtz1e
X-Developer-Key: i=borrello@diag.uniroma1.it; a=ed25519;
 pk=4xRQbiJKehl7dFvrG33o2HpveMrwQiUPKtIlObzKmdY=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tls_is_tx_ready() checks that list_first_entry() does not return NULL.
This condition can never happen. For empty lists, list_first_entry()
returns the list_entry() of the head, which is a type confusion.
Use list_first_entry_or_null() which returns NULL in case of empty
lists.

Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 9ed978634125..a83d2b4275fa 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2427,7 +2427,7 @@ static bool tls_is_tx_ready(struct tls_sw_context_tx *ctx)
 {
 	struct tls_rec *rec;
 
-	rec = list_first_entry(&ctx->tx_list, struct tls_rec, list);
+	rec = list_first_entry_or_null(&ctx->tx_list, struct tls_rec, list);
 	if (!rec)
 		return false;
 

---
base-commit: 2241ab53cbb5cdb08a6b2d4688feb13971058f65
change-id: 20230128-list-entry-null-check-tls-92da3440d32e

Best regards,
-- 
Pietro Borrello <borrello@diag.uniroma1.it>
