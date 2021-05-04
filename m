Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335C23727B7
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 11:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhEDJEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 05:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbhEDJEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 05:04:06 -0400
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C034C061574
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 02:03:12 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:1ca1:e52f:3ec5:3ac5])
        by baptiste.telenet-ops.be with bizsmtp
        id 0Z35250023aEpPb01Z356l; Tue, 04 May 2021 11:03:08 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ldqxM-002izR-Lk; Tue, 04 May 2021 11:03:04 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ldqxM-00H6vk-2r; Tue, 04 May 2021 11:03:04 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Adam Ford <aford173@gmail.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] dt-bindings: net: renesas,etheravb: Fix optional second clock name
Date:   Tue,  4 May 2021 11:03:00 +0200
Message-Id: <b3d91c9f70a15792ad19c87e4ea35fc876600fae.1620118901.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the optional "clock-names" property is present, but the optional TXC
reference clock is not, "make dtbs_check" complains:

    ethernet@e6800000: clock-names: ['fck'] is too short

Fix this by declaring that a single clock name is valid.
While at it, drop the superfluous upper limit on the number of clocks,
as it is implied by the list of descriptions.

Fixes: 6f43735b6da64bd4 ("dt-bindings: net: renesas,etheravb: Add additional clocks")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/devicetree/bindings/net/renesas,etheravb.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
index fe72a5598addf89c..005868f703a6e2cd 100644
--- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
@@ -51,12 +51,12 @@ properties:
 
   clocks:
     minItems: 1
-    maxItems: 2
     items:
       - description: AVB functional clock
       - description: Optional TXC reference clock
 
   clock-names:
+    minItems: 1
     items:
       - const: fck
       - const: refclk
-- 
2.25.1

