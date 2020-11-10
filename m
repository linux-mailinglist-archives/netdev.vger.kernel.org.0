Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AECA2ACBC8
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 04:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731619AbgKJDcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 22:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731664AbgKJDbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 22:31:39 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8945BC0613D3;
        Mon,  9 Nov 2020 19:31:39 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id f27so5564335pgl.1;
        Mon, 09 Nov 2020 19:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pF51Sa1m31zHtusl1Q/a9fcn1tFfdxdiiX0Xoe3v770=;
        b=NCvkAz63xkDZRyBQ/QTtJu/+6VMyz0snjrKfW3QtAsRPMpoD1On6YVFMAid67IUw1w
         /bqHqNqbpj2A3AvxKPX+Gf3+PJJUrqyd9pDk+dOGXGElDtXnvux7harO5c4s+WTRkG/+
         Gv3DDtooY/sVmxYjry6v0pji5KvSpUYc6myLXVc/hUPjIWS5js5nRXrd/rZPNOYDjIjd
         2Xc+QBfYANzIS3Q+2GDM60DWiiQerCiZLUlsteH1aVF0L0hzmuRUB1mNQjfRr0K0szux
         GUIiIvBbBENVo30mZP5g6u34SQr/dONPxHnlFDXPalCjXsmBslw4h4zlf2PI+hbfT6j4
         GV3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pF51Sa1m31zHtusl1Q/a9fcn1tFfdxdiiX0Xoe3v770=;
        b=GFuPHAOuxc38upYlYT7TfGOik5caFYEdrEGFlel+ROHIxclPcAB8gG9ERaTA5ArHrz
         TImWaZUGG/DJPfIFs+P2hMpS43MFk/hSv+RtGCmNjIxsYLg1TirRXtwCUa4Z32c1v/BR
         A1b4aT2ssOSHplTx2vA4qyxqNvhEoaNKdFH4PZoXEFDUmfXmXkTeW6fKtdvuxIeXqNBX
         qFJW9rdknah08MRZ33AA0h4hKV6Agi+Zzqx2U13aouIKB13qwjfQa9C1lSmjfY+y4w3Q
         TzB/rPEQ66ww0ohb38mZDjWM1zLwxW9aOJapoaZgavwUx7x62T71AORYYWBK6bNtiIr+
         mucg==
X-Gm-Message-State: AOAM530s+y9CYH2X6dU8ovXQqLO2m7o0A657jTEwKkVKvsauJaugVNSf
        vApwGUQl9iNOSern3cWJe2NmPRedbh0=
X-Google-Smtp-Source: ABdhPJzRWnSg4/l66+aBSIjmRMMVm3wMYaGbRFFC7cOHJdLqbR5ZjBnyUM5HOitF2Wjo6nU+N+7fsw==
X-Received: by 2002:a63:b24e:: with SMTP id t14mr15065321pgo.224.1604979098735;
        Mon, 09 Nov 2020 19:31:38 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k12sm965677pjf.22.2020.11.09.19.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 19:31:37 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC ARM
        ARCHITECTURE), Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE), Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH 08/10] ARM: dts: NSP: Add a default compatible for switch node
Date:   Mon,  9 Nov 2020 19:31:11 -0800
Message-Id: <20201110033113.31090-9-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201110033113.31090-1-f.fainelli@gmail.com>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a default compatible string which is based on the 58522 SRAB
compatible, this allows us to have sane defaults and silences the
following warnings:

 arch/arm/boot/dts/bcm958522er.dt.yaml:
    ethernet-switch@36000: compatible: 'oneOf' conditional failed,
one
    must be fixed:
            ['brcm,bcm5301x-srab'] is too short
            'brcm,bcm5325' was expected
            'brcm,bcm53115' was expected
            'brcm,bcm53125' was expected
            'brcm,bcm53128' was expected
            'brcm,bcm5365' was expected
            'brcm,bcm5395' was expected
            'brcm,bcm5389' was expected
            'brcm,bcm5397' was expected
            'brcm,bcm5398' was expected
            'brcm,bcm11360-srab' was expected
            'brcm,bcm5301x-srab' is not one of ['brcm,bcm53010-srab',
    'brcm,bcm53011-srab', 'brcm,bcm53012-srab', 'brcm,bcm53018-srab',
    'brcm,bcm53019-srab']
            'brcm,bcm5301x-srab' is not one of ['brcm,bcm11404-srab',
    'brcm,bcm11407-srab', 'brcm,bcm11409-srab', 'brcm,bcm58310-srab',
    'brcm,bcm58311-srab', 'brcm,bcm58313-srab']
            'brcm,bcm5301x-srab' is not one of ['brcm,bcm58522-srab',
    'brcm,bcm58523-srab', 'brcm,bcm58525-srab', 'brcm,bcm58622-srab',
    'brcm,bcm58623-srab', 'brcm,bcm58625-srab', 'brcm,bcm88312-srab']
            'brcm,bcm5301x-srab' is not one of ['brcm,bcm3384-switch',
    'brcm,bcm6328-switch', 'brcm,bcm6368-switch']
            From schema:
    Documentation/devicetree/bindings/net/dsa/b53.yaml

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/boot/dts/bcm-nsp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
index 09fd7e55c069..8453865d1439 100644
--- a/arch/arm/boot/dts/bcm-nsp.dtsi
+++ b/arch/arm/boot/dts/bcm-nsp.dtsi
@@ -386,7 +386,7 @@ ccbtimer1: timer@35000 {
 		};
 
 		srab: ethernet-switch@36000 {
-			compatible = "brcm,nsp-srab";
+			compatible = "brcm,bcm58522-srab", "brcm,nsp-srab";
 			reg = <0x36000 0x1000>,
 			      <0x3f308 0x8>,
 			      <0x3f410 0xc>;
-- 
2.25.1

