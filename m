Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A44B64F305
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 22:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiLPVLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 16:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiLPVLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 16:11:30 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C3361508;
        Fri, 16 Dec 2022 13:11:29 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 124so2646827pfy.0;
        Fri, 16 Dec 2022 13:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=limXE+sVuV7aUaAoF1fPZSdAt3/p7mO7Db46PmQRsl0=;
        b=IbToVEiAkpMx4YpuygfqhRQarf6XhQYOtrE78gOxW+e68ky/QCIHjBkltO1NRCltzB
         UN2ailQXq2+pNbPRZbi5CXzzF7WKy9y0qlhTRXxcsSJdLvYM+bOonsVFZjv5Lt1n1Ezh
         y7OBexT3v1MQ7EKR9f74Y7K1CrxSFr+rZE9JItXgTI+ok+93NAYbiuyE9a/A4L3/opon
         YBsEMBukFxMgQ8fU4xL+yUH8j3eE81G5oPA62+C8vveAe4us4ARaGevgI+lBYloQKnvA
         fWN7nS8zR8nUad+te4XjY+lSmw1i+pQVSnnW7tlMMkrOghb3OlNSraaFPaR/23gYi1Kb
         dk1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=limXE+sVuV7aUaAoF1fPZSdAt3/p7mO7Db46PmQRsl0=;
        b=tceYGylNt97pSfiLEauLYwcFEmWE0LzhR6ODTRQRnSUJZRdv+zvP1qQPyKfv9okbk4
         0ZodV4/dsVEdsLr4xQqTArlyvYk5TAs0IEz56NQwVxN41SMyN8h8uTn6K9ppFOft0jUv
         +52h8z6K3Bh+kPS1wgySATRhGGeEzvoh1s94kTS7iTBYYzHrBbigFpSOc9CzIOn+AL8Y
         WWUHdh/ko2lB0ihL0YfAAe82wFrrI6ydnyTGRU2uyi6KBm8VCk3uvXJCiDlzB9XOqEn7
         19xMDhFatVApvY6GJysxIPP+rOg2gVXQLEDgc1ELPwQmhLn7rvM3gZqbsYIhsd1ddKYh
         i3Tw==
X-Gm-Message-State: ANoB5pkzhM4E7DHx2fECOLbB/xQ9teYdpAhAExOjrqddK//C99RTwAYa
        /ANL/rcr77VCxjf0NzOL4YGJsN8pcThnDQ==
X-Google-Smtp-Source: AA0mqf4z34XFE8Gy41cPeCTK+bZuom4iJOb35oeSjn/Z8yy3H/wv6jwgj5DFCrYLxYWGsNp1doYlgA==
X-Received: by 2002:a62:36c7:0:b0:573:38f0:c8f5 with SMTP id d190-20020a6236c7000000b0057338f0c8f5mr34171445pfa.28.1671225089013;
        Fri, 16 Dec 2022 13:11:29 -0800 (PST)
Received: from localhost.localdomain ([14.5.161.132])
        by smtp.gmail.com with ESMTPSA id y189-20020a62cec6000000b005773bd639besm1981584pfg.10.2022.12.16.13.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 13:11:28 -0800 (PST)
From:   Kang Minchul <tegongkang@gmail.com>
To:     Alex Elder <elder@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kang Minchul <tegongkang@gmail.com>
Subject: [PATCH net-next v3] net: ipa: Remove redundant comparison with zero
Date:   Sat, 17 Dec 2022 06:11:24 +0900
Message-Id: <20221216211124.154459-1-tegongkang@gmail.com>
X-Mailer: git-send-email 2.34.1
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

platform_get_irq_byname() returns non-zero IRQ number on success,
and negative error number on failure.

So comparing return value with zero is unnecessary.

Signed-off-by: Kang Minchul <tegongkang@gmail.com>
---
 drivers/net/ipa/gsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index bea2da1c4c51..e05e94bd9ba0 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1302,7 +1302,7 @@ static int gsi_irq_init(struct gsi *gsi, struct platform_device *pdev)
 	int ret;
 
 	ret = platform_get_irq_byname(pdev, "gsi");
-	if (ret <= 0)
+	if (ret < 0)
 		return ret ? : -EINVAL;
 
 	gsi->irq = ret;
-- 
2.34.1

