Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A9D388554
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 05:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353013AbhESDd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 23:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353035AbhESDd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 23:33:58 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874F7C06175F;
        Tue, 18 May 2021 20:32:39 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id h7so6254384plt.1;
        Tue, 18 May 2021 20:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PDM0WuZX1yIfkmFl6be0esAhzpUXa3/Aurhrr7XvDPM=;
        b=oyAW7BlbmqjuHJBPJb1YBJ8fZJgNvvTlbqP2zwAUMP3CwKxp19dWpxoQIu/n+do6Yx
         tJKA28crQFPZqY/1sE16YEbcC3R3wmkUvSr4MJPiitnLsnKru+MW0WeklCO29wfxquyl
         Msdc10P866HoPbayGW8P5XmDQNMFFoNom1//VPwA0sESGw7vSHI+E8q3txA9et9g/bbS
         xnIRKNXjbJR/tBelY6c3CwEnEcp3tz0u5ZqkYWZNYMCitFdpRJ2gnl7gKiZSs6ZQOdo+
         9u9Old23sAkc3w6XraC/j8BekVH/bjS//B8yQVWJR2dlGJzwt1du2dB4y5XGF2X5Fy9o
         Gbpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PDM0WuZX1yIfkmFl6be0esAhzpUXa3/Aurhrr7XvDPM=;
        b=Jo4AwPyRJjiZS5L+utNc5IsfCmQzoWxIvhS5XjJk7DO0IJ0ImfBS87NxAL6Uw7H8li
         lDgAXnNf4Kl90V2OGWuhLB+CcB+/i0VkmhgGmqVaZnVvibMxVqbMG62or5rav1vDSfjY
         tSzLmW4wMfoQXaE/M1WIoiJjsGRe74gvN72rEE1m7EjC9QCD/N3vsB6zEkM8XhcPyR4h
         FtIdF9Ist/MOEFSDgxYd04voBr5lw7dQpsHEhs6FA7t0uufEtCqHft4rmr09zk/VuxuF
         xww+DSsTCAHmxdM3pZ3AeZg+CpJPOIhbHiTKWmt1V38yx0evSxF49qlPp1uXARWSLRM0
         kSBQ==
X-Gm-Message-State: AOAM530fqjQyiPghdaynZBqaHyIMPNkKuB87PGaWE+H6nZnNkzqS3iIm
        VKksc6WoPTzTNPSZjugT/YeDcS1ruVggRdo1kEI=
X-Google-Smtp-Source: ABdhPJwqtxge1uuHi1Aa0NPjjm29H2edDQ6TIs+ffsUAY3h0ZbqTsJsBWS/aurSb0mTdAXXo9PWpcg==
X-Received: by 2002:a17:902:bd09:b029:ec:7e58:a54a with SMTP id p9-20020a170902bd09b02900ec7e58a54amr8523868pls.62.1621395159142;
        Tue, 18 May 2021 20:32:39 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id g13sm8244587pfr.75.2021.05.18.20.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 20:32:38 -0700 (PDT)
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
        Marc Zyngier <maz@kernel.org>, Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v2 3/4] dt-bindings: net: dsa: add MT7530 interrupt controller binding
Date:   Wed, 19 May 2021 11:32:01 +0800
Message-Id: <20210519033202.3245667-4-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210519033202.3245667-1-dqfext@gmail.com>
References: <20210519033202.3245667-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add device tree binding to support MT7530 interrupt controller.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Rob Herring <robh@kernel.org>
---
v1 -> v2:
Fixed plural (property -> properties)

 Documentation/devicetree/bindings/net/dsa/mt7530.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/mt7530.txt b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
index de04626a8e9d..18247ebfc487 100644
--- a/Documentation/devicetree/bindings/net/dsa/mt7530.txt
+++ b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
@@ -81,6 +81,12 @@ Optional properties:
 - gpio-controller: Boolean; if defined, MT7530's LED controller will run on
 	GPIO mode.
 - #gpio-cells: Must be 2 if gpio-controller is defined.
+- interrupt-controller: Boolean; Enables the internal interrupt controller.
+
+If interrupt-controller is defined, the following properties are required.
+
+- #interrupt-cells: Must be 1.
+- interrupts: Parent interrupt for the interrupt controller.
 
 See Documentation/devicetree/bindings/net/dsa/dsa.txt for a list of additional
 required, optional properties and how the integrated switch subnodes must
-- 
2.25.1

