Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4994645B2
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 05:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346541AbhLAEP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 23:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346514AbhLAEPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 23:15:55 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B05C061574;
        Tue, 30 Nov 2021 20:12:35 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 137so15113910pgg.3;
        Tue, 30 Nov 2021 20:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8NzlNFEIINqTDcWXH0e+WAbc6LfC9f1pv4m0DsSAh4M=;
        b=qSxFvZRknsXn+NMy9FJpvfYA6ddl2zjmyPxFcHCzG6A2qoZtqPftfVphIHBEEkDLvH
         R2LmAsnQYSxyuHkjT+YuUwsr2+WV6FxFvRQohZDTnPCPXe5GKyqDve/we7eKlUWKOzli
         6LtFEA8lvE72ESGx5/xW+F1n1vMIIweJICjX8hF/aIpFbfpfq+btDpftL+i7M/WfRzgu
         REaBeIsO9Ec6Nbm2T8KwsCX+Qh/gBB2h3nsXYSet/sGD4icwDaUbZPxZIDR0r3WHnv1e
         7z4gQwJt2+rmwMTiBfGPsBDSnYOvdXfvzlEp0GzHFKycjdqnj7F8RQ7+d0EQR6BilcGs
         sLfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8NzlNFEIINqTDcWXH0e+WAbc6LfC9f1pv4m0DsSAh4M=;
        b=VkkHbgmJVuqS1kRHGSiBUIflTxhauoHt33RRo0ThCDAee2j0PtoYennd/Z22XDqt+j
         3P0gRuvpx6W1eESF/D54TNbHEt9Y5FqXTjPyGC2QjBMPZqvTEmRI1l4riY3CRFt188Xn
         BZb8mflLRRDGBZ3W8xFWHsphqtjPlRe48mPNbcrsz715pFQGQwEEsQ0dmOhsopzGHylu
         GeHNxqYVLn9pKFbzm4OaE/ZYDNqtc4mTPDo2iwSX0Qq+QO7WWv9hE32Rl8PmIAXO3PYk
         sksbbVVMe2OMvTLMVM9yAXdYi13BM2W8s5YEEJPxZk5RAQzBoIDOUxAcx2sISNuVRq4Q
         RRgg==
X-Gm-Message-State: AOAM531MzJosK1UbUMRylvlEoAHr/sDuXdpVRwwGeCV1t66O6t/jsuzZ
        HRbj0zuINTQC3slK5O/l1rD2MKn3mDQ=
X-Google-Smtp-Source: ABdhPJyWbdwX768kqwq3ZiVkyd0yQ0A0wFNMVmq2k3vn+txLIVL1r1iQIJqSDIMuqiYaqniSn7bbcQ==
X-Received: by 2002:a63:2ccd:: with SMTP id s196mr2776647pgs.77.1638331954610;
        Tue, 30 Nov 2021 20:12:34 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id s8sm4296451pfe.196.2021.11.30.20.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 20:12:34 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC GBIT
        ETHERNET DRIVER), Doug Berger <opendmb@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE)
Subject: [PATCH net-next 1/7] dt-bindings: net: brcm,unimac-mdio: reg-names is optional
Date:   Tue, 30 Nov 2021 20:12:22 -0800
Message-Id: <20211201041228.32444-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201041228.32444-1-f.fainelli@gmail.com>
References: <20211201041228.32444-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The UniMAC MDIO controller integrated into GENET does not provide a
reg-names property since it is optional, reflect that in the binding.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
index f4f4c37f1d4e..cda52f98340f 100644
--- a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
@@ -64,7 +64,6 @@ unevaluatedProperties: false
 
 required:
   - reg
-  - reg-names
   - '#address-cells'
   - '#size-cells'
 
-- 
2.25.1

