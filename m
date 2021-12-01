Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958CB465472
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352152AbhLASBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352035AbhLASAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:00:36 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E72C061758;
        Wed,  1 Dec 2021 09:57:06 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id l190so24415756pge.7;
        Wed, 01 Dec 2021 09:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tExO4r+cy0RFB17XdXDlhBrae4MKdtqXWFJl8QhkaZ0=;
        b=OdhppBQEa4ryLH9att8LycRi3rFQ6Ga0EBTENit5xYQDB1Bfba3CKRCE8+rFa0Mpyv
         f2gFF2MNjOj1KBDwXU9LxBuif8gDT4/7cTgs2tA4u6yMJN5AClWL6IZ8BpOQuV5Vm7YT
         XmfFFyaWBBl9RsxHVfQURfNkvMiGqQv19t5gXTJfW26Ow2EGYCX8j1k7QAK65EcGXV0e
         G35bFclcVFGsMWS9RUUAfNHjTro9qzcOMr+MHLteCkTKdMSsrqRlX3SGaGZryEDtSiE3
         zMtzOY/vwApuDcHjVJfE5buQaAxDeYTNFBpUixPc5rHljnGkagxSZ3JT5j/RiSIeU4u2
         qBtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tExO4r+cy0RFB17XdXDlhBrae4MKdtqXWFJl8QhkaZ0=;
        b=qnU4s/G/Nvo7KZxrJ1VvKwCEIGdaxLgrBnsqh+Yw8HK2WiNq0X+FyZTz+LA8nEx9Yg
         7qnEAVZvle0+FLjMklPWMJ1hnGLjd9PFUYFZ1q52e36tqj4eEXIj4WrSW/az4JStEj6t
         IEpwmSHEGFg3epc90PXxGY0yUUzYBvzuB6rSP6jkwpw0KHcKDRyDbFQ+5M6frW5bTFEo
         yvoxVHtYoGAC4uNSkjKdGnI5z5xkmfRueUG9ftOpQDfCHk/c9XqJgI0j6iUp6COJXaHb
         kBegpXTZeLOlZJOC1YgDkzJ1bz10qY1UMOCCABb7zftzxsvAXJzYMoOgdhti64edSVVS
         9J4w==
X-Gm-Message-State: AOAM530zilwEsHOiWdhHmOc+CQ9Fc8hRDvnOGrChTvJDNfY4OHxtP8N+
        aRGWoDLjMinLt9W/YcjmrpHCno6DI4I=
X-Google-Smtp-Source: ABdhPJwMiQoRDug6ipJxypCtMgfXSsdjC+XcWPhh3/HN9O/4/dDPGj02z853Fem37KY+f7wl6gt8qA==
X-Received: by 2002:a65:6a0a:: with SMTP id m10mr5782535pgu.82.1638381425196;
        Wed, 01 Dec 2021 09:57:05 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j13sm471546pfc.151.2021.12.01.09.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:57:04 -0800 (PST)
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
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE),
        linux-phy@lists.infradead.org (open list:GENERIC PHY FRAMEWORK)
Subject: [PATCH net-next v2 4/9] dt-bindings: net: Document moca PHY interface
Date:   Wed,  1 Dec 2021 09:56:47 -0800
Message-Id: <20211201175652.4722-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201175652.4722-1-f.fainelli@gmail.com>
References: <20211201175652.4722-1-f.fainelli@gmail.com>
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
index ff4909e1fdda..404035754db6 100644
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

