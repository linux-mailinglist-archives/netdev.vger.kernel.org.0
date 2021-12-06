Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DE646A3A5
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346803AbhLFSEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346179AbhLFSE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 13:04:26 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E6DC061359;
        Mon,  6 Dec 2021 10:00:57 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so11410725pjc.4;
        Mon, 06 Dec 2021 10:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NuG70eYUXORcwGIelzhd3H+BMUojXfGScK3jwHgC0Ps=;
        b=Dx14OFdu0UvAWbZVjpnq0xkc1Ezt868+d31/k3C9hZCVVBGroKJ/FY/Yx9eb77rPUn
         e7iN/vgCf5isHeonNpd1l/uYzlvtnOVxgj1s5pvf0kceHv0DdKclylCn6DVwVdgN8NQO
         E00d6qJx8txI+mJAzUG51ETUy0H89ydaFM2jBpJnZTTvCXon3zzat3N1Uk1BP11VuIW0
         Gg1k3sE152Na7lRStDW4Mz4VuagwrCnfxtOt07pY9AyLl5bJg/nYyZ3t9NGeY2LnAsaS
         j+F2IRzSVxuE8km6TzIAFBLsD73sNBY4X0Pa8Z/sDHEK5WqA2ozhwQb6s+Sv6oQoDDcW
         g3Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NuG70eYUXORcwGIelzhd3H+BMUojXfGScK3jwHgC0Ps=;
        b=cr2aqPXlknbWuKJHuJ/IsC/8FJ7EAiCRM12dtEiLxja+aX85WhMDGZKRvtaDPMrXR+
         ooA1tqLdZqWKihLPHaN06RTEr8U17zHBBYI7JuGAxWkPSj3E9byEgChbl5xzErSJ3zbw
         uV1EUfP4CXSvzfXJCYvi6i1JoesBMRNBiWb0LlPUa/uERPEkR6NvL4U277OaC4gi1j79
         vDw2f8k2XhXMd3vkJbrtw7GMuOLH8gBx2ZilkpSOjc9iyIjurvoYCNvwLf5LEvCKQnI/
         svt6yJWI6cF+wc1OCwjtOJgp3KDEr8caJP2DpuJER5QBNM7ldXzk2P/7rTOwrCaxQjQC
         vCIQ==
X-Gm-Message-State: AOAM530rnQeGRLdpNeVYgStmbrtZHh8A2x4ftgd/lNU1hW7DQmgiC0bD
        Eiavd2qS4xa/DzxMBm0rjngqiaRGw9I=
X-Google-Smtp-Source: ABdhPJwUV3ctQdXWmP6IrbkyObT1OKO2ULNM2CzwgNfytBsRd/8030/dv/FVcTBmncw+7/7SenVlzw==
X-Received: by 2002:a17:902:8302:b0:143:6e5f:a4a0 with SMTP id bd2-20020a170902830200b001436e5fa4a0mr45166311plb.20.1638813656332;
        Mon, 06 Dec 2021 10:00:56 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u11sm5444070pfg.120.2021.12.06.10.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 10:00:55 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     devicetree@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC GBIT
        ETHERNET DRIVER), Doug Berger <opendmb@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE),
        linux-phy@lists.infradead.org (open list:GENERIC PHY FRAMEWORK)
Subject: [PATCH v3 3/8] dt-bindings: net: Document moca PHY interface
Date:   Mon,  6 Dec 2021 10:00:44 -0800
Message-Id: <20211206180049.2086907-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206180049.2086907-1-f.fainelli@gmail.com>
References: <20211206180049.2086907-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MoCA (Multimedia over Coaxial) is used by the internal GENET/MOCA cores
and will be needed in order to convert GENET to YAML in subsequent
changes.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 95b5a3d77421..47b5f728701d 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -69,6 +69,7 @@ properties:
       - rev-mii
       - rmii
       - rev-rmii
+      - moca
 
       # RX and TX delays are added by the MAC when required
       - rgmii
-- 
2.25.1

