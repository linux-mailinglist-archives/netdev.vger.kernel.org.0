Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5E04287EF
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 09:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbhJKHmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 03:42:24 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:57514
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234329AbhJKHlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 03:41:49 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id DB48240028
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 07:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633937988;
        bh=UgKOyYZwudZNcbOmLjHV2oxljhkCMf/FkAv9xZY25jk=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=VcX+7spCnd6U+Ae1SvJ6nByzv9umNK0MFTJqQhyyT6zUPS34NIgD/5QFP02Pz3YSz
         S9X/6sy8vogjKrIYEzC0w847WiYaJJ0ak9Zv69EygZTSAjTE6F1h7HHwzsJhcImej9
         srYnfkUyZe9RajA0QNQW2rE3NSzdZ8TuxX/YZ5rgbpjpNyO7KQ6LauPo4ClpriR6fx
         Ip+v9mF6anCXRxVOptLhOU4HHXLeYUv8P9gdUD5SkA/w8EYLZCEF4cfYeShmTW13lQ
         /cKHZzjpE1AcSraO53f5zCTSA0Byxv1akTDS5Sv6guGY+hD9mzJFWAf1ydOuiiJcS8
         vWgCiMYAgmlKg==
Received: by mail-ed1-f71.google.com with SMTP id x5-20020a50f185000000b003db0f796903so15056980edl.18
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 00:39:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UgKOyYZwudZNcbOmLjHV2oxljhkCMf/FkAv9xZY25jk=;
        b=fCrn+f+wGvz+tem+bHxCscsvlbfQSgJnJaAKW+wV4YIUjLyf011Xjnk8Vv9YQI7KI4
         WdPPhdRkO/IK4AyGg4A6ghaEkWL1gXsClDBbi9P5XP3XXb3JJtyE44cCAGJEhX0oCE2k
         5sGUjt0Nqy8cSXtGNNlSmCSrSLb8V9+tYU9PkNo4F1fP3D376Y7rz+4C0M81Db8riyxh
         s0skDzvMdTQBPOH1SgHZKPCBthpdIquNrukcbJQSIAf9bDccn3VvjKee8LDvXZDs1kna
         quCp89UM4Vl5IMLMdLX2WSWgceXmxwp1h72P8e+N0xqPQi6j4jqUFdfNEAdMhAn93Anf
         qoYA==
X-Gm-Message-State: AOAM530Bhxmq1rmiZD1CFsxio1C1AFi2UzLPxmqm0Vq/ydvqXbybRuYA
        qxmE6BMTZRnCHBqrncJu2eFYNPDAToWCx8yCbj4eAMv80yjghFAeRoObufk5Is5TjmvwORz3gOr
        3XzpRbIsF6dckpIgi8WM0Wqo8UN6qcEmRGA==
X-Received: by 2002:a05:6402:90b:: with SMTP id g11mr285857edz.32.1633937987496;
        Mon, 11 Oct 2021 00:39:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpldaLH9a88wXudeyQvv2eytBFPukbJ2BYMZlSB5t8tpzJmcsqoMhbsiBWxgjJeaELLuFqBA==
X-Received: by 2002:a05:6402:90b:: with SMTP id g11mr285836edz.32.1633937987365;
        Mon, 11 Oct 2021 00:39:47 -0700 (PDT)
Received: from localhost.localdomain (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id y8sm3023965ejm.104.2021.10.11.00.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 00:39:46 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Charles Gorand <charles.gorand@effinnov.com>,
        Mark Greer <mgreer@animalcreek.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 2/8] dt-bindings: nfc: nxp,nci: document NXP PN547 binding
Date:   Mon, 11 Oct 2021 09:39:28 +0200
Message-Id: <20211011073934.34340-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211011073934.34340-1-krzysztof.kozlowski@canonical.com>
References: <20211011073934.34340-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NXP PN547 NFC controller seems to be compatible with the NXP NCI and
there already DTS files using two compatibles.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml b/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
index 70634d20d4d7..7465aea2e1c0 100644
--- a/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
@@ -12,7 +12,11 @@ maintainers:
 
 properties:
   compatible:
-    const: nxp,nxp-nci-i2c
+    oneOf:
+      - const: nxp,nxp-nci-i2c
+      - items:
+          - const: nxp,pn547
+          - const: nxp,nxp-nci-i2c
 
   enable-gpios:
     description: Output GPIO pin used for enabling/disabling the controller
-- 
2.30.2

