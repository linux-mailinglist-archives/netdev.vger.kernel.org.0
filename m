Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147FF20B562
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 17:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730153AbgFZPyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 11:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730100AbgFZPxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 11:53:49 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4468C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 08:53:49 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 22so9283483wmg.1
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 08:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3dhW1zpRJn6MuRyNGCR+XtNKordche0o+F/kMzuScM4=;
        b=zXTm3SG4EoOLmldH7ZgAjJ26q5anOcvWlaFRF800csm/wbDScWfDqVfZY2lEq+T/5Z
         AzitLOlzdCV50x2F3e/M8dqvwpbS9hQ6QGtNzOXcOuwvqyz2y1fEHn4t20kTYLR4ohb8
         yk0FUGDecRrzsTKtLZN1dtETEhB0HSezENWRlxgn16BA6ideO+8VXUVTyhl/tpSoYCwO
         sDMnoTJbJlk3Fs8Ikn0w9mqn/M+E6RLqFKj0oJqXr4bQsBJh4EIiImPPXdLKIe/dR8Hd
         6CcLr/fjTFvFVw7/M0vnWkLXpgAsSJrcEq3Vlt22Gd+pywTK0UCbaTBorxQ2G+W7+r+1
         Vg5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3dhW1zpRJn6MuRyNGCR+XtNKordche0o+F/kMzuScM4=;
        b=q1CsEqTv97wgAG4vOtDZMC1JAuKq8nb282tsiC4gAzmwHwv10h3SDgw+SEetVlHJXy
         gkwPfJqwLowZ2gPJ90bCJTLk2pEzeodGCegswJJauf1l+4qiethGb40Ey8rcPEpEqUZM
         j5brEhSSLhZnF2M9WQ6tW2sIMqq8/lag8B8l7Ilva+F84MwtBTHRsaQC4CcFZXjYdIpP
         eORXC29C7oqm2TIOCeYpT4IXpyI92aIuv7Gc3+po+AuK0FfBi98SfQYwnv+SlOnC2lty
         STMIMy4T2O0HO/tl1PTx9MWvpMO+dpYE6Gn2TgDAeAFCG199yE3+iIGaKk+F7va0Zex3
         gung==
X-Gm-Message-State: AOAM533CsjLAZr4aVqUVseULMc4iGyyjtY4I4sTyUvO4E3zH0G2Xd6VK
        jmWzsoBiVbeK5sMIE25pXCIsnw==
X-Google-Smtp-Source: ABdhPJwG77d1JFYmn17Dsojx0FfCnFgXgA6Gd2Cbr/BKlfKTgWUJKL+qCHyGaeiNfaxBJ3DK7ckO4g==
X-Received: by 2002:a1c:80d3:: with SMTP id b202mr4226820wmd.111.1593186828506;
        Fri, 26 Jun 2020 08:53:48 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id h142sm8242791wme.3.2020.06.26.08.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 08:53:47 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 4/6] net: mdio: add a forward declaration for reset_control to mdio.h
Date:   Fri, 26 Jun 2020 17:53:23 +0200
Message-Id: <20200626155325.7021-5-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200626155325.7021-1-brgl@bgdev.pl>
References: <20200626155325.7021-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

This header refers to struct reset_control but doesn't include any reset
header. The structure definition is probably somehow indirectly pulled in
since no warnings are reported but for the sake of correctness add the
forward declaration for struct reset_control.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 include/linux/mdio.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 36d2e0673d03..898cbf00332a 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -18,6 +18,7 @@
 
 struct gpio_desc;
 struct mii_bus;
+struct reset_control;
 
 /* Multiple levels of nesting are possible. However typically this is
  * limited to nested DSA like layer, a MUX layer, and the normal
-- 
2.26.1

