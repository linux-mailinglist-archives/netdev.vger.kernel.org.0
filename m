Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5022D364762
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 17:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241650AbhDSPrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 11:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241483AbhDSPri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 11:47:38 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155DAC06174A;
        Mon, 19 Apr 2021 08:47:07 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id nk8so5025006pjb.3;
        Mon, 19 Apr 2021 08:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d6IeN222L2AvMC3BWodguJL4uvfgEGERLTNiOfhrG14=;
        b=d+KMjGdwLqY1RKsIEwvO2O/+nJyhETXl0eZQN9OgrfAQFOdo0cPkMwuPXUvA849dKX
         Z0OA/iV0oQNKVvgQASsytNZ+0D/qE25JJIWkIfJ7kVlTwQHmjbP3jXKCfm3fDShGUuzH
         BwMbic2WtsJxI/z4kZTSglL1GG9kr7BRGT1EajjilM5bSWuFXYYGMZmlUPP/vZlo/cQa
         LbiBcQ/44cAnK82wqwyA8jH54x8x4Sk2g/n3vIUevFzHqrJN7yWkX1bCPOfG+Nsn3fM2
         HSEiRieW7yA7bsKjTbnXiMySGxv8aiWYuhmg6xuTDNhQ3QoIOEVkQfWoDug3V6YnIGzO
         YVvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d6IeN222L2AvMC3BWodguJL4uvfgEGERLTNiOfhrG14=;
        b=LoararCX2bApbvYwocq6AL6m3TgHqpjxRb1Qve56YT3X2BsS1XDg/mJN/9h7pQkzj5
         s3pWuqoefAKBKS1Mka/p/E5ZjFp9hyJZWd5KTpezXVOlkCSTJsdsI7QVtxL+8YWiilzA
         IP6CFtWm8CVcetxx6OF5zB4L3feql9K5fFG0VpcMsh8LGpfxtqeXpHU5j73i3FMKAGC/
         fgEmYyCMN7ucuJfZyZAj/wPOcLZAYQ+z4OHnekQzOBt4aWhvF50JEZhqBO//LCBSXxe3
         VUoeOhs+geuHcAJM/vD24di4vAfr1en5rxKmuAgf0hVAOdglYDzZA+X7UxQH4V1Z7wJ4
         WBNw==
X-Gm-Message-State: AOAM532RITgLd0MDkBqWr8BrXjanrGUCnzLTXaoPWSIP8nxk7HnJ0JiK
        I6ySvsa+iRzIVWl+lmnWabo=
X-Google-Smtp-Source: ABdhPJyQOLYsHUKaECSVkjdiOan+lnRWKTgrZi8x0QQ9DX5p0KE3pkRZKrm4yz1se7ftVYlH6bGPag==
X-Received: by 2002:a17:90b:4504:: with SMTP id iu4mr25401047pjb.76.1618847226695;
        Mon, 19 Apr 2021 08:47:06 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id u1sm15314139pjj.19.2021.04.19.08.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 08:47:06 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next v2 1/2] dt-bindings: net: mediatek: add optional GMAC labels
Date:   Mon, 19 Apr 2021 08:46:58 -0700
Message-Id: <20210419154659.44096-2-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419154659.44096-1-ilya.lipnitskiy@gmail.com>
References: <20210419154659.44096-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the mediatek ethernet driver change that adds support for
custom labels and provide an example.

Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 Documentation/devicetree/bindings/net/mediatek-net.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/mediatek-net.txt b/Documentation/devicetree/bindings/net/mediatek-net.txt
index 72d03e07cf7c..500bf9351010 100644
--- a/Documentation/devicetree/bindings/net/mediatek-net.txt
+++ b/Documentation/devicetree/bindings/net/mediatek-net.txt
@@ -51,6 +51,10 @@ Required properties:
 	is equal to 0 and the MAC uses fixed-link to connect
 	with internal switch such as MT7530.
 
+Optional properties:
+- label: overrides the default netdevice name. Useful when a custom name for the
+	DSA master interface is desired.
+
 Example:
 
 eth: ethernet@1b100000 {
@@ -74,12 +78,14 @@ eth: ethernet@1b100000 {
 
 	gmac1: mac@0 {
 		compatible = "mediatek,eth-mac";
+		label = "gmac1";
 		reg = <0>;
 		phy-handle = <&phy0>;
 	};
 
 	gmac2: mac@1 {
 		compatible = "mediatek,eth-mac";
+		label = "gmac2";
 		reg = <1>;
 		phy-handle = <&phy1>;
 	};
-- 
2.31.1

