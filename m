Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF98C1E63D0
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 16:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391110AbgE1OXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 10:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391108AbgE1OWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 10:22:55 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C30C05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 07:22:54 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id j198so4620880wmj.0
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 07:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fW1nO44AIOkd1DyHEXQPPUYlT6a8b9ESKOQqboJxrOI=;
        b=Ej4N7uslJSputqEQa2xbVuKyL2M+K03+7SqLgEzI3Rn7DshHJgdM/1XfyTMJGnW2Vr
         m0kkQeSvrJxgLmRBi4HalZPUSysYWSMvD8eFOAkLxWuFZhQhfy/KFGA/rhCdy4GUO4Pn
         iKNJxxJUjDqambIIaNJHNZx7GdTpvLc5/YhqkdhU/HunYNdaEEHUWKYEKM/54NCX3mc4
         7+4XyZJipYLbx5cPjsGshzE8ppHw/6xYyV6Z2MCCG8D1JcIbjXIceyeEUpdWsHqCAuhz
         oq1OVCuUMCpbxDzIXVKaKNAUP6MtMrYwvPGK3qKZh8Z+oY7R5T9JWGFIadiTQ2msyWgZ
         0lcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fW1nO44AIOkd1DyHEXQPPUYlT6a8b9ESKOQqboJxrOI=;
        b=g8tR7uP3Uel9+1agEZby9wzAQsg5RTGQk5zYxsr+7l2uJA/qGKlAN/VB32c8JVQbwB
         PR3Te6Zx7wF2qZW+c8XtiK391P2Ppa+iTjlz2n87Du9u/QmnZ7Y8NZxuZF9Lau1zvpzR
         LyQT4dvVYbgbqz7vKJXmvgdufD+BjaCOdcRZWQb+q2HA6dy5u8r0MrGiwnYGUjQe9bXn
         1DUaZparfetuiTgDz/8+7NTGP2i5Vt6zpfbHsIhCfA1B+kmoOnZQsIih2Kk4/eza5e4c
         BGehhb9G1vj85vLuLQ7QR7jZhHdmMeKosbt1v5cZzRMNS2LNdbNBACnCAgFzPuzo4/pT
         dVpA==
X-Gm-Message-State: AOAM533s54OCJoqVoPGsb5IQqjoAULpZYbPnHL8X8TRxXe5qpwsP2Cas
        etgUcv8nS9GbFbdqPXCkszjhhg==
X-Google-Smtp-Source: ABdhPJyjpo8fZxpr55zZ4EY0chHkdotq2Tr2sLbnnUHjIG5v+Aeelk58EK7UzA58W/G6CefodEUQ6A==
X-Received: by 2002:a1c:4008:: with SMTP id n8mr1516082wma.118.1590675772064;
        Thu, 28 May 2020 07:22:52 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id h74sm6258162wrh.76.2020.05.28.07.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 07:22:51 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v2 0/2] regmap: provide simple bitops and use them in a driver
Date:   Thu, 28 May 2020 16:22:39 +0200
Message-Id: <20200528142241.20466-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

I noticed that oftentimes I use regmap_update_bits() for simple bit
setting or clearing. In this case the fourth argument is superfluous as
it's always 0 or equal to the mask argument.

This series proposes to add simple bit operations for setting, clearing
and testing specific bits with regmap.

The second patch uses all three in a driver that got recently picked into
the net-next tree.

The patches obviously target different trees so - if you're ok with
the change itself - I propose you pick the first one into your regmap
tree for v5.8 and then I'll resend the second patch to add the first
user for these macros for v5.9.

v1 -> v2:
- convert the new macros to static inline functions

Bartosz Golaszewski (2):
  regmap: provide helpers for simple bit operations
  net: ethernet: mtk-star-emac: use regmap bitops

 drivers/base/regmap/regmap.c                  | 22 +++++
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 80 ++++++++-----------
 include/linux/regmap.h                        | 36 +++++++++
 3 files changed, 93 insertions(+), 45 deletions(-)

-- 
2.26.1

