Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5DB6BBA09
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 17:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjCOQl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 12:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbjCOQlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 12:41:07 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4EF168A2;
        Wed, 15 Mar 2023 09:40:01 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso1480059wmb.0;
        Wed, 15 Mar 2023 09:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678898354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r3JeHlD2DJ70R0jw0cbmmZc+e39yS+644tBOVlRHHhU=;
        b=laW2OFRHNWxZUIXhOuio/PYddOojdw3J825tBUJ7Nf8cpPknjCMn9CxIbDZLzokqNq
         g4tluzoQKVFHIbPSreqxpl9Nyk0E31QCK/o3ED3jsHpyCRZmjiLrl0Gh/0Yrt8kdUg+z
         iUvVQvHCxFYnAn49IgV5NFK0vRTFnQ2B66aFmopCRtB5/xux9yy57ISb6gXIlX0tWlFA
         SdOSUoiKCFXxGUr6vxNTy2d5s6KjUfLoA0suR8Grrxp9W432OsOoV8UMCdIbGQjSy5Sx
         IQfD39pNEOWOJ0TKwZlL2gQMsefSzEbyFpK9Oa54NeWQ8EOQxIEutwal/K9J6V8+x9BD
         +sLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678898354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r3JeHlD2DJ70R0jw0cbmmZc+e39yS+644tBOVlRHHhU=;
        b=MhBaf+4LskhNNahF6r4VzPIs/JvLrFXZympiOqvucxJrGlrLrohoRkJQK/7dIC0pCd
         /2XGrv7JDhPjROWhSwoIveLBcbu4gZwM45dY5GHynaOw/b45Laz2uLAt1Gh8ytAKnWnu
         cMFoTeV+p4rkomDRWtwWzkkulMwplJUy97FSCdX73KcgSNMfpApC6FUXxO8ax/dwZD89
         vOE1T3hI+Ua+EwaNqrfJLiDg2XMqqxkmVQuMd+kIkkMGZnMT6HZArcCE5oq/yYrkXI3y
         nz1oswOeEZFMcfRCc6oq5VRw/YLLAIwSlrPo4AGFQNhwRHAJmZYbkNmIJzt+tkyIUsV6
         k1/Q==
X-Gm-Message-State: AO0yUKVLSILdDjz7QGBGtCdEdOM6YkJy/oNnHoGV/iidVg47mp5JweXX
        0EzfOb/Iz3AoIUTNRBTPLYM=
X-Google-Smtp-Source: AK7set8dRCxmDf5+Ngr+B1lJ5b/aizEj5CNgsBalpJadCo/HLTnhjlkHYcYE2x/RmfCQ1kcASQfh8A==
X-Received: by 2002:a05:600c:c0b:b0:3ed:2dbf:6a80 with SMTP id fm11-20020a05600c0c0b00b003ed2dbf6a80mr4625223wmb.5.1678898353861;
        Wed, 15 Mar 2023 09:39:13 -0700 (PDT)
Received: from mars.. ([2a02:168:6806:0:839a:f879:3eb0:8b4e])
        by smtp.gmail.com with ESMTPSA id z17-20020a5d4d11000000b002c5a1bd527dsm5039595wrt.96.2023.03.15.09.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 09:39:13 -0700 (PDT)
From:   Klaus Kudielka <klaus.kudielka@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Klaus Kudielka <klaus.kudielka@gmail.com>
Subject: [PATCH net-next v4 4/4] net: dsa: mv88e6xxx: mask apparently non-existing phys during probing
Date:   Wed, 15 Mar 2023 17:38:46 +0100
Message-Id: <20230315163846.3114-5-klaus.kudielka@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315163846.3114-1-klaus.kudielka@gmail.com>
References: <20230315163846.3114-1-klaus.kudielka@gmail.com>
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

To avoid excessive mdio bus transactions during probing, mask all phy
addresses that do not exist (there is a 1:1 mapping between switch port
number and phy address).

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---

Notes:
    v2: Patch is new

 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 29b0f3bb1c..c52798d9ce 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3797,6 +3797,7 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 	bus->read_c45 = mv88e6xxx_mdio_read_c45;
 	bus->write_c45 = mv88e6xxx_mdio_write_c45;
 	bus->parent = chip->dev;
+	bus->phy_mask = GENMASK(31, mv88e6xxx_num_ports(chip));
 
 	if (!external) {
 		err = mv88e6xxx_g2_irq_mdio_setup(chip, bus);
-- 
2.39.2

