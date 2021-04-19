Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE523639DE
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 06:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbhDSEEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 00:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbhDSEEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 00:04:36 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A00C06174A;
        Sun, 18 Apr 2021 21:04:07 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id p12so23328338pgj.10;
        Sun, 18 Apr 2021 21:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d6IeN222L2AvMC3BWodguJL4uvfgEGERLTNiOfhrG14=;
        b=hp1kcgZxFWT8L4BFkOKZifS1WtozMEz2JHpzcAYKcXyohrFfbFPqyKBqsn6UVaaE92
         ujAG3bWmhL7fMQVAsynqU56t4V8rqWcZM2VbZgtgwennO/CJhtf1sTkk6FGc3altf0Ke
         1UwCM7LXFIO9ZJSvQcL2W0XjXxaG3YIjDYXnPO1G4BE4HKn4BKET0yY9EiWLcBlntNmS
         1S6AyBdFKVYPoAwXDqWVaD5gSI8grL8VtmgZ3YMIEgEFDklO0tDT8J4YWoy+/VZ/ExRZ
         XtHqAm4SXDdMYLHfBTTo4Axxo02/L/eko/10X4PPiPJsffZ4902yw7hixvGgfRFgB1H5
         i9XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d6IeN222L2AvMC3BWodguJL4uvfgEGERLTNiOfhrG14=;
        b=tC05CetO6PGGnBSj7P6lMdw+FUGfhFm5B003R3Tbq2aL+VcTXhAlJyHwO+89VHzQ1m
         cFvzLhUZzfTFQ3JnL0wuZaAeK9Ko6+QOj4DcphP5rWr+Lg5QUBqeUy1oeerI1tZrDYO0
         SeOkbuo+nZf7Wa/flOTo3IeMwKXwIPleP0N63huWvTLIfrGT7jenQBQHyob4QgsuOgiv
         QCwVXskiBHqlUWcvGCLLjAcQoFeLF4IMLvP01AKeSI9vBev0VHcouJCjwZwTHkVyzgVV
         Ee6lfCI4+K32m9fknlQsB/d84LTT/80M6QzHqZtC863eG+vI+kNSb/NV6vq/iHdFOA9T
         93gw==
X-Gm-Message-State: AOAM532sieXMX5f9sxxBibH4p9hjkX1bZn1PtECo82NdO7KDAke7MR7/
        cl68vbIwzWzD1Nt5gBQoaS0=
X-Google-Smtp-Source: ABdhPJySGEplzNOMXbX8mZJ9ih1HgpaLsQcB9orNv5Od5eujgBSB/bPGQSA2iseT8Vp27TAWSqWWcQ==
X-Received: by 2002:a65:42c3:: with SMTP id l3mr8072387pgp.258.1618805047563;
        Sun, 18 Apr 2021 21:04:07 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id 25sm12169423pgx.72.2021.04.18.21.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 21:04:07 -0700 (PDT)
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
Subject: [PATCH net-next 1/2] dt-bindings: net: mediatek: add optional GMAC labels
Date:   Sun, 18 Apr 2021 21:03:51 -0700
Message-Id: <20210419040352.2452-2-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419040352.2452-1-ilya.lipnitskiy@gmail.com>
References: <20210419040352.2452-1-ilya.lipnitskiy@gmail.com>
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

