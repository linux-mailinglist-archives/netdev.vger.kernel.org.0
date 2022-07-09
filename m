Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C7A56C4EE
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 02:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiGIAPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 20:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiGIAPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 20:15:43 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B69691EE
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 17:15:41 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31c88e36c0bso2297507b3.20
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 17:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=18zwxTMww86cndEzpYub9pnZe0fDkNY6EnCvkW/t9JY=;
        b=msxqFvaOZSoAWLO402a9iXoMeeEmvOcEg5VOhX+o22iSw24U+MJ7v5aJbXYhjOXEcs
         80KPM4xIH89KOQGhECF+FEZEs0ZImyjKLbt6Mjaj7LDHuEIKn4GysLo5nD9ujirYiRc4
         IgHy2nx/83FOn6x/5OM7PPbJlxmw2aA847iuBYirfRbTGllNigutmESrvh5uJ09m2Mkv
         l1GzyelrnzqNCsFX/zFW/lxNYJkZrXMfA3eK8aHziKCL6C/UMKfsCZEgFvs42zjW7YkW
         SV0eehnKB7Ka7Mco0HyzgpIJXij9SbnHq6hNPjgtpyS3thEq/3GvRWmlVHpnOUQJW1kd
         gVqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=18zwxTMww86cndEzpYub9pnZe0fDkNY6EnCvkW/t9JY=;
        b=DoiAl5/jU5CzjSWwGfBS8e/nxqS32XJvzrezVh4IkDYNB83bmjSGY69VVnBQtQ/MQr
         BnIKuHZL/AjRWQ4ryPKt2KNla58PlmnCB06NGa3vcpFerKjH2SHxdORwbVmbN3WQtmM/
         z9am79o7RRkgM33uyR3FEqldPSZWGApC69AovfjuK1CZKooAF+PbVeHcnyZp1J3/SgiP
         77WLPOrPVH4gLFX9YewizQ9J8ieyUdotGx7U6by/Mot/yB5Gqxj86KtWaLil+qp3kq5T
         xaema2SEiOlBFUfcwM4eOlQJVzVIO43tGkPU9Mv3petV/pOwL18hqylcs3RHQ4f81MnV
         K6xg==
X-Gm-Message-State: AJIora8TJnR8bi0bxQkS80clf+E9jx5YdiH3wB5i1InNEpx7+vwMDPOX
        EYSPfV2YJH6HqyTpTEKAThZAO8owfqtK2V3J1w==
X-Google-Smtp-Source: AGRyM1sfR9BLCzjhQ7iB9/w8T0nTXqnCY8GM70POd4QwcuIQdsEQRKXzL/APCV3KaFIEOVcpID4t0hTXIVbShLssFQ==
X-Received: from justinstitt.mtv.corp.google.com ([2620:15c:211:202:f21c:9185:9405:36f])
 (user=justinstitt job=sendgmr) by 2002:a25:907:0:b0:66e:3f14:c463 with SMTP
 id 7-20020a250907000000b0066e3f14c463mr6447554ybj.243.1657325741218; Fri, 08
 Jul 2022 17:15:41 -0700 (PDT)
Date:   Fri,  8 Jul 2022 17:15:27 -0700
Message-Id: <20220709001527.618593-1-justinstitt@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH] mediatek: mt76: eeprom: fix clang -Wformat warning
From:   Justin Stitt <justinstitt@google.com>
To:     Jakub Kicinski <kubakici@wp.pl>, Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building with Clang we encounter the following warning:
| drivers/net/wireless/mediatek/mt7601u/eeprom.c:193:5: error: format
| specifies type 'char' but the argument has type 'int' [-Werror,-Wformat]
| chan_bounds[idx].start + chan_bounds[idx].num - 1);

Variadic functions (printf-like) undergo default argument promotion.
Documentation/core-api/printk-formats.rst specifically recommends using
the promoted-to-type's format flag.

Moreover, C11 6.3.1.1 states:
(https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1548.pdf) `If an int
can represent all values of the original type ..., the value is
converted to an int; otherwise, it is converted to an unsigned int.
These are called the integer promotions.`

With this information in hand, we really should stop using `%hh[dxu]` or
`%h[dxu]` as they usually prompt Clang -Wformat warnings as well as go
against documented standard recommendations.

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Note: produced warning with x86 allyesconfig.

 drivers/net/wireless/mediatek/mt7601u/eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/eeprom.c b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
index aa3b64902cf9..625bebe60538 100644
--- a/drivers/net/wireless/mediatek/mt7601u/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
@@ -188,7 +188,7 @@ mt7601u_set_country_reg(struct mt7601u_dev *dev, u8 *eeprom)
 
 	if (idx != -1)
 		dev_info(dev->dev,
-			 "EEPROM country region %02hhx (channels %hhd-%hhd)\n",
+			 "EEPROM country region %02x (channels %d-%d)\n",
 			 val, chan_bounds[idx].start,
 			 chan_bounds[idx].start + chan_bounds[idx].num - 1);
 	else
-- 
2.37.0.rc0.161.g10f37bed90-goog

