Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCC3653331
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 16:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbiLUPZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 10:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234605AbiLUPZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 10:25:47 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41355F68
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:43 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id r26so22442046edc.10
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HU1fM1Lkfa3GCTAXKr+w8jT2gXMcP3RN7DZ2MvUOkc8=;
        b=WtYsqbILYftz9L6zgOypJZRybELx1w/ZwOle04X7RjSeaOzSX9dfIq0MlOI00pcnjW
         w8VrrKfUe19RUPuUB8GtaYjdXRRd9Mf/ydmkXRgqWu8FV60YW1/kkpWfWF0owTOsTuTf
         DSJsdsGKZpyr/iewDGgSYILZhOTpYuLEKNX78jRIjQvuOICZPs5kWwBMNfXLn2reAf4U
         q+ch1/wBGACrelb1yYqQCO9xtPXtQMu7SdhtW7aix7YndS46sjLdo2+fhffTFI0tOX5e
         cQEh62Ts1JGOA7BMNPmq2EYDFwRjgksrsjTaMPFoRWGrmYcnQtfp7JAnDm3oeK2PbFp0
         34Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HU1fM1Lkfa3GCTAXKr+w8jT2gXMcP3RN7DZ2MvUOkc8=;
        b=kSaPiQOwGSnBrAuqACdl+b//Ow5uIofnizh29sa90lv563JBiDNn73ipIR4dmYsoEv
         4QPvFrdfFt7vZGfyoZVouJxmKtRUbpVTeJU4/A0lMHmz9T9dcIJ76jfOwZIVPo4To43W
         sVJ128XFpvP4HXGqg2lUOTlMxOcRGW1MdV9I9vGdrC4gEgyp7hip7LAA/ypJZteE6W16
         jjs8rwVRCDXXHH141uHnOd6zd3Dygh9kHcYa+ote/vRnEPREwPoT4qx3hao7LpLmuUc6
         xRbittJixbOMfEpj6rCbeOk/ZEJGT8nqiNtdsSchX/lLz22/gX+3SdpAO41KuI633KBz
         Z0KQ==
X-Gm-Message-State: AFqh2koZMVqu4rSE+Ikls5/1mv23J4VeX7ome+LZefYFC6DNnt7Gx7bb
        W3pBihHH1lOfftsvNp3rocaySAhNreJFpmcS
X-Google-Smtp-Source: AMrXdXtZz9fpR8hP9aUKNWjugy5IKldEiN3VoOl3UFA/+2MNt9/fVWOYL/jVZn0mGWFR1ULpR3yaQg==
X-Received: by 2002:a05:6402:38d:b0:46f:b2df:4e0b with SMTP id o13-20020a056402038d00b0046fb2df4e0bmr1836537edv.14.1671636341814;
        Wed, 21 Dec 2022 07:25:41 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id n19-20020aa7c793000000b0045cf4f72b04sm7105428eds.94.2022.12.21.07.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 07:25:41 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 01/18] can: tcan4x5x: Remove reserved register 0x814 from writable table
Date:   Wed, 21 Dec 2022 16:25:20 +0100
Message-Id: <20221221152537.751564-2-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221152537.751564-1-msp@baylibre.com>
References: <20221221152537.751564-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mentioned register is not writable. It is reserved and should not be
written.

Fixes: 39dbb21b6a29 ("can: tcan4x5x: Specify separate read/write ranges")
Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/tcan4x5x-regmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/m_can/tcan4x5x-regmap.c b/drivers/net/can/m_can/tcan4x5x-regmap.c
index 2b218ce04e9f..fafa6daa67e6 100644
--- a/drivers/net/can/m_can/tcan4x5x-regmap.c
+++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
@@ -95,7 +95,6 @@ static const struct regmap_range tcan4x5x_reg_table_wr_range[] = {
 	regmap_reg_range(0x000c, 0x0010),
 	/* Device configuration registers and Interrupt Flags*/
 	regmap_reg_range(0x0800, 0x080c),
-	regmap_reg_range(0x0814, 0x0814),
 	regmap_reg_range(0x0820, 0x0820),
 	regmap_reg_range(0x0830, 0x0830),
 	/* M_CAN */
-- 
2.38.1

