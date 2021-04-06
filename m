Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E5735566A
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 16:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345092AbhDFOUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 10:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345055AbhDFOTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 10:19:06 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FEBC061762;
        Tue,  6 Apr 2021 07:18:57 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id h20so7583874plr.4;
        Tue, 06 Apr 2021 07:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7DjmGF6FnRAdOMOxx79iiAfLHcA67arTjIOWyK4tFvc=;
        b=tuFpQyem7+MyofHl1KDCGxnIE9BsTsqrcTnmIFRasapf56OIPO5TFcMvR4t2HLcAWp
         90Mv+yNotGjgJpalZ5jOv/CMz0jwjXmk/aREctLFBtXDsiQFAMidyoFqZkm1e3O71FiB
         PyLTZtBn5+kjv4sG9tSau9F4RUuYcFvM38IQ5Hv6oD6oUUhTFk2sQdp1ik0ulyw9bZly
         FyAKL2w92xiT7L3FQgCQJCJ1DW/1sOuq8wRnpqEtGAzTFDgX0VKmD52L8N5ljh004vBf
         iaVQlizsUAhnF6ksf38ZqqZog3InF4u6fOflhNW8wskTyPj0T8ZJA52ydK2wAl2OAvTK
         DqiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7DjmGF6FnRAdOMOxx79iiAfLHcA67arTjIOWyK4tFvc=;
        b=iTI3dNltfofZ4KfIPoPR36unB7210He8ags83qpnnYwMzTJ6JJaZsd8jEI0WkB1t3D
         +pUmboQn8TrYhoG/+P2xNpi9wcMCIivnzph4Rf8snpdhqYoosfzoFuQSRFoTFe943yRa
         oly4VgGUi2u5BX9hHOfRW46uc3UgOANdO0YxYrMfejkx9BCcaDLoJjMOxBh3RkpzYPVS
         /sNv1mZ/pMl6n/TbQ5jzjQE2u1tlHnwNjjD5AY7GgGz98nJ5jIg0+AprR6MWdY8xvnpX
         aahAmvILJ9LdHLnorRyC3Pc+b9EC7oUvUm28no2QWb6hub2wwjsW3mZWiDUTxxdqih0y
         Mpwg==
X-Gm-Message-State: AOAM5337RVzbnK+hynxvTUwVJDGvwn6CKYT7gJ2mpZN22orSrm2OzRVi
        vtslzY6LaC3U1jEVsqx/Svg=
X-Google-Smtp-Source: ABdhPJxsINrnkef2tA65NnbGwjhL+miREBITUbGbg8CoFi/8e+9oSsiWo5WIJE7CIo/QexG5M3g2Jw==
X-Received: by 2002:a17:90a:7064:: with SMTP id f91mr4768709pjk.89.1617718737378;
        Tue, 06 Apr 2021 07:18:57 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id u1sm18337581pgg.11.2021.04.06.07.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 07:18:56 -0700 (PDT)
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
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [RFC net-next 4/4] staging: mt7621-dts: enable MT7530 interrupt controller
Date:   Tue,  6 Apr 2021 22:18:19 +0800
Message-Id: <20210406141819.1025864-5-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210406141819.1025864-1-dqfext@gmail.com>
References: <20210406141819.1025864-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable MT7530 interrupt controller in the MT7621 SoC.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/staging/mt7621-dts/mt7621.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/mt7621-dts/mt7621.dtsi b/drivers/staging/mt7621-dts/mt7621.dtsi
index 16fc94f65486..ebf8b0633e88 100644
--- a/drivers/staging/mt7621-dts/mt7621.dtsi
+++ b/drivers/staging/mt7621-dts/mt7621.dtsi
@@ -447,6 +447,9 @@ switch0: switch0@0 {
 				mediatek,mcm;
 				resets = <&rstctrl 2>;
 				reset-names = "mcm";
+				interrupt-controller;
+				interrupt-parent = <&gic>;
+				interrupts = <GIC_SHARED 23 IRQ_TYPE_LEVEL_HIGH>;
 
 				ports {
 					#address-cells = <1>;
-- 
2.25.1

