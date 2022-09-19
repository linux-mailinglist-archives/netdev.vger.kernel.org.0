Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4861A5BC38C
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 09:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiISHg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 03:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiISHgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 03:36:54 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70881A052;
        Mon, 19 Sep 2022 00:36:52 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id p18so27135804plr.8;
        Mon, 19 Sep 2022 00:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=RddoVyEqgGJbShhyE5VODA29DwwxqOU5Hde1vtZl7Js=;
        b=ovr8O4wH2ir8oES79vxrTqPvVQsUz6/BvzIxWtyTVISHyD/CA0I8VUgG7N5YYg/Dej
         wOYL7gE2kE6A334hS+0+CCrhzdevCH59BiGY9PEujVG8+JTm17M4dJ5KV9SIVCz6ppG2
         +4Wo+GW2JjEVT6JK5RpQ9ZX+VnWDB+CKMzxrf9k6oadtU7SED2lIaOYLL5qAYOTlTS4f
         21cxcxEpicDoRys31GHGntbEanzDJfMI6moKBUnZzvRZsxRd8sJp4f8TnkzCf8lx23NV
         aWBBZn7xWwPhPdNdryswOAt/rjCNcUgR3j4n3lg74dV7UWkTe9oAwVoC9F52eVRr9EsU
         ZwDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=RddoVyEqgGJbShhyE5VODA29DwwxqOU5Hde1vtZl7Js=;
        b=nRHbws1yBWT6v4LxYdBkxAdZgtGNuZxIlP9jX9ji2Ilo3wJc/9AgisqJwLf/wxit5I
         z2rvMQTw1kvf3nZlGyOYh+0/1gZwLwB8JFoRuQdPnezlYq3RtJzljKxRMsUlTkjgB/9m
         JJii79Orc9Hju38jxh14+myN4EtEDrG21mExLvy7uo76jKS0iYfKXlGPDnh355u4t0Xn
         EYyXdPpK9AUKctpbJhm/WyKgN0IZTno9fwEmH3Gheun3MzUtFumgIrixSN1uYSzjD7pz
         QDq+K+17HTiG7c3RzFIdh5RTdV2oyF0u0JNisPNnyfQR8XfDZOgX54ifL32dYnwtSCYU
         Ahww==
X-Gm-Message-State: ACrzQf1l3f0AaS5TBvr0/LUtvOTmdyZmMrq711DTm13Fa/zDl21JyMYN
        kbXUUfUfdDf5Xi+VKflOI1eAgu0de5FIrg==
X-Google-Smtp-Source: AMsMyM5d2B/SRJRE0y/4M53WgO7y36aAF0tXhKY8Gh8Zt4pFmZRRNtmJfFsqflRGeGq/LTkOfpvrbg==
X-Received: by 2002:a17:902:e547:b0:178:43de:acac with SMTP id n7-20020a170902e54700b0017843deacacmr12006475plf.39.1663573012017;
        Mon, 19 Sep 2022 00:36:52 -0700 (PDT)
Received: from localhost.localdomain (lily-optiplex-3070.dynamic.ucsd.edu. [2607:f720:1300:3033::1:4dd])
        by smtp.googlemail.com with ESMTPSA id 7-20020a17090a0f8700b002033b3875eesm6000680pjz.20.2022.09.19.00.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 00:36:50 -0700 (PDT)
From:   Li Zhong <floridsleeves@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     f.fainelli@gmail.com, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net, klassert@kernel.org,
        Li Zhong <floridsleeves@gmail.com>
Subject: [PATCH v1] drivers/net/ethernet/3com: check the return value of vortex_up()
Date:   Mon, 19 Sep 2022 00:36:31 -0700
Message-Id: <20220919073631.1574577-1-floridsleeves@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Check the return value of vortex_up(), which could be error code when
the rx ring is not full.

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
---
 drivers/net/ethernet/3com/3c59x.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index ccf07667aa5e..7806c5f60ac8 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -1942,6 +1942,7 @@ vortex_error(struct net_device *dev, int status)
 	void __iomem *ioaddr = vp->ioaddr;
 	int do_tx_reset = 0, reset_mask = 0;
 	unsigned char tx_status = 0;
+	int err;
 
 	if (vortex_debug > 2) {
 		pr_err("%s: vortex_error(), status=0x%x\n", dev->name, status);
@@ -2016,7 +2017,9 @@ vortex_error(struct net_device *dev, int status)
 			/* Must not enter D3 or we can't legally issue the reset! */
 			vortex_down(dev, 0);
 			issue_and_wait(dev, TotalReset | 0xff);
-			vortex_up(dev);		/* AKPM: bug.  vortex_up() assumes that the rx ring is full. It may not be. */
+			err = vortex_up(dev);
+			if (err)
+				return;
 		} else if (fifo_diag & 0x0400)
 			do_tx_reset = 1;
 		if (fifo_diag & 0x3000) {
-- 
2.25.1

