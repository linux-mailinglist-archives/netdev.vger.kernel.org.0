Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAA34DB4BD
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357129AbiCPPU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357228AbiCPPU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:20:28 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF1664BEF
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:19:13 -0700 (PDT)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B35A43F4C0
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 15:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1647443951;
        bh=l6KBwGM0uiIwlc1rKLa9ZFBDgTPatr0zsqNmkU7zEfs=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=hnBMVm5NuJPHWUriNwJEAOlygXoDV5wbnmaQGBeNGuOR2ufAhiBRhADZ5jGjxW/jN
         5AadvsvS3O5L9v3mhL0W7zT/03qdMNrR9nubb7I/Jnk6gxQEBVH81vvgjTYrhxMD5k
         Yf672IqY3tzqVH8QZqAdY/9H4IswTQUNZ/ZK4ucawyxfyJEYyellQdPdklM7BTEPrn
         SfYY/WVrSYopzf2S96gnPaU//uWNVxHm6QdBCDwdveD5046ANkOu/SiQeQ2/lFPzfR
         qrgAGstoNxy+CkqxX7F3jPh6xaQv6SjA8ljmGNhXTEps1X7qGtiSzKVqqL38Myac3q
         ZFMLp+AuaQ8oQ==
Received: by mail-ej1-f71.google.com with SMTP id x2-20020a1709065ac200b006d9b316257fso1344546ejs.12
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:19:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l6KBwGM0uiIwlc1rKLa9ZFBDgTPatr0zsqNmkU7zEfs=;
        b=FZMnxR8/4447M6CY5p8UADcHcAliM/lI07vMHKOp2lJtFNmh6NnAPrteyEyUjUbbPU
         pJ1uP7ucWhoC8gOtP7p+CT5iweB6L2VCguj6Yu77unyOkmGQ+TzWJ+O+N0LDtYx4aPMB
         6gqsWrR0uQgaaNS4r1EBmctrygNkap8QKgXokMhfFmn5AymfBcFPFBp8VU6irn0gJxGq
         oY97VxVX0F5jF4EM94EJbSnYBzULsM73X+qm/+QMTsZVYNFFFNlQV/p6Ucz2zvNhboZ2
         OKP3vS9rZ1atWzdpwAmrVj/JqUYzNNurqWyt9dwQ+KOEzAgXY4l3NpIxv3vFeY4ke5YA
         09UQ==
X-Gm-Message-State: AOAM533psx+Kv0/3jAAfvcLYMqNOkf5wsSdbQEYIIGAEBIB8B2orgJfU
        8oE+3qWTE8c+BSK85YiklhmtCH5J9iaPAsDw+5UXJjuhrvgixAlLITkK6yH1nmcdEUMWPnRWVNR
        oAE2os2DnnJNV+P04RqYZmfZITFnk4nlgsA==
X-Received: by 2002:a17:906:58d2:b0:6da:b635:fbf3 with SMTP id e18-20020a17090658d200b006dab635fbf3mr432683ejs.40.1647443951296;
        Wed, 16 Mar 2022 08:19:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxoPSUJMHOAL6T3mNLew5/+8ilp8MWnQTCLDeDxeKP/9TPhEl9ftEH1knZ3RViNX+M9VfXG4g==
X-Received: by 2002:a17:906:58d2:b0:6da:b635:fbf3 with SMTP id e18-20020a17090658d200b006dab635fbf3mr432665ejs.40.1647443951025;
        Wed, 16 Mar 2022 08:19:11 -0700 (PDT)
Received: from localhost.localdomain ([194.191.244.86])
        by smtp.gmail.com with ESMTPSA id d8-20020a170906640800b006d5853081b7sm1016788ejm.70.2022.03.16.08.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:19:10 -0700 (PDT)
From:   Juerg Haefliger <juerg.haefliger@canonical.com>
X-Google-Original-From: Juerg Haefliger <juergh@canonical.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux@armlinux.org.uk
Cc:     linux-kernel@vger.kernel.org,
        Juerg Haefliger <juergh@canonical.com>
Subject: [PATCH] net: phy: mscc: Add MODULE_FIRMWARE macros
Date:   Wed, 16 Mar 2022 16:18:35 +0100
Message-Id: <20220316151835.88765-1-juergh@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver requires firmware so define MODULE_FIRMWARE so that modinfo
provides the details.

Signed-off-by: Juerg Haefliger <juergh@canonical.com>
---
 drivers/net/phy/mscc/mscc_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index ebfeeb3c67c1..7e3017e7a1c0 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2685,3 +2685,6 @@ MODULE_DEVICE_TABLE(mdio, vsc85xx_tbl);
 MODULE_DESCRIPTION("Microsemi VSC85xx PHY driver");
 MODULE_AUTHOR("Nagaraju Lakkaraju");
 MODULE_LICENSE("Dual MIT/GPL");
+
+MODULE_FIRMWARE(MSCC_VSC8584_REVB_INT8051_FW);
+MODULE_FIRMWARE(MSCC_VSC8574_REVB_INT8051_FW);
-- 
2.32.0

