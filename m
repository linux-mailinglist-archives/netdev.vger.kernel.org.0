Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAC6F4C68
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 14:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731412AbfKHNC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 08:02:57 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46671 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730858AbfKHNC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 08:02:27 -0500
Received: by mail-lj1-f193.google.com with SMTP id e9so6092093ljp.13
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 05:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BB15j+OZLSCqmbjpw6Rixs0w7wUAu62j+M3Q47LEWSI=;
        b=JPiH6ZKd2ZnUmbFTOFb+zecHncuK5W1rGbGHK2U2HNNwnIhWkIOIPn3+7Ay7T0tzM1
         5EAegX18KxWev95bX7gOYwgvjHEidVs2vmnDI0xounVD1lgao9hp6JuWyqGGmyzDgY1m
         DdQZLrXfOdpXw03FSH6fnD3E4Vvj1RGWqOAVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BB15j+OZLSCqmbjpw6Rixs0w7wUAu62j+M3Q47LEWSI=;
        b=gRatJ2ld9lIceK3PCh/o5jEqmlzLBvSXvaVgv8jpOMND7Apm7vUPGi0jE22wrijwXt
         TpV3uV6X07Xk4gQcwb/ki7ZdaGImbPG4GtLfq1JWciX8rbvCfr2oIoWWXm6Ll1+RLyY6
         zStAoW4chc53H2zcKbOBuj4tEnkQLRIhRQyE6gtgNVaF1gN43qQrSzHFQx7J7PvUhFWE
         cxcCnFT+xoO5StYuXlVfaNmg/i7K3x+EQgYY1QhspDRLjzp7rUtyrcGmHOyWRFatjvV1
         ESlad0LrUfx6unmZ95rzC/g/nT7qVCwqDuqscYsbX/8py+zyDx81R71Vb1lRJGwGI9XC
         CX2A==
X-Gm-Message-State: APjAAAU3lNd63y1Rww5oU5evJhMmdDeM23ouWuidQbiso6cyy8yEB3Ol
        sz+/KL5lJhsn3jViRRoOTFRjDA==
X-Google-Smtp-Source: APXvYqxJ5+E/xDqZwwVj1PKuG5R1Tse40MqtXo1j/SjaIDAjgO45IHqu0Kxn9Mf/lNqB6jnMlGV11g==
X-Received: by 2002:a2e:b5a2:: with SMTP id f2mr6613757ljn.108.1573218145233;
        Fri, 08 Nov 2019 05:02:25 -0800 (PST)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id d28sm2454725lfn.33.2019.11.08.05.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 05:02:24 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Scott Wood <oss@buserror.net>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org
Subject: [PATCH v4 46/47] net: ethernet: freescale: make UCC_GETH explicitly depend on PPC32
Date:   Fri,  8 Nov 2019 14:01:22 +0100
Message-Id: <20191108130123.6839-47-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191108130123.6839-1-linux@rasmusvillemoes.dk>
References: <20191108130123.6839-1-linux@rasmusvillemoes.dk>
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

