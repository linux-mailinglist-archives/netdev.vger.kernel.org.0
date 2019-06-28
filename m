Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5791059177
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 04:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfF1CqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 22:46:21 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34081 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbfF1CqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 22:46:20 -0400
Received: by mail-pg1-f194.google.com with SMTP id p10so1907107pgn.1;
        Thu, 27 Jun 2019 19:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5SQb1rM39meuBB6kZ01b1gP2wTIZb8uQPRv3lqA/cvA=;
        b=Z4dN6KjCURldpDE4kGaLm1ZeeKEVwTFkwRp/H/b3yOb1MBNqibzC9yLToHL0Gr+mEO
         691TJP9Nfi5q+izFuEWZPCZL5YAc0y4MB4FqCfFBm47+xlv0lxaZc1nHJ1cUw3Y530u0
         fxUTxn70+WRMv9zMZqymvMq4aBj2MHDyIx3vM1qi5rmEEvqCveGp99n3FFXJSuaeybDU
         iFWDKqtc0NoPZwOGUO9nLWuhV1xamv8M9rGzQwXPH868ZctdbYybffDk4JIDT7rY6soT
         8U87lnIbsy4umme0RvX/ngkJBiWq5Zi9NQk5iv6R6pAuhWWFNZzhX7UHZdBmJEcJ/UYT
         1lNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5SQb1rM39meuBB6kZ01b1gP2wTIZb8uQPRv3lqA/cvA=;
        b=h8Sj1AjWALgvpA8WqO1BCLwzHPzz6q3e6PlgljtyBcLsnfM8D2CHDiTrkI/PF8Kg7x
         tXlWgIUoztRVJ6LPXPFI9oWurWUAPzOsvBK3+YRT74fpk4MYWJmUXSxwfDrcvczlyQLo
         8VWky44ixsgLGuGE0ildq8gSMKMFZYmSpPL3u34VenCm28xEjxCi3+1rBd3H9iJiPKGR
         8I9IREjX+oh4VGXnogzvmr5I7aV57ry8ojyFuxPQ15vwzFDNO2fIFEOsyVY0oEn6AcTg
         MiFRpUSGuoBPIbJaQcXt0pVePpEPNMZK4+49Q7k/N6C6XQC56i+ciyqrJf6dMa/rhGvY
         7/WQ==
X-Gm-Message-State: APjAAAWkYkhUZCH9HpIe8nHz2hcBZSD5Y3yh2g+dNLZf1cDNSzPI1DEP
        d4JABE+j2zaPWfuRfHuNm8iBJNUVzscKoA==
X-Google-Smtp-Source: APXvYqzi6C3bPWcXCtUhhnrB+6T7U5NBy1jrEcuFbM0+E15a3pNnUK8dKeozzqZoA0GJSpDAF4Dp/w==
X-Received: by 2002:a63:1b66:: with SMTP id b38mr6938032pgm.54.1561689980331;
        Thu, 27 Jun 2019 19:46:20 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id h26sm462584pfq.64.2019.06.27.19.46.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 19:46:19 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/27] atm: idt77252: remove memset after dma_alloc_coherent
Date:   Fri, 28 Jun 2019 10:46:13 +0800
Message-Id: <20190628024613.14929-1-huangfq.daxian@gmail.com>
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

