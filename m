Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C318388A5B
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 11:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344782AbhESJUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 05:20:35 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:33026 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237188AbhESJUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 05:20:34 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1621415951; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=oKhH+3x37jVYwpsaTvYqbGwxbdMPM/QLgMWWWyUN+DR2KAYrBEQXumRPK+qXQcftTq
    LdYnUgvtt50SUwg8QYe+NF4h9tFPTTlEMcTif174zOZQkrtLHms/51wX6Kr7fFZ+62HB
    KOFkbhNT5wt3AfvIt4tZ1mHGMqmCEqJHDCrKn4nOwY9KgcxfyeqQLuywzxUEOGcNxdlC
    7cRK9y57adashICn9hQkaETqppAgiKXGuQTwY+RJVyb+8xC7EE5bW9/g/T7BvFEwoyed
    FJorbKPronOhbcUJN8+nRk1xi+E7WtVYr31kFouM3ufie3KSTtKCMgHsPfz/9dlADlIk
    MUeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1621415951;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=Zbi+B4/e2Q+/ssyD7Vq4ySlcm/sXYI/o0fZdGdKqrgk=;
    b=W/niXT26d4Wa3wWWU04YNW5JKmQcfzY/1dt0PL15er7C26qLRxacQVsmu2el2PLAT+
    5iR4KkkNg+PQUwV0EnJdvtNcjsmRhBIFA20u6Q2N6Wo7AaPb/1DnDkfScqQOh2ERkkDH
    AqybytYQNf9xGvvpCWcUZUh4oEb6A7O4qjM93KnWtvuXYzVxD5+vaQWSAl8uVixAtBAm
    Wde5r0brz9mtVFX2fS1hos6ge0K5vnt5mvZThayjCDhF2povLCvgBi/fyRaoZFnmuWy4
    O9DJbZ1j435gfzBNbq3XOqBpUbfvpCbWypi64HefDM2BdW3GKQhmjbqyklFDSgpW2zDP
    EJRQ==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1621415951;
    s=strato-dkim-0002; d=gerhold.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=Zbi+B4/e2Q+/ssyD7Vq4ySlcm/sXYI/o0fZdGdKqrgk=;
    b=g0P/DtWfPQbij3eOCD7iESCphhfTFk0DfcgzmYgW/yAz3JF4FjGf3q7KpSzTnptlbN
    Bp7bVv7fXF6BK4MYW68gCIhT4wncUI2dGplNRE45b5Um447zDxXekqtxkEvM9PwDmCjO
    xre3F0tfhIM9hGXp8L3RKH1o0X7npRUZFN5cTQomEs0PBkGSRxpfEuYCSWpCQZmtDZik
    oHsUNblHAleFar+qGl8czFWF8Jmgc/KhVeHKSxb0NQluNKGMtC/X8a5PF3Ov43qTWRh1
    OkVaCieMjGzUvz77XdlVuFWKqY9tFVi/5z3OxmNnurpDbe7gQniQXlU4eK/qxFdhL+vI
    d+jw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXS7IYBkLahKxB4G6NfHcC"
X-RZG-CLASS-ID: mo00
Received: from droid..
    by smtp.strato.de (RZmta 47.26.1 DYNA|AUTH)
    with ESMTPSA id z041eax4J9J95ai
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 19 May 2021 11:19:09 +0200 (CEST)
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
Subject: [PATCH v2 1/2] dt-bindings: net: nfc: s3fwrn5: Add optional clock
Date:   Wed, 19 May 2021 11:16:12 +0200
Message-Id: <20210519091613.7343-1-stephan@gerhold.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some systems, S3FWRN5 depends on having an external clock enabled
to function correctly. Allow declaring that clock in the device tree.

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
---
Changes in v2: Minor change in commit message only
v1: https://lore.kernel.org/netdev/20210518133935.571298-1-stephan@gerhold.net/
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

