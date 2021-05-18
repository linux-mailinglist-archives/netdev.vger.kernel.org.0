Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBE5387A24
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 15:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhERNlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 09:41:15 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:30239 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbhERNlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 09:41:14 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1621345192; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=LNo3e33Jwp/DUaMWUGF2+AqPjxexI2khm2MPog2GVv+qI7lHxv60ObBW1vpYY8GpoL
    0TwXFCGMlc1GFmu9EC1lQ7gBvCu6ObRZsi256D0LXf3PAN53rLh7yVXlaV8xoEilvHAN
    vp9uEcP2AugVOkFnD2cnYK0BsWibPaHGC2fvE1Yr31aPLA3wISVDEGVRikHvy9xRqL7Z
    qSL4qlfRigN4v1F4ar7MkIyS3lo7O8h47g+A+hY5uYdmD7ssYn7q9bmVwnw9+xxG18Uh
    nByL7H1RPmGmVyCohv1fzxIHQcrga2Bq0YZLFNCG0sGkJUOhKO0LkE0gXST7sNU/zI+G
    cLpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1621345192;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=Y1KRDbu5WN3XFPdHGE3A1QrQ6q/NLxWm/b5TELJkolY=;
    b=rNG/seh7q8wSOqLsG87KzEkp180y5PqYra90vA3Gl8uXMhERDZPjakRKxV9Wo/GfnK
    vs0zPJ6sXixX0+O9in8RFlXtNNLD8yD+k4oK/FEEOXrgcVv0H01IErN5ySLQaYEEk4SO
    RXDp0d/xvnj714SrVp/3mHUVPQLeHCzSPYKAfnrwr996akE4q5UDhRi2OBx5DPGplHn7
    4Ny+1asV+uqmxrv27Ub09pL8I+8qCwyqdUHlygKBLHZF8bk7UGZLF/l4yuMOaNBKB5L4
    3GbJONprzX6w7cu8JJRPByHzZmZlf7EQRvPsd+HoEQTVgWzTr4BDOUmn70TD0BFAvOFL
    /cFA==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1621345192;
    s=strato-dkim-0002; d=gerhold.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=Y1KRDbu5WN3XFPdHGE3A1QrQ6q/NLxWm/b5TELJkolY=;
    b=iERjNiZS708Ahp81a9V91zZEQKq4ddOf32Bfg7NLiFzDVMBC6FgmfgllH05jiaDMz8
    fo7thxQ0Z4RhiBj6RGC9+fEZMID2r8A7Wtd2RvO0e7wjRUrmJjzyGFgN1GIXsVCljnmF
    x+hgMZ5LqeflrJjQrMnr+m9hN7LYDz8AAWlA24+YzZWxIZv9zq6WG8KFxr2WWni9whrz
    OuD3fy+9TX/fwdXDJZoQayaQ56b/FQwMZoedvyipKBGzQu42lH5UjgQVLk6nw8iO2b72
    2IqBaTz6wgqK3fR0XqLaTKQGg04i+3H0oiXV0Xr6wJ0RjF3C4Kj7S5b2gb0/v/faR1Gb
    7VCg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXS7IYBkLahKxB4W6NZHoD"
X-RZG-CLASS-ID: mo00
Received: from droid..
    by smtp.strato.de (RZmta 47.26.1 DYNA|AUTH)
    with ESMTPSA id f01503x4IDdp2oJ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 18 May 2021 15:39:51 +0200 (CEST)
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Krzysztof Opasiak <k.opasiak@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        ~postmarketos/upstreaming@lists.sr.ht,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH 1/2] dt-bindings: net: nfc: s3fwrn5: Add optional clock
Date:   Tue, 18 May 2021 15:39:34 +0200
Message-Id: <20210518133935.571298-1-stephan@gerhold.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some systems, S3FWRN5 depends on having an external clock enabled
to function correctly. Allow declaring that clock (optionally) in the
device tree.

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
---
 .../devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml         | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
index 477066e2b821..081742c2b726 100644
--- a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
@@ -27,6 +27,9 @@ properties:
   reg:
     maxItems: 1
 
+  clocks:
+    maxItems: 1
+
   wake-gpios:
     maxItems: 1
     description:
@@ -80,6 +83,8 @@ examples:
 
             en-gpios = <&gpf1 4 GPIO_ACTIVE_HIGH>;
             wake-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
+
+            clocks = <&rpmcc 20>;
         };
     };
   # UART example on Raspberry Pi
-- 
2.31.1

