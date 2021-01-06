Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414B42EBD75
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 13:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbhAFMII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 07:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbhAFMIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 07:08:06 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F46C06134D;
        Wed,  6 Jan 2021 04:07:26 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id h22so6062928lfu.2;
        Wed, 06 Jan 2021 04:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rDF/zTGcTs2y4fqV4lAyEpALaGNYk/sTtTAyrIyrxwQ=;
        b=rTd3E0HzFveXtbrDzXFyn5Se+Ubjv0Oo7QrCrhgjq+Myl7+tUq1GHtnH+O85S9Xerz
         NiGkgh3OfFBIs4VdVcA5kw4bHaJCOyIdcwIqnDLQbXxJzfjMOUMwb/H0KtSRiXgfJxZ+
         W47erm7eXiFtZ3PQH6QyIPf3WZlb1Xn9eZSwRleGEaon1rcShhDVp91aNBjmXzc5SPLb
         TKTeXhGccYIZEKax4U2UAVYtsuwe0/AAXpVVS3VdN0QiJPcyAnytUF7pfatRj/5xLxIp
         Y/SdkUOMXgj+9vmfNyzEnx/KC7biFw4MRChd9HPKSu43lTPEmwMusWXGZUaeadg9uf+v
         Yi7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rDF/zTGcTs2y4fqV4lAyEpALaGNYk/sTtTAyrIyrxwQ=;
        b=JVw8rFj7aMiXJh97WP4cnvO7l8fXA8ZzYeUjyfsvL7xoMdWRDaPnzdOEF34paUxIDf
         aYDLUts9DFJC0nCd54qN1RnnwC6BgFJMaD9PDmJjC+ZdHkyf+8fbwlCz0JGvu1Vroe3Y
         jjjHD/iZFqPNHsG7RD4TLAUUztyik0rM+vYznAkGzICYWjuCp8MiJ2zsvCH++0w9KROj
         oDhO25eROcrVuf7sMxojCenRIq7jW3cbLoRPoTp1KasjJJN7ABfEY70I3z8AUN/RXQGg
         vvnm8GKUxbqEI4u/3YuI1YBmUcz9iLilRzv6XJtk/duEjyEkUdZ0QFJmPGQsNmqHQlmX
         btFA==
X-Gm-Message-State: AOAM532g3ERQJcx1idCq53uTpn5FcS9zo1ujp29KEx6O3Czr3hGnmQS6
        pHZAUJ7HN+QIM0BFxUhD6ZA=
X-Google-Smtp-Source: ABdhPJzWuE4nz3FptfKP3PN+vZVWOEAwaOi9H6m5alB3Tf1nPJAZ9pDfft4zIJaTL3RdBs0T20mg8g==
X-Received: by 2002:a05:6512:247:: with SMTP id b7mr1681847lfo.171.1609934844617;
        Wed, 06 Jan 2021 04:07:24 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id v5sm316096lfd.103.2021.01.06.04.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 04:07:24 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next 2/3] dt-bindings: net: dsa: sf2: add BCM4908 switch binding
Date:   Wed,  6 Jan 2021 13:07:10 +0100
Message-Id: <20210106120711.630-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106120711.630-1-zajec5@gmail.com>
References: <20210106120711.630-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

BCM4908 family SoCs have integrated Starfighter 2 switch.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
index a7dba2e0fc9c..995e6774736e 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
@@ -16,6 +16,7 @@ properties:
   compatible:
     items:
       - enum:
+          - brcm,bcm4908-switch
           - brcm,bcm7445-switch-v4.0
           - brcm,bcm7278-switch-v4.0
           - brcm,bcm7278-switch-v4.8
-- 
2.26.2

