Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89363800A6
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 01:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhEMXFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 19:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhEMXFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 19:05:32 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299B1C061574;
        Thu, 13 May 2021 16:04:22 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id 1so21074392qtb.0;
        Thu, 13 May 2021 16:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5kzGv2iHn3/izMP0DDwAFYLuDgOh/guXF9UGZskZqcA=;
        b=O1vf/f+ODXtfZGn96zPUqp//RnUao9fUXDvHrlog5lZWU+H7RSWVWfjyIy7LQsDRpx
         m+jUMBWid8DhWQ0H33cccpXYzZ+KrEsFHB/g9AniiZtIIn27t4R1TeaOvZW11KrmpgAx
         wSsyV/pCZTHdPIpPxEImwGjijmMFgBbpDk/o5ys3LmYx/ztU+/UYntcjfjs0TY6PBnRG
         CFmt/6qEB5/vsVCXJSoq2g1C0JPD8/29L7xueyB/ZI98kJsTPrazHuYv6L1nknKUOKbk
         FNLxkcllLtke71XF5zXxBvQZkHzcWwTG0y8Dm4/ASthZ/yiAHZVilUt/545byrrtZvrE
         /Y8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=5kzGv2iHn3/izMP0DDwAFYLuDgOh/guXF9UGZskZqcA=;
        b=N3SsAeYUipVATEJRpb6o+ti6hhvo+bqn3py+Fe9kaW2JgSqBV7uyYI2mkiVccHlx+l
         rM19z9RGrVVBJrCKjpwIkjcVLJqKoEc//tlFgnrSCeLPcdnLHHOLs4o3y10H7SoJJYGV
         wwt8czOKw/JWdZ31Kw8pq4mxWCCSpOvNJ46iqgCBVB0P5LbWHP5ycHISUic9jn3Mn8Xe
         9Ty7cep1OVSHjbzKIsb/Wxa2Pr+LN0VBYLp86yVfNl06VoWaetFCRWj8zkYmF4qvYpYz
         b4TLitGb+9qfPtrlzE4C/vZcw6Cfi62s+TVrKONaaWq4YDsGHSzCQIOeq7hzAPwvnj53
         1uTw==
X-Gm-Message-State: AOAM532fV1wDnnOFYkaAyyJXABFE2lu9TbKCRvUxWgJls28WY+bTMYQ/
        1BLU2KZT3GsZtDpWd0v9unv5U6B2hE0=
X-Google-Smtp-Source: ABdhPJxnkxR+M1U0M94Ymqr53S/ioF5VF/Ku5cKgBGXmgRy1b1vAUJBILvMaHfSJcbfs3QO9nkSVqQ==
X-Received: by 2002:ac8:5250:: with SMTP id y16mr31833537qtn.36.1620947061477;
        Thu, 13 May 2021 16:04:21 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s10sm3352037qkj.77.2021.05.13.16.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 16:04:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sunil Goutham <sgoutham@marvell.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] net: thunderx: Drop unnecessary NULL check after container_of
Date:   Thu, 13 May 2021 16:04:18 -0700
Message-Id: <20210513230418.919219-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The result of container_of() operations is never NULL unless the embedded
element is the first element of the structure. This is not the case here.
The NULL check is therefore unnecessary and misleading. Remove it.

This change was made automatically with the following Coccinelle script.

@@
type t;
identifier v;
statement s;
@@

<+...
(
  t v = container_of(...);
|
  v = container_of(...);
)
  ...
  when != v
- if (\( !v \| v == NULL \) ) s
...+>

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
index 0c783aadf393..c36fed9c3d73 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -594,9 +594,6 @@ static void bgx_lmac_handler(struct net_device *netdev)
 	struct phy_device *phydev;
 	int link_changed = 0;
 
-	if (!lmac)
-		return;
-
 	phydev = lmac->phydev;
 
 	if (!phydev->link && lmac->last_link)
-- 
2.25.1

