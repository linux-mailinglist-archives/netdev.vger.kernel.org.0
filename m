Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB925BC08B
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 01:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiIRX0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 19:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiIRX0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 19:26:35 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2863A15FCA;
        Sun, 18 Sep 2022 16:26:34 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id g2so16668536qkk.1;
        Sun, 18 Sep 2022 16:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=8EAn0cvdlfoIPExkywDlAWVYcfVTv9+DcRGm06t9Xe0=;
        b=iW6tucCCgZ5pZY72nI38Eu2AUCumKfVLIqoaDS2hX5URAg5jqvPLE9VLTtRdEYYd90
         5w7Nfx+C9vgKRRN31+AbjvVFURwJJZzGHkGyEzLGu3/P6E5J1kEZXrz4yKSy2r/h5pt0
         ++D1N3q1IR2bCmgPECOy3BvLE++gxTi/UB0GwznzP5YycquEdqfeQp5hNx5g988/g5XX
         lLxMwvPscvOylDyZ5H0NKJ5xACaNAN4ytNIElbWIoODOGBepbmlMDUuhy2T60mCjxPf0
         G+QXiVu6IR0yIg8zNMW6cwUnHqUULCuKO/ZaQZXnygMkHZN7yhJ2U13BEYwBR0o0DkkA
         5i6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=8EAn0cvdlfoIPExkywDlAWVYcfVTv9+DcRGm06t9Xe0=;
        b=D21d07mm+f2JuVkHkvENWwxk+OYdbPcTkjCCCbdM7WXlRgr5W51J6z2kShWktb52Gp
         jRtb1iT9VQvKl2CTklrnKrV1fJ/m9uKpM0krZpn3lHi/us0gnICjTBOsuXdbn63U3YsN
         kpFI8qHiiYUT0MFVFKzT7HUz+A1wpnQmy44EGT7dVGHH1V0vXJaSJF+OISIyQq4h2qBs
         RuaMjzHMNOtAVf/etTgtNJZfdXATkisqVK06CeEkLsdpKQ6ec0TzCH+7zEczsDSVG/Jx
         uOKtylRTXKt8NRDUT6KtesKu+XU5zlLodo9ogTsv5RWrEnJnQXqtRPs7Hr9B1TpdZ56F
         RXwQ==
X-Gm-Message-State: ACrzQf2xxG3Vey6flG7m5UrcOXrvBjHXJjMloOVwAfWmXTqGEo38J3PC
        TMIHuFAiYFcxD5njw4GDM3A=
X-Google-Smtp-Source: AMsMyM7hM1MM7LF1QdJVTos4SleSEL5rhfJ3Ek6St9qQNr2e/LRqf7tOpo+FGJsh6PIXiZeqN/aKNw==
X-Received: by 2002:ae9:c105:0:b0:6ce:e3d8:73af with SMTP id z5-20020ae9c105000000b006cee3d873afmr5306664qki.105.1663543593335;
        Sun, 18 Sep 2022 16:26:33 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id de42-20020a05620a372a00b006b945519488sm11637265qkb.88.2022.09.18.16.26.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 16:26:33 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list),
        Zheyu Ma <zheyuma97@gmail.com>,
        Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next 03/13] sunhme: forward the error code from pci_enable_device()
Date:   Sun, 18 Sep 2022 19:26:16 -0400
Message-Id: <20220918232626.1601885-4-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220918232626.1601885-1-seanga2@gmail.com>
References: <20220918232626.1601885-1-seanga2@gmail.com>
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

From: Rolf Eike Beer <eike-kernel@sf-tec.de>

This already returns a proper error value, so pass it to the caller.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

 drivers/net/ethernet/sun/sunhme.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 7340d0f2ef93..1fc16801f520 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2940,11 +2940,12 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 		strcpy(prom_name, "SUNW,hme");
 #endif
 
-	err = -ENODEV;
+	err = pci_enable_device(pdev);
 
-	if (pci_enable_device(pdev))
+	if (err)
 		goto err_out;
 	pci_set_master(pdev);
+	err = -ENODEV;
 
 	if (!strcmp(prom_name, "SUNW,qfe") || !strcmp(prom_name, "qfe")) {
 		qp = quattro_pci_find(pdev);
-- 
2.37.1

