Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB992ACBCF
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 04:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731976AbgKJDcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 22:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731341AbgKJDba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 22:31:30 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10668C0613D3;
        Mon,  9 Nov 2020 19:31:30 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id r10so8944140pgb.10;
        Mon, 09 Nov 2020 19:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4oP345zT1sZZRikhjh4rRfaErPcAmO3pAObF0ITF17E=;
        b=apIxxcV5KJFUxQg2Ha9eqFlRFX8BubIHfKI+vKMvzNxpUVcD+3KjSqfCo8kWEyoT6F
         VLC2wncSk+V+Zz79P/ignxnzr7XyrjP1wn/Y0O4m12Gyuf5FHlgWqywortzJ5PnoB1t2
         owtSPl4BmItCZjtyoqdNXu8k1kBrYJOiV84esfRHDnck8UHu7/2KIwPf6pFjz7LgzpK3
         P6nk+k4rT3TMtixpI/S9i9iRM6HXXXjpyySaS2DYQECHQOxeLdwXwcsRrcokThoSl+zO
         Hh5AYEpcfmX5Xm4kr2e8uS/saInIktyHt5GsRmA2YalFTebvEMd99kdYjbZCvwdflqbY
         fQ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4oP345zT1sZZRikhjh4rRfaErPcAmO3pAObF0ITF17E=;
        b=b4q0EccCPx0nvgDSFur543mfrscSIYAaBSEnl30+5FQe6jYV0UZBz5BqSYxSY+wX7T
         oYxZuo8qGdRqjZRH6LfyNaxhnYh1UC3x3bGMrl1zv9BrJtvwcarUzKnTtHQuo9MrnLy4
         Rup9OkFj2uPJW9LQJKXDcRC+2lGD+q6GcDrc6Hw9zTmFP3883NG/NBzrp5uX+gbN9DBt
         wDNhVIoF9Gn9MNzPhSFIfcYJbtb4K2rge5olTXFsFwLkjRaFE8de9o/NDww6Xg2hE9EB
         WfQkOb2H5Me2gcMC066+lc7G40tKQ5qc8GoLj3HDbu+ikQr8D9J/CklTid1vPADqWxmZ
         fYfA==
X-Gm-Message-State: AOAM531oBQfAcQwBQf+Tfz7Mu0pmHP1HxXEQkWBhy+cTX6PO8yM5RSPV
        7/Z89SKIITnoMHp07TxhMZiWEpXszIw=
X-Google-Smtp-Source: ABdhPJyKY2cR6epNyrFGGokiabLt589QhyPfk4MQUMK5oLavFq62xKg2WSEvqAoOo3dMCOOInMSwww==
X-Received: by 2002:a63:ff5d:: with SMTP id s29mr3949379pgk.290.1604979089242;
        Mon, 09 Nov 2020 19:31:29 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k12sm965677pjf.22.2020.11.09.19.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 19:31:28 -0800 (PST)
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
Subject: [PATCH 04/10] ARM: dts: BCM5301X: Add a default compatible for switch node
Date:   Mon,  9 Nov 2020 19:31:07 -0800
Message-Id: <20201110033113.31090-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201110033113.31090-1-f.fainelli@gmail.com>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a default compatible string which is based on the 53010 SRAB
compatible, this allows us to have sane defaults and silences the
following warnings:

arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dt.yaml:
ethernet-switch@18007000: compatible: 'oneOf' conditional failed, one
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
 arch/arm/boot/dts/bcm5301x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index ee23c0841699..807580dd89f5 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -483,7 +483,7 @@ thermal: thermal@1800c2c0 {
 	};
 
 	srab: ethernet-switch@18007000 {
-		compatible = "brcm,bcm5301x-srab";
+		compatible = "brcm,bcm53010-srab", "brcm,bcm5301x-srab";
 		reg = <0x18007000 0x1000>;
 
 		status = "disabled";
-- 
2.25.1

