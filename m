Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45667541C51
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 23:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382822AbiFGV6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 17:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383337AbiFGVxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 17:53:05 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEC4243BAE
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 12:11:32 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id i1so15607532plg.7
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 12:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4x0y2QOtFjngDKfaT5qelc7FJCWVTdt0sgBSsQXwCE0=;
        b=eHmJKxQLN7wtUiQ4NOfbbRm0UYnDGyzk72gCLWYI53P9WjH0RIwf6Sg6rC+JT9teK2
         tFgeD1AhuY7oexEw5rO0lF1GBF8Cz9XPuNRu24Qpc8+01U7xcQwe3xqAMEWEmvFLyBej
         JpF3cQOf9eEWaTCRCkoaOGa0O980JV7iyYVAx3DBD9xhdOUADaZ2c6GYvtEa2holGjYI
         I6LguBnG5E35TmdmFsCeYH0glPMWEKmWuJGJAYOCq+vmQYdZ/gPAvAKypTyFN1B40P9O
         adMS5H8iBAREvpZ7kM4SbgGzJ8LnMc2JXPfP8nmYWNHUKq+N7DvcGpgqAtKfX95IX+jF
         s25g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4x0y2QOtFjngDKfaT5qelc7FJCWVTdt0sgBSsQXwCE0=;
        b=kAQGy0LUwuTOh/spAq1nmsu/nI/5Pc1la0y+S5pHdU+qMQ4gzcbgVaOjOZVDQ90TU0
         6PEneWtPBKVOtm3H4PYdPCsW1f0kfqgLxvn8mD9NJXy4Rjuz0O1/FHqXqa+Ic1O8dB7e
         wtwmJw9LVB4ioKimhWoP3GcSMgNU0hCD3A/A7zEIm+bHygDu6IgF2MwppLpSJ18/a1eF
         LinGM272MZYiY2ApCfSigjv02DvZamQmoNvGJaWGQzrKFXkrPJuPPUhbiFiJZw5Ze+5c
         YS/HXJodMNch3SXfNRHmHOlvfNzpFbTBpjNuedzLz1/9sRwkOtP3xVuqGOWggcNYmYyg
         yuPQ==
X-Gm-Message-State: AOAM532+VGIZVTauBDdICKDxWEzNYKBQ7xWGqqQcmDmApSU4rXHqK6D8
        DintnRi1zlveGAafr+u2BRw=
X-Google-Smtp-Source: ABdhPJyVeaL+7PkM+tPf2NIFdB9NxjxGzs8Bd9iU4R/7V5NDbuFIKp+wiq9OK+n+urNHUzlvr2MFeA==
X-Received: by 2002:a17:903:290:b0:15c:1c87:e66c with SMTP id j16-20020a170903029000b0015c1c87e66cmr30703101plr.61.1654629091980;
        Tue, 07 Jun 2022 12:11:31 -0700 (PDT)
Received: from penguin.lxd ([2620:0:1000:2514:216:3eff:fe31:a1ca])
        by smtp.googlemail.com with ESMTPSA id go13-20020a17090b03cd00b001e667f932cdsm11713950pjb.53.2022.06.07.12.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 12:11:31 -0700 (PDT)
From:   Justin Stitt <jstitt007@gmail.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     llvm@lists.linux.dev, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        Justin Stitt <jstitt007@gmail.com>
Subject: [PATCH] net: amd-xgbe: fix clang -Wformat warning
Date:   Tue,  7 Jun 2022 12:11:19 -0700
Message-Id: <20220607191119.20686-1-jstitt007@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

see warning:
| drivers/net/ethernet/amd/xgbe/xgbe-drv.c:2787:43: warning: format specifies
| type 'unsigned short' but the argument has type 'int' [-Wformat]
|        netdev_dbg(netdev, "Protocol: %#06hx\n", ntohs(eth->h_proto));
|                                      ~~~~~~     ^~~~~~~~~~~~~~~~~~~

Variadic functions (printf-like) undergo default argument promotion.
Documentation/core-api/printk-formats.rst specifically recommends
using the promoted-to-type's format flag.

Also, as per C11 6.3.1.1:
(https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1548.pdf)
`If an int can represent all values of the original type ..., the
value is converted to an int; otherwise, it is converted to an
unsigned int. These are called the integer promotions.`

Since the argument is a u16 it will get promoted to an int and thus it is
most accurate to use the %x format specifier here. It should be noted that the
`#06` formatting sugar does not alter the promotion rules.

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Signed-off-by: Justin Stitt <jstitt007@gmail.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index a3593290886f..4d46780fad13 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2784,7 +2784,7 @@ void xgbe_print_pkt(struct net_device *netdev, struct sk_buff *skb, bool tx_rx)
 
 	netdev_dbg(netdev, "Dst MAC addr: %pM\n", eth->h_dest);
 	netdev_dbg(netdev, "Src MAC addr: %pM\n", eth->h_source);
-	netdev_dbg(netdev, "Protocol: %#06hx\n", ntohs(eth->h_proto));
+	netdev_dbg(netdev, "Protocol: %#06x\n", ntohs(eth->h_proto));
 
 	for (i = 0; i < skb->len; i += 32) {
 		unsigned int len = min(skb->len - i, 32U);
-- 
2.30.2

