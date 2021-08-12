Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A07D3EA0A5
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 10:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235230AbhHLIiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 04:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234768AbhHLIin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 04:38:43 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725C6C061765;
        Thu, 12 Aug 2021 01:38:18 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id g138so3868579wmg.4;
        Thu, 12 Aug 2021 01:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MFE2kJwSYNLGR3mvNEkobybd41Blz6kFxxuAlCZNTv4=;
        b=mCMKNG0oTCn8Jm+EOR5k7O6zFs/dVw6YRt/UHr6yGEdss+vyZjkBpsGpRCSvrmu+e2
         8K3SSKzZxK7YDBC4Q5E5T4vunRDDPasN4vqaWYs0yNGlLeN/1Hbjm8nebHlvkHCZ5g4l
         iHPi6HgULqYCAkLJ4jwjCHaVE2l/HIVolwiHdbXKjaLUiuxxNdxgnDXafab0VhyYoX4R
         //7ddPcvA0x8N/2ZZdZuCvDEPfHinmVKpFMK7JgIwDloCXxqsMLaUbqpvt7VMQwN8aeh
         IzMu6zZV/hpiU14WDvgtc6cqHEVky9dDz76mme9kwBfiyfdiVo/bwBDag/CImo8MuoGw
         ugxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MFE2kJwSYNLGR3mvNEkobybd41Blz6kFxxuAlCZNTv4=;
        b=o4JWJgaqiQR7AH8QAypd9uQ462DbS/Q3h5ABt0H64/GppQGnM+/gMJ005QdtI9wbcC
         V+DI/a2Aaq8/sMwZPnMo4pGsA+8yE3YwWlZxTOMhxDWRJ2niUvQvHyr8gtVdaxxxt7hI
         Qz2AHwyziJK28Md4iEBIhYa/ktYlMi11QmTSakx5VPmHuIVavxicCNIOv0lhxD6NyJei
         KRtvAh25ki7WCnMR1hTPSqCTu2rHsLXT1gQ7/rffjKN+YpNyodahpRVOEyzS5gaMu66M
         enJHYd9AtNvmmc3Q7GH4wtrqVhDmV511tFbuMqOvFzYzUVaTqknzQQT3+jkcw9ImYpUM
         LHmw==
X-Gm-Message-State: AOAM530i6KxSdikwG9tHbOOnPxO5sZuhoazwZcvI6hwyM1vuza76qUd+
        inD5FeY//5GU2Og+PQYZUqw=
X-Google-Smtp-Source: ABdhPJzI3+337f1gcbPRpmT6E074LVtjLXVw/p5D0LDSEy7yZrvsZQgSrlVolfgEAyDsGClNHZzekw==
X-Received: by 2002:a1c:cc05:: with SMTP id h5mr14287909wmb.5.1628757496949;
        Thu, 12 Aug 2021 01:38:16 -0700 (PDT)
Received: from felia.fritz.box ([2001:16b8:2d76:9600:40d6:1b8e:9bb5:afdf])
        by smtp.gmail.com with ESMTPSA id 9sm1830324wmf.34.2021.08.12.01.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 01:38:16 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH 0/3] Kconfig symbol clean-up on net
Date:   Thu, 12 Aug 2021 10:38:03 +0200
Message-Id: <20210812083806.28434-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear David, dear Jakub,

The script ./scripts/checkkconfigsymbols.py warns on invalid references to
Kconfig symbols (often, minor typos, name confusions or outdated references).

This patch series addresses all issues reported by
./scripts/checkkconfigsymbols.py in ./net/ and ./drivers/net/ for Kconfig
and Makefile files. Issues in the Kconfig and Makefile files indicate some
shortcomings in the overall build definitions, and often are true actionable
issues to address.

These issues can be identified and filtered by:

  ./scripts/checkkconfigsymbols.py \
  | grep -E "(drivers/)?net/.*(Kconfig|Makefile)" -B 1 -A 1

After applying this patch series on linux-next (next-20210811), the command
above yields no further issues to address.

Please pick this patch series into your net-next tree.

Best regards,

Lukas

Lukas Bulwahn (3):
  net: Kconfig: remove obsolete reference to config MICROBLAZE_64K_PAGES
  net: 802: remove dead leftover after ipx driver removal
  net: dpaa_eth: remove dead select in menuconfig FSL_DPAA_ETH

 drivers/net/Kconfig                         |  4 +-
 drivers/net/ethernet/freescale/dpaa/Kconfig |  1 -
 net/802/Makefile                            |  1 -
 net/802/p8023.c                             | 60 ---------------------
 4 files changed, 2 insertions(+), 64 deletions(-)
 delete mode 100644 net/802/p8023.c

-- 
2.17.1

