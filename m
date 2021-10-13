Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BE542C3F0
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 16:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237741AbhJMOxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 10:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236703AbhJMOw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 10:52:59 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B5DC061764
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 07:50:54 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id r18so11180664edv.12
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 07:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FpjertO2BPyqSfuWgO3BNw0nSj6qKavYY6QdzhU8p2I=;
        b=ILAU0+46XWYxNdy9TQfzF6rFidPJNCX1fB43rPTp1M7vLe3vPK94rEDSwzHcJSsfdW
         o15qDL4/LBTeuEhXak4/6bGWeeP2dj5y2t29NQtBGi3B3c3U1svgYpEQT0p5E1hPq4Lw
         ztilTYz+O2Lxqn5h315XukFQDn7D+rosSeowc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FpjertO2BPyqSfuWgO3BNw0nSj6qKavYY6QdzhU8p2I=;
        b=SQsk07Xqa7oSdgSTMWS4l3k9k5X+XE9vf+MJI9EoUrxS200f7gN8OzVmqSU6TVlm8c
         UNX0MNOHbcYqKgLugbFX5K4X61PT33nt7L9Ty6YBMhybBZI+fIYQ6TvXhhb6jur9fbNu
         spu9MqabFwIQ9BzhlTl8ljCeJexQdoQ113iHQFbxhFqm6i5ekxrGOS9AoRPhyJfkUkZ3
         SSJj/Y4zowwYcGH7dZIk2zdFaGV1KVZIJc+cpMAjNYxorx/BCyDG5403JCk0yv7RPgXc
         TDdO+B7UqgZzCGx4wVzHOToq2sQybnOr789iB6bgRAcZt/aaUsCfo9Oggk562FVWW1HV
         Wdnw==
X-Gm-Message-State: AOAM533sDyJJw+NA22lcXK07UvPX36c2+cinUj7/9R1YIOuW4U0OoJlT
        QaceLnqTOMtEzQXpy+mLa/MF5Q==
X-Google-Smtp-Source: ABdhPJwMsf8aNlQP82hrVxPSoU5V2krZR+BukbA7Crtk7KsNj0DVNiZ1GjeYGhOyquDypWvcHDalaA==
X-Received: by 2002:a50:e08c:: with SMTP id f12mr10360008edl.178.1634136653126;
        Wed, 13 Oct 2021 07:50:53 -0700 (PDT)
Received: from capella.. (27-reverse.bang-olufsen.dk. [193.89.194.27])
        by smtp.gmail.com with ESMTPSA id nd22sm7535098ejc.98.2021.10.13.07.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 07:50:52 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 2/6] net: dsa: move NET_DSA_TAG_RTL4_A to right place in Kconfig/Makefile
Date:   Wed, 13 Oct 2021 16:50:34 +0200
Message-Id: <20211013145040.886956-3-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013145040.886956-1-alvin@pqrs.dk>
References: <20211013145040.886956-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

Move things around a little so that this tag driver is alphabetically
ordered. The Kconfig file is sorted based on the tristate text.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---

v1 -> v2: no change; collect Reviewed-by from Vladimir and Linus

RFC -> v1: this patch is new

 net/dsa/Kconfig  | 14 +++++++-------
 net/dsa/Makefile |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index bca1b5d66df2..6c7f79e45886 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -92,13 +92,6 @@ config NET_DSA_TAG_KSZ
 	  Say Y if you want to enable support for tagging frames for the
 	  Microchip 8795/9477/9893 families of switches.
 
-config NET_DSA_TAG_RTL4_A
-	tristate "Tag driver for Realtek 4 byte protocol A tags"
-	help
-	  Say Y or M if you want to enable support for tagging frames for the
-	  Realtek switches with 4 byte protocol A tags, sich as found in
-	  the Realtek RTL8366RB.
-
 config NET_DSA_TAG_OCELOT
 	tristate "Tag driver for Ocelot family of switches, using NPI port"
 	depends on MSCC_OCELOT_SWITCH_LIB || \
@@ -130,6 +123,13 @@ config NET_DSA_TAG_QCA
 	  Say Y or M if you want to enable support for tagging frames for
 	  the Qualcomm Atheros QCA8K switches.
 
+config NET_DSA_TAG_RTL4_A
+	tristate "Tag driver for Realtek 4 byte protocol A tags"
+	help
+	  Say Y or M if you want to enable support for tagging frames for the
+	  Realtek switches with 4 byte protocol A tags, sich as found in
+	  the Realtek RTL8366RB.
+
 config NET_DSA_TAG_LAN9303
 	tristate "Tag driver for SMSC/Microchip LAN9303 family of switches"
 	help
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 67ea009f242c..f78d537044db 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -10,12 +10,12 @@ obj-$(CONFIG_NET_DSA_TAG_DSA_COMMON) += tag_dsa.o
 obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
 obj-$(CONFIG_NET_DSA_TAG_HELLCREEK) += tag_hellcreek.o
 obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
-obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
 obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
 obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
 obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o
 obj-$(CONFIG_NET_DSA_TAG_OCELOT_8021Q) += tag_ocelot_8021q.o
 obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
+obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
 obj-$(CONFIG_NET_DSA_TAG_SJA1105) += tag_sja1105.o
 obj-$(CONFIG_NET_DSA_TAG_TRAILER) += tag_trailer.o
 obj-$(CONFIG_NET_DSA_TAG_XRS700X) += tag_xrs700x.o
-- 
2.32.0

