Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3AF4DBA23
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 22:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358215AbiCPVcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 17:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358108AbiCPVc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 17:32:29 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D8E27CF2
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 14:31:14 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a3-20020a5b0ac3000000b006288f395b25so2930201ybr.18
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 14:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Sppr1OS9CruOLejjk++CwGMO6tK4IY6RrP567+9z7Go=;
        b=cUUbrDv0wCM1dCYoVLBRpVW6lbnjJLGmf994bsLluq3xvbI50wZVitBfqTr8K/OM0/
         Fv92SnLdvEEg123lykqNVuI31cm2DjfFHFLtOJRWvLC9lPUR7SPUxDkuGjgyVMPHEvKy
         aVcgtC32ibp16QY+W7mCIKp4fMdu2wnHH4qvItfoeNMZT4T268l7QhJehKftmEHwlM4i
         vkg1x7j54tBhZ18ipBQf1o0iyqrIIwprDPLmAkM82B9X0tNBTkV0R+N3t76WbXIfx2wZ
         JdXZ0geG7vHrjnZV+a/oTJavh/AAk6joVVumbQP+yU6c5ChrVauPRmdppGkoHuYnKdIA
         ZOQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Sppr1OS9CruOLejjk++CwGMO6tK4IY6RrP567+9z7Go=;
        b=o186tCeYI4oKAZIZAY2l91TwmcKYs6NmgbayWqz4V0oaI74gisr69EGLFCYNF5MrwU
         AdoOOuavehwYpPy+arCAF8roGIPnJLOZAOmFIBdsXp3sN5JPUDz0Ds76Hc1gWeM/Z2ww
         80VNMQABJLW13HD81nJS82cem7qU9ig4e+Ti13UrAFdSjqhDnvvrw+fihmx+druegsu9
         CiDHw29itYYsI0wjDvFPCMU5NjCWInuNVlP0F863ygDaonK/2RTpWhBFvHugdtCY+X9A
         bGBpOTrruTUZHSMHz9PI8f7HYHpElOcskJ4OturUHwqzjMbyVApsMSqzX7sQzGd+2gtL
         zmZA==
X-Gm-Message-State: AOAM532DZNKRhe6KWwbWOXfZPL3RRmm00fZqkz2cd4lrVVvj8x6xbA4u
        9baTj5/uBfUQwBsTuM5tkDPYRAeX
X-Google-Smtp-Source: ABdhPJwu/38KY1T5f/RYMYQiU6iKi97m3qbHy1HRkpa1Zk+re0CBZHDdbQiOF386tyryOopU/0MKGhDSBg==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:7dae:6503:2272:5cd1])
 (user=morbo job=sendgmr) by 2002:a5b:f10:0:b0:628:8420:d694 with SMTP id
 x16-20020a5b0f10000000b006288420d694mr1979853ybr.483.1647466273437; Wed, 16
 Mar 2022 14:31:13 -0700 (PDT)
Date:   Wed, 16 Mar 2022 14:31:09 -0700
Message-Id: <20220316213109.2352015-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH] enetc: use correct format characters
From:   Bill Wendling <morbo@google.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Cc:     Bill Wendling <morbo@google.com>
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

When compiling with -Wformat, clang emits the following warning:

drivers/net/ethernet/freescale/enetc/enetc_mdio.c:151:22: warning:
format specifies type 'unsigned char' but the argument has type 'int'
[-Wformat]
                        phy_id, dev_addr, regnum);
                                          ^~~~~~
./include/linux/dev_printk.h:163:47: note: expanded from macro 'dev_dbg'
                dev_printk(KERN_DEBUG, dev, dev_fmt(fmt), ##__VA_ARGS__); \
                                                    ~~~     ^~~~~~~~~~~
./include/linux/dev_printk.h:129:34: note: expanded from macro 'dev_printk'
                _dev_printk(level, dev, fmt, ##__VA_ARGS__);            \
                                        ~~~    ^~~~~~~~~~~

The types of these arguments are unconditionally defined, so this patch
updates the format character to the correct ones for ints and unsigned
ints.

Link: ClangBuiltLinux/linux#378
Signed-off-by: Bill Wendling <morbo@google.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
index 70e6d97b380f..1c8f5cc6dec4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
@@ -147,7 +147,7 @@ int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 	/* return all Fs if nothing was there */
 	if (enetc_mdio_rd(mdio_priv, ENETC_MDIO_CFG) & MDIO_CFG_RD_ER) {
 		dev_dbg(&bus->dev,
-			"Error while reading PHY%d reg at %d.%hhu\n",
+			"Error while reading PHY%d reg at %d.%d\n",
 			phy_id, dev_addr, regnum);
 		return 0xffff;
 	}
-- 
2.35.1.723.g4982287a31-goog

