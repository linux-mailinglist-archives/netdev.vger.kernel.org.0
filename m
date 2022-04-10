Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11BE4FAD56
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 12:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbiDJKt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 06:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236992AbiDJKt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 06:49:27 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A048532CA
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 03:47:16 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id b19so18958265wrh.11
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 03:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=svUJ4ir0Dr2U1dE5ScG9t3ewLApCBlPpmf7/Q/Ayqbc=;
        b=N9X0PlZK2C/MsV9hx5696qFBXEOsY0iFZMKeds2NBWjoi68bMz7GjMHSVYTksD9Irc
         zU5sfWqYesJGqMr7PKg3mlnRwmUPUKpqhJESj4tk8IuVfMVp4qlwBfsEusp8aHL1fh8n
         weAiqSKwlcn79inPvAJQbD0GOpEtDE6lxoj0qpkgw13f+imkMZBnsmxGZWrKNfYwJEvo
         BZBvUMLXsarzvSA4uYUNdOWadf3GqF+J74z7ALS7w3cdch0M2SA7dHEKVpUmNnZ5PzmJ
         8b8m7Wkf7Z5jHMNYG8fWJ5CQlprSwmtrvoYwG3im6YfIWx4Sbnml79VCXcW2xaznklF6
         3TQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=svUJ4ir0Dr2U1dE5ScG9t3ewLApCBlPpmf7/Q/Ayqbc=;
        b=RMIzDf38DKQxKtUmqOymjQUYaMYqtvUX50JP0F7FhHxa53GJUC1smqKkyv8ViNAwtp
         0gYkMAOs61zEaqc9sTEds5gM4pBb/loll3qYIYqqSFk7Us8WNCBzvVFoK32Aoax7NFgg
         5Oq6VkeEWcJnJ6lwCwBju1Qu8sspJWDg0NkjxygvFjWiWeDtnkc8YqnoN7281QhqZTID
         XRX6WYzv+I+9n8/ND1Qm3ZlyHyDOOvla8zmgUnKuH3dV7f9bdGQ/glnRay930XlSOVav
         IAtps0AqDQx9gySAQayDxbU0SQ72kT0EdKOW52ETjzR+BAb7LszkmTBqVaNATrVAzwrb
         L1Vg==
X-Gm-Message-State: AOAM532x4KCp8IW2Ajkwyygmh8U9rVHGPB7dGouNUvBasJv6NjjoT4Qx
        UVaog7j6UxB+qtL6/Mo+Jy7UEYj47GAKkh5OnVs=
X-Google-Smtp-Source: ABdhPJyWXvZwF8ahNEDjEJBr86HMpyrpo7SeLGXy5ooXPPGT47/s6UDHQ4y90kX7v+r6i81Lya33sw==
X-Received: by 2002:adf:b64c:0:b0:1e3:16d0:3504 with SMTP id i12-20020adfb64c000000b001e316d03504mr21059056wre.333.1649587634947;
        Sun, 10 Apr 2022 03:47:14 -0700 (PDT)
Received: from josua-work.lan (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id f8-20020a5d64c8000000b0020784359295sm12839196wri.54.2022.04.10.03.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 03:47:14 -0700 (PDT)
From:   Josua Mayer <josua@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com, Josua Mayer <josua@solid-run.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 1/3] dt: adin: document clk-out property
Date:   Sun, 10 Apr 2022 13:46:24 +0300
Message-Id: <20220410104626.11517-2-josua@solid-run.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220410104626.11517-1-josua@solid-run.com>
References: <20220410104626.11517-1-josua@solid-run.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ADIN1300 supports generating certain clocks on its GP_CLK pin.
Add a DT property to specify the frequency.

Due to the complexity of the clock configuration register, for now only
125MHz is documented.

Signed-off-by: Josua Mayer <josua@solid-run.com>
---
 Documentation/devicetree/bindings/net/adi,adin.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
index 1129f2b58e98..4e421bf5193d 100644
--- a/Documentation/devicetree/bindings/net/adi,adin.yaml
+++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
@@ -36,6 +36,11 @@ properties:
     enum: [ 4, 8, 12, 16, 20, 24 ]
     default: 8
 
+  adi,clk-out-frequency:
+    description: Clock output frequency in Hertz.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [125000000]
+
 unevaluatedProperties: false
 
 examples:
-- 
2.34.1

