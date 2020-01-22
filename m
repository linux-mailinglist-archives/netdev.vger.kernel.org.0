Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9CC7145551
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbgAVNUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:20:54 -0500
Received: from inva021.nxp.com ([92.121.34.21]:53538 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbgAVNUw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 08:20:52 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 800EC20033F;
        Wed, 22 Jan 2020 14:20:50 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 72538200332;
        Wed, 22 Jan 2020 14:20:50 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2CF4520364;
        Wed, 22 Jan 2020 14:20:50 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net 1/3] dt-bindings: net: add fsl,erratum-a011043
Date:   Wed, 22 Jan 2020 15:20:27 +0200
Message-Id: <1579699229-5948-2-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1579699229-5948-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1579699229-5948-1-git-send-email-madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an entry for erratum A011043: the MDIO_CFG[MDIO_RD_ER]
bit may be falsely set when reading internal PCS registers.
MDIO reads to internal PCS registers may result in having
the MDIO_CFG[MDIO_RD_ER] bit set, even when there is no
error and read data (MDIO_DATA[MDIO_DATA]) is correct.
Software may get false read error when reading internal
PCS registers through MDIO. As a workaround, all internal
MDIO accesses should ignore the MDIO_CFG[MDIO_RD_ER] bit.

Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
---
 Documentation/devicetree/bindings/net/fsl-fman.txt | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl-fman.txt b/Documentation/devicetree/bindings/net/fsl-fman.txt
index 299c0dcd67db..250f8d8cdce4 100644
--- a/Documentation/devicetree/bindings/net/fsl-fman.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fman.txt
@@ -403,6 +403,19 @@ PROPERTIES
 		The settings and programming routines for internal/external
 		MDIO are different. Must be included for internal MDIO.
 
+- fsl,erratum-a011043
+		Usage: optional
+		Value type: <boolean>
+		Definition: Indicates the presence of the A011043 erratum
+		describing that the MDIO_CFG[MDIO_RD_ER] bit may be falsely
+		set when reading internal PCS registers. MDIO reads to
+		internal PCS registers may result in having the
+		MDIO_CFG[MDIO_RD_ER] bit set, even when there is no error and
+		read data (MDIO_DATA[MDIO_DATA]) is correct.
+		Software may get false read error when reading internal
+		PCS registers through MDIO. As a workaround, all internal
+		MDIO accesses should ignore the MDIO_CFG[MDIO_RD_ER] bit.
+
 For internal PHY device on internal mdio bus, a PHY node should be created.
 See the definition of the PHY node in booting-without-of.txt for an
 example of how to define a PHY (Internal PHY has no interrupt line).
-- 
2.1.0

