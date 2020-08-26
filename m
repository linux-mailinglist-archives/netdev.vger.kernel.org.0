Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60A9253A74
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 00:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgHZW5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726929AbgHZW4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 18:56:45 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3311C061574;
        Wed, 26 Aug 2020 15:56:44 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id w14so4265603ljj.4;
        Wed, 26 Aug 2020 15:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Faqc4Y9V7/YRWZwITUiurHwxzcpfGAmHW6joRfPlemE=;
        b=lmB0LDB+1vQqs+eJfL1qEVGeBIDKO6Etz3hYkvun8GOSnCfD8+mtdlAGRcmu4XUWlk
         moo1Q0TZkVepYDg8xveCv1ZqQRFvPZVANhKYoOWDD/S6suUO5WDh8UIzbMG/pKEBzcMi
         QByv0YZe2eeFNbWSQ9Wohjjf9DbHR41K9AAO8bNyZjU1290xUvmL5T7CkltlhQ6WMtez
         4dC3MOYe3Hdskh5ZtwUYOs+B7HtknSlrxW1bY6+F9uG5olqRg+Llz2DCl4nwk6qJPP7b
         Vh27lpnRmBWj6CUR92qLAN4ZjfIyUGjEa9AEDumyEHb4HACWF7BIE0uhDYyNMsVxXA8Z
         6mKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Faqc4Y9V7/YRWZwITUiurHwxzcpfGAmHW6joRfPlemE=;
        b=b382khUh4T2AgfbxbvaQdGX+L8Oxd9whG83lEjZdP6GFWCVqHzPSfVkTPYjVtEEtVr
         rVgBbEssDyDigQuLEYmmKMDbbPkB3etaBmNpml6teISUhOqAvHDaKK8NGpOc5cpQQtf6
         tsaT2zeGEOxmmrusfkei47zXmXY/6VS1knjtAndXhjh8im5FhaoV/469q8ogF7VutGlj
         5jzaJY/mzo1hJNhriEdAKX9M3P2W9U4jKBa0Tr4JIIqwi66S8sRJAlHDHyOg3DLwBBdL
         VonKHgQtcbPoEEL5pjshKq4SpYhTDO13/LmHkOXoQV2JegfrBoP8Lce7zQfxacgKfFAM
         iA4Q==
X-Gm-Message-State: AOAM530474UO6H7HVRLeUcYtxlPUv3g1JTRNQ+v+rS35zl5QXvqs+8sU
        0YLDHH/fo5cC20wnW2Twt08Zn18dzuFtWg==
X-Google-Smtp-Source: ABdhPJyUt3p1ehjR9dqBkgLWDFtQon1+zZydUewkZUdKSYezBlbKsX5ZjoZxjY1ZM85rtKZo3y7Dig==
X-Received: by 2002:a2e:918f:: with SMTP id f15mr8087271ljg.86.1598482603215;
        Wed, 26 Aug 2020 15:56:43 -0700 (PDT)
Received: from localhost.localdomain (h-82-196-111-59.NA.cust.bahnhof.se. [82.196.111.59])
        by smtp.gmail.com with ESMTPSA id u28sm49075ljd.39.2020.08.26.15.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 15:56:42 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next 4/6] net: phy: at803x: constify static regulator_ops
Date:   Thu, 27 Aug 2020 00:56:06 +0200
Message-Id: <20200826225608.90299-5-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200826225608.90299-1-rikard.falkeborn@gmail.com>
References: <20200826225608.90299-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only usage of vddio_regulator_ops and vddh_regulator_ops is to
assign their address to the ops field in the regulator_desc struct,
which is a const pointer. Make them const to allow the compiler to
put them in read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/net/phy/at803x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 101651b2de54..ed601a7e46a0 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -343,7 +343,7 @@ static int at803x_rgmii_reg_get_voltage_sel(struct regulator_dev *rdev)
 	return (val & AT803X_DEBUG_RGMII_1V8) ? 1 : 0;
 }
 
-static struct regulator_ops vddio_regulator_ops = {
+static const struct regulator_ops vddio_regulator_ops = {
 	.list_voltage = regulator_list_voltage_table,
 	.set_voltage_sel = at803x_rgmii_reg_set_voltage_sel,
 	.get_voltage_sel = at803x_rgmii_reg_get_voltage_sel,
@@ -364,7 +364,7 @@ static const struct regulator_desc vddio_desc = {
 	.owner = THIS_MODULE,
 };
 
-static struct regulator_ops vddh_regulator_ops = {
+static const struct regulator_ops vddh_regulator_ops = {
 };
 
 static const struct regulator_desc vddh_desc = {
-- 
2.28.0

