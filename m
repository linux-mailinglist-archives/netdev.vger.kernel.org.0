Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F426B8D3F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 09:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjCNIZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 04:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbjCNIYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:24:41 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F02493855;
        Tue, 14 Mar 2023 01:23:19 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso12522903wmq.1;
        Tue, 14 Mar 2023 01:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678782197;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dqZkrCAWu+hXPTE7zS1DdbqNadZAkw4Sc37GhSVGqcg=;
        b=GrrBho6Y/psw/haQUt8S/5YDoIljaVJaWVG3AQH/jQ0Ez3x8Oh02MmesNzijQ/xkQJ
         OephBJ6QHLvocFqBdSGZiIWwgB8QH+0dYBtnauEA+VsjkETV3DxQmcxTuVQJXYnvNoTG
         RnsYekQPKcwebea3aK8nmgaqIww4d4iy0vIRHtgApVRQknYLSFBzU6G2qJyhGkhXXCvy
         dr2RVSuslyKrypgbwkhybIjRa5kjsL3ygInri/bm31ggKyAQ5b0hF7Ikd4p6bri/809Y
         uat/oYo/C6tcsWIacyL1wzrE0XOMFTzcjbWS3lkjM2Kf2Bb9O192jCV7XsuTVl2IrT7o
         oCBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678782197;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dqZkrCAWu+hXPTE7zS1DdbqNadZAkw4Sc37GhSVGqcg=;
        b=rxXpzex9cQizngMewUttLGcfExidK5S5HQIyzSiznGf6xll2wHo2STJXh7+tGVaNe1
         Pb3ZPgyCI/1HnUU0daAxgKBAzc9nDjsHhdSVI/6/NjPbrGrG6lpljOspUhrVLqMUPEI2
         NjiJof/PzTila4b6W6FcNjnwuB6nPt0qc2FzDshVdlhEQiw7NZViNXCWjREpvJhd1nin
         opCwCp0Cu93M4+skgmsRUTtgTbWoj+S/vjs+McTIwPs6hWVouuQOPS2hCHrvo4nEsnMV
         WHXtG/+fegyqtzgr0aMzOkHmHwiMdBW8vDUrnbVeBGoteDlGhhtBZzYTqEijSQw522z2
         t4mQ==
X-Gm-Message-State: AO0yUKXwlsT94upTtgx8q7241zFkLSEnpcXI0X3y1o8+ocpGNu6wlmW7
        w+qa+NMViElYYfOhFBzmm+M=
X-Google-Smtp-Source: AK7set+B9FkFd8u10HcJUHbtuQGGGbz+HXHNFAHRAGmN1CJ8fvvrERszDJHQ1H0ynjhYzZ+Njy92bg==
X-Received: by 2002:a05:600c:4f08:b0:3ea:e554:7815 with SMTP id l8-20020a05600c4f0800b003eae5547815mr14544496wmq.9.1678782196940;
        Tue, 14 Mar 2023 01:23:16 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id t10-20020a1c770a000000b003e9ded91c27sm2146847wmi.4.2023.03.14.01.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 01:23:16 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: phy: micrel: Fix spelling mistake "minimim" -> "minimum"
Date:   Tue, 14 Mar 2023 08:23:15 +0000
Message-Id: <20230314082315.26532-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

There is a spelling mistake in a pr_warn_ratelimited message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/phy/micrel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index e5b2af69ac03..e3d3959cf2be 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -4108,7 +4108,7 @@ static int lan8841_ptp_perout(struct ptp_clock_info *ptp,
 	period_nsec = timespec64_to_ns(&ts_period);
 
 	if (period_nsec < 200) {
-		pr_warn_ratelimited("%s: perout period too small, minimim is 200 nsec\n",
+		pr_warn_ratelimited("%s: perout period too small, minimum is 200 nsec\n",
 				    phydev_name(phydev));
 		return -EOPNOTSUPP;
 	}
-- 
2.30.2

