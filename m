Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E913639CA
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 05:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237354AbhDSDn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 23:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbhDSDnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 23:43:24 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E14C06174A;
        Sun, 18 Apr 2021 20:42:55 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id z16so23291927pga.1;
        Sun, 18 Apr 2021 20:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FjmLOq8AscliWv+GjWQBYtgkGTnMApgANFmdxbvdJ2Q=;
        b=WbPn5dbLh4aFvVmT5ar1EU2Ik4b66KqeuOQsi+yxhJiYauhJZ8VGl79NcwLlm2NDiQ
         kQNrVyLAgO+U1VDGF1LaKeIPWAXfCcSrunA4AHxW/CMbv98j4Dma9W1w63F4SoTz7KX4
         NOSyJQxVFIADh85rlrWRwuK1R2GQnieSVYYwPsicjWpxIIP/dJ4X1p4hiZMBQvNIzjDh
         wyf/tj0eZggxroVzT+yjNG/yUfj+G2f7027fhR9Y9bfvdw2qHt+EiFHbia3GMI4zxARq
         wBhwoS7NG/lH8Hdnul/CUREzQ1+zKZwjuFmcao2IDLazNAlj8RECgmrdUKqORIwlZoa4
         ZtmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FjmLOq8AscliWv+GjWQBYtgkGTnMApgANFmdxbvdJ2Q=;
        b=IYRTrJTyM6x27Y0Nv/JHRn19t/sGrPpYzju4fBjJay5T0Bjgrz3W3rNdKtYDyNKdXO
         R8SIGgPTN6qNOoSL1T+9WsmDeN4qYcjOzEmbByRXVhP998+xGtBAAaeBVepwLrYqEl9O
         if2+ADH5wXRkZ4PjWT3YDzzL35eXfyy4w9mDR5INfMCdv204NWRBH5VRDJVjYkCtwLSX
         K0miC/cG9gyGLAtXCk2GkoY9zcS4LOltn18jBD/jdBuTEgy9QEZGTZxBLL+pfGLm6/WU
         tYWYujWlFJy2c+AdOaHolIIc6k57qINgNF9h9EjT/nkntMpPUXUE30HLcOlWICGO7XK0
         MaWQ==
X-Gm-Message-State: AOAM532DbYdbI7KGmvR0JqbJH17JynsYEfPC7FT7UTDtbRhn7kRYbZrZ
        7SbDnPOHagFdHQqCHWdzdl8=
X-Google-Smtp-Source: ABdhPJyoeOP0a/t5AWeTecXUJVWmB3q/yKl6pz4SiOFjNc/pWuDErwkkhtu6tb0rZWDuVNO5McblIw==
X-Received: by 2002:a62:be16:0:b029:25a:e1b4:5deb with SMTP id l22-20020a62be160000b029025ae1b45debmr10911501pff.66.1618803775470;
        Sun, 18 Apr 2021 20:42:55 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id g24sm12477681pgn.18.2021.04.18.20.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 20:42:55 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Greg Ungerer <gerg@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sean Wang <sean.wang@kernel.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH] dt-bindings: net: mediatek: support MT7621 SoC
Date:   Sun, 18 Apr 2021 20:42:53 -0700
Message-Id: <20210419034253.21322-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing binding documentation for SoC support that has been in place
since v5.1

Fixes: 889bcbdeee57 ("net: ethernet: mediatek: support MT7621 SoC ethernet hardware")
Cc: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 Documentation/devicetree/bindings/net/mediatek-net.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/mediatek-net.txt b/Documentation/devicetree/bindings/net/mediatek-net.txt
index 72d03e07cf7c..950ef6af20b1 100644
--- a/Documentation/devicetree/bindings/net/mediatek-net.txt
+++ b/Documentation/devicetree/bindings/net/mediatek-net.txt
@@ -10,6 +10,7 @@ Required properties:
 - compatible: Should be
 		"mediatek,mt2701-eth": for MT2701 SoC
 		"mediatek,mt7623-eth", "mediatek,mt2701-eth": for MT7623 SoC
+		"mediatek,mt7621-eth": for MT7621 SoC
 		"mediatek,mt7622-eth": for MT7622 SoC
 		"mediatek,mt7629-eth": for MT7629 SoC
 		"ralink,rt5350-eth": for Ralink Rt5350F and MT7628/88 SoC
-- 
2.31.1

