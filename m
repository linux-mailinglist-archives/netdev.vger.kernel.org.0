Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394DD318A42
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 13:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbhBKMSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbhBKMN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:13:58 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69B2C06178C;
        Thu, 11 Feb 2021 04:13:15 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id v6so2435784ljh.9;
        Thu, 11 Feb 2021 04:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eWK55MN/QnlaO+o8PUxLf8oUHMPNZSUqMMx8+4iR3UE=;
        b=dj1xr97R60wSnSVwYtEVBaSZWomdFjzcVFIEcLiuZN5OYXBSqG0ruAWS40zHeDI7xF
         zZ9LE2fO84BHD/YQPhpF0Y1uf4xKc2FUw1c4ejENTxuq49lfJhgY9tA3TYS9Oz8Y0flP
         4O6amDC6LZH3CIEMKzrWiNHusDdzryjXdRAJ558Rzb0qzwRPe8CBcs9uLdG78vMawf/K
         3JOlFSrLBJN4O3VkvoRTnM6UEaWMas0KpRQR8MRNOuVAfvTwCr9urPLvAadq04GFTQYv
         UxKmUKx/r2Q7qm3ivzTX+0o+LgXWcLwZvAhWjbbOY8C+TOlwq45Rqsyx+gfffWH9y7KJ
         apIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eWK55MN/QnlaO+o8PUxLf8oUHMPNZSUqMMx8+4iR3UE=;
        b=Po3Ac2AVWfs4GIgq/5+TXYAzCqudVQ7A9JoYlgZP88M415KVyOgdhQZYXsG3nNpTmE
         0l0YG9kAIjcbNRqVIh+K8Rp70igqkzJPz7Vsru7i6DRKvU1r4+yCdXTIDNhuVO8CL8rF
         jqUX9hHHdtJUQD13qxnDiTDOt3vcPpbFTUGvQpszZlLAnqCVTmLg8ElinbMh3CkD416y
         YY9N5NrvHE5brI0ePRyhto1Ge9zmD10NdGTTERG35jEn6o4u8s34THqlN3ItwLSq+H+C
         dLqP/CcvCg38DwZx1xEjkoQZrhyYRZp7bNtlUVHlmaMa58N4UyiyIsIAzWTR7BJ3otrq
         /vVw==
X-Gm-Message-State: AOAM531TcZEVqwA63KW6s8NY+QcP2KfhpLx0c6dnQ+7cXDoC5syydyxS
        UmKVd195oH5NmRTc0peM5uU=
X-Google-Smtp-Source: ABdhPJzmDe/zMH8sTaq4bXho6QdIVSbg7Y+gVLja53fcPvJ10r9fPPTbEvyq34MOFE46U+UHcqf3vw==
X-Received: by 2002:a2e:9748:: with SMTP id f8mr3656577ljj.29.1613045594242;
        Thu, 11 Feb 2021 04:13:14 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id f23sm834783ljn.131.2021.02.11.04.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 04:13:13 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next 5.12 4/8] net: broadcom: bcm4908_enet: drop unneeded memset()
Date:   Thu, 11 Feb 2021 13:12:35 +0100
Message-Id: <20210211121239.728-5-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211121239.728-1-zajec5@gmail.com>
References: <20210209230130.4690-2-zajec5@gmail.com>
 <20210211121239.728-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

dma_alloc_coherent takes care of zeroing allocated memory

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index e56348eb188f..f4e31646d50f 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -163,8 +163,6 @@ static int bcm4908_dma_alloc_buf_descs(struct bcm4908_enet *enet,
 	if (!ring->slots)
 		goto err_free_buf_descs;
 
-	memset(ring->cpu_addr, 0, size);
-
 	ring->read_idx = 0;
 	ring->write_idx = 0;
 
-- 
2.26.2

