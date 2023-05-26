Return-Path: <netdev+bounces-5662-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C687125D4
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:46:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBEC21C21038
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E02C8F2;
	Fri, 26 May 2023 11:46:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290DD742FE
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 11:46:07 +0000 (UTC)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDE3194
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 04:46:02 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-96fbe7fbdd4so110919066b.3
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 04:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685101561; x=1687693561;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+vlt+5VLC7KI/CuMwSmVCoc1T0RjObSqqBqBI2FUoWI=;
        b=abDSY2fbWfc/NpEno6lPCk1ECWzGdg/c0ZJO1PungQgyLhJWQl76dcMVxO/+NkvkJ7
         ZTKZo5jTqwHAtIdUBhtv500uC6LwwqfGjYiV4Ry6kQ0Is86AoPfmVdbb9h/eIgxfTg1G
         oIAQlFz+0mGelva57WyQqGHh/KnU31DZfuHcoZYZ2IlK4VsjOBqZe2Y2gvYnbseYN6fW
         +pGTpXqPckNIAIZ54bUgFRmD+KnJMzxN3QL4ZH8yvSGe3cM4sTudhN2WbKPDDU8gSgU0
         BG/GtnHtMVHl7nu2rnG6WtFou89Qovc8MDTLSJ3MmzQxUUZe7XXOmgKLILHD5l5C4DSs
         3+CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685101561; x=1687693561;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+vlt+5VLC7KI/CuMwSmVCoc1T0RjObSqqBqBI2FUoWI=;
        b=bHMdQIPwKBXanGM+hP0HRpO1GYkp5L3F24u667FldbNMVIOy4lDneKod6ZmNVo3pPW
         wmZhyvhY+R+386747aRjKy72iIWVpC8Qb4Sl4YYEnBeedOmhy9njhVkMhT9nFGVtJEff
         I6GDLt/HbMb8rSMZK9pkVTcn0PfoZMOgMGlggTYV5O+ZYpsXM5a9vaudpjdlMQ2WhGJM
         SAqkHjJOOCYAcynqAcXnQa3kMROD6C8bycELv8JeXyINVOHZNhmnY8hRhYniYf20oVJn
         wDXUku09ycek63pYZkHmJouu3e/EA0NIn8a1B/aGgaxA8p99oDVmDZutRaOifWqKsPDf
         45pQ==
X-Gm-Message-State: AC+VfDx1VjHO/9CZ1l74dc4O1s/OHmnGs3FQn+HryAegmvMShO7GFGsE
	iTD4wbi4OyrHRSvdjBh0rEYNXQ==
X-Google-Smtp-Source: ACHHUZ582mOEkzgQjppredkDpk8pe+heNFACxpfj1l33/h7T9wXg7DUZDmFAfhnCrlTTCh4EwAFbMw==
X-Received: by 2002:a17:907:9708:b0:970:925:6563 with SMTP id jg8-20020a170907970800b0097009256563mr1837879ejc.8.1685101560854;
        Fri, 26 May 2023 04:46:00 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id w24-20020a17090649d800b009666523d52dsm2043491ejv.156.2023.05.26.04.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 04:45:59 -0700 (PDT)
Date: Fri, 26 May 2023 14:45:54 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: phy: fix a signedness bug in genphy_loopback()
Message-ID: <d7bb312e-2428-45f6-b9b3-59ba544e8b94@kili.mountain>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The "val" variable is used to store error codes from phy_read() so
it needs to be signed for the error handling to work as expected.

Fixes: 014068dcb5b1 ("net: phy: genphy_loopback: add link speed configuration")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/net/phy/phy_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 2cad9cc3f6b8..d52dd699ae0b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2700,8 +2700,8 @@ EXPORT_SYMBOL(genphy_resume);
 int genphy_loopback(struct phy_device *phydev, bool enable)
 {
 	if (enable) {
-		u16 val, ctl = BMCR_LOOPBACK;
-		int ret;
+		u16 ctl = BMCR_LOOPBACK;
+		int val, ret;
 
 		ctl |= mii_bmcr_encode_fixed(phydev->speed, phydev->duplex);
 
-- 
2.39.2


