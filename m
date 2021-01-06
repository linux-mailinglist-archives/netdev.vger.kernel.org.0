Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CBF2EC3C2
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 20:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbhAFTQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 14:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbhAFTQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 14:16:30 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938D8C06134C;
        Wed,  6 Jan 2021 11:15:50 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id t6so2050185plq.1;
        Wed, 06 Jan 2021 11:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iz8jSmPjQGbRFCMF25JP5CEtJNsmD4TP0IpG9FYZAX0=;
        b=uLrYtgToreV9aA1B70pAoagKFbs1u/YXr179nrlSTZiBKADVmDsCPXMQkLRLL576y6
         f3/1pIY3K6NJp83FNkBzTVLt/e9uvx5R6YsDkQFLRrDDH+SbCuJ51d8ncBAkWEuPPRi5
         tv6S0hzCCcih6NjjGQhQZnDFR98VDSZ4SE1w/tlQPyNs9w8UBjEI3ZACP0U33jcwc5AV
         zW3LlAZmYyc6Qp+KaThx58JvGUHKsPl7CCJRV3t9zEh/XJ7ffQBPo7KVBs7kPe84ee/F
         Q6t7GSbq/PLtjFqS12gHVnJsCfEmNI9Wpd5o78QMpf91QE/oqZDRqKwUyzEAicnr7p7w
         6eqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iz8jSmPjQGbRFCMF25JP5CEtJNsmD4TP0IpG9FYZAX0=;
        b=M/vozn6PDRx/BaS5Thvgh5JKt3FwtXwCBGCBLgRFPcb12F6GDEOmtLyY79xX4hLGOd
         V8ZTPfMCOS464f0ua64OG8pzzAdTHrr9RAAh1Qatw3GhXyUWASN6JFRC9pvuPvocrxOi
         1UCEidxGaBogXLjns4gs68my1sywQ7p4De2X/s9SIrRIZ39m+pz+FUv7wXhNaQpbopgA
         l704KpF/R+aifgqV+QBvfZyo2JVdJvPnJWPWoBkxQfmQIWo1i/X8Mqp0owgtjMy8fBPl
         zQPZNBo3mxb6+Oq1te2cE5gOQC6JeXuAKEVXiAoEVO9XZME7DGQzFLFoIst88yguZ0uZ
         NBeQ==
X-Gm-Message-State: AOAM530QuuzQrWlY+fb+cEJJr1uQDz6egLDHhSeW74+BxuGjqNrDFnmq
        W+4WRNJd+G4CdwdoAz+coRjjmKMvWjY=
X-Google-Smtp-Source: ABdhPJy6GPDuQWULK7wqe8MGK2OGocw01NxFMnQ7KWA8l1thqI2HhQAMwK3gsCb0PS8ZGHWCgpMnSQ==
X-Received: by 2002:a17:90b:e0d:: with SMTP id ge13mr5519827pjb.111.1609960549747;
        Wed, 06 Jan 2021 11:15:49 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f126sm3219566pfa.58.2021.01.06.11.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 11:15:48 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: broadcom: Drop OF dependency from BGMAC_PLATFORM
Date:   Wed,  6 Jan 2021 11:15:45 -0800
Message-Id: <20210106191546.1358324-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All of the OF code that is used has stubbed and will compile and link
just fine, keeping COMPILE_TEST is enough.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 7b79528d6eed..4bdf8fbe75a6 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -174,7 +174,6 @@ config BGMAC_BCMA
 config BGMAC_PLATFORM
 	tristate "Broadcom iProc GBit platform support"
 	depends on ARCH_BCM_IPROC || COMPILE_TEST
-	depends on OF
 	select BGMAC
 	select PHYLIB
 	select FIXED_PHY
-- 
2.25.1

