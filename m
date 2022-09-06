Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3605ADFAF
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 08:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238210AbiIFGU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 02:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238085AbiIFGUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 02:20:50 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BC52B636;
        Mon,  5 Sep 2022 23:20:43 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t11-20020a17090a510b00b001fac77e9d1fso13878220pjh.5;
        Mon, 05 Sep 2022 23:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=3Kvr9t8tl1/ms0/7xPHpz9WdqpLe/wgSflXORB7TJd0=;
        b=Fl4hRRFl5sMh4BN5/k16jkd3sP6MTf3gaTHSBGMWQ6tlGQgGIVMGz1MsvoHYey997j
         ylt+tl6FiSGMSMJqweBQVHc+Yz/Q9wqhd8sEsdxcpFLFb9LpaaFDGMA8vFP56lbPLa2F
         Laho1GWqhs5jrLoFarET3QX1qzHALDUK6Q381LQalztW/EmeIvMHXyq/25oCKXPKQ2XI
         r9D0nzjt+BoRMTXh+TmeV84uOaPsh9wbvdyElKy28cVu+og91IwhZSdSPQSl+qVOAMLg
         gGgWcup79BJw06q4InpwI5cxsjSTlIBS4rysbxcjQaoXJcGb1hzce65Z9/ABgK58f3z0
         qojQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=3Kvr9t8tl1/ms0/7xPHpz9WdqpLe/wgSflXORB7TJd0=;
        b=R/Zur/1ww4hZg/AgZtZeXZ4QPZI/P+wkhiVrUotQWAaGtWXTYdzoNcewN9K//fp2s2
         1yL6X4flf4uQgWqKHWWEdqJ6sVhsKSBjbMAJifDK/OTy/4bzDaTjTP9yuubTSiyisddK
         bd9XQ9R+rJiBJ+FZsQ1M2b/E6LJvGV89CyDBLg2v3m+fXBXNS0Qm/rmygFqgYfppIWJq
         JS5H3wlMox12MjfY3tJ/1I0bdQMoksJXv5MVk77Qo/DdwzAOpOUB/oWcM94Svt+SS80X
         P85CvKlTz1iC8ockD8+iniORUrDSxZFJ9B1f7Trtyc/uhKehMZCl5GTOmUnZorYpAlpA
         4bmA==
X-Gm-Message-State: ACgBeo0Oz+opdlEoHar0Cg+ywFvzQMvOeqEnQd0dVek0UwujnYIFJ9ra
        wJodI4LSdOswpZE3AtvPZeM=
X-Google-Smtp-Source: AA6agR6mgN6a8EMCkb2sUzh84tuyTkJRzb3cEOqOWShLqubfN42tc50cBynnYgKnWZ78FPXvtqlsow==
X-Received: by 2002:a17:902:ab98:b0:172:a566:d462 with SMTP id f24-20020a170902ab9800b00172a566d462mr51817770plr.53.1662445243373;
        Mon, 05 Sep 2022 23:20:43 -0700 (PDT)
Received: from localhost.localdomain ([76.132.249.1])
        by smtp.gmail.com with ESMTPSA id m16-20020a170902db1000b00172dd10f64fsm8877798plx.263.2022.09.05.23.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 23:20:42 -0700 (PDT)
From:   rentao.bupt@gmail.com
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heyi Guo <guoheyi@linux.alibaba.com>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Liang He <windhl@126.com>, Hao Chen <chenhao288@hisilicon.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, Tao Ren <taoren@fb.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc:     Tao Ren <rentao.bupt@gmail.com>
Subject: [PATCH net-next v2 2/2] ARM: dts: aspeed: elbert: Enable mac3 controller
Date:   Mon,  5 Sep 2022 23:20:26 -0700
Message-Id: <20220906062026.57169-3-rentao.bupt@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906062026.57169-1-rentao.bupt@gmail.com>
References: <20220906062026.57169-1-rentao.bupt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tao Ren <rentao.bupt@gmail.com>

Enable mac3 controller in Elbert dts: Elbert MAC3 is connected to the
BCM53134P onboard switch's IMP_RGMII port directly (fixed link, no PHY
between BMC MAC and BCM53134P).

Note: BMC's mdio0 controller is connected to BCM53134P's MDIO interface
for debugging purposes only: BCM53134P always loads configurations from
its EEPROM, and users should not configure the switch via the MDIO
interface. As a result, the MDIO connection is disabled in dts.

Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
---
 Changes in v2:
  - updated comments and patch description.

 .../boot/dts/aspeed-bmc-facebook-elbert.dts   | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts b/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
index 27b43fe099f1..36657d8fdb73 100644
--- a/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
@@ -183,3 +183,23 @@ imux31: i2c@7 {
 &i2c11 {
 	status = "okay";
 };
+
+/*
+ * BMC's "mac3" is connected to BCM53134P's IMP_RGMII port directly (no
+ * PHY in between).
+ * Although BMC's "mdio0" controller is connected to BCM53134P's MDIO
+ * interface, it's only for debugging purposes: BCM53134P always loads
+ * configurations from its EEPROM, and users should not configure the
+ * switch through MDIO interface in regular operations. As a result,
+ * the MDIO connection is disabled in dts.
+ */
+&mac3 {
+	status = "okay";
+	phy-mode = "rgmii";
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_rgmii4_default>;
+	fixed-link {
+		speed = <1000>;
+		full-duplex;
+	};
+};
-- 
2.37.3

