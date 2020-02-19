Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D86E61647FE
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 16:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgBSPNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 10:13:10 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55965 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgBSPNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 10:13:08 -0500
Received: by mail-wm1-f65.google.com with SMTP id q9so1028600wmj.5;
        Wed, 19 Feb 2020 07:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DgQTawVnvOeaCy4fqOCxs8TdoBzrIHpG69q22QTtFfQ=;
        b=YWxKWAiNq96mL1RZzLYuQNF2U9TcxkiZ+3R386Oq2M6ExArzIsAoQ+y5JSaVdP5hTp
         GnEoyrRaySS0/SyUfTYawe2R4sPoPfN59Fuo7y0INHUwW+OTNqkKlS9im9nt22kzk3q/
         lJTyJtngi+xpcosoWmw9Ot5SFrWKt3TxiYyLA/TKEZqLxsoMoNGolo7mjUAjayqp00k9
         eXi2zfQ9RVtOV90fRi450NOUAXlGWcfAHv9SylEZMC/E3du12LAhcCxU1Ykdd2xr5m6/
         QDdoN4iLgp426kZW7VQTO8qzc8UvqzmZnz/Q1ejyKmz6wpNn/ANdX6zubpuPtzVxZn/h
         QJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DgQTawVnvOeaCy4fqOCxs8TdoBzrIHpG69q22QTtFfQ=;
        b=W7nsFimp3tm3D5OT2iF+7Bg+0GX/8cYeDuZ668bDcaeRC0y237QXBUq91p+cAaR3AK
         j1Sxh8syaLh5Mi+7K9g39lTfcG8azO57HC4fAzx+qD099FnPBNx+tr3waHC14D2VNwCA
         5BAo+FleRxPc5lnj3R0hPSFQzOi7bBrd5hOY+OJcGRBJxowH4SQb3899qbOLoLAY/tMn
         k52ewUVLpFjTj9OQHLoJjptgs9uL1zly8lgzLie+jBJENOpdUgV4OD42KmOiHdBhvBv8
         edQtTKgrCWemZXgulM3bL1+3EvUpl36dtB5F6yN34TFda2SCbQX5vc4NsnVhN/45qSSa
         UOdA==
X-Gm-Message-State: APjAAAXVYBc5kSHPdVXtYy1h4hOwgdiCuoUUSxHda8PL7xFDXev1TtAv
        P0lJ1mxw4IYWznMZ2njy9iw=
X-Google-Smtp-Source: APXvYqyJen7ypND9HZ0n9bQDfqMPUXHNPpk/nVe+cLHLkrjIQlU2PF4ssQ1e4Ptb0eed2zMPc4dGBQ==
X-Received: by 2002:a7b:c318:: with SMTP id k24mr11189202wmj.54.1582125186403;
        Wed, 19 Feb 2020 07:13:06 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id b13sm83137wrq.48.2020.02.19.07.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 07:13:05 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next/devicetree 1/5] arm64: dts: fsl: ls1028a: delete extraneous #interrupt-cells for ENETC RCIE
Date:   Wed, 19 Feb 2020 17:12:55 +0200
Message-Id: <20200219151259.14273-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200219151259.14273-1-olteanv@gmail.com>
References: <20200219151259.14273-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This specifier overrides the interrupt specifier with 3 cells from gic
(/interrupt-controller@6000000), but in fact ENETC is not an interrupt
controller, so the property is bogus.

Interrupts used by the children of the ENETC RCIE must use the full
3-cell specifier required by the GIC.

The issue has no functional consequence so there is no real reason to
port the patch to stable trees.

Fixes: 927d7f857542 ("arm64: dts: fsl: ls1028a: Add PCI IERC node and ENETC endpoints")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 0bf375ec959b..dfead691e509 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -683,7 +683,6 @@
 			reg = <0x01 0xf0000000 0x0 0x100000>;
 			#address-cells = <3>;
 			#size-cells = <2>;
-			#interrupt-cells = <1>;
 			msi-parent = <&its>;
 			device_type = "pci";
 			bus-range = <0x0 0x0>;
-- 
2.17.1

