Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3CF68EB04
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 10:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjBHJVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 04:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbjBHJUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 04:20:40 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065BA47405
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 01:18:08 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id p9so3641480ejj.1
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 01:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HaQvqlEgokcy6/EGaLptwrwzxlWJe//6zHxL+sHpt84=;
        b=B8HsohgJVuNRUV8hlLmUEqm9BN8ha4HoyBmlKDmI5c7LU54LZ048kdUiEmWwVf4GZv
         8uUUqprZZ9qD2bEbWg6VGz9IX45cofm4IRVQ2bO31K9qXrJcFA9OXIKvHYy1oBCy4BRp
         aeFes9GhwbaGDJ4ObMwLQzKfOdHTfs8ikPK/QS0QhM2DbglSgQrxc/tHvZl+SXjmhI8T
         hCN4WOnROiA+gVHvy1GeWo8tFv0Tksb7CUZLrDWJM4S9BLiUgaA5EDX8A09GoXO0ZTgN
         0gIKhAVN4JQF2r9eaFpTNjMRNJFpd3CmmO4xgz8xySGtdd234grIzXcLAoQV7BYiO7ek
         EGag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HaQvqlEgokcy6/EGaLptwrwzxlWJe//6zHxL+sHpt84=;
        b=PwFJ/sjRjNy82kBuNQ1S7i1W1hxM0lhy7uXLhGhxw2WcmHWIh0m5QBl+1TXc9Or8FI
         F0sjIzEUOya7QPDT8yRHD650LNnq92RSwpscQTFn0teBXxHrCwbBj+Zc4MMv/51VX1eO
         mkhwrfBya6ErfrR7kU9OfmRWrN8W1frekTGwdYXcHl4OouW5VBSEH/vt9AqA4rWqBZ+r
         JcZsGSek5oxRxGf9FIkRmDP4zVXVnf1wrYIBXst5pEZFzeBipmfu9lk97UbigsFal1Iz
         w+V10T3+PhH7ITXkf8mLaIKjSMnKBM4l3McSBj+Ah+G5xnMG6GjjRZeaGMcz92oM1BXf
         yUnQ==
X-Gm-Message-State: AO0yUKXOSoHjaFY0JN31S22IAWW0iZp/J3h6yDGfPLzp0G37iWI3Ca5D
        raoY8ybos2qBy1cx5YJUbeE=
X-Google-Smtp-Source: AK7set8lyYn+YdLECIJU9uwx78HYrb/I0lsDrYSsAhsuN1kPMWyqViYEKU6C2PwGqrJcDpvYq7GIeg==
X-Received: by 2002:a17:906:1286:b0:886:50d:be8d with SMTP id k6-20020a170906128600b00886050dbe8dmr7610705ejb.13.1675847886135;
        Wed, 08 Feb 2023 01:18:06 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id d10-20020a17090692ca00b0088f8ae18b6bsm8042076ejx.189.2023.02.08.01.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 01:18:05 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        bcm-kernel-feedback-list@broadcom.com
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Jon Mason <jdmason@kudzu.us>
Subject: [PATCH net] net: bgmac: fix BCM5358 support by setting correct flags
Date:   Wed,  8 Feb 2023 10:16:37 +0100
Message-Id: <20230208091637.16291-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Rafał Miłecki <rafal@milecki.pl>

Code blocks handling BCMA_CHIP_ID_BCM5357 and BCMA_CHIP_ID_BCM53572 were
incorrectly unified. Chip package values are not unique and cannot be
checked independently. They are meaningful only in a context of a given
chip.

Packages BCM5358 and BCM47188 share the same value but then belong to
different chips. Code unification resulted in treating BCM5358 as
BCM47188 and broke its initialization.

Link: https://github.com/openwrt/openwrt/issues/8278
Fixes: cb1b0f90acfe ("net: ethernet: bgmac: unify code of the same family")
Cc: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/ethernet/broadcom/bgmac-bcma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma.c b/drivers/net/ethernet/broadcom/bgmac-bcma.c
index 02bd3cf9a260..6e4f36aaf5db 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma.c
@@ -240,12 +240,12 @@ static int bgmac_probe(struct bcma_device *core)
 		bgmac->feature_flags |= BGMAC_FEAT_CLKCTLST;
 		bgmac->feature_flags |= BGMAC_FEAT_FLW_CTRL1;
 		bgmac->feature_flags |= BGMAC_FEAT_SW_TYPE_PHY;
-		if (ci->pkg == BCMA_PKG_ID_BCM47188 ||
-		    ci->pkg == BCMA_PKG_ID_BCM47186) {
+		if ((ci->id == BCMA_CHIP_ID_BCM5357 && ci->pkg == BCMA_PKG_ID_BCM47186) ||
+		    (ci->id == BCMA_CHIP_ID_BCM53572 && ci->pkg == BCMA_PKG_ID_BCM47188)) {
 			bgmac->feature_flags |= BGMAC_FEAT_SW_TYPE_RGMII;
 			bgmac->feature_flags |= BGMAC_FEAT_IOST_ATTACHED;
 		}
-		if (ci->pkg == BCMA_PKG_ID_BCM5358)
+		if (ci->id == BCMA_CHIP_ID_BCM5357 && ci->pkg == BCMA_PKG_ID_BCM5358)
 			bgmac->feature_flags |= BGMAC_FEAT_SW_TYPE_EPHYRMII;
 		break;
 	case BCMA_CHIP_ID_BCM53573:
-- 
2.34.1

