Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C5B622AA7
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiKILhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiKILgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:36:50 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9704C27B20
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 03:36:49 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id n12so45789990eja.11
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 03:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=timesys-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UY2maBEIsSaPGonhH7Zug1vnGHGtkFRD1T5I7sOXlVM=;
        b=heaBRErbYjC+jZHx+uu3VF2GKDIWQ/DdZhTO9NrlfAkvEjdniomObZ+eW8yi2H5pbH
         3XWczHqE/SoHNZVfjplwP4cRApKhYCwB1RzoB4hqUTTlWq5+4WROXeCDKIw5IIyVpEDr
         nxYsn2RSO5xn5PcVEkyJt2IHoVdMpQoqNS1giDh6DCk7gM7ALm4iAapjpIUZz4UOZ7Va
         GDlmi5ywAtNglx1h1xJowKs9gU6ve4it+naUBoGOt/zWH5eTzf7scs7vWRvrGs4dVltw
         SkuOLeySMUUMlLkasPHx+P/CE6DERbJwLTPv+C6NHe/ECrxR4tJQxpIbPAn/H1qVZOLj
         yqkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UY2maBEIsSaPGonhH7Zug1vnGHGtkFRD1T5I7sOXlVM=;
        b=WPRa1dvPu79JI//E0BKWMLDyxwMSLiiw7vfEd8Z2dyAhM4X2/g75KSFesDXN/rA0cJ
         JX5aR73qpQBQCTsU//dnltpxiOtbPD6vsDPltCx5uFCYvlLnL79EmjqRqJKnOGKG2pF8
         1Rx/M12myZFA0RS0EWxsmlbjLLCvjewgxKUM/IX41FMRY1ahsu4U83Hyity3usyNoYk+
         qsq5KhixK4TrgS6XQGYjvfCdpX5G78CrnsGyvoMZMGcyIPe0g9ZbG42etiOeDl+ARATP
         DBTlrSqBRDN7Jx/rSb5t2b1GKNRNfPKLs8nT20Easc51CLDTgti4A4bdwzWcLxXbnrJ6
         l4gg==
X-Gm-Message-State: ACrzQf2c7k1OFrjds0/Aii1zB+Gl8Mkh8gqQX1sEqPlYO+yKYHVt2Sa4
        PzRVM6MoNy80KhHmk9yeKkzNSQ==
X-Google-Smtp-Source: AMsMyM4Fo6V/S4LWI75oyZYpWIX40lwEsUNVVjeWm/UPYBPxt6r+HpCgjyuD3BA4TNrWeMdm9dl2VQ==
X-Received: by 2002:a17:907:8a09:b0:7ad:adff:ddf6 with SMTP id sc9-20020a1709078a0900b007adadffddf6mr57990814ejc.320.1667993808163;
        Wed, 09 Nov 2022 03:36:48 -0800 (PST)
Received: from localhost.localdomain (host-87-8-57-39.retail.telecomitalia.it. [87.8.57.39])
        by smtp.gmail.com with ESMTPSA id c17-20020a17090618b100b0073d7bef38e3sm643111ejf.45.2022.11.09.03.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 03:36:47 -0800 (PST)
From:   Angelo Dureghello <angelo.dureghello@timesys.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org,
        Angelo Dureghello <angelo.dureghello@timesys.com>
Subject: [PATCH] net: dsa: mv88e6xxx: enable set_policy
Date:   Wed,  9 Nov 2022 12:35:21 +0100
Message-Id: <20221109113521.240054-1-angelo.dureghello@timesys.com>
X-Mailer: git-send-email 2.38.1
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

Enabling set_policy capability for mv88e6321.

Signed-off-by: Angelo Dureghello <angelo.dureghello@timesys.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 2479be3a1e35..78648c80dbc3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5075,6 +5075,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
 	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
-- 
2.38.1

