Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20AC3FD66C
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 11:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243514AbhIAJUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 05:20:16 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:42055 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243510AbhIAJUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 05:20:08 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 77850580B15;
        Wed,  1 Sep 2021 05:19:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 01 Sep 2021 05:19:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=LrL/waN/SgT3V
        TwhPg9YFJlylmLY/yInMq39GRXzfHc=; b=j0Xy3aDUEOjfB+p+atodu59YDxwxk
        r65Ymc+8DXjMl+9tXw48tZF+ryzYwGwX4KbktOnH+f0g6cxxqvM6etHzHZJWAjQo
        PewJQeGDK9BN2Cnx8YIrnBGPIeJprocYTsZhyhP6Jh6vzpTyhjWk0i2kjGEn+nEk
        1Sps6oy8+8MPB7H0KO5RHQEwsBoFkuiyCx5Le2dfMombJ9PisNzoZWlmajW7kGfO
        G74/4PxrmZPPYd1i03qdI1peI/9EdNcPH6k2GftCNkX0W/0qHz7+rwF1Tx+6Wxbo
        JFT+ttqwtTE5kd5PxPB2jANJFTsS650e12nugi3Yqvo/7Xd20347hwVmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=LrL/waN/SgT3VTwhPg9YFJlylmLY/yInMq39GRXzfHc=; b=MvMiUjja
        Lv02VerRZvqNao5txAp9g7sZNXIbwUmIi47Byxh2vpLTRv0znZdNB7yZqduMyJ+R
        5QQCAKND5r4aCkGb9FZQXjgDRzG4H0F/z7oBa96PGw68xnXJf5ngmXKTbDm9/qXA
        zUSENJjEDCJqQzkQ4uJ2NwflT/iqPZxBFVbP6E+yhfeAbzJy0NWe5lXearloTQ74
        vqbQYnNVQUmfDqQdwxNCWcK1WdrPN09inGqLuCJdazS5Z2BHY+nlHnO25bwciODO
        I4PPOVFira70ITS/8VP1DyNEgKqdmUCM7cmcnudxaZg0XWRDyXfdYYw+9nTT7ch5
        hnax4r0w+2b5jg==
X-ME-Sender: <xms:j0UvYfYO9Ap8rZEskhWt1JXVjJBu6jesDTyq62oyHFm7sdTsguXn3w>
    <xme:j0UvYeZ-GVblYEXzhLlkk5bmfqByu5_y1Z5BQi9hYZfhrh7zkzRI3zp2P7dDOtmN5
    hk1ytVBNgERHiQdvew>
X-ME-Received: <xmr:j0UvYR8ERvg3rmXRNWxNPGPR5b4HoqS5mZQuuy6mlna6TFVyTPZKttHsGM3fUlXURhaeFnmuBN_bVOYQFQ40yRTne7XN-ti3Mf6v>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvfedgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepvdekleevfeffkeejhfffueelteelfeduieefheduudfggffhhfffheevveeh
    hedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmh
    grgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:j0UvYVoH-5BogUf0B-CN947emnpiRncDVqjmlAR5u-t7jUAXiSX6Cw>
    <xmx:j0UvYarBuFJkrAO4pA9HQlit0Wz6pGBs8_-fIpUqHJOgUyLnBMRmKw>
    <xmx:j0UvYbTNR6wGy35fjeotXmJKSIJ2GCjc2gV46oxqaQK3qHjw1e6Ghw>
    <xmx:j0UvYQj-WetV8Hjg394VOJsq-i8EZN7fndshAqcW74PTucInO0-LLA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Sep 2021 05:19:10 -0400 (EDT)
From:   Maxime Ripard <maxime@cerno.tech>
To:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        =?UTF-8?q?Jernej=20=C5=A0krabec?= <jernej.skrabec@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        Alistair Francis <alistair@alistair23.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v2 08/52] dt-bindings: bluetooth: realtek: Add missing max-speed
Date:   Wed,  1 Sep 2021 11:18:08 +0200
Message-Id: <20210901091852.479202-9-maxime@cerno.tech>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901091852.479202-1-maxime@cerno.tech>
References: <20210901091852.479202-1-maxime@cerno.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

additionalProperties prevent any property not explicitly defined in the
binding to be used. Yet, some serial properties like max-speed are valid
and validated through the serial/serial.yaml binding.

Even though the ideal solution would be to use unevaluatedProperties
instead, it's not pratical due to the way the bus bindings have been
described. Let's add max-speed to remove the warning.

Cc: Alistair Francis <alistair@alistair23.me>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: Vasily Khoruzhick <anarsoul@gmail.com>
Reviewed-by: Alistair Francis <alistair@alistair23.me>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
---
 Documentation/devicetree/bindings/net/realtek-bluetooth.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
index 0634e69dd9a6..157d606bf9cb 100644
--- a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
@@ -34,6 +34,8 @@ properties:
     maxItems: 1
     description: GPIO specifier, used to wakeup the host processor
 
+  max-speed: true
+
 required:
   - compatible
 
-- 
2.31.1

