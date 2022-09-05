Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C745ADC16
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 01:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbiIEX5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 19:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbiIEX5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 19:57:05 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75BB62AA3;
        Mon,  5 Sep 2022 16:57:00 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o4so9576190pjp.4;
        Mon, 05 Sep 2022 16:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=jfgoG65m8y92e/I+R1FFZjCqYowE45KYPw1MG3KYwPc=;
        b=CYxNR3IMSrHOPWsxZDepJUS65bRt7H6VcpeRt6MM10aBzWg18CnbBImh4Yyi9KLWw8
         TCcKEKkFMN+ZT8bfJ1xJ7lOYzEM10+4b0CtDytAZ6kI6X7zpYchrxlos4bEG3pUIN3IJ
         QFW1ERQC+oOoGlwAZVoByqoM72Vc8EnTN0xwkARrR6/0+U9GudrnHmj9wEwXiO7nUH7N
         s6k9XUHi1UPZBVqjSRcUqeGs/bZvK8doV1RXnUn9P1Hs2RYa8p6ZtPptwK8w2cL9HsJp
         WGAiarK3Y8av7ozoIkdBB2xHK3L+sRVsNwYqPkVely/kzpWstBARDbYEGBPuag7QbyhD
         MXFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=jfgoG65m8y92e/I+R1FFZjCqYowE45KYPw1MG3KYwPc=;
        b=j+84+GdLMo1q8ebRDuo1cc3WYj2drIioZFFXLmTSY7/N0LTjWJzG6GKtlR9tgvOZwT
         /moSn2W/bF0g1fnt54P4g3edA4B5xqP1tDaFzes/cJtxN9X3Fn0b6RH8A7qgS/Q4J1b1
         rNeXMR4dhQkqy5G4V5lQXya6O9bWLyDTAYBZgGQV5DL2Ko1z/KvtQj9Nu35hJkim7Y6t
         Xd3F/Y4miJp8bOhbQ2rBWYKcovcrFDlhq9DOThJFjAQZZhzuaF0AlTSMuBQscURo3IFe
         c01IowKwDJpkdHPEa+eqUcUmTO9Ie7NFjtJkoIiwLDF/CY615tyTfGlO91oWgB+kmEAu
         woIQ==
X-Gm-Message-State: ACgBeo31yKOdsT6lQSnbD/qRRr2sC4A5ZRcOUe9hS5HrP+4rbRp5ALi2
        p8VifthH8vWnC+9UHhkBGkg=
X-Google-Smtp-Source: AA6agR5GLHFYb6BNlPh/lb13Sdr8yCGnsYNTWWtx0r29gyDFpyv1zsHWc/cDmHgS4l3hGgJz5T39yg==
X-Received: by 2002:a17:90b:1804:b0:1fb:141:a09d with SMTP id lw4-20020a17090b180400b001fb0141a09dmr21524677pjb.170.1662422219891;
        Mon, 05 Sep 2022 16:56:59 -0700 (PDT)
Received: from localhost.localdomain ([76.132.249.1])
        by smtp.gmail.com with ESMTPSA id g26-20020aa79dda000000b00537f13d217bsm8405530pfq.76.2022.09.05.16.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 16:56:59 -0700 (PDT)
From:   rentao.bupt@gmail.com
To:     "David S . Miller" <davem@davemloft.net>,
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
Subject: [PATCH net-next 2/2] ARM: dts: aspeed: elbert: Enable mac3 controller
Date:   Mon,  5 Sep 2022 16:56:34 -0700
Message-Id: <20220905235634.20957-3-rentao.bupt@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220905235634.20957-1-rentao.bupt@gmail.com>
References: <20220905235634.20957-1-rentao.bupt@gmail.com>
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
onboard switch directly (fixed link).

Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
---
 arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts b/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
index 27b43fe099f1..52cb617783ac 100644
--- a/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
@@ -183,3 +183,14 @@ imux31: i2c@7 {
 &i2c11 {
 	status = "okay";
 };
+
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
2.30.2

