Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E20765773C
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 14:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbiL1NhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 08:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbiL1Ngm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 08:36:42 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8810AFCCB;
        Wed, 28 Dec 2022 05:36:40 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id t17so38406056eju.1;
        Wed, 28 Dec 2022 05:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d807py09DD3Qe4/u5U+I0QX5zsRCtWMK/ARKc6ylwQ8=;
        b=IIXsBoXeUkr+5VqJl+tmA3q8ykF7/iePNO1YUjQkz1bk78gN7+sUTIdid2y2esG/WG
         NCn2UiehP8nX2hbxuJurO4Z3g0VlXTrgUUVnIqbsz98Vgb5NPb44pyHiLs6xDMTP9kSH
         X+2oRJHyPqf3o6Ct9OlcBMQgmrdLw5gK5+qgdzRzRf29OGFsajzyYARKs5Gzu2ktqqxu
         h6TW2G7BNg6qMexOyFxZ2DGpxr8x8op1lhbE6BzSSthRMtz0FY05j2ngY81/bxNddt8n
         9ChlGQ3U9c2iMcmGbgR49u2lgJ8FoFknn6mBnV85aaL5MWEknLP7q1cJPB+HyljBi3Gr
         ERcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d807py09DD3Qe4/u5U+I0QX5zsRCtWMK/ARKc6ylwQ8=;
        b=xyYuDdmHtT+dw5jgcMgeeianmkWYY3KRW4/RqfRGZZ3HzulAbRBGQmd+hjc2XIXaby
         rdIxRYZoFxNQ+66hJJhTtA6Pz0yDQqbmEhuHxDPhtaPf5rM54aXQej2Ndx/22fHgN2Sp
         ap75OYBA4wryemHj1eVbMA3NHFN9ZKs1TAIEUunC76h7i7LnzO0MultP66HLH0P6kyzl
         X4h0/ktOez3SYhLZ4Ws4VUclsTZoPJqNkx2u6eBeovK6PtT2g0WkauQ8WWpqaM51vLRT
         0Iv3QZOjDbGGzBYHv3oxakhZErQa9XDikrp/RJP39wHNls9lJXfk8RiMYw+uQdZ7m7Eq
         C9nw==
X-Gm-Message-State: AFqh2kpan2s4a3q03BHhiGbrkNKz2+Ynv8Ut2O4Ic1/v6Vg1IbL+s3mM
        j3V/y0FPa8EsN+oMNgWOttnI06J57p8=
X-Google-Smtp-Source: AMrXdXuRWTaubbJK9yWRBILGJVgtdeYL5uiE1CLzyfTiDB/dlno4xBj06jBWIAnl777t2+IZeyIFNw==
X-Received: by 2002:a17:907:c712:b0:7bd:6372:fdb4 with SMTP id ty18-20020a170907c71200b007bd6372fdb4mr30778950ejc.41.1672234598895;
        Wed, 28 Dec 2022 05:36:38 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b830-5100-f22f-74ff-fe21-0725.c23.pool.telefonica.de. [2a01:c23:b830:5100:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id g3-20020a170906538300b0082535e2da13sm7450475ejo.6.2022.12.28.05.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 05:36:38 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, pkshih@realtek.com,
        tehuang@realtek.com, s.hauer@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 0/4] rtw88: Four fixes found while working on SDIO support
Date:   Wed, 28 Dec 2022 14:35:43 +0100
Message-Id: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
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

This series consists of three patches which are fixing existing
behavior (meaning: it either affects PCIe or USB or both) in the rtw88
driver.

The first change adds the packed attribute to the eFuse structs. This
was spotted by Ping-Ke while reviewing the SDIO support patches from
[0].

The remaining three changes relate to locking (barrier hold) problems.
We previously had discussed patches for this for SDIO support, but the
problem never ocurred while testing USB cards. It turns out that these
are still needed and I think that they also fix the same problems for
USB users (it's not clear how often it happens there though).

The issue fixed by the second and third patches have been spotted by a
user who tested rtw88 SDIO support. Everything is working fine for him
but there are warnings [1] and [2] in the kernel log stating "Voluntary
context switch within RCU read-side critical section!".

The solution in the third and fourth patch was actually suggested by
Ping-Ke in [3]. Thanks again!


[0] https://lore.kernel.org/linux-wireless/695c976e02ed44a2b2345a3ceb226fc4@realtek.com/
[1] https://github.com/LibreELEC/LibreELEC.tv/pull/7301#issuecomment-1366421445
[2] https://github.com/LibreELEC/LibreELEC.tv/pull/7301#issuecomment-1366610249
[3] https://lore.kernel.org/lkml/e0aa1ba4336ab130712e1fcb425e6fd0adca4145.camel@realtek.com/


Martin Blumenstingl (4):
  rtw88: Add packed attribute to the eFuse structs
  rtw88: Configure the registers from rtw_bf_assoc() outside the RCU
    lock
  rtw88: Use rtw_iterate_vifs() for rtw_vif_watch_dog_iter()
  rtw88: Use non-atomic rtw_iterate_stas() in rtw_ra_mask_info_update()

 drivers/net/wireless/realtek/rtw88/bf.c       | 13 ++++++------
 drivers/net/wireless/realtek/rtw88/mac80211.c |  4 +++-
 drivers/net/wireless/realtek/rtw88/main.c     |  6 ++++--
 drivers/net/wireless/realtek/rtw88/main.h     |  6 +++---
 drivers/net/wireless/realtek/rtw88/rtw8723d.h |  6 +++---
 drivers/net/wireless/realtek/rtw88/rtw8821c.h | 20 +++++++++----------
 drivers/net/wireless/realtek/rtw88/rtw8822b.h | 20 +++++++++----------
 drivers/net/wireless/realtek/rtw88/rtw8822c.h | 20 +++++++++----------
 8 files changed, 50 insertions(+), 45 deletions(-)

-- 
2.39.0

