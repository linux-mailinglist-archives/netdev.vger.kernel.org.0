Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC9FEC2F1
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbfKAMnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:43:11 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36642 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730823AbfKAMm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:42:58 -0400
Received: by mail-lf1-f68.google.com with SMTP id a6so3736116lfo.3
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 05:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BB15j+OZLSCqmbjpw6Rixs0w7wUAu62j+M3Q47LEWSI=;
        b=Q7l5B4ZzSFqdTZCb4tJtnGHQpMhdr2CvGmwTVybZhIGX2c4ktEn1SU46jLKTynP5c6
         xws5ATktOjO0yGARdh9e3ppAPSG4uIhGXWJLJb9bFFD7aZJ2kIdOQ/z6ktB1D335VRc0
         X76ZLrmMFUG8IjfB808JNyn/6kr5P9fM6Yovc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BB15j+OZLSCqmbjpw6Rixs0w7wUAu62j+M3Q47LEWSI=;
        b=hZEVXvZm40qCA1l6Ew76RS5Rd4eWUqByZMsGN3jyiiCf9D8QfdaRNzFS9YnolTgiWf
         rMXDpysVjutg6Mf5ub5G+e27sWgQ3MdKu+9ssD4Mtu+B5j/4NjGMrMItEYJYY99EPk02
         esq1r+GF4Uu5m+e+YAePfvKPIGELNGabYefjGjLruHWgGTgokp7221C9Bsdf7uycOiAz
         bofRePf9tYkgoRtYjdZI3swCfhS2TwS/DvLdNTWx76BoHOlGllqy0vxQZcV7mfbwjuaE
         3nYAJvyNe8VvAtEhA6IpwtGy+T1ReDAPM/LqzpGbIKlfm8Fci4DNqggTxo3LmNuj6EGS
         Yz7A==
X-Gm-Message-State: APjAAAX1oWFUF+mrrv6ZW/c0OBfgPPksX5WPLEWrXmpu9ulUsU7hI1I6
        ZgY4MZd5bt0E4YTr+wiS0EyMIw==
X-Google-Smtp-Source: APXvYqxCElUjbfpW6EePME6G+/EpoG3cuPhRw39POP0u7K0TVGS1unxGXbHxq4fCys0zyQmGeY2RWg==
X-Received: by 2002:a19:10:: with SMTP id 16mr7317366lfa.100.1572612176600;
        Fri, 01 Nov 2019 05:42:56 -0700 (PDT)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id o26sm2458540lfi.57.2019.11.01.05.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 05:42:56 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Scott Wood <oss@buserror.net>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org
Subject: [PATCH v3 34/36] net: ethernet: freescale: make UCC_GETH explicitly depend on PPC32
Date:   Fri,  1 Nov 2019 13:42:08 +0100
Message-Id: <20191101124210.14510-35-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191101124210.14510-1-linux@rasmusvillemoes.dk>
References: <20191018125234.21825-1-linux@rasmusvillemoes.dk>
 <20191101124210.14510-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, QUICC_ENGINE depends on PPC32, so this in itself does not
change anything. In order to allow removing the PPC32 dependency from
QUICC_ENGINE and avoid allmodconfig build failures, add this explicit
dependency.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/ethernet/freescale/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index 6a7e8993119f..2bd7ace0a953 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -74,7 +74,7 @@ config FSL_XGMAC_MDIO
 
 config UCC_GETH
 	tristate "Freescale QE Gigabit Ethernet"
-	depends on QUICC_ENGINE
+	depends on QUICC_ENGINE && PPC32
 	select FSL_PQ_MDIO
 	select PHYLIB
 	---help---
-- 
2.23.0

