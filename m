Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085FD36E4D5
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 08:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239316AbhD2GXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 02:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbhD2GXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 02:23:00 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FB9C06138B;
        Wed, 28 Apr 2021 23:22:12 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id k3-20020a17090ad083b0290155b934a295so3964236pju.2;
        Wed, 28 Apr 2021 23:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RSIa7cBeJXNMWSKO0g+y/qJaGWxsHGcVnf++n7k/uXw=;
        b=BRiQ7/DW5YHwWO7c9iXHCGkrjRhxLKv9pg5hGtzg+gFnL9Nvlgjnkf1yYCu0SW5yzJ
         AUjvGQyY3l+d5rz7Ctg7S615v/rQYvfgcRIKCFMXFpGPndl+wZ/EORLtJY4B5mn2QsCx
         UGzG8fBwRxkBDtHatHgiZuG9zf2iIYKdUCgvtvjKOTzH7wz1MQ/ngQo/AnKKFOcIWeKX
         4nkA+T1OKeAf8aoVn1IShyvoyJKyGhDEok2cmttnKyDIlr4Md7Rsp+NDMA34Jdp61HA+
         qrl8FT1SuRMiTMzD0oZYF7sDt3VUkCbS/74b9+NTZSB0nwyfjIeVjio6OoTpTBYFuJZs
         ZBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RSIa7cBeJXNMWSKO0g+y/qJaGWxsHGcVnf++n7k/uXw=;
        b=pKzbH5gO3WogU8AOcLzIl10e07g5E1HE5/1/2Q1Ee4W6bQRflApg/csWCJM0eUmVFO
         rMJo6DhduXrmGSREq5V7WoREnGqBUX7xLh/IAZbLpQvsTCSilChbNsWnvZ+mlermJYBC
         ER4ZXqXZ8V4yX8NtcxDog9TPr5xhKL3+3+IJQTEFmSuM7SzwXCKyqmx8SK1rNaZxyAeS
         2LX6SjE2XhYyMirDAmA7QJrWSGXDVv6zw34ftSHQ25FK6e+1xvfg9dsOnIOZs+AP1dbo
         KhDKmCpflGtAiPkG+CST1RyQ31Lz+OKseWR056zOd6gnpl3OA7u8YR3dh3EAogTzjpqd
         SLTA==
X-Gm-Message-State: AOAM533xqw2PkV5QLgs219Goq2en/yHsGz4VQ+SYnZpUIF6uVMXPcm1a
        9nPMEFLgMBoV4vkOTuy3sLQ=
X-Google-Smtp-Source: ABdhPJz78bH+9TBRL6WkYhA1HjaOrdEk/3am69Dj1OmvsxGayn11HtBOKdGvNOoxsDI1jcc4AlHTUg==
X-Received: by 2002:a17:902:a582:b029:ec:d002:623b with SMTP id az2-20020a170902a582b02900ecd002623bmr34077406plb.36.1619677331784;
        Wed, 28 Apr 2021 23:22:11 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id b7sm1431008pfi.42.2021.04.28.23.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 23:22:11 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH net-next 4/4] staging: mt7621-dts: enable MT7530 interrupt controller
Date:   Thu, 29 Apr 2021 14:21:30 +0800
Message-Id: <20210429062130.29403-5-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210429062130.29403-1-dqfext@gmail.com>
References: <20210429062130.29403-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable MT7530 interrupt controller in the MT7621 SoC.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
RFC v4 -> PATCH v1:
- No changes.

 drivers/staging/mt7621-dts/mt7621.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/mt7621-dts/mt7621.dtsi b/drivers/staging/mt7621-dts/mt7621.dtsi
index 16fc94f65486..0f7e487883a5 100644
--- a/drivers/staging/mt7621-dts/mt7621.dtsi
+++ b/drivers/staging/mt7621-dts/mt7621.dtsi
@@ -447,6 +447,10 @@ switch0: switch0@0 {
 				mediatek,mcm;
 				resets = <&rstctrl 2>;
 				reset-names = "mcm";
+				interrupt-controller;
+				#interrupt-cells = <1>;
+				interrupt-parent = <&gic>;
+				interrupts = <GIC_SHARED 23 IRQ_TYPE_LEVEL_HIGH>;
 
 				ports {
 					#address-cells = <1>;
-- 
2.25.1

