Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E546570CCE
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 23:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbiGKViI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 17:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiGKViH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 17:38:07 -0400
Received: from mail-ua1-x949.google.com (mail-ua1-x949.google.com [IPv6:2607:f8b0:4864:20::949])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B8D80486
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 14:38:06 -0700 (PDT)
Received: by mail-ua1-x949.google.com with SMTP id h11-20020ab0470b000000b003832767ad4eso919118uac.23
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 14:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=zHqFC2vAvLBhn+dr9vFDSM6RsrMGwj0OEAPrK2Tbzq8=;
        b=VTXLdAFTNd9UwJNVkky3hIozNLYY6mYM83YMxH8oGI4oLZBAwrAybsmBIb5wT4hiOp
         bdGWsm17JWHSCJzj49qhZRobzJj/cMC/zFrpRXnXqFDoInwf3JdxlvrDAWJZGhsTJcch
         UqKYp01WFjLcw6OpeHOtG8tmI5eii8XLUf7i1ZVfdU5Igxkj37TUP1Zb1KO0bHFDD1lq
         kuGrwfn8OQJCUwzPCCJ4y4gnAwUy0gtn0C1Z+DnLJZbKF4EEoW7lnKV/30evtMD6VW1+
         IGqFHOAYi+nDRuQEH5rVGt2b/P+iT6IuRMDfxQOEtoVoLo7alxaHnaDQ39NvfAs6Nr78
         1A9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=zHqFC2vAvLBhn+dr9vFDSM6RsrMGwj0OEAPrK2Tbzq8=;
        b=uyVqV1GJK4m+/fSc7nQt/ACjt0TmBe+qjY2UdEE3B/TyBKBt6Ti0nMP5bGf61k+7K/
         rjgVSM1SIWFJ6KfRs3sJ3m1Zzxl8kn2hw63RHoHYzCttP8HABPS0FlGIgcunuCY4AoEs
         6YxLXo/ncPscVuTr9srt8k1wSZn6y30sU/S04yFF/BvisfjPAM4OyUWZefamwE3UOYoL
         B0xP0uJaIZxP2+TgCxHXNhSHBIaaE/j/WfDNmSI/ZVevnWKZZV2xYV5z5xSmUHUFYrfJ
         p7d9DM5xKmzEilVIkOOj2svDGRsVjpLmqoCqZvD8StHYU7d0aye+2YLPk+RC0nIVn2Ur
         cyjg==
X-Gm-Message-State: AJIora9nlZzx8pKh1toLO4kWpv0i6pTmMwHGahGgTxcPFyhnGuvuPpIc
        NeFvkLAl20GKeQiWHh8bhpw7DfJFVmbxJsKnfw==
X-Google-Smtp-Source: AGRyM1t+1oh1h9sGwQmRmQGmeG2XnD9OhdrwpWmEnE6iE7hFzFQEg9WRj9cDgGkg4MOgmMnXwYe5lebG86W+m7D/eA==
X-Received: from justinstitt.mtv.corp.google.com ([2620:15c:211:202:4bd0:f760:5332:9f1c])
 (user=justinstitt job=sendgmr) by 2002:a0d:df48:0:b0:31c:973f:b444 with SMTP
 id i69-20020a0ddf48000000b0031c973fb444mr21768515ywe.119.1657574997770; Mon,
 11 Jul 2022 14:29:57 -0700 (PDT)
Date:   Mon, 11 Jul 2022 14:29:32 -0700
Message-Id: <20220711212932.1501592-1-justinstitt@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH] mediatek: mt7601u: fix clang -Wformat warning
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building with Clang we encounter this warning:
| drivers/net/wireless/mediatek/mt7601u/debugfs.c:92:6: error: format
| specifies type 'unsigned char' but the argument has type 'int'
| [-Werror,-Wformat] dev->ee->reg.start + dev->ee->reg.num - 1);

The format specifier used is `%hhu` which describes a u8. Both
`dev->ee->reg.start` and `.num` are u8 as well. However, the expression
as a whole is promoted to an int as you cannot get smaller-than-int from
addition. Therefore, to fix the warning, use the promoted-to-type's
format specifier -- in this case `%d`.

example:
```
uint8_t a = 4, b = 7;
int size = sizeof(a + b - 1);
printf("%d\n", size);
// output: 4
```

See more:
(https://wiki.sei.cmu.edu/confluence/display/c/INT02-C.+Understand+integer+conversion+rules)
"Integer types smaller than int are promoted when an operation is
performed on them. If all values of the original type can be represented
as an int, the value of the smaller type is converted to an int;
otherwise, it is converted to an unsigned int."

Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Note: This patch silences the -Wformat warning for this file (which is
the goal) but in reality all instances of `%hh[dux]` should be converted
to `%[dux]` for this file and probably every file. That's a bit larger
scope than the goal of enabling -Wformat for Clang builds, though.

 drivers/net/wireless/mediatek/mt7601u/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/debugfs.c b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
index 20669eacb66e..230b0e1061a7 100644
--- a/drivers/net/wireless/mediatek/mt7601u/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
@@ -88,7 +88,7 @@ mt7601u_eeprom_param_show(struct seq_file *file, void *data)
 		   dev->ee->rssi_offset[0], dev->ee->rssi_offset[1]);
 	seq_printf(file, "Reference temp: %hhx\n", dev->ee->ref_temp);
 	seq_printf(file, "LNA gain: %hhx\n", dev->ee->lna_gain);
-	seq_printf(file, "Reg channels: %hhu-%hhu\n", dev->ee->reg.start,
+	seq_printf(file, "Reg channels: %hhu-%d\n", dev->ee->reg.start,
 		   dev->ee->reg.start + dev->ee->reg.num - 1);
 
 	seq_puts(file, "Per rate power:\n");
-- 
2.37.0.144.g8ac04bfd2-goog

