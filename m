Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C9A2F8683
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 21:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388288AbhAOUUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 15:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbhAOUUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 15:20:43 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A726C0613C1;
        Fri, 15 Jan 2021 12:20:03 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id e22so20550426iom.5;
        Fri, 15 Jan 2021 12:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kApooGQIwOz07p5AA8OncskjV3Mmhq6kMk2+q5JbFGw=;
        b=V8jm0deTdWBNjdquMSgeGJw0ktNTDFf/TTeqeCZ5OHBmt0JBNeGV4v+uDGQ41/DcVf
         Kq4QH61o4XpHgG5VoNLnqSbuoHQotIsMevw41/q2NMXnRhVb/mq8DV65C/7d9hk6kY83
         zQ5GvL9jVIxvqGODcxrnLSywa0+rVgdm4+WXkKXXb+w9naXbZXvga+iW6A7lz93CZFmO
         hOwUwmWkgTVfmDlNrXPoo11Pbrdaa6F2YU1mSMdRhUU5GaUxUuh1iV8oTXXsgiOEA9LZ
         t320nNQhaWpJdnk5/WGcRefoU8sABoP91zsz8mjoOZZtKCY8XtGBMdYgv+JIzRJ+GtI0
         Q4Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kApooGQIwOz07p5AA8OncskjV3Mmhq6kMk2+q5JbFGw=;
        b=CR9/Pz6opaJ7QJpraSIlMBV7gXwG2SHGI9BAA3BcX2friEED0vOc1VcbAvn6KeLBYW
         jxucUDvTEfIjUwk0ymY8ojHFgRkT50pygOc3CIy6TATe0XqE5ETVPBqgZYLrRRp7ccyK
         loaI81lKHiWrf4s+2GkvwNNBNI1ZiQz5BkY+FQyZJLMaaUyXup3EliUjEeXBBgTss0oJ
         V89IbjZIJfK1mY4qFigiepkfm5A+pGpNdp+MuNy6xKrT/4MkvnfAPB0Or/2t5+mUGwF0
         QGOQVSBd3jiMaEZ1/Hmqe+0Fr6AYPCDdadWEx4lZ/H8ivu32x5jJ2AvnU/n2DXYTbyjp
         a9Tw==
X-Gm-Message-State: AOAM533BvwNJ+idu4xEfJS0SNr/n9OQg+QKy9rDknILJY6hIySnOkhs3
        tAv9nzzdfgWHg1q9qYTjsvfN/JP8Wo65z3gP
X-Google-Smtp-Source: ABdhPJzr9pTfqOqoKR99Fz8HCYGVkKvwaWFUPCB+qc6i4IXKH8Cq/kVWv7pom4eYem4Ru6B7TuNXWw==
X-Received: by 2002:a92:d40a:: with SMTP id q10mr12535083ilm.20.1610742000544;
        Fri, 15 Jan 2021 12:20:00 -0800 (PST)
Received: from aford-IdeaCentre-A730.lan ([2601:448:8400:9e8:475c:c79e:a431:bccb])
        by smtp.gmail.com with ESMTPSA id e28sm4194900iov.38.2021.01.15.12.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 12:19:59 -0800 (PST)
From:   Adam Ford <aford173@gmail.com>
To:     linux-renesas-soc@vger.kernel.org
Cc:     aford@beaconembedded.com, Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 1/4] dt-bindings: net: renesas,etheravb: Add additional clocks
Date:   Fri, 15 Jan 2021 14:19:48 -0600
Message-Id: <20210115201953.443710-1-aford173@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AVB driver assumes there is an external crystal, but it could
be clocked by other means.  In order to enable a programmable
clock, it needs to be added to the clocks list and enabled in the
driver.  Since there currently only one clock, there is no
clock-names list either.

Update bindings to add the additional optional clock, and explicitly
name both of them.

Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/net/renesas,etheravb.yaml     | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

V2:  Change name from TXC Refclock to refclock
     The r-b and a-b notes were pulled from patchwork.

diff --git a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
index 244befb6402a..9f84d9c6f141 100644
--- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
@@ -49,7 +49,16 @@ properties:
   interrupt-names: true
 
   clocks:
-    maxItems: 1
+    minItems: 1
+    maxItems: 2
+    items:
+      - description: AVB functional clock
+      - description: Optional reference clock
+
+  clock-names:
+    items:
+      - const: fck
+      - const: refclk
 
   iommus:
     maxItems: 1
-- 
2.25.1

