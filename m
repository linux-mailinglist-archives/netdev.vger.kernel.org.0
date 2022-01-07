Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725314870EB
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 04:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345728AbiAGDEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 22:04:32 -0500
Received: from mail-ot1-f47.google.com ([209.85.210.47]:39818 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345697AbiAGDE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 22:04:28 -0500
Received: by mail-ot1-f47.google.com with SMTP id p8-20020a9d7448000000b005907304d0c5so5250825otk.6;
        Thu, 06 Jan 2022 19:04:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NBar8N+1gW94C3fgFMqpUysSc+AeI/hjDEO8pXAcURg=;
        b=Gda/pja9vOnM7kcsAvhCwdf1Ti4eEHTh5isUZ4QueZdbPrLnY3clpo6qzr1V1Wj2RW
         f3pOTH/RBnPsYSLDh6DtOFtSTM2vnR26rPye1egIk2Pxd908Q3skrlpF61VmXQmspIiu
         r80FFGY/vPWNBz8t5s0cQCtKtNQIBHMsx6KLPoR7oyxc0EHdit5zvEX1xiMoVYhrOtM9
         dUxz4ej1tYcpjBJtn5p2piYJqJiU1nX/JoCdqFYxVGRj7JqEoZjjSrDiicRtW21Uy9w4
         WnEX3L3uHEc+HHVlUS4lytOpB/OLjLEDf7Ck/Cm0TkKdhdgcpKf2UrxQQgySZgYOqE9w
         rC8A==
X-Gm-Message-State: AOAM5327J0zct/lRu2xDAkxf3F/YXbqJn547ZL0vtwIovRCxNtRcqFRA
        nAKsSrDpQ22s5kt68KRjHA==
X-Google-Smtp-Source: ABdhPJzttxN24jpI2p+TdOXTWAvbQK6w0JRyEjAdIzTeHDE2eH/HHDwVvIRge1Nv30K0X6SqEy9hcQ==
X-Received: by 2002:a9d:6b14:: with SMTP id g20mr3065468otp.37.1641524668136;
        Thu, 06 Jan 2022 19:04:28 -0800 (PST)
Received: from xps15.herring.priv (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.googlemail.com with ESMTPSA id k11sm692385ots.22.2022.01.06.19.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 19:04:27 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: wireless: mt76: Fix 8-bit property sizes
Date:   Thu,  6 Jan 2022 21:04:17 -0600
Message-Id: <20220107030419.2380198-1-robh@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The '/bits/ 8' notation applies the next <> list of values. Another <> list
is encoded as 32-bits by default. IOW, each <> list needs to be preceeded
with '/bits/ 8'.

While the dts format allows this, as a rule we don't mix sizes for DT
properties since all size information is lost in the dtb file.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/net/wireless/mediatek,mt76.yaml       | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
index 1489d3c1cd6e..269cd63fb544 100644
--- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
@@ -191,9 +191,9 @@ examples:
                    channels = <36 48>;
                    rates-ofdm = /bits/ 8 <23 23 23 23 23 23 23 23>;
                    rates-mcs = /bits/ 8 <1 23 23 23 23 23 23 23 23 23 23>,
-                                        <3 22 22 22 22 22 22 22 22 22 22>;
+                               /bits/ 8 <3 22 22 22 22 22 22 22 22 22 22>;
                    rates-ru = /bits/ 8 <3 22 22 22 22 22 22 22 22 22 22 22 22>,
-                                       <4 20 20 20 20 20 20 20 20 20 20 20 20>;
+                              /bits/ 8 <4 20 20 20 20 20 20 20 20 20 20 20 20>;
                };
                b1 {
                    channels = <100 181>;
-- 
2.32.0

