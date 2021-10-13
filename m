Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3887942B219
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 03:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237611AbhJMBTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 21:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237010AbhJMBSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 21:18:43 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17D0C061762;
        Tue, 12 Oct 2021 18:16:40 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id i20so3098501edj.10;
        Tue, 12 Oct 2021 18:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=I7/2mOCuSGi00O37dYhVmntD5IhCZQlkid+4wMza39o=;
        b=OODHe90IewNddL5u/Fu/UvqTxVKhCVjU0kmoSf/Hyvdd3Zwajjf1Qjgg8CkU7ohb65
         +sMN1GptB8cY/F6oyzDhLVRLhq+35EbA+hxdMhtuqnboyGUNpyd5adrpe0KNd7CYP0bh
         EDuU41V6QQqTiYkhImlMLk3Yl82kuaOl7T8IDxCMA45ZSeo5Gw6lE/FPTuTX+47BnnBu
         jDkaaeK/N8XTUTS3/lFQyF2JSikuIGd2fWkceYJW4/7uzKZEDcTmJHIeJC34kJJmfcOF
         8Z4iEOHlTIPH3g6cGyJ4oDkiFDIv5MLTEOD66gQKvWqBDxUiGEbATxg5wiD3gMC59X+X
         nF6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I7/2mOCuSGi00O37dYhVmntD5IhCZQlkid+4wMza39o=;
        b=dkg4w3g/ysQ7SRzN6Iqo7W7v/ewj16/i2DCuTfueLzG0f8WZpg21n21X1XZawBual9
         +m70XoC1hKH2fcqiJpqUEtHH13F7ObVimJ3XXAO7VRn0OIdJueLiyqvDAP83Mj3WyW+V
         KARXJxGEsDR68jfjpJ3r2KuGoZ3Wj4R42cNZungAZZ2HcWkOaxGrUII1y3ymrPneHTAR
         XrJzvjXhtMs7vViY1KvwAzWJeaN5lng6Y01qU+cyjgvdoTcYh6YgME/ztQCeXPDn0GNi
         F99LPmPU1PiF+kEkd+Cib++v8rjmx0/m8yoozAlBolDx4W8YlBljbLGABimU9U7wkFSA
         ewRA==
X-Gm-Message-State: AOAM531FSeGVb5DbnfnyrZqszVSIZvZKqh/dMfcWjUACRomB7mVb+v+V
        omalsTQwDP5MX37YTSn6CKA=
X-Google-Smtp-Source: ABdhPJxYG8x3tbDFnztZ54v2gNYvaRqupjLscG01iTEBOgEtJ3ylpcrHCY4jN1nowSiaUjOE0DOwTg==
X-Received: by 2002:aa7:db85:: with SMTP id u5mr5000996edt.234.1634087799168;
        Tue, 12 Oct 2021 18:16:39 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v13sm6894630ede.79.2021.10.12.18.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 18:16:38 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        John Crispin <john@phrozen.org>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [net-next PATCH v6 11/16] dt-bindings: net: dsa: qca8k: document support for qca8328
Date:   Wed, 13 Oct 2021 03:16:17 +0200
Message-Id: <20211013011622.10537-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013011622.10537-1-ansuelsmth@gmail.com>
References: <20211013011622.10537-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QCA8328 is the bigger brother of qca8327. Document the new compatible
binding and add some information to understand the various switch
compatible.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 9e6748ec13da..f057117764af 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -3,9 +3,10 @@
 Required properties:
 
 - compatible: should be one of:
-    "qca,qca8327"
-    "qca,qca8334"
-    "qca,qca8337"
+    "qca,qca8328": referenced as AR8328(N)-AK1(A/B) QFN 176 pin package
+    "qca,qca8327": referenced as AR8327(N)-AL1A DR-QFN 148 pin package
+    "qca,qca8334": referenced as QCA8334-AL3C QFN 88 pin package
+    "qca,qca8337": referenced as QCA8337N-AL3(B/C) DR-QFN 148 pin package
 
 - #size-cells: must be 0
 - #address-cells: must be 1
-- 
2.32.0

