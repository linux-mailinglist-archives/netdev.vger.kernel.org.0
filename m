Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8924DC284
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 10:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiCQJWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 05:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiCQJWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 05:22:36 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06D7340D3
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:21:19 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gb19so4376811pjb.1
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=00f+kRqIByvWTuoSfawk8+MFKoCBfn6Hxvgo5w11mT4=;
        b=DU+Xf+EGgdElVWDUA0yjAZFpXDdhGuPFQ7j5AV4gCkZeHUqjXWHhm9Fw8gJjeNv7yO
         Kw+HPLHH5x+Fiovlb+6p/dJdqMALIGnko2pNgPrqjhSm0IfL/Gw32HAzi+GJrtCSB4TE
         YP8dpdPdQ2m9fAmFLpRc/v936AH00+YbE4E7aTlRLx+NAvIkcSn7OaSLhqFTKZT/nmoN
         nkYllwjl5+sHo6HgWPh5SjvbyJ4WGA9TnFhxHVCUnxhHjRpdmEjNeA+ocz8o29EyKzsp
         V/BNgskPZRt7M5twtV90zxMhlMJKc+fXmRDbsTAVv8kMPxzF4whQp20XD/JO2lrR/zOS
         /DzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=00f+kRqIByvWTuoSfawk8+MFKoCBfn6Hxvgo5w11mT4=;
        b=A9Nq9oCyNc9kgjRczc/jd9nWiFHM5nrdbsPReGKFPC8hCkKrN/DTiHeiGkFltsXU8C
         D5usw8bACI9rxxFYjakQfs07+giNs9FHLh+7VVGaoZ878yGbng9Lw5vv3XYKVWeRjP32
         eyD04hzI/lL53uiJoOQqzv9PIL0SIpXnzs9aUQ+HIiN++DndQAo9mVrpy8OIqFe6vED9
         fdVcEI0pJZuOzt7Z62iqDKt97YV6JFI+J/Dtl/NigFLzVY3BE6Dm3dyKyaPY+n43PXZi
         EKhUmpc54J8D84B9RxAww4VK3PBpz528x7ENkYBwSgN4kbdJT+bbe5OHpQ1lewZPJAZj
         2Kpw==
X-Gm-Message-State: AOAM530bu9BWt1+0HRyNnzNukg8WEp3QBn2dCkKCrxlADXlBikoqBSTg
        JrMpzL+/zA+IEl6gHmSETaveXw==
X-Google-Smtp-Source: ABdhPJwmYksWZBSHUGtcqtQOeQnfwX3VEqnqKkZvYqw3GjwRv5P472XI1XsLEuxMcMLRAjZwDapwew==
X-Received: by 2002:a17:90a:17ab:b0:1bf:9519:fe86 with SMTP id q40-20020a17090a17ab00b001bf9519fe86mr14837606pja.25.1647508879412;
        Thu, 17 Mar 2022 02:21:19 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id x9-20020a056a00188900b004f7454e4f53sm6309056pfh.37.2022.03.17.02.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 02:21:19 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        linux@armlinux.org.uk, robert.hancock@calian.com, andrew@lunn.ch,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>
Subject: [PATCH v2 1/2] dt-bindings: net: xilinx_axienet: add pcs-handle attribute
Date:   Thu, 17 Mar 2022 17:19:25 +0800
Message-Id: <20220317091926.86765-1-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the new pcs-handle attribute to support connecting to an
external PHY in SGMII or 1000Base-X modes through the internal PCS/PMA
PHY.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
---
 Documentation/devicetree/bindings/net/xilinx_axienet.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
index b8e4894bc634..2a9a3a90eb63 100644
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
+++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
@@ -68,6 +68,11 @@ Optional properties:
 		  required through the core's MDIO interface (i.e. always,
 		  unless the PHY is accessed through a different bus).
 
+ - pcs-handle: 	  Phandle to the internal PCS/PMA PHY, if a fixed external PHY
+		  is tied to it in SGMII or 1000Base-X modes. This is not
+		  required for SFP connection. The driver would use phy-handle
+		  to reference the PCS/PMA PHY in such case.
+
 Example:
 	axi_ethernet_eth: ethernet@40c00000 {
 		compatible = "xlnx,axi-ethernet-1.00.a";
-- 
2.34.1

