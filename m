Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF08B5AFBE4
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 07:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiIGFpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 01:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiIGFpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 01:45:13 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AAC371BB;
        Tue,  6 Sep 2022 22:45:05 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id z187so13528318pfb.12;
        Tue, 06 Sep 2022 22:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=MxUjkhck3ThCup5JU1rYOQtyKBWOrj1qhayfFTMHy24=;
        b=n294xEYj18Ngb737eeY0NWR2FiB5hbvUei2t+J5yesyN4dPpRgCcQI5xcIi4MC/r/h
         6+jt4NOnvd3xqc+iQiy/4rDKGUgcvcmOEZP/ukuUUzrQX2hr7ku5EJBu6RXANfcTBX3v
         Hm1auCTam2QnlOGmN//E2ZN2f3Kr66eZQ55KRHqkH8eAuNJOTPE7SMDFGF5z4ba2PX9j
         7wwCLpIbO+HRSLCOLVeHMLgPipKfQDZm75lqTBK0ZFnMsKsvIqkwZgASvLhe+ReAIsSF
         PNy9j4zmR33ajjcv0h5ZntfKQARz1NDjXaZq+A0VJ7QxSRz3c2Ecv9RVBIKU6oBpcw3Z
         cdlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=MxUjkhck3ThCup5JU1rYOQtyKBWOrj1qhayfFTMHy24=;
        b=qde9e1f6BRCoQaF633bkFWJ8faLe8ahxzfPthSHYYepqHXwV9+CHsNJjz7V4wq4oiF
         9idtDE0CzmzuP3VJFjnRcPD/obG4jsl1S7yK5XygNhjt7GxJpBN8fhot2a6pQG0NAcuP
         N1li8oCmMSLvX9+rmk83l80WsPgatHNVfBNH+6PAgCaUk/NJKaiy/1HWMK3TP32EYphe
         Yc1Dkhr07BpelP1Rokl8oNW18xATtEyqw5B+NosAkjamfnxjeqwtV5SyG5bWVNkqEON8
         bX89TMaPPqFnpsBqk+5hQnlCrYpkJq9lINk0VhEYXqkmGXEukkF0HqI8kFVZMSsSTihb
         yNaQ==
X-Gm-Message-State: ACgBeo3iBp96oC4sU4pCb/n7vx7/gNll0O3Y3DiE3tw8sEisz/sArAQS
        2AwaR7DFIvsCXR2HVhS3TUU=
X-Google-Smtp-Source: AA6agR7kbaoNt6zjIBweSiPmfp6LIaSt/m1OzJ7rtVUYJf/gIBW1VZ07ewfRKxRgezbUZstg0VLgJg==
X-Received: by 2002:a05:6a00:4c85:b0:538:5500:4873 with SMTP id eb5-20020a056a004c8500b0053855004873mr2265813pfb.81.1662529504723;
        Tue, 06 Sep 2022 22:45:04 -0700 (PDT)
Received: from localhost.localdomain ([76.132.249.1])
        by smtp.gmail.com with ESMTPSA id b2-20020a170902d50200b0016c0c82e85csm11222798plg.75.2022.09.06.22.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 22:45:04 -0700 (PDT)
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
Subject: [PATCH net-next v3 2/2] ARM: dts: aspeed: elbert: Enable mac3 controller
Date:   Tue,  6 Sep 2022 22:44:53 -0700
Message-Id: <20220907054453.20016-3-rentao.bupt@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220907054453.20016-1-rentao.bupt@gmail.com>
References: <20220907054453.20016-1-rentao.bupt@gmail.com>
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

Note: BMC's mdio0 controller is connected to BCM53134P's MDIO interface,
and the MDIO channel will be enabled later, when BCM53134 is added to
"bcm53xx" DSA driver.

Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
---
 Changes in v3:
  - updated comments and patch description.
 Changes in v2:
  - updated comments and patch description.
 .../boot/dts/aspeed-bmc-facebook-elbert.dts    | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts b/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
index 27b43fe099f1..8e1a1d1b282d 100644
--- a/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
@@ -183,3 +183,21 @@ imux31: i2c@7 {
 &i2c11 {
 	status = "okay";
 };
+
+/*
+ * BMC's "mac3" controller is connected to BCM53134P's IMP_RGMII port
+ * directly (fixed link, no PHY in between).
+ * Note: BMC's "mdio0" controller is connected to BCM53134P's MDIO
+ * interface, and the MDIO channel will be enabled in dts later, when
+ * BCM53134 is added to "bcm53xx" DSA driver.
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

