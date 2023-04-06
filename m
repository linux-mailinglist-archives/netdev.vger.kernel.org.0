Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2EC6D9ECB
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 19:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239451AbjDFRdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 13:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjDFRd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 13:33:29 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479CA93F4
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 10:33:19 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4087440009;
        Thu,  6 Apr 2023 17:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680802397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lE+ScTHLoYOTTINdJCo2R2wh+bH4oHAkPrK/mHLAqkQ=;
        b=f0W1tbVTTYSTgyLGWEaUacd8Fq1iQGfxKgly4uXEAxMS04op2A9G4jDaF2JVDYHF/VLITN
        KdhA6VqnHkI1mHZ3PbT3i8BGTaqYYhhoGbjRKoiPCuJFglFM+lBoof8PZMH5JI+zJbZA//
        9cFq6eVg9O+o28uyyeeRJiJPU8YSSoaItGJpaemamO2uuPhon9lXzHa0ADzHiGO8Z/BPM3
        t8piJuGCaN9yXFytvZJjXza287N0sHhvXQNd22x+d3mKb6gDJ62sO7sS8LNHfFIVtbOPce
        PPLtLdQo1KWktO9jnjHrNW65wWBVe9ONN3jfXB3XDu4K/Rpv0oioxT0CBWHySw==
From:   =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, glipus@gmail.com, maxime.chevallier@bootlin.com,
        vladimir.oltean@nxp.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com,
        thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux@armlinux.org.uk,
        Kory Maincent <kory.maincent@bootlin.com>
Subject: [PATCH net-next RFC v4 3/5] dt-bindings: net: phy: add timestamp preferred choice property
Date:   Thu,  6 Apr 2023 19:33:06 +0200
Message-Id: <20230406173308.401924-4-kory.maincent@bootlin.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230406173308.401924-1-kory.maincent@bootlin.com>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kory Maincent <kory.maincent@bootlin.com>

Add property to select the preferred hardware timestamp layer.
The choice of using devicetree binding has been made as the PTP precision
and quality depends of external things, like adjustable clock, or the lack
of a temperature compensated crystal or specific features. Even if the
preferred timestamp is a configuration it is hardly related to the design
of the board.

Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
---
 Documentation/devicetree/bindings/net/ethernet-phy.yaml | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index ac04f8efa35c..32d7ef7520e6 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -144,6 +144,13 @@ properties:
       Mark the corresponding energy efficient ethernet mode as
       broken and request the ethernet to stop advertising it.
 
+  preferred-timestamp:
+    enum:
+      - phy
+      - mac
+    description:
+      Specifies the preferred hardware timestamp layer.
+
   pses:
     $ref: /schemas/types.yaml#/definitions/phandle-array
     maxItems: 1
-- 
2.25.1

