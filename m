Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CA93D1085
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 16:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239056AbhGUNYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 09:24:11 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:60987 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239047AbhGUNYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 09:24:09 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 639E95809C2;
        Wed, 21 Jul 2021 10:04:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 21 Jul 2021 10:04:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=l7ug8ue7+utK6
        2Olyu7meE3dxw7j4slos6SGwgmkw0Q=; b=PfTfwfLEFKiRMDH/0ZrwxiEQ1SGtE
        T1gKRQzbcqmBOocYvCnbeypyH8mv/fWmvkBOex7gzHjJ/a1dVQSBF4PShvDAW7dX
        ZuMsRDkZa28B3VkAcybxbXgAWIAqEi3+z59gayj05DEFyY7+rs2p+91FYto3To0E
        oJqQxK7aiiVWCB2Owp42LkLSkC1r2WgRnJsscmtLYAc2de4O8bganQn9xdCnR3z9
        IVaMthc16aiHAAVpsY9O7WG9c7+DkEO8wrJHc7k3IfEuWpK6x3vUGG2gVSA7pGkf
        DHHGuKzcHXXklXLYPOR3VY58yvxujlInPy1Svimdz5/S/8FmFzsWNI5WA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=l7ug8ue7+utK62Olyu7meE3dxw7j4slos6SGwgmkw0Q=; b=HrWrtN3S
        Zj3gtD5V64IoMIQpkLmod7OotAuA9mmvsSZeHc+5yh/6BVz2T1xbJgj6cGVKhi0O
        Vicr2IcosfQWnpLbAMqba/7Nk4pw5K0G02sdRiMofJDyjlzYZXOXV3QfBQqXR4Go
        ERJDrFJDKqZfrabXACgr3f7sauFqd16Oa5boH0uW0d0sCNYqvSlVXxfoQ6uxUUiO
        o7KsNBCFXjia64eIMiUnRAGJYMqw7TZrs4LBHXUgP9VT0fDKvAg9Cns+voeEQwjV
        GCSeMp49EYYncIKSMKDlWB6mUyqD3r+v23X7t/0hFuI8PJxCR4kjbm55ZlMli6dY
        6RD5dogsoZpGVQ==
X-ME-Sender: <xms:fSn4YA_cWo-w7vGy3QUOtxJncVdn5F03zM4JQ1yPPW1JphA2ty8iKQ>
    <xme:fSn4YItIL9NvqNcbkCMLa2q5MgkRMswviLg26YGZGzfVo3BFdPdaz7wpC5etdqwLH
    g30Lq6IBK11lOkO0f0>
X-ME-Received: <xmr:fSn4YGAd08eG4KV9uJhDHFlo7IlDJ3QA98Ne7SsaHkAWvhot2kCQQFo1bg-TNj9LtBjfrfGbeajXsIpSpNb3jLDwg7duTC4i5g1R>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfeeggdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepofgrgihimhgv
    ucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrghtth
    gvrhhnpedvkeelveefffekjefhffeuleetleefudeifeehuddugffghffhffehveevheeh
    vdenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrg
    igihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:fSn4YAcuq1qygfa2DV0DzAy20fTfoUV1Ro5XGAiiH0GSPEQTeaMd9A>
    <xmx:fSn4YFOn9CLZ4qEeb4OsH9hwGIpDP1_eA285uK65VZdbdNVD4cikaQ>
    <xmx:fSn4YKls6msaktPmlXcJNl3zLXoP0gpQtFi1YyusaaPX8_vxEHMIcg>
    <xmx:fSn4YKn7iBYgv16RtbvBWq33XLWOG-cTw80MxB1Q8jS5Bse6RqY-rA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jul 2021 10:04:44 -0400 (EDT)
From:   Maxime Ripard <maxime@cerno.tech>
To:     Chen-Yu Tsai <wens@csie.org>, Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        Alistair Francis <alistair@alistair23.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vasily Khoruzhick <anarsoul@gmail.com>
Subject: [PATCH 08/54] dt-bindings: bluetooth: realtek: Add missing max-speed
Date:   Wed, 21 Jul 2021 16:03:38 +0200
Message-Id: <20210721140424.725744-9-maxime@cerno.tech>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210721140424.725744-1-maxime@cerno.tech>
References: <20210721140424.725744-1-maxime@cerno.tech>
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
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
---
 Documentation/devicetree/bindings/net/realtek-bluetooth.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
index 4f485df69ac3..deae94ef54b8 100644
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

