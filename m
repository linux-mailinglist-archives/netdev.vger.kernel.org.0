Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B32E5EB067
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiIZSoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbiIZSn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:43:59 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D25488A16;
        Mon, 26 Sep 2022 11:42:42 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 184-20020a1c02c1000000b003b494ffc00bso122920wmc.0;
        Mon, 26 Sep 2022 11:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date;
        bh=gp0fbvy2tUrmKm/iw/c/azuvn8FXFqwnpF65hLRML3k=;
        b=ZmnLsxN10+ZD+EjAF3JReD7uJAXFJdjUtOJquBOO4lCnM5uS5tRaD7ZSPV3ik/PDvc
         TgzTKXoyQJ8nqxm3hEQMcBGNBz7ujDezxSkCYqfGyH+CRU3d66jEkYx4F8KwVq6ZBCl0
         +mx1DUuLEYCcXmyCStjn1QrX/cH05VJNV/1tsmsPAvtt5RlUYz98x8YL4tJptlEouuKV
         ZvfgYUQCftMhSzns0BFxYr6ZnGqVLhyKW2k6ELm7DhcSXSwiyH678O47pLc3oYU4Wj1U
         kUSDT5EzzPdLgcwnJWjx818rYWIw4KlQfxMGva5EjXPw6dchviDSgFQUsiREE4mCvJgw
         UUig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=gp0fbvy2tUrmKm/iw/c/azuvn8FXFqwnpF65hLRML3k=;
        b=MO9Ls0TtQiU1kotYYcbdEzx752FYNRUgZ4x9zK9O2QSZd7r1JWhE5wHd1fiwCcutsq
         YwFvTEtFN0pTuMckTqmlkPzLRzzrY+JnvhfY2uyCRTjaMCRN/o/MmSxN0vCgKwXPuPIz
         D+XU3u+4miHAsNPQ/NDsRkEsSShF6EGRApr7o0i9Hv1kKhT51v16S/rcM3W8JvNyhj4v
         PpRHfG4RKuyP2QBLcLG9AOIwZeOomDe1juJcDQZXoCST+kIVnzceIffxNSTiXC6JpihU
         QpwpxwMTlbIi+SC1/HC9SOxyGc656RI8fy0fQFX88HCwYNqIx1c2QDOGbT3bv89SFWKC
         hOcA==
X-Gm-Message-State: ACrzQf13KfCDlicxgPKgo7mQrBj7NfMfQBG6qNrN89X1+GlrHkobBvB6
        VSNPDu1GciNLKA6DR/b2NSkdZp3L8A==
X-Google-Smtp-Source: AMsMyM79aYinHSO7lUY6m3XeLtBfKUEDiqH8wQeOFu/1WkmCSWQvG0Feu519/19iTJdFJce0GVmkjw==
X-Received: by 2002:a05:600c:4f55:b0:3b4:b687:a7b7 with SMTP id m21-20020a05600c4f5500b003b4b687a7b7mr57464wmq.185.1664217760790;
        Mon, 26 Sep 2022 11:42:40 -0700 (PDT)
Received: from fedora (88-106-97-87.dynamic.dsl.as9105.com. [88.106.97.87])
        by smtp.gmail.com with ESMTPSA id h9-20020a05600c350900b003b492338f45sm13562149wmq.39.2022.09.26.11.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 11:42:40 -0700 (PDT)
Date:   Mon, 26 Sep 2022 19:42:38 +0100
From:   Jules Irenge <jbi.octave@gmail.com>
To:     borntraeger@linux.ibm.com
Cc:     svens@linux.ibm.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        agordeev@linux.ibm.com
Subject: [PATCH 3/7] s390/qeth: Convert snprintf() to scnprintf()
Message-ID: <YzHyniCyf+G/2xI8@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Coccinnelle reports a warning
Warning: Use scnprintf or sprintf
Adding to that, there has been a slow migration from snprintf to scnprintf.
This LWN article explains the rationale for this change
https: //lwn.net/Articles/69419/
Ie. snprintf() returns what *would* be the resulting length,
while scnprintf() returns the actual length.

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/s390/net/qeth_core_sys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
index 406be169173c..b40802d707a1 100644
--- a/drivers/s390/net/qeth_core_sys.c
+++ b/drivers/s390/net/qeth_core_sys.c
@@ -500,9 +500,9 @@ static ssize_t qeth_hw_trap_show(struct device *dev,
 	struct qeth_card *card = dev_get_drvdata(dev);
 
 	if (card->info.hwtrap)
-		return snprintf(buf, 5, "arm\n");
+		return scnprintf(buf, 5, "arm\n");
 	else
-		return snprintf(buf, 8, "disarm\n");
+		return scnprintf(buf, 8, "disarm\n");
 }
 
 static ssize_t qeth_hw_trap_store(struct device *dev,
-- 
2.37.3

