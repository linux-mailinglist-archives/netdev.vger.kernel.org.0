Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8D4758879
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfF0Re7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:34:59 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38544 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfF0Re6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:34:58 -0400
Received: by mail-pf1-f194.google.com with SMTP id y15so1581620pfn.5;
        Thu, 27 Jun 2019 10:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5SQb1rM39meuBB6kZ01b1gP2wTIZb8uQPRv3lqA/cvA=;
        b=cY5DlXyQ+i0vhpdExXlsOUtFFIO16il000fSXYrPn2u0s7GeRJUhWpHvmoUiM3LiX+
         dHH/gjqmdWDBW2Qo/dZYgEG4Q+MFV8oU4ZtAItun2i547Hg5I2RRb2juwL5pVjhKQFps
         8+M4lIcmQP5yx5oiGC0efgdIb2CZJFzEwY4R7vx1LEBiP8qaKxDRJrVoLF+TLrYYyLQi
         oVCu5Yzno/5m9E+2IA+g1OGxCrx9P2kd2EycBozkh/G0MC9UPlWBMGg9SR6p9zQ4Ce8I
         apkzuUJ7rbmF2Smv4k/JhGVpdta2me5N677FpM+wmwOJnkZh3EeRCsawk9uAuy6FqBjj
         +Exw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5SQb1rM39meuBB6kZ01b1gP2wTIZb8uQPRv3lqA/cvA=;
        b=A/3Hf0UwCuXXhjEHagkFkGOJ2ZhaHr5xnTBVMYNDUq5SeM2gAmfv3eGGaixZE/kcPe
         99g9WXl/dmfqQToWq/A4PZ7RADddbzZyocfoBMhRV0PFvnNeRR2xehWeQ6iyulDmTraP
         X9+9ZB4QofqwQJQx2lFY0w79Tfow3AWoMXoC0qXzzj16bmYLY77wY5FPg5ga5NHavIi1
         kJW6p1trO69SNBjqjchwd+KQXYLYzyYNSnwNm/9v5r+FIcAjWD943Ji+Re5kp7HADYiB
         DbsBUxBar273HcRBNdkIdFNz9oXGq4zXXuF+N19wRWnpaNRn65I9MuiUxLYM4Obw2QyQ
         HgvQ==
X-Gm-Message-State: APjAAAWoeBLTS+kuwUcJ4EQj4AQQl0WuXUriou19hD4w9KKt4AQnTqEL
        PdRyTSZToU9VkdMu4ofDEQxiwKt2AzQ=
X-Google-Smtp-Source: APXvYqwvrvA6qwgW7DKHNtt68qgVGeHRp0MZ8M5wwwO2Zvvu09444JQq2IIE9hv3tCfJDP2UxVG2rQ==
X-Received: by 2002:a63:ed13:: with SMTP id d19mr4845247pgi.100.1561656898277;
        Thu, 27 Jun 2019 10:34:58 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id y23sm5623700pfo.106.2019.06.27.10.34.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:34:57 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/87] atm: idt77252: Remove call to memset after dma_alloc_coherent
Date:   Fri, 28 Jun 2019 01:34:51 +0800
Message-Id: <20190627173451.2245-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/atm/idt77252.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 43a14579e80e..df51680e8931 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -1379,7 +1379,6 @@ init_tsq(struct idt77252_dev *card)
 		printk("%s: can't allocate TSQ.\n", card->name);
 		return -1;
 	}
-	memset(card->tsq.base, 0, TSQSIZE);
 
 	card->tsq.last = card->tsq.base + TSQ_NUM_ENTRIES - 1;
 	card->tsq.next = card->tsq.last;
-- 
2.11.0

