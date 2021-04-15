Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A1D36059F
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbhDOJ1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbhDOJ07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 05:26:59 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAD5C061761
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 02:26:36 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id a36so15485384ljq.8
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 02:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=JYXtByocNzdUyie9ZCRPrngMjOeMLMOYohNBttdV3IE=;
        b=OtDalePQGPrcfmDLkkqJhNqNXLxO2CYFGmmSq6en2xvvXDWwaqDJqUrVW974yeKWg3
         fODGiAhXfd+ZG8gAmMjdkYL7EoSQf8EVsmk30byuJNQuutWFgXlLtXipLqD8lTSVFLwt
         mGk3uGvM2VitVm9U0GOWJY+G4CNbaIzPSptWZ8sFdtS+KWeF/Rvk4b8grhz/hYEtkGyg
         ITzeK+30+zcwqNtXmx47G12D/6J/Zye79QSOhHuBF8QGo6918pbfcV63uo6odUrh5lOP
         Vs5CnXRXFJnkgBx2MPveGyLonAzlIqtFcQ+ZDQBBz2R9yMGParVR01PqZbJmcCqW9Svm
         JBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=JYXtByocNzdUyie9ZCRPrngMjOeMLMOYohNBttdV3IE=;
        b=UVLBDr528PjeBeyad4wCEs849rUbmDqX48cbDYTHDIqTFpVQ2QvRkyCbHH52A/8END
         cfFFj8slt3uLc/yC1CnWrbb65O6vSAfv3nrNRM6x9B6nRYZDuGs4dvG9j8J6Ry15M1YJ
         R/n14gAkq9TsoFX+o6faAoZcADOQbk/tzrQtORv5uxPze5NgI9CIzp5lWlQGCX2CECUr
         tUpDhRTYfga4UzucbIOxmc633JIXRj7msjlsHhxcBPZgu0FH75xBpvcyZ4OWQj4mqyZp
         R2oKzvL+r/DsA6IdqBNPA3Cd+WzewiEGL1ErLKrrO9Z91pWI4CnMcRHQKOkA6Gy4j5t2
         tB1A==
X-Gm-Message-State: AOAM533WX1936c8mJ17yHMjg7pmV8M6ViheRsGKOENrAsNG98Idvpw2c
        D14qwvJ1zkFVFLRFj7BrSPSjog==
X-Google-Smtp-Source: ABdhPJxBOc6E58NSwqXtquKlHZ9YkZfofkDdaScflkGBDsw7xpwNHi1/Vw0erwIUz4vVfOLt2/VTKw==
X-Received: by 2002:a2e:320c:: with SMTP id y12mr1271942ljy.360.1618478794795;
        Thu, 15 Apr 2021 02:26:34 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g4sm595557lfc.102.2021.04.15.02.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 02:26:34 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 net-next 5/5] dt-bindings: net: dsa: Document dsa,tag-protocol property
Date:   Thu, 15 Apr 2021 11:26:10 +0200
Message-Id: <20210415092610.953134-6-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210415092610.953134-1-tobias@waldekranz.com>
References: <20210415092610.953134-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'dsa,tag-protocol' is used to force a switch tree to use a
particular tag protocol, typically because the Ethernet controller
that it is connected to is not compatible with the default one.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 Documentation/devicetree/bindings/net/dsa/dsa.yaml | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 8a3494db4d8d..c4dec0654c6a 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -70,6 +70,15 @@ patternProperties:
               device is what the switch port is connected to
             $ref: /schemas/types.yaml#/definitions/phandle
 
+          dsa,tag-protocol:
+            description:
+              Instead of the default, the switch will use this tag protocol if
+              possible. Useful when a device supports multiple protcols and
+              the default is incompatible with the Ethernet device.
+            enum:
+              - dsa
+              - edsa
+
           phy-handle: true
 
           phy-mode: true
-- 
2.25.1

