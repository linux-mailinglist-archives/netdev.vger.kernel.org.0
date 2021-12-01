Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70EC8465465
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244000AbhLASAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233042AbhLASAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:00:24 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB09C061756;
        Wed,  1 Dec 2021 09:57:03 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id b13so18333867plg.2;
        Wed, 01 Dec 2021 09:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8NzlNFEIINqTDcWXH0e+WAbc6LfC9f1pv4m0DsSAh4M=;
        b=MlYX+38bebzRMaYNeN2EmfOKqLzrhDKnBDaSqxWJ1nf4SpBuhDRx+wXW7RIkc4gGq2
         +powvlGTI/pQMziKrr16YnLZNpMDL72dBTtsWBNAcYNxJtu29FmhI8okc1C9o4Zx+SmD
         4oRlcwymxL92xZTeMchH64bZ6QedSkVqYS2CWEfBZ+GQfcXx8sdN8pizDc3ndX4jm92L
         hz5jHSaXnKc3IZU5npd723/wY4fdxXLvFzPIbu/KNcdIBnUFyWvT/ONQ1CpKK2eslI0f
         MdMFjIKS3MGa/1UmGKJN76pGfiyO0pBmS8kzJ5S9ViGK/UrIV4hLgZVlrcf4Wbc/2Pmk
         NUGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8NzlNFEIINqTDcWXH0e+WAbc6LfC9f1pv4m0DsSAh4M=;
        b=R0Ui6Onhu+d/AmTOogqB9MBYUf6h4QvDrQiyHCPQr9bJY+KuCBcEYaXJlbwjmqq8Nm
         QFYtnILz4/gyuiif4jzA6vXCIhPznWQC+6NSa0dCGgBtD09krlMKxtO8Pd9gFuIZsALT
         Gb5pjXM24mhkTMd67LnWGKfVwg0raCyxNp+6lIcr1uNLlBB+A6bs/gpATDsnovwRpfSQ
         R1XZMGtLGUVjxZwJMdG9/is6upHZLRgry6uRMO4nwNx1BT0noA49vdAXpDTmW/1rZy8f
         n9WnJPFj0E6gUV77yrrS+V7WhVCm+AFdp0kRlGQq41BGePanbzsx+uguhRtyNtuoEOgP
         ZIEg==
X-Gm-Message-State: AOAM532dFeLCnP3+sU3vaTwXTzC4r1mTorY6En3Cn3OaExGpfIWY4MDf
        F3s/KTMuuVH8y/wXNsxlsR5gBsGKgrE=
X-Google-Smtp-Source: ABdhPJzdoyylYdHTMJD/A1gdPn+qlC76D/QkYKB03SZS0qIdqZTN3akJtZdg1hXJBGd8gyQuZ0xvmQ==
X-Received: by 2002:a17:90b:380e:: with SMTP id mq14mr9728940pjb.74.1638381422438;
        Wed, 01 Dec 2021 09:57:02 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j13sm471546pfc.151.2021.12.01.09.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:57:01 -0800 (PST)
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
Subject: [PATCH net-next v2 2/9] dt-bindings: net: brcm,unimac-mdio: reg-names is optional
Date:   Wed,  1 Dec 2021 09:56:45 -0800
Message-Id: <20211201175652.4722-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201175652.4722-1-f.fainelli@gmail.com>
References: <20211201175652.4722-1-f.fainelli@gmail.com>
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

