Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F266623E53
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 10:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiKJJMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 04:12:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiKJJMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 04:12:00 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E0269DF2
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 01:11:56 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id v27so2130017eda.1
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 01:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=timesys-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HatXbN02WnkWWa743XuxxCmNp7tmlfah7GOKGkEZ69A=;
        b=1HiA71OitIb/yQFMYq56gx+qIDWAgUPoBBoDlpQ2JHqTQsC1bHfem9YVPHcxVQZd+0
         xqa/i+IlMjYw+MinncP+B3FoPBy/B9D2Bl8gaEKyWZwkxIT4AUO5a/lsFJ7VqJim/gfj
         RD/hoiudK63Pclg72Guc2Fsn1HA8CEWOvo4mocSI2Cti0xOvWAtK/p42yLfopMNIPVIr
         MzwFkf3x+vTSuC/sSlFLGFEKCdiUdVM65HbeETMYu6I/j0fr7M2r0+5AdkWgeZJXuu79
         ZS8eztzkBh5ZJc4b2zkISSxrEls0H3OkXQF5+hhepmT4ACkh7ifjBvwp3zTmOtNMpWGr
         jmPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HatXbN02WnkWWa743XuxxCmNp7tmlfah7GOKGkEZ69A=;
        b=oBO9upf8au044crjfj8PwYfdNAxEd1mhXBaQQA9IHKHoThM8GGcSt4IqUjlUJELdaF
         cIoP5b69DwFWzhM1D2p6bwLGUOU7VETkblZpo2kn9Vej4B+/r5WRIdMyy7P/p41R2ABy
         dwuAkl/yberKzg4/Bb/ArPg88WPABlV0dCC4Ix95zC7OGRKfTPm2dciNm87LQRbI29al
         d4x/+Nqz8TVFDTouSsEdsRao6KGz+f6MmHWiFwHS8QrIvdmcUirOzcHe3IyU5tqFJMBV
         lxLkRshB/S1lx7h+Oi2ZzNhi92z94d9QJccCA2B+GuHsewSpPso3H3Fk3NiizJqbsnee
         MwWw==
X-Gm-Message-State: ACrzQf1dicL+iALPK0DaQSyeZRiOXisBJ7GLnXVr1B5n2yhBW8yFvULQ
        lV41hh7eS/xnwwNtESUjbbjZZA==
X-Google-Smtp-Source: AMsMyM4fpyqW25ybtT2VTxJ+vwNxdmsQhC8inxXZ7tZyPX19djs8w8p+yJV+e568OJlxzwRe64Hr9Q==
X-Received: by 2002:a05:6402:1cc1:b0:453:1517:94e4 with SMTP id ds1-20020a0564021cc100b00453151794e4mr62554882edb.399.1668071514849;
        Thu, 10 Nov 2022 01:11:54 -0800 (PST)
Received: from localhost.localdomain (host-87-8-57-39.retail.telecomitalia.it. [87.8.57.39])
        by smtp.gmail.com with ESMTPSA id rk7-20020a170907214700b0078dce9984afsm6927100ejb.220.2022.11.10.01.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 01:11:54 -0800 (PST)
From:   Angelo Dureghello <angelo.dureghello@timesys.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org,
        Angelo Dureghello <angelo.dureghello@timesys.com>
Subject: [PATCH v2] net: dsa: mv88e6xxx: enable set_policy
Date:   Thu, 10 Nov 2022 10:10:27 +0100
Message-Id: <20221110091027.998073-1-angelo.dureghello@timesys.com>
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
Changes for v2:
- enable set_policy also for mv88e6320, since of same family.
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 2479be3a1e35..3cbe02aa8018 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5031,6 +5031,7 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
 	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
@@ -5075,6 +5076,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
 	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
-- 
2.38.1

