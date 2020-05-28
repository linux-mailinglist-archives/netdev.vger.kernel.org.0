Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42AF1E60F8
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389789AbgE1MfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389743AbgE1MfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 08:35:13 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191D3C08C5C5
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 05:35:12 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id r9so2961439wmh.2
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 05:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BQJlUoiEpzky8o42erc/ysy+K0QjdQ5ysTv41onRRZM=;
        b=n5TfYfHGMNMD8D+8R6USQfibZj8hFE1+qAcYAnQl3Mw9twHILNshCqgYHbRv7HpuaL
         v4IklUmYcEW5niLRusiOXOTcnxRLlH+wYowKNR3lZLf5ItsR95+s8Hv++i4vO5dC4uPh
         n0p4wW94L1kDNBcKfipskEv7wfb7426RGlrPhn4PFoxf1I0YEsoJru8lwCrLv92WVLLy
         2hlwHISith+xluEzHWoEfPddgu3jBHMUjBzpgKrfubN75bsbjR1KjwAIJGSc6VeHYsh9
         WQfz5qvkacA722/Ou4Ec0yxL3tlfgeZ+5nX5+ECK9Hx0I9c1Wqnk3rOdrygNkRJdfAh9
         V4dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BQJlUoiEpzky8o42erc/ysy+K0QjdQ5ysTv41onRRZM=;
        b=XwJ6npsTHFF0bs2cTM6pkRFyYiMdK6+Y4vwQztdhpEParXu5sAux7RpuZNc1XlWYCB
         Cvix7X+tQix2LUYUaoIm3XRm7wwjnUgZauiudYVWNxE2NUNQW9OUzapFKmfL2pAtsqfP
         810b2Ku/VcuSr6ZpWqXTtY0tDXWFRKQ8dMC9FJeNaW0CvOvxBQIowyBHCJKZFEz/M5Jp
         kMGH1kyb1JLOAP3793JclOUpvlz7+1Tkt/F3z60qdb+xUMMyYnTqQMZuwcY3ny6P94Nq
         y7Tex73B60IsVPpeSG6vuC+CyRmjCt7jxdOhjyMSWtHRZaFVy6Mi2+7xuSfQMm7ZxmxV
         tJIw==
X-Gm-Message-State: AOAM531WlarHg7TZ3XH4QEJ4/NvAyXeTnkSntJlDN9X3kJ9qoWO8+wr9
        r5esOAzqGA7PNJ6gYGIlLMTDRA==
X-Google-Smtp-Source: ABdhPJwkYFBW2TmPZeRXJcUrexQmKR4xdJmfkmnN7Oh42inb9Wtau1p7DRTwWhCZId+ogIBZ4nemzg==
X-Received: by 2002:a7b:ce01:: with SMTP id m1mr3261268wmc.116.1590669310774;
        Thu, 28 May 2020 05:35:10 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id c140sm6027306wmd.18.2020.05.28.05.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 05:35:10 -0700 (PDT)
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
Subject: [PATCH 0/2] regmap: provide simple bitops and use them in a driver
Date:   Thu, 28 May 2020 14:34:57 +0200
Message-Id: <20200528123459.21168-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Hi Mark,

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

Bartosz Golaszewski (2):
  regmap: provide helpers for simple bit operations
  net: ethernet: mtk-star-emac: use regmap bitops

 drivers/net/ethernet/mediatek/mtk_star_emac.c | 80 ++++++++-----------
 include/linux/regmap.h                        | 18 +++++
 2 files changed, 53 insertions(+), 45 deletions(-)

-- 
2.25.0

