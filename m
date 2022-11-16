Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC6A62B844
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 11:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbiKPK3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 05:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbiKPK2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 05:28:49 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56392F3AD;
        Wed, 16 Nov 2022 02:25:16 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id f18so9932832ejz.5;
        Wed, 16 Nov 2022 02:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QE2rgR+SD3txu2X9qQrvuHMcKPW65HWDIVU0aZ4LzFk=;
        b=iazRd6Fc4IJ8oSDNINndacd3WHizzJeIn0H+QfH3Of74DJw/qQ5uW6KWaKgH0nTiz1
         Ip1vrLgbFD15IY5QqSwGmrcWwWUrXp9mtg/uc93K2BCOiW9YCc7EsmWiNZ27CSCdv2tK
         DddMA/Qyalqljtfry5/e4DsmcJcGszv3HhoWnWDLKe12AA9FaCGlIp6KShAsgoGxYQ1m
         vRYY+91MO0cEX/mpzSEM/0+nYxGF7XCwOQVW1msRkKmy1ma9EYPT7GZg0licXKjEROoq
         0IyQHcg8R3A9pj4qq0K1aciDy02Y5WN9STTcdoenN9xjJQANUIz47kJtJQo2rx98PuKV
         BDCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QE2rgR+SD3txu2X9qQrvuHMcKPW65HWDIVU0aZ4LzFk=;
        b=0j/YXgw2D9Bf9Z0xMxf1SLevQQ2hxjLIU3iUG7WS1XXPhpxZDiddY0nTnlEPXNZl6Q
         fL9ym1ag41zyZwjyHveiivy3ZHBVcepieHVAWCQP/QF/6wGOYH2jPn940mv4+TNAMkZ5
         PwAQDZDsLZqs/zPAp24ZmGh6KFR84X7E0CJ5Vv4pY3HjK7Ez0T+dxhvJJdwW9arA28vv
         lKA5QlEf6vrS79IWPlE160yNnPyddCvydnwb/DpuimRgy4rw6vAaOc1RBqDL0hWayNTS
         U/gtaTSUu1M9qvlcsqS5UWDma8VqAzjS8PToJLx6s3veH6zjwxEn0tLmZM4cT6Vi65BX
         mvSA==
X-Gm-Message-State: ANoB5pn6wNZINGN8G3SlU3khyuBtVYFEpl/5HmZY69sGtuIWTNrbcDla
        hp2giK8V90kNJTtXJsuHTFk=
X-Google-Smtp-Source: AA0mqf4DxIr6lOh7UFZ8iVcc8DpYOp554VDVImChrKKz+ZA0VeEk13y/0Jljbf1po8KOTTxuR3d7rg==
X-Received: by 2002:a17:907:76d2:b0:78d:8c6b:397b with SMTP id kf18-20020a17090776d200b0078d8c6b397bmr16610397ejc.364.1668594314896;
        Wed, 16 Nov 2022 02:25:14 -0800 (PST)
Received: from felia.fritz.box (200116b826c55000c59461cca0b9a159.dip.versatel-1u1.de. [2001:16b8:26c5:5000:c594:61cc:a0b9:a159])
        by smtp.gmail.com with ESMTPSA id s5-20020a05640217c500b0045c010d0584sm7294352edy.47.2022.11.16.02.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 02:25:14 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] net: fman: remove reference to non-existing config PCS
Date:   Wed, 16 Nov 2022 11:24:50 +0100
Message-Id: <20221116102450.13928-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit a7c2a32e7f22 ("net: fman: memac: Use lynx pcs driver") makes the
Freescale Data-Path Acceleration Architecture Frame Manager use lynx pcs
driver by selecting PCS_LYNX.

It also selects the non-existing config PCS as well, which has no effect.

Remove this select to a non-existing config.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 drivers/net/ethernet/freescale/fman/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/Kconfig b/drivers/net/ethernet/freescale/fman/Kconfig
index e76a3d262b2b..a55542c1ad65 100644
--- a/drivers/net/ethernet/freescale/fman/Kconfig
+++ b/drivers/net/ethernet/freescale/fman/Kconfig
@@ -4,7 +4,6 @@ config FSL_FMAN
 	depends on FSL_SOC || ARCH_LAYERSCAPE || COMPILE_TEST
 	select GENERIC_ALLOCATOR
 	select PHYLINK
-	select PCS
 	select PCS_LYNX
 	select CRC32
 	default n
-- 
2.17.1

