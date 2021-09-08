Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7503F4032CF
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 05:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347421AbhIHDD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 23:03:57 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:35281 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347404AbhIHDDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 23:03:52 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id AE8802B0028E;
        Tue,  7 Sep 2021 23:02:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 07 Sep 2021 23:02:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=yugISvk6ahKA18WyB5Dtl/32FJ
        Cm7tuQeJ17QqmQL+w=; b=hAUo83B+FMlXPMEVpLpjYZ5LAihaKxQikF0NdWeR7e
        qel8VhdrrQKPG9S1MRCKP2sR6bQmtYcepYOp3fEv99AtQ6b5JabKZYuKP94KU/4b
        cTnHbTB0I8s6gYFbaXD3Arrr9nmWsG/UbJAIC4/iQoHBRMdAYIlen5+wmWSLZ7bJ
        H+4O/xyaK3cSp0d3DkeIWBoGKrgZtwALLdgRO2E2koRI/I9dr1pvaebZlieJ70uG
        Fqa8Xd5Fpz1EyO+2nvLb2sNbufoM4KJ31c7iJAgToF8igvSAexQXaBMZ65j8H1sN
        mz9QIkF4Y5NIjRnQlSjyL0Gmojt7pGSBLybqedQzenPg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yugISvk6ahKA18WyB
        5Dtl/32FJCm7tuQeJ17QqmQL+w=; b=X/Dl81qj11QfzZ/yV8DcvSiRgQbZKdkSW
        JhMKvHQWeNZLiDFaiXoKlfyZqJKy7jnDcrezyB6wbzbtR0sZUfw6rX4KLceZo4n3
        kpZn0RDd+MyPqr/NZSwk8tKvm76IZCFbjd+JwCaw8myN/5w2AmvykThu0rBuOOI5
        4jgPjuGZxs+YsplpB+gzj30BcgIBgFpcllKjz+86bJiPBrb8TW5eS+vKoMxThiZP
        oa1BdhvUprgfxUj4VgFtYY2Mum4i0MoyzpavGIVI+ovMgVRfxIl+UV0uBm6TINmq
        gfBsXtzWnXab92cLVgzp1pd9YJM3SGGhvMiixv9b9Y2N5q5bRtobA==
X-ME-Sender: <xms:0ic4Yf4fpAnkqMXlG3Jt7tP90KXlkcqBerJY6T727wXefLyKlfcMqw>
    <xme:0ic4YU7vvZngDWuDEkoDIZ02v0AoeoZOiJ--8pIVk1LNFTYdyjk-bvIauHqzEmz_l
    qfspz9_lBj9e38QrA>
X-ME-Received: <xmr:0ic4YWdQJ1KkhGJI7aPSVRjxKIKzj5NnSvj1qR-Qxj98sVdawxK-TuXFq5CQuGCKaueZxwlYTEVFhUV5GN-yzajwflWM021fzaoku3LdBEgsKwbbZwFP5IRZMe73ngeMpTmU9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudefiedgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgvlhcu
    jfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtffrrg
    htthgvrhhnpeeiteekhfehuddugfeltddufeejjeefgeevheekueffhffhjeekheeiffdt
    vedtveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hsrghmuhgvlhesshhhohhllhgrnhgurdhorhhg
X-ME-Proxy: <xmx:0ic4YQIy0QL8QuNoa5oz7hrMxPYLM6gVeTcCj_Up7gYpXfZC-bMDMw>
    <xmx:0ic4YTLbGzgPudMc2iQQXUbKxD9EfSOCbaeVzQ9MS9dQt8M6UMorQg>
    <xmx:0ic4YZzcydncsRtC-Q3QgnhPN7FdDjnz4voyVvHr3lMZOZQBQ7rtHA>
    <xmx:0yc4YQCe1xku8365-WRlDPGqmzFJbemBpLrLjicGFhkd5U5kxBbyW-rtLKs>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Sep 2021 23:02:41 -0400 (EDT)
From:   Samuel Holland <samuel@sholland.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Cc:     Guo Ren <guoren@kernel.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org, Samuel Holland <samuel@sholland.org>
Subject: [PATCH] dt-bindings: net: sun8i-emac: Add compatible for D1
Date:   Tue,  7 Sep 2021 22:02:40 -0500
Message-Id: <20210908030240.9007-1-samuel@sholland.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The D1 SoC contains EMAC hardware which is compatible with the A64 EMAC.
Add the new compatible string, with the A64 as a fallback.

Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml    | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
index 7f2578d48e3f..9eb4bb529ad5 100644
--- a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
+++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
@@ -19,7 +19,9 @@ properties:
       - const: allwinner,sun8i-v3s-emac
       - const: allwinner,sun50i-a64-emac
       - items:
-          - const: allwinner,sun50i-h6-emac
+          - enum:
+              - allwinner,sun20i-d1-emac
+              - allwinner,sun50i-h6-emac
           - const: allwinner,sun50i-a64-emac
 
   reg:
-- 
2.31.1

