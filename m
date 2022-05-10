Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81821521FEF
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346640AbiEJPwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347246AbiEJPwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:52:08 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9826023BC2;
        Tue, 10 May 2022 08:48:07 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id t16so13810793qtr.9;
        Tue, 10 May 2022 08:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YUVX9pehnKFP2HbXOeJRXPON1pdMSinpND4hyUbpd7Y=;
        b=H7DHmga0YfNQOKRmyc5R1n9BtsfW36I+EeUo8Gn6tKIkX1sawCN5POYUm1ggf0QLIg
         y/zdQlOHPeAwSHVXraw2VC92qXm5io24/bWkUg1a+EOWnAFbhyWGy2MQNYq+voI38Af5
         qZJGZMvd3wnnjh0CIvbujrGVLSjzEHi3dj/FKGGyEv7SNcwK08++bVPBiKSAfTxpILXC
         10JenjZtFA2cuFkeXEq6/NVYLvBCGiFr8H5wwG5j8N/vk8f+kI2EV3ewRffC9eLq8o0I
         GfiUAU89D1PkvS/jYqGf1K163yTaUsGnqaXBK9LMC0TVultHBleCIej+qbQMbyD9ZLTL
         8dXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YUVX9pehnKFP2HbXOeJRXPON1pdMSinpND4hyUbpd7Y=;
        b=Zn9ZO58XyJSLgt5sYc+kG8EU98WgEthfog6UBymmWTpVU2faebwW3aqZlNaW7MqQMr
         6pcA0rMcAbjj5rcYGuI9KN+gHl5qJIPIG+m8gdx6D3Mn+p2RxTOA7bGCm8ZGXh3pBd1b
         VIwO3V0tSY140eeBt1mfk6aqYzxDvJGoQTXP+JKlGEYGINweLKmlUnHYTWGsyFwmhO8b
         Q1/XvmosCG2+5aDYPmSVR4VUUewxR7562AA9pqG00SGqo+1uC6tjUe5UI269HfP5CfxF
         GoFCuCjJ0hGnTAUZC2hDpXJGB5skLU33mQnZghBM9Rth7OLmx1d4Rz6nAJLCj5E8MXeR
         kr6g==
X-Gm-Message-State: AOAM531FLpIT6bkKpy4xul547kLOB5vg5oG431ZKMKbHqApPCvet5q10
        eCqcJ2Cq244Rt/9PX6Fu/RE=
X-Google-Smtp-Source: ABdhPJxaFgINLYqbZDb9FJmk7RM9HPgCJquH2MWeHN9oyrPrIpTHIjpThvrKU8Y1hJ9jOgwtocfAUQ==
X-Received: by 2002:a05:622a:141:b0:2f3:c7be:3f53 with SMTP id v1-20020a05622a014100b002f3c7be3f53mr19486120qtw.539.1652197685469;
        Tue, 10 May 2022 08:48:05 -0700 (PDT)
Received: from localhost ([98.242.65.84])
        by smtp.gmail.com with ESMTPSA id w2-20020a379402000000b0069fc13ce250sm9044681qkd.129.2022.05.10.08.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 08:48:05 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Nicholas Piggin <npiggin@gmail.com>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Matti Vaittinen <Matti.Vaittinen@fi.rohmeurope.com>,
        linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Manish Chopra <manishc@marvell.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH 09/22] qed: replace bitmap_weight() with MANY_BITS()
Date:   Tue, 10 May 2022 08:47:37 -0700
Message-Id: <20220510154750.212913-10-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220510154750.212913-1-yury.norov@gmail.com>
References: <20220510154750.212913-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qed_init_qm_get_idx_from_flags() uses bitmap_weight() to check if
number of bits in pq_flags is greater than 1.

It's a bad practice to use bitmap API for things like flags, because flags
are not bitmaps (and it's bloating and potentially not safe - for example
if flags are not declared as unsigned long).

In this case, MANY_BITS() fits better than bitmap_weight(), and
switching to MANY_BITS() silences scripts/coccinelle/api/bitmap.cocci.

CC: Ariel Elior <aelior@marvell.com>
CC: David S. Miller <davem@davemloft.net>
CC: Eric Dumazet <edumazet@google.com>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Manish Chopra <manishc@marvell.com>
CC: Paolo Abeni <pabeni@redhat.com>
CC: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 672480c9d195..fbe69e538f53 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -1702,8 +1702,7 @@ static u16 *qed_init_qm_get_idx_from_flags(struct qed_hwfn *p_hwfn,
 	struct qed_qm_info *qm_info = &p_hwfn->qm_info;
 
 	/* Can't have multiple flags set here */
-	if (bitmap_weight(&pq_flags,
-			  sizeof(pq_flags) * BITS_PER_BYTE) > 1) {
+	if (MANY_BITS(pq_flags)) {
 		DP_ERR(p_hwfn, "requested multiple pq flags 0x%lx\n", pq_flags);
 		goto err;
 	}
-- 
2.32.0

