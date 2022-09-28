Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505DC5ED22A
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 02:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiI1AmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 20:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiI1AmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 20:42:01 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39A01C6133;
        Tue, 27 Sep 2022 17:42:00 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id g23so7131858qtu.2;
        Tue, 27 Sep 2022 17:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=24mwch+9Dgf0bZ4LPZLYwZNGujwjKCMpUS4L9Z2MX10=;
        b=DKYJHdTkLK//5MQoKkDunUh2q+VHJXJ3NjAo7NDenLx7wsSl29hb64U1rp9sCJZhEm
         vuIZnk9QVaBR/3FqIrVuWgfsQItVDU5xp6+cESkGhqttDfRq2P8Tw1PreIC+XaqUY7Q7
         Ribmva8kDQXfjrA1XlIaazmIrlxkTRtXogIj3GB11RU+YiVTDYX1ZeYhAKms+uNxMKIy
         aC9sN3aCMoJvZlZp2UcUTOM+GcHTi7MItVjgf3wCoqbTnOwupw0mcoG2eoBspWfagcoG
         q2JN7EsFqlCd8FRaFCRIwYsJJqfuNeOt0fRKmr7N6994KBtJlniYCOw93DFN/WZumlwQ
         89pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=24mwch+9Dgf0bZ4LPZLYwZNGujwjKCMpUS4L9Z2MX10=;
        b=qd3Nshpp8lx7oVk1Q+otuCV2DjAWKO5+uvZlzXkeBq6+7klRlv4W+71CmosO4kIviy
         +IfaHyB7JUO3H2ZGbRb4vAU3CYQ5xN7zuyBGPQk7N9W5jUaWWCws5va9rXCdcmavWiNl
         SCD8yOHfISekXal+CYtEhStHRelletBBJz8CJcEZvry+VE8zXf++qCX0U6/U5oagmztB
         ZKFbQrMZvzsqU4EIWPY7+aK12H8SoBm3HA7kuIjS44+5g1qduNy7wTKoazUVLTOQAG9T
         nRXgfjARut6MXoFj/uyeGV2kz9jcxX4UmVSSrD4YxrAz9v1jNAUjXRKnNDIVjTI5+0wY
         en3A==
X-Gm-Message-State: ACrzQf3JbMoeKdQBGzuGpSCeQPX7PtD1C6o8X9g9mjhT3SzBVknDr+WV
        qTuC1d3+cCC1syh9SQSL9ao=
X-Google-Smtp-Source: AMsMyM71QPWcluMXvjmXZ5+03EMl+SSoGU52lJ2NzuWoiORPgIEhxniDJ+YwMz893gkdch+VdpKSmg==
X-Received: by 2002:a05:622a:1492:b0:35c:b7e6:12ef with SMTP id t18-20020a05622a149200b0035cb7e612efmr25029590qtx.94.1664325719845;
        Tue, 27 Sep 2022 17:41:59 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id bj7-20020a05620a190700b006bad7a2964fsm1937831qkb.78.2022.09.27.17.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 17:41:59 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Zheyu Ma <zheyuma97@gmail.com>,
        Nick Bowler <nbowler@draconx.ca>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] net: sunhme: Fix undersized zeroing of quattro->happy_meals
Date:   Tue, 27 Sep 2022 20:41:57 -0400
Message-Id: <20220928004157.279731-1-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
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

Just use kzalloc instead.

Fixes: d6f1e89bdbb8 ("sunhme: Return an ERR_PTR from quattro_pci_find")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

 drivers/net/ethernet/sun/sunhme.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 3afa73db500c..62deed210a95 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2409,12 +2409,10 @@ static struct quattro *quattro_sbus_find(struct platform_device *child)
 	if (qp)
 		return qp;
 
-	qp = kmalloc(sizeof(struct quattro), GFP_KERNEL);
+	qp = kzalloc(sizeof(*qp), GFP_KERNEL);
 	if (!qp)
 		return NULL;
 
-	memset(qp->happy_meals, 0, sizeof(*qp->happy_meals));
-
 	qp->quattro_dev = child;
 	qp->next = qfe_sbus_list;
 	qfe_sbus_list = qp;
-- 
2.37.1

