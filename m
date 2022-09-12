Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611E55B62F3
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 23:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbiILVp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 17:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiILVpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 17:45:20 -0400
Received: from mail-ua1-x949.google.com (mail-ua1-x949.google.com [IPv6:2607:f8b0:4864:20::949])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF642F65D
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 14:45:19 -0700 (PDT)
Received: by mail-ua1-x949.google.com with SMTP id 66-20020a9f2048000000b0039dcf9c5852so3060248uam.7
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 14:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=/Jj3vAgrEpX1DljkVFCcAOLTZJVyDl94mCsDlbaWTfw=;
        b=Xj4EIcIg6IC64GjjkVlNjsH5kct6/Y5PMdIvSRIi3mFav1MkwP8CBJBBQrgXLcWwZJ
         n8t2HweyN3IPZh88c7dXIZa6Ed+XYafUYg2Cu4YchtA1A/2VloWCU/68eTfZTc6P13m9
         MLDZKv3Ioa3XjGUz3RJWfA0dLhMLSEgBsgdrHEt+OdjvuBDTacKvup9GBbeV5aiT9KzF
         fQw3qMBTBXCttDB4/XfNbEsFPZGGOM4gPFH7T7L2JWdQHyy2/DDtWO1e2sCXmXYm+Efw
         Es6701+y0ZdBfst8o77qb828by0wmrKlEekuK8/s4SkkAboabONEVypQzd3GwFcRkrAY
         wlBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=/Jj3vAgrEpX1DljkVFCcAOLTZJVyDl94mCsDlbaWTfw=;
        b=PVafbgu+W3qxuiaT9EfHZardnxGNY/fRLhNDfp7cJzHcSEUfN/0c/YmXCja5PwY3NC
         6XMFJxCfO8KjvNBe+5+osHr+zy3YeJ5s5JRLJ69B/tynG3C3aJkLoby58+tEW+WtD5BW
         Poz2jxMgS3c3K6gkf8CtAv2qvvmz8VqbNVl6tgsAaysVfxUjWs7fwISb5meP+RUTOtsO
         uYZZzqMx2PxOXuTi9aGWLS3Mdaxf9kmYjErO+5ar9IhPIwNtB6U5K/r9bWuJQ4gCglRN
         WAEwqIJojoEh0Y0lelD+xObJ3CkyBSaIUARB5ju/hpGt4tq9IkvGHv2AFncjw4DYjI8U
         Om1Q==
X-Gm-Message-State: ACgBeo3tEwcAwDOwbuSGEARjv/1iuU0mUp6027zeU+tDmtfTHbOSkqBu
        Aji88rC2OucNjspSa33YsGt+WBk9Xw==
X-Google-Smtp-Source: AA6agR5bYG0ltKebN2EVuVafJrdOszZ3fazLf/V8UlLwcZfm4Mig7uNZ9aE/OA5z598Sg65ynpaau5hKow==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a67:ac09:0:b0:388:70e9:63a0 with SMTP id
 v9-20020a67ac09000000b0038870e963a0mr9253277vse.56.1663019118005; Mon, 12 Sep
 2022 14:45:18 -0700 (PDT)
Date:   Mon, 12 Sep 2022 14:45:10 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220912214510.929070-1-nhuck@google.com>
Subject: [PATCH] net: wwan: t7xx: Fix return type of t7xx_ccmni_start_xmit
From:   Nathan Huckleberry <nhuck@google.com>
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@linux.intel.com>,
        Liu Haijun <haijun.liu@mediatek.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ndo_start_xmit field in net_device_ops is expected to be of type
netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of t7xx_ccmni_start_xmit should be changed from int to
netdev_tx_t.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 drivers/net/wwan/t7xx/t7xx_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_netdev.c b/drivers/net/wwan/t7xx/t7xx_netdev.c
index c6b6547f2c6f..f71d3bc3b237 100644
--- a/drivers/net/wwan/t7xx/t7xx_netdev.c
+++ b/drivers/net/wwan/t7xx/t7xx_netdev.c
@@ -74,7 +74,7 @@ static int t7xx_ccmni_send_packet(struct t7xx_ccmni *ccmni, struct sk_buff *skb,
 	return 0;
 }
 
-static int t7xx_ccmni_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t t7xx_ccmni_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct t7xx_ccmni *ccmni = wwan_netdev_drvpriv(dev);
 	int skb_len = skb->len;
-- 
2.37.2.789.g6183377224-goog

