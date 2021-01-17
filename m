Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD6C2F947A
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 19:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbhAQSRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 13:17:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729632AbhAQSQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 13:16:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610907327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=kLX4rjXMuZVOcW60dYfHUGcg3ri1M4DH6zvIU3aqXdA=;
        b=cuSbrRmL2mwiTJLTmqlKQkehodaDT+I/zTdgbzOXCgehyUJ07j7q7Rl7Rab4PeY287Q9zK
        kiTOT6PEORMeMDn4tov5sBdU5fz2aE1JyEN6ZkS267+8ZXaQifp1TNnjNzp2zZ8t21k6pR
        OcBQJ5xILqMe43eH5zlIpmcN1DMaXi4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-aof-KPsCMdmHlZVeYs9yyw-1; Sun, 17 Jan 2021 13:15:25 -0500
X-MC-Unique: aof-KPsCMdmHlZVeYs9yyw-1
Received: by mail-qv1-f70.google.com with SMTP id j5so14062700qvu.22
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 10:15:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kLX4rjXMuZVOcW60dYfHUGcg3ri1M4DH6zvIU3aqXdA=;
        b=GSMF4oZunf7WOwLNqDYnPVp/UdkmN1vzC3yyEkdZXBme/JKXdY4Bnxw5xk4iby3Iw3
         vqPu2ZyoMqA97NFE+ZBNaLWrsdWvHs7OYwJmCb8eKTTcecwc/yjHxHmyxYIsold+s47+
         2BLSIv1CNVi/eSa3MIlvKr+su06IgoTqpk3p4ZftQ8ftEQW11xhptoZgWg16qQnwlKk+
         RunMiXSg45AFmqHwgIRUTbg0RjAxrGGSOmhO61uBH1S0837h91Q6FqU73dDY2kz8YuBD
         E3OUzrLqd6qiGRr/hZZ/GN4ZyKmBTIzAmL6kdpONMiiQwRSBHY2OUCnL1mB3Fx++vGKg
         6qKw==
X-Gm-Message-State: AOAM5313b5SsUcXaDSRn7bOySGvFT3eM+i7sc3xUe3bH092foIHMVR39
        2DsU1T+Q61rESnuBILw1A0jY+Oi5GAj0CZ2EfCPKjiI2DMf/fMXXA4zUkgGYdre6BA0N/1NL0mu
        7bOpzuK+c7jNJpb07
X-Received: by 2002:ac8:5cd0:: with SMTP id s16mr19657119qta.309.1610907325209;
        Sun, 17 Jan 2021 10:15:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxHA5Uu0gpa8XxDScZXYLEIxNiq80IwCQ7L2RmuyrJGlG8Qx5Pax5Bfhqa3+05laLR+7+KNtA==
X-Received: by 2002:ac8:5cd0:: with SMTP id s16mr19657095qta.309.1610907325012;
        Sun, 17 Jan 2021 10:15:25 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id l191sm9315956qke.7.2021.01.17.10.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 10:15:24 -0800 (PST)
From:   trix@redhat.com
To:     m.grzeschik@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        joe@perches.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] arcnet: fix macro name when DEBUG is defined
Date:   Sun, 17 Jan 2021 10:15:19 -0800
Message-Id: <20210117181519.527625-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

When DEBUG is defined this error occurs

drivers/net/arcnet/com20020_cs.c:70:15: error: ‘com20020_REG_W_ADDR_HI’
  undeclared (first use in this function);
  did you mean ‘COM20020_REG_W_ADDR_HI’?
       ioaddr, com20020_REG_W_ADDR_HI);
               ^~~~~~~~~~~~~~~~~~~~~~

From reviewing the context, the suggestion is what is meant.

Fixes: 0fec65130b9f ("arcnet: com20020: Use arcnet_<I/O> routines")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/arcnet/com20020_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/arcnet/com20020_cs.c b/drivers/net/arcnet/com20020_cs.c
index cf607ffcf358..81223f6bebcc 100644
--- a/drivers/net/arcnet/com20020_cs.c
+++ b/drivers/net/arcnet/com20020_cs.c
@@ -67,7 +67,7 @@ static void regdump(struct net_device *dev)
 	/* set up the address register */
 	count = 0;
 	arcnet_outb((count >> 8) | RDDATAflag | AUTOINCflag,
-		    ioaddr, com20020_REG_W_ADDR_HI);
+		    ioaddr, COM20020_REG_W_ADDR_HI);
 	arcnet_outb(count & 0xff, ioaddr, COM20020_REG_W_ADDR_LO);
 
 	for (count = 0; count < 256 + 32; count++) {
-- 
2.27.0

