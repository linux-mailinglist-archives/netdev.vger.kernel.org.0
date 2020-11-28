Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49AE92C7679
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbgK1WzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 17:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgK1WzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 17:55:17 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2984EC0613D3;
        Sat, 28 Nov 2020 14:54:37 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id l1so9764231wrb.9;
        Sat, 28 Nov 2020 14:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pK9Ea/lgfc3fvgVFGg7cOxa+M9VALejH1ACdbsPKEMs=;
        b=nmHd2TevB8pFTfshsA8RnxSQyuL2AAIj267/vJnzTiOWPNVDN8ceOlhKFYYg1C0RL5
         qkNHODFKbPacJYAqBbVyE1R1kxyXkiEsq9VDr6T3F0Pzjcv3h8G1W2mWR+gWduYNCPwx
         PUH9IEUtRTA+3IVJoalQn3Zzfn2jLeL5shsDjgTFlGZgvtdedcav0t+cjw54FwdgmQPX
         6TV3LSA4YbH2zZSZHR6EfFc7STj7asKszDqDGShb49q9WVZuJbt/u+7MX15xV7VDo3FN
         kqwh3UIPOczUpMMvTXvSKhNz5/9YV9dtpaOXbiqAgw5Lt2TKqfuLKzARKOI3wicNeXmb
         6y0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pK9Ea/lgfc3fvgVFGg7cOxa+M9VALejH1ACdbsPKEMs=;
        b=PlpGihDmR+7NyU+z6PGn64xAFL7I8vnNshjcOomCNmkZ6jWTSCLTcpedBEk1ATmhWn
         CwAHmYh1y9JsJmVidLqhtGgLRW7/8pw3QQwPD+i3vSopjOZsYNN+2UV5ZGBAZQxLUnfT
         NlE6Stv3y8DJQe+vhr+2n39YhLpn6XHsaoxsFlbWwFEe6qedu9HiOMr5Vt8lHRw6sXsb
         cQNpcjNbLhz+oBXRXj2A+N1BbsaTp8IBUtYN9pN9E1il35ZNTGNknNMwA+7w/QGrnbj3
         zsS6HUPCXU6Ox8wGhc03jYUYLyzrrlY9n9AUI5El9FasZIDWKaSotuSTN+TINYpLH7+K
         hz5A==
X-Gm-Message-State: AOAM532cEWrUBqFM02Ho68h8JBFvhqV0TVJh8/smU3Wu+55AvvfNuMAR
        LMnGLlquYm8kN2pJmiik2KU=
X-Google-Smtp-Source: ABdhPJzdyErr8cs5tsLS+ZbaWXTssjqNORLamAngXh3vqxJSdBmE2QgGccfdpJqXKCravltxrU9DSw==
X-Received: by 2002:a05:6000:347:: with SMTP id e7mr19715253wre.35.1606604075863;
        Sat, 28 Nov 2020 14:54:35 -0800 (PST)
Received: from adgra-XPS-15-9570.home (lfbn-idf1-1-1007-144.w86-238.abo.wanadoo.fr. [86.238.83.144])
        by smtp.gmail.com with ESMTPSA id d13sm24231506wrb.39.2020.11.28.14.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 14:54:35 -0800 (PST)
From:   Adrien Grassein <adrien.grassein@gmail.com>
Cc:     fugang.duan@nxp.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrien Grassein <adrien.grassein@gmail.com>
Subject: [PATCH 1/3] dt-bindings: net: fsl-fec add mdc/mdio bitbang option
Date:   Sat, 28 Nov 2020 23:54:23 +0100
Message-Id: <20201128225425.19300-1-adrien.grassein@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dt-bindings explanation for the two new gpios
(mdio and mdc) used for bitbanging.

Signed-off-by: Adrien Grassein <adrien.grassein@gmail.com>
---
 Documentation/devicetree/bindings/net/fsl-fec.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
index 9b543789cd52..e9fa992354b7 100644
--- a/Documentation/devicetree/bindings/net/fsl-fec.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
@@ -22,6 +22,10 @@ Optional properties:
 - fsl,err006687-workaround-present: If present indicates that the system has
   the hardware workaround for ERR006687 applied and does not need a software
   workaround.
+- mdc-gpios: Bitbanged MDIO Management Data Clock GPIO. If specified,
+mdio-gpios should be specified too.
+- mdio-gpios: Bitbanged MDIO Management Data I/O GPIO. If specified,
+mdc-gpios should be specified too.
 - fsl,stop-mode: register bits of stop mode control, the format is
 		 <&gpr req_gpr req_bit>.
 		 gpr is the phandle to general purpose register node.
-- 
2.20.1

