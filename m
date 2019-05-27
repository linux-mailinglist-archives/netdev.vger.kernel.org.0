Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE652AE70
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 08:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfE0GQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 02:16:20 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42703 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfE0GQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 02:16:19 -0400
Received: by mail-lj1-f194.google.com with SMTP id 188so13575529ljf.9
        for <netdev@vger.kernel.org>; Sun, 26 May 2019 23:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yBwVU4kiBOgfU/NvkAQydDYbsfkITBYOkXA5jdhPjxg=;
        b=JzgfgiYZVA9ZMkSuoRLdcRTBoI7KpMT3C0i2xL5673Y1l41bdD7ZfUQ36+i1izVDBN
         y+jasas71M5gvw8tqLzwcVWxhwuyH2U6IdpSjLp6KdaIeboyHI0fZbCNv+WDtOHYrmeB
         R1JIBffMRoBZFr5kl3nNLaPUDnurVytYspPJGH5diLVf9AkQUMWfFquu/xq7lHa6YEQW
         MjNCxGCHjqCqR+KKM5jNLywuM2Jb019/FmiIlAcHlS0aQ33tSy3taibaY48FBhY0jlTB
         GEOJYAklc6anrURGivVsvj4JkUECPPfznjhFYUKRSXKgbXDTNvBCoe6YqGmZ1ypdN/iq
         SXyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yBwVU4kiBOgfU/NvkAQydDYbsfkITBYOkXA5jdhPjxg=;
        b=RO5xuCrDSC6B3t7vC7LYi876qfXQ8uL3ol/9lq3MCSCv8WOBgaWpVowepkZL9Z9XUP
         HLdeeIvKP7qUsSe0llu3LpPy9aMjEiDd5UsyPrNqs6kku3T95oFrLJ3TnwbHHo2qvYWp
         sJYocKH+IPyssS7zxfM/a9FUrVfTcZY8EmcNJxhnAvfZgh6C0VUpXvauaQxQaXjgQIW0
         y4BHEcNWHuIrsmxjOZeH7oN0QEAxjMirtWAW8Zmz5i4M6Ynd3b88i9tIITmHsHyXcwkB
         pTIcuG5JdaJROCTTTKZ/BA7wKfMc0YFccfxbchAbK12K0Sqkoa6g+Q6G48BE21LbBEGC
         6XdA==
X-Gm-Message-State: APjAAAUloi4Xjt361rlq+nA8B4DDN3O0c3g69w3xYLxqXGIXIajsnujE
        258ZLppyW2AE6TdLZfkJFuFRZwL7XX7Kgg==
X-Google-Smtp-Source: APXvYqzWwPV+Qv18VAhmpIjYUdY1pJ8e4XIpyMvYx6PjiyJ+1gZSFFaLz/c7bkc+TAa7ah1eSUHv5w==
X-Received: by 2002:a2e:99c3:: with SMTP id l3mr11086102ljj.73.1558937777464;
        Sun, 26 May 2019 23:16:17 -0700 (PDT)
Received: from maxim-H61M-D2-B3.d-systems.local ([185.75.190.112])
        by smtp.gmail.com with ESMTPSA id a25sm2045454lfc.28.2019.05.26.23.16.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 23:16:16 -0700 (PDT)
From:   Max Uvarov <muvarov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, Max Uvarov <muvarov@gmail.com>
Subject: [PATCH v2 3/4] net: phy: dp83867: do not call config_init twice
Date:   Mon, 27 May 2019 09:16:06 +0300
Message-Id: <20190527061607.30030-4-muvarov@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190527061607.30030-1-muvarov@gmail.com>
References: <20190527061607.30030-1-muvarov@gmail.com>
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
index 5fafcc091525..a1c0b2128de2 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -337,7 +337,7 @@ static int dp83867_phy_reset(struct phy_device *phydev)
 
 	usleep_range(10, 20);
 
-	return dp83867_config_init(phydev);
+	return 0;
 }
 
 static struct phy_driver dp83867_driver[] = {
-- 
2.17.1

