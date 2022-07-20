Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4266357B12D
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 08:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiGTGjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 02:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiGTGjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 02:39:31 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF85402F4;
        Tue, 19 Jul 2022 23:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1658299170; x=1689835170;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=I6SdapWfhcN5YzSovhTu3AGuzmo8W2cQvh1AYyIQ9cQ=;
  b=eXSCg4XOgci4SJ/gt0u0FTcP4d67/B58zaF3EjOU9uY+VeqQKwbQ9VdN
   nVYs27JxUnfZOSP1QrtPwNJVG0sw2W6BLwdIeKeAHycaoV53Ye3FahmZQ
   xu+HLlX6NijbrieRdZw2rpnc0UHrKQgjR/5NkcFqNNZ9c2X49QGEX3H7R
   7J2pMeio351Ocbr99wKWpP5VWxXitweW+k6HtQ/kRJz4O7E9KYbkO1kBR
   oRcNmt9LXZL/dxGb6go19mNSdNjOkyONX7ka5DSn5kTgk5mU0IXuZqMRm
   r3DJqfSLsjnYp6bf0AK7+1a021FzQ1FLUo0+sWKiDC6M0oT45rWZ+qpn1
   w==;
X-IronPort-AV: E=Sophos;i="5.92,286,1650924000"; 
   d="scan'208";a="25147499"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 20 Jul 2022 08:39:28 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Wed, 20 Jul 2022 08:39:28 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Wed, 20 Jul 2022 08:39:28 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1658299168; x=1689835168;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=I6SdapWfhcN5YzSovhTu3AGuzmo8W2cQvh1AYyIQ9cQ=;
  b=q+fQEiXHeB4zqVXP6cXjTux/RAidBx5pkbTHIordvKQtNb6y4jxsA3YN
   XBzEIgd2jSSShpCwJiUhZN/dUhW83Ku3LBJ6PtwMhpLKYOYh1XQHFnWVu
   T5q3Ltk5WBdLFU8PEhi+UWAV/jNR1O+eTAgyK4oC3/XQfvhT3bQ2cQrF6
   qH5bfHsn9yHgy+0P7sYnm8A+wKU5lONCwp98aVjo7rfBMhk25/6a0r3EL
   tGl4/QRz0NwwvMuR18kME+cDXmvX+Fa/4jmyeDBx2qihYiYJ0chW9gP4X
   Ma5DVZNYTmkC3x0MfUIhahwyOd1qB1H3UlfSmi7gAjAET+05Yaxcf4r/W
   g==;
X-IronPort-AV: E=Sophos;i="5.92,286,1650924000"; 
   d="scan'208";a="25147498"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 20 Jul 2022 08:39:28 +0200
Received: from steina-w.tq-net.de (unknown [10.123.49.12])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 17865280056;
        Wed, 20 Jul 2022 08:39:28 +0200 (CEST)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v3 1/1] dt-bindings: net: fsl,fec: Add nvmem-cells / nvmem-cell-names properties
Date:   Wed, 20 Jul 2022 08:39:24 +0200
Message-Id: <20220720063924.1412799-1-alexander.stein@ew.tq-group.com>
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
Changes in v3:
* Use nvmem-cells/nvmem-cell-names properties from ethernet-controller.yaml
* Set unevaluatedProperties instead of additionalProperties

Changes in v2:
* Add amount and names of nvmem-cells (copied from ethernet-controller.yaml)

 Documentation/devicetree/bindings/net/fsl,fec.yaml | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index daa2f79a294f..85a8d8fb6b8f 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -121,6 +121,10 @@ properties:
 
   mac-address: true
 
+  nvmem-cells: true
+
+  nvmem-cell-names: true
+
   tx-internal-delay-ps:
     enum: [0, 2000]
 
@@ -213,7 +217,7 @@ required:
 # least undocumented properties. However, PHY may have a deprecated option to
 # place PHY OF properties in the MAC node, such as Micrel PHY, and we can find
 # these boards which is based on i.MX6QDL.
-additionalProperties: false
+unevaluatedProperties: false
 
 examples:
   - |
-- 
2.25.1

