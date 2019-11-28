Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2287F10CAF7
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 15:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbfK1O6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 09:58:08 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34287 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727587AbfK1O6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 09:58:07 -0500
Received: by mail-lj1-f195.google.com with SMTP id m6so21460828ljc.1
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 06:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uJFqdfn2nSDjHf42hirywvV4nKXCcu5QZEHn2MRQUqE=;
        b=Fm9J/BPtzefO6mLtz+s8hghaGLQl9/e0iHtM+c2WZUylSQ5IRCuZvLLrqa9pvESajc
         sgUXiAdEW5ODvwgf/p7K3+6ps2qo4ojoUJEOeaW4+cvwZGzSxZUYdES0IEMWB57Deuf4
         xjUml1c0Urakd08HfwFSCPyXLT1jfJ5CE/vuE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uJFqdfn2nSDjHf42hirywvV4nKXCcu5QZEHn2MRQUqE=;
        b=A8DeHlaTrvywm2aXpTJP+OptU81Fi+TEHY4qhB2ROFcr4z9lDcEieraFZ4kJE788Ss
         tBw+wG77+LgKIpmQb6o02j5ELW7wObxaBcE454TSPEMDitTYgaCMTVN07+FZvx4UwKTW
         AmnZwgyWSrwdv13dTxpuB5lTg4/bmERRFabH9SduXiyY7hD9gr4ELuMfIkVpIl7qOfPD
         7Esr1FKSiczpbUNd0i2ZV13Ee/NYwI4yeZBq2ckbyEa9G0VdcAessUVCCAdI922WvOIN
         dUWslv5KksQZ4Z3f/NAzjzbOceMmGb7i71dxVd/4F6nNtuEZpQahYD7FHUO5HUi/hGZR
         B/Wg==
X-Gm-Message-State: APjAAAUuNz/AyNz6N7ZbjW2nZ9Yx+9Ja7slUeagP5e9YYAimNyR8xGJX
        VLq1CImDBMkaql8r+EY7UKo3gA==
X-Google-Smtp-Source: APXvYqyvULz2Tjp/CvI4s3FOQVWvQSzO1JW8WbB25Ky4p0+qkSxEH1U0IiPoAs0MVz6PY4HNawn0gg==
X-Received: by 2002:a2e:90da:: with SMTP id o26mr1140714ljg.25.1574953085644;
        Thu, 28 Nov 2019 06:58:05 -0800 (PST)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id u2sm2456803lfl.18.2019.11.28.06.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 06:58:05 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Scott Wood <oss@buserror.net>, Timur Tabi <timur@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org
Subject: [PATCH v6 47/49] net: ethernet: freescale: make UCC_GETH explicitly depend on PPC32
Date:   Thu, 28 Nov 2019 15:55:52 +0100
Message-Id: <20191128145554.1297-48-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191128145554.1297-1-linux@rasmusvillemoes.dk>
References: <20191128145554.1297-1-linux@rasmusvillemoes.dk>
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

Also, the QE Ethernet has never been integrated on any non-PowerPC SoC
and most likely will not be in the future.

Reviewed-by: Timur Tabi <timur@kernel.org>
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

