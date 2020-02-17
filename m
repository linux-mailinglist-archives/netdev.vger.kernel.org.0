Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D70251614ED
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgBQOoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:44:23 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40757 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728798AbgBQOoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:44:22 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so18738010wmi.5;
        Mon, 17 Feb 2020 06:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fYOm0c6Wq8+JdA+av6JaNbF89Lpk98DTtPwQkUkGoO0=;
        b=pOC8mE/7xlzVJZkKjxtN7wWpmPHu/f/tJkKakRwbXKQlFLQ/LkwWMRI+cAWKaYM0u/
         xAhFFvs9hBUfOXgmaaP5Gti97ui9q/JduIYiShIhlLPDoCkatKdse57ReBrmrykk4n5C
         eXZQ0b/PvY4A77hX8QmvKIrMV5+BWNhJRTAcDbBHpAj13zb/xtSW3L9IKg3ATinWMUxr
         4ZA9bOvWQ/feXPgfSGtpl8N0z1+fEnowlW/XRUc2SLBzbq5q6Czmgm2/wr6qdHZGqmAO
         nJBwUThNeesyQLiQnVE03NY6I6VWFGzyPkEF1rvubWlkfUAbWDSBgZitS9khw6aDldgj
         H0XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fYOm0c6Wq8+JdA+av6JaNbF89Lpk98DTtPwQkUkGoO0=;
        b=rtLee9pzu44JCOBD/4PC8vhXjWOjXs3zvf1zI3+MbGzqm9wJ0f4ycv3s9FwdPMNRmZ
         Pg0SF17Qo50oj6Spj7VIw+sT97ljAIILHLb0KoQEn1W18PWawh1Bpd9e/ci/Qxmt/GVo
         TFsZ0POlzuMJT0bq3k9mSjAex3FaSccvmLzOsipXA2vw4upYtD84Oe8KJuvfudT+Zjg1
         1PTRSyetVOZDeLHU9mp8d29bifrETOTpVeC/HNLGW3HVt1aDqK+5LX/p+jSbzV8Yigo+
         Kywo9BvGXrhaAIB66P1tFAX1WKKldv7UWVmCa38EwOTK8uoHhcB2fBLF2d0o1Dy1E5pW
         AmcQ==
X-Gm-Message-State: APjAAAX7glUnia8vjFItugYcpbSciGvnamtS1lahEu602CYrC9gl0ehW
        dSE5m9LcAoPAYgbPeEyNvw4=
X-Google-Smtp-Source: APXvYqxDuXJIQFYMIV1ZOU+5DG84y1Tpxf4v+9gyIdkVcVh8HzM47zm8T8IQfTHwnu+kW/RN7QZxww==
X-Received: by 2002:a1c:960c:: with SMTP id y12mr22462178wmd.9.1581950660618;
        Mon, 17 Feb 2020 06:44:20 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id j5sm1381699wrb.33.2020.02.17.06.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 06:44:20 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH devicetree 1/4] arm64: dts: fsl: ls1028a: delete extraneous #interrupt-cells for ENETC RCIE
Date:   Mon, 17 Feb 2020 16:44:11 +0200
Message-Id: <20200217144414.409-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200217144414.409-1-olteanv@gmail.com>
References: <20200217144414.409-1-olteanv@gmail.com>
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

Fixes: 927d7f857542 ("arm64: dts: fsl: ls1028a: Add PCI IERC node and ENETC endpoints")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

