Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC0D35B90C
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 05:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236695AbhDLDni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 23:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236685AbhDLDnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 23:43:35 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB244C06138C;
        Sun, 11 Apr 2021 20:43:18 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id l76so8329164pga.6;
        Sun, 11 Apr 2021 20:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B7rQ+eZyVc+UGwnL8MpFME+8yUWCYk1WtHWcRPLJGoU=;
        b=SX9V77mQzekQf74AmDKyq12CC70YI2JSMomXypPWg9EHeJO19nYLvD9v1RV/OQhqZ2
         bnJ5kqRCF0sI51ZclyYfkhiK9LsuieMFVM5BMyGSBtOSFI3OnQmY73FUusH6Tq7gNyW2
         osgLXz40/Q0FOx3/MmRNi33vLAK8MLpJUCpJ1aSJSc4Rfl/ljkQoYNCAfyc1Aj/nLRel
         mWEh8nXmAf9GZPeHwdRvCxRvs8ryBxXafF5k8lQFak74lGtR9/mvfyb0hCDlputgEcIh
         PQvVZPo35rol+nKCC9hUzYYCm7LFmGgBN03lYQlYMjwaE1P8oTR+LBzBAMFJU+ehziGn
         guBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B7rQ+eZyVc+UGwnL8MpFME+8yUWCYk1WtHWcRPLJGoU=;
        b=MvU4udW7biqoujelgVsseH9oegXdwPyggfs7SJ47gCNuKbRRE+dsyhMq/2GiPoej9l
         jxzHYcRC6AldYNhqKnKb0kSutOkg31M2GvkHxnoPoutUX94D5T+eEN+i/n73ga5qEJMS
         +SDkNewMBOBQ2R8V/Efvk/VHhLkjKrcsZB8R53TzlJiAmL1jgI+njgZn23nPiRZGbevJ
         Rx6A/TRmfXYpdjqQ97dm9q0y6e5Jh7P/asru77eGOHCAYmK+U3Dq2IMQSqkx8zpneK+2
         EGNr3/kE1DQPWbpHPOAAhDKWx8R0YUK98Fh+Xq9ejWsObiUA83+YkGsyCedLIoPgnL12
         xCnQ==
X-Gm-Message-State: AOAM5333m4kE+nunudtJK8cTHVLNbICSUGorlQeWgHQbZwIA7jCdbZSh
        BZbmG0uSBH/aorCrS1+WR3Tjihh2rWUXhQ2S
X-Google-Smtp-Source: ABdhPJydgOU/45ri7toqVvb8GVdWpTxBGy/14uX4uwb3MKKywYOtmAFOl76qvuEMw6EYJbxuNTiK6w==
X-Received: by 2002:a63:1c22:: with SMTP id c34mr18489418pgc.408.1618198998301;
        Sun, 11 Apr 2021 20:43:18 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id v22sm5387185pff.105.2021.04.11.20.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 20:43:17 -0700 (PDT)
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
Subject: [RFC v4 net-next 4/4] staging: mt7621-dts: enable MT7530 interrupt controller
Date:   Mon, 12 Apr 2021 11:42:37 +0800
Message-Id: <20210412034237.2473017-5-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210412034237.2473017-1-dqfext@gmail.com>
References: <20210412034237.2473017-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable MT7530 interrupt controller in the MT7621 SoC.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
RFC v3 -> RFC v4:
- Add #interrupt-cells property.

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

