Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DABB49F348
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 07:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346284AbiA1GGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 01:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346295AbiA1GGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 01:06:18 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9287DC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:06:18 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id q186so10504267oih.8
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bqUzGX3gIjfpTTEyjWLdIl4fsy8pNWiAPNpoKLcY8OE=;
        b=Va9+mgY/7fnV0DBqQ2ZDoJ0xAi3oKbnhy6i7GYyJOBkhJb4zpu2JwrjlFneCeBEAYk
         JZC/xkgtHI4GGbIqIcaX8C/unmyQGpz/O8BRjTHqqVqputm49QTfU34NdWuQ3jwLalVz
         Iv1aqx0YO2G0IFLdik0zZzDGcj5wVYfGSixlIJqNk2sn1WB2nzEJGt4YyjWc/AcCJzst
         uLtTVCUl0lLdB0oSGK7YbZCDYMJOBOqOefnSm8gAAVSnPdV9A9lAhWXQks5irUAvzMM0
         XtpcGOpiVG5TeNkxAxxk/R4zzqqvp4s67M88seeDFnVDG4us5BmFziMZ2PhFCGxOolS+
         9M4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bqUzGX3gIjfpTTEyjWLdIl4fsy8pNWiAPNpoKLcY8OE=;
        b=08u0DaQD8CS5UMHIki27KnROXK8jWRjJo+VW332wKZSQhyllhM3Wk8i2j5Px6uRnrT
         FK4sfgkEPHorP0v0yzyFb/s9F55b4yc27SnYe7O46U/OiNgSrSU1URI9mFOU/39L4dvM
         toX2gP6a2dwDtflvRE5sSYXtKWBKF1U+sPvjdlP4fgZpSIcR2Li2Q8EoeliiWvcUvwIi
         It2BLg/31SGqPdcjeITEo6E1AEcwo9OhuviSapBk48BpYO5KYq+vhfXDVUSNlOvqRBZv
         6tMgv9G4rciUE3k455/kO5aR9J19LQfFgsGRWBzPuYwNV7dXcqFcvkumcfshYe0pqTwM
         PvHw==
X-Gm-Message-State: AOAM533c68CvVAUpiKAkAx7E7Ns1nMTAlR2rEMuvrHKKgRci+JWny0RI
        rUbs4urprxGMxJHVjMd1IKidm6VPT/iqjw==
X-Google-Smtp-Source: ABdhPJwJ1VTwAkXCzyMn0i2ttWkYMuOommo0wUDxxH92vc5/03k0/yF9D+4HM6e3LmEj77iMhH/tFw==
X-Received: by 2002:a05:6808:14d4:: with SMTP id f20mr4372836oiw.54.1643349977783;
        Thu, 27 Jan 2022 22:06:17 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id m23sm9790229oos.6.2022.01.27.22.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 22:06:17 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        davem@davemloft.net, kuba@kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v6 11/13] net: dsa: realtek: rtl8365mb: add RTL8367RB-VB support
Date:   Fri, 28 Jan 2022 03:05:07 -0300
Message-Id: <20220128060509.13800-12-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128060509.13800-1-luizluca@gmail.com>
References: <20220128060509.13800-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTL8367RB-VB is a 5+2 port 10/100/1000M Ethernet switch.
It is similar to RTL8367S but in this version, both
external interfaces are RGMII.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 6974decf5ebe..174496e4d736 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -108,6 +108,9 @@
 #define RTL8365MB_CHIP_ID_8367S		0x6367
 #define RTL8365MB_CHIP_VER_8367S	0x00A0
 
+#define RTL8365MB_CHIP_ID_8367RB	0x6367
+#define RTL8365MB_CHIP_VER_8367RB	0x0020
+
 /* Family-specific data and limits */
 #define RTL8365MB_PHYADDRMAX		7
 #define RTL8365MB_NUM_PHYREGS		32
@@ -1979,6 +1982,11 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 				 "found an RTL8365MB-VC switch (ver=0x%04x)\n",
 				 chip_ver);
 			break;
+		case RTL8365MB_CHIP_VER_8367RB:
+			dev_info(priv->dev,
+				 "found an RTL8367RB-VB switch (ver=0x%04x)\n",
+				 chip_ver);
+			break;
 		case RTL8365MB_CHIP_VER_8367S:
 			dev_info(priv->dev,
 				 "found an RTL8367S switch (ver=0x%04x)\n",
-- 
2.34.1

