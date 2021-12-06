Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E64A46A39B
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346005AbhLFSEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346077AbhLFSEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 13:04:23 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E286C061746;
        Mon,  6 Dec 2021 10:00:54 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id m24so7556077pls.10;
        Mon, 06 Dec 2021 10:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8NzlNFEIINqTDcWXH0e+WAbc6LfC9f1pv4m0DsSAh4M=;
        b=jMr3AgR8WA/HadtPHvYuy2cexlD2vCjYqKkD0QCon5sMAb5+f53aNRaCF+cX/MjK1I
         ooiAo0rfd/EZFNiShmxSeKpcOfBi2F6cd6QFJcUt5A2J0wg5TSxy6O5pKQt7mTysK1XK
         OwfVBsyhnuyB5WwBmRpIrq+bqaJxSlhXVbywcf331X5/yguw/VA6iKu5POyTi3bk+tzh
         aQR/WHtuH9cKzfFVMMyQk9n1xDFfELgGM88ny/Ub/kxe8YV7KKE2yfQ5Bin+WkT8EA5s
         Sf/ZYYstLt3m4+lRu6E2rFNXSnGXFAZexYUtMN0fBYaVjiSq3G4knXEdNYfXQoWI3YTT
         +Cpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8NzlNFEIINqTDcWXH0e+WAbc6LfC9f1pv4m0DsSAh4M=;
        b=WW/SiPstaQtOHSC+PO4tT/5pwnaoYrCCp06BbxazC1HWXTQnxHmtRP3gOSGla+086b
         sk490EFj8PcdV+TgIEqW8KUyASvbdE5VRcXr2ElF8nsqgqeFH0lRrfHpT/MuQfWPJpU4
         LXEd7+pgtp7FMZ8GvzAGZ7RPUZ1ILWBQi5nMp2NqMBRqh3WjB2IxAppJTWeemkdawL6K
         mozti0WRk02vSghACboe+7UPB9db30vFaG9V5mpu9+EfrqYh/TcKjYd34ZQuVF9v0jPH
         Z9PZSaZ7FsUXIsXaLccPuAWQZWW5ZfrDKHjbhhr3/lD+ihtLD9hS5CJ0RsaLwNhrIRgK
         bX7w==
X-Gm-Message-State: AOAM531JGP6Ek+48Ga5ITWLHZTpupVs2IK9LqJMuUNaTmgbvqlUZB6/I
        2N8GxD32i0wEMQIBU/K39affPEHBTBY=
X-Google-Smtp-Source: ABdhPJzfEfVEta3O/mLOLewG99piJjzBrQZH40e2k1H3HdcxMIyY4VE0jKhGB70cWd1FeC6d9cg4VA==
X-Received: by 2002:a17:902:7c88:b0:142:5f2f:182a with SMTP id y8-20020a1709027c8800b001425f2f182amr45525167pll.72.1638813653645;
        Mon, 06 Dec 2021 10:00:53 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u11sm5444070pfg.120.2021.12.06.10.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 10:00:53 -0800 (PST)
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
Subject: [PATCH v3 1/8] dt-bindings: net: brcm,unimac-mdio: reg-names is optional
Date:   Mon,  6 Dec 2021 10:00:42 -0800
Message-Id: <20211206180049.2086907-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206180049.2086907-1-f.fainelli@gmail.com>
References: <20211206180049.2086907-1-f.fainelli@gmail.com>
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

