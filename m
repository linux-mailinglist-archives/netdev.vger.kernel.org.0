Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A82625C052
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 13:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgICL3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 07:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728480AbgICL0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 07:26:46 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB8BC061258
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 04:26:30 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id b79so2500783wmb.4
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 04:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o8lMzA8/1JzsevoeEklFRFWRCmVGXrAAGNkn7AQNDnk=;
        b=orfh4pSc/LLmRJWqnhhwzuDZdMFvR4P6ueWKm/6nG47B/ykq+9yhuiRb9fNJdmj1JM
         WV27oOpbcaUC6OWF+SNuhQQr9fBrO+2iunv1sSYf6RfhdgKlTXaQ28CbSrLx4gyyiIIc
         GhQkbyRN0AAjdZTwPumoaSPqSwSEp9WFXC3W4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o8lMzA8/1JzsevoeEklFRFWRCmVGXrAAGNkn7AQNDnk=;
        b=mGeLaLMt/6LqFKHQNbbtfGN52pc+IexJTrmywG5FMKqk5NAn/RLyzAlrUP2V3OMlog
         DJs6LdtU7Jln12bTjNLFhf88yJBTfRMlIu5CKYE6pEoYuKH0cVQxDC/RPj0WpmnKmqWc
         Hzn3INz02qdxbR8P/s2nnKqd0l8+Jzk6Yl9gqlY9wD7xcMeZbEFZorXmZTUWcXmC5Fiu
         OHpiDuHKaUOyOXxU+12pyYvM+rpMmOd+zQxGlt9PkIn3LXA42qTfhm3nknNHVXVDZ7LJ
         ZueJUQwjLApgWpYLeLfc25Tsi8MqqH4KE69JHpRKIHf9kKrMKSVafEA8VJrfkyqzPxj8
         QCHA==
X-Gm-Message-State: AOAM533Kd0dYF14KfD2XufREQiEEgEMJy8NOLr+yVcajKOB5n4UMUB4G
        0tEOuRg/XnxCLnMg1aDMA58IrA==
X-Google-Smtp-Source: ABdhPJzD3GfkceLIu/lu0T9vi1jDZ3fF+F4lQOO/4fd2HEkBn6W0e2lOomEzdBL27OhyuC2p8vcmRg==
X-Received: by 2002:a7b:cb0e:: with SMTP id u14mr1984909wmj.158.1599132389380;
        Thu, 03 Sep 2020 04:26:29 -0700 (PDT)
Received: from ar2.home.b5net.uk ([213.48.11.149])
        by smtp.gmail.com with ESMTPSA id 71sm4312734wrm.23.2020.09.03.04.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 04:26:28 -0700 (PDT)
From:   Paul Barker <pbarker@konsulko.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Paul Barker <pbarker@konsulko.com>, netdev@vger.kernel.org
Subject: [PATCH 2/2] net: dsa: b53: Print err message on SW_RST timeout
Date:   Thu,  3 Sep 2020 12:26:21 +0100
Message-Id: <20200903112621.379037-3-pbarker@konsulko.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903112621.379037-1-pbarker@konsulko.com>
References: <20200903112621.379037-1-pbarker@konsulko.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows us to differentiate between the possible failure modes of
b53_switch_reset() by looking at the dmesg output.

Signed-off-by: Paul Barker <pbarker@konsulko.com>
---
 drivers/net/dsa/b53/b53_common.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index c2ecb1cdef3f..26fcff85d881 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -765,8 +765,11 @@ static int b53_switch_reset(struct b53_device *dev)
 			usleep_range(1000, 2000);
 		} while (timeout-- > 0);
 
-		if (timeout == 0)
+		if (timeout == 0) {
+			dev_err(dev->dev,
+				"Timeout waiting for SW_RST to clear!\n");
 			return -ETIMEDOUT;
+		}
 	}
 
 	b53_read8(dev, B53_CTRL_PAGE, B53_SWITCH_MODE, &mgmt);
-- 
2.28.0

