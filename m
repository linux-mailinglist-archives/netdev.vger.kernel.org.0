Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665724645B8
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 05:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346566AbhLAEQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 23:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346545AbhLAEP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 23:15:59 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D2AC06174A;
        Tue, 30 Nov 2021 20:12:38 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id v19so16642458plo.7;
        Tue, 30 Nov 2021 20:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xVoKWeNn56cuTdwEaWw3q49t3mf9LKbZIeR0Fnf7eBw=;
        b=oUlryFWFGsPsidH/+KD18ZO9ozd5oVMB+0TrJ5h5RZvVMB4WSiN8X8+H65psjlCb2Y
         RDzTI1nWljrW03lbHbHAH/EipRyffWEEMmX9V78zsFJVO7Pg9qsV0mOpJrZbmBDO3WFx
         jQcd4kuNNFmUknK7RRBXEbeEFdKvkEOfxbYjvvAceAi2gI2cUGNi+OvViR8vVjwQZ6wr
         /+zqguvN5kz7ESjuC89/9KGmTCNZiGv8OjRR5csP2YhqkEcj494sZgEMbr3JoFqhrdLC
         vLeMYP8wOt+9rDNPrgINrqGrdhNropwjvUvOLzySJZmNrpJkh8rcEnst4ijnEHIdnFyS
         f7vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xVoKWeNn56cuTdwEaWw3q49t3mf9LKbZIeR0Fnf7eBw=;
        b=VrTCh6g2MQQ84LI7zuN1TwCgZZpbvu6O/VoM7AJ7p66AJcazSa09jzKb0yzgZP4rjs
         67ujZ4JrcV2e7Sdq4oURapDc+SoJmuU2/HMyCNxRG75MOAytWScbZImIPOG0PTkLFBH6
         llmVHZI4TgATUAsFECDyKAqxQ1sJ+eCqdaICz2GCUP2jH4aciUv2wOg/BA4zIvFWQuo/
         tR3juD0QyJnmTfiE8oiW4r53Vf8Qw/OgctImRMN/XI99waFP/8L/hdbF56ypa52AzURL
         MjfC3+Vs4zV6r1zvlUOQAnLgez91XxGYsTfCdycidoFNQsNnJNdk/MNii2ZGMldr6nxk
         SZsg==
X-Gm-Message-State: AOAM530ORt99FJqP1L1vy95Tyf2mNp+kxFWv1WLuozKtOEYoSnfqzEL3
        8VPoPz5ki6zmgoQsM89FcVrQD3u7iHs=
X-Google-Smtp-Source: ABdhPJw2AIxSo0x8NdgHNJxKTcL0OCdOReI7qQTHHWdOvAKRA5PnBfFNSHUM4cdSjI4e1TbRDL+GsQ==
X-Received: by 2002:a17:90a:bb84:: with SMTP id v4mr4412675pjr.4.1638331957919;
        Tue, 30 Nov 2021 20:12:37 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id s8sm4296451pfe.196.2021.11.30.20.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 20:12:37 -0800 (PST)
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
Subject: [PATCH net-next 3/7] dt-bindings: net: Document moca PHY interface
Date:   Tue, 30 Nov 2021 20:12:24 -0800
Message-Id: <20211201041228.32444-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201041228.32444-1-f.fainelli@gmail.com>
References: <20211201041228.32444-1-f.fainelli@gmail.com>
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
index b0933a8c295a..31bfec8bb674 100644
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

