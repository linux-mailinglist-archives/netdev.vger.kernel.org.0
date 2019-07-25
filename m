Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA8874309
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 03:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388527AbfGYB4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 21:56:21 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:41613 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387820AbfGYB4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 21:56:20 -0400
Received: by mail-io1-f65.google.com with SMTP id j5so89677701ioj.8;
        Wed, 24 Jul 2019 18:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qevhiXyEkOEohVJW3YzRivh0Gax/OIllMhMhZOJIHME=;
        b=TBFGwqbj3nbU65GLBrBZl71FwhcyOLJT3oy7f6HQ4p7OWd1UZhw3x6ghQj+GOX+qhr
         +DszMCfhiI1rXxU1HPJomwyCL1toRYPMPdvV1xqcO4NLpS+9TEPeRygIgPOOXwZEFMIt
         4dTKKRc1M41Xg7MAQpy1PNbRPjn/eADt2UQGCZHrFmKVD1/F7yiO85nWWByvpbqsYTUc
         fZNNK1dKeA17LldaN3EXLn8m+8mO17RTcLdZ+yh4NCOFvhQkbWOdelQOZDolVeFc0oqT
         82qWfZ7CiPdzuMuoytedxXQCIu10RyXWGymZ+aRg6cLH9bcZv+6l3R7EAC/2BlsL2Ede
         Z9tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qevhiXyEkOEohVJW3YzRivh0Gax/OIllMhMhZOJIHME=;
        b=JY9ckdhqCsQxpVmOlzxHJuYEk0WuCWqfjBcY+wf7nfdWwIyY0WWx2ZcmFsJ1hMvBew
         tNRV1EbHoLd97PzGoYmuL1hSRUDjTM6lCkmnS7nSwwwgjt7EITl+MuceCUJTHhw9k9nT
         qrWuvSBqz+boBwp4PXVexN/Erj7nLcrkHOC35ZzysB/+eahvPY+yCrqIE0jb/8qTwvZp
         tRmhH5UgPsx4KlyNszu6MlbzObh4Q1OsfZz8YNOfBT/H6AHrBCHe8uocnh98kdw+63G/
         rjDA2050xSfdJnefY2RmPo9XZs5rk59py36gK2oi1G49Uvcbso3WxJqiYHxsarnvMHvh
         bwbw==
X-Gm-Message-State: APjAAAXq5pnUTQpZpzgqYBlDimEta/IqTm7I1rfSX7t9V9jkzUt/VKbm
        VVRTR/O1+8GHS1kBwK6wMkY=
X-Google-Smtp-Source: APXvYqx8tccydlT5uM42UOdOEystMy52xKNIp/ebeNlBVZV+/HV7vIDYOpojHdALAR4RTxu/IW9lHg==
X-Received: by 2002:a5d:8ccc:: with SMTP id k12mr79818851iot.141.1564019779646;
        Wed, 24 Jul 2019 18:56:19 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id n22sm80119216iob.37.2019.07.24.18.56.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 18:56:19 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        secalert@redhat.com, Navid Emamdoost <navid.emamdoost@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: mscc: ocelot: null check devm_kcalloc
Date:   Wed, 24 Jul 2019 20:56:09 -0500
Message-Id: <20190725015609.24389-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devm_kcalloc may fail and return NULL. Added the null check.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/ethernet/mscc/ocelot_board.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 58bde1a9eacb..52377cfdc31a 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -257,6 +257,8 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 	ocelot->ports = devm_kcalloc(&pdev->dev, ocelot->num_phys_ports,
 				     sizeof(struct ocelot_port *), GFP_KERNEL);
+	if (!ocelot->ports)
+		return -ENOMEM;
 
 	INIT_LIST_HEAD(&ocelot->multicast);
 	ocelot_init(ocelot);
-- 
2.17.1

