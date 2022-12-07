Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F626458ED
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 12:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiLGLXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 06:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiLGLXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 06:23:40 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D5CFC6;
        Wed,  7 Dec 2022 03:23:38 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id d14so19489209edj.11;
        Wed, 07 Dec 2022 03:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Swxnqm3Yd6IphquwUVUjDbZqjsoRJONegiUpMUBVzbI=;
        b=HYxWXiXhINqH8bCJs4SmMewv5g8Ur2E0DRr8gIwW12/0KK4qTfP5z59eS4QT8nStom
         /EkDq+Tm7TELmiMhkrf5PqXt7YxQu0DPQ4W72ASsxVWhhuKhlPFMondPKLLQmhr7f/Q1
         szN+UjpPqSMfqdT29m3C4nk0GmQn59Y78UFMY/Xhp46FBIeOMzpu+iLWGi4mFfw37L2k
         TOB/rqpmia7dsWAgOAdFo3Im+C0xXflKP44KCK6tfikKdpCvzjX6Nf2kD+/gnXd/geYk
         gXNxrpP6hipS4G5NkFzdbm9l7m8DDue++k/VWjlsjB5l8qAiM94C5lAXdDoRxyGf6+Rr
         j4wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Swxnqm3Yd6IphquwUVUjDbZqjsoRJONegiUpMUBVzbI=;
        b=D3AP79h39VUPYfP9UaNi4/eN3CXWn89gdVpexfw52XPLub3o1JUnl7bydqzt82S200
         vkPBHw8kdZQZzk8u18KDgEkH5qNB/kjFHi8K8lES7EGNxd+qUIOASjAew2FVTes5QpDG
         11gkh0slBnuz3KgdJsPjE8laRpVQr6/488P8naRbkeZgtNPVDw/+XHj3Ul5SfVkKqQPK
         yKENvUxTh6sQUFbwOrFdu7I8dV/Q8msJYAg1oC27UtoaqpvdFOz3iZuWFerxcFF/dl69
         TL4zNwOPDgu984+cSdvjXh2DQjTzbqLKraFrQyUg7GWfoIx9UH7YV/fuEBSh8p6veeZ0
         s44w==
X-Gm-Message-State: ANoB5plGUr2/ed2xedYXiFKVDPdfYcN37UWU2hTmnpMozvO9Oj6sebyK
        9OhqahIwi1Bxj5tHO2dk+uccqm2me6cnUg==
X-Google-Smtp-Source: AA0mqf5HAtg0GE5OsFF3c0vQQ0Lz9CGfSlS0+QSwQa5Bicln7DNek7IMvwQAAEuPZ1pLMl4hryWeQg==
X-Received: by 2002:a05:6402:e0d:b0:466:4168:6ea7 with SMTP id h13-20020a0564020e0d00b0046641686ea7mr20466056edh.273.1670412216884;
        Wed, 07 Dec 2022 03:23:36 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id f6-20020a056402004600b0046776f98d0csm2051450edu.79.2022.12.07.03.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 03:23:36 -0800 (PST)
Date:   Wed, 7 Dec 2022 14:23:28 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] lib: packing: fix shift wrapping in bit_reverse()
Message-ID: <Y5B3sAcS6qKSt+lS@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bit_reverse() function is clearly supposed to be able to handle
64 bit values, but the types for "(1 << i)" and "bit << (width - i - 1)"
are not enough to handle more than 32 bits.

Fixes: 554aae35007e ("lib: Add support for generic packing operations")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 lib/packing.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/packing.c b/lib/packing.c
index 9a72f4bbf0e2..9d7418052f5a 100644
--- a/lib/packing.c
+++ b/lib/packing.c
@@ -32,12 +32,11 @@ static int get_reverse_lsw32_offset(int offset, size_t len)
 static u64 bit_reverse(u64 val, unsigned int width)
 {
 	u64 new_val = 0;
-	unsigned int bit;
 	unsigned int i;
 
 	for (i = 0; i < width; i++) {
-		bit = (val & (1 << i)) != 0;
-		new_val |= (bit << (width - i - 1));
+		if (val & BIT_ULL(1))
+			new_val |= BIT_ULL(width - i - 1);
 	}
 	return new_val;
 }
-- 
2.35.1

