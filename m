Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9E1575CFF
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 10:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiGOIGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 04:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiGOIGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 04:06:47 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F4D7E00E;
        Fri, 15 Jul 2022 01:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1657872406; x=1689408406;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9HdCXT2PbQm9vJbMtpRbCdAbxy2aAViPdQXhEIRSHxk=;
  b=alz/3Kb5xoPoH5N9Fgk2RyWFTpjAa3oLCidhuAvdnQEy5GlCFTGTfYBV
   GZuH307hWQSqu6BNwyIT74fduxvrbYJrXnF5e8Fn3JdBEWWOw0izoaD3B
   GqPrOUg0GU6hfoLhWaNHqxjqpdAlADurxNfownpMHWmxQT+SjQ01V5cJ0
   LdZoDYQqI6lsHWINRbHLr3P54cm0RHhVB+KoWw4ZaXV9GIXzhxxMyCZtY
   jIfVO7O4Q6hVw+ncsdHEjMQT3YrCINlKq42Tp6fV+MgFSWd/yJqYxpix1
   1R4M+MfuM1S0ddoLHzq9AzBOFLhV5q+WsU6Hor6CT7MSYggL9azUe8FiY
   g==;
X-IronPort-AV: E=Sophos;i="5.92,273,1650924000"; 
   d="scan'208";a="25069691"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 15 Jul 2022 10:06:43 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Fri, 15 Jul 2022 10:06:43 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Fri, 15 Jul 2022 10:06:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1657872403; x=1689408403;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9HdCXT2PbQm9vJbMtpRbCdAbxy2aAViPdQXhEIRSHxk=;
  b=QYuIPz+2sw4PM+1bC9afVbEMHRqIMOflCKTNVcl9nl0iNb/bWR3/SZ/s
   oGu2L4tpSvb0vni6pKMZTvwSH6UQ3GAfj9P1TKH6f3KE8oagS21BBGvE2
   v4cGD5J/srDBkI70VLdQHB5S2PBU0Vkw4uaK475Ivu1Oif/uFU+cSR2Uq
   5v5JTbTa4SaVYsJtM94JT/WNlePKb+AbOwOQteVzYhfXbFEdns/gBp89q
   cu3WszE6uP4oxD+FD7o8dK+ZymQUyE5qT8bnNRnslqGV89VJRftHKyvqg
   uCamD3MLKp8uaskAF+RC10rex373ndOiV3HW4EzFHMO5DXM43xUzLsYd/
   g==;
X-IronPort-AV: E=Sophos;i="5.92,273,1650924000"; 
   d="scan'208";a="25069690"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 15 Jul 2022 10:06:43 +0200
Received: from steina-w.tq-net.de (unknown [10.123.49.12])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 8CFD2280056;
        Fri, 15 Jul 2022 10:06:43 +0200 (CEST)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v2 1/1] dt-bindings: net: fsl,fec: Add nvmem-cells / nvmem-cell-names properties
Date:   Fri, 15 Jul 2022 10:06:40 +0200
Message-Id: <20220715080640.881316-1-alexander.stein@ew.tq-group.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These properties are inherited from ethernet-controller.yaml.
This fixes the dt_binding_check warning:
imx8mm-tqma8mqml-mba8mx.dt.yaml: ethernet@30be0000: 'nvmem-cell-names',
'nvmem-cells' do not match any of the regexes: 'pinctrl-[0-9]+'

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
---
Changes in v2:
* Add amount and names of nvmem-cells (copied from ethernet-controller.yaml)

 Documentation/devicetree/bindings/net/fsl,fec.yaml | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index daa2f79a294f..b5b55dca08cb 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -121,6 +121,14 @@ properties:
 
   mac-address: true
 
+  nvmem-cells:
+    maxItems: 1
+    description:
+      Reference to an nvmem node for the MAC address
+
+  nvmem-cell-names:
+    const: mac-address
+
   tx-internal-delay-ps:
     enum: [0, 2000]
 
-- 
2.25.1

