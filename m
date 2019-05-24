Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885B2295AA
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 12:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390502AbfEXK0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 06:26:01 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36618 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390442AbfEXKZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 06:25:57 -0400
Received: by mail-lf1-f65.google.com with SMTP id y10so6745198lfl.3
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 03:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UUnKJywbuQNPAqJsfCoHncqH1hW8S2U8LKpAPCF0ca4=;
        b=bMwKHQyipWJme+v/+kqfnjrt/JtqO5yxOylRNLokOq/c9qiiECRXjaUqR96AWSXLti
         m8AGg9aWGNc8aYDS0gFvffghGD/KihmbtjbuS2LR1BgtlefLlwq9uXsKoUUAD6aPEqYX
         CmDna+eJi+gP1r1RVRQHg7KMluZXvrrKlY8iU/+87TRpuFI8A1TsKvOMPFnHJ8OpLprw
         oaYl+oa4ibEetM9c2IqvItwDXgc6n99iAE5IoWe8iXiFoSW+j+vTs2Yf9d9jsNYwdFm0
         HDV9HbaWVrK9QgPxRLq2FpHjF8ZMH4dwtVWtThv7yPhP0rYL8+zL4VsHe3yz4oDq59uf
         p6FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UUnKJywbuQNPAqJsfCoHncqH1hW8S2U8LKpAPCF0ca4=;
        b=E7fqK1mbrkwlWwqtHIy3JgTahoPmhzdLkUByYpOqlB4RJpxQUqfzU0JBwaEqC57vnU
         KR5yozIwyMd+nHAXYUJjbR+UzeFSvRw2EB244FYUGSevU5Hzgw2X+KNMB0scSkhdFHu9
         6JX199nTfs3hUmsg+th6pcf3S18taB6l04naas3sSVziPOyVTNAWK9dArUMIAq1k/YtQ
         ch6HtNbM3JT4NN1lmhfRmeUeLTiHi1YKkRpE2ESXx1LvfWzKoxD7pVmOvLRYQ2ZaG5mM
         A1xxv/dsZqLJ//XlasyHsHnm6BXf0hfhs1pQhGLBsNcPGyhufz+gO3Bx3A+8h8+cX4KJ
         xcKA==
X-Gm-Message-State: APjAAAWSteY/RqgoOFT6VSlE4/fBoclPT/tPgBREV2jg5NBwIhI9/2HS
        oUMw3uBaRZjO/9gJX2aPJGm0JtwLS9Rklw==
X-Google-Smtp-Source: APXvYqzS/FF/VRRkasnFQ7vJ3lFAC/Lc7ISyLADaNpSjoPJmTfOqWPnF00oJKnIIj9RP/459A8C60A==
X-Received: by 2002:ac2:59c7:: with SMTP id x7mr12875289lfn.75.1558693556078;
        Fri, 24 May 2019 03:25:56 -0700 (PDT)
Received: from maxim-H61M-D2-B3.d-systems.local ([185.75.190.112])
        by smtp.gmail.com with ESMTPSA id n7sm421567ljc.69.2019.05.24.03.25.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 03:25:55 -0700 (PDT)
From:   Max Uvarov <muvarov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, Max Uvarov <muvarov@gmail.com>
Subject: [PATCH 3/3] net:phy:dp83867: do not call config_init twice
Date:   Fri, 24 May 2019 13:25:41 +0300
Message-Id: <20190524102541.4478-4-muvarov@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190524102541.4478-1-muvarov@gmail.com>
References: <20190524102541.4478-1-muvarov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phy state machine calls _config_init just after
reset.

Signed-off-by: Max Uvarov <muvarov@gmail.com>
---
 drivers/net/phy/dp83867.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 66b0a09ad094..2984fd5ae495 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -342,7 +342,7 @@ static int dp83867_phy_reset(struct phy_device *phydev)
 
 	usleep_range(10, 20);
 
-	return dp83867_config_init(phydev);
+	return 0;
 }
 
 static struct phy_driver dp83867_driver[] = {
-- 
2.17.1

